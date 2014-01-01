Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754242AbaAAOEr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jan 2014 09:04:47 -0500
Received: from know-smtprelay-omc-1.server.virginmedia.net ([80.0.253.65]:54979
	"EHLO know-smtprelay-omc-1.server.virginmedia.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753970AbaAAOEp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jan 2014 09:04:45 -0500
X-Originating-IP: [82.36.39.136]
X-Spam: 0
X-Authority: v=2.1 cv=WI/xXxcR c=1 sm=1 tr=0 a=h3ZJzbuz6X3s3VlFudNWSw==:117
 a=h3ZJzbuz6X3s3VlFudNWSw==:17 a=6vexxxhns_QA:10 a=fZX2ME0dHmMA:10
 a=3NElcqgl2aoA:10 a=k1j_C7plYBUA:10 a=a5Gf7U6LAAAA:8 a=9wwvVaL5uFYA:10
 a=r77TgQKjGQsHNAKrUKIA:9 a=9iDbn-4jx3cA:10 a=cKsnjEOsciEA:10 a=aR16PxjQAAAA:8
 a=9oIARtNkiUse0-itiTsA:9 a=JaSszSP0i6nZ5z0j:21 a=S9pMSJ-9TWAk49AW:21
 a=wPNLvfGTeEIA:10 a=CiSHi91Bn78A:10 a=yHIqe9kG5mgA:10
 a=l4_8YrWuMFbGUYMMyz0A:9 a=49ladYHvHUoA:10 a=e5mUnYsNAAAA:8
 a=oqdJn5yxE9SkZLy2chUA:9 a=AeQODK12sm9M-N0f:21 a=iyrQEKc7hfnNS2in:21
 a=zUfKZcXaiyZdBXN_:21 a=57ZKFFc7odEA:10 a=qqlwiqL-QEIA:10 a=m7jhuX_RuCIA:10
 a=h71UUtTGq9UA:10 a=JXQJvpueyLIA:10 a=4MV12Pj9_AoA:10 a=TRaWWqdqQ4oA:10
 a=aWTTYslQkP0A:10
Message-ID: <52C42079.6060604@blueyonder.co.uk>
Date: Wed, 01 Jan 2014 14:04:41 +0000
From: Sid Boyce <sboyce@blueyonder.co.uk>
Reply-To: sboyce@blueyonder.co.uk
Organization: blueyonder.co.uk
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Ilia Mirkin <imirkin@alum.mit.edu>
CC: LKML Mailing List <linux-kernel@vger.kernel.org>,
        opensuse factory list <opensuse-factory@opensuse.org>,
        "nouveau@lists.freedesktop.org" <nouveau@lists.freedesktop.org>
Subject: Re: Possible 3.13-rc nouveau regression with GT 560 Ti
References: <52C29918.4060102@blueyonder.co.uk>	<CAKb7UvhBunpMC6mzjRg7Zb5gGPPYj99=2jd+Lgnr-qeXFs0w9A@mail.gmail.com>	<52C3644C.9090809@blueyonder.co.uk> <CAKb7UviLpfZMtZM9X1R0Eaj=5ww2k=T+7x01dZH3ns2Ew1HuFw@mail.gmail.com>
In-Reply-To: <CAKb7UviLpfZMtZM9X1R0Eaj=5ww2k=T+7x01dZH3ns2Ew1HuFw@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------000406030101080009000603"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000406030101080009000603
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 01/01/14 00:55, Ilia Mirkin wrote:
> On Tue, Dec 31, 2013 at 7:41 PM, Sid Boyce <sboyce@blueyonder.co.uk> wrote:
>> On 31/12/13 10:36, Ilia Mirkin wrote:
>>> On Tue, Dec 31, 2013 at 5:14 AM, Sid Boyce <sboyce@blueyonder.co.uk>
>>> wrote:
>>>> System x86_64 with openSUSE 13.1.
>>>> X.Org version: 1.14.99.905
>>>>
>>>> openSUSE 12.2 kernels boot successfully into a graphical screen, login to
>>>> KDE4, etc. all normal.
>>>>
>>>> 3.13-rc kernels boot fully with X running but no graphical screen and it
>>>> freezes in VC with not all the startup messages displayed but I could ssh
>>>> in
>>>> from another box to check dmesg and logs.
>>>>
>>>> Xorg.0.log which I thought I had saved did not log an error.
>>>>
>>>> dmesg said "nouveau Playlist update failed".
>>>>
>>>> Changed the GeForce GT 560 Ti for a GeForce 8600 GT and 3.13.0-rc6 is up
>>>> and
>>>> running.
>>>>
>>>> If necessary I can go back to the GT 560 Ti to gather dmesg and Xorg log
>>>> information.
>>> Having a dmesg would be nice. One thing I can think of off-hand is
>>> that 3.13-rc has MSI turned on by default. You can turn it off by
>>> adding "nouveau.config=NvMSI=0" to your kernel cmdline. If that
>>> doesn't help, a bisect restricted to drivers/gpu/drm/nouveau should
>>> show the offending commit fairly quickly.
>>>
>>>     -ilia
>>>
>> Adding "nouveau.config=NvMSI=0" to the command line fixed the problem.
>> So it looks like commit 049ffa8ab33a63b3bff672d1a0ee6a35ad253fe8 introduced
>> it.
> Any chance you might mmiotrace the blob (version 325 or later) to see
> which registers it fiddles with? Or alternatively, if you have a NVCE
> card (you never did end up providing the logs which would have made
> that apparent), could you try replacing nvc3_mc_oclass with
> nvc0_mc_oclass for the 0xce case in
> drivers/gpu/drm/nouveau/core/engine/device/nvc0.c? (and boot without
> the MSI disabling.) The switch has already been made for NVC8 in
> 0bae1d61c75 -- perhaps there are more "odd" ones.
>
>    -ilia
>
Fails exactly the same.
         case 0xc3:
                 device->cname = "GF106";
                 device->oclass[NVDEV_SUBDEV_VBIOS  ] = 
&nouveau_bios_oclass;
                 device->oclass[NVDEV_SUBDEV_GPIO   ] = &nv50_gpio_oclass;
                 device->oclass[NVDEV_SUBDEV_I2C    ] = &nv94_i2c_oclass;
                 device->oclass[NVDEV_SUBDEV_CLOCK  ] = &nvc0_clock_oclass;
                 device->oclass[NVDEV_SUBDEV_THERM  ] = &nva3_therm_oclass;
                 device->oclass[NVDEV_SUBDEV_MXM    ] = &nv50_mxm_oclass;
                 device->oclass[NVDEV_SUBDEV_DEVINIT] = 
&nvc0_devinit_oclass;
                 device->oclass[NVDEV_SUBDEV_MC     ] = 
nvc0_mc_oclass;      <<<<<====
                 device->oclass[NVDEV_SUBDEV_BUS    ] = nvc0_bus_oclass;
                 device->oclass[NVDEV_SUBDEV_TIMER  ] = &nv04_timer_oclass;

The dmesg and Xorg.0.log with the problem captured across a ssh link.

# ps fax|grep X
  5633 pts/0    S+     0:00          \_ grep --color=auto X
  5160 tty7     Ss+    0:08  \_ /usr/bin/Xorg -br :0 vt7 -nolisten tcp 
-auth /var/lib/kdm/AuthFiles/A:0-yqspza

Also
# echo mmiotrace > /sys/kernel/debug/tracing/current_tracer
-bash: echo: write error: Invalid argument.

# ls -l /sys/kernel/debug/tracing/current_tracer
-rw-r--r-- 1 root root 0 Jan  1 14:00 
/sys/kernel/debug/tracing/current_tracer
Regards
Sid.

-- 
Sid Boyce ... Hamradio License G3VBV, Licensed Private Pilot
Emeritus IBM/Amdahl Mainframes and Sun/Fujitsu Servers Tech Support
Senior Staff Specialist, Cricket Coach
Microsoft Windows Free Zone - Linux used for all Computing Tasks


--------------000406030101080009000603
Content-Type: application/x-gzip;
 name="dmesg.gz"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="dmesg.gz"

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
Tcixk7XPKkrm+80+4YCiAuPzvbpH6jrbdlfV1nzfda3W6MlyVfdx5Xm364X9X6/Hd4NqA8/C
Oa13kvprPT7N4cKpa9YugLnMa/yeJy2ittuFZSC2RL4T6NBIcKTpHYneq/WpQiDb8/chMNqO
S57s7A4wKEOtkAF5QgYcdfh0XN5n2+6X+hrZQB6c9I5XNJMB9bzR+cKyDMhuGQCNVGkxUbii
K+WJrlRAw/gbQJ8WsLjV4HHSr2gfNXd+Ht//ThMb0mKpgGemVhu4WoXCaVLsF/EJkNsE7ean
QH47aDx8Olg09cxIq8xfgzUiGNuJTAl7SrI+XFNjqLnmbb1MFuKC7J1v2+jldScu+pdkmviO
2LxF219Wm3Ww0JKvM20RXuY8yHdnE8/w6aqv0nF/KmJ8TUMzDHUxChXuNgtS+HAIVG5CeuGH
g1XkCE54z5vrofqoyB+c74tnxCbWZnZGnCdH8fWrhDBrqFlYOnG4jTZUK8QjL9OPJwPXC730
fJu4SGFyRHxRiXG4WybiJyrgT/VDjdRYVViLzFSXbzE7Jfets2FzCJiQZMPQnc60Vo/hPIyQ
lmsbkn1L0whZUcv3ffKKzJ2wfUUKSLc/EbvM1BZN8JapI77miKIMVcKJ0hixSKhIDMzjg6uJ
sx04C/K9Xd3voxYlk3HRgnR1rJNONGsxjzWb0vY1SVYK1mtc7t0mVqG/GBwvYX5W8DOUaBy8
BLusWxXSR2x6d43bS66Q7mmBKLRvo+S0VtcsT/rY/RjMeBWe8NlpzRzEc45NswvcgeO/1IM9
HrZYRF8hTJglOXrH0U4fey7TMFgprA0nGh25VaLY+V6wizBc37FrS4TJ8H74UN/vQdpK6F6a
LBYY0yqtpuJBc1l86fY/4sFpKK3XOZU+QkskCo+T3d0Fze+eTXaFhZMTs2dQ08fR4iPZs7rY
I+hIbN4X9Cz9atFKxXewSOady6D4cxIm9b/iK3jE088f/g8ByCl3uEEBAA==
--------------000406030101080009000603
Content-Type: text/x-log;
 name="Xorg.0.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="Xorg.0.log"

[   102.323] 
This is a pre-release version of the X server from The X.Org Foundation.
It is not supported in any way.
Bugs may be filed in the bugzilla at http://bugs.freedesktop.org/.
Select the "xorg" product for bugs you find in this release.
Before reporting bugs in pre-release versions please check the
latest version in the X.Org Foundation git repository.
See http://wiki.x.org/wiki/GitPage for git access instructions.
[   102.323] 
X.Org X Server 1.14.99.905 (1.15.0 RC 5)
Release Date: 2013-12-19
[   102.323] X Protocol Version 11, Revision 0
[   102.323] Build Operating System: openSUSE SUSE LINUX
[   102.323] Current Operating System: Linux slipstream 3.13.0-rc61-smp+ #1 SMP PREEMPT Wed Jan 1 13:20:30 GMT 2014 x86_64
[   102.323] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-3.13.0-rc61-smp+ root=UUID=9e02a4c0-c401-4874-a706-30ec3f0a98aa quiet splash
[   102.323] Build Date: 22 December 2013  07:18:32PM
[   102.323]  
[   102.323] Current version of pixman: 0.32.4
[   102.323] 	Before reporting problems, check http://wiki.x.org
	to make sure that you have the latest version.
[   102.323] Markers: (--) probed, (**) from config file, (==) default setting,
	(++) from command line, (!!) notice, (II) informational,
	(WW) warning, (EE) error, (NI) not implemented, (??) unknown.
[   102.323] (==) Log file: "/var/log/Xorg.0.log", Time: Wed Jan  1 13:25:36 2014
[   102.323] (==) Using config directory: "/etc/X11/xorg.conf.d"
[   102.323] (==) Using system config directory "/usr/share/X11/xorg.conf.d"
[   102.324] (==) No Layout section.  Using the first Screen section.
[   102.324] (==) No screen section available. Using defaults.
[   102.324] (**) |-->Screen "Default Screen Section" (0)
[   102.324] (**) |   |-->Monitor "<default monitor>"
[   102.324] (==) No monitor specified for screen "Default Screen Section".
	Using a default monitor configuration.
[   102.324] (==) Automatically adding devices
[   102.324] (==) Automatically enabling devices
[   102.324] (==) Automatically adding GPU devices
[   102.324] (WW) The directory "/usr/share/fonts/misc/sgi" does not exist.
[   102.324] 	Entry deleted from font path.
[   102.324] (==) FontPath set to:
	/usr/share/fonts/misc:unscaled,
	/usr/share/fonts/Type1/,
	/usr/share/fonts/100dpi:unscaled,
	/usr/share/fonts/75dpi:unscaled,
	/usr/share/fonts/ghostscript/,
	/usr/share/fonts/cyrillic:unscaled,
	/usr/share/fonts/truetype/,
	built-ins
[   102.324] (==) ModulePath set to "/usr/lib64/xorg/modules/updates,/usr/lib64/xorg/modules"
[   102.324] (II) The server relies on udev to provide the list of input devices.
	If no devices become available, reconfigure udev or disable AutoAddDevices.
[   102.324] (II) Loader magic: 0x80ac60
[   102.324] (II) Module ABI versions:
[   102.324] 	X.Org ANSI C Emulation: 0.4
[   102.324] 	X.Org Video Driver: 15.0
[   102.324] 	X.Org XInput driver : 20.0
[   102.324] 	X.Org Server Extension : 8.0
[   102.324] (II) xfree86: Adding drm device (/dev/dri/card0)
[   102.326] (--) PCI:*(0:1:0:0) 10de:1200:1043:838b rev 161, Mem @ 0xf8000000/33554432, 0xd0000000/134217728, 0xdc000000/67108864, I/O @ 0x0000cf00/128, BIOS @ 0x????????/524288
[   102.326] Initializing built-in extension Generic Event Extension
[   102.326] Initializing built-in extension SHAPE
[   102.326] Initializing built-in extension MIT-SHM
[   102.326] Initializing built-in extension XInputExtension
[   102.326] Initializing built-in extension XTEST
[   102.326] Initializing built-in extension BIG-REQUESTS
[   102.326] Initializing built-in extension SYNC
[   102.326] Initializing built-in extension XKEYBOARD
[   102.326] Initializing built-in extension XC-MISC
[   102.326] Initializing built-in extension SECURITY
[   102.326] Initializing built-in extension XINERAMA
[   102.326] Initializing built-in extension XFIXES
[   102.326] Initializing built-in extension RENDER
[   102.326] Initializing built-in extension RANDR
[   102.326] Initializing built-in extension COMPOSITE
[   102.326] Initializing built-in extension DAMAGE
[   102.326] Initializing built-in extension MIT-SCREEN-SAVER
[   102.326] Initializing built-in extension DOUBLE-BUFFER
[   102.326] Initializing built-in extension RECORD
[   102.326] Initializing built-in extension DPMS
[   102.326] Initializing built-in extension Present
[   102.326] Initializing built-in extension DRI3
[   102.326] Initializing built-in extension X-Resource
[   102.326] Initializing built-in extension XVideo
[   102.326] Initializing built-in extension XVideo-MotionCompensation
[   102.326] Initializing built-in extension XFree86-VidModeExtension
[   102.326] Initializing built-in extension XFree86-DGA
[   102.326] Initializing built-in extension XFree86-DRI
[   102.326] Initializing built-in extension DRI2
[   102.326] (II) LoadModule: "glx"
[   102.389] (II) Loading /usr/lib64/xorg/modules/extensions/libglx.so
[   102.390] (II) Module glx: vendor="X.Org Foundation"
[   102.390] 	compiled for 1.14.99.905, module version = 1.0.0
[   102.390] 	ABI class: X.Org Server Extension, version 8.0
[   102.390] (==) AIGLX enabled
[   102.390] Loading extension GLX
[   102.390] (==) Matched nvidia as autoconfigured driver 0
[   102.390] (==) Matched nouveau as autoconfigured driver 1
[   102.390] (==) Matched nv as autoconfigured driver 2
[   102.390] (==) Matched nvidia as autoconfigured driver 3
[   102.390] (==) Matched nouveau as autoconfigured driver 4
[   102.390] (==) Matched nv as autoconfigured driver 5
[   102.390] (==) Matched modesetting as autoconfigured driver 6
[   102.390] (==) Matched fbdev as autoconfigured driver 7
[   102.390] (==) Matched vesa as autoconfigured driver 8
[   102.390] (==) Assigned the driver to the xf86ConfigLayout
[   102.390] (II) LoadModule: "nvidia"
[   102.400] (WW) Warning, couldn't open module nvidia
[   102.400] (II) UnloadModule: "nvidia"
[   102.400] (II) Unloading nvidia
[   102.400] (EE) Failed to load module "nvidia" (module does not exist, 0)
[   102.400] (II) LoadModule: "nouveau"
[   102.400] (II) Loading /usr/lib64/xorg/modules/drivers/nouveau_drv.so
[   102.401] (II) Module nouveau: vendor="X.Org Foundation"
[   102.401] 	compiled for 1.14.99.904, module version = 1.0.10
[   102.401] 	Module class: X.Org Video Driver
[   102.401] 	ABI class: X.Org Video Driver, version 15.0
[   102.401] (II) LoadModule: "nv"
[   102.401] (WW) Warning, couldn't open module nv
[   102.401] (II) UnloadModule: "nv"
[   102.401] (II) Unloading nv
[   102.401] (EE) Failed to load module "nv" (module does not exist, 0)
[   102.401] (II) LoadModule: "modesetting"
[   102.401] (II) Loading /usr/lib64/xorg/modules/drivers/modesetting_drv.so
[   102.401] (II) Module modesetting: vendor="X.Org Foundation"
[   102.401] 	compiled for 1.14.99.904, module version = 0.8.0
[   102.401] 	Module class: X.Org Video Driver
[   102.401] 	ABI class: X.Org Video Driver, version 15.0
[   102.401] (II) LoadModule: "fbdev"
[   102.401] (II) Loading /usr/lib64/xorg/modules/drivers/fbdev_drv.so
[   102.401] (II) Module fbdev: vendor="X.Org Foundation"
[   102.401] 	compiled for 1.14.99.904, module version = 0.4.4
[   102.402] 	Module class: X.Org Video Driver
[   102.402] 	ABI class: X.Org Video Driver, version 15.0
[   102.402] (II) LoadModule: "vesa"
[   102.402] (II) Loading /usr/lib64/xorg/modules/drivers/vesa_drv.so
[   102.402] (II) Module vesa: vendor="X.Org Foundation"
[   102.402] 	compiled for 1.14.99.904, module version = 2.3.3
[   102.402] 	Module class: X.Org Video Driver
[   102.402] 	ABI class: X.Org Video Driver, version 15.0
[   102.402] (II) NOUVEAU driver 
[   102.402] (II) NOUVEAU driver for NVIDIA chipset families :
[   102.402] 	RIVA TNT        (NV04)
[   102.402] 	RIVA TNT2       (NV05)
[   102.402] 	GeForce 256     (NV10)
[   102.402] 	GeForce 2       (NV11, NV15)
[   102.402] 	GeForce 4MX     (NV17, NV18)
[   102.402] 	GeForce 3       (NV20)
[   102.402] 	GeForce 4Ti     (NV25, NV28)
[   102.402] 	GeForce FX      (NV3x)
[   102.402] 	GeForce 6       (NV4x)
[   102.402] 	GeForce 7       (G7x)
[   102.402] 	GeForce 8       (G8x)
[   102.402] 	GeForce GTX 200 (NVA0)
[   102.402] 	GeForce GTX 400 (NVC0)
[   102.402] (II) modesetting: Driver for Modesetting Kernel Drivers: kms
[   102.402] (II) FBDEV: driver for framebuffer: fbdev
[   102.402] (II) VESA: driver for VESA chipsets: vesa
[   102.402] (++) using VT number 7

[   102.402] (II) [drm] nouveau interface version: 1.1.1
[   102.402] (WW) Falling back to old probe method for modesetting
[   102.403] (WW) Falling back to old probe method for fbdev
[   102.403] (II) Loading sub module "fbdevhw"
[   102.403] (II) LoadModule: "fbdevhw"
[   102.403] (II) Loading /usr/lib64/xorg/modules/libfbdevhw.so
[   102.403] (II) Module fbdevhw: vendor="X.Org Foundation"
[   102.403] 	compiled for 1.14.99.905, module version = 0.0.2
[   102.403] 	ABI class: X.Org Video Driver, version 15.0
[   102.403] (WW) Falling back to old probe method for vesa
[   102.403] (WW) VGA arbiter: cannot open kernel arbiter, no multi-card support
[   102.403] (II) Loading sub module "dri2"
[   102.403] (II) LoadModule: "dri2"
[   102.403] (II) Module "dri2" already built-in
[   102.403] (--) NOUVEAU(0): Chipset: "NVIDIA NVCE"
[   102.403] (II) NOUVEAU(0): Creating default Display subsection in Screen section
	"Default Screen Section" for depth/fbbpp 24/32
[   102.403] (==) NOUVEAU(0): Depth 24, (--) framebuffer bpp 32
[   102.403] (==) NOUVEAU(0): RGB weight 888
[   102.403] (==) NOUVEAU(0): Default visual is TrueColor
[   102.403] (==) NOUVEAU(0): Using HW cursor
[   102.403] (==) NOUVEAU(0): GLX sync to VBlank disabled.
[   102.403] (==) NOUVEAU(0): Page flipping enabled
[   102.403] (==) NOUVEAU(0): Swap limit set to 2 [Max allowed 2]
[   102.428] (II) NOUVEAU(0): Output DVI-I-1 has no monitor section
[   102.484] (II) NOUVEAU(0): Output DVI-I-2 has no monitor section
[   102.486] (II) NOUVEAU(0): Output HDMI-1 has no monitor section
[   102.509] (II) NOUVEAU(0): EDID for output DVI-I-1
[   102.566] (II) NOUVEAU(0): EDID for output DVI-I-2
[   102.566] (II) NOUVEAU(0): Manufacturer: SAM  Model: 795  Serial#: 1110590298
[   102.566] (II) NOUVEAU(0): Year: 2012  Week: 6
[   102.566] (II) NOUVEAU(0): EDID Version: 1.3
[   102.566] (II) NOUVEAU(0): Digital Display Input
[   102.566] (II) NOUVEAU(0): Max Image Size [cm]: horiz.: 52  vert.: 29
[   102.566] (II) NOUVEAU(0): Gamma: 2.20
[   102.566] (II) NOUVEAU(0): DPMS capabilities: Off
[   102.566] (II) NOUVEAU(0): Supported color encodings: RGB 4:4:4 YCrCb 4:4:4 
[   102.566] (II) NOUVEAU(0): First detailed timing is preferred mode
[   102.566] (II) NOUVEAU(0): redX: 0.641 redY: 0.338   greenX: 0.315 greenY: 0.629
[   102.566] (II) NOUVEAU(0): blueX: 0.159 blueY: 0.059   whiteX: 0.312 whiteY: 0.329
[   102.566] (II) NOUVEAU(0): Supported established timings:
[   102.566] (II) NOUVEAU(0): 720x400@70Hz
[   102.566] (II) NOUVEAU(0): 640x480@60Hz
[   102.566] (II) NOUVEAU(0): 640x480@67Hz
[   102.566] (II) NOUVEAU(0): 640x480@72Hz
[   102.566] (II) NOUVEAU(0): 640x480@75Hz
[   102.566] (II) NOUVEAU(0): 800x600@56Hz
[   102.566] (II) NOUVEAU(0): 800x600@60Hz
[   102.566] (II) NOUVEAU(0): 800x600@72Hz
[   102.566] (II) NOUVEAU(0): 800x600@75Hz
[   102.566] (II) NOUVEAU(0): 832x624@75Hz
[   102.566] (II) NOUVEAU(0): 1024x768@60Hz
[   102.566] (II) NOUVEAU(0): 1024x768@70Hz
[   102.566] (II) NOUVEAU(0): 1024x768@75Hz
[   102.566] (II) NOUVEAU(0): 1280x1024@75Hz
[   102.566] (II) NOUVEAU(0): 1152x864@75Hz
[   102.566] (II) NOUVEAU(0): Manufacturer's mask: 0
[   102.566] (II) NOUVEAU(0): Supported standard timings:
[   102.566] (II) NOUVEAU(0): #0: hsize: 1280  vsize 800  refresh: 60  vid: 129
[   102.566] (II) NOUVEAU(0): #1: hsize: 1280  vsize 960  refresh: 60  vid: 16513
[   102.566] (II) NOUVEAU(0): #2: hsize: 1280  vsize 1024  refresh: 60  vid: 32897
[   102.566] (II) NOUVEAU(0): #3: hsize: 1440  vsize 900  refresh: 60  vid: 149
[   102.566] (II) NOUVEAU(0): #4: hsize: 1600  vsize 1200  refresh: 60  vid: 16553
[   102.566] (II) NOUVEAU(0): #5: hsize: 1680  vsize 1050  refresh: 60  vid: 179
[   102.566] (II) NOUVEAU(0): #6: hsize: 1152  vsize 864  refresh: 75  vid: 20337
[   102.566] (II) NOUVEAU(0): #7: hsize: 1440  vsize 900  refresh: 75  vid: 3989
[   102.566] (II) NOUVEAU(0): Supported detailed timing:
[   102.566] (II) NOUVEAU(0): clock: 148.5 MHz   Image Size:  521 x 293 mm
[   102.566] (II) NOUVEAU(0): h_active: 1920  h_sync: 2008  h_sync_end 2052 h_blank_end 2200 h_border: 0
[   102.566] (II) NOUVEAU(0): v_active: 1080  v_sync: 1084  v_sync_end 1089 v_blanking: 1125 v_border: 0
[   102.566] (II) NOUVEAU(0): Ranges: V min: 56 V max: 75 Hz, H min: 30 H max: 81 kHz, PixClock max 175 MHz
[   102.566] (II) NOUVEAU(0): Monitor name: SA300/SA350
[   102.566] (II) NOUVEAU(0): Serial No: H4XC205202
[   102.566] (II) NOUVEAU(0): Supported detailed timing:
[   102.566] (II) NOUVEAU(0): clock: 148.5 MHz   Image Size:  521 x 293 mm
[   102.566] (II) NOUVEAU(0): h_active: 1920  h_sync: 2448  h_sync_end 2492 h_blank_end 2640 h_border: 0
[   102.566] (II) NOUVEAU(0): v_active: 1080  v_sync: 1084  v_sync_end 1089 v_blanking: 1125 v_border: 0
[   102.566] (II) NOUVEAU(0): Supported detailed timing:
[   102.566] (II) NOUVEAU(0): clock: 74.2 MHz   Image Size:  521 x 293 mm
[   102.566] (II) NOUVEAU(0): h_active: 1280  h_sync: 1390  h_sync_end 1430 h_blank_end 1650 h_border: 0
[   102.566] (II) NOUVEAU(0): v_active: 720  v_sync: 725  v_sync_end 730 v_blanking: 750 v_border: 0
[   102.566] (II) NOUVEAU(0): Supported detailed timing:
[   102.566] (II) NOUVEAU(0): clock: 74.2 MHz   Image Size:  521 x 293 mm
[   102.566] (II) NOUVEAU(0): h_active: 1280  h_sync: 1720  h_sync_end 1760 h_blank_end 1980 h_border: 0
[   102.566] (II) NOUVEAU(0): v_active: 720  v_sync: 725  v_sync_end 730 v_blanking: 750 v_border: 0
[   102.566] (II) NOUVEAU(0): Supported detailed timing:
[   102.566] (II) NOUVEAU(0): clock: 27.0 MHz   Image Size:  521 x 293 mm
[   102.566] (II) NOUVEAU(0): h_active: 720  h_sync: 732  h_sync_end 796 h_blank_end 864 h_border: 0
[   102.566] (II) NOUVEAU(0): v_active: 576  v_sync: 581  v_sync_end 586 v_blanking: 625 v_border: 0
[   102.566] (II) NOUVEAU(0): Supported detailed timing:
[   102.566] (II) NOUVEAU(0): clock: 27.0 MHz   Image Size:  521 x 293 mm
[   102.566] (II) NOUVEAU(0): h_active: 720  h_sync: 736  h_sync_end 798 h_blank_end 858 h_border: 0
[   102.566] (II) NOUVEAU(0): v_active: 480  v_sync: 489  v_sync_end 495 v_blanking: 525 v_border: 0
[   102.566] (II) NOUVEAU(0): Number of EDID sections to follow: 1
[   102.566] (II) NOUVEAU(0): EDID (in hex):
[   102.566] (II) NOUVEAU(0): 	00ffffffffffff004c2d95075a433242
[   102.566] (II) NOUVEAU(0): 	0616010380341d782a2cc1a45650a128
[   102.566] (II) NOUVEAU(0): 	0f5054bfef808100814081809500a940
[   102.566] (II) NOUVEAU(0): 	b300714f950f023a801871382d40582c
[   102.566] (II) NOUVEAU(0): 	450009252100001e000000fd00384b1e
[   102.566] (II) NOUVEAU(0): 	5111000a202020202020000000fc0053
[   102.566] (II) NOUVEAU(0): 	413330302f53413335300a20000000ff
[   102.566] (II) NOUVEAU(0): 	00483458433230353230320a20200176
[   102.566] (II) NOUVEAU(0): 	02010400023a80d072382d40102c4580
[   102.566] (II) NOUVEAU(0): 	09252100001e011d007251d01e206e28
[   102.566] (II) NOUVEAU(0): 	550009252100001e011d00bc52d01e20
[   102.566] (II) NOUVEAU(0): 	b828554009252100001e8c0ad0902040
[   102.566] (II) NOUVEAU(0): 	31200c4055000925210000188c0ad08a
[   102.566] (II) NOUVEAU(0): 	20e02d10103e96000925210000180000
[   102.566] (II) NOUVEAU(0): 	00000000000000000000000000000000
[   102.566] (II) NOUVEAU(0): 	0000000000000000000000000000005e
[   102.566] (II) NOUVEAU(0): Printing probed modes for output DVI-I-2
[   102.566] (II) NOUVEAU(0): Modeline "1920x1080"x60.0  148.50  1920 2008 2052 2200  1080 1084 1089 1125 +hsync +vsync (67.5 kHz eP)
[   102.566] (II) NOUVEAU(0): Modeline "1920x1080"x50.0  148.50  1920 2448 2492 2640  1080 1084 1089 1125 +hsync +vsync (56.2 kHz e)
[   102.566] (II) NOUVEAU(0): Modeline "1920x1080"x59.9  148.35  1920 2008 2052 2200  1080 1084 1089 1125 +hsync +vsync (67.4 kHz e)
[   102.566] (II) NOUVEAU(0): Modeline "1600x1200"x60.0  162.00  1600 1664 1856 2160  1200 1201 1204 1250 +hsync +vsync (75.0 kHz e)
[   102.566] (II) NOUVEAU(0): Modeline "1680x1050"x59.9  119.00  1680 1728 1760 1840  1050 1053 1059 1080 +hsync -vsync (64.7 kHz e)
[   102.566] (II) NOUVEAU(0): Modeline "1280x1024"x75.0  135.00  1280 1296 1440 1688  1024 1025 1028 1066 +hsync +vsync (80.0 kHz e)
[   102.566] (II) NOUVEAU(0): Modeline "1280x1024"x60.0  108.00  1280 1328 1440 1688  1024 1025 1028 1066 +hsync +vsync (64.0 kHz e)
[   102.567] (II) NOUVEAU(0): Modeline "1440x900"x75.0  136.75  1440 1536 1688 1936  900 903 909 942 -hsync +vsync (70.6 kHz e)
[   102.567] (II) NOUVEAU(0): Modeline "1440x900"x59.9   88.75  1440 1488 1520 1600  900 903 909 926 +hsync -vsync (55.5 kHz e)
[   102.567] (II) NOUVEAU(0): Modeline "1280x960"x60.0  108.00  1280 1376 1488 1800  960 961 964 1000 +hsync +vsync (60.0 kHz e)
[   102.567] (II) NOUVEAU(0): Modeline "1280x800"x59.9   71.00  1280 1328 1360 1440  800 803 809 823 +hsync -vsync (49.3 kHz e)
[   102.567] (II) NOUVEAU(0): Modeline "1152x864"x75.0  108.00  1152 1216 1344 1600  864 865 868 900 +hsync +vsync (67.5 kHz e)
[   102.567] (II) NOUVEAU(0): Modeline "1280x720"x60.0   74.25  1280 1390 1430 1650  720 725 730 750 +hsync +vsync (45.0 kHz e)
[   102.567] (II) NOUVEAU(0): Modeline "1280x720"x50.0   74.25  1280 1720 1760 1980  720 725 730 750 +hsync +vsync (37.5 kHz e)
[   102.567] (II) NOUVEAU(0): Modeline "1280x720"x59.9   74.18  1280 1390 1430 1650  720 725 730 750 +hsync +vsync (45.0 kHz e)
[   102.567] (II) NOUVEAU(0): Modeline "1024x768"x75.1   78.80  1024 1040 1136 1312  768 769 772 800 +hsync +vsync (60.1 kHz e)
[   102.567] (II) NOUVEAU(0): Modeline "1024x768"x70.1   75.00  1024 1048 1184 1328  768 771 777 806 -hsync -vsync (56.5 kHz e)
[   102.567] (II) NOUVEAU(0): Modeline "1024x768"x60.0   65.00  1024 1048 1184 1344  768 771 777 806 -hsync -vsync (48.4 kHz e)
[   102.567] (II) NOUVEAU(0): Modeline "832x624"x74.6   57.28  832 864 928 1152  624 625 628 667 -hsync -vsync (49.7 kHz e)
[   102.567] (II) NOUVEAU(0): Modeline "800x600"x72.2   50.00  800 856 976 1040  600 637 643 666 +hsync +vsync (48.1 kHz e)
[   102.567] (II) NOUVEAU(0): Modeline "800x600"x75.0   49.50  800 816 896 1056  600 601 604 625 +hsync +vsync (46.9 kHz e)
[   102.567] (II) NOUVEAU(0): Modeline "800x600"x60.3   40.00  800 840 968 1056  600 601 605 628 +hsync +vsync (37.9 kHz e)
[   102.567] (II) NOUVEAU(0): Modeline "800x600"x56.2   36.00  800 824 896 1024  600 601 603 625 +hsync +vsync (35.2 kHz e)
[   102.567] (II) NOUVEAU(0): Modeline "720x576"x50.0   27.00  720 732 796 864  576 581 586 625 -hsync -vsync (31.2 kHz e)
[   102.567] (II) NOUVEAU(0): Modeline "720x480"x60.0   27.03  720 736 798 858  480 489 495 525 -hsync -vsync (31.5 kHz e)
[   102.567] (II) NOUVEAU(0): Modeline "720x480"x59.9   27.00  720 736 798 858  480 489 495 525 -hsync -vsync (31.5 kHz e)
[   102.567] (II) NOUVEAU(0): Modeline "640x480"x75.0   31.50  640 656 720 840  480 481 484 500 -hsync -vsync (37.5 kHz e)
[   102.567] (II) NOUVEAU(0): Modeline "640x480"x72.8   31.50  640 664 704 832  480 489 491 520 -hsync -vsync (37.9 kHz e)
[   102.567] (II) NOUVEAU(0): Modeline "640x480"x66.7   30.24  640 704 768 864  480 483 486 525 -hsync -vsync (35.0 kHz e)
[   102.567] (II) NOUVEAU(0): Modeline "640x480"x60.0   25.20  640 656 752 800  480 490 492 525 -hsync -vsync (31.5 kHz e)
[   102.567] (II) NOUVEAU(0): Modeline "640x480"x59.9   25.18  640 656 752 800  480 490 492 525 -hsync -vsync (31.5 kHz e)
[   102.567] (II) NOUVEAU(0): Modeline "720x400"x70.1   28.32  720 738 846 900  400 412 414 449 -hsync +vsync (31.5 kHz e)
[   102.569] (II) NOUVEAU(0): EDID for output HDMI-1
[   102.569] (II) NOUVEAU(0): Output DVI-I-1 disconnected
[   102.569] (II) NOUVEAU(0): Output DVI-I-2 connected
[   102.569] (II) NOUVEAU(0): Output HDMI-1 disconnected
[   102.569] (II) NOUVEAU(0): Using exact sizes for initial modes
[   102.569] (II) NOUVEAU(0): Output DVI-I-2 using initial mode 1920x1080
[   102.569] (II) NOUVEAU(0): Using default gamma of (1.0, 1.0, 1.0) unless otherwise stated.
[   102.569] (--) NOUVEAU(0): Virtual size is 1920x1080 (pitch 0)
[   102.569] (**) NOUVEAU(0):  Driver mode "1920x1080": 148.5 MHz (scaled from 0.0 MHz), 67.5 kHz, 60.0 Hz
[   102.569] (II) NOUVEAU(0): Modeline "1920x1080"x60.0  148.50  1920 2008 2052 2200  1080 1084 1089 1125 +hsync +vsync (67.5 kHz eP)
[   102.569] (**) NOUVEAU(0):  Driver mode "1920x1080": 148.5 MHz (scaled from 0.0 MHz), 56.2 kHz, 50.0 Hz
[   102.569] (II) NOUVEAU(0): Modeline "1920x1080"x50.0  148.50  1920 2448 2492 2640  1080 1084 1089 1125 +hsync +vsync (56.2 kHz e)
[   102.569] (**) NOUVEAU(0):  Driver mode "1920x1080": 148.4 MHz (scaled from 0.0 MHz), 67.4 kHz, 59.9 Hz
[   102.569] (II) NOUVEAU(0): Modeline "1920x1080"x59.9  148.35  1920 2008 2052 2200  1080 1084 1089 1125 +hsync +vsync (67.4 kHz e)
[   102.569] (**) NOUVEAU(0):  Driver mode "1600x1200": 162.0 MHz (scaled from 0.0 MHz), 75.0 kHz, 60.0 Hz
[   102.569] (II) NOUVEAU(0): Modeline "1600x1200"x60.0  162.00  1600 1664 1856 2160  1200 1201 1204 1250 +hsync +vsync (75.0 kHz e)
[   102.569] (**) NOUVEAU(0):  Driver mode "1680x1050": 119.0 MHz (scaled from 0.0 MHz), 64.7 kHz, 59.9 Hz
[   102.569] (II) NOUVEAU(0): Modeline "1680x1050"x59.9  119.00  1680 1728 1760 1840  1050 1053 1059 1080 +hsync -vsync (64.7 kHz e)
[   102.569] (**) NOUVEAU(0):  Driver mode "1280x1024": 135.0 MHz (scaled from 0.0 MHz), 80.0 kHz, 75.0 Hz
[   102.569] (II) NOUVEAU(0): Modeline "1280x1024"x75.0  135.00  1280 1296 1440 1688  1024 1025 1028 1066 +hsync +vsync (80.0 kHz e)
[   102.569] (**) NOUVEAU(0):  Driver mode "1280x1024": 108.0 MHz (scaled from 0.0 MHz), 64.0 kHz, 60.0 Hz
[   102.569] (II) NOUVEAU(0): Modeline "1280x1024"x60.0  108.00  1280 1328 1440 1688  1024 1025 1028 1066 +hsync +vsync (64.0 kHz e)
[   102.569] (**) NOUVEAU(0):  Driver mode "1440x900": 136.8 MHz (scaled from 0.0 MHz), 70.6 kHz, 75.0 Hz
[   102.569] (II) NOUVEAU(0): Modeline "1440x900"x75.0  136.75  1440 1536 1688 1936  900 903 909 942 -hsync +vsync (70.6 kHz e)
[   102.569] (**) NOUVEAU(0):  Driver mode "1440x900": 88.8 MHz (scaled from 0.0 MHz), 55.5 kHz, 59.9 Hz
[   102.569] (II) NOUVEAU(0): Modeline "1440x900"x59.9   88.75  1440 1488 1520 1600  900 903 909 926 +hsync -vsync (55.5 kHz e)
[   102.569] (**) NOUVEAU(0):  Driver mode "1280x960": 108.0 MHz (scaled from 0.0 MHz), 60.0 kHz, 60.0 Hz
[   102.569] (II) NOUVEAU(0): Modeline "1280x960"x60.0  108.00  1280 1376 1488 1800  960 961 964 1000 +hsync +vsync (60.0 kHz e)
[   102.569] (**) NOUVEAU(0):  Driver mode "1280x800": 71.0 MHz (scaled from 0.0 MHz), 49.3 kHz, 59.9 Hz
[   102.569] (II) NOUVEAU(0): Modeline "1280x800"x59.9   71.00  1280 1328 1360 1440  800 803 809 823 +hsync -vsync (49.3 kHz e)
[   102.569] (**) NOUVEAU(0):  Driver mode "1152x864": 108.0 MHz (scaled from 0.0 MHz), 67.5 kHz, 75.0 Hz
[   102.569] (II) NOUVEAU(0): Modeline "1152x864"x75.0  108.00  1152 1216 1344 1600  864 865 868 900 +hsync +vsync (67.5 kHz e)
[   102.569] (**) NOUVEAU(0):  Driver mode "1280x720": 74.2 MHz (scaled from 0.0 MHz), 45.0 kHz, 60.0 Hz
[   102.569] (II) NOUVEAU(0): Modeline "1280x720"x60.0   74.25  1280 1390 1430 1650  720 725 730 750 +hsync +vsync (45.0 kHz e)
[   102.569] (**) NOUVEAU(0):  Driver mode "1280x720": 74.2 MHz (scaled from 0.0 MHz), 37.5 kHz, 50.0 Hz
[   102.569] (II) NOUVEAU(0): Modeline "1280x720"x50.0   74.25  1280 1720 1760 1980  720 725 730 750 +hsync +vsync (37.5 kHz e)
[   102.569] (**) NOUVEAU(0):  Driver mode "1280x720": 74.2 MHz (scaled from 0.0 MHz), 45.0 kHz, 59.9 Hz
[   102.569] (II) NOUVEAU(0): Modeline "1280x720"x59.9   74.18  1280 1390 1430 1650  720 725 730 750 +hsync +vsync (45.0 kHz e)
[   102.569] (**) NOUVEAU(0):  Driver mode "1024x768": 78.8 MHz (scaled from 0.0 MHz), 60.1 kHz, 75.1 Hz
[   102.569] (II) NOUVEAU(0): Modeline "1024x768"x75.1   78.80  1024 1040 1136 1312  768 769 772 800 +hsync +vsync (60.1 kHz e)
[   102.569] (**) NOUVEAU(0):  Driver mode "1024x768": 75.0 MHz (scaled from 0.0 MHz), 56.5 kHz, 70.1 Hz
[   102.569] (II) NOUVEAU(0): Modeline "1024x768"x70.1   75.00  1024 1048 1184 1328  768 771 777 806 -hsync -vsync (56.5 kHz e)
[   102.569] (**) NOUVEAU(0):  Driver mode "1024x768": 65.0 MHz (scaled from 0.0 MHz), 48.4 kHz, 60.0 Hz
[   102.569] (II) NOUVEAU(0): Modeline "1024x768"x60.0   65.00  1024 1048 1184 1344  768 771 777 806 -hsync -vsync (48.4 kHz e)
[   102.569] (**) NOUVEAU(0):  Driver mode "832x624": 57.3 MHz (scaled from 0.0 MHz), 49.7 kHz, 74.6 Hz
[   102.569] (II) NOUVEAU(0): Modeline "832x624"x74.6   57.28  832 864 928 1152  624 625 628 667 -hsync -vsync (49.7 kHz e)
[   102.569] (**) NOUVEAU(0):  Driver mode "800x600": 50.0 MHz (scaled from 0.0 MHz), 48.1 kHz, 72.2 Hz
[   102.569] (II) NOUVEAU(0): Modeline "800x600"x72.2   50.00  800 856 976 1040  600 637 643 666 +hsync +vsync (48.1 kHz e)
[   102.569] (**) NOUVEAU(0):  Driver mode "800x600": 49.5 MHz (scaled from 0.0 MHz), 46.9 kHz, 75.0 Hz
[   102.569] (II) NOUVEAU(0): Modeline "800x600"x75.0   49.50  800 816 896 1056  600 601 604 625 +hsync +vsync (46.9 kHz e)
[   102.569] (**) NOUVEAU(0):  Driver mode "800x600": 40.0 MHz (scaled from 0.0 MHz), 37.9 kHz, 60.3 Hz
[   102.569] (II) NOUVEAU(0): Modeline "800x600"x60.3   40.00  800 840 968 1056  600 601 605 628 +hsync +vsync (37.9 kHz e)
[   102.569] (**) NOUVEAU(0):  Driver mode "800x600": 36.0 MHz (scaled from 0.0 MHz), 35.2 kHz, 56.2 Hz
[   102.569] (II) NOUVEAU(0): Modeline "800x600"x56.2   36.00  800 824 896 1024  600 601 603 625 +hsync +vsync (35.2 kHz e)
[   102.569] (**) NOUVEAU(0):  Driver mode "720x576": 27.0 MHz (scaled from 0.0 MHz), 31.2 kHz, 50.0 Hz
[   102.569] (II) NOUVEAU(0): Modeline "720x576"x50.0   27.00  720 732 796 864  576 581 586 625 -hsync -vsync (31.2 kHz e)
[   102.569] (**) NOUVEAU(0):  Driver mode "720x480": 27.0 MHz (scaled from 0.0 MHz), 31.5 kHz, 60.0 Hz
[   102.569] (II) NOUVEAU(0): Modeline "720x480"x60.0   27.03  720 736 798 858  480 489 495 525 -hsync -vsync (31.5 kHz e)
[   102.569] (**) NOUVEAU(0):  Driver mode "720x480": 27.0 MHz (scaled from 0.0 MHz), 31.5 kHz, 59.9 Hz
[   102.569] (II) NOUVEAU(0): Modeline "720x480"x59.9   27.00  720 736 798 858  480 489 495 525 -hsync -vsync (31.5 kHz e)
[   102.569] (**) NOUVEAU(0):  Driver mode "640x480": 31.5 MHz (scaled from 0.0 MHz), 37.5 kHz, 75.0 Hz
[   102.569] (II) NOUVEAU(0): Modeline "640x480"x75.0   31.50  640 656 720 840  480 481 484 500 -hsync -vsync (37.5 kHz e)
[   102.569] (**) NOUVEAU(0):  Driver mode "640x480": 31.5 MHz (scaled from 0.0 MHz), 37.9 kHz, 72.8 Hz
[   102.569] (II) NOUVEAU(0): Modeline "640x480"x72.8   31.50  640 664 704 832  480 489 491 520 -hsync -vsync (37.9 kHz e)
[   102.569] (**) NOUVEAU(0):  Driver mode "640x480": 30.2 MHz (scaled from 0.0 MHz), 35.0 kHz, 66.7 Hz
[   102.569] (II) NOUVEAU(0): Modeline "640x480"x66.7   30.24  640 704 768 864  480 483 486 525 -hsync -vsync (35.0 kHz e)
[   102.569] (**) NOUVEAU(0):  Driver mode "640x480": 25.2 MHz (scaled from 0.0 MHz), 31.5 kHz, 60.0 Hz
[   102.569] (II) NOUVEAU(0): Modeline "640x480"x60.0   25.20  640 656 752 800  480 490 492 525 -hsync -vsync (31.5 kHz e)
[   102.569] (**) NOUVEAU(0):  Driver mode "640x480": 25.2 MHz (scaled from 0.0 MHz), 31.5 kHz, 59.9 Hz
[   102.569] (II) NOUVEAU(0): Modeline "640x480"x59.9   25.18  640 656 752 800  480 490 492 525 -hsync -vsync (31.5 kHz e)
[   102.569] (**) NOUVEAU(0):  Driver mode "720x400": 28.3 MHz (scaled from 0.0 MHz), 31.5 kHz, 70.1 Hz
[   102.569] (II) NOUVEAU(0): Modeline "720x400"x70.1   28.32  720 738 846 900  400 412 414 449 -hsync +vsync (31.5 kHz e)
[   102.569] (==) NOUVEAU(0): DPI set to (96, 96)
[   102.569] (II) Loading sub module "fb"
[   102.569] (II) LoadModule: "fb"
[   102.570] (II) Loading /usr/lib64/xorg/modules/libfb.so
[   102.570] (II) Module fb: vendor="X.Org Foundation"
[   102.570] 	compiled for 1.14.99.905, module version = 1.0.0
[   102.570] 	ABI class: X.Org ANSI C Emulation, version 0.4
[   102.570] (II) Loading sub module "exa"
[   102.570] (II) LoadModule: "exa"
[   102.570] (II) Loading /usr/lib64/xorg/modules/libexa.so
[   102.570] (II) Module exa: vendor="X.Org Foundation"
[   102.570] 	compiled for 1.14.99.905, module version = 2.6.0
[   102.570] 	ABI class: X.Org Video Driver, version 15.0
[   102.570] (II) Loading sub module "shadowfb"
[   102.570] (II) LoadModule: "shadowfb"
[   102.570] (II) Loading /usr/lib64/xorg/modules/libshadowfb.so
[   102.570] (II) Module shadowfb: vendor="X.Org Foundation"
[   102.570] 	compiled for 1.14.99.905, module version = 1.0.0
[   102.570] 	ABI class: X.Org ANSI C Emulation, version 0.4
[   102.570] (II) UnloadModule: "modesetting"
[   102.570] (II) Unloading modesetting
[   102.570] (II) UnloadModule: "fbdev"
[   102.570] (II) Unloading fbdev
[   102.570] (II) UnloadSubModule: "fbdevhw"
[   102.570] (II) Unloading fbdevhw
[   102.570] (II) UnloadModule: "vesa"
[   102.570] (II) Unloading vesa
[   102.570] (--) Depth 24 pixmap format is 32 bpp
[   104.571] (II) NOUVEAU(0): Opened GPU channel 0
[   104.574] (II) NOUVEAU(0): [DRI2] Setup complete
[   104.574] (II) NOUVEAU(0): [DRI2]   DRI driver: nouveau
[   104.574] (II) NOUVEAU(0): [DRI2]   VDPAU driver: nouveau
[   104.574] (II) EXA(0): Driver allocated offscreen pixmaps
[   104.574] (II) EXA(0): Driver registered support for the following operations:
[   104.574] (II)         Solid
[   104.574] (II)         Copy
[   104.574] (II)         Composite (RENDER acceleration)
[   104.574] (II)         UploadToScreen
[   104.574] (II)         DownloadFromScreen
[   104.574] (==) NOUVEAU(0): Backing store enabled
[   104.574] (==) NOUVEAU(0): Silken mouse enabled
[   104.574] (II) NOUVEAU(0): [XvMC] Associated with Nouveau GeForce 8/9 Textured Video.
[   104.574] (II) NOUVEAU(0): [XvMC] Extension initialized.
[   104.574] (==) NOUVEAU(0): DPMS enabled
[   104.574] (II) NOUVEAU(0): RandR 1.2 enabled, ignore the following RandR disabled message.
[   104.575] (--) RandR disabled
[   106.594] (II) AIGLX: enabled GLX_MESA_copy_sub_buffer
[   106.594] (II) AIGLX: enabled GLX_ARB_create_context
[   106.594] (II) AIGLX: enabled GLX_ARB_create_context_profile
[   106.594] (II) AIGLX: enabled GLX_EXT_create_context_es2_profile
[   106.594] (II) AIGLX: enabled GLX_INTEL_swap_event
[   106.594] (II) AIGLX: enabled GLX_SGI_swap_control and GLX_MESA_swap_control
[   106.594] (II) AIGLX: enabled GLX_EXT_framebuffer_sRGB
[   106.594] (II) AIGLX: enabled GLX_ARB_fbconfig_float
[   106.594] (II) AIGLX: GLX_EXT_texture_from_pixmap backed by buffer objects
[   106.595] (II) AIGLX: Loaded and initialized nouveau
[   106.595] (II) GLX: Initialized DRI2 GL provider for screen 0
[   121.595] (II) NOUVEAU(0): NVEnterVT is called.
[   125.595] (II) NOUVEAU(0): Setting screen physical size to 508 x 285
[   125.595] resize called 1920 1080
[   125.639] (II) config/udev: Adding input device Power Button (/dev/input/event3)
[   125.639] (**) Power Button: Applying InputClass "evdev keyboard catchall"
[   125.639] (**) Power Button: Applying InputClass "evdev keyboard catchall"
[   125.639] (**) Power Button: Applying InputClass "LocalKeyboard"
[   125.639] (II) LoadModule: "evdev"
[   125.639] (II) Loading /usr/lib64/xorg/modules/input/evdev_drv.so
[   125.639] (II) Module evdev: vendor="X.Org Foundation"
[   125.639] 	compiled for 1.14.99.905, module version = 2.8.2
[   125.639] 	Module class: X.Org XInput Driver
[   125.639] 	ABI class: X.Org XInput driver, version 20.0
[   125.639] (II) Using input driver 'evdev' for 'Power Button'
[   125.639] (**) Power Button: always reports core events
[   125.639] (**) evdev: Power Button: Device: "/dev/input/event3"
[   125.639] (--) evdev: Power Button: Vendor 0 Product 0x1
[   125.639] (--) evdev: Power Button: Found keys
[   125.639] (II) evdev: Power Button: Configuring as keyboard
[   125.639] (**) Option "config_info" "udev:/sys/devices/LNXSYSTM:00/LNXPWRBN:00/input/input3/event3"
[   125.639] (II) XINPUT: Adding extended input device "Power Button" (type: KEYBOARD, id 6)
[   125.639] (**) Option "xkb_rules" "evdev"
[   125.639] (**) Option "xkb_model" "pc104"
[   125.639] (**) Option "xkb_layout" "gb"
[   125.656] (II) config/udev: Adding input device Power Button (/dev/input/event2)
[   125.656] (**) Power Button: Applying InputClass "evdev keyboard catchall"
[   125.656] (**) Power Button: Applying InputClass "evdev keyboard catchall"
[   125.656] (**) Power Button: Applying InputClass "LocalKeyboard"
[   125.656] (II) Using input driver 'evdev' for 'Power Button'
[   125.656] (**) Power Button: always reports core events
[   125.656] (**) evdev: Power Button: Device: "/dev/input/event2"
[   125.656] (--) evdev: Power Button: Vendor 0 Product 0x1
[   125.656] (--) evdev: Power Button: Found keys
[   125.656] (II) evdev: Power Button: Configuring as keyboard
[   125.656] (**) Option "config_info" "udev:/sys/devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input2/event2"
[   125.656] (II) XINPUT: Adding extended input device "Power Button" (type: KEYBOARD, id 7)
[   125.656] (**) Option "xkb_rules" "evdev"
[   125.656] (**) Option "xkb_model" "pc104"
[   125.656] (**) Option "xkb_layout" "gb"
[   125.656] (II) config/udev: Adding drm device (/dev/dri/card0)
[   125.657] (II) config/udev: Adding input device HDA NVidia HDMI (/dev/input/event13)
[   125.657] (II) No input driver specified, ignoring this device.
[   125.657] (II) This device may have been added with another device file.
[   125.657] (II) config/udev: Adding input device CH PRODUCTS CH FLIGHT SIM YOKE USB  (/dev/input/event1)
[   125.657] (II) No input driver specified, ignoring this device.
[   125.657] (II) This device may have been added with another device file.
[   125.657] (II) config/udev: Adding input device CH PRODUCTS CH FLIGHT SIM YOKE USB  (/dev/input/js0)
[   125.657] (II) No input driver specified, ignoring this device.
[   125.657] (II) This device may have been added with another device file.
[   125.657] (II) config/udev: Adding input device HD Pro Webcam C920 (/dev/input/event14)
[   125.657] (**) HD Pro Webcam C920: Applying InputClass "evdev keyboard catchall"
[   125.657] (**) HD Pro Webcam C920: Applying InputClass "evdev keyboard catchall"
[   125.657] (**) HD Pro Webcam C920: Applying InputClass "LocalKeyboard"
[   125.657] (II) Using input driver 'evdev' for 'HD Pro Webcam C920'
[   125.657] (**) HD Pro Webcam C920: always reports core events
[   125.657] (**) evdev: HD Pro Webcam C920: Device: "/dev/input/event14"
[   125.657] (--) evdev: HD Pro Webcam C920: Vendor 0x46d Product 0x82d
[   125.657] (--) evdev: HD Pro Webcam C920: Found keys
[   125.657] (II) evdev: HD Pro Webcam C920: Configuring as keyboard
[   125.657] (**) Option "config_info" "udev:/sys/devices/pci0000:00/0000:00:13.2/usb6/6-5/6-5:1.0/input/input14/event14"
[   125.657] (II) XINPUT: Adding extended input device "HD Pro Webcam C920" (type: KEYBOARD, id 8)
[   125.657] (**) Option "xkb_rules" "evdev"
[   125.657] (**) Option "xkb_model" "pc104"
[   125.657] (**) Option "xkb_layout" "gb"
[   125.658] (II) config/udev: Adding input device HDA ATI SB Line Out CLFE (/dev/input/event7)
[   125.658] (II) No input driver specified, ignoring this device.
[   125.658] (II) This device may have been added with another device file.
[   125.658] (II) config/udev: Adding input device HDA ATI SB Line Out Side (/dev/input/event6)
[   125.658] (II) No input driver specified, ignoring this device.
[   125.658] (II) This device may have been added with another device file.
[   125.658] (II) config/udev: Adding input device HDA ATI SB Front Headphone (/dev/input/event5)
[   125.658] (II) No input driver specified, ignoring this device.
[   125.658] (II) This device may have been added with another device file.
[   125.658] (II) config/udev: Adding input device HDA ATI SB Front Mic (/dev/input/event12)
[   125.658] (II) No input driver specified, ignoring this device.
[   125.658] (II) This device may have been added with another device file.
[   125.658] (II) config/udev: Adding input device HDA ATI SB Rear Mic (/dev/input/event11)
[   125.658] (II) No input driver specified, ignoring this device.
[   125.658] (II) This device may have been added with another device file.
[   125.658] (II) config/udev: Adding input device HDA ATI SB Line (/dev/input/event10)
[   125.658] (II) No input driver specified, ignoring this device.
[   125.658] (II) This device may have been added with another device file.
[   125.658] (II) config/udev: Adding input device HDA ATI SB Line Out Front (/dev/input/event9)
[   125.658] (II) No input driver specified, ignoring this device.
[   125.658] (II) This device may have been added with another device file.
[   125.659] (II) config/udev: Adding input device HDA ATI SB Line Out Surround (/dev/input/event8)
[   125.659] (II) No input driver specified, ignoring this device.
[   125.659] (II) This device may have been added with another device file.
[   125.659] (II) config/udev: Adding input device Logitech Trackball (/dev/input/event4)
[   125.659] (**) Logitech Trackball: Applying InputClass "evdev pointer catchall"
[   125.659] (**) Logitech Trackball: Applying InputClass "evdev pointer catchall"
[   125.659] (II) Using input driver 'evdev' for 'Logitech Trackball'
[   125.659] (**) Logitech Trackball: always reports core events
[   125.659] (**) evdev: Logitech Trackball: Device: "/dev/input/event4"
[   125.659] (--) evdev: Logitech Trackball: Vendor 0x46d Product 0xc404
[   125.659] (--) evdev: Logitech Trackball: Found 9 mouse buttons
[   125.659] (--) evdev: Logitech Trackball: Found scroll wheel(s)
[   125.659] (--) evdev: Logitech Trackball: Found relative axes
[   125.659] (--) evdev: Logitech Trackball: Found x and y relative axes
[   125.659] (II) evdev: Logitech Trackball: Configuring as mouse
[   125.659] (II) evdev: Logitech Trackball: Adding scrollwheel support
[   125.659] (**) evdev: Logitech Trackball: YAxisMapping: buttons 4 and 5
[   125.659] (**) evdev: Logitech Trackball: EmulateWheelButton: 4, EmulateWheelInertia: 10, EmulateWheelTimeout: 200
[   125.659] (**) Option "config_info" "udev:/sys/devices/pci0000:00/0000:00:16.0/usb11/11-1/11-1:1.0/input/input4/event4"
[   125.659] (II) XINPUT: Adding extended input device "Logitech Trackball" (type: MOUSE, id 9)
[   125.659] (II) evdev: Logitech Trackball: initialized for relative axes.
[   125.659] (**) Logitech Trackball: (accel) keeping acceleration scheme 1
[   125.659] (**) Logitech Trackball: (accel) acceleration profile 0
[   125.659] (**) Logitech Trackball: (accel) acceleration factor: 2.000
[   125.659] (**) Logitech Trackball: (accel) acceleration threshold: 4
[   125.659] (II) config/udev: Adding input device Logitech Trackball (/dev/input/mouse0)
[   125.659] (II) No input driver specified, ignoring this device.
[   125.659] (II) This device may have been added with another device file.
[   125.659] (II) config/udev: Adding input device AT Translated Set 2 keyboard (/dev/input/event0)
[   125.659] (**) AT Translated Set 2 keyboard: Applying InputClass "evdev keyboard catchall"
[   125.659] (**) AT Translated Set 2 keyboard: Applying InputClass "evdev keyboard catchall"
[   125.659] (**) AT Translated Set 2 keyboard: Applying InputClass "LocalKeyboard"
[   125.659] (II) Using input driver 'evdev' for 'AT Translated Set 2 keyboard'
[   125.659] (**) AT Translated Set 2 keyboard: always reports core events
[   125.659] (**) evdev: AT Translated Set 2 keyboard: Device: "/dev/input/event0"
[   125.659] (--) evdev: AT Translated Set 2 keyboard: Vendor 0x1 Product 0x1
[   125.659] (--) evdev: AT Translated Set 2 keyboard: Found keys
[   125.659] (II) evdev: AT Translated Set 2 keyboard: Configuring as keyboard
[   125.659] (**) Option "config_info" "udev:/sys/devices/platform/i8042/serio0/input/input0/event0"
[   125.659] (II) XINPUT: Adding extended input device "AT Translated Set 2 keyboard" (type: KEYBOARD, id 10)
[   125.659] (**) Option "xkb_rules" "evdev"
[   125.659] (**) Option "xkb_model" "pc104"
[   125.659] (**) Option "xkb_layout" "gb"

--------------000406030101080009000603--
