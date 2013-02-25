Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752743Ab3BYFve (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 00:51:34 -0500
Received: from mail-da0-f51.google.com ([209.85.210.51]:65323 "EHLO
	mail-da0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751355Ab3BYFvc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 00:51:32 -0500
Date: Sun, 24 Feb 2013 21:52:18 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Ben Skeggs <bskeggs@redhat.com>
Cc: David Airlie <airlied@linux.ie>, Martin Peres <martin.peres@labri.fr>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: resume fails to light display on Macbook Pro Retina on 3.8-rc1
Message-ID: <20130225055218.GA1205@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="EVF5PPMfhYS0aIcm"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--EVF5PPMfhYS0aIcm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Ben,

My Macbook Pro Retina fails to resume properly on 3.8.  I tracked this
down to commit 6c5a04249d7afeea3e0ed971e7813f84e29a1706 (drm/nvd0/disp:
move link training helpers into core as display methods)

Anything I can try to help solve this?

Note, I'm using the Intel driver as the main controller for this laptop,
well, I think I am, my xorg log is attached.

And sorry for not reporting this sooner, it took me a long time to
bisect down, there were other resume and boot issues on the bisect trail
leading to this, the full log is below.

thanks,

greg k-h


git bisect start
# good: [29594404d7fe73cd80eaa4ee8c43dcc53970c60e] Linux 3.7
git bisect good 29594404d7fe73cd80eaa4ee8c43dcc53970c60e
# bad: [19f949f52599ba7c3f67a5897ac6be14bfcb1200] Linux 3.8
git bisect bad 19f949f52599ba7c3f67a5897ac6be14bfcb1200
# good: [dadfab4873256d2145640c0ce468fcbfb48977fe] Merge tag 'firewire-updates' of git://git.kernel.org/pub/scm/linux/kernel/git/ieee1394/linux1394
git bisect good dadfab4873256d2145640c0ce468fcbfb48977fe
# bad: [992956189de58cae9f2be40585bc25105cd7c5ad] efi: Fix the build with user namespaces enabled.
git bisect bad 992956189de58cae9f2be40585bc25105cd7c5ad
# skip: [2b8318881ddbcb67c5e8d2178b42284749442222] Merge tag 'fbdev-for-3.8' of git://gitorious.org/linux-omap-dss2/linux
git bisect skip 2b8318881ddbcb67c5e8d2178b42284749442222
# good: [da22f22e91f0d14d996c7258101575a5a06ddf85] ssb: add ssb_chipco_gpio_pull{up,down}
git bisect good da22f22e91f0d14d996c7258101575a5a06ddf85
# good: [bb523fc08d4a4a726c7555be7800735685888b3c] drm/i915: convert PIPE_CLK_SEL to transcoder
git bisect good bb523fc08d4a4a726c7555be7800735685888b3c
# good: [d3e4ea017a414a19ab11a10b52e80a0c8b3f1670] [media] em28xx-cards: fix a warning
git bisect good d3e4ea017a414a19ab11a10b52e80a0c8b3f1670
# good: [3fcb6eb4063ab4eef05601c266afa2af667c8e1f] video: exynos_dp: remove redundant parameters
git bisect good 3fcb6eb4063ab4eef05601c266afa2af667c8e1f
# good: [c5b005ab7091c9ef4ca9b47569a8e27e54588933] drbd: use bitmap_parse instead of __bitmap_parse
git bisect good c5b005ab7091c9ef4ca9b47569a8e27e54588933
# skip: [c13e69b2f0e1e2da41a175c7e9215659842cbef9] Merge tag 'upstream-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/jgarzik/libata-dev
git bisect skip c13e69b2f0e1e2da41a175c7e9215659842cbef9
# good: [c8241969b44438c9335b59d375b627214bc36483] drm/i915: pass adjusted_mode to intel_choose_pipe_bpp_dither(), again
git bisect good c8241969b44438c9335b59d375b627214bc36483
# skip: [c5258190c2ae664cdf367417a2a25e5fa4104322] Merge branch 'next' of git://git.monstr.eu/linux-2.6-microblaze
git bisect skip c5258190c2ae664cdf367417a2a25e5fa4104322
# good: [24ebb37e6515d999bb27f5f8de6ff30faa7479f5] HID: i2c-hid: change I2C name
git bisect good 24ebb37e6515d999bb27f5f8de6ff30faa7479f5
# good: [189e11731aa858597095fbe1e6d243bad26bd96b] x86: pvclock: add note about rdtsc barriers
git bisect good 189e11731aa858597095fbe1e6d243bad26bd96b
# skip: [75e300c8ba5864367634d946c729d8fd05c1cbc2] Merge tag 'for-v3.8' of git://git.infradead.org/users/cbou/linux-pstore
git bisect skip 75e300c8ba5864367634d946c729d8fd05c1cbc2
# good: [08ff32352d6ff7083533dc1c25618d42f92ec28e] mlx4: 64-byte CQE/EQE support
git bisect good 08ff32352d6ff7083533dc1c25618d42f92ec28e
# skip: [e81d372ff9f694e13fa46e8b5aaed505c7fd2a1f] Merge branch 'for-next' of git://git.kernel.org/pub/scm/linux/kernel/git/cooloney/linux-leds
git bisect skip e81d372ff9f694e13fa46e8b5aaed505c7fd2a1f
# good: [fc8d7547b1e19e1bb8f3206837ee0c7c6538e2e5] RDMA/nes: Fix for sending fpdus in order to hardware
git bisect good fc8d7547b1e19e1bb8f3206837ee0c7c6538e2e5
# good: [4247bfe20ab1cb8cf1874b811c0dc60bcd0249e8] Merge remote-tracking branch 'regulator/topic/stub' into regulator-next
git bisect good 4247bfe20ab1cb8cf1874b811c0dc60bcd0249e8
# good: [5028ea04c8a8a67fe73f18f5f34386730c9c1bf2] OMAPDSS: Remove acb and acbi fields from omap_dss_device
git bisect good 5028ea04c8a8a67fe73f18f5f34386730c9c1bf2
# good: [986836503e49ccf7e84b813715d344964ec93566] Merge branch 'drbd-8.4_ed6' into for-3.8-drivers-drbd-8.4_ed6
git bisect good 986836503e49ccf7e84b813715d344964ec93566
# bad: [9add1ac3dd256ad12e266f8403daf928be19953f] Merge branch 'drm-next-3.8' of git://people.freedesktop.org/~agd5f/linux into drm-next
git bisect bad 9add1ac3dd256ad12e266f8403daf928be19953f
# good: [1f2285d462c02ef9b82ee9c553a31884c23994f0] drm/nouveau/clk: fix crystal frequency retrieval on nv25
git bisect good 1f2285d462c02ef9b82ee9c553a31884c23994f0
# bad: [bd3b49f25a3eae2d91432247b7565489120b6bcf] drm: tegra: Add maintainers entry
git bisect bad bd3b49f25a3eae2d91432247b7565489120b6bcf
# bad: [6c8e4633d351f6f794c8a5c03f19e8d5a25f9639] drm/nouveau/dp: move core link training calls to common code
git bisect bad 6c8e4633d351f6f794c8a5c03f19e8d5a25f9639
# good: [b6caea505879c4a606cf364442fd1f06f6c40e30] drm/nouveau/bios: implement BIT 'U' table (and subtable) parsing in core
git bisect good b6caea505879c4a606cf364442fd1f06f6c40e30
# skip: [ed58aee93c45d5095253d9bc370b418e3d767940] drm/nvd0/disp: handle DP transfer unit setup from second supervisor interrupt
git bisect skip ed58aee93c45d5095253d9bc370b418e3d767940
# skip: [4a230fa61884ffe6b6a806563eee82f12a60fa1e] drm/nvd0/disp: calculate U script id in supervisor interrupt
git bisect skip 4a230fa61884ffe6b6a806563eee82f12a60fa1e
# bad: [0a9e2b959f2a1673ca9315df8e0b6dec1069060e] drm/nvd0/disp: move HDA codec setup to core
git bisect bad 0a9e2b959f2a1673ca9315df8e0b6dec1069060e
# good: [cbe7270d48670889a88705478a68d000b0bc3f6e] drm/nouveau/core: expose full method calling capabilities with nv_exec
git bisect good cbe7270d48670889a88705478a68d000b0bc3f6e
# bad: [6c5a04249d7afeea3e0ed971e7813f84e29a1706] drm/nvd0/disp: move link training helpers into core as display methods
git bisect bad 6c5a04249d7afeea3e0ed971e7813f84e29a1706
# good: [fb445b3c23a4ae75190e814d952be6dce6181abe] drm/nouveau/core: allow representing method ranges in nouveau_omthds
git bisect good fb445b3c23a4ae75190e814d952be6dce6181abe

--EVF5PPMfhYS0aIcm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="Xorg.0.log"

[     5.617] 
This is a pre-release version of the X server from The X.Org Foundation.
It is not supported in any way.
Bugs may be filed in the bugzilla at http://bugs.freedesktop.org/.
Select the "xorg" product for bugs you find in this release.
Before reporting bugs in pre-release versions please check the
latest version in the X.Org Foundation git repository.
See http://wiki.x.org/wiki/GitPage for git access instructions.
[     5.617] 
X.Org X Server 1.13.2.901 (1.13.3 RC 1)
Release Date: 2013-02-15
[     5.617] X Protocol Version 11, Revision 0
[     5.617] Build Operating System: Linux 3.7.5-1-ARCH x86_64 
[     5.617] Current Operating System: Linux mb 3.7.0-rc4-test+ #86 SMP PREEMPT Sun Feb 24 20:53:20 PST 2013 x86_64
[     5.617] Kernel command line: root=/dev/sda5 ro
[     5.617] Build Date: 18 February 2013  03:52:56PM
[     5.617]  
[     5.617] Current version of pixman: 0.28.2
[     5.617] 	Before reporting problems, check http://wiki.x.org
	to make sure that you have the latest version.
[     5.617] Markers: (--) probed, (**) from config file, (==) default setting,
	(++) from command line, (!!) notice, (II) informational,
	(WW) warning, (EE) error, (NI) not implemented, (??) unknown.
[     5.617] (==) Log file: "/var/log/Xorg.0.log", Time: Sun Feb 24 21:39:10 2013
[     5.619] (==) Using config directory: "/etc/X11/xorg.conf.d"
[     5.620] (==) No Layout section.  Using the first Screen section.
[     5.620] (==) No screen section available. Using defaults.
[     5.620] (**) |-->Screen "Default Screen Section" (0)
[     5.620] (**) |   |-->Monitor "<default monitor>"
[     5.620] (==) No monitor specified for screen "Default Screen Section".
	Using a default monitor configuration.
[     5.620] (==) Automatically adding devices
[     5.620] (==) Automatically enabling devices
[     5.620] (==) Automatically adding GPU devices
[     5.623] (WW) The directory "/usr/share/fonts/OTF/" does not exist.
[     5.623] 	Entry deleted from font path.
[     5.624] (WW) `fonts.dir' not found (or not valid) in "/usr/share/fonts/100dpi/".
[     5.624] 	Entry deleted from font path.
[     5.624] 	(Run 'mkfontdir' on "/usr/share/fonts/100dpi/").
[     5.624] (WW) `fonts.dir' not found (or not valid) in "/usr/share/fonts/75dpi/".
[     5.624] 	Entry deleted from font path.
[     5.624] 	(Run 'mkfontdir' on "/usr/share/fonts/75dpi/").
[     5.624] (==) FontPath set to:
	/usr/share/fonts/misc/,
	/usr/share/fonts/TTF/,
	/usr/share/fonts/Type1/
[     5.624] (==) ModulePath set to "/usr/lib/xorg/modules"
[     5.624] (II) The server relies on udev to provide the list of input devices.
	If no devices become available, reconfigure udev or disable AutoAddDevices.
[     5.624] (II) Loader magic: 0x7fcc20
[     5.624] (II) Module ABI versions:
[     5.624] 	X.Org ANSI C Emulation: 0.4
[     5.624] 	X.Org Video Driver: 13.1
[     5.624] 	X.Org XInput driver : 18.0
[     5.624] 	X.Org Server Extension : 7.0
[     5.625] (II) config/udev: Adding drm device (/dev/dri/card1)
[     7.205] (II) config/udev: Adding drm device (/dev/dri/card0)
[     7.212] (--) PCI: (0:0:2:0) 8086:0166:106b:00f7 rev 9, Mem @ 0xc1400000/4194304, 0xb0000000/268435456, I/O @ 0x00003000/64
[     7.212] (--) PCI:*(0:1:0:0) 10de:0fd5:106b:00f2 rev 161, Mem @ 0xc0000000/16777216, 0x90000000/268435456, 0xa0000000/33554432, I/O @ 0x00002000/128, BIOS @ 0x????????/524288
[     7.213] Initializing built-in extension Generic Event Extension
[     7.213] Initializing built-in extension SHAPE
[     7.213] Initializing built-in extension MIT-SHM
[     7.213] Initializing built-in extension XInputExtension
[     7.213] Initializing built-in extension XTEST
[     7.213] Initializing built-in extension BIG-REQUESTS
[     7.213] Initializing built-in extension SYNC
[     7.213] Initializing built-in extension XKEYBOARD
[     7.213] Initializing built-in extension XC-MISC
[     7.213] Initializing built-in extension SECURITY
[     7.213] Initializing built-in extension XINERAMA
[     7.213] Initializing built-in extension XFIXES
[     7.213] Initializing built-in extension RENDER
[     7.213] Initializing built-in extension RANDR
[     7.213] Initializing built-in extension COMPOSITE
[     7.213] Initializing built-in extension DAMAGE
[     7.213] Initializing built-in extension MIT-SCREEN-SAVER
[     7.213] Initializing built-in extension DOUBLE-BUFFER
[     7.213] Initializing built-in extension RECORD
[     7.213] Initializing built-in extension DPMS
[     7.213] Initializing built-in extension X-Resource
[     7.213] Initializing built-in extension XVideo
[     7.213] Initializing built-in extension XVideo-MotionCompensation
[     7.213] Initializing built-in extension XFree86-VidModeExtension
[     7.213] Initializing built-in extension XFree86-DGA
[     7.213] Initializing built-in extension XFree86-DRI
[     7.213] Initializing built-in extension DRI2
[     7.213] (II) LoadModule: "glx"
[     7.217] (II) Loading /usr/lib/xorg/modules/extensions/libglx.so
[     7.219] (II) Module glx: vendor="X.Org Foundation"
[     7.219] 	compiled for 1.13.2.901, module version = 1.0.0
[     7.219] 	ABI class: X.Org Server Extension, version 7.0
[     7.219] (==) AIGLX enabled
[     7.219] Loading extension GLX
[     7.219] (==) Matched nouveau as autoconfigured driver 0
[     7.219] (==) Matched nvidia as autoconfigured driver 1
[     7.219] (==) Matched nv as autoconfigured driver 2
[     7.219] (==) Matched intel as autoconfigured driver 3
[     7.219] (==) Matched nouveau as autoconfigured driver 4
[     7.219] (==) Matched nvidia as autoconfigured driver 5
[     7.219] (==) Matched nv as autoconfigured driver 6
[     7.219] (==) Matched vesa as autoconfigured driver 7
[     7.219] (==) Matched modesetting as autoconfigured driver 8
[     7.219] (==) Matched fbdev as autoconfigured driver 9
[     7.219] (==) Assigned the driver to the xf86ConfigLayout
[     7.219] (II) LoadModule: "nouveau"
[     7.220] (II) Loading /usr/lib/xorg/modules/drivers/nouveau_drv.so
[     7.223] (II) Module nouveau: vendor="X.Org Foundation"
[     7.223] 	compiled for 1.13.1, module version = 1.0.6
[     7.223] 	Module class: X.Org Video Driver
[     7.223] 	ABI class: X.Org Video Driver, version 13.1
[     7.223] (II) LoadModule: "nvidia"
[     7.223] (WW) Warning, couldn't open module nvidia
[     7.223] (II) UnloadModule: "nvidia"
[     7.223] (II) Unloading nvidia
[     7.223] (EE) Failed to load module "nvidia" (module does not exist, 0)
[     7.223] (II) LoadModule: "nv"
[     7.223] (WW) Warning, couldn't open module nv
[     7.223] (II) UnloadModule: "nv"
[     7.223] (II) Unloading nv
[     7.223] (EE) Failed to load module "nv" (module does not exist, 0)
[     7.223] (II) LoadModule: "intel"
[     7.224] (II) Loading /usr/lib/xorg/modules/drivers/intel_drv.so
[     7.228] (II) Module intel: vendor="X.Org Foundation"
[     7.228] 	compiled for 1.13.2.901, module version = 2.21.3
[     7.228] 	Module class: X.Org Video Driver
[     7.228] 	ABI class: X.Org Video Driver, version 13.1
[     7.228] (II) LoadModule: "vesa"
[     7.228] (WW) Warning, couldn't open module vesa
[     7.228] (II) UnloadModule: "vesa"
[     7.228] (II) Unloading vesa
[     7.228] (EE) Failed to load module "vesa" (module does not exist, 0)
[     7.228] (II) LoadModule: "modesetting"
[     7.228] (WW) Warning, couldn't open module modesetting
[     7.228] (II) UnloadModule: "modesetting"
[     7.228] (II) Unloading modesetting
[     7.228] (EE) Failed to load module "modesetting" (module does not exist, 0)
[     7.228] (II) LoadModule: "fbdev"
[     7.229] (WW) Warning, couldn't open module fbdev
[     7.229] (II) UnloadModule: "fbdev"
[     7.229] (II) Unloading fbdev
[     7.229] (EE) Failed to load module "fbdev" (module does not exist, 0)
[     7.229] (II) NOUVEAU driver 
[     7.229] (II) NOUVEAU driver for NVIDIA chipset families :
[     7.229] 	RIVA TNT        (NV04)
[     7.229] 	RIVA TNT2       (NV05)
[     7.229] 	GeForce 256     (NV10)
[     7.229] 	GeForce 2       (NV11, NV15)
[     7.229] 	GeForce 4MX     (NV17, NV18)
[     7.229] 	GeForce 3       (NV20)
[     7.229] 	GeForce 4Ti     (NV25, NV28)
[     7.229] 	GeForce FX      (NV3x)
[     7.229] 	GeForce 6       (NV4x)
[     7.229] 	GeForce 7       (G7x)
[     7.229] 	GeForce 8       (G8x)
[     7.229] 	GeForce GTX 200 (NVA0)
[     7.229] 	GeForce GTX 400 (NVC0)
[     7.230] (II) intel: Driver for Intel Integrated Graphics Chipsets: i810,
	i810-dc100, i810e, i815, i830M, 845G, 854, 852GM/855GM, 865G, 915G,
	E7221 (i915), 915GM, 945G, 945GM, 945GME, Pineview GM, Pineview G,
	965G, G35, 965Q, 946GZ, 965GM, 965GME/GLE, G33, Q35, Q33, GM45,
	4 Series, G45/G43, Q45/Q43, G41, B43, B43, Clarkdale, Arrandale,
	Sandybridge Desktop (GT1), Sandybridge Desktop (GT2),
	Sandybridge Desktop (GT2+), Sandybridge Mobile (GT1),
	Sandybridge Mobile (GT2), Sandybridge Mobile (GT2+),
	Sandybridge Server, Ivybridge Mobile (GT1), Ivybridge Mobile (GT2),
	Ivybridge Desktop (GT1), Ivybridge Desktop (GT2), Ivybridge Server,
	Ivybridge Server (GT2), Haswell Desktop (GT1), Haswell Desktop (GT2),
	Haswell Desktop (GT2+), Haswell Mobile (GT1), Haswell Mobile (GT2),
	Haswell Mobile (GT2+), Haswell Server (GT1), Haswell Server (GT2),
	Haswell Server (GT2+), Haswell SDV Desktop (GT1),
	Haswell SDV Desktop (GT2), Haswell SDV Desktop (GT2+),
	Haswell SDV Mobile (GT1), Haswell SDV Mobile (GT2),
	Haswell SDV Mobile (GT2+), Haswell SDV Server (GT1),
	Haswell SDV Server (GT2), Haswell SDV Server (GT2+),
	Haswell ULT Desktop (GT1), Haswell ULT Desktop (GT2),
	Haswell ULT Desktop (GT2+), Haswell ULT Mobile (GT1),
	Haswell ULT Mobile (GT2), Haswell ULT Mobile (GT2+),
	Haswell ULT Server (GT1), Haswell ULT Server (GT2),
	Haswell ULT Server (GT2+), Haswell CRW Desktop (GT1),
	Haswell CRW Desktop (GT2), Haswell CRW Desktop (GT2+),
	Haswell CRW Mobile (GT1), Haswell CRW Mobile (GT2),
	Haswell CRW Mobile (GT2+), Haswell CRW Server (GT1),
	Haswell CRW Server (GT2), Haswell CRW Server (GT2+),
	ValleyView PO board
[     7.230] (++) using VT number 1

[     7.231] (II) [drm] nouveau interface version: 1.1.0
[     7.231] (II) Loading sub module "dri"
[     7.231] (II) LoadModule: "dri"
[     7.231] (II) Module "dri" already built-in
[     7.231] (II) NOUVEAU(0): Loaded DRI module
[     7.231] (--) NOUVEAU(0): Chipset: "NVIDIA NVe7"
[     7.231] (II) NOUVEAU(0): Creating default Display subsection in Screen section
	"Default Screen Section" for depth/fbbpp 24/32
[     7.231] (==) NOUVEAU(0): Depth 24, (--) framebuffer bpp 32
[     7.231] (==) NOUVEAU(0): RGB weight 888
[     7.231] (==) NOUVEAU(0): Default visual is TrueColor
[     7.231] (==) NOUVEAU(0): Using HW cursor
[     7.231] (==) NOUVEAU(0): GLX sync to VBlank disabled.
[     7.231] (==) NOUVEAU(0): Page flipping enabled
[     7.231] (==) NOUVEAU(0): Swap limit set to 2 [Max allowed 2]
[     7.238] (II) NOUVEAU(0): Output eDP-2 has no monitor section
[     7.242] (II) NOUVEAU(0): Output DP-1 has no monitor section
[     7.246] (II) NOUVEAU(0): Output DP-2 has no monitor section
[     7.249] (II) NOUVEAU(0): Output HDMI-1 has no monitor section
[     7.253] (II) NOUVEAU(0): EDID for output eDP-2
[     7.253] (II) NOUVEAU(0): Manufacturer: APP  Model: a00f  Serial#: 0
[     7.253] (II) NOUVEAU(0): Year: 2011  Week: 16
[     7.253] (II) NOUVEAU(0): EDID Version: 1.4
[     7.253] (II) NOUVEAU(0): Digital Display Input
[     7.253] (II) NOUVEAU(0): 8 bits per channel
[     7.253] (II) NOUVEAU(0): Digital interface is DisplayPort
[     7.253] (II) NOUVEAU(0): Max Image Size [cm]: horiz.: 33  vert.: 21
[     7.253] (II) NOUVEAU(0): Gamma: 2.20
[     7.253] (II) NOUVEAU(0): No DPMS capabilities specified
[     7.253] (II) NOUVEAU(0): Supported color encodings: RGB 4:4:4 
[     7.253] (II) NOUVEAU(0): First detailed timing is preferred mode
[     7.253] (II) NOUVEAU(0): Preferred mode is native pixel format and refresh rate
[     7.253] (II) NOUVEAU(0): redX: 0.653 redY: 0.334   greenX: 0.300 greenY: 0.620
[     7.253] (II) NOUVEAU(0): blueX: 0.146 blueY: 0.050   whiteX: 0.312 whiteY: 0.329
[     7.253] (II) NOUVEAU(0): Manufacturer's mask: 0
[     7.253] (II) NOUVEAU(0): Supported detailed timing:
[     7.253] (II) NOUVEAU(0): clock: 337.8 MHz   Image Size:  331 x 207 mm
[     7.253] (II) NOUVEAU(0): h_active: 2880  h_sync: 2928  h_sync_end 2960 h_blank_end 3040 h_border: 0
[     7.253] (II) NOUVEAU(0): v_active: 1800  v_sync: 1803  v_sync_end 1809 v_blanking: 1852 v_border: 0
[     7.253] (II) NOUVEAU(0): Monitor name: Color LCD
[     7.253] (II) NOUVEAU(0): EDID (in hex):
[     7.253] (II) NOUVEAU(0): 	00ffffffffffff0006100fa000000000
[     7.253] (II) NOUVEAU(0): 	10150104a5211578026fb1a7554c9e25
[     7.253] (II) NOUVEAU(0): 	0c505400000001010101010101010101
[     7.253] (II) NOUVEAU(0): 	010101010101ef8340a0b00834703020
[     7.253] (II) NOUVEAU(0): 	36004bcf1000001a000000fc00436f6c
[     7.253] (II) NOUVEAU(0): 	6f72204c43440a202020000000100000
[     7.253] (II) NOUVEAU(0): 	00000000000000000000000000000010
[     7.253] (II) NOUVEAU(0): 	000000000000000000000000000000e7
[     7.253] (II) NOUVEAU(0): Printing probed modes for output eDP-2
[     7.253] (II) NOUVEAU(0): Modeline "2880x1800"x60.0  337.75  2880 2928 2960 3040  1800 1803 1809 1852 +hsync -vsync (111.1 kHz eP)
[     7.253] (II) NOUVEAU(0): Modeline "1920x1200"x59.9  193.25  1920 2056 2256 2592  1200 1203 1209 1245 -hsync +vsync (74.6 kHz e)
[     7.253] (II) NOUVEAU(0): Modeline "1920x1080"x60.0  173.00  1920 2048 2248 2576  1080 1083 1088 1120 -hsync +vsync (67.2 kHz e)
[     7.253] (II) NOUVEAU(0): Modeline "1600x1200"x59.9  161.00  1600 1712 1880 2160  1200 1203 1207 1245 -hsync +vsync (74.5 kHz e)
[     7.253] (II) NOUVEAU(0): Modeline "1680x1050"x60.0  146.25  1680 1784 1960 2240  1050 1053 1059 1089 -hsync +vsync (65.3 kHz e)
[     7.253] (II) NOUVEAU(0): Modeline "1400x1050"x60.0  121.75  1400 1488 1632 1864  1050 1053 1057 1089 -hsync +vsync (65.3 kHz e)
[     7.253] (II) NOUVEAU(0): Modeline "1280x1024"x59.9  109.00  1280 1368 1496 1712  1024 1027 1034 1063 -hsync +vsync (63.7 kHz e)
[     7.253] (II) NOUVEAU(0): Modeline "1280x960"x59.9  101.25  1280 1360 1488 1696  960 963 967 996 -hsync +vsync (59.7 kHz e)
[     7.253] (II) NOUVEAU(0): Modeline "1152x864"x60.0   81.75  1152 1216 1336 1520  864 867 871 897 -hsync +vsync (53.8 kHz e)
[     7.253] (II) NOUVEAU(0): Modeline "1024x768"x59.9   63.50  1024 1072 1176 1328  768 771 775 798 -hsync +vsync (47.8 kHz e)
[     7.253] (II) NOUVEAU(0): Modeline "800x600"x59.9   38.25  800 832 912 1024  600 603 607 624 -hsync +vsync (37.4 kHz e)
[     7.253] (II) NOUVEAU(0): Modeline "640x480"x59.4   23.75  640 664 720 800  480 483 487 500 -hsync +vsync (29.7 kHz e)
[     7.253] (II) NOUVEAU(0): Modeline "720x400"x59.6   22.25  720 744 808 896  400 403 413 417 -hsync +vsync (24.8 kHz e)
[     7.253] (II) NOUVEAU(0): Modeline "640x400"x60.0   20.00  640 664 720 800  400 403 409 417 -hsync +vsync (25.0 kHz e)
[     7.253] (II) NOUVEAU(0): Modeline "640x350"x59.8   17.50  640 664 720 800  350 353 363 366 -hsync +vsync (21.9 kHz e)
[     7.257] (II) NOUVEAU(0): EDID for output DP-1
[     7.261] (II) NOUVEAU(0): EDID for output DP-2
[     7.264] (II) NOUVEAU(0): EDID for output HDMI-1
[     7.264] (II) NOUVEAU(0): Output eDP-2 connected
[     7.264] (II) NOUVEAU(0): Output DP-1 disconnected
[     7.264] (II) NOUVEAU(0): Output DP-2 disconnected
[     7.264] (II) NOUVEAU(0): Output HDMI-1 disconnected
[     7.264] (II) NOUVEAU(0): Using exact sizes for initial modes
[     7.264] (II) NOUVEAU(0): Output eDP-2 using initial mode 2880x1800
[     7.264] (II) NOUVEAU(0): Using default gamma of (1.0, 1.0, 1.0) unless otherwise stated.
[     7.264] (--) NOUVEAU(0): Virtual size is 2880x1800 (pitch 0)
[     7.264] (**) NOUVEAU(0):  Driver mode "2880x1800": 337.8 MHz (scaled from 0.0 MHz), 111.1 kHz, 60.0 Hz
[     7.264] (II) NOUVEAU(0): Modeline "2880x1800"x60.0  337.75  2880 2928 2960 3040  1800 1803 1809 1852 +hsync -vsync (111.1 kHz eP)
[     7.264] (**) NOUVEAU(0):  Driver mode "1920x1200": 193.2 MHz (scaled from 0.0 MHz), 74.6 kHz, 59.9 Hz
[     7.264] (II) NOUVEAU(0): Modeline "1920x1200"x59.9  193.25  1920 2056 2256 2592  1200 1203 1209 1245 -hsync +vsync (74.6 kHz e)
[     7.264] (**) NOUVEAU(0):  Driver mode "1920x1080": 173.0 MHz (scaled from 0.0 MHz), 67.2 kHz, 60.0 Hz
[     7.264] (II) NOUVEAU(0): Modeline "1920x1080"x60.0  173.00  1920 2048 2248 2576  1080 1083 1088 1120 -hsync +vsync (67.2 kHz e)
[     7.264] (**) NOUVEAU(0):  Driver mode "1600x1200": 161.0 MHz (scaled from 0.0 MHz), 74.5 kHz, 59.9 Hz
[     7.264] (II) NOUVEAU(0): Modeline "1600x1200"x59.9  161.00  1600 1712 1880 2160  1200 1203 1207 1245 -hsync +vsync (74.5 kHz e)
[     7.264] (**) NOUVEAU(0):  Driver mode "1680x1050": 146.2 MHz (scaled from 0.0 MHz), 65.3 kHz, 60.0 Hz
[     7.264] (II) NOUVEAU(0): Modeline "1680x1050"x60.0  146.25  1680 1784 1960 2240  1050 1053 1059 1089 -hsync +vsync (65.3 kHz e)
[     7.264] (**) NOUVEAU(0):  Driver mode "1400x1050": 121.8 MHz (scaled from 0.0 MHz), 65.3 kHz, 60.0 Hz
[     7.264] (II) NOUVEAU(0): Modeline "1400x1050"x60.0  121.75  1400 1488 1632 1864  1050 1053 1057 1089 -hsync +vsync (65.3 kHz e)
[     7.264] (**) NOUVEAU(0):  Driver mode "1280x1024": 109.0 MHz (scaled from 0.0 MHz), 63.7 kHz, 59.9 Hz
[     7.264] (II) NOUVEAU(0): Modeline "1280x1024"x59.9  109.00  1280 1368 1496 1712  1024 1027 1034 1063 -hsync +vsync (63.7 kHz e)
[     7.264] (**) NOUVEAU(0):  Driver mode "1280x960": 101.2 MHz (scaled from 0.0 MHz), 59.7 kHz, 59.9 Hz
[     7.264] (II) NOUVEAU(0): Modeline "1280x960"x59.9  101.25  1280 1360 1488 1696  960 963 967 996 -hsync +vsync (59.7 kHz e)
[     7.264] (**) NOUVEAU(0):  Driver mode "1152x864": 81.8 MHz (scaled from 0.0 MHz), 53.8 kHz, 60.0 Hz
[     7.264] (II) NOUVEAU(0): Modeline "1152x864"x60.0   81.75  1152 1216 1336 1520  864 867 871 897 -hsync +vsync (53.8 kHz e)
[     7.264] (**) NOUVEAU(0):  Driver mode "1024x768": 63.5 MHz (scaled from 0.0 MHz), 47.8 kHz, 59.9 Hz
[     7.264] (II) NOUVEAU(0): Modeline "1024x768"x59.9   63.50  1024 1072 1176 1328  768 771 775 798 -hsync +vsync (47.8 kHz e)
[     7.264] (**) NOUVEAU(0):  Driver mode "800x600": 38.2 MHz (scaled from 0.0 MHz), 37.4 kHz, 59.9 Hz
[     7.264] (II) NOUVEAU(0): Modeline "800x600"x59.9   38.25  800 832 912 1024  600 603 607 624 -hsync +vsync (37.4 kHz e)
[     7.264] (**) NOUVEAU(0):  Driver mode "640x480": 23.8 MHz (scaled from 0.0 MHz), 29.7 kHz, 59.4 Hz
[     7.264] (II) NOUVEAU(0): Modeline "640x480"x59.4   23.75  640 664 720 800  480 483 487 500 -hsync +vsync (29.7 kHz e)
[     7.264] (**) NOUVEAU(0):  Driver mode "720x400": 22.2 MHz (scaled from 0.0 MHz), 24.8 kHz, 59.6 Hz
[     7.264] (II) NOUVEAU(0): Modeline "720x400"x59.6   22.25  720 744 808 896  400 403 413 417 -hsync +vsync (24.8 kHz e)
[     7.264] (**) NOUVEAU(0):  Driver mode "640x400": 20.0 MHz (scaled from 0.0 MHz), 25.0 kHz, 60.0 Hz
[     7.264] (II) NOUVEAU(0): Modeline "640x400"x60.0   20.00  640 664 720 800  400 403 409 417 -hsync +vsync (25.0 kHz e)
[     7.264] (**) NOUVEAU(0):  Driver mode "640x350": 17.5 MHz (scaled from 0.0 MHz), 21.9 kHz, 59.8 Hz
[     7.264] (II) NOUVEAU(0): Modeline "640x350"x59.8   17.50  640 664 720 800  350 353 363 366 -hsync +vsync (21.9 kHz e)
[     7.264] (==) NOUVEAU(0): DPI set to (96, 96)
[     7.264] (II) Loading sub module "fb"
[     7.264] (II) LoadModule: "fb"
[     7.264] (II) Loading /usr/lib/xorg/modules/libfb.so
[     7.266] (II) Module fb: vendor="X.Org Foundation"
[     7.266] 	compiled for 1.13.2.901, module version = 1.0.0
[     7.266] 	ABI class: X.Org ANSI C Emulation, version 0.4
[     7.266] (II) Loading sub module "exa"
[     7.266] (II) LoadModule: "exa"
[     7.266] (II) Loading /usr/lib/xorg/modules/libexa.so
[     7.267] (II) Module exa: vendor="X.Org Foundation"
[     7.267] 	compiled for 1.13.2.901, module version = 2.6.0
[     7.267] 	ABI class: X.Org Video Driver, version 13.1
[     7.267] (II) Loading sub module "shadowfb"
[     7.267] (II) LoadModule: "shadowfb"
[     7.267] (II) Loading /usr/lib/xorg/modules/libshadowfb.so
[     7.267] (II) Module shadowfb: vendor="X.Org Foundation"
[     7.268] 	compiled for 1.13.2.901, module version = 1.0.0
[     7.268] 	ABI class: X.Org ANSI C Emulation, version 0.4
[     7.268] (==) intel(G0): Depth 24, (--) framebuffer bpp 32
[     7.268] (==) intel(G0): RGB weight 888
[     7.268] (==) intel(G0): Default visual is TrueColor
[     7.268] (--) intel(G0): Integrated Graphics Chipset: Intel(R) Ivybridge Mobile (GT2)
[     7.268] (**) intel(G0): Relaxed fencing enabled
[     7.268] (**) intel(G0): Wait on SwapBuffers? enabled
[     7.268] (**) intel(G0): Triple buffering? enabled
[     7.268] (**) intel(G0): Framebuffer tiled
[     7.268] (**) intel(G0): Pixmaps tiled
[     7.268] (**) intel(G0): 3D buffers tiled
[     7.268] (**) intel(G0): SwapBuffers wait enabled
[     7.268] (==) intel(G0): video overlay key set to 0x101fe
[     7.293] (II) intel(G0): Output VGA1 has no monitor section
[     7.320] (II) intel(G0): EDID for output VGA1
[     7.320] (II) intel(G0): Output VGA1 disconnected
[     7.320] (WW) intel(G0): No outputs definitely connected, trying again...
[     7.320] (II) intel(G0): Output VGA1 disconnected
[     7.320] (WW) intel(G0): Unable to find connected outputs - setting 1024x768 initial framebuffer
[     7.320] (II) intel(G0): Using default gamma of (1.0, 1.0, 1.0) unless otherwise stated.
[     7.320] (II) intel(G0): Kernel page flipping support detected, enabling
[     7.320] (==) intel(G0): DPI set to (96, 96)
[     7.320] (II) Loading sub module "fb"
[     7.320] (II) LoadModule: "fb"
[     7.320] (II) Loading /usr/lib/xorg/modules/libfb.so
[     7.320] (II) Module fb: vendor="X.Org Foundation"
[     7.320] 	compiled for 1.13.2.901, module version = 1.0.0
[     7.320] 	ABI class: X.Org ANSI C Emulation, version 0.4
[     7.320] (II) Loading sub module "dri2"
[     7.320] (II) LoadModule: "dri2"
[     7.320] (II) Module "dri2" already built-in
[     7.320] (--) Depth 24 pixmap format is 32 bpp
[     7.320] (II) intel(G0): [DRI2] Setup complete
[     7.320] (II) intel(G0): [DRI2]   DRI driver: i965
[     7.320] (II) intel(G0): Allocated new frame buffer 2880x1800 stride 11776, tiled
[     7.321] (II) UXA(256): Driver registered support for the following operations:
[     7.321] (II)         solid
[     7.321] (II)         copy
[     7.321] (II)         composite (RENDER acceleration)
[     7.321] (II)         put_image
[     7.321] (II)         get_image
[     7.321] (==) intel(G0): Backing store disabled
[     7.321] (==) intel(G0): Silken mouse enabled
[     7.321] (II) intel(G0): Initializing HW Cursor
[     7.321] (II) intel(G0): RandR 1.2 enabled, ignore the following RandR disabled message.
[     7.322] (==) intel(G0): DPMS enabled
[     7.322] (==) intel(G0): Intel XvMC decoder enabled
[     7.322] (II) intel(G0): Set up textured video
[     7.322] (II) intel(G0): [XvMC] xvmc_vld driver initialized.
[     7.322] (II) intel(G0): direct rendering: DRI2 Enabled
[     7.322] (==) intel(G0): hotplug detection: "enabled"
[     7.323] (EE) NOUVEAU(0): Error creating GPU channel: -22
[     7.323] (EE) NOUVEAU(0): Error initialising acceleration.  Falling back to NoAccel
[     7.323] (==) NOUVEAU(0): Backing store disabled
[     7.323] (==) NOUVEAU(0): Silken mouse enabled
[     7.323] (==) NOUVEAU(0): DPMS enabled
[     7.323] (II) NOUVEAU(0): RandR 1.2 enabled, ignore the following RandR disabled message.
[     7.323] (--) RandR disabled
[     7.327] (II) AIGLX: Screen 0 is not DRI2 capable
[     7.327] (II) AIGLX: Screen 0 is not DRI capable
[     7.382] (II) AIGLX: Loaded and initialized swrast
[     7.382] (II) GLX: Initialized DRISWRAST GL provider for screen 0
[     7.397] (II) NOUVEAU(0): NVEnterVT is called.
[     7.400] (II) NOUVEAU(0): Setting screen physical size to 762 x 476
[     7.400] resize called 2880 1800
[     7.467] (II) config/udev: Adding input device Power Button (/dev/input/event4)
[     7.467] (**) Power Button: Applying InputClass "evdev keyboard catchall"
[     7.467] (II) LoadModule: "evdev"
[     7.467] (II) Loading /usr/lib/xorg/modules/input/evdev_drv.so
[     7.468] (II) Module evdev: vendor="X.Org Foundation"
[     7.468] 	compiled for 1.13.0, module version = 2.7.3
[     7.468] 	Module class: X.Org XInput Driver
[     7.468] 	ABI class: X.Org XInput driver, version 18.0
[     7.468] (II) Using input driver 'evdev' for 'Power Button'
[     7.468] (**) Power Button: always reports core events
[     7.469] (**) evdev: Power Button: Device: "/dev/input/event4"
[     7.469] (--) evdev: Power Button: Vendor 0 Product 0x1
[     7.469] (--) evdev: Power Button: Found keys
[     7.469] (II) evdev: Power Button: Configuring as keyboard
[     7.469] (**) Option "config_info" "udev:/sys/devices/LNXSYSTM:00/LNXPWRBN:00/input/input4/event4"
[     7.469] (II) XINPUT: Adding extended input device "Power Button" (type: KEYBOARD, id 6)
[     7.469] (**) Option "xkb_rules" "evdev"
[     7.469] (**) Option "xkb_model" "evdev"
[     7.469] (**) Option "xkb_layout" "us"
[     7.492] (II) config/udev: Adding input device Video Bus (/dev/input/event14)
[     7.492] (**) Video Bus: Applying InputClass "evdev keyboard catchall"
[     7.492] (II) Using input driver 'evdev' for 'Video Bus'
[     7.492] (**) Video Bus: always reports core events
[     7.492] (**) evdev: Video Bus: Device: "/dev/input/event14"
[     7.492] (--) evdev: Video Bus: Vendor 0 Product 0x6
[     7.492] (--) evdev: Video Bus: Found keys
[     7.492] (II) evdev: Video Bus: Configuring as keyboard
[     7.492] (**) Option "config_info" "udev:/sys/devices/LNXSYSTM:00/device:00/PNP0A08:00/LNXVIDEO:01/input/input14/event14"
[     7.492] (II) XINPUT: Adding extended input device "Video Bus" (type: KEYBOARD, id 7)
[     7.492] (**) Option "xkb_rules" "evdev"
[     7.492] (**) Option "xkb_model" "evdev"
[     7.492] (**) Option "xkb_layout" "us"
[     7.493] (II) config/udev: Adding input device Video Bus (/dev/input/event13)
[     7.493] (**) Video Bus: Applying InputClass "evdev keyboard catchall"
[     7.493] (II) Using input driver 'evdev' for 'Video Bus'
[     7.493] (**) Video Bus: always reports core events
[     7.493] (**) evdev: Video Bus: Device: "/dev/input/event13"
[     7.493] (--) evdev: Video Bus: Vendor 0 Product 0x6
[     7.493] (--) evdev: Video Bus: Found keys
[     7.493] (II) evdev: Video Bus: Configuring as keyboard
[     7.493] (**) Option "config_info" "udev:/sys/devices/LNXSYSTM:00/device:00/PNP0A08:00/device:02/LNXVIDEO:00/input/input13/event13"
[     7.493] (II) XINPUT: Adding extended input device "Video Bus" (type: KEYBOARD, id 8)
[     7.493] (**) Option "xkb_rules" "evdev"
[     7.493] (**) Option "xkb_model" "evdev"
[     7.493] (**) Option "xkb_layout" "us"
[     7.494] (II) config/udev: Adding input device Power Button (/dev/input/event1)
[     7.494] (**) Power Button: Applying InputClass "evdev keyboard catchall"
[     7.494] (II) Using input driver 'evdev' for 'Power Button'
[     7.494] (**) Power Button: always reports core events
[     7.494] (**) evdev: Power Button: Device: "/dev/input/event1"
[     7.494] (--) evdev: Power Button: Vendor 0 Product 0x1
[     7.494] (--) evdev: Power Button: Found keys
[     7.494] (II) evdev: Power Button: Configuring as keyboard
[     7.494] (**) Option "config_info" "udev:/sys/devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input1/event1"
[     7.494] (II) XINPUT: Adding extended input device "Power Button" (type: KEYBOARD, id 9)
[     7.494] (**) Option "xkb_rules" "evdev"
[     7.494] (**) Option "xkb_model" "evdev"
[     7.494] (**) Option "xkb_layout" "us"
[     7.495] (II) config/udev: Adding input device Lid Switch (/dev/input/event0)
[     7.495] (II) No input driver specified, ignoring this device.
[     7.495] (II) This device may have been added with another device file.
[     7.495] (II) config/udev: Adding input device Sleep Button (/dev/input/event2)
[     7.495] (**) Sleep Button: Applying InputClass "evdev keyboard catchall"
[     7.495] (II) Using input driver 'evdev' for 'Sleep Button'
[     7.495] (**) Sleep Button: always reports core events
[     7.495] (**) evdev: Sleep Button: Device: "/dev/input/event2"
[     7.495] (--) evdev: Sleep Button: Vendor 0 Product 0x3
[     7.495] (--) evdev: Sleep Button: Found keys
[     7.495] (II) evdev: Sleep Button: Configuring as keyboard
[     7.495] (**) Option "config_info" "udev:/sys/devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input2/event2"
[     7.495] (II) XINPUT: Adding extended input device "Sleep Button" (type: KEYBOARD, id 10)
[     7.495] (**) Option "xkb_rules" "evdev"
[     7.495] (**) Option "xkb_model" "evdev"
[     7.495] (**) Option "xkb_layout" "us"
[     7.496] (II) config/udev: Adding drm device (/dev/dri/card1)
[     7.496] (II) config/udev: Adding input device HDA NVidia HDMI/DP,pcm=7 (/dev/input/event10)
[     7.496] (II) No input driver specified, ignoring this device.
[     7.496] (II) This device may have been added with another device file.
[     7.496] (II) config/udev: Adding input device HDA NVidia HDMI/DP,pcm=3 (/dev/input/event11)
[     7.496] (II) No input driver specified, ignoring this device.
[     7.496] (II) This device may have been added with another device file.
[     7.497] (II) config/udev: Adding input device HDA NVidia HDMI/DP,pcm=8 (/dev/input/event9)
[     7.497] (II) No input driver specified, ignoring this device.
[     7.497] (II) This device may have been added with another device file.
[     7.497] (II) config/udev: Adding drm device (/dev/dri/card0)
[     7.497] (II) config/udev: Adding input device HDA Intel PCH Headphone (/dev/input/event5)
[     7.497] (II) No input driver specified, ignoring this device.
[     7.497] (II) This device may have been added with another device file.
[     7.497] (II) config/udev: Adding input device Apple Inc. Apple Internal Keyboard / Trackpad (/dev/input/event6)
[     7.497] (**) Apple Inc. Apple Internal Keyboard / Trackpad: Applying InputClass "evdev keyboard catchall"
[     7.497] (II) Using input driver 'evdev' for 'Apple Inc. Apple Internal Keyboard / Trackpad'
[     7.497] (**) Apple Inc. Apple Internal Keyboard / Trackpad: always reports core events
[     7.497] (**) evdev: Apple Inc. Apple Internal Keyboard / Trackpad: Device: "/dev/input/event6"
[     7.497] (--) evdev: Apple Inc. Apple Internal Keyboard / Trackpad: Vendor 0x5ac Product 0x262
[     7.497] (--) evdev: Apple Inc. Apple Internal Keyboard / Trackpad: Found keys
[     7.497] (II) evdev: Apple Inc. Apple Internal Keyboard / Trackpad: Configuring as keyboard
[     7.497] (**) Option "config_info" "udev:/sys/devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.8/2-1.8.2/2-1.8.2:1.0/input/input6/event6"
[     7.497] (II) XINPUT: Adding extended input device "Apple Inc. Apple Internal Keyboard / Trackpad" (type: KEYBOARD, id 11)
[     7.497] (**) Option "xkb_rules" "evdev"
[     7.497] (**) Option "xkb_model" "evdev"
[     7.497] (**) Option "xkb_layout" "us"
[     7.497] (II) config/udev: Adding input device bcm5974 (/dev/input/event7)
[     7.497] (**) bcm5974: Applying InputClass "evdev touchpad catchall"
[     7.497] (**) bcm5974: Applying InputClass "touchpad catchall"
[     7.497] (**) bcm5974: Applying InputClass "Default clickpad buttons"
[     7.497] (**) bcm5974: Applying InputClass "Disable clickpad buttons on Apple touchpads"
[     7.497] (II) LoadModule: "synaptics"
[     7.497] (II) Loading /usr/lib/xorg/modules/input/synaptics_drv.so
[     7.498] (II) Module synaptics: vendor="X.Org Foundation"
[     7.498] 	compiled for 1.13.2, module version = 1.6.3
[     7.498] 	Module class: X.Org XInput Driver
[     7.498] 	ABI class: X.Org XInput driver, version 18.0
[     7.498] (II) Using input driver 'synaptics' for 'bcm5974'
[     7.498] (**) bcm5974: always reports core events
[     7.498] (**) Option "Device" "/dev/input/event7"
[     7.524] (II) synaptics: bcm5974: found clickpad property
[     7.524] (--) synaptics: bcm5974: x-axis range -4750 - 5280
[     7.524] (--) synaptics: bcm5974: y-axis range -150 - 6730
[     7.524] (--) synaptics: bcm5974: pressure range 0 - 256
[     7.524] (--) synaptics: bcm5974: finger width range 0 - 16
[     7.524] (--) synaptics: bcm5974: buttons: left double triple
[     7.524] (--) synaptics: bcm5974: Vendor 0x5ac Product 0x262
[     7.524] (**) Option "TapButton1" "1"
[     7.524] (**) Option "TapButton2" "2"
[     7.524] (**) Option "TapButton3" "3"
[     7.524] (**) Option "SoftButtonAreas" "0 0 0 0 0 0 0 0"
[     7.524] (--) synaptics: bcm5974: touchpad found
[     7.524] (**) bcm5974: always reports core events
[     7.540] (**) Option "config_info" "udev:/sys/devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.8/2-1.8.2/2-1.8.2:1.2/input/input7/event7"
[     7.540] (II) XINPUT: Adding extended input device "bcm5974" (type: TOUCHPAD, id 12)
[     7.540] (**) synaptics: bcm5974: (accel) MinSpeed is now constant deceleration 2.5
[     7.540] (**) synaptics: bcm5974: MaxSpeed is now 1.75
[     7.540] (**) synaptics: bcm5974: AccelFactor is now 0.016
[     7.540] (**) bcm5974: (accel) keeping acceleration scheme 1
[     7.540] (**) bcm5974: (accel) acceleration profile 1
[     7.540] (**) bcm5974: (accel) acceleration factor: 2.000
[     7.540] (**) bcm5974: (accel) acceleration threshold: 4
[     7.542] (--) synaptics: bcm5974: touchpad found
[     7.542] (II) config/udev: Adding input device bcm5974 (/dev/input/mouse0)
[     7.542] (**) bcm5974: Ignoring device from InputClass "touchpad ignore duplicates"
[     7.543] (II) config/udev: Adding input device PC Speaker (/dev/input/event3)
[     7.543] (II) No input driver specified, ignoring this device.
[     7.543] (II) This device may have been added with another device file.
[     7.548] (II) config/udev: Adding input device (unnamed) (/dev/input/event12)
[     7.549] (**) (unnamed): Applying InputClass "evdev pointer catchall"
[     7.549] (II) Using input driver 'evdev' for '(unnamed)'
[     7.549] (**) (unnamed): always reports core events
[     7.549] (**) evdev: (unnamed): Device: "/dev/input/event12"
[     7.549] (EE) evdev: (unnamed): Unable to open evdev device "/dev/input/event12".
[     7.549] (EE) PreInit returned 2 for "(unnamed)"
[     7.549] (II) UnloadModule: "evdev"
[     7.549] (II) config/udev: Adding input device (unnamed) (/dev/input/mouse1)
[     7.549] (II) No input driver specified, ignoring this device.
[     7.549] (II) This device may have been added with another device file.
[     7.549] (II) config/udev: Adding input device (unnamed) (/dev/input/event8)
[     7.549] (**) (unnamed): Applying InputClass "evdev keyboard catchall"
[     7.549] (II) Using input driver 'evdev' for '(unnamed)'
[     7.549] (**) (unnamed): always reports core events
[     7.549] (**) evdev: (unnamed): Device: "/dev/input/event8"
[     7.550] (EE) evdev: (unnamed): Unable to open evdev device "/dev/input/event8".
[     7.550] (EE) PreInit returned 2 for "(unnamed)"
[     7.550] (II) UnloadModule: "evdev"
[     7.550] removing GPU device /sys/devices/pci0000:00/0000:00:01.0/0000:01:00.0/drm/card1 15597408
[     7.550] xf86: remove device 0 /sys/devices/pci0000:00/0000:00:01.0/0000:01:00.0/drm/card1
[     7.551] failed to find screen to remove
[     7.551] (II) config/udev: Adding drm device (/dev/dri/card1)
[     7.551] removing GPU device /sys/devices/pci0000:00/0000:00:01.0/0000:01:00.0/drm/card1/card1-eDP-2 0
[     7.551] removing GPU device /sys/devices/pci0000:00/0000:00:01.0/0000:01:00.0/drm/card1/card1-DP-1 0
[     7.551] removing GPU device /sys/devices/pci0000:00/0000:00:01.0/0000:01:00.0/drm/card1/card1-DP-2 0
[     7.551] removing GPU device /sys/devices/pci0000:00/0000:00:01.0/0000:01:00.0/drm/card1/card1-HDMI-A-1 0
[     7.556] (II) NOUVEAU(0): EDID vendor "APP", prod id 40975
[     7.556] (II) NOUVEAU(0): Printing DDC gathered Modelines:
[     7.556] (II) NOUVEAU(0): Modeline "2880x1800"x0.0  337.75  2880 2928 2960 3040  1800 1803 1809 1852 +hsync -vsync (111.1 kHz eP)
[     8.119] (II) NOUVEAU(0): EDID vendor "APP", prod id 40975
[     8.119] (II) NOUVEAU(0): Printing DDC gathered Modelines:
[     8.119] (II) NOUVEAU(0): Modeline "2880x1800"x0.0  337.75  2880 2928 2960 3040  1800 1803 1809 1852 +hsync -vsync (111.1 kHz eP)
[    20.417] (II) NOUVEAU(0): EDID vendor "APP", prod id 40975
[    20.417] (II) NOUVEAU(0): Printing DDC gathered Modelines:
[    20.417] (II) NOUVEAU(0): Modeline "2880x1800"x0.0  337.75  2880 2928 2960 3040  1800 1803 1809 1852 +hsync -vsync (111.1 kHz eP)
[    20.707] (II) NOUVEAU(0): EDID vendor "APP", prod id 40975
[    20.707] (II) NOUVEAU(0): Printing DDC gathered Modelines:
[    20.707] (II) NOUVEAU(0): Modeline "2880x1800"x0.0  337.75  2880 2928 2960 3040  1800 1803 1809 1852 +hsync -vsync (111.1 kHz eP)
[    20.866] (II) NOUVEAU(0): EDID vendor "APP", prod id 40975
[    20.866] (II) NOUVEAU(0): Printing DDC gathered Modelines:
[    20.866] (II) NOUVEAU(0): Modeline "2880x1800"x0.0  337.75  2880 2928 2960 3040  1800 1803 1809 1852 +hsync -vsync (111.1 kHz eP)
[    38.697] (II) NOUVEAU(0): EDID vendor "APP", prod id 40975
[    38.697] (II) NOUVEAU(0): Printing DDC gathered Modelines:
[    38.697] (II) NOUVEAU(0): Modeline "2880x1800"x0.0  337.75  2880 2928 2960 3040  1800 1803 1809 1852 +hsync -vsync (111.1 kHz eP)
[    38.716] resize called 2880 1800
[    39.006] (II) NOUVEAU(0): EDID vendor "APP", prod id 40975
[    39.006] (II) NOUVEAU(0): Printing DDC gathered Modelines:
[    39.006] (II) NOUVEAU(0): Modeline "2880x1800"x0.0  337.75  2880 2928 2960 3040  1800 1803 1809 1852 +hsync -vsync (111.1 kHz eP)
[    39.253] (II) NOUVEAU(0): EDID vendor "APP", prod id 40975
[    39.253] (II) NOUVEAU(0): Printing DDC gathered Modelines:
[    39.253] (II) NOUVEAU(0): Modeline "2880x1800"x0.0  337.75  2880 2928 2960 3040  1800 1803 1809 1852 +hsync -vsync (111.1 kHz eP)
[    39.913] (II) NOUVEAU(0): NVLeaveVT is called.
[    46.883] (II) NOUVEAU(0): NVEnterVT is called.
[    47.081] (II) NOUVEAU(0): EDID vendor "APP", prod id 40975
[    47.081] (II) NOUVEAU(0): Printing DDC gathered Modelines:
[    47.081] (II) NOUVEAU(0): Modeline "2880x1800"x0.0  337.75  2880 2928 2960 3040  1800 1803 1809 1852 +hsync -vsync (111.1 kHz eP)
[    47.150] (--) synaptics: bcm5974: touchpad found
[    48.928] (II) NOUVEAU(0): EDID vendor "APP", prod id 40975
[    48.928] (II) NOUVEAU(0): Printing DDC gathered Modelines:
[    48.928] (II) NOUVEAU(0): Modeline "2880x1800"x0.0  337.75  2880 2928 2960 3040  1800 1803 1809 1852 +hsync -vsync (111.1 kHz eP)
[    48.950] resize called 2880 1800

--EVF5PPMfhYS0aIcm--
