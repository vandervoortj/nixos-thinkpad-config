{ config, pkgs, ... }:

{
  imports =
    [ 
      ./hardware-configuration.nix
    ];

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot/EFI";
      };
    };
    plymouth.enable = true;
  };

  networking = {
    hostName = "sharon-thinkpad";
    networkmanager.enable = true;
  };

  time.timeZone = "America/Toronto";

  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    useXkbConfig = true;
  };

  services = {
    avahi = {
      enable = true;
      nssmdns = true;
    };
    xserver = {
      enable = true;
      excludePackages = [ pkgs.xterm ];
      layout = "us";
      libinput.enable = true;
      displayManager = {
        gdm = {
          enable = true;
          autoSuspend = true;
        };
        autoLogin = {
          enable = true;
          user = "sharon";
        };
      };
      desktopManager.gnome.enable = true;
    };
    printing.enable = true;
    dnsmasq.enable = true;
    openssh.enable = true;
    gnome = {
      chrome-gnome-shell.enable = true;
      gnome-keyring.enable = true;
      gnome-settings-daemon.enable = true;
    };
  };

  sound.enable = true;

  hardware = {
    pulseaudio.enable = true;
  };

  zramSwap = {
    enable = true;
    memoryPercent = 25;
  };

  users = {
    defaultUserShell = pkgs.fish;
    users.jom = {
      isNormalUser = true;
      extraGroups = [ "wheel" ]; 
      packages = with pkgs; [
        chromium
      ];
    };
    users.sharon = {
      isNormalUser = true;
    };  
  };

  environment = {
    shells = [ pkgs.fish ];
    gnome.excludePackages = [ pkgs.gnome-tour ];
    systemPackages = with pkgs; [
      wget
    ];
  };

  programs = {
    mtr.enable = true;
    fish.enable = true;
    neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
      defaultEditor = true;
      configure = {
        customRC = ''
          set undofile
          set undodir=~/.vim/undodir
        '';
        packages.nix.start = with pkgs.vimPlugins; [ 
          vim-nix 
          coc-nvim
          coc-highlight
          rainbow
        ];
      };
    };
    starship = {
      enable = true;
      settings = {
        "add_newline" = false;
        "format" = "$all";
        "scan_timeout" = 30;
        "username" = {
          "format" = "[$user]($style)";
          "style_user" = "bold green";
          "show_always" = true;
          "style_root" = "bold red";
        };
      };
    };
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };

  nixpkgs.config.allowUnfree = true;

  nix = {
    gc = {
      automatic = true;
      options = "--delete-older-than 7d";
      dates = "weekly";
    };
    optimise = {
      automatic = true;
      dates = [ "weekly" ];
    };
  };

  system = {
    stateVersion = "22.05";
    autoUpgrade = {
      enable = true;
      channel = "nixos-22.05";
      persistent = true;
      allowReboot = true;
    };
  };
}

