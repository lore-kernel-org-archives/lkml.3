Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756537Ab3K1UI4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 15:08:56 -0500
Received: from ares07.inai.de ([5.9.24.206]:38418 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753717Ab3K1UIu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 15:08:50 -0500
Date: Thu, 28 Nov 2013 21:08:45 +0100 (CET)
From: Jan Engelhardt <jengelh@inai.de>
To: Chris Wilson <chris@chris-wilson.co.uk>
cc: daniel.vetter@ffwll.ch, dri-devel@lists.freedesktop.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: i915: pipe state still does not match
In-Reply-To: <20131127110836.GA6087@nuc-i3427.alporthouse.com>
Message-ID: <alpine.LSU.2.11.1311282017400.4098@nerf07.vanv.qr>
References: <alpine.LSU.2.11.1311271156060.20996@nerf07.vanv.qr> <20131127110836.GA6087@nuc-i3427.alporthouse.com>
User-Agent: Alpine 2.11 (LSU 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 2013-11-27 12:08, Chris Wilson wrote:
>On Wed, Nov 27, 2013 at 11:59:56AM +0100, Jan Engelhardt wrote:
>> 
>> Despite the i915/drm fixes added in v3.11.8, the X server still 
>> terminates due to some pipe state bug in 3.11.9.
>
>X terminating is entirely unconnected with that *ERROR*.

Are you sure? Whenever X crashed, that inteldrv kernel message
was showing up in dmesg.
Affected versions:
	xorg-x11-server-1.14.3.901
	xf86-video-intel-2.99.906-4.1.x86_64
Working versions:
	xorg-x11-server-1.13.2
	xf86-video-intel-2.20.19

>Can you please attach your Xorg.0.log with the crash information?

What I could collect so far:


[    47.331] 
This is a pre-release version of the X server from The X.Org Foundation.
It is not supported in any way.
Bugs may be filed in the bugzilla at http://bugs.freedesktop.org/.
Select the "xorg" product for bugs you find in this release.
Before reporting bugs in pre-release versions please check the
latest version in the X.Org Foundation git repository.
See http://wiki.x.org/wiki/GitPage for git access instructions.
[    47.331] 
X.Org X Server 1.14.3.901 (1.14.4 RC 1)
Release Date: 2013-10-26
[    47.331] X Protocol Version 11, Revision 0
[    47.331] Build Operating System: openSUSE SUSE LINUX
[    47.331] Current Operating System: Linux nakamura.inai.de 3.11.9-jng20-desktop #1 SMP PREEMPT Wed Nov 27 09:56:23 UTC 2013 (a089a7e) x86_64
[    47.331] Kernel command line: root=/dev/disk/by-label/nakamura-root splash=silent showopts video=640x480
[    47.332] Build Date: 06 November 2013  10:07:38AM
[    47.332]  
[    47.332] Current version of pixman: 0.30.2
[    47.332] 	Before reporting problems, check http://wiki.x.org
	to make sure that you have the latest version.
[    47.332] Markers: (--) probed, (**) from config file, (==) default setting,
	(++) from command line, (!!) notice, (II) informational,
	(WW) warning, (EE) error, (NI) not implemented, (??) unknown.
[    47.333] (==) Log file: "/var/log/Xorg.0.log", Time: Thu Nov 28 20:15:00 2013
[    47.335] (==) Using config directory: "/etc/X11/xorg.conf.d"
[    47.335] (==) Using system config directory "/usr/share/X11/xorg.conf.d"
[    47.378] (==) No Layout section.  Using the first Screen section.
[    47.379] (==) No screen section available. Using defaults.
[    47.379] (**) |-->Screen "Default Screen Section" (0)
[    47.379] (**) |   |-->Monitor "<default monitor>"
[    47.395] (==) No monitor specified for screen "Default Screen Section".
	Using a default monitor configuration.
[    47.395] (==) Automatically adding devices
[    47.395] (==) Automatically enabling devices
[    47.395] (==) Automatically adding GPU devices
[    47.396] (WW) The directory "/usr/share/fonts/misc/sgi" does not exist.
[    47.396] 	Entry deleted from font path.
[    47.396] (==) FontPath set to:
	/usr/share/fonts/misc:unscaled,
	/usr/share/fonts/Type1/,
	/usr/share/fonts/100dpi:unscaled,
	/usr/share/fonts/75dpi:unscaled,
	/usr/share/fonts/ghostscript/,
	/usr/share/fonts/cyrillic:unscaled,
	/usr/share/fonts/truetype/,
	built-ins
[    47.396] (==) ModulePath set to "/usr/lib64/xorg/modules/updates,/usr/lib64/xorg/modules"
[    47.396] (II) The server relies on udev to provide the list of input devices.
	If no devices become available, reconfigure udev or disable AutoAddDevices.
[    47.411] (II) Loader magic: 0x803c20
[    47.411] (II) Module ABI versions:
[    47.411] 	X.Org ANSI C Emulation: 0.4
[    47.411] 	X.Org Video Driver: 14.1
[    47.411] 	X.Org XInput driver : 19.1
[    47.411] 	X.Org Server Extension : 7.0
[    47.412] (II) xfree86: Adding drm device (/dev/dri/card0)
[    47.416] (--) PCI:*(0:0:2:0) 8086:a011:104d:9075 rev 0, Mem @ 0xfea80000/524288, 0xe0000000/268435456, 0xfe800000/1048576, I/O @ 0x0000f0f0/8
[    47.417] (--) PCI: (0:0:2:1) 8086:a012:104d:9075 rev 0, Mem @ 0xfea00000/524288
[    47.418] Initializing built-in extension Generic Event Extension
[    47.419] Initializing built-in extension SHAPE
[    47.419] Initializing built-in extension MIT-SHM
[    47.419] Initializing built-in extension XInputExtension
[    47.419] Initializing built-in extension XTEST
[    47.419] Initializing built-in extension BIG-REQUESTS
[    47.419] Initializing built-in extension SYNC
[    47.419] Initializing built-in extension XKEYBOARD
[    47.419] Initializing built-in extension XC-MISC
[    47.419] Initializing built-in extension SECURITY
[    47.419] Initializing built-in extension XINERAMA
[    47.419] Initializing built-in extension XFIXES
[    47.420] Initializing built-in extension RENDER
[    47.420] Initializing built-in extension RANDR
[    47.420] Initializing built-in extension COMPOSITE
[    47.420] Initializing built-in extension DAMAGE
[    47.420] Initializing built-in extension MIT-SCREEN-SAVER
[    47.420] Initializing built-in extension DOUBLE-BUFFER
[    47.420] Initializing built-in extension RECORD
[    47.420] Initializing built-in extension DPMS
[    47.420] Initializing built-in extension X-Resource
[    47.420] Initializing built-in extension XVideo
[    47.420] Initializing built-in extension XVideo-MotionCompensation
[    47.421] Initializing built-in extension XFree86-VidModeExtension
[    47.421] Initializing built-in extension XFree86-DGA
[    47.421] Initializing built-in extension XFree86-DRI
[    47.421] Initializing built-in extension DRI2
[    47.421] (II) "glx" will be loaded by default.
[    47.421] (II) LoadModule: "dri2"
[    47.421] (II) Module "dri2" already built-in
[    47.421] (II) LoadModule: "glamoregl"
[    47.437] (II) Loading /usr/lib64/xorg/modules/libglamoregl.so
[    47.529] (II) Module glamoregl: vendor="X.Org Foundation"
[    47.529] 	compiled for 1.14.3, module version = 0.5.1
[    47.529] 	ABI class: X.Org ANSI C Emulation, version 0.4
[    47.529] (II) LoadModule: "glx"
[    47.531] (II) Loading /usr/lib64/xorg/modules/extensions/libglx.so
[    47.569] (II) Module glx: vendor="X.Org Foundation"
[    47.570] 	compiled for 1.14.3.901, module version = 1.0.0
[    47.570] 	ABI class: X.Org Server Extension, version 7.0
[    47.570] (==) AIGLX enabled
[    47.571] Loading extension GLX
[    47.571] (==) Matched intel as autoconfigured driver 0
[    47.571] (==) Matched intel as autoconfigured driver 1
[    47.571] (==) Matched modesetting as autoconfigured driver 2
[    47.571] (==) Matched fbdev as autoconfigured driver 3
[    47.571] (==) Matched vesa as autoconfigured driver 4
[    47.571] (==) Assigned the driver to the xf86ConfigLayout
[    47.571] (II) LoadModule: "intel"
[    47.576] (II) Loading /usr/lib64/xorg/modules/drivers/intel_drv.so
[    47.635] (II) Module intel: vendor="X.Org Foundation"
[    47.635] 	compiled for 1.14.3.901, module version = 2.99.906
[    47.635] 	Module class: X.Org Video Driver
[    47.635] 	ABI class: X.Org Video Driver, version 14.1
[    47.635] (II) LoadModule: "modesetting"
[    47.638] (WW) Warning, couldn't open module modesetting
[    47.638] (II) UnloadModule: "modesetting"
[    47.638] (II) Unloading modesetting
[    47.638] (EE) Failed to load module "modesetting" (module does not exist, 0)
[    47.639] (II) LoadModule: "fbdev"
[    47.640] (II) Loading /usr/lib64/xorg/modules/drivers/fbdev_drv.so
[    47.647] (II) Module fbdev: vendor="X.Org Foundation"
[    47.647] 	compiled for 1.14.3, module version = 0.4.3
[    47.647] 	Module class: X.Org Video Driver
[    47.647] 	ABI class: X.Org Video Driver, version 14.1
[    47.647] (II) LoadModule: "vesa"
[    47.648] (II) Loading /usr/lib64/xorg/modules/drivers/vesa_drv.so
[    47.654] (II) Module vesa: vendor="X.Org Foundation"
[    47.654] 	compiled for 1.14.3, module version = 2.3.3
[    47.654] 	Module class: X.Org Video Driver
[    47.654] 	ABI class: X.Org Video Driver, version 14.1
[    47.654] (II) intel: Driver for Intel(R) Integrated Graphics Chipsets:
	i810, i810-dc100, i810e, i815, i830M, 845G, 854, 852GM/855GM, 865G,
	915G, E7221 (i915), 915GM, 945G, 945GM, 945GME, Pineview GM,
	Pineview G, 965G, G35, 965Q, 946GZ, 965GM, 965GME/GLE, G33, Q35, Q33,
	GM45, 4 Series, G45/G43, Q45/Q43, G41, B43, HD Graphics,
	HD Graphics 2000, HD Graphics 3000, HD Graphics 2500,
	HD Graphics 4000, HD Graphics P4000, HD Graphics 4600,
	HD Graphics 5000, HD Graphics P4600/P4700, Iris(TM) Graphics 5100,
	HD Graphics 4400, HD Graphics 4200, Iris(TM) Pro Graphics 5200
[    47.656] (II) FBDEV: driver for framebuffer: fbdev
[    47.657] (II) VESA: driver for VESA chipsets: vesa
[    47.657] (++) using VT number 7

[    47.677] (WW) Falling back to old probe method for fbdev
[    47.677] (II) Loading sub module "fbdevhw"
[    47.677] (II) LoadModule: "fbdevhw"
[    47.679] (II) Loading /usr/lib64/xorg/modules/libfbdevhw.so
[    47.693] (II) Module fbdevhw: vendor="X.Org Foundation"
[    47.693] 	compiled for 1.14.3.901, module version = 0.0.2
[    47.693] 	ABI class: X.Org Video Driver, version 14.1
[    47.693] (WW) Falling back to old probe method for vesa
[    47.711] (II) intel(0): Creating default Display subsection in Screen section
	"Default Screen Section" for depth/fbbpp 24/32
[    47.711] (==) intel(0): Depth 24, (--) framebuffer bpp 32
[    47.711] (==) intel(0): RGB weight 888
[    47.711] (==) intel(0): Default visual is TrueColor
[    47.711] (--) intel(0): Integrated Graphics Chipset: Intel(R) Pineview GM
[    47.713] (--) intel(0): CPU: x86-64, sse2, sse3, ssse3
[    47.713] (**) intel(0): Framebuffer tiled
[    47.713] (**) intel(0): Pixmaps tiled
[    47.713] (**) intel(0): "Tear free" disabled
[    47.713] (**) intel(0): Forcing per-crtc-pixmaps? no
[    47.713] (II) intel(0): Output LVDS1 has no monitor section
[    47.714] (--) intel(0): found backlight control interface acpi_video0 (type 'firmware')
[    47.714] (II) intel(0): Output VGA1 has no monitor section
[    47.714] (II) intel(0): Output VIRTUAL1 has no monitor section
[    47.715] (--) intel(0): Output LVDS1 using initial mode 640x480 on pipe 1
[    47.715] (--) intel(0): Output VGA1 using initial mode 640x480 on pipe 0
[    47.715] (==) intel(0): DPI set to (96, 96)
[    47.715] (II) Loading sub module "dri2"
[    47.715] (II) LoadModule: "dri2"
[    47.715] (II) Module "dri2" already built-in
[    47.716] (II) UnloadModule: "fbdev"
[    47.716] (II) Unloading fbdev
[    47.716] (II) UnloadSubModule: "fbdevhw"
[    47.716] (II) Unloading fbdevhw
[    47.716] (II) UnloadModule: "vesa"
[    47.717] (II) Unloading vesa
[    47.717] (==) Depth 24 pixmap format is 32 bpp
[    47.750] (II) intel(0): SNA initialized with Alviso (gen3) backend
[    47.750] (==) intel(0): Backing store disabled
[    47.750] (==) intel(0): Silken mouse enabled
[    47.750] (II) intel(0): HW Cursor enabled
[    47.750] (II) intel(0): RandR 1.2 enabled, ignore the following RandR disabled message.
[    47.753] (==) intel(0): DPMS enabled
[    47.775] (II) intel(0): [XvMC] i915_xvmc driver initialized.
[    47.775] (II) intel(0): [DRI2] Setup complete
[    47.775] (II) intel(0): [DRI2]   DRI driver: i915
[    47.775] (II) intel(0): direct rendering: DRI2 Enabled
[    47.775] (==) intel(0): hotplug detection: "enabled"
[    47.775] (--) RandR disabled
[    48.068] (II) AIGLX: enabled GLX_MESA_copy_sub_buffer
[    48.068] (II) AIGLX: enabled GLX_INTEL_swap_event
[    48.068] (II) AIGLX: enabled GLX_ARB_create_context
[    48.068] (II) AIGLX: enabled GLX_ARB_create_context_profile
[    48.068] (II) AIGLX: enabled GLX_EXT_create_context_es2_profile
[    48.068] (II) AIGLX: enabled GLX_SGI_swap_control and GLX_MESA_swap_control
[    48.068] (II) AIGLX: GLX_EXT_texture_from_pixmap backed by buffer objects
[    48.069] (II) AIGLX: Loaded and initialized i915
[    48.069] (II) GLX: Initialized DRI2 GL provider for screen 0
[    48.077] (II) intel(0): switch to mode 640x480@75.0 on pipe 0 using VGA1, position (0, 0), rotation normal
[    48.080] (II) intel(0): switch to mode 640x480@60.0 on pipe 1 using LVDS1, position (0, 0), rotation normal
[    48.088] (II) intel(0): Setting screen physical size to 169 x 127
[    48.285] (II) config/udev: Adding input device Power Button (/dev/input/event3)
[    48.285] (**) Power Button: Applying InputClass "evdev keyboard catchall"
[    48.285] (**) Power Button: Applying InputClass "evdev keyboard catchall"
[    48.285] (**) Power Button: Applying InputClass "LocalKeyboard"
[    48.285] (II) LoadModule: "evdev"
[    48.287] (II) Loading /usr/lib64/xorg/modules/input/evdev_drv.so
[    48.300] (II) Module evdev: vendor="X.Org Foundation"
[    48.300] 	compiled for 1.14.3, module version = 2.8.2
[    48.300] 	Module class: X.Org XInput Driver
[    48.300] 	ABI class: X.Org XInput driver, version 19.1
[    48.300] (II) Using input driver 'evdev' for 'Power Button'
[    48.300] (**) Power Button: always reports core events
[    48.300] (**) evdev: Power Button: Device: "/dev/input/event3"
[    48.300] (--) evdev: Power Button: Vendor 0 Product 0x1
[    48.300] (--) evdev: Power Button: Found keys
[    48.301] (II) evdev: Power Button: Configuring as keyboard
[    48.301] (**) Option "config_info" "udev:/sys/devices/LNXSYSTM:00/LNXPWRBN:00/input/input3/event3"
[    48.301] (II) XINPUT: Adding extended input device "Power Button" (type: KEYBOARD, id 6)
[    48.301] (**) Option "xkb_rules" "evdev"
[    48.301] (**) Option "xkb_model" "pc104"
[    48.301] (**) Option "xkb_layout" "us"
[    48.399] (II) config/udev: Adding input device Video Bus (/dev/input/event4)
[    48.399] (**) Video Bus: Applying InputClass "evdev keyboard catchall"
[    48.399] (**) Video Bus: Applying InputClass "evdev keyboard catchall"
[    48.399] (**) Video Bus: Applying InputClass "LocalKeyboard"
[    48.399] (II) Using input driver 'evdev' for 'Video Bus'
[    48.399] (**) Video Bus: always reports core events
[    48.399] (**) evdev: Video Bus: Device: "/dev/input/event4"
[    48.399] (--) evdev: Video Bus: Vendor 0 Product 0x6
[    48.399] (--) evdev: Video Bus: Found keys
[    48.399] (II) evdev: Video Bus: Configuring as keyboard
[    48.399] (**) Option "config_info" "udev:/sys/devices/LNXSYSTM:00/device:00/PNP0A08:00/LNXVIDEO:00/input/input5/event4"
[    48.399] (II) XINPUT: Adding extended input device "Video Bus" (type: KEYBOARD, id 7)
[    48.399] (**) Option "xkb_rules" "evdev"
[    48.399] (**) Option "xkb_model" "pc104"
[    48.399] (**) Option "xkb_layout" "us"
[    48.401] (II) config/udev: Adding input device Sony Vaio Keys (/dev/input/event7)
[    48.401] (**) Sony Vaio Keys: Applying InputClass "evdev keyboard catchall"
[    48.401] (**) Sony Vaio Keys: Applying InputClass "evdev keyboard catchall"
[    48.401] (**) Sony Vaio Keys: Applying InputClass "LocalKeyboard"
[    48.402] (II) Using input driver 'evdev' for 'Sony Vaio Keys'
[    48.402] (**) Sony Vaio Keys: always reports core events
[    48.402] (**) evdev: Sony Vaio Keys: Device: "/dev/input/event7"
[    48.402] (--) evdev: Sony Vaio Keys: Vendor 0x104d Product 0
[    48.402] (--) evdev: Sony Vaio Keys: Found keys
[    48.402] (II) evdev: Sony Vaio Keys: Configuring as keyboard
[    48.402] (**) Option "config_info" "udev:/sys/devices/LNXSYSTM:00/device:00/PNP0A08:00/device:02/SNY5001:00/input/input8/event7"
[    48.402] (II) XINPUT: Adding extended input device "Sony Vaio Keys" (type: KEYBOARD, id 8)
[    48.402] (**) Option "xkb_rules" "evdev"
[    48.402] (**) Option "xkb_model" "pc104"
[    48.402] (**) Option "xkb_layout" "us"
[    48.404] (II) config/udev: Adding input device Sony Vaio Jogdial (/dev/input/event8)
[    48.404] (II) No input driver specified, ignoring this device.
[    48.404] (II) This device may have been added with another device file.
[    48.405] (II) config/udev: Adding input device Sony Vaio Jogdial (/dev/input/mouse2)
[    48.405] (II) No input driver specified, ignoring this device.
[    48.405] (II) This device may have been added with another device file.
[    48.407] (II) config/udev: Adding input device Power Button (/dev/input/event1)
[    48.407] (**) Power Button: Applying InputClass "evdev keyboard catchall"
[    48.407] (**) Power Button: Applying InputClass "evdev keyboard catchall"
[    48.407] (**) Power Button: Applying InputClass "LocalKeyboard"
[    48.407] (II) Using input driver 'evdev' for 'Power Button'
[    48.407] (**) Power Button: always reports core events
[    48.407] (**) evdev: Power Button: Device: "/dev/input/event1"
[    48.407] (--) evdev: Power Button: Vendor 0 Product 0x1
[    48.407] (--) evdev: Power Button: Found keys
[    48.407] (II) evdev: Power Button: Configuring as keyboard
[    48.407] (**) Option "config_info" "udev:/sys/devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input1/event1"
[    48.407] (II) XINPUT: Adding extended input device "Power Button" (type: KEYBOARD, id 9)
[    48.407] (**) Option "xkb_rules" "evdev"
[    48.407] (**) Option "xkb_model" "pc104"
[    48.408] (**) Option "xkb_layout" "us"
[    48.410] (II) config/udev: Adding input device Lid Switch (/dev/input/event2)
[    48.410] (II) No input driver specified, ignoring this device.
[    48.410] (II) This device may have been added with another device file.
[    48.410] (II) config/udev: Adding drm device (/dev/dri/card0)
[    48.412] (II) config/udev: Adding input device HDA Digital PCBeep (/dev/input/event11)
[    48.412] (II) No input driver specified, ignoring this device.
[    48.412] (II) This device may have been added with another device file.
[    48.413] (II) config/udev: Adding input device HDA Intel Front Headphone (/dev/input/event12)
[    48.413] (II) No input driver specified, ignoring this device.
[    48.413] (II) This device may have been added with another device file.
[    48.414] (II) config/udev: Adding input device HDA Intel Mic (/dev/input/event13)
[    48.414] (II) No input driver specified, ignoring this device.
[    48.414] (II) This device may have been added with another device file.
[    48.415] (II) config/udev: Adding input device PS/2+USB Mouse (/dev/input/event6)
[    48.415] (**) PS/2+USB Mouse: Applying InputClass "evdev pointer catchall"
[    48.415] (**) PS/2+USB Mouse: Applying InputClass "evdev pointer catchall"
[    48.415] (II) Using input driver 'evdev' for 'PS/2+USB Mouse'
[    48.415] (**) PS/2+USB Mouse: always reports core events
[    48.415] (**) evdev: PS/2+USB Mouse: Device: "/dev/input/event6"
[    48.415] (--) evdev: PS/2+USB Mouse: Vendor 0x4f3 Product 0x210
[    48.415] (--) evdev: PS/2+USB Mouse: Found 3 mouse buttons
[    48.415] (--) evdev: PS/2+USB Mouse: Found scroll wheel(s)
[    48.415] (--) evdev: PS/2+USB Mouse: Found relative axes
[    48.416] (--) evdev: PS/2+USB Mouse: Found x and y relative axes
[    48.416] (II) evdev: PS/2+USB Mouse: Configuring as mouse
[    48.416] (II) evdev: PS/2+USB Mouse: Adding scrollwheel support
[    48.416] (**) evdev: PS/2+USB Mouse: YAxisMapping: buttons 4 and 5
[    48.416] (**) evdev: PS/2+USB Mouse: EmulateWheelButton: 4, EmulateWheelInertia: 10, EmulateWheelTimeout: 200
[    48.416] (**) Option "config_info" "udev:/sys/devices/pci0000:00/0000:00:1d.0/usb2/2-2/2-2:1.0/input/input7/event6"
[    48.416] (II) XINPUT: Adding extended input device "PS/2+USB Mouse" (type: MOUSE, id 10)
[    48.416] (II) evdev: PS/2+USB Mouse: initialized for relative axes.
[    48.417] (**) PS/2+USB Mouse: (accel) keeping acceleration scheme 1
[    48.417] (**) PS/2+USB Mouse: (accel) acceleration profile 0
[    48.417] (**) PS/2+USB Mouse: (accel) acceleration factor: 2.000
[    48.417] (**) PS/2+USB Mouse: (accel) acceleration threshold: 4
[    48.418] (II) config/udev: Adding input device PS/2+USB Mouse (/dev/input/mouse1)
[    48.418] (II) No input driver specified, ignoring this device.
[    48.418] (II) This device may have been added with another device file.
[    48.419] (II) config/udev: Adding input device USB2.0 Webcam (/dev/input/event10)
[    48.419] (**) USB2.0 Webcam: Applying InputClass "evdev keyboard catchall"
[    48.419] (**) USB2.0 Webcam: Applying InputClass "evdev keyboard catchall"
[    48.419] (**) USB2.0 Webcam: Applying InputClass "LocalKeyboard"
[    48.419] (II) Using input driver 'evdev' for 'USB2.0 Webcam'
[    48.420] (**) USB2.0 Webcam: always reports core events
[    48.420] (**) evdev: USB2.0 Webcam: Device: "/dev/input/event10"
[    48.420] (--) evdev: USB2.0 Webcam: Vendor 0x4fc Product 0x2000
[    48.420] (--) evdev: USB2.0 Webcam: Found keys
[    48.420] (II) evdev: USB2.0 Webcam: Configuring as keyboard
[    48.420] (**) Option "config_info" "udev:/sys/devices/pci0000:00/0000:00:1d.7/usb1/1-7/1-7:1.0/input/input11/event10"
[    48.420] (II) XINPUT: Adding extended input device "USB2.0 Webcam" (type: KEYBOARD, id 11)
[    48.420] (**) Option "xkb_rules" "evdev"
[    48.420] (**) Option "xkb_model" "pc104"
[    48.420] (**) Option "xkb_layout" "us"
[    48.422] (II) config/udev: Adding input device AT Translated Set 2 keyboard (/dev/input/event0)
[    48.422] (**) AT Translated Set 2 keyboard: Applying InputClass "evdev keyboard catchall"
[    48.422] (**) AT Translated Set 2 keyboard: Applying InputClass "evdev keyboard catchall"
[    48.422] (**) AT Translated Set 2 keyboard: Applying InputClass "LocalKeyboard"
[    48.422] (II) Using input driver 'evdev' for 'AT Translated Set 2 keyboard'
[    48.422] (**) AT Translated Set 2 keyboard: always reports core events
[    48.422] (**) evdev: AT Translated Set 2 keyboard: Device: "/dev/input/event0"
[    48.422] (--) evdev: AT Translated Set 2 keyboard: Vendor 0x1 Product 0x1
[    48.422] (--) evdev: AT Translated Set 2 keyboard: Found keys
[    48.422] (II) evdev: AT Translated Set 2 keyboard: Configuring as keyboard
[    48.423] (**) Option "config_info" "udev:/sys/devices/platform/i8042/serio0/input/input0/event0"
[    48.423] (II) XINPUT: Adding extended input device "AT Translated Set 2 keyboard" (type: KEYBOARD, id 12)
[    48.423] (**) Option "xkb_rules" "evdev"
[    48.423] (**) Option "xkb_model" "pc104"
[    48.423] (**) Option "xkb_layout" "us"
[    48.425] (II) config/udev: Adding input device SynPS/2 Synaptics TouchPad (/dev/input/event5)
[    48.425] (**) SynPS/2 Synaptics TouchPad: Applying InputClass "evdev touchpad catchall"
[    48.425] (**) SynPS/2 Synaptics TouchPad: Applying InputClass "evdev touchpad catchall"
[    48.425] (**) SynPS/2 Synaptics TouchPad: Applying InputClass "touchpad catchall"
[    48.425] (**) SynPS/2 Synaptics TouchPad: Applying InputClass "Default clickpad buttons"
[    48.425] (II) LoadModule: "synaptics"
[    48.426] (II) Loading /usr/lib64/xorg/modules/input/synaptics_drv.so
[    48.433] (II) Module synaptics: vendor="X.Org Foundation"
[    48.433] 	compiled for 1.14.3, module version = 1.7.1
[    48.433] 	Module class: X.Org XInput Driver
[    48.433] 	ABI class: X.Org XInput driver, version 19.1
[    48.433] (II) Using input driver 'synaptics' for 'SynPS/2 Synaptics TouchPad'
[    48.433] (**) SynPS/2 Synaptics TouchPad: always reports core events
[    48.433] (**) Option "Device" "/dev/input/event5"
[    48.456] (II) synaptics: SynPS/2 Synaptics TouchPad: ignoring touch events for semi-multitouch device
[    48.456] (--) synaptics: SynPS/2 Synaptics TouchPad: x-axis range 1472 - 5888 (res 98)
[    48.456] (--) synaptics: SynPS/2 Synaptics TouchPad: y-axis range 1408 - 4938 (res 177)
[    48.456] (--) synaptics: SynPS/2 Synaptics TouchPad: pressure range 0 - 255
[    48.457] (--) synaptics: SynPS/2 Synaptics TouchPad: finger width range 0 - 15
[    48.457] (--) synaptics: SynPS/2 Synaptics TouchPad: buttons: left right double triple
[    48.457] (--) synaptics: SynPS/2 Synaptics TouchPad: Vendor 0x2 Product 0x7
[    48.457] (**) Option "HorizScrollDelta" "0"
[    48.457] (**) Option "TapButton1" "1"
[    48.457] (**) Option "TapButton2" "3"
[    48.457] (**) Option "TapButton3" "2"
[    48.457] (--) synaptics: SynPS/2 Synaptics TouchPad: touchpad found
[    48.458] (**) SynPS/2 Synaptics TouchPad: always reports core events
[    48.468] (**) Option "config_info" "udev:/sys/devices/platform/i8042/serio1/input/input6/event5"
[    48.468] (II) XINPUT: Adding extended input device "SynPS/2 Synaptics TouchPad" (type: TOUCHPAD, id 13)
[    48.468] (**) synaptics: SynPS/2 Synaptics TouchPad: (accel) MinSpeed is now constant deceleration 2.5
[    48.468] (**) synaptics: SynPS/2 Synaptics TouchPad: (accel) MaxSpeed is now 1.75
[    48.468] (**) synaptics: SynPS/2 Synaptics TouchPad: (accel) AccelFactor is now 0.035
[    48.470] (**) SynPS/2 Synaptics TouchPad: (accel) keeping acceleration scheme 1
[    48.470] (**) SynPS/2 Synaptics TouchPad: (accel) acceleration profile 1
[    48.470] (**) SynPS/2 Synaptics TouchPad: (accel) acceleration factor: 2.000
[    48.470] (**) SynPS/2 Synaptics TouchPad: (accel) acceleration threshold: 4
[    48.470] (--) synaptics: SynPS/2 Synaptics TouchPad: touchpad found
[    48.472] (II) config/udev: Adding input device SynPS/2 Synaptics TouchPad (/dev/input/mouse0)
[    48.472] (**) SynPS/2 Synaptics TouchPad: Ignoring device from InputClass "touchpad ignore duplicates"
[    48.473] (II) config/udev: Adding input device PC Speaker (/dev/input/event9)
[    48.474] (II) No input driver specified, ignoring this device.
[    48.474] (II) This device may have been added with another device file.
[    53.076] (II) intel(0): EDID vendor "BNQ", prod id 30420
[    53.076] (II) intel(0): Using EDID range info for horizontal sync
[    53.076] (II) intel(0): Using EDID range info for vertical refresh
[    53.076] (II) intel(0): Printing DDC gathered Modelines:
[    53.076] (II) intel(0): Modeline "1280x1024"x0.0  108.00  1280 1328 1440 1688  1024 1025 1028 1066 +hsync +vsync (64.0 kHz eP)
[    53.076] (II) intel(0): Modeline "640x350"x0.0   25.17  640 656 752 800  350 387 389 449 +hsync -vsync (31.5 kHz e)
[    53.076] (II) intel(0): Modeline "800x600"x0.0   40.00  800 840 968 1056  600 601 605 628 +hsync +vsync (37.9 kHz e)
[    53.077] (II) intel(0): Modeline "640x480"x0.0   31.50  640 656 720 840  480 481 484 500 -hsync -vsync (37.5 kHz e)
[    53.077] (II) intel(0): Modeline "640x480"x0.0   31.50  640 664 704 832  480 489 492 520 -hsync -vsync (37.9 kHz e)
[    53.077] (II) intel(0): Modeline "640x480"x0.0   30.24  640 704 768 864  480 483 486 525 -hsync -vsync (35.0 kHz e)
[    53.077] (II) intel(0): Modeline "640x480"x0.0   25.18  640 656 752 800  480 490 492 525 -hsync -vsync (31.5 kHz e)
[    53.077] (II) intel(0): Modeline "720x400"x0.0   28.32  720 738 846 900  400 412 414 449 -hsync +vsync (31.5 kHz e)
[    53.077] (II) intel(0): Modeline "1280x1024"x0.0  135.00  1280 1296 1440 1688  1024 1025 1028 1066 +hsync +vsync (80.0 kHz e)
[    53.077] (II) intel(0): Modeline "1024x768"x0.0   78.75  1024 1040 1136 1312  768 769 772 800 +hsync +vsync (60.0 kHz e)
[    53.077] (II) intel(0): Modeline "1024x768"x0.0   75.00  1024 1048 1184 1328  768 771 777 806 -hsync -vsync (56.5 kHz e)
[    53.077] (II) intel(0): Modeline "1024x768"x0.0   65.00  1024 1048 1184 1344  768 771 777 806 -hsync -vsync (48.4 kHz e)
[    53.077] (II) intel(0): Modeline "832x624"x0.0   57.28  832 864 928 1152  624 625 628 667 -hsync -vsync (49.7 kHz e)
[    53.077] (II) intel(0): Modeline "800x600"x0.0   49.50  800 816 896 1056  600 601 604 625 +hsync +vsync (46.9 kHz e)
[    53.077] (II) intel(0): Modeline "800x600"x0.0   50.00  800 856 976 1040  600 637 643 666 +hsync +vsync (48.1 kHz e)
[    53.077] (II) intel(0): Modeline "1152x864"x0.0  108.00  1152 1216 1344 1600  864 865 868 900 +hsync +vsync (67.5 kHz e)
[    53.077] (II) intel(0): Modeline "1280x1024"x72.0  132.75  1280 1368 1504 1728  1024 1025 1028 1067 -hsync +vsync (76.8 kHz e)
[    53.096] (II) intel(0): switch to mode 1024x600@60.0 on pipe 1 using LVDS1, position (0, 1024), rotation normal
[    53.889] (II) intel(0): switch to mode 1280x1024@60.0 on pipe 0 using VGA1, position (0, 0), rotation normal
[    53.987] (II) intel(0): resizing framebuffer to 1280x1624
[    54.061] (II) intel(0): switch to mode 1280x1024@60.0 on pipe 0 using VGA1, position (0, 0), rotation normal
[    54.079] (II) intel(0): switch to mode 1024x600@60.0 on pipe 1 using LVDS1, position (0, 1024), rotation normal
[   110.819] (EE) 
[   110.819] (EE) Backtrace:
[   110.838] (EE) 0: /usr/bin/X (xorg_backtrace+0x3d) [0x585acd]
[   110.838] (EE) 1: /usr/bin/X (0x400000+0x189839) [0x589839]
[   110.838] (EE) 2: /lib64/libpthread.so.0 (0x7f61ab72f000+0xf9f0) [0x7f61ab73e9f0]
[   110.838] (EE) 3: /lib64/libc.so.6 (0x7f61aa581000+0x12d28c) [0x7f61aa6ae28c]
[   110.838] (EE) 4: /usr/lib64/xorg/modules/drivers/intel_drv.so (0x7f61a6571000+0x9abe3) [0x7f61a660bbe3]
[   110.839] (EE) 5: /usr/lib64/xorg/modules/drivers/intel_drv.so (0x7f61a6571000+0x9db81) [0x7f61a660eb81]
[   110.839] (EE) 6: /usr/bin/X (0x400000+0xd8d8f) [0x4d8d8f]
[   110.839] (EE) 7: /usr/bin/X (0x400000+0x3cc3e) [0x43cc3e]
[   110.839] (EE) 8: /usr/bin/X (0x400000+0x2c1ba) [0x42c1ba]
[   110.839] (EE) 9: /lib64/libc.so.6 (__libc_start_main+0xf5) [0x7f61aa5a2be5]
[   110.840] (EE) 10: /usr/bin/X (0x400000+0x2c501) [0x42c501]
[   110.840] (EE) 
[   110.840] (EE) Segmentation fault at address 0x7f61a4db1000
[   110.840] (EE) 
Fatal server error:
[   110.840] (EE) Caught signal 11 (Segmentation fault). Server aborting
[   110.840] (EE) 
[   110.840] (EE) 
Please consult the The X.Org Foundation support 
	 at http://wiki.x.org
 for help. 
[   110.840] (EE) Please also check the log file at "/var/log/Xorg.0.log" for additional information.
[   110.840] (EE) 
[   110.841] (II) AIGLX: Suspending AIGLX clients for VT switch
[   111.723] (EE) Server terminated with error (1). Closing log file.


gdb
===

Received SIGSEGV at...
(gdb) bt
#0  __memcpy_ssse3 () at ../sysdeps/x86_64/multiarch/memcpy-ssse3.S:1788
#1  0x00007ff0e76d5be3 in memcpy (__len=<optimized out>, 
    __src=<optimized out>, __dest=<optimized out>)
    at /usr/include/bits/string3.h:51
#2  sna_video_copy_data (video=video@entry=0x1e12780, 
    frame=frame@entry=0x7ffff8952340, 
    buf=buf@entry=0x7ff0e31c4000 "`\201_\200`\201`\200a\201c\200e\201g\200h\200i\200k\200k\200l\200l\200m\200m\200l\200j\200j\200h\200i\200j\200l\200m\200o\200p\200r\200r\200s\200s\200u\200u\200v\200v\200w\200w\200w\200w\200w\200w\200w\200w\200w\200w\200w\200v\200t\200s\200q\200q\200n\200n\200n\200n\200n\200n\200n\200n\200n\200n\200n\200n\200n\200n\200n\200n\200o\200o\200o\200n\200n\200n\200m\200m\200l\200l\200l\200l\200l\200l\200l\200l\200l\200l\200k\200k\200k\200k\200k\200l\200l\200l\200l\200l\200l\200l\200l\200j\200j\200j\200"...) at sna_video.c:536
#3  0x00007ff0e76d8b81 in sna_video_textured_put_image (
    client=<optimized out>, draw=0x21a9640, port=<optimized out>, 
    gc=<optimized out>, src_x=<optimized out>, src_y=<optimized out>, 
    src_w=512, src_h=384, drw_x=0, drw_y=32, drw_w=1280, drw_h=960, 
    format=0x7ff0e775e580 <Images>, 
    buf=0x7ff0e31c4000 "`\201_\200`\201`\200a\201c\200e\201g\200h\200i\200k\200k\200l\200l\200m\200m\200l\200j\200j\200h\200i\200j\200l\200m\200o\200p\200r\200r\200s\200s\200u\200u\200v\200v\200w\200w\200w\200w\200w\200w\200w\200w\200w\200w\200w\200v\200t\200s\200q\200q\200n\200n\200n\200n\200n\200n\200n\200n\200n\200n\200n\200n\200n\200n\200n\200n\200o\200o\200o\200n\200n\200n\200m\200m\200l\200l\200l\200l\200l\200l\200l\200l\200l\200l\200k\200k\200k\200k\200k\200l\200l\200l---Type <return> to continue, or q <return> to quit---
\200l\200l\200l\200l\200l\200j\200j\200j\200"..., sync=0, width=512, 
    height=384) at sna_video_textured.c:236
#4  0x00000000004d8d8f in ProcXvShmPutImage (client=0x236ebb0) at xvdisp.c:1025
#5  0x000000000043cc3e in Dispatch () at dispatch.c:432
#6  0x000000000042c1ba in main (argc=8, argv=0x7ffff8952638, 
    envp=<optimized out>) at main.c:298
(gdb) up
#1  0x00007ff0e76d5be3 in memcpy (__len=<optimized out>, 
    __src=<optimized out>, __dest=<optimized out>)
    at /usr/include/bits/string3.h:51
51	  return __builtin___memcpy_chk (__dest, __src, __len, __bos0 (__dest));
(gdb) 
#2  sna_video_copy_data (video=video@entry=0x1e12780, 
    frame=frame@entry=0x7ffff8952340, 
    buf=buf@entry=0x7ff0e31c4000 "`\201_\200`\201`\200a\201c\200e\201g\200h\200i\200k\200k\200l\200l\200m\200m\200l\200j\200j\200h\200i\200j\200l\200m\200o\200p\200r\200r\200s\200s\200u\200u\200v\200v\200w\200w\200w\200w\200w\200w\200w\200w\200w\200w\200w\200v\200t\200s\200q\200q\200n\200n\200n\200n\200n\200n\200n\200n\200n\200n\200n\200n\200n\200n\200n\200n\200o\200o\200o\200n\200n\200n\200m\200m\200l\200l\200l\200l\200l\200l\200l\200l\200l\200l\200k\200k\200k\200k\200k\200l\200l\200l\200l\200l\200l\200l\200l\200j\200j\200j\200"...) at sna_video.c:536
536						memcpy(dst,
(gdb) l
531									       KGEM_BUFFER_WRITE | KGEM_BUFFER_WRITE_INPLACE,
532									       (void **)&dst);
533						if (frame->bo == NULL)
534							return false;
535	
536						memcpy(dst,
537						       buf + (frame->image.y1 * frame->width*2) + (frame->image.x1 << 1),
538						       2U*(frame->image.y2-frame->image.y1)*frame->width);
539					}
540					return true;
(gdb) p dst
$1 = (uint8_t *) 0x7ff0e2cc8000 <Address 0x7ff0e2cc8000 out of bounds>
(gdb) p frame
$2 = (struct sna_video_frame *) 0x7ffff8952340
(gdb) p *frame
$3 = {bo = 0x23a4600, id = 844715353, size = 393216, UBufOffset = 0, 
  VBufOffset = 0, width = 512, height = 384, pitch = {1024, 0}, image = {
    x1 = 2, y1 = 0, x2 = 510, y2 = 384}, src = {x1 = 2, y1 = 0, x2 = 510, 
    y2 = 384}}
(gdb) p *frame->bo
$5 = {rq = 0x0, exec = 0x0, proxy = 0x21bae60, list = {next = 0x23a4618, 
    prev = 0x23a4618}, request = {next = 0x23a4628, prev = 0x23a4628}, vma = {
    next = 0x23a4638, prev = 0x23a4638}, map__cpu = 0x0, map__gtt = 0x0, 
  binding = {next = 0x0, format = 0, offset = 0}, presumed_offset = 0, 
  unique_id = 17315, refcnt = 1, handle = 123, target_handle = 4294967295, 
  delta = 0, size = {pages = {count = 393216, bucket = 0}, bytes = 393216}, 
  pitch = 0, tiling = 0, reusable = 0, gpu_dirty = 0, gtt_dirty = 0, 
  domain = 1, needs_flush = 0, snoop = 0, io = 1, flush = 0, scanout = 0, 
  purged = 0}
(gdb) up
#3  0x00007ff0e76d8b81 in sna_video_textured_put_image (
    client=<optimized out>, draw=0x21a9640, port=<optimized out>, 
    gc=<optimized out>, src_x=<optimized out>, src_y=<optimized out>, 
    src_w=512, src_h=384, drw_x=0, drw_y=32, drw_w=1280, drw_h=960, 
    format=0x7ff0e775e580 <Images>, 
    buf=0x7ff0e31c4000 "`\201_\200`\201`\200a\201c\200e\201g\200h\200i\200k\200k\200l\200l\200m\200m\200l\200j\200j\200h\200i\200j\200l\200m\200o\200p\200r\200r\200s\200s\200u\200u\200v\200v\200w\200w\200w\200w\200w\200w\200w\200w\200w\200w\200w\200v\200t\200s\200q\200q\200n\200n\200n\200n\200n\200n\200n\200n\200n\200n\200n\200n\200n\200n\200n\200n\200o\200o\200o\200n\200n\200n\200m\200m\200l\200l\200l\200l\200l\200l\200l\200l\200l\200l\200k\200k\200k\200k\200k\200l\200l\200l\200l\200l\200l\200l\200l\200j\200j\200j\200"..., sync=0, width=512, 
    height=384) at sna_video_textured.c:236
236			if (!sna_video_copy_data(video, &frame, buf)) {
(gdb) l
231			frame.image.x1 = 0;
232			frame.image.y1 = 0;
233			frame.image.x2 = frame.width;
234			frame.image.y2 = frame.height;
235		} else {
236			if (!sna_video_copy_data(video, &frame, buf)) {
237				DBG(("%s: failed to copy frame\n", __FUNCTION__));
238				kgem_bo_destroy(&sna->kgem, frame.bo);
239				return BadAlloc;
240			}
(gdb) up
#4  0x00000000004d8d8f in ProcXvShmPutImage (client=0x236ebb0) at xvdisp.c:1025
1025	    status = XvdiPutImage(client, pDraw, pPort, pGC, stuff->src_x, stuff->src_y,
(gdb) l
1020	        return BadAccess;
1021	
1022	    if ((width < stuff->width) || (height < stuff->height))
1023	        return BadValue;
1024	
1025	    status = XvdiPutImage(client, pDraw, pPort, pGC, stuff->src_x, stuff->src_y,
1026	                          stuff->src_w, stuff->src_h, stuff->drw_x,
1027	                          stuff->drw_y, stuff->drw_w, stuff->drw_h, pImage,
1028	                          (unsigned char *) shmdesc->addr + stuff->offset,
1029	                          stuff->send_event, stuff->width, stuff->height);
(gdb) up
#5  0x000000000043cc3e in Dispatch () at dispatch.c:432
432	                        result =
(gdb) l
427	                if (result > (maxBigRequestSize << 2))
428	                    result = BadLength;
429	                else {
430	                    result = XaceHookDispatch(client, client->majorOp);
431	                    if (result == Success)
432	                        result =
433	                            (*client->requestVector[client->majorOp]) (client);
434	                    XaceHookAuditEnd(client, result);
435	                }
436	#ifdef XSERVER_DTRACE
(gdb) up
#6  0x000000000042c1ba in main (argc=8, argv=0x7ffff8952638, 
    envp=<optimized out>) at main.c:298
298	        Dispatch();
(gdb) l
293	        pthread_mutex_unlock(&serverRunningMutex);
294	#endif
295	
296	        NotifyParentProcess();
297	
298	        Dispatch();
299	
300	#ifdef XQUARTZ
301	        /* Let the other threads know the server is no longer running */
302	        pthread_mutex_lock(&serverRunningMutex);
(gdb) up
Initial frame selected; you cannot go up.
(gdb) gcore /tmp/Xorg.core
warning: target file /proc/1979/cmdline contained unexpected null characters
warning: Memory read failed for corefile section, 999424 bytes at 0x7ff0e2cc8000.
warning: Memory read failed for corefile section, 12288 bytes at 0x7ff0e2dbc000.
warning: Memory read failed for corefile section, 262144 bytes at 0x7ff0e2dc2000.
warning: Memory read failed for corefile section, 24576 bytes at 0x7ff0e2e02000.
warning: Memory read failed for corefile section, 262144 bytes at 0x7ff0e2eb8000.
warning: Memory read failed for corefile section, 8192 bytes at 0x7ff0e2f14000.
warning: Memory read failed for corefile section, 917504 bytes at 0x7ff0e304c000.
warning: Memory read failed for corefile section, 262144 bytes at 0x7ff0e3291000.
warning: Memory read failed for corefile section, 262144 bytes at 0x7ff0e32d1000.
warning: Memory read failed for corefile section, 262144 bytes at 0x7ff0e3498000.
warning: Memory read failed for corefile section, 262144 bytes at 0x7ff0e3847000.
warning: Memory read failed for corefile section, 262144 bytes at 0x7ff0e38c7000.
warning: Memory read failed for corefile section, 262144 bytes at 0x7ff0e3907000.
warning: Memory read failed for corefile section, 8192 bytes at 0x7ff0e3d17000.
warning: Memory read failed for corefile section, 8192 bytes at 0x7ff0e3d20000.
warning: Memory read failed for corefile section, 12288 bytes at 0x7ff0e3d24000.
warning: Memory read failed for corefile section, 262144 bytes at 0x7ff0e3d67000.
warning: Memory read failed for corefile section, 1048576 bytes at 0x7ff0e3da7000.
warning: Memory read failed for corefile section, 262144 bytes at 0x7ff0e4a67000.
warning: Memory read failed for corefile section, 1048576 bytes at 0x7ff0e4b67000.
warning: Memory read failed for corefile section, 1048576 bytes at 0x7ff0e5827000.
warning: Memory read failed for corefile section, 20480 bytes at 0x7ff0e5a18000.
warning: Memory read failed for corefile section, 61440 bytes at 0x7ff0e5a1d000.
warning: Memory read failed for corefile section, 61440 bytes at 0x7ff0e5a2c000.
warning: Memory read failed for corefile section, 1048576 bytes at 0x7ff0e5d7b000.
warning: Memory read failed for corefile section, 8192 bytes at 0x7ff0e6635000.
warning: Memory read failed for corefile section, 16384 bytes at 0x7ff0e6639000.
warning: Memory read failed for corefile section, 12288 bytes at 0x7ff0ed446000.
warning: Memory read failed for corefile section, 12288 bytes at 0x7ff0ed449000.
warning: Memory read failed for corefile section, 12288 bytes at 0x7ff0ed44c000.
warning: Memory read failed for corefile section, 12288 bytes at 0x7ff0ed453000.
warning: Memory read failed for corefile section, 8192 bytes at 0x7ff0ed625000.
warning: Memory read failed for corefile section, 65536 bytes at 0x7ff0ed627000.
warning: Memory read failed for corefile section, 20480 bytes at 0x7ff0ed63a000.
Saved corefile /tmp/Xorg.core



/proc/(Xorg)/smaps
==================

00400000-00601000 r-xp 00000000 fe:00 50987182                           /usr/bin/Xorg
Size:               2052 kB
Rss:                1456 kB
Pss:                1452 kB
Shared_Clean:          8 kB
Shared_Dirty:          0 kB
Private_Clean:      1448 kB
Private_Dirty:         0 kB
Referenced:          208 kB
Anonymous:             0 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd ex mr mw me dw 
00800000-00803000 r--p 00200000 fe:00 50987182                           /usr/bin/Xorg
Size:                 12 kB
Rss:                   8 kB
Pss:                   8 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         8 kB
Referenced:            8 kB
Anonymous:             8 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd mr mw me dw ac 
00803000-0080f000 rw-p 00203000 fe:00 50987182                           /usr/bin/Xorg
Size:                 48 kB
Rss:                  32 kB
Pss:                  32 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:        32 kB
Referenced:           28 kB
Anonymous:            32 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd wr mr mw me dw ac 
0080f000-0081f000 rw-p 00000000 00:00 0 
Size:                 64 kB
Rss:                  60 kB
Pss:                  60 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:        60 kB
Referenced:           52 kB
Anonymous:            60 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd wr mr mw me ac 
01dd5000-0272b000 rw-p 00000000 00:00 0                                  [heap]
Size:               9560 kB
Rss:                9380 kB
Pss:                9380 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:      9380 kB
Referenced:         5080 kB
Anonymous:          9380 kB
AnonHugePages:      2048 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd wr mr mw me ac 
7ff0e2cc8000-7ff0e2dbc000 rw-s 10265a000 00:05 1886                      /dev/dri/card0
Size:                976 kB
Rss:                   0 kB
Pss:                   0 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         0 kB
Referenced:            0 kB
Anonymous:             0 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd wr sh mr mw me ms pf io de dd 
7ff0e2dbc000-7ff0e2dbf000 rw-s 102487000 00:05 1886                      /dev/dri/card0
Size:                 12 kB
Rss:                   0 kB
Pss:                   0 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         0 kB
Referenced:            0 kB
Anonymous:             0 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd wr sh mr mw me ms pf io de dd 
7ff0e2dc2000-7ff0e2e02000 rw-s 10238f000 00:05 1886                      /dev/dri/card0
Size:                256 kB
Rss:                   0 kB
Pss:                   0 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         0 kB
Referenced:            0 kB
Anonymous:             0 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd wr sh mr mw me ms pf io de dd 
7ff0e2e02000-7ff0e2e08000 rw-s 102481000 00:05 1886                      /dev/dri/card0
Size:                 24 kB
Rss:                   0 kB
Pss:                   0 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         0 kB
Referenced:            0 kB
Anonymous:             0 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd wr sh mr mw me ms pf io de dd 
7ff0e2e38000-7ff0e2e78000 rw-s 00000000 00:04 16809                      /drm mm object (deleted)
Size:                256 kB
Rss:                  96 kB
Pss:                  96 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:        96 kB
Referenced:           96 kB
Anonymous:             0 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd wr sh mr mw me ms 
7ff0e2eb8000-7ff0e2ef8000 rw-s 102146000 00:05 1886                      /dev/dri/card0
Size:                256 kB
Rss:                   0 kB
Pss:                   0 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         0 kB
Referenced:            0 kB
Anonymous:             0 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd wr sh mr mw me ms pf io de dd 
7ff0e2ef8000-7ff0e2f11000 rw-s 00000000 00:04 16252                      /drm mm object (deleted)
Size:                100 kB
Rss:                 100 kB
Pss:                 100 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:       100 kB
Referenced:          100 kB
Anonymous:             0 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd wr sh mr mw me ms 
7ff0e2f14000-7ff0e2f16000 rw-s 10247c000 00:05 1886                      /dev/dri/card0
Size:                  8 kB
Rss:                   0 kB
Pss:                   0 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         0 kB
Referenced:            0 kB
Anonymous:             0 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd wr sh mr mw me ms pf io de dd 
7ff0e2fcc000-7ff0e300c000 rw-s 00000000 00:04 16808                      /drm mm object (deleted)
Size:                256 kB
Rss:                   4 kB
Pss:                   4 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         4 kB
Referenced:            4 kB
Anonymous:             0 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd wr sh mr mw me ms 
7ff0e304c000-7ff0e312c000 rw-s 10250a000 00:05 1886                      /dev/dri/card0
Size:                896 kB
Rss:                   0 kB
Pss:                   0 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         0 kB
Referenced:            0 kB
Anonymous:             0 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd wr sh mr mw me ms pf io de dd 
7ff0e312e000-7ff0e3130000 rw-s 00000000 00:04 16436                      /drm mm object (deleted)
Size:                  8 kB
Rss:                   8 kB
Pss:                   8 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         8 kB
Referenced:            8 kB
Anonymous:             0 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd wr sh mr mw me ms 
7ff0e3164000-7ff0e31c4000 rw-s 00000000 00:04 5079049                    /SYSV00000000 (deleted)
Size:                384 kB
Rss:                 384 kB
Pss:                 192 kB
Shared_Clean:          0 kB
Shared_Dirty:        384 kB
Private_Clean:         0 kB
Private_Dirty:         0 kB
Referenced:          384 kB
Anonymous:             0 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd wr sh mr mw me ms 
7ff0e31c4000-7ff0e3224000 rw-s 00000000 00:04 5046280                    /SYSV00000000 (deleted)
Size:                384 kB
Rss:                 384 kB
Pss:                 192 kB
Shared_Clean:          0 kB
Shared_Dirty:        384 kB
Private_Clean:         0 kB
Private_Dirty:         0 kB
Referenced:          384 kB
Anonymous:             0 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd wr sh mr mw me ms 
7ff0e3291000-7ff0e32d1000 rw-s 10274e000 00:05 1886                      /dev/dri/card0
Size:                256 kB
Rss:                   0 kB
Pss:                   0 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         0 kB
Referenced:            0 kB
Anonymous:             0 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd wr sh mr mw me ms pf io de dd 
7ff0e32d1000-7ff0e3311000 rw-s 102106000 00:05 1886                      /dev/dri/card0
Size:                256 kB
Rss:                   0 kB
Pss:                   0 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         0 kB
Referenced:            0 kB
Anonymous:             0 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd wr sh mr mw me ms pf io de dd 
7ff0e3331000-7ff0e33f1000 rw-s 00000000 00:04 16818                      /drm mm object (deleted)
Size:                768 kB
Rss:                 400 kB
Pss:                 400 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:       400 kB
Referenced:          400 kB
Anonymous:             0 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd wr sh mr mw me ms 
7ff0e3498000-7ff0e34d8000 rw-s 1022a6000 00:05 1886                      /dev/dri/card0
Size:                256 kB
Rss:                   0 kB
Pss:                   0 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         0 kB
Referenced:            0 kB
Anonymous:             0 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd wr sh mr mw me ms pf io de dd 
7ff0e34d8000-7ff0e3598000 rw-s 00000000 00:04 16409                      /drm mm object (deleted)
Size:                768 kB
Rss:                 768 kB
Pss:                 768 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:       768 kB
Referenced:          768 kB
Anonymous:             0 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd wr sh mr mw me ms 
7ff0e35a0000-7ff0e35e0000 rw-s 00000000 00:04 16975                      /drm mm object (deleted)
Size:                256 kB
Rss:                 104 kB
Pss:                 104 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:       104 kB
Referenced:          104 kB
Anonymous:             0 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd wr sh mr mw me ms 
7ff0e35e0000-7ff0e3620000 rw-s 00000000 00:04 17830                      /drm mm object (deleted)
Size:                256 kB
Rss:                 120 kB
Pss:                 120 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:       120 kB
Referenced:          120 kB
Anonymous:             0 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd wr sh mr mw me ms 
7ff0e3847000-7ff0e3887000 rw-s 101ee3000 00:05 1886                      /dev/dri/card0
Size:                256 kB
Rss:                   0 kB
Pss:                   0 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         0 kB
Referenced:            0 kB
Anonymous:             0 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd wr sh mr mw me ms pf io de dd 
7ff0e3887000-7ff0e38c7000 rw-s 00000000 00:04 16099                      /drm mm object (deleted)
Size:                256 kB
Rss:                 100 kB
Pss:                 100 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:       100 kB
Referenced:          100 kB
Anonymous:             0 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd wr sh mr mw me ms 
7ff0e38c7000-7ff0e3907000 rw-s 102266000 00:05 1886                      /dev/dri/card0
Size:                256 kB
Rss:                   0 kB
Pss:                   0 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         0 kB
Referenced:            0 kB
Anonymous:             0 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd wr sh mr mw me ms pf io de dd 
7ff0e3907000-7ff0e3947000 rw-s 101de3000 00:05 1886                      /dev/dri/card0
Size:                256 kB
Rss:                   0 kB
Pss:                   0 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         0 kB
Referenced:            0 kB
Anonymous:             0 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd wr sh mr mw me ms pf io de dd 
7ff0e3947000-7ff0e3987000 rw-s 00000000 00:04 15067                      /drm mm object (deleted)
Size:                256 kB
Rss:                  96 kB
Pss:                  96 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:        96 kB
Referenced:           96 kB
Anonymous:             0 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd wr sh mr mw me ms 
7ff0e3987000-7ff0e39c7000 rw-s 00000000 00:04 15066                      /drm mm object (deleted)
Size:                256 kB
Rss:                 256 kB
Pss:                 256 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:       256 kB
Referenced:          256 kB
Anonymous:             0 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd wr sh mr mw me ms 
7ff0e39c7000-7ff0e3a07000 rw-s 00000000 00:04 16974                      /drm mm object (deleted)
Size:                256 kB
Rss:                 144 kB
Pss:                 144 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:       144 kB
Referenced:          144 kB
Anonymous:             0 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd wr sh mr mw me ms 
7ff0e3a07000-7ff0e3a47000 rw-s 00000000 00:04 16973                      /drm mm object (deleted)
Size:                256 kB
Rss:                 256 kB
Pss:                 256 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:       256 kB
Referenced:          256 kB
Anonymous:             0 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd wr sh mr mw me ms 
7ff0e3a47000-7ff0e3a87000 rw-s 00000000 00:04 17595                      /drm mm object (deleted)
Size:                256 kB
Rss:                  12 kB
Pss:                  12 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:        12 kB
Referenced:           12 kB
Anonymous:             0 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd wr sh mr mw me ms 
7ff0e3b07000-7ff0e3b67000 rw-s 00000000 00:04 3375114                    /SYSV00000000 (deleted)
Size:                384 kB
Rss:                 384 kB
Pss:                 192 kB
Shared_Clean:          0 kB
Shared_Dirty:        384 kB
Private_Clean:         0 kB
Private_Dirty:         0 kB
Referenced:          384 kB
Anonymous:             0 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd wr sh mr mw me ms 
7ff0e3b67000-7ff0e3c27000 rw-s 00000000 00:04 15819                      /drm mm object (deleted)
Size:                768 kB
Rss:                 768 kB
Pss:                 768 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:       768 kB
Referenced:          768 kB
Anonymous:             0 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd wr sh mr mw me ms 
7ff0e3c27000-7ff0e3ce7000 rw-s 00000000 00:04 15039                      /drm mm object (deleted)
Size:                768 kB
Rss:                 384 kB
Pss:                 384 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:       384 kB
Referenced:          196 kB
Anonymous:             0 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd wr sh mr mw me ms 
7ff0e3d15000-7ff0e3d17000 rw-s 00000000 00:04 17735                      /drm mm object (deleted)
Size:                  8 kB
Rss:                   8 kB
Pss:                   8 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         8 kB
Referenced:            8 kB
Anonymous:             0 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd wr sh mr mw me ms 
7ff0e3d17000-7ff0e3d19000 rw-s 10279c000 00:05 1886                      /dev/dri/card0
Size:                  8 kB
Rss:                   0 kB
Pss:                   0 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         0 kB
Referenced:            0 kB
Anonymous:             0 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd wr sh mr mw me ms pf io de dd 
7ff0e3d19000-7ff0e3d1e000 rw-s 00000000 00:04 17732                      /drm mm object (deleted)
Size:                 20 kB
Rss:                  20 kB
Pss:                  20 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:        20 kB
Referenced:           20 kB
Anonymous:             0 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd wr sh mr mw me ms 
7ff0e3d1e000-7ff0e3d20000 rw-s 00000000 00:04 16877                      /drm mm object (deleted)
Size:                  8 kB
Rss:                   8 kB
Pss:                   8 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         8 kB
Referenced:            8 kB
Anonymous:             0 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd wr sh mr mw me ms 
7ff0e3d20000-7ff0e3d22000 rw-s 10279a000 00:05 1886                      /dev/dri/card0
Size:                  8 kB
Rss:                   0 kB
Pss:                   0 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         0 kB
Referenced:            0 kB
Anonymous:             0 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd wr sh mr mw me ms pf io de dd 
7ff0e3d22000-7ff0e3d24000 rw-s 00000000 00:04 16867                      /drm mm object (deleted)
Size:                  8 kB
Rss:                   8 kB
Pss:                   8 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         8 kB
Referenced:            8 kB
Anonymous:             0 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd wr sh mr mw me ms 
7ff0e3d24000-7ff0e3d27000 rw-s 10234c000 00:05 1886                      /dev/dri/card0
Size:                 12 kB
Rss:                   0 kB
Pss:                   0 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         0 kB
Referenced:            0 kB
Anonymous:             0 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd wr sh mr mw me ms pf io de dd 
7ff0e3d67000-7ff0e3da7000 rw-s 102308000 00:05 1886                      /dev/dri/card0
Size:                256 kB
Rss:                   0 kB
Pss:                   0 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         0 kB
Referenced:            0 kB
Anonymous:             0 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd wr sh mr mw me ms pf io de dd 
7ff0e3da7000-7ff0e4a67000 rw-s 1010dd000 00:05 1886                      /dev/dri/card0
Size:              13056 kB
Rss:                   0 kB
Pss:                   0 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         0 kB
Referenced:            0 kB
Anonymous:             0 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd wr sh mr mw me ms pf io de dd 
7ff0e4a67000-7ff0e4aa7000 rw-s 1023cf000 00:05 1886                      /dev/dri/card0
Size:                256 kB
Rss:                   0 kB
Pss:                   0 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         0 kB
Referenced:            0 kB
Anonymous:             0 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd wr sh mr mw me ms pf io de dd 
7ff0e4aa7000-7ff0e4ae7000 rw-s 00000000 00:04 16971                      /drm mm object (deleted)
Size:                256 kB
Rss:                  88 kB
Pss:                  88 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:        88 kB
Referenced:           88 kB
Anonymous:             0 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd wr sh mr mw me ms 
7ff0e4ae7000-7ff0e4b67000 rw-s 00000000 00:04 2129924                    /SYSV00000000 (deleted)
Size:                512 kB
Rss:                   4 kB
Pss:                   2 kB
Shared_Clean:          0 kB
Shared_Dirty:          4 kB
Private_Clean:         0 kB
Private_Dirty:         0 kB
Referenced:            4 kB
Anonymous:             0 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd wr sh mr mw me ms 
7ff0e4b67000-7ff0e5827000 rw-s 1003dd000 00:05 1886                      /dev/dri/card0
Size:              13056 kB
Rss:                   0 kB
Pss:                   0 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         0 kB
Referenced:            0 kB
Anonymous:             0 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd wr sh mr mw me ms pf io de dd 
7ff0e5827000-7ff0e5a07000 rw-s 1001fa000 00:05 1886                      /dev/dri/card0
Size:               1920 kB
Rss:                   0 kB
Pss:                   0 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         0 kB
Referenced:            0 kB
Anonymous:             0 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd wr sh mr mw me ms pf io de dd 
7ff0e5a09000-7ff0e5a0b000 rw-s 00000000 00:04 16851                      /drm mm object (deleted)
Size:                  8 kB
Rss:                   8 kB
Pss:                   8 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         8 kB
Referenced:            8 kB
Anonymous:             0 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd wr sh mr mw me ms 
7ff0e5a18000-7ff0e5a1d000 rw-s 101fe6000 00:05 1886                      /dev/dri/card0
Size:                 20 kB
Rss:                   0 kB
Pss:                   0 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         0 kB
Referenced:            0 kB
Anonymous:             0 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd wr sh mr mw me ms pf io de dd 
7ff0e5a1d000-7ff0e5a2c000 rw-s 101e72000 00:05 1886                      /dev/dri/card0
Size:                 60 kB
Rss:                   0 kB
Pss:                   0 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         0 kB
Referenced:            0 kB
Anonymous:             0 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd wr sh mr mw me ms pf io de dd 
7ff0e5a2c000-7ff0e5a3b000 rw-s 101e63000 00:05 1886                      /dev/dri/card0
Size:                 60 kB
Rss:                   0 kB
Pss:                   0 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         0 kB
Referenced:            0 kB
Anonymous:             0 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd wr sh mr mw me ms pf io de dd 
7ff0e5afb000-7ff0e5b5b000 rw-s 00000000 00:04 1900549                    /SYSV00000000 (deleted)
Size:                384 kB
Rss:                 216 kB
Pss:                 108 kB
Shared_Clean:          0 kB
Shared_Dirty:        216 kB
Private_Clean:         0 kB
Private_Dirty:         0 kB
Referenced:           72 kB
Anonymous:             0 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd wr sh mr mw me ms 
7ff0e5b5b000-7ff0e5b9b000 rw-s 00000000 00:04 17496                      /drm mm object (deleted)
Size:                256 kB
Rss:                  12 kB
Pss:                  12 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:        12 kB
Referenced:           12 kB
Anonymous:             0 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd wr sh mr mw me ms 
7ff0e5b9b000-7ff0e5bfb000 rw-s 00000000 00:04 1736706                    /SYSV00000000 (deleted)
Size:                384 kB
Rss:                 352 kB
Pss:                 176 kB
Shared_Clean:          0 kB
Shared_Dirty:        352 kB
Private_Clean:         0 kB
Private_Dirty:         0 kB
Referenced:          160 kB
Anonymous:             0 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd wr sh mr mw me ms 
7ff0e5bfb000-7ff0e5c3b000 rw-s 00000000 00:04 14843                      /drm mm object (deleted)
Size:                256 kB
Rss:                  24 kB
Pss:                  24 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:        24 kB
Referenced:            0 kB
Anonymous:             0 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd wr sh mr mw me ms 
7ff0e5c3b000-7ff0e5c9b000 rw-s 00000000 00:04 1671171                    /SYSV00000000 (deleted)
Size:                384 kB
Rss:                  88 kB
Pss:                  44 kB
Shared_Clean:          0 kB
Shared_Dirty:         88 kB
Private_Clean:         0 kB
Private_Dirty:         0 kB
Referenced:            0 kB
Anonymous:             0 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd wr sh mr mw me ms 
7ff0e5c9b000-7ff0e5d1b000 rw-s 00000000 00:04 5734407                    /SYSV00000000 (deleted)
Size:                512 kB
Rss:                   4 kB
Pss:                   2 kB
Shared_Clean:          0 kB
Shared_Dirty:          4 kB
Private_Clean:         0 kB
Private_Dirty:         0 kB
Referenced:            4 kB
Anonymous:             0 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd wr sh mr mw me ms 
7ff0e5d1b000-7ff0e5d7b000 rw-s 00000000 00:04 1343489                    /SYSV00000000 (deleted)
Size:                384 kB
Rss:                 340 kB
Pss:                 170 kB
Shared_Clean:          0 kB
Shared_Dirty:        340 kB
Private_Clean:         0 kB
Private_Dirty:         0 kB
Referenced:           80 kB
Anonymous:             0 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd wr sh mr mw me ms 
7ff0e5d7b000-7ff0e5f5b000 rw-s 100000000 00:05 1886                      /dev/dri/card0
Size:               1920 kB
Rss:                   0 kB
Pss:                   0 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         0 kB
Referenced:            0 kB
Anonymous:             0 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd wr sh mr mw me ms pf io de dd 
7ff0e5f5b000-7ff0e5fbb000 rw-s 00000000 00:04 1310720                    /SYSV00000000 (deleted)
Size:                384 kB
Rss:                 384 kB
Pss:                 192 kB
Shared_Clean:          0 kB
Shared_Dirty:        384 kB
Private_Clean:         0 kB
Private_Dirty:         0 kB
Referenced:            0 kB
Anonymous:             0 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd wr sh mr mw me ms 
7ff0e5fbb000-7ff0e5fca000 r-xp 00000000 fe:00 53346690                   /usr/lib64/xorg/modules/input/synaptics_drv.so
Size:                 60 kB
Rss:                  56 kB
Pss:                  56 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:        56 kB
Private_Dirty:         0 kB
Referenced:           16 kB
Anonymous:             0 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd ex mr mw me 
7ff0e5fca000-7ff0e61c9000 ---p 0000f000 fe:00 53346690                   /usr/lib64/xorg/modules/input/synaptics_drv.so
Size:               2044 kB
Rss:                   0 kB
Pss:                   0 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         0 kB
Referenced:            0 kB
Anonymous:             0 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: mr mw me 
7ff0e61c9000-7ff0e61ca000 r--p 0000e000 fe:00 53346690                   /usr/lib64/xorg/modules/input/synaptics_drv.so
Size:                  4 kB
Rss:                   4 kB
Pss:                   4 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         4 kB
Referenced:            4 kB
Anonymous:             4 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd mr mw me ac 
7ff0e61ca000-7ff0e61cb000 rw-p 0000f000 fe:00 53346690                   /usr/lib64/xorg/modules/input/synaptics_drv.so
Size:                  4 kB
Rss:                   4 kB
Pss:                   4 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         4 kB
Referenced:            4 kB
Anonymous:             4 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd wr mr mw me ac 
7ff0e61cb000-7ff0e61d0000 r-xp 00000000 fe:00 53085993                   /usr/lib64/libmtdev.so.1.0.0
Size:                 20 kB
Rss:                  16 kB
Pss:                  16 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:        16 kB
Private_Dirty:         0 kB
Referenced:            4 kB
Anonymous:             0 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd ex mr mw me 
7ff0e61d0000-7ff0e63cf000 ---p 00005000 fe:00 53085993                   /usr/lib64/libmtdev.so.1.0.0
Size:               2044 kB
Rss:                   0 kB
Pss:                   0 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         0 kB
Referenced:            0 kB
Anonymous:             0 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: mr mw me 
7ff0e63cf000-7ff0e63d0000 r--p 00004000 fe:00 53085993                   /usr/lib64/libmtdev.so.1.0.0
Size:                  4 kB
Rss:                   4 kB
Pss:                   4 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         4 kB
Referenced:            0 kB
Anonymous:             4 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd mr mw me ac 
7ff0e63d0000-7ff0e63d1000 rw-p 00005000 fe:00 53085993                   /usr/lib64/libmtdev.so.1.0.0
Size:                  4 kB
Rss:                   4 kB
Pss:                   4 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         4 kB
Referenced:            4 kB
Anonymous:             4 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd wr mr mw me ac 
7ff0e63d1000-7ff0e63de000 r-xp 00000000 fe:00 53346688                   /usr/lib64/xorg/modules/input/evdev_drv.so
Size:                 52 kB
Rss:                  48 kB
Pss:                  48 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:        48 kB
Private_Dirty:         0 kB
Referenced:           20 kB
Anonymous:             0 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd ex mr mw me 
7ff0e63de000-7ff0e65dd000 ---p 0000d000 fe:00 53346688                   /usr/lib64/xorg/modules/input/evdev_drv.so
Size:               2044 kB
Rss:                   0 kB
Pss:                   0 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         0 kB
Referenced:            0 kB
Anonymous:             0 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: mr mw me 
7ff0e65dd000-7ff0e65de000 r--p 0000c000 fe:00 53346688                   /usr/lib64/xorg/modules/input/evdev_drv.so
Size:                  4 kB
Rss:                   4 kB
Pss:                   4 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         4 kB
Referenced:            4 kB
Anonymous:             4 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd mr mw me ac 
7ff0e65de000-7ff0e65df000 rw-p 0000d000 fe:00 53346688                   /usr/lib64/xorg/modules/input/evdev_drv.so
Size:                  4 kB
Rss:                   4 kB
Pss:                   4 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         4 kB
Referenced:            4 kB
Anonymous:             4 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd wr mr mw me ac 
7ff0e65df000-7ff0e6635000 rw-p 00000000 00:00 0 
Size:                344 kB
Rss:                 336 kB
Pss:                 336 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:       336 kB
Referenced:           48 kB
Anonymous:           336 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd wr mr mw me ac 
7ff0e6635000-7ff0e6637000 rw-s 102304000 00:05 1886                      /dev/dri/card0
Size:                  8 kB
Rss:                   0 kB
Pss:                   0 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         0 kB
Referenced:            0 kB
Anonymous:             0 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd wr sh mr mw me ms pf io de dd 
7ff0e6637000-7ff0e6639000 rw-s 00000000 00:04 16817                      /drm mm object (deleted)
Size:                  8 kB
Rss:                   8 kB
Pss:                   8 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         8 kB
Referenced:            8 kB
Anonymous:             0 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd wr sh mr mw me ms 
7ff0e6639000-7ff0e663d000 rw-s 102348000 00:05 1886                      /dev/dri/card0
Size:                 16 kB
Rss:                   0 kB
Pss:                   0 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         0 kB
Referenced:            0 kB
Anonymous:             0 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd wr sh mr mw me ms pf io de dd 
7ff0e663d000-7ff0e6691000 rw-p 00000000 00:00 0 
Size:                336 kB
Rss:                   4 kB
Pss:                   4 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         4 kB
Referenced:            0 kB
Anonymous:             4 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd wr mr mw me ac 
7ff0e6691000-7ff0e677b000 r-xp 00000000 fe:00 53084999                   /usr/lib64/libstdc++.so.6.0.18
Size:                936 kB
Rss:                 116 kB
Pss:                  38 kB
Shared_Clean:        116 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         0 kB
Referenced:          116 kB
Anonymous:             0 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd ex mr mw me 
7ff0e677b000-7ff0e697a000 ---p 000ea000 fe:00 53084999                   /usr/lib64/libstdc++.so.6.0.18
Size:               2044 kB
Rss:                   0 kB
Pss:                   0 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         0 kB
Referenced:            0 kB
Anonymous:             0 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: mr mw me 
7ff0e697a000-7ff0e6982000 r--p 000e9000 fe:00 53084999                   /usr/lib64/libstdc++.so.6.0.18
Size:                 32 kB
Rss:                  32 kB
Pss:                  32 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:        32 kB
Referenced:            0 kB
Anonymous:            32 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd mr mw me ac 
7ff0e6982000-7ff0e6984000 rw-p 000f1000 fe:00 53084999                   /usr/lib64/libstdc++.so.6.0.18
Size:                  8 kB
Rss:                   8 kB
Pss:                   8 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         8 kB
Referenced:            0 kB
Anonymous:             8 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd wr mr mw me ac 
7ff0e6984000-7ff0e6999000 rw-p 00000000 00:00 0 
Size:                 84 kB
Rss:                  12 kB
Pss:                  12 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:        12 kB
Referenced:            0 kB
Anonymous:            12 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd wr mr mw me ac 
7ff0e6999000-7ff0e69c0000 r-xp 00000000 fe:00 53084377                   /usr/lib64/libexpat.so.1.6.0
Size:                156 kB
Rss:                 108 kB
Pss:                   8 kB
Shared_Clean:        108 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         0 kB
Referenced:          108 kB
Anonymous:             0 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd ex mr mw me 
7ff0e69c0000-7ff0e6bc0000 ---p 00027000 fe:00 53084377                   /usr/lib64/libexpat.so.1.6.0
Size:               2048 kB
Rss:                   0 kB
Pss:                   0 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         0 kB
Referenced:            0 kB
Anonymous:             0 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: mr mw me 
7ff0e6bc0000-7ff0e6bc2000 r--p 00027000 fe:00 53084377                   /usr/lib64/libexpat.so.1.6.0
Size:                  8 kB
Rss:                   8 kB
Pss:                   8 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         8 kB
Referenced:            0 kB
Anonymous:             8 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd mr mw me ac 
7ff0e6bc2000-7ff0e6bc3000 rw-p 00029000 fe:00 53084377                   /usr/lib64/libexpat.so.1.6.0
Size:                  4 kB
Rss:                   4 kB
Pss:                   4 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         4 kB
Referenced:            0 kB
Anonymous:             4 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd wr mr mw me ac 
7ff0e6bc3000-7ff0e6f97000 r-xp 00000000 fe:00 53085461                   /usr/lib64/libdricore9.2.2.so.1.0.0
Size:               3920 kB
Rss:                   0 kB
Pss:                   0 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         0 kB
Referenced:            0 kB
Anonymous:             0 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd ex mr mw me 
7ff0e6f97000-7ff0e7197000 ---p 003d4000 fe:00 53085461                   /usr/lib64/libdricore9.2.2.so.1.0.0
Size:               2048 kB
Rss:                   0 kB
Pss:                   0 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         0 kB
Referenced:            0 kB
Anonymous:             0 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: mr mw me 
7ff0e7197000-7ff0e71a9000 r--p 003d4000 fe:00 53085461                   /usr/lib64/libdricore9.2.2.so.1.0.0
Size:                 72 kB
Rss:                  72 kB
Pss:                  72 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:        72 kB
Referenced:            0 kB
Anonymous:            72 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd mr mw me ac 
7ff0e71a9000-7ff0e71b4000 rw-p 003e6000 fe:00 53085461                   /usr/lib64/libdricore9.2.2.so.1.0.0
Size:                 44 kB
Rss:                  44 kB
Pss:                  44 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:        44 kB
Referenced:            0 kB
Anonymous:            44 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd wr mr mw me ac 
7ff0e71b4000-7ff0e71cc000 rw-p 00000000 00:00 0 
Size:                 96 kB
Rss:                   8 kB
Pss:                   8 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         8 kB
Referenced:            0 kB
Anonymous:             8 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd wr mr mw me ac 
7ff0e71cc000-7ff0e721a000 r-xp 00000000 fe:00 54132745                   /usr/lib64/dri/i915_dri.so
Size:                312 kB
Rss:                   0 kB
Pss:                   0 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         0 kB
Referenced:            0 kB
Anonymous:             0 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd ex mr mw me 
7ff0e721a000-7ff0e7419000 ---p 0004e000 fe:00 54132745                   /usr/lib64/dri/i915_dri.so
Size:               2044 kB
Rss:                   0 kB
Pss:                   0 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         0 kB
Referenced:            0 kB
Anonymous:             0 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: mr mw me 
7ff0e7419000-7ff0e741a000 r--p 0004d000 fe:00 54132745                   /usr/lib64/dri/i915_dri.so
Size:                  4 kB
Rss:                   4 kB
Pss:                   4 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         4 kB
Referenced:            0 kB
Anonymous:             4 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd mr mw me ac 
7ff0e741a000-7ff0e741b000 rw-p 0004e000 fe:00 54132745                   /usr/lib64/dri/i915_dri.so
Size:                  4 kB
Rss:                   4 kB
Pss:                   4 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         4 kB
Referenced:            0 kB
Anonymous:             4 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd wr mr mw me ac 
7ff0e741b000-7ff0e743a000 r-xp 00000000 fe:00 53088887                   /usr/lib64/libdrm_intel.so.1.0.0
Size:                124 kB
Rss:                   0 kB
Pss:                   0 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         0 kB
Referenced:            0 kB
Anonymous:             0 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd ex mr mw me 
7ff0e743a000-7ff0e7639000 ---p 0001f000 fe:00 53088887                   /usr/lib64/libdrm_intel.so.1.0.0
Size:               2044 kB
Rss:                   0 kB
Pss:                   0 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         0 kB
Referenced:            0 kB
Anonymous:             0 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: mr mw me 
7ff0e7639000-7ff0e763a000 r--p 0001e000 fe:00 53088887                   /usr/lib64/libdrm_intel.so.1.0.0
Size:                  4 kB
Rss:                   4 kB
Pss:                   4 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         4 kB
Referenced:            0 kB
Anonymous:             4 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd mr mw me ac 
7ff0e763a000-7ff0e763b000 rw-p 0001f000 fe:00 53088887                   /usr/lib64/libdrm_intel.so.1.0.0
Size:                  4 kB
Rss:                   4 kB
Pss:                   4 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         4 kB
Referenced:            0 kB
Anonymous:             4 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd wr mr mw me ac 
7ff0e763b000-7ff0e7789000 r-xp 00000000 fe:00 53347441                   /usr/lib64/xorg/modules/drivers/intel_drv.so
Size:               1336 kB
Rss:                 676 kB
Pss:                 676 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:       676 kB
Private_Dirty:         0 kB
Referenced:          184 kB
Anonymous:             0 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd ex mr mw me 
7ff0e7789000-7ff0e7989000 ---p 0014e000 fe:00 53347441                   /usr/lib64/xorg/modules/drivers/intel_drv.so
Size:               2048 kB
Rss:                   0 kB
Pss:                   0 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         0 kB
Referenced:            0 kB
Anonymous:             0 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: mr mw me 
7ff0e7989000-7ff0e798d000 r--p 0014e000 fe:00 53347441                   /usr/lib64/xorg/modules/drivers/intel_drv.so
Size:                 16 kB
Rss:                  16 kB
Pss:                  16 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:        16 kB
Referenced:           12 kB
Anonymous:            16 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd mr mw me ac 
7ff0e798d000-7ff0e7991000 rw-p 00152000 fe:00 53347441                   /usr/lib64/xorg/modules/drivers/intel_drv.so
Size:                 16 kB
Rss:                  16 kB
Pss:                  16 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:        16 kB
Referenced:           16 kB
Anonymous:            16 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd wr mr mw me ac 
7ff0e7991000-7ff0e79fa000 r-xp 00000000 fe:00 53346307                   /usr/lib64/xorg/modules/extensions/libglx.so
Size:                420 kB
Rss:                  96 kB
Pss:                  96 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:        96 kB
Private_Dirty:         0 kB
Referenced:           36 kB
Anonymous:             0 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd ex mr mw me 
7ff0e79fa000-7ff0e7bf9000 ---p 00069000 fe:00 53346307                   /usr/lib64/xorg/modules/extensions/libglx.so
Size:               2044 kB
Rss:                   0 kB
Pss:                   0 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         0 kB
Referenced:            0 kB
Anonymous:             0 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: mr mw me 
7ff0e7bf9000-7ff0e7bfa000 r--p 00068000 fe:00 53346307                   /usr/lib64/xorg/modules/extensions/libglx.so
Size:                  4 kB
Rss:                   4 kB
Pss:                   4 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         4 kB
Referenced:            4 kB
Anonymous:             4 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd mr mw me ac 
7ff0e7bfa000-7ff0e7bfd000 rw-p 00069000 fe:00 53346307                   /usr/lib64/xorg/modules/extensions/libglx.so
Size:                 12 kB
Rss:                  12 kB
Pss:                  12 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:        12 kB
Referenced:            8 kB
Anonymous:            12 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd wr mr mw me ac 
7ff0e7bfd000-7ff0e7bff000 rw-p 00000000 00:00 0 
Size:                  8 kB
Rss:                   4 kB
Pss:                   4 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         4 kB
Referenced:            4 kB
Anonymous:             4 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd wr mr mw me ac 
7ff0e7bff000-7ff0e7c04000 r-xp 00000000 fe:00 53084593                   /usr/lib64/libXxf86vm.so.1.0.0
Size:                 20 kB
Rss:                   4 kB
Pss:                   0 kB
Shared_Clean:          4 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         0 kB
Referenced:            4 kB
Anonymous:             0 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd ex mr mw me 
7ff0e7c04000-7ff0e7e03000 ---p 00005000 fe:00 53084593                   /usr/lib64/libXxf86vm.so.1.0.0
Size:               2044 kB
Rss:                   0 kB
Pss:                   0 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         0 kB
Referenced:            0 kB
Anonymous:             0 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: mr mw me 
7ff0e7e03000-7ff0e7e04000 r--p 00004000 fe:00 53084593                   /usr/lib64/libXxf86vm.so.1.0.0
Size:                  4 kB
Rss:                   4 kB
Pss:                   4 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         4 kB
Referenced:            0 kB
Anonymous:             4 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd mr mw me ac 
7ff0e7e04000-7ff0e7e05000 rw-p 00005000 fe:00 53084593                   /usr/lib64/libXxf86vm.so.1.0.0
Size:                  4 kB
Rss:                   4 kB
Pss:                   4 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         4 kB
Referenced:            0 kB
Anonymous:             4 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd wr mr mw me ac 
7ff0e7e05000-7ff0e7e1b000 r-xp 00000000 fe:00 53087687                   /usr/lib64/libxcb-glx.so.0.0.0
Size:                 88 kB
Rss:                  12 kB
Pss:                   0 kB
Shared_Clean:         12 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         0 kB
Referenced:           12 kB
Anonymous:             0 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd ex mr mw me 
7ff0e7e1b000-7ff0e801a000 ---p 00016000 fe:00 53087687                   /usr/lib64/libxcb-glx.so.0.0.0
Size:               2044 kB
Rss:                   0 kB
Pss:                   0 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         0 kB
Referenced:            0 kB
Anonymous:             0 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: mr mw me 
7ff0e801a000-7ff0e801c000 r--p 00015000 fe:00 53087687                   /usr/lib64/libxcb-glx.so.0.0.0
Size:                  8 kB
Rss:                   8 kB
Pss:                   8 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         8 kB
Referenced:            0 kB
Anonymous:             8 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd mr mw me ac 
7ff0e801c000-7ff0e801d000 rw-p 00017000 fe:00 53087687                   /usr/lib64/libxcb-glx.so.0.0.0
Size:                  4 kB
Rss:                   4 kB
Pss:                   4 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         4 kB
Referenced:            0 kB
Anonymous:             4 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd wr mr mw me ac 
7ff0e801d000-7ff0e8022000 r-xp 00000000 fe:00 53084385                   /usr/lib64/libXfixes.so.3.1.0
Size:                 20 kB
Rss:                   8 kB
Pss:                   0 kB
Shared_Clean:          8 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         0 kB
Referenced:            8 kB
Anonymous:             0 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd ex mr mw me 
7ff0e8022000-7ff0e8221000 ---p 00005000 fe:00 53084385                   /usr/lib64/libXfixes.so.3.1.0
Size:               2044 kB
Rss:                   0 kB
Pss:                   0 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         0 kB
Referenced:            0 kB
Anonymous:             0 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: mr mw me 
7ff0e8221000-7ff0e8222000 r--p 00004000 fe:00 53084385                   /usr/lib64/libXfixes.so.3.1.0
Size:                  4 kB
Rss:                   4 kB
Pss:                   4 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         4 kB
Referenced:            0 kB
Anonymous:             4 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd mr mw me ac 
7ff0e8222000-7ff0e8223000 rw-p 00005000 fe:00 53084385                   /usr/lib64/libXfixes.so.3.1.0
Size:                  4 kB
Rss:                   4 kB
Pss:                   4 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         4 kB
Referenced:            0 kB
Anonymous:             4 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd wr mr mw me ac 
7ff0e8223000-7ff0e8225000 r-xp 00000000 fe:00 53086963                   /usr/lib64/libXdamage.so.1.1.0
Size:                  8 kB
Rss:                   4 kB
Pss:                   0 kB
Shared_Clean:          4 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         0 kB
Referenced:            4 kB
Anonymous:             0 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd ex mr mw me 
7ff0e8225000-7ff0e8424000 ---p 00002000 fe:00 53086963                   /usr/lib64/libXdamage.so.1.1.0
Size:               2044 kB
Rss:                   0 kB
Pss:                   0 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         0 kB
Referenced:            0 kB
Anonymous:             0 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: mr mw me 
7ff0e8424000-7ff0e8425000 r--p 00001000 fe:00 53086963                   /usr/lib64/libXdamage.so.1.1.0
Size:                  4 kB
Rss:                   4 kB
Pss:                   4 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         4 kB
Referenced:            0 kB
Anonymous:             4 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd mr mw me ac 
7ff0e8425000-7ff0e8426000 rw-p 00002000 fe:00 53086963                   /usr/lib64/libXdamage.so.1.1.0
Size:                  4 kB
Rss:                   4 kB
Pss:                   4 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         4 kB
Referenced:            0 kB
Anonymous:             4 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd wr mr mw me ac 
7ff0e8426000-7ff0e8437000 r-xp 00000000 fe:00 53084247                   /usr/lib64/libXext.so.6.4.0
Size:                 68 kB
Rss:                  16 kB
Pss:                   0 kB
Shared_Clean:         16 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         0 kB
Referenced:           16 kB
Anonymous:             0 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd ex mr mw me 
7ff0e8437000-7ff0e8636000 ---p 00011000 fe:00 53084247                   /usr/lib64/libXext.so.6.4.0
Size:               2044 kB
Rss:                   0 kB
Pss:                   0 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         0 kB
Referenced:            0 kB
Anonymous:             0 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: mr mw me 
7ff0e8636000-7ff0e8637000 r--p 00010000 fe:00 53084247                   /usr/lib64/libXext.so.6.4.0
Size:                  4 kB
Rss:                   4 kB
Pss:                   4 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         4 kB
Referenced:            0 kB
Anonymous:             4 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd mr mw me ac 
7ff0e8637000-7ff0e8638000 rw-p 00011000 fe:00 53084247                   /usr/lib64/libXext.so.6.4.0
Size:                  4 kB
Rss:                   4 kB
Pss:                   4 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         4 kB
Referenced:            0 kB
Anonymous:             4 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd wr mr mw me ac 
7ff0e8638000-7ff0e8659000 r-xp 00000000 fe:00 53084342                   /usr/lib64/libglapi.so.0.0.0
Size:                132 kB
Rss:                   4 kB
Pss:                   0 kB
Shared_Clean:          4 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         0 kB
Referenced:            4 kB
Anonymous:             0 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd ex mr mw me 
7ff0e8659000-7ff0e8859000 ---p 00021000 fe:00 53084342                   /usr/lib64/libglapi.so.0.0.0
Size:               2048 kB
Rss:                   0 kB
Pss:                   0 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         0 kB
Referenced:            0 kB
Anonymous:             0 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: mr mw me 
7ff0e8859000-7ff0e885c000 r--p 00021000 fe:00 53084342                   /usr/lib64/libglapi.so.0.0.0
Size:                 12 kB
Rss:                  12 kB
Pss:                  12 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:        12 kB
Referenced:            0 kB
Anonymous:            12 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd mr mw me ac 
7ff0e885c000-7ff0e885d000 rw-p 00024000 fe:00 53084342                   /usr/lib64/libglapi.so.0.0.0
Size:                  4 kB
Rss:                   4 kB
Pss:                   4 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         4 kB
Referenced:            0 kB
Anonymous:             4 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd wr mr mw me ac 
7ff0e885d000-7ff0e885e000 rw-p 00000000 00:00 0 
Size:                  4 kB
Rss:                   0 kB
Pss:                   0 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         0 kB
Referenced:            0 kB
Anonymous:             0 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd wr mr mw me ac 
7ff0e885e000-7ff0e8865000 r-xp 00000000 fe:00 53085002                   /usr/lib64/libffi.so.4.0.1
Size:                 28 kB
Rss:                   8 kB
Pss:                   0 kB
Shared_Clean:          8 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         0 kB
Referenced:            8 kB
Anonymous:             0 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd ex mr mw me 
7ff0e8865000-7ff0e8a64000 ---p 00007000 fe:00 53085002                   /usr/lib64/libffi.so.4.0.1
Size:               2044 kB
Rss:                   0 kB
Pss:                   0 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         0 kB
Referenced:            0 kB
Anonymous:             0 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: mr mw me 
7ff0e8a64000-7ff0e8a65000 r--p 00006000 fe:00 53085002                   /usr/lib64/libffi.so.4.0.1
Size:                  4 kB
Rss:                   4 kB
Pss:                   4 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         4 kB
Referenced:            0 kB
Anonymous:             4 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd mr mw me ac 
7ff0e8a65000-7ff0e8a66000 rw-p 00007000 fe:00 53085002                   /usr/lib64/libffi.so.4.0.1
Size:                  4 kB
Rss:                   4 kB
Pss:                   4 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         4 kB
Referenced:            0 kB
Anonymous:             4 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd wr mr mw me ac 
7ff0e8a66000-7ff0e8ac2000 r-xp 00000000 fe:00 53085199                   /usr/lib64/libGL.so.1.2.0
Size:                368 kB
Rss:                  20 kB
Pss:                   1 kB
Shared_Clean:         20 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         0 kB
Referenced:           20 kB
Anonymous:             0 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd ex mr mw me 
7ff0e8ac2000-7ff0e8cc1000 ---p 0005c000 fe:00 53085199                   /usr/lib64/libGL.so.1.2.0
Size:               2044 kB
Rss:                   0 kB
Pss:                   0 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         0 kB
Referenced:            0 kB
Anonymous:             0 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: mr mw me 
7ff0e8cc1000-7ff0e8cc3000 r--p 0005b000 fe:00 53085199                   /usr/lib64/libGL.so.1.2.0
Size:                  8 kB
Rss:                   8 kB
Pss:                   8 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         8 kB
Referenced:            0 kB
Anonymous:             8 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd mr mw me ac 
7ff0e8cc3000-7ff0e8cc4000 rw-p 0005d000 fe:00 53085199                   /usr/lib64/libGL.so.1.2.0
Size:                  4 kB
Rss:                   4 kB
Pss:                   4 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         4 kB
Referenced:            0 kB
Anonymous:             4 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd wr mr mw me ac 
7ff0e8cc4000-7ff0e8cc5000 rw-p 00000000 00:00 0 
Size:                  4 kB
Rss:                   0 kB
Pss:                   0 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         0 kB
Referenced:            0 kB
Anonymous:             0 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd wr mr mw me ac 
7ff0e8cc5000-7ff0e8cd3000 r-xp 00000000 fe:00 53087895                   /usr/lib64/libwayland-server.so.0.1.0
Size:                 56 kB
Rss:                   8 kB
Pss:                   0 kB
Shared_Clean:          8 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         0 kB
Referenced:            8 kB
Anonymous:             0 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd ex mr mw me 
7ff0e8cd3000-7ff0e8ed2000 ---p 0000e000 fe:00 53087895                   /usr/lib64/libwayland-server.so.0.1.0
Size:               2044 kB
Rss:                   0 kB
Pss:                   0 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         0 kB
Referenced:            0 kB
Anonymous:             0 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: mr mw me 
7ff0e8ed2000-7ff0e8ed4000 r--p 0000d000 fe:00 53087895                   /usr/lib64/libwayland-server.so.0.1.0
Size:                  8 kB
Rss:                   8 kB
Pss:                   8 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         8 kB
Referenced:            0 kB
Anonymous:             8 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd mr mw me ac 
7ff0e8ed4000-7ff0e8ed5000 rw-p 0000f000 fe:00 53087895                   /usr/lib64/libwayland-server.so.0.1.0
Size:                  4 kB
Rss:                   4 kB
Pss:                   4 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         4 kB
Referenced:            0 kB
Anonymous:             4 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd wr mr mw me ac 
7ff0e8ed5000-7ff0e8ee0000 r-xp 00000000 fe:00 53087857                   /usr/lib64/libwayland-client.so.0.1.0
Size:                 44 kB
Rss:                   8 kB
Pss:                   0 kB
Shared_Clean:          8 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         0 kB
Referenced:            8 kB
Anonymous:             0 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd ex mr mw me 
7ff0e8ee0000-7ff0e90df000 ---p 0000b000 fe:00 53087857                   /usr/lib64/libwayland-client.so.0.1.0
Size:               2044 kB
Rss:                   0 kB
Pss:                   0 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         0 kB
Referenced:            0 kB
Anonymous:             0 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: mr mw me 
7ff0e90df000-7ff0e90e1000 r--p 0000a000 fe:00 53087857                   /usr/lib64/libwayland-client.so.0.1.0
Size:                  8 kB
Rss:                   8 kB
Pss:                   8 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         8 kB
Referenced:            0 kB
Anonymous:             8 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd mr mw me ac 
7ff0e90e1000-7ff0e90e2000 rw-p 0000c000 fe:00 53087857                   /usr/lib64/libwayland-client.so.0.1.0
Size:                  4 kB
Rss:                   4 kB
Pss:                   4 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         4 kB
Referenced:            0 kB
Anonymous:             4 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd wr mr mw me ac 
7ff0e90e2000-7ff0e9100000 r-xp 00000000 fe:00 53084548                   /usr/lib64/libxcb.so.1.1.0
Size:                120 kB
Rss:                  28 kB
Pss:                   1 kB
Shared_Clean:         28 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         0 kB
Referenced:           28 kB
Anonymous:             0 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd ex mr mw me 
7ff0e9100000-7ff0e92ff000 ---p 0001e000 fe:00 53084548                   /usr/lib64/libxcb.so.1.1.0
Size:               2044 kB
Rss:                   0 kB
Pss:                   0 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         0 kB
Referenced:            0 kB
Anonymous:             0 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: mr mw me 
7ff0e92ff000-7ff0e9300000 r--p 0001d000 fe:00 53084548                   /usr/lib64/libxcb.so.1.1.0
Size:                  4 kB
Rss:                   4 kB
Pss:                   4 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         4 kB
Referenced:            0 kB
Anonymous:             4 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd mr mw me ac 
7ff0e9300000-7ff0e9301000 rw-p 0001e000 fe:00 53084548                   /usr/lib64/libxcb.so.1.1.0
Size:                  4 kB
Rss:                   4 kB
Pss:                   4 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         4 kB
Referenced:            0 kB
Anonymous:             4 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd wr mr mw me ac 
7ff0e9301000-7ff0e9306000 r-xp 00000000 fe:00 53087187                   /usr/lib64/libxcb-xfixes.so.0.0.0
Size:                 20 kB
Rss:                   8 kB
Pss:                   0 kB
Shared_Clean:          8 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         0 kB
Referenced:            8 kB
Anonymous:             0 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd ex mr mw me 
7ff0e9306000-7ff0e9506000 ---p 00005000 fe:00 53087187                   /usr/lib64/libxcb-xfixes.so.0.0.0
Size:               2048 kB
Rss:                   0 kB
Pss:                   0 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         0 kB
Referenced:            0 kB
Anonymous:             0 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: mr mw me 
7ff0e9506000-7ff0e9507000 r--p 00005000 fe:00 53087187                   /usr/lib64/libxcb-xfixes.so.0.0.0
Size:                  4 kB
Rss:                   4 kB
Pss:                   4 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         4 kB
Referenced:            0 kB
Anonymous:             4 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd mr mw me ac 
7ff0e9507000-7ff0e9508000 rw-p 00006000 fe:00 53087187                   /usr/lib64/libxcb-xfixes.so.0.0.0
Size:                  4 kB
Rss:                   4 kB
Pss:                   4 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         4 kB
Referenced:            0 kB
Anonymous:             4 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd wr mr mw me ac 
7ff0e9508000-7ff0e950c000 r-xp 00000000 fe:00 53087694                   /usr/lib64/libxcb-dri2.so.0.0.0
Size:                 16 kB
Rss:                   8 kB
Pss:                   0 kB
Shared_Clean:          8 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         0 kB
Referenced:            8 kB
Anonymous:             0 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd ex mr mw me 
7ff0e950c000-7ff0e970b000 ---p 00004000 fe:00 53087694                   /usr/lib64/libxcb-dri2.so.0.0.0
Size:               2044 kB
Rss:                   0 kB
Pss:                   0 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         0 kB
Referenced:            0 kB
Anonymous:             0 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: mr mw me 
7ff0e970b000-7ff0e970c000 r--p 00003000 fe:00 53087694                   /usr/lib64/libxcb-dri2.so.0.0.0
Size:                  4 kB
Rss:                   4 kB
Pss:                   4 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         4 kB
Referenced:            0 kB
Anonymous:             4 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd mr mw me ac 
7ff0e970c000-7ff0e970d000 rw-p 00004000 fe:00 53087694                   /usr/lib64/libxcb-dri2.so.0.0.0
Size:                  4 kB
Rss:                   4 kB
Pss:                   4 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         4 kB
Referenced:            0 kB
Anonymous:             4 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd wr mr mw me ac 
7ff0e970d000-7ff0e9845000 r-xp 00000000 fe:00 53085943                   /usr/lib64/libX11.so.6.3.0
Size:               1248 kB
Rss:                 116 kB
Pss:                   6 kB
Shared_Clean:        116 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         0 kB
Referenced:          116 kB
Anonymous:             0 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd ex mr mw me 
7ff0e9845000-7ff0e9a45000 ---p 00138000 fe:00 53085943                   /usr/lib64/libX11.so.6.3.0
Size:               2048 kB
Rss:                   0 kB
Pss:                   0 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         0 kB
Referenced:            0 kB
Anonymous:             0 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: mr mw me 
7ff0e9a45000-7ff0e9a46000 r--p 00138000 fe:00 53085943                   /usr/lib64/libX11.so.6.3.0
Size:                  4 kB
Rss:                   4 kB
Pss:                   4 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         4 kB
Referenced:            0 kB
Anonymous:             4 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd mr mw me ac 
7ff0e9a46000-7ff0e9a4b000 rw-p 00139000 fe:00 53085943                   /usr/lib64/libX11.so.6.3.0
Size:                 20 kB
Rss:                  20 kB
Pss:                  20 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:        20 kB
Referenced:            0 kB
Anonymous:            20 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd wr mr mw me ac 
7ff0e9a4b000-7ff0e9a4c000 r-xp 00000000 fe:00 53085340                   /usr/lib64/libX11-xcb.so.1.0.0
Size:                  4 kB
Rss:                   4 kB
Pss:                   0 kB
Shared_Clean:          4 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         0 kB
Referenced:            4 kB
Anonymous:             0 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd ex mr mw me 
7ff0e9a4c000-7ff0e9c4b000 ---p 00001000 fe:00 53085340                   /usr/lib64/libX11-xcb.so.1.0.0
Size:               2044 kB
Rss:                   0 kB
Pss:                   0 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         0 kB
Referenced:            0 kB
Anonymous:             0 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: mr mw me 
7ff0e9c4b000-7ff0e9c4c000 r--p 00000000 fe:00 53085340                   /usr/lib64/libX11-xcb.so.1.0.0
Size:                  4 kB
Rss:                   4 kB
Pss:                   4 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         4 kB
Referenced:            0 kB
Anonymous:             4 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd mr mw me ac 
7ff0e9c4c000-7ff0e9c4d000 rw-p 00001000 fe:00 53085340                   /usr/lib64/libX11-xcb.so.1.0.0
Size:                  4 kB
Rss:                   4 kB
Pss:                   4 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         4 kB
Referenced:            0 kB
Anonymous:             4 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd wr mr mw me ac 
7ff0e9c4d000-7ff0e9c7f000 r-xp 00000000 fe:00 53085463                   /usr/lib64/libglamor.so.0.0.0
Size:                200 kB
Rss:                  12 kB
Pss:                  12 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:        12 kB
Private_Dirty:         0 kB
Referenced:           12 kB
Anonymous:             0 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd ex mr mw me 
7ff0e9c7f000-7ff0e9e7f000 ---p 00032000 fe:00 53085463                   /usr/lib64/libglamor.so.0.0.0
Size:               2048 kB
Rss:                   0 kB
Pss:                   0 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         0 kB
Referenced:            0 kB
Anonymous:             0 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: mr mw me 
7ff0e9e7f000-7ff0e9e80000 r--p 00032000 fe:00 53085463                   /usr/lib64/libglamor.so.0.0.0
Size:                  4 kB
Rss:                   4 kB
Pss:                   4 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         4 kB
Referenced:            0 kB
Anonymous:             4 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd mr mw me ac 
7ff0e9e80000-7ff0e9e81000 rw-p 00033000 fe:00 53085463                   /usr/lib64/libglamor.so.0.0.0
Size:                  4 kB
Rss:                   4 kB
Pss:                   4 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         4 kB
Referenced:            0 kB
Anonymous:             4 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd wr mr mw me ac 
7ff0e9e81000-7ff0e9e89000 rw-p 00000000 00:00 0 
Size:                 32 kB
Rss:                   0 kB
Pss:                   0 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         0 kB
Referenced:            0 kB
Anonymous:             0 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd wr mr mw me ac 
7ff0e9e89000-7ff0e9e8f000 r-xp 00000000 fe:00 53089212                   /usr/lib64/libgbm.so.1.0.0
Size:                 24 kB
Rss:                   8 kB
Pss:                   0 kB
Shared_Clean:          8 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         0 kB
Referenced:            8 kB
Anonymous:             0 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd ex mr mw me 
7ff0e9e8f000-7ff0ea08e000 ---p 00006000 fe:00 53089212                   /usr/lib64/libgbm.so.1.0.0
Size:               2044 kB
Rss:                   0 kB
Pss:                   0 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         0 kB
Referenced:            0 kB
Anonymous:             0 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: mr mw me 
7ff0ea08e000-7ff0ea08f000 r--p 00005000 fe:00 53089212                   /usr/lib64/libgbm.so.1.0.0
Size:                  4 kB
Rss:                   4 kB
Pss:                   4 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         4 kB
Referenced:            0 kB
Anonymous:             4 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd mr mw me ac 
7ff0ea08f000-7ff0ea090000 rw-p 00006000 fe:00 53089212                   /usr/lib64/libgbm.so.1.0.0
Size:                  4 kB
Rss:                   4 kB
Pss:                   4 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         4 kB
Referenced:            0 kB
Anonymous:             4 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd wr mr mw me ac 
7ff0ea090000-7ff0ea0af000 r-xp 00000000 fe:00 53084170                   /usr/lib64/libEGL.so.1.0.0
Size:                124 kB
Rss:                   8 kB
Pss:                   0 kB
Shared_Clean:          8 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         0 kB
Referenced:            8 kB
Anonymous:             0 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd ex mr mw me 
7ff0ea0af000-7ff0ea2af000 ---p 0001f000 fe:00 53084170                   /usr/lib64/libEGL.so.1.0.0
Size:               2048 kB
Rss:                   0 kB
Pss:                   0 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         0 kB
Referenced:            0 kB
Anonymous:             0 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: mr mw me 
7ff0ea2af000-7ff0ea2b0000 r--p 0001f000 fe:00 53084170                   /usr/lib64/libEGL.so.1.0.0
Size:                  4 kB
Rss:                   4 kB
Pss:                   4 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         4 kB
Referenced:            0 kB
Anonymous:             4 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd mr mw me ac 
7ff0ea2b0000-7ff0ea2b1000 rw-p 00020000 fe:00 53084170                   /usr/lib64/libEGL.so.1.0.0
Size:                  4 kB
Rss:                   4 kB
Pss:                   4 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         4 kB
Referenced:            0 kB
Anonymous:             4 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd wr mr mw me ac 
7ff0ea2b1000-7ff0ea2b4000 r-xp 00000000 fe:00 53346692                   /usr/lib64/xorg/modules/libglamoregl.so
Size:                 12 kB
Rss:                   8 kB
Pss:                   8 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         8 kB
Private_Dirty:         0 kB
Referenced:            8 kB
Anonymous:             0 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd ex mr mw me 
7ff0ea2b4000-7ff0ea4b3000 ---p 00003000 fe:00 53346692                   /usr/lib64/xorg/modules/libglamoregl.so
Size:               2044 kB
Rss:                   0 kB
Pss:                   0 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         0 kB
Referenced:            0 kB
Anonymous:             0 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: mr mw me 
7ff0ea4b3000-7ff0ea4b4000 r--p 00002000 fe:00 53346692                   /usr/lib64/xorg/modules/libglamoregl.so
Size:                  4 kB
Rss:                   4 kB
Pss:                   4 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         4 kB
Referenced:            0 kB
Anonymous:             4 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd mr mw me ac 
7ff0ea4b4000-7ff0ea4b5000 rw-p 00003000 fe:00 53346692                   /usr/lib64/xorg/modules/libglamoregl.so
Size:                  4 kB
Rss:                   4 kB
Pss:                   4 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         4 kB
Referenced:            0 kB
Anonymous:             4 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd wr mr mw me ac 
7ff0ea4b5000-7ff0ea4cb000 r-xp 00000000 fe:00 42205309                   /lib64/libgcc_s.so.1
Size:                 88 kB
Rss:                  48 kB
Pss:                  17 kB
Shared_Clean:         48 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         0 kB
Referenced:           28 kB
Anonymous:             0 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd ex mr mw me 
7ff0ea4cb000-7ff0ea6ca000 ---p 00016000 fe:00 42205309                   /lib64/libgcc_s.so.1
Size:               2044 kB
Rss:                   0 kB
Pss:                   0 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         0 kB
Referenced:            0 kB
Anonymous:             0 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: mr mw me 
7ff0ea6ca000-7ff0ea6cb000 r--p 00015000 fe:00 42205309                   /lib64/libgcc_s.so.1
Size:                  4 kB
Rss:                   4 kB
Pss:                   4 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         4 kB
Referenced:            0 kB
Anonymous:             4 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd mr mw me ac 
7ff0ea6cb000-7ff0ea6cc000 rw-p 00016000 fe:00 42205309                   /lib64/libgcc_s.so.1
Size:                  4 kB
Rss:                   4 kB
Pss:                   4 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         4 kB
Referenced:            0 kB
Anonymous:             4 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd wr mr mw me ac 
7ff0ea6cc000-7ff0ea708000 r-xp 00000000 fe:00 53085052                   /usr/lib64/libpng16.so.16.6.0
Size:                240 kB
Rss:                  28 kB
Pss:                   1 kB
Shared_Clean:         28 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         0 kB
Referenced:           28 kB
Anonymous:             0 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd ex mr mw me 
7ff0ea708000-7ff0ea907000 ---p 0003c000 fe:00 53085052                   /usr/lib64/libpng16.so.16.6.0
Size:               2044 kB
Rss:                   0 kB
Pss:                   0 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         0 kB
Referenced:            0 kB
Anonymous:             0 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: mr mw me 
7ff0ea907000-7ff0ea908000 r--p 0003b000 fe:00 53085052                   /usr/lib64/libpng16.so.16.6.0
Size:                  4 kB
Rss:                   4 kB
Pss:                   4 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         4 kB
Referenced:            0 kB
Anonymous:             4 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd mr mw me ac 
7ff0ea908000-7ff0ea909000 rw-p 0003c000 fe:00 53085052                   /usr/lib64/libpng16.so.16.6.0
Size:                  4 kB
Rss:                   4 kB
Pss:                   4 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         4 kB
Referenced:            0 kB
Anonymous:             4 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd wr mr mw me ac 
7ff0ea909000-7ff0ea96e000 r-xp 00000000 fe:00 53087960                   /usr/lib64/libpcre.so.1.2.1
Size:                404 kB
Rss:                   4 kB
Pss:                   0 kB
Shared_Clean:          4 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         0 kB
Referenced:            4 kB
Anonymous:             0 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd ex mr mw me 
7ff0ea96e000-7ff0eab6d000 ---p 00065000 fe:00 53087960                   /usr/lib64/libpcre.so.1.2.1
Size:               2044 kB
Rss:                   0 kB
Pss:                   0 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         0 kB
Referenced:            0 kB
Anonymous:             0 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: mr mw me 
7ff0eab6d000-7ff0eab6e000 r--p 00064000 fe:00 53087960                   /usr/lib64/libpcre.so.1.2.1
Size:                  4 kB
Rss:                   4 kB
Pss:                   4 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         4 kB
Referenced:            0 kB
Anonymous:             4 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd mr mw me ac 
7ff0eab6e000-7ff0eab6f000 rw-p 00065000 fe:00 53087960                   /usr/lib64/libpcre.so.1.2.1
Size:                  4 kB
Rss:                   4 kB
Pss:                   4 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         4 kB
Referenced:            0 kB
Anonymous:             4 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd wr mr mw me ac 
7ff0eab6f000-7ff0eab75000 r-xp 00000000 fe:00 53086752                   /usr/lib64/libfontenc.so.1.0.0
Size:                 24 kB
Rss:                   4 kB
Pss:                   4 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         4 kB
Private_Dirty:         0 kB
Referenced:            4 kB
Anonymous:             0 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd ex mr mw me 
7ff0eab75000-7ff0ead74000 ---p 00006000 fe:00 53086752                   /usr/lib64/libfontenc.so.1.0.0
Size:               2044 kB
Rss:                   0 kB
Pss:                   0 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         0 kB
Referenced:            0 kB
Anonymous:             0 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: mr mw me 
7ff0ead74000-7ff0ead75000 r--p 00005000 fe:00 53086752                   /usr/lib64/libfontenc.so.1.0.0
Size:                  4 kB
Rss:                   4 kB
Pss:                   4 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         4 kB
Referenced:            0 kB
Anonymous:             4 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd mr mw me ac 
7ff0ead75000-7ff0ead76000 rw-p 00006000 fe:00 53086752                   /usr/lib64/libfontenc.so.1.0.0
Size:                  4 kB
Rss:                   4 kB
Pss:                   4 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         4 kB
Referenced:            0 kB
Anonymous:             4 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd wr mr mw me ac 
7ff0ead76000-7ff0ead77000 rw-p 00000000 00:00 0 
Size:                  4 kB
Rss:                   0 kB
Pss:                   0 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         0 kB
Referenced:            0 kB
Anonymous:             0 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd wr mr mw me ac 
7ff0ead77000-7ff0eae03000 r-xp 00000000 fe:00 53086408                   /usr/lib64/libfreetype.so.6.10.2
Size:                560 kB
Rss:                  56 kB
Pss:                   3 kB
Shared_Clean:         56 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         0 kB
Referenced:           56 kB
Anonymous:             0 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd ex mr mw me 
7ff0eae03000-7ff0eb003000 ---p 0008c000 fe:00 53086408                   /usr/lib64/libfreetype.so.6.10.2
Size:               2048 kB
Rss:                   0 kB
Pss:                   0 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         0 kB
Referenced:            0 kB
Anonymous:             0 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: mr mw me 
7ff0eb003000-7ff0eb008000 r--p 0008c000 fe:00 53086408                   /usr/lib64/libfreetype.so.6.10.2
Size:                 20 kB
Rss:                  20 kB
Pss:                  20 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:        20 kB
Referenced:            0 kB
Anonymous:            20 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd mr mw me ac 
7ff0eb008000-7ff0eb009000 rw-p 00091000 fe:00 53086408                   /usr/lib64/libfreetype.so.6.10.2
Size:                  4 kB
Rss:                   4 kB
Pss:                   4 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         4 kB
Referenced:            0 kB
Anonymous:             4 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd wr mr mw me ac 
7ff0eb009000-7ff0eb01e000 r-xp 00000000 fe:00 42205362                   /lib64/libz.so.1.2.8
Size:                 84 kB
Rss:                  36 kB
Pss:                   5 kB
Shared_Clean:         36 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         0 kB
Referenced:           36 kB
Anonymous:             0 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd ex mr mw me 
7ff0eb01e000-7ff0eb21d000 ---p 00015000 fe:00 42205362                   /lib64/libz.so.1.2.8
Size:               2044 kB
Rss:                   0 kB
Pss:                   0 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         0 kB
Referenced:            0 kB
Anonymous:             0 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: mr mw me 
7ff0eb21d000-7ff0eb21e000 r--p 00014000 fe:00 42205362                   /lib64/libz.so.1.2.8
Size:                  4 kB
Rss:                   4 kB
Pss:                   4 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         4 kB
Referenced:            4 kB
Anonymous:             4 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd mr mw me ac 
7ff0eb21e000-7ff0eb21f000 rw-p 00015000 fe:00 42205362                   /lib64/libz.so.1.2.8
Size:                  4 kB
Rss:                   4 kB
Pss:                   4 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         4 kB
Referenced:            0 kB
Anonymous:             4 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd wr mr mw me ac 
7ff0eb21f000-7ff0eb226000 r-xp 00000000 fe:00 42205389                   /lib64/librt-2.18.so
Size:                 28 kB
Rss:                   4 kB
Pss:                   0 kB
Shared_Clean:          4 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         0 kB
Referenced:            4 kB
Anonymous:             0 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd ex mr mw me 
7ff0eb226000-7ff0eb425000 ---p 00007000 fe:00 42205389                   /lib64/librt-2.18.so
Size:               2044 kB
Rss:                   0 kB
Pss:                   0 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         0 kB
Referenced:            0 kB
Anonymous:             0 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: mr mw me 
7ff0eb425000-7ff0eb426000 r--p 00006000 fe:00 42205389                   /lib64/librt-2.18.so
Size:                  4 kB
Rss:                   4 kB
Pss:                   4 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         4 kB
Referenced:            0 kB
Anonymous:             4 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd mr mw me ac 
7ff0eb426000-7ff0eb427000 rw-p 00007000 fe:00 42205389                   /lib64/librt-2.18.so
Size:                  4 kB
Rss:                   4 kB
Pss:                   4 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         4 kB
Referenced:            0 kB
Anonymous:             4 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd wr mr mw me ac 
7ff0eb427000-7ff0eb448000 r-xp 00000000 fe:00 42205368                   /lib64/libselinux.so.1
Size:                132 kB
Rss:                  16 kB
Pss:                   0 kB
Shared_Clean:         16 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         0 kB
Referenced:           16 kB
Anonymous:             0 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd ex mr mw me 
7ff0eb448000-7ff0eb647000 ---p 00021000 fe:00 42205368                   /lib64/libselinux.so.1
Size:               2044 kB
Rss:                   0 kB
Pss:                   0 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         0 kB
Referenced:            0 kB
Anonymous:             0 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: mr mw me 
7ff0eb647000-7ff0eb648000 r--p 00020000 fe:00 42205368                   /lib64/libselinux.so.1
Size:                  4 kB
Rss:                   4 kB
Pss:                   4 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         4 kB
Referenced:            0 kB
Anonymous:             4 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd mr mw me ac 
7ff0eb648000-7ff0eb649000 rw-p 00021000 fe:00 42205368                   /lib64/libselinux.so.1
Size:                  4 kB
Rss:                   4 kB
Pss:                   4 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         4 kB
Referenced:            0 kB
Anonymous:             4 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd wr mr mw me ac 
7ff0eb649000-7ff0eb64b000 rw-p 00000000 00:00 0 
Size:                  8 kB
Rss:                   4 kB
Pss:                   4 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         4 kB
Referenced:            0 kB
Anonymous:             4 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd wr mr mw me ac 
7ff0eb64b000-7ff0eb7f0000 r-xp 00000000 fe:00 42205320                   /lib64/libc-2.18.so
Size:               1684 kB
Rss:                 736 kB
Pss:                  43 kB
Shared_Clean:        728 kB
Shared_Dirty:          0 kB
Private_Clean:         8 kB
Private_Dirty:         0 kB
Referenced:          736 kB
Anonymous:             0 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd ex mr mw me 
7ff0eb7f0000-7ff0eb9f0000 ---p 001a5000 fe:00 42205320                   /lib64/libc-2.18.so
Size:               2048 kB
Rss:                   0 kB
Pss:                   0 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         0 kB
Referenced:            0 kB
Anonymous:             0 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: mr mw me 
7ff0eb9f0000-7ff0eb9f4000 r--p 001a5000 fe:00 42205320                   /lib64/libc-2.18.so
Size:                 16 kB
Rss:                  16 kB
Pss:                  16 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:        16 kB
Referenced:           12 kB
Anonymous:            16 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd mr mw me ac 
7ff0eb9f4000-7ff0eb9f6000 rw-p 001a9000 fe:00 42205320                   /lib64/libc-2.18.so
Size:                  8 kB
Rss:                   8 kB
Pss:                   8 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         8 kB
Referenced:            8 kB
Anonymous:             8 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd wr mr mw me ac 
7ff0eb9f6000-7ff0eb9fa000 rw-p 00000000 00:00 0 
Size:                 16 kB
Rss:                  16 kB
Pss:                  16 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:        16 kB
Referenced:            8 kB
Anonymous:            16 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd wr mr mw me ac 
7ff0eb9fa000-7ff0ebafc000 r-xp 00000000 fe:00 42205342                   /lib64/libm-2.18.so
Size:               1032 kB
Rss:                 204 kB
Pss:                  73 kB
Shared_Clean:        160 kB
Shared_Dirty:          0 kB
Private_Clean:        44 kB
Private_Dirty:         0 kB
Referenced:          188 kB
Anonymous:             0 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd ex mr mw me 
7ff0ebafc000-7ff0ebcfb000 ---p 00102000 fe:00 42205342                   /lib64/libm-2.18.so
Size:               2044 kB
Rss:                   0 kB
Pss:                   0 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         0 kB
Referenced:            0 kB
Anonymous:             0 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: mr mw me 
7ff0ebcfb000-7ff0ebcfc000 r--p 00101000 fe:00 42205342                   /lib64/libm-2.18.so
Size:                  4 kB
Rss:                   4 kB
Pss:                   4 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         4 kB
Referenced:            4 kB
Anonymous:             4 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd mr mw me ac 
7ff0ebcfc000-7ff0ebcfd000 rw-p 00102000 fe:00 42205342                   /lib64/libm-2.18.so
Size:                  4 kB
Rss:                   4 kB
Pss:                   4 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         4 kB
Referenced:            4 kB
Anonymous:             4 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd wr mr mw me ac 
7ff0ebcfd000-7ff0ebd02000 r-xp 00000000 fe:00 53088118                   /usr/lib64/libXdmcp.so.6.0.0
Size:                 20 kB
Rss:                   4 kB
Pss:                   1 kB
Shared_Clean:          4 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         0 kB
Referenced:            4 kB
Anonymous:             0 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd ex mr mw me 
7ff0ebd02000-7ff0ebf01000 ---p 00005000 fe:00 53088118                   /usr/lib64/libXdmcp.so.6.0.0
Size:               2044 kB
Rss:                   0 kB
Pss:                   0 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         0 kB
Referenced:            0 kB
Anonymous:             0 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: mr mw me 
7ff0ebf01000-7ff0ebf02000 r--p 00004000 fe:00 53088118                   /usr/lib64/libXdmcp.so.6.0.0
Size:                  4 kB
Rss:                   4 kB
Pss:                   4 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         4 kB
Referenced:            4 kB
Anonymous:             4 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd mr mw me ac 
7ff0ebf02000-7ff0ebf03000 rw-p 00005000 fe:00 53088118                   /usr/lib64/libXdmcp.so.6.0.0
Size:                  4 kB
Rss:                   4 kB
Pss:                   4 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         4 kB
Referenced:            0 kB
Anonymous:             4 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd wr mr mw me ac 
7ff0ebf03000-7ff0ebf06000 r-xp 00000000 fe:00 53086487                   /usr/lib64/libXau.so.6.0.0
Size:                 12 kB
Rss:                   8 kB
Pss:                   0 kB
Shared_Clean:          8 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         0 kB
Referenced:            8 kB
Anonymous:             0 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd ex mr mw me 
7ff0ebf06000-7ff0ec105000 ---p 00003000 fe:00 53086487                   /usr/lib64/libXau.so.6.0.0
Size:               2044 kB
Rss:                   0 kB
Pss:                   0 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         0 kB
Referenced:            0 kB
Anonymous:             0 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: mr mw me 
7ff0ec105000-7ff0ec106000 r--p 00002000 fe:00 53086487                   /usr/lib64/libXau.so.6.0.0
Size:                  4 kB
Rss:                   4 kB
Pss:                   4 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         4 kB
Referenced:            4 kB
Anonymous:             4 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd mr mw me ac 
7ff0ec106000-7ff0ec107000 rw-p 00003000 fe:00 53086487                   /usr/lib64/libXau.so.6.0.0
Size:                  4 kB
Rss:                   4 kB
Pss:                   4 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         4 kB
Referenced:            0 kB
Anonymous:             4 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd wr mr mw me ac 
7ff0ec107000-7ff0ec142000 r-xp 00000000 fe:00 53086968                   /usr/lib64/libXfont.so.1.4.1
Size:                236 kB
Rss:                 136 kB
Pss:                 136 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:       136 kB
Private_Dirty:         0 kB
Referenced:           32 kB
Anonymous:             0 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd ex mr mw me 
7ff0ec142000-7ff0ec341000 ---p 0003b000 fe:00 53086968                   /usr/lib64/libXfont.so.1.4.1
Size:               2044 kB
Rss:                   0 kB
Pss:                   0 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         0 kB
Referenced:            0 kB
Anonymous:             0 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: mr mw me 
7ff0ec341000-7ff0ec342000 r--p 0003a000 fe:00 53086968                   /usr/lib64/libXfont.so.1.4.1
Size:                  4 kB
Rss:                   4 kB
Pss:                   4 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         4 kB
Referenced:            4 kB
Anonymous:             4 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd mr mw me ac 
7ff0ec342000-7ff0ec344000 rw-p 0003b000 fe:00 53086968                   /usr/lib64/libXfont.so.1.4.1
Size:                  8 kB
Rss:                   8 kB
Pss:                   8 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         8 kB
Referenced:            8 kB
Anonymous:             8 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd wr mr mw me ac 
7ff0ec344000-7ff0ec3e5000 r-xp 00000000 fe:00 53087102                   /usr/lib64/libpixman-1.so.0.30.2
Size:                644 kB
Rss:                 160 kB
Pss:                  63 kB
Shared_Clean:        128 kB
Shared_Dirty:          0 kB
Private_Clean:        32 kB
Private_Dirty:         0 kB
Referenced:          116 kB
Anonymous:             0 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd ex mr mw me 
7ff0ec3e5000-7ff0ec5e5000 ---p 000a1000 fe:00 53087102                   /usr/lib64/libpixman-1.so.0.30.2
Size:               2048 kB
Rss:                   0 kB
Pss:                   0 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         0 kB
Referenced:            0 kB
Anonymous:             0 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: mr mw me 
7ff0ec5e5000-7ff0ec5ec000 r--p 000a1000 fe:00 53087102                   /usr/lib64/libpixman-1.so.0.30.2
Size:                 28 kB
Rss:                  28 kB
Pss:                  28 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:        28 kB
Referenced:           24 kB
Anonymous:            28 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd mr mw me ac 
7ff0ec5ec000-7ff0ec5ed000 rw-p 000a8000 fe:00 53087102                   /usr/lib64/libpixman-1.so.0.30.2
Size:                  4 kB
Rss:                   4 kB
Pss:                   4 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         4 kB
Referenced:            4 kB
Anonymous:             4 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd wr mr mw me ac 
7ff0ec5ed000-7ff0ec5f8000 r-xp 00000000 fe:00 53085486                   /usr/lib64/libdrm.so.2.4.0
Size:                 44 kB
Rss:                  36 kB
Pss:                  21 kB
Shared_Clean:         16 kB
Shared_Dirty:          0 kB
Private_Clean:        20 kB
Private_Dirty:         0 kB
Referenced:           28 kB
Anonymous:             0 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd ex mr mw me 
7ff0ec5f8000-7ff0ec7f7000 ---p 0000b000 fe:00 53085486                   /usr/lib64/libdrm.so.2.4.0
Size:               2044 kB
Rss:                   0 kB
Pss:                   0 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         0 kB
Referenced:            0 kB
Anonymous:             0 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: mr mw me 
7ff0ec7f7000-7ff0ec7f8000 r--p 0000a000 fe:00 53085486                   /usr/lib64/libdrm.so.2.4.0
Size:                  4 kB
Rss:                   4 kB
Pss:                   4 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         4 kB
Referenced:            4 kB
Anonymous:             4 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd mr mw me ac 
7ff0ec7f8000-7ff0ec7f9000 rw-p 0000b000 fe:00 53085486                   /usr/lib64/libdrm.so.2.4.0
Size:                  4 kB
Rss:                   4 kB
Pss:                   4 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         4 kB
Referenced:            4 kB
Anonymous:             4 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd wr mr mw me ac 
7ff0ec7f9000-7ff0ec811000 r-xp 00000000 fe:00 42205420                   /lib64/libpthread-2.18.so
Size:                 96 kB
Rss:                  60 kB
Pss:                   4 kB
Shared_Clean:         56 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         4 kB
Referenced:           60 kB
Anonymous:             4 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd ex mr mw me 
7ff0ec811000-7ff0eca11000 ---p 00018000 fe:00 42205420                   /lib64/libpthread-2.18.so
Size:               2048 kB
Rss:                   0 kB
Pss:                   0 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         0 kB
Referenced:            0 kB
Anonymous:             0 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: mr mw me 
7ff0eca11000-7ff0eca12000 r--p 00018000 fe:00 42205420                   /lib64/libpthread-2.18.so
Size:                  4 kB
Rss:                   4 kB
Pss:                   4 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         4 kB
Referenced:            4 kB
Anonymous:             4 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd mr mw me ac 
7ff0eca12000-7ff0eca13000 rw-p 00019000 fe:00 42205420                   /lib64/libpthread-2.18.so
Size:                  4 kB
Rss:                   4 kB
Pss:                   4 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         4 kB
Referenced:            4 kB
Anonymous:             4 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd wr mr mw me ac 
7ff0eca13000-7ff0eca17000 rw-p 00000000 00:00 0 
Size:                 16 kB
Rss:                   4 kB
Pss:                   4 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         4 kB
Referenced:            4 kB
Anonymous:             4 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd wr mr mw me ac 
7ff0eca17000-7ff0eca1f000 r-xp 00000000 fe:00 53086939                   /usr/lib64/libpciaccess.so.0.11.1
Size:                 32 kB
Rss:                  16 kB
Pss:                  16 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:        16 kB
Private_Dirty:         0 kB
Referenced:            4 kB
Anonymous:             0 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd ex mr mw me 
7ff0eca1f000-7ff0ecc1f000 ---p 00008000 fe:00 53086939                   /usr/lib64/libpciaccess.so.0.11.1
Size:               2048 kB
Rss:                   0 kB
Pss:                   0 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         0 kB
Referenced:            0 kB
Anonymous:             0 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: mr mw me 
7ff0ecc1f000-7ff0ecc20000 r--p 00008000 fe:00 53086939                   /usr/lib64/libpciaccess.so.0.11.1
Size:                  4 kB
Rss:                   4 kB
Pss:                   4 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         4 kB
Referenced:            4 kB
Anonymous:             4 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd mr mw me ac 
7ff0ecc20000-7ff0ecc21000 rw-p 00009000 fe:00 53086939                   /usr/lib64/libpciaccess.so.0.11.1
Size:                  4 kB
Rss:                   4 kB
Pss:                   4 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         4 kB
Referenced:            0 kB
Anonymous:             4 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd wr mr mw me ac 
7ff0ecc21000-7ff0ecc24000 r-xp 00000000 fe:00 42205339                   /lib64/libdl-2.18.so
Size:                 12 kB
Rss:                   8 kB
Pss:                   0 kB
Shared_Clean:          8 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         0 kB
Referenced:            8 kB
Anonymous:             0 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd ex mr mw me 
7ff0ecc24000-7ff0ece23000 ---p 00003000 fe:00 42205339                   /lib64/libdl-2.18.so
Size:               2044 kB
Rss:                   0 kB
Pss:                   0 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         0 kB
Referenced:            0 kB
Anonymous:             0 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: mr mw me 
7ff0ece23000-7ff0ece24000 r--p 00002000 fe:00 42205339                   /lib64/libdl-2.18.so
Size:                  4 kB
Rss:                   4 kB
Pss:                   4 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         4 kB
Referenced:            4 kB
Anonymous:             4 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd mr mw me ac 
7ff0ece24000-7ff0ece25000 rw-p 00003000 fe:00 42205339                   /lib64/libdl-2.18.so
Size:                  4 kB
Rss:                   4 kB
Pss:                   4 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         4 kB
Referenced:            0 kB
Anonymous:             4 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd wr mr mw me ac 
7ff0ece25000-7ff0ecfe6000 r-xp 00000000 fe:00 42205233                   /lib64/libcrypto.so.1.0.0
Size:               1796 kB
Rss:                 296 kB
Pss:                  33 kB
Shared_Clean:        296 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         0 kB
Referenced:          296 kB
Anonymous:             0 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd ex mr mw me 
7ff0ecfe6000-7ff0ed1e6000 ---p 001c1000 fe:00 42205233                   /lib64/libcrypto.so.1.0.0
Size:               2048 kB
Rss:                   0 kB
Pss:                   0 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         0 kB
Referenced:            0 kB
Anonymous:             0 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: mr mw me 
7ff0ed1e6000-7ff0ed201000 r--p 001c1000 fe:00 42205233                   /lib64/libcrypto.so.1.0.0
Size:                108 kB
Rss:                 108 kB
Pss:                 108 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:       108 kB
Referenced:            4 kB
Anonymous:           108 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd mr mw me ac 
7ff0ed201000-7ff0ed20c000 rw-p 001dc000 fe:00 42205233                   /lib64/libcrypto.so.1.0.0
Size:                 44 kB
Rss:                  44 kB
Pss:                  44 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:        44 kB
Referenced:            4 kB
Anonymous:            44 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd wr mr mw me ac 
7ff0ed20c000-7ff0ed210000 rw-p 00000000 00:00 0 
Size:                 16 kB
Rss:                   4 kB
Pss:                   4 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         4 kB
Referenced:            4 kB
Anonymous:             4 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd wr mr mw me ac 
7ff0ed210000-7ff0ed221000 r-xp 00000000 fe:00 53084943                   /usr/lib64/libudev.so.1.4.0
Size:                 68 kB
Rss:                  52 kB
Pss:                   3 kB
Shared_Clean:         52 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         0 kB
Referenced:           52 kB
Anonymous:             0 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd ex mr mw me 
7ff0ed221000-7ff0ed420000 ---p 00011000 fe:00 53084943                   /usr/lib64/libudev.so.1.4.0
Size:               2044 kB
Rss:                   0 kB
Pss:                   0 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         0 kB
Referenced:            0 kB
Anonymous:             0 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: mr mw me 
7ff0ed420000-7ff0ed421000 r--p 00010000 fe:00 53084943                   /usr/lib64/libudev.so.1.4.0
Size:                  4 kB
Rss:                   4 kB
Pss:                   4 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         4 kB
Referenced:            4 kB
Anonymous:             4 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd mr mw me ac 
7ff0ed421000-7ff0ed422000 rw-p 00011000 fe:00 53084943                   /usr/lib64/libudev.so.1.4.0
Size:                  4 kB
Rss:                   4 kB
Pss:                   4 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         4 kB
Referenced:            0 kB
Anonymous:             4 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd wr mr mw me ac 
7ff0ed422000-7ff0ed442000 r-xp 00000000 fe:00 42205286                   /lib64/ld-2.18.so
Size:                128 kB
Rss:                 108 kB
Pss:                   5 kB
Shared_Clean:        104 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         4 kB
Referenced:          108 kB
Anonymous:             4 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd ex mr mw me dw 
7ff0ed444000-7ff0ed446000 rw-s 00000000 00:04 16425                      /drm mm object (deleted)
Size:                  8 kB
Rss:                   8 kB
Pss:                   8 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         8 kB
Referenced:            8 kB
Anonymous:             0 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd wr sh mr mw me ms 
7ff0ed446000-7ff0ed449000 rw-s 101fa3000 00:05 1886                      /dev/dri/card0
Size:                 12 kB
Rss:                   0 kB
Pss:                   0 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         0 kB
Referenced:            0 kB
Anonymous:             0 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd wr sh mr mw me ms pf io de dd 
7ff0ed449000-7ff0ed44c000 rw-s 101da0000 00:05 1886                      /dev/dri/card0
Size:                 12 kB
Rss:                   0 kB
Pss:                   0 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         0 kB
Referenced:            0 kB
Anonymous:             0 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd wr sh mr mw me ms pf io de dd 
7ff0ed44c000-7ff0ed44f000 rw-s 101d9d000 00:05 1886                      /dev/dri/card0
Size:                 12 kB
Rss:                   0 kB
Pss:                   0 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         0 kB
Referenced:            0 kB
Anonymous:             0 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd wr sh mr mw me ms pf io de dd 
7ff0ed44f000-7ff0ed452000 rw-s 00000000 00:04 15905                      /drm mm object (deleted)
Size:                 12 kB
Rss:                  12 kB
Pss:                  12 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:        12 kB
Referenced:           12 kB
Anonymous:             0 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd wr sh mr mw me ms 
7ff0ed452000-7ff0ed453000 rw-s 00000000 00:04 15751                      /drm mm object (deleted)
Size:                  4 kB
Rss:                   4 kB
Pss:                   4 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         4 kB
Referenced:            0 kB
Anonymous:             0 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd wr sh mr mw me ms 
7ff0ed453000-7ff0ed456000 rw-s 1003da000 00:05 1886                      /dev/dri/card0
Size:                 12 kB
Rss:                   0 kB
Pss:                   0 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         0 kB
Referenced:            0 kB
Anonymous:             0 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd wr sh mr mw me ms pf io de dd 
7ff0ed456000-7ff0ed457000 rw-s 00000000 00:04 15749                      /drm mm object (deleted)
Size:                  4 kB
Rss:                   4 kB
Pss:                   4 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         4 kB
Referenced:            0 kB
Anonymous:             0 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd wr sh mr mw me ms 
7ff0ed457000-7ff0ed458000 rw-s 00000000 00:04 15748                      /drm mm object (deleted)
Size:                  4 kB
Rss:                   4 kB
Pss:                   4 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         4 kB
Referenced:            0 kB
Anonymous:             0 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd wr sh mr mw me ms 
7ff0ed458000-7ff0ed459000 rw-s 00000000 00:04 15747                      /drm mm object (deleted)
Size:                  4 kB
Rss:                   4 kB
Pss:                   4 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         4 kB
Referenced:            0 kB
Anonymous:             0 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd wr sh mr mw me ms 
7ff0ed459000-7ff0ed45a000 rw-s 00000000 00:04 15746                      /drm mm object (deleted)
Size:                  4 kB
Rss:                   4 kB
Pss:                   4 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         4 kB
Referenced:            0 kB
Anonymous:             0 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd wr sh mr mw me ms 
7ff0ed45a000-7ff0ed45b000 rw-s 00000000 00:04 15745                      /drm mm object (deleted)
Size:                  4 kB
Rss:                   4 kB
Pss:                   4 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         4 kB
Referenced:            0 kB
Anonymous:             0 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd wr sh mr mw me ms 
7ff0ed45b000-7ff0ed45c000 rw-s 00000000 00:04 15744                      /drm mm object (deleted)
Size:                  4 kB
Rss:                   4 kB
Pss:                   4 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         4 kB
Referenced:            0 kB
Anonymous:             0 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd wr sh mr mw me ms 
7ff0ed45c000-7ff0ed45d000 rw-s 00000000 00:04 15742                      /drm mm object (deleted)
Size:                  4 kB
Rss:                   4 kB
Pss:                   4 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         4 kB
Referenced:            0 kB
Anonymous:             0 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd wr sh mr mw me ms 
7ff0ed45d000-7ff0ed45e000 rw-s 00000000 00:04 15740                      /drm mm object (deleted)
Size:                  4 kB
Rss:                   4 kB
Pss:                   4 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         4 kB
Referenced:            0 kB
Anonymous:             0 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd wr sh mr mw me ms 
7ff0ed45e000-7ff0ed45f000 rw-s 00000000 00:04 15739                      /drm mm object (deleted)
Size:                  4 kB
Rss:                   4 kB
Pss:                   4 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         4 kB
Referenced:            0 kB
Anonymous:             0 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd wr sh mr mw me ms 
7ff0ed45f000-7ff0ed460000 rw-s 00000000 00:04 15738                      /drm mm object (deleted)
Size:                  4 kB
Rss:                   4 kB
Pss:                   4 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         4 kB
Referenced:            0 kB
Anonymous:             0 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd wr sh mr mw me ms 
7ff0ed460000-7ff0ed461000 rw-s 00000000 00:04 15737                      /drm mm object (deleted)
Size:                  4 kB
Rss:                   4 kB
Pss:                   4 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         4 kB
Referenced:            0 kB
Anonymous:             0 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd wr sh mr mw me ms 
7ff0ed461000-7ff0ed462000 rw-s 00000000 00:04 15736                      /drm mm object (deleted)
Size:                  4 kB
Rss:                   4 kB
Pss:                   4 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         4 kB
Referenced:            0 kB
Anonymous:             0 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd wr sh mr mw me ms 
7ff0ed462000-7ff0ed463000 rw-s 00000000 00:04 15732                      /drm mm object (deleted)
Size:                  4 kB
Rss:                   4 kB
Pss:                   4 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         4 kB
Referenced:            0 kB
Anonymous:             0 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd wr sh mr mw me ms 
7ff0ed463000-7ff0ed464000 rw-s 00000000 00:04 15731                      /drm mm object (deleted)
Size:                  4 kB
Rss:                   4 kB
Pss:                   4 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         4 kB
Referenced:            0 kB
Anonymous:             0 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd wr sh mr mw me ms 
7ff0ed464000-7ff0ed465000 rw-s 00000000 00:04 15729                      /drm mm object (deleted)
Size:                  4 kB
Rss:                   4 kB
Pss:                   4 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         4 kB
Referenced:            0 kB
Anonymous:             0 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd wr sh mr mw me ms 
7ff0ed465000-7ff0ed466000 rw-s 00000000 00:04 15728                      /drm mm object (deleted)
Size:                  4 kB
Rss:                   4 kB
Pss:                   4 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         4 kB
Referenced:            0 kB
Anonymous:             0 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd wr sh mr mw me ms 
7ff0ed466000-7ff0ed467000 rw-s 00000000 00:04 15727                      /drm mm object (deleted)
Size:                  4 kB
Rss:                   4 kB
Pss:                   4 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         4 kB
Referenced:            0 kB
Anonymous:             0 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd wr sh mr mw me ms 
7ff0ed467000-7ff0ed468000 rw-s 00000000 00:04 15726                      /drm mm object (deleted)
Size:                  4 kB
Rss:                   4 kB
Pss:                   4 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         4 kB
Referenced:            0 kB
Anonymous:             0 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd wr sh mr mw me ms 
7ff0ed468000-7ff0ed469000 rw-s 00000000 00:04 15725                      /drm mm object (deleted)
Size:                  4 kB
Rss:                   4 kB
Pss:                   4 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         4 kB
Referenced:            0 kB
Anonymous:             0 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd wr sh mr mw me ms 
7ff0ed469000-7ff0ed46a000 rw-s 00000000 00:04 15720                      /drm mm object (deleted)
Size:                  4 kB
Rss:                   4 kB
Pss:                   4 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         4 kB
Referenced:            0 kB
Anonymous:             0 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd wr sh mr mw me ms 
7ff0ed46a000-7ff0ed46b000 rw-s 00000000 00:04 15718                      /drm mm object (deleted)
Size:                  4 kB
Rss:                   4 kB
Pss:                   4 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         4 kB
Referenced:            0 kB
Anonymous:             0 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd wr sh mr mw me ms 
7ff0ed46b000-7ff0ed46c000 rw-s 00000000 00:04 15717                      /drm mm object (deleted)
Size:                  4 kB
Rss:                   4 kB
Pss:                   4 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         4 kB
Referenced:            0 kB
Anonymous:             0 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd wr sh mr mw me ms 
7ff0ed46c000-7ff0ed46d000 rw-s 00000000 00:04 15716                      /drm mm object (deleted)
Size:                  4 kB
Rss:                   4 kB
Pss:                   4 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         4 kB
Referenced:            0 kB
Anonymous:             0 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd wr sh mr mw me ms 
7ff0ed46d000-7ff0ed46e000 rw-s 00000000 00:04 15715                      /drm mm object (deleted)
Size:                  4 kB
Rss:                   4 kB
Pss:                   4 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         4 kB
Referenced:            0 kB
Anonymous:             0 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd wr sh mr mw me ms 
7ff0ed46e000-7ff0ed621000 rw-p 00000000 00:00 0 
Size:               1740 kB
Rss:                 916 kB
Pss:                 916 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:       916 kB
Referenced:          468 kB
Anonymous:           916 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd wr mr mw me ac 
7ff0ed621000-7ff0ed622000 rw-s 00000000 00:04 15714                      /drm mm object (deleted)
Size:                  4 kB
Rss:                   4 kB
Pss:                   4 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         4 kB
Referenced:            0 kB
Anonymous:             0 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd wr sh mr mw me ms 
7ff0ed622000-7ff0ed625000 rw-s 00000000 00:04 2064390                    /SYSV00000000 (deleted)
Size:                 12 kB
Rss:                  12 kB
Pss:                   6 kB
Shared_Clean:          0 kB
Shared_Dirty:         12 kB
Private_Clean:         0 kB
Private_Dirty:         0 kB
Referenced:            0 kB
Anonymous:             0 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd wr sh mr mw me ms 
7ff0ed625000-7ff0ed627000 rw-s 1001f8000 00:05 1886                      /dev/dri/card0
Size:                  8 kB
Rss:                   0 kB
Pss:                   0 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         0 kB
Referenced:            0 kB
Anonymous:             0 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd wr sh mr mw me ms pf io de dd 
7ff0ed627000-7ff0ed637000 rw-s 1001e8000 00:05 1886                      /dev/dri/card0
Size:                 64 kB
Rss:                   0 kB
Pss:                   0 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         0 kB
Referenced:            0 kB
Anonymous:             0 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd wr sh mr mw me ms pf io de dd 
7ff0ed63a000-7ff0ed63f000 rw-s 1001e0000 00:05 1886                      /dev/dri/card0
Size:                 20 kB
Rss:                   0 kB
Pss:                   0 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         0 kB
Referenced:            0 kB
Anonymous:             0 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd wr sh mr mw me ms pf io de dd 
7ff0ed63f000-7ff0ed641000 rw-p 00000000 00:00 0 
Size:                  8 kB
Rss:                   8 kB
Pss:                   8 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         8 kB
Referenced:            4 kB
Anonymous:             8 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd wr mr mw me ac 
7ff0ed641000-7ff0ed642000 r--p 0001f000 fe:00 42205286                   /lib64/ld-2.18.so
Size:                  4 kB
Rss:                   4 kB
Pss:                   4 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         4 kB
Referenced:            4 kB
Anonymous:             4 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd mr mw me dw ac 
7ff0ed642000-7ff0ed643000 rw-p 00020000 fe:00 42205286                   /lib64/ld-2.18.so
Size:                  4 kB
Rss:                   4 kB
Pss:                   4 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         4 kB
Referenced:            4 kB
Anonymous:             4 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd wr mr mw me dw ac 
7ff0ed643000-7ff0ed644000 rw-p 00000000 00:00 0 
Size:                  4 kB
Rss:                   4 kB
Pss:                   4 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         4 kB
Referenced:            4 kB
Anonymous:             4 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd wr mr mw me ac 
7ffff8933000-7ffff8954000 rw-p 00000000 00:00 0                          [stack]
Size:                136 kB
Rss:                  44 kB
Pss:                  44 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:        44 kB
Referenced:           28 kB
Anonymous:            44 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd wr mr mw me gd ac 
7ffff898c000-7ffff898e000 r-xp 00000000 00:00 0                          [vdso]
Size:                  8 kB
Rss:                   8 kB
Pss:                   0 kB
Shared_Clean:          8 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         0 kB
Referenced:            8 kB
Anonymous:             0 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd ex mr mw me de 
ffffffffff600000-ffffffffff601000 r-xp 00000000 00:00 0                  [vsyscall]
Size:                  4 kB
Rss:                   0 kB
Pss:                   0 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         0 kB
Referenced:            0 kB
Anonymous:             0 kB
AnonHugePages:         0 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
VmFlags: rd ex 
