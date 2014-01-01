Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756714AbaAABo4 (ORCPT <rfc822;list-kernel77@spinics.net>);
	Tue, 31 Dec 2013 20:44:56 -0500
Received: from know-smtprelay-omc-1.server.virginmedia.net ([80.0.253.65]:60669
	"EHLO know-smtprelay-omc-1.server.virginmedia.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753973AbaAABoy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Dec 2013 20:44:54 -0500
X-Originating-IP: [82.36.39.136]
X-Spam: 0
X-Authority: v=2.1 cv=WI/xXxcR c=1 sm=1 tr=0 a=h3ZJzbuz6X3s3VlFudNWSw==:117
 a=h3ZJzbuz6X3s3VlFudNWSw==:17 a=6vexxxhns_QA:10 a=fZX2ME0dHmMA:10
 a=3NElcqgl2aoA:10 a=k1j_C7plYBUA:10 a=a5Gf7U6LAAAA:8 a=9wwvVaL5uFYA:10
 a=r77TgQKjGQsHNAKrUKIA:9 a=9iDbn-4jx3cA:10 a=cKsnjEOsciEA:10 a=aR16PxjQAAAA:8
 a=9oIARtNkiUse0-itiTsA:9 a=YkHu2DQ51yV5PTjh:21 a=L9hUu2C0isDSC5yq:21
 a=wPNLvfGTeEIA:10 a=CiSHi91Bn78A:10 a=yHIqe9kG5mgA:10 a=e5mUnYsNAAAA:8
 a=TcPrq0qT7PbwCiMduNIA:9 a=LFu_vK8GZXVSIiip:21 a=VQuorffQoWej_ESU:21
 a=zUfKZcXaiyZdBXN_:21 a=57ZKFFc7odEA:10 a=qqlwiqL-QEIA:10 a=m7jhuX_RuCIA:10
 a=h71UUtTGq9UA:10 a=JXQJvpueyLIA:10 a=4MV12Pj9_AoA:10 a=TRaWWqdqQ4oA:10
 a=aWTTYslQkP0A:10
Message-ID: <52C37313.60805@blueyonder.co.uk>
Date: Wed, 01 Jan 2014 01:44:51 +0000
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
 boundary="------------070107000107040402070200"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070107000107040402070200
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
I'll have a look tomorrow - it is a NVCE card..
With everything running at the moment
# echo mmiotrace > /sys/kernel/debug/tracing/current_tracer
bash: echo: write error: Invalid argument

I shall build a new kernel (3.13.0-rc51) with the change
         case 0xce:
                 device->cname = "GF114";
                 device->oclass[NVDEV_SUBDEV_VBIOS  ] = 
&nouveau_bios_oclass;
                 device->oclass[NVDEV_SUBDEV_GPIO   ] = &nv50_gpio_oclass;
                 device->oclass[NVDEV_SUBDEV_I2C    ] = &nv94_i2c_oclass;
                 device->oclass[NVDEV_SUBDEV_CLOCK  ] = &nvc0_clock_oclass;
                 device->oclass[NVDEV_SUBDEV_THERM  ] = &nva3_therm_oclass;
                 device->oclass[NVDEV_SUBDEV_MXM    ] = &nv50_mxm_oclass;
                 device->oclass[NVDEV_SUBDEV_DEVINIT] = 
&nvc0_devinit_oclass;
                 device->oclass[NVDEV_SUBDEV_MC     ] = nvc3_mc_oclass;

Regards
Sid.

-- 
Sid Boyce ... Hamradio License G3VBV, Licensed Private Pilot
Emeritus IBM/Amdahl Mainframes and Sun/Fujitsu Servers Tech Support
Senior Staff Specialist, Cricket Coach
Microsoft Windows Free Zone - Linux used for all Computing Tasks


--------------070107000107040402070200
Content-Type: text/x-log;
 name="Xorg.0.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="Xorg.0.log"

[    97.740] 
This is a pre-release version of the X server from The X.Org Foundation.
It is not supported in any way.
Bugs may be filed in the bugzilla at http://bugs.freedesktop.org/.
Select the "xorg" product for bugs you find in this release.
Before reporting bugs in pre-release versions please check the
latest version in the X.Org Foundation git repository.
See http://wiki.x.org/wiki/GitPage for git access instructions.
[    97.740] 
X.Org X Server 1.14.99.905 (1.15.0 RC 5)
Release Date: 2013-12-19
[    97.740] X Protocol Version 11, Revision 0
[    97.740] Build Operating System: openSUSE SUSE LINUX
[    97.740] Current Operating System: Linux slipstream 3.13.0-rc6-smp+ #1 SMP PREEMPT Mon Dec 30 15:47:46 GMT 2013 x86_64
[    97.740] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-3.13.0-rc6-smp+ root=UUID=9e02a4c0-c401-4874-a706-30ec3f0a98aa nouveau.config=NvMSI=0 quiet splash
[    97.740] Build Date: 22 December 2013  07:18:32PM
[    97.740]  
[    97.740] Current version of pixman: 0.32.4
[    97.740] 	Before reporting problems, check http://wiki.x.org
	to make sure that you have the latest version.
[    97.740] Markers: (--) probed, (**) from config file, (==) default setting,
	(++) from command line, (!!) notice, (II) informational,
	(WW) warning, (EE) error, (NI) not implemented, (??) unknown.
[    97.740] (==) Log file: "/var/log/Xorg.0.log", Time: Wed Jan  1 00:26:25 2014
[    97.741] (==) Using config directory: "/etc/X11/xorg.conf.d"
[    97.741] (==) Using system config directory "/usr/share/X11/xorg.conf.d"
[    97.741] (==) No Layout section.  Using the first Screen section.
[    97.741] (==) No screen section available. Using defaults.
[    97.741] (**) |-->Screen "Default Screen Section" (0)
[    97.741] (**) |   |-->Monitor "<default monitor>"
[    97.741] (==) No monitor specified for screen "Default Screen Section".
	Using a default monitor configuration.
[    97.741] (==) Automatically adding devices
[    97.741] (==) Automatically enabling devices
[    97.741] (==) Automatically adding GPU devices
[    97.741] (WW) The directory "/usr/share/fonts/misc/sgi" does not exist.
[    97.741] 	Entry deleted from font path.
[    97.741] (==) FontPath set to:
	/usr/share/fonts/misc:unscaled,
	/usr/share/fonts/Type1/,
	/usr/share/fonts/100dpi:unscaled,
	/usr/share/fonts/75dpi:unscaled,
	/usr/share/fonts/ghostscript/,
	/usr/share/fonts/cyrillic:unscaled,
	/usr/share/fonts/truetype/,
	built-ins
[    97.741] (==) ModulePath set to "/usr/lib64/xorg/modules/updates,/usr/lib64/xorg/modules"
[    97.741] (II) The server relies on udev to provide the list of input devices.
	If no devices become available, reconfigure udev or disable AutoAddDevices.
[    97.741] (II) Loader magic: 0x80ac60
[    97.741] (II) Module ABI versions:
[    97.741] 	X.Org ANSI C Emulation: 0.4
[    97.741] 	X.Org Video Driver: 15.0
[    97.741] 	X.Org XInput driver : 20.0
[    97.741] 	X.Org Server Extension : 8.0
[    97.741] (II) xfree86: Adding drm device (/dev/dri/card0)
[    97.743] (--) PCI:*(0:1:0:0) 10de:1200:1043:838b rev 161, Mem @ 0xf8000000/33554432, 0xd0000000/134217728, 0xdc000000/67108864, I/O @ 0x0000cf00/128, BIOS @ 0x????????/524288
[    97.743] Initializing built-in extension Generic Event Extension
[    97.743] Initializing built-in extension SHAPE
[    97.743] Initializing built-in extension MIT-SHM
[    97.743] Initializing built-in extension XInputExtension
[    97.743] Initializing built-in extension XTEST
[    97.743] Initializing built-in extension BIG-REQUESTS
[    97.743] Initializing built-in extension SYNC
[    97.743] Initializing built-in extension XKEYBOARD
[    97.743] Initializing built-in extension XC-MISC
[    97.743] Initializing built-in extension SECURITY
[    97.743] Initializing built-in extension XINERAMA
[    97.743] Initializing built-in extension XFIXES
[    97.743] Initializing built-in extension RENDER
[    97.743] Initializing built-in extension RANDR
[    97.743] Initializing built-in extension COMPOSITE
[    97.743] Initializing built-in extension DAMAGE
[    97.743] Initializing built-in extension MIT-SCREEN-SAVER
[    97.743] Initializing built-in extension DOUBLE-BUFFER
[    97.743] Initializing built-in extension RECORD
[    97.743] Initializing built-in extension DPMS
[    97.743] Initializing built-in extension Present
[    97.743] Initializing built-in extension DRI3
[    97.743] Initializing built-in extension X-Resource
[    97.743] Initializing built-in extension XVideo
[    97.743] Initializing built-in extension XVideo-MotionCompensation
[    97.743] Initializing built-in extension XFree86-VidModeExtension
[    97.743] Initializing built-in extension XFree86-DGA
[    97.743] Initializing built-in extension XFree86-DRI
[    97.743] Initializing built-in extension DRI2
[    97.743] (II) LoadModule: "glx"
[    97.783] (II) Loading /usr/lib64/xorg/modules/extensions/libglx.so
[    97.784] (II) Module glx: vendor="X.Org Foundation"
[    97.784] 	compiled for 1.14.99.905, module version = 1.0.0
[    97.784] 	ABI class: X.Org Server Extension, version 8.0
[    97.784] (==) AIGLX enabled
[    97.784] Loading extension GLX
[    97.784] (==) Matched nvidia as autoconfigured driver 0
[    97.784] (==) Matched nouveau as autoconfigured driver 1
[    97.784] (==) Matched nv as autoconfigured driver 2
[    97.784] (==) Matched nvidia as autoconfigured driver 3
[    97.784] (==) Matched nouveau as autoconfigured driver 4
[    97.784] (==) Matched nv as autoconfigured driver 5
[    97.784] (==) Matched modesetting as autoconfigured driver 6
[    97.784] (==) Matched fbdev as autoconfigured driver 7
[    97.784] (==) Matched vesa as autoconfigured driver 8
[    97.784] (==) Assigned the driver to the xf86ConfigLayout
[    97.784] (II) LoadModule: "nvidia"
[    97.818] (WW) Warning, couldn't open module nvidia
[    97.818] (II) UnloadModule: "nvidia"
[    97.818] (II) Unloading nvidia
[    97.818] (EE) Failed to load module "nvidia" (module does not exist, 0)
[    97.818] (II) LoadModule: "nouveau"
[    97.819] (II) Loading /usr/lib64/xorg/modules/drivers/nouveau_drv.so
[    97.819] (II) Module nouveau: vendor="X.Org Foundation"
[    97.819] 	compiled for 1.14.99.904, module version = 1.0.10
[    97.819] 	Module class: X.Org Video Driver
[    97.819] 	ABI class: X.Org Video Driver, version 15.0
[    97.819] (II) LoadModule: "nv"
[    97.819] (WW) Warning, couldn't open module nv
[    97.819] (II) UnloadModule: "nv"
[    97.819] (II) Unloading nv
[    97.819] (EE) Failed to load module "nv" (module does not exist, 0)
[    97.819] (II) LoadModule: "modesetting"
[    97.819] (II) Loading /usr/lib64/xorg/modules/drivers/modesetting_drv.so
[    97.819] (II) Module modesetting: vendor="X.Org Foundation"
[    97.819] 	compiled for 1.14.99.904, module version = 0.8.0
[    97.819] 	Module class: X.Org Video Driver
[    97.819] 	ABI class: X.Org Video Driver, version 15.0
[    97.819] (II) LoadModule: "fbdev"
[    97.819] (II) Loading /usr/lib64/xorg/modules/drivers/fbdev_drv.so
[    97.820] (II) Module fbdev: vendor="X.Org Foundation"
[    97.820] 	compiled for 1.14.99.904, module version = 0.4.4
[    97.820] 	Module class: X.Org Video Driver
[    97.820] 	ABI class: X.Org Video Driver, version 15.0
[    97.820] (II) LoadModule: "vesa"
[    97.820] (II) Loading /usr/lib64/xorg/modules/drivers/vesa_drv.so
[    97.820] (II) Module vesa: vendor="X.Org Foundation"
[    97.820] 	compiled for 1.14.99.904, module version = 2.3.3
[    97.820] 	Module class: X.Org Video Driver
[    97.820] 	ABI class: X.Org Video Driver, version 15.0
[    97.820] (II) NOUVEAU driver 
[    97.820] (II) NOUVEAU driver for NVIDIA chipset families :
[    97.820] 	RIVA TNT        (NV04)
[    97.820] 	RIVA TNT2       (NV05)
[    97.820] 	GeForce 256     (NV10)
[    97.820] 	GeForce 2       (NV11, NV15)
[    97.820] 	GeForce 4MX     (NV17, NV18)
[    97.820] 	GeForce 3       (NV20)
[    97.820] 	GeForce 4Ti     (NV25, NV28)
[    97.820] 	GeForce FX      (NV3x)
[    97.820] 	GeForce 6       (NV4x)
[    97.820] 	GeForce 7       (G7x)
[    97.820] 	GeForce 8       (G8x)
[    97.820] 	GeForce GTX 200 (NVA0)
[    97.820] 	GeForce GTX 400 (NVC0)
[    97.820] (II) modesetting: Driver for Modesetting Kernel Drivers: kms
[    97.820] (II) FBDEV: driver for framebuffer: fbdev
[    97.820] (II) VESA: driver for VESA chipsets: vesa
[    97.820] (++) using VT number 7

[    97.820] (II) [drm] nouveau interface version: 1.1.1
[    97.820] (WW) Falling back to old probe method for modesetting
[    97.820] (WW) Falling back to old probe method for fbdev
[    97.820] (II) Loading sub module "fbdevhw"
[    97.820] (II) LoadModule: "fbdevhw"
[    97.821] (II) Loading /usr/lib64/xorg/modules/libfbdevhw.so
[    97.821] (II) Module fbdevhw: vendor="X.Org Foundation"
[    97.821] 	compiled for 1.14.99.905, module version = 0.0.2
[    97.821] 	ABI class: X.Org Video Driver, version 15.0
[    97.821] (WW) Falling back to old probe method for vesa
[    97.821] (WW) VGA arbiter: cannot open kernel arbiter, no multi-card support
[    97.821] (II) Loading sub module "dri2"
[    97.821] (II) LoadModule: "dri2"
[    97.821] (II) Module "dri2" already built-in
[    97.821] (--) NOUVEAU(0): Chipset: "NVIDIA NVCE"
[    97.821] (II) NOUVEAU(0): Creating default Display subsection in Screen section
	"Default Screen Section" for depth/fbbpp 24/32
[    97.821] (==) NOUVEAU(0): Depth 24, (--) framebuffer bpp 32
[    97.821] (==) NOUVEAU(0): RGB weight 888
[    97.821] (==) NOUVEAU(0): Default visual is TrueColor
[    97.821] (==) NOUVEAU(0): Using HW cursor
[    97.821] (==) NOUVEAU(0): GLX sync to VBlank disabled.
[    97.821] (==) NOUVEAU(0): Page flipping enabled
[    97.821] (==) NOUVEAU(0): Swap limit set to 2 [Max allowed 2]
[    97.846] (II) NOUVEAU(0): Output DVI-I-1 has no monitor section
[    97.902] (II) NOUVEAU(0): Output DVI-I-2 has no monitor section
[    97.904] (II) NOUVEAU(0): Output HDMI-1 has no monitor section
[    97.927] (II) NOUVEAU(0): EDID for output DVI-I-1
[    97.984] (II) NOUVEAU(0): EDID for output DVI-I-2
[    97.984] (II) NOUVEAU(0): Manufacturer: SAM  Model: 795  Serial#: 1110590298
[    97.984] (II) NOUVEAU(0): Year: 2012  Week: 6
[    97.984] (II) NOUVEAU(0): EDID Version: 1.3
[    97.984] (II) NOUVEAU(0): Digital Display Input
[    97.984] (II) NOUVEAU(0): Max Image Size [cm]: horiz.: 52  vert.: 29
[    97.984] (II) NOUVEAU(0): Gamma: 2.20
[    97.984] (II) NOUVEAU(0): DPMS capabilities: Off
[    97.984] (II) NOUVEAU(0): Supported color encodings: RGB 4:4:4 YCrCb 4:4:4 
[    97.984] (II) NOUVEAU(0): First detailed timing is preferred mode
[    97.984] (II) NOUVEAU(0): redX: 0.641 redY: 0.338   greenX: 0.315 greenY: 0.629
[    97.984] (II) NOUVEAU(0): blueX: 0.159 blueY: 0.059   whiteX: 0.312 whiteY: 0.329
[    97.984] (II) NOUVEAU(0): Supported established timings:
[    97.984] (II) NOUVEAU(0): 720x400@70Hz
[    97.984] (II) NOUVEAU(0): 640x480@60Hz
[    97.984] (II) NOUVEAU(0): 640x480@67Hz
[    97.984] (II) NOUVEAU(0): 640x480@72Hz
[    97.984] (II) NOUVEAU(0): 640x480@75Hz
[    97.984] (II) NOUVEAU(0): 800x600@56Hz
[    97.984] (II) NOUVEAU(0): 800x600@60Hz
[    97.984] (II) NOUVEAU(0): 800x600@72Hz
[    97.984] (II) NOUVEAU(0): 800x600@75Hz
[    97.984] (II) NOUVEAU(0): 832x624@75Hz
[    97.984] (II) NOUVEAU(0): 1024x768@60Hz
[    97.984] (II) NOUVEAU(0): 1024x768@70Hz
[    97.984] (II) NOUVEAU(0): 1024x768@75Hz
[    97.984] (II) NOUVEAU(0): 1280x1024@75Hz
[    97.984] (II) NOUVEAU(0): 1152x864@75Hz
[    97.984] (II) NOUVEAU(0): Manufacturer's mask: 0
[    97.984] (II) NOUVEAU(0): Supported standard timings:
[    97.984] (II) NOUVEAU(0): #0: hsize: 1280  vsize 800  refresh: 60  vid: 129
[    97.984] (II) NOUVEAU(0): #1: hsize: 1280  vsize 960  refresh: 60  vid: 16513
[    97.984] (II) NOUVEAU(0): #2: hsize: 1280  vsize 1024  refresh: 60  vid: 32897
[    97.984] (II) NOUVEAU(0): #3: hsize: 1440  vsize 900  refresh: 60  vid: 149
[    97.984] (II) NOUVEAU(0): #4: hsize: 1600  vsize 1200  refresh: 60  vid: 16553
[    97.984] (II) NOUVEAU(0): #5: hsize: 1680  vsize 1050  refresh: 60  vid: 179
[    97.984] (II) NOUVEAU(0): #6: hsize: 1152  vsize 864  refresh: 75  vid: 20337
[    97.984] (II) NOUVEAU(0): #7: hsize: 1440  vsize 900  refresh: 75  vid: 3989
[    97.984] (II) NOUVEAU(0): Supported detailed timing:
[    97.984] (II) NOUVEAU(0): clock: 148.5 MHz   Image Size:  521 x 293 mm
[    97.984] (II) NOUVEAU(0): h_active: 1920  h_sync: 2008  h_sync_end 2052 h_blank_end 2200 h_border: 0
[    97.984] (II) NOUVEAU(0): v_active: 1080  v_sync: 1084  v_sync_end 1089 v_blanking: 1125 v_border: 0
[    97.984] (II) NOUVEAU(0): Ranges: V min: 56 V max: 75 Hz, H min: 30 H max: 81 kHz, PixClock max 175 MHz
[    97.984] (II) NOUVEAU(0): Monitor name: SA300/SA350
[    97.984] (II) NOUVEAU(0): Serial No: H4XC205202
[    97.984] (II) NOUVEAU(0): Supported detailed timing:
[    97.984] (II) NOUVEAU(0): clock: 148.5 MHz   Image Size:  521 x 293 mm
[    97.984] (II) NOUVEAU(0): h_active: 1920  h_sync: 2448  h_sync_end 2492 h_blank_end 2640 h_border: 0
[    97.984] (II) NOUVEAU(0): v_active: 1080  v_sync: 1084  v_sync_end 1089 v_blanking: 1125 v_border: 0
[    97.984] (II) NOUVEAU(0): Supported detailed timing:
[    97.984] (II) NOUVEAU(0): clock: 74.2 MHz   Image Size:  521 x 293 mm
[    97.984] (II) NOUVEAU(0): h_active: 1280  h_sync: 1390  h_sync_end 1430 h_blank_end 1650 h_border: 0
[    97.984] (II) NOUVEAU(0): v_active: 720  v_sync: 725  v_sync_end 730 v_blanking: 750 v_border: 0
[    97.984] (II) NOUVEAU(0): Supported detailed timing:
[    97.984] (II) NOUVEAU(0): clock: 74.2 MHz   Image Size:  521 x 293 mm
[    97.984] (II) NOUVEAU(0): h_active: 1280  h_sync: 1720  h_sync_end 1760 h_blank_end 1980 h_border: 0
[    97.984] (II) NOUVEAU(0): v_active: 720  v_sync: 725  v_sync_end 730 v_blanking: 750 v_border: 0
[    97.984] (II) NOUVEAU(0): Supported detailed timing:
[    97.984] (II) NOUVEAU(0): clock: 27.0 MHz   Image Size:  521 x 293 mm
[    97.984] (II) NOUVEAU(0): h_active: 720  h_sync: 732  h_sync_end 796 h_blank_end 864 h_border: 0
[    97.984] (II) NOUVEAU(0): v_active: 576  v_sync: 581  v_sync_end 586 v_blanking: 625 v_border: 0
[    97.984] (II) NOUVEAU(0): Supported detailed timing:
[    97.984] (II) NOUVEAU(0): clock: 27.0 MHz   Image Size:  521 x 293 mm
[    97.984] (II) NOUVEAU(0): h_active: 720  h_sync: 736  h_sync_end 798 h_blank_end 858 h_border: 0
[    97.984] (II) NOUVEAU(0): v_active: 480  v_sync: 489  v_sync_end 495 v_blanking: 525 v_border: 0
[    97.984] (II) NOUVEAU(0): Number of EDID sections to follow: 1
[    97.984] (II) NOUVEAU(0): EDID (in hex):
[    97.984] (II) NOUVEAU(0): 	00ffffffffffff004c2d95075a433242
[    97.984] (II) NOUVEAU(0): 	0616010380341d782a2cc1a45650a128
[    97.984] (II) NOUVEAU(0): 	0f5054bfef808100814081809500a940
[    97.984] (II) NOUVEAU(0): 	b300714f950f023a801871382d40582c
[    97.984] (II) NOUVEAU(0): 	450009252100001e000000fd00384b1e
[    97.984] (II) NOUVEAU(0): 	5111000a202020202020000000fc0053
[    97.984] (II) NOUVEAU(0): 	413330302f53413335300a20000000ff
[    97.984] (II) NOUVEAU(0): 	00483458433230353230320a20200176
[    97.984] (II) NOUVEAU(0): 	02010400023a80d072382d40102c4580
[    97.984] (II) NOUVEAU(0): 	09252100001e011d007251d01e206e28
[    97.984] (II) NOUVEAU(0): 	550009252100001e011d00bc52d01e20
[    97.984] (II) NOUVEAU(0): 	b828554009252100001e8c0ad0902040
[    97.984] (II) NOUVEAU(0): 	31200c4055000925210000188c0ad08a
[    97.984] (II) NOUVEAU(0): 	20e02d10103e96000925210000180000
[    97.984] (II) NOUVEAU(0): 	00000000000000000000000000000000
[    97.984] (II) NOUVEAU(0): 	0000000000000000000000000000005e
[    97.984] (II) NOUVEAU(0): Printing probed modes for output DVI-I-2
[    97.984] (II) NOUVEAU(0): Modeline "1920x1080"x60.0  148.50  1920 2008 2052 2200  1080 1084 1089 1125 +hsync +vsync (67.5 kHz eP)
[    97.984] (II) NOUVEAU(0): Modeline "1920x1080"x50.0  148.50  1920 2448 2492 2640  1080 1084 1089 1125 +hsync +vsync (56.2 kHz e)
[    97.984] (II) NOUVEAU(0): Modeline "1920x1080"x59.9  148.35  1920 2008 2052 2200  1080 1084 1089 1125 +hsync +vsync (67.4 kHz e)
[    97.984] (II) NOUVEAU(0): Modeline "1600x1200"x60.0  162.00  1600 1664 1856 2160  1200 1201 1204 1250 +hsync +vsync (75.0 kHz e)
[    97.984] (II) NOUVEAU(0): Modeline "1680x1050"x59.9  119.00  1680 1728 1760 1840  1050 1053 1059 1080 +hsync -vsync (64.7 kHz e)
[    97.984] (II) NOUVEAU(0): Modeline "1280x1024"x75.0  135.00  1280 1296 1440 1688  1024 1025 1028 1066 +hsync +vsync (80.0 kHz e)
[    97.984] (II) NOUVEAU(0): Modeline "1280x1024"x60.0  108.00  1280 1328 1440 1688  1024 1025 1028 1066 +hsync +vsync (64.0 kHz e)
[    97.985] (II) NOUVEAU(0): Modeline "1440x900"x75.0  136.75  1440 1536 1688 1936  900 903 909 942 -hsync +vsync (70.6 kHz e)
[    97.985] (II) NOUVEAU(0): Modeline "1440x900"x59.9   88.75  1440 1488 1520 1600  900 903 909 926 +hsync -vsync (55.5 kHz e)
[    97.985] (II) NOUVEAU(0): Modeline "1280x960"x60.0  108.00  1280 1376 1488 1800  960 961 964 1000 +hsync +vsync (60.0 kHz e)
[    97.985] (II) NOUVEAU(0): Modeline "1280x800"x59.9   71.00  1280 1328 1360 1440  800 803 809 823 +hsync -vsync (49.3 kHz e)
[    97.985] (II) NOUVEAU(0): Modeline "1152x864"x75.0  108.00  1152 1216 1344 1600  864 865 868 900 +hsync +vsync (67.5 kHz e)
[    97.985] (II) NOUVEAU(0): Modeline "1280x720"x60.0   74.25  1280 1390 1430 1650  720 725 730 750 +hsync +vsync (45.0 kHz e)
[    97.985] (II) NOUVEAU(0): Modeline "1280x720"x50.0   74.25  1280 1720 1760 1980  720 725 730 750 +hsync +vsync (37.5 kHz e)
[    97.985] (II) NOUVEAU(0): Modeline "1280x720"x59.9   74.18  1280 1390 1430 1650  720 725 730 750 +hsync +vsync (45.0 kHz e)
[    97.985] (II) NOUVEAU(0): Modeline "1024x768"x75.1   78.80  1024 1040 1136 1312  768 769 772 800 +hsync +vsync (60.1 kHz e)
[    97.985] (II) NOUVEAU(0): Modeline "1024x768"x70.1   75.00  1024 1048 1184 1328  768 771 777 806 -hsync -vsync (56.5 kHz e)
[    97.985] (II) NOUVEAU(0): Modeline "1024x768"x60.0   65.00  1024 1048 1184 1344  768 771 777 806 -hsync -vsync (48.4 kHz e)
[    97.985] (II) NOUVEAU(0): Modeline "832x624"x74.6   57.28  832 864 928 1152  624 625 628 667 -hsync -vsync (49.7 kHz e)
[    97.985] (II) NOUVEAU(0): Modeline "800x600"x72.2   50.00  800 856 976 1040  600 637 643 666 +hsync +vsync (48.1 kHz e)
[    97.985] (II) NOUVEAU(0): Modeline "800x600"x75.0   49.50  800 816 896 1056  600 601 604 625 +hsync +vsync (46.9 kHz e)
[    97.985] (II) NOUVEAU(0): Modeline "800x600"x60.3   40.00  800 840 968 1056  600 601 605 628 +hsync +vsync (37.9 kHz e)
[    97.985] (II) NOUVEAU(0): Modeline "800x600"x56.2   36.00  800 824 896 1024  600 601 603 625 +hsync +vsync (35.2 kHz e)
[    97.985] (II) NOUVEAU(0): Modeline "720x576"x50.0   27.00  720 732 796 864  576 581 586 625 -hsync -vsync (31.2 kHz e)
[    97.985] (II) NOUVEAU(0): Modeline "720x480"x60.0   27.03  720 736 798 858  480 489 495 525 -hsync -vsync (31.5 kHz e)
[    97.985] (II) NOUVEAU(0): Modeline "720x480"x59.9   27.00  720 736 798 858  480 489 495 525 -hsync -vsync (31.5 kHz e)
[    97.985] (II) NOUVEAU(0): Modeline "640x480"x75.0   31.50  640 656 720 840  480 481 484 500 -hsync -vsync (37.5 kHz e)
[    97.985] (II) NOUVEAU(0): Modeline "640x480"x72.8   31.50  640 664 704 832  480 489 491 520 -hsync -vsync (37.9 kHz e)
[    97.985] (II) NOUVEAU(0): Modeline "640x480"x66.7   30.24  640 704 768 864  480 483 486 525 -hsync -vsync (35.0 kHz e)
[    97.985] (II) NOUVEAU(0): Modeline "640x480"x60.0   25.20  640 656 752 800  480 490 492 525 -hsync -vsync (31.5 kHz e)
[    97.985] (II) NOUVEAU(0): Modeline "640x480"x59.9   25.18  640 656 752 800  480 490 492 525 -hsync -vsync (31.5 kHz e)
[    97.985] (II) NOUVEAU(0): Modeline "720x400"x70.1   28.32  720 738 846 900  400 412 414 449 -hsync +vsync (31.5 kHz e)
[    97.987] (II) NOUVEAU(0): EDID for output HDMI-1
[    97.987] (II) NOUVEAU(0): Output DVI-I-1 disconnected
[    97.987] (II) NOUVEAU(0): Output DVI-I-2 connected
[    97.987] (II) NOUVEAU(0): Output HDMI-1 disconnected
[    97.987] (II) NOUVEAU(0): Using exact sizes for initial modes
[    97.987] (II) NOUVEAU(0): Output DVI-I-2 using initial mode 1920x1080
[    97.987] (II) NOUVEAU(0): Using default gamma of (1.0, 1.0, 1.0) unless otherwise stated.
[    97.987] (--) NOUVEAU(0): Virtual size is 1920x1080 (pitch 0)
[    97.987] (**) NOUVEAU(0):  Driver mode "1920x1080": 148.5 MHz (scaled from 0.0 MHz), 67.5 kHz, 60.0 Hz
[    97.987] (II) NOUVEAU(0): Modeline "1920x1080"x60.0  148.50  1920 2008 2052 2200  1080 1084 1089 1125 +hsync +vsync (67.5 kHz eP)
[    97.987] (**) NOUVEAU(0):  Driver mode "1920x1080": 148.5 MHz (scaled from 0.0 MHz), 56.2 kHz, 50.0 Hz
[    97.987] (II) NOUVEAU(0): Modeline "1920x1080"x50.0  148.50  1920 2448 2492 2640  1080 1084 1089 1125 +hsync +vsync (56.2 kHz e)
[    97.987] (**) NOUVEAU(0):  Driver mode "1920x1080": 148.4 MHz (scaled from 0.0 MHz), 67.4 kHz, 59.9 Hz
[    97.987] (II) NOUVEAU(0): Modeline "1920x1080"x59.9  148.35  1920 2008 2052 2200  1080 1084 1089 1125 +hsync +vsync (67.4 kHz e)
[    97.987] (**) NOUVEAU(0):  Driver mode "1600x1200": 162.0 MHz (scaled from 0.0 MHz), 75.0 kHz, 60.0 Hz
[    97.987] (II) NOUVEAU(0): Modeline "1600x1200"x60.0  162.00  1600 1664 1856 2160  1200 1201 1204 1250 +hsync +vsync (75.0 kHz e)
[    97.987] (**) NOUVEAU(0):  Driver mode "1680x1050": 119.0 MHz (scaled from 0.0 MHz), 64.7 kHz, 59.9 Hz
[    97.987] (II) NOUVEAU(0): Modeline "1680x1050"x59.9  119.00  1680 1728 1760 1840  1050 1053 1059 1080 +hsync -vsync (64.7 kHz e)
[    97.987] (**) NOUVEAU(0):  Driver mode "1280x1024": 135.0 MHz (scaled from 0.0 MHz), 80.0 kHz, 75.0 Hz
[    97.987] (II) NOUVEAU(0): Modeline "1280x1024"x75.0  135.00  1280 1296 1440 1688  1024 1025 1028 1066 +hsync +vsync (80.0 kHz e)
[    97.987] (**) NOUVEAU(0):  Driver mode "1280x1024": 108.0 MHz (scaled from 0.0 MHz), 64.0 kHz, 60.0 Hz
[    97.987] (II) NOUVEAU(0): Modeline "1280x1024"x60.0  108.00  1280 1328 1440 1688  1024 1025 1028 1066 +hsync +vsync (64.0 kHz e)
[    97.987] (**) NOUVEAU(0):  Driver mode "1440x900": 136.8 MHz (scaled from 0.0 MHz), 70.6 kHz, 75.0 Hz
[    97.987] (II) NOUVEAU(0): Modeline "1440x900"x75.0  136.75  1440 1536 1688 1936  900 903 909 942 -hsync +vsync (70.6 kHz e)
[    97.987] (**) NOUVEAU(0):  Driver mode "1440x900": 88.8 MHz (scaled from 0.0 MHz), 55.5 kHz, 59.9 Hz
[    97.987] (II) NOUVEAU(0): Modeline "1440x900"x59.9   88.75  1440 1488 1520 1600  900 903 909 926 +hsync -vsync (55.5 kHz e)
[    97.987] (**) NOUVEAU(0):  Driver mode "1280x960": 108.0 MHz (scaled from 0.0 MHz), 60.0 kHz, 60.0 Hz
[    97.987] (II) NOUVEAU(0): Modeline "1280x960"x60.0  108.00  1280 1376 1488 1800  960 961 964 1000 +hsync +vsync (60.0 kHz e)
[    97.987] (**) NOUVEAU(0):  Driver mode "1280x800": 71.0 MHz (scaled from 0.0 MHz), 49.3 kHz, 59.9 Hz
[    97.987] (II) NOUVEAU(0): Modeline "1280x800"x59.9   71.00  1280 1328 1360 1440  800 803 809 823 +hsync -vsync (49.3 kHz e)
[    97.987] (**) NOUVEAU(0):  Driver mode "1152x864": 108.0 MHz (scaled from 0.0 MHz), 67.5 kHz, 75.0 Hz
[    97.987] (II) NOUVEAU(0): Modeline "1152x864"x75.0  108.00  1152 1216 1344 1600  864 865 868 900 +hsync +vsync (67.5 kHz e)
[    97.987] (**) NOUVEAU(0):  Driver mode "1280x720": 74.2 MHz (scaled from 0.0 MHz), 45.0 kHz, 60.0 Hz
[    97.987] (II) NOUVEAU(0): Modeline "1280x720"x60.0   74.25  1280 1390 1430 1650  720 725 730 750 +hsync +vsync (45.0 kHz e)
[    97.987] (**) NOUVEAU(0):  Driver mode "1280x720": 74.2 MHz (scaled from 0.0 MHz), 37.5 kHz, 50.0 Hz
[    97.987] (II) NOUVEAU(0): Modeline "1280x720"x50.0   74.25  1280 1720 1760 1980  720 725 730 750 +hsync +vsync (37.5 kHz e)
[    97.987] (**) NOUVEAU(0):  Driver mode "1280x720": 74.2 MHz (scaled from 0.0 MHz), 45.0 kHz, 59.9 Hz
[    97.987] (II) NOUVEAU(0): Modeline "1280x720"x59.9   74.18  1280 1390 1430 1650  720 725 730 750 +hsync +vsync (45.0 kHz e)
[    97.987] (**) NOUVEAU(0):  Driver mode "1024x768": 78.8 MHz (scaled from 0.0 MHz), 60.1 kHz, 75.1 Hz
[    97.987] (II) NOUVEAU(0): Modeline "1024x768"x75.1   78.80  1024 1040 1136 1312  768 769 772 800 +hsync +vsync (60.1 kHz e)
[    97.987] (**) NOUVEAU(0):  Driver mode "1024x768": 75.0 MHz (scaled from 0.0 MHz), 56.5 kHz, 70.1 Hz
[    97.987] (II) NOUVEAU(0): Modeline "1024x768"x70.1   75.00  1024 1048 1184 1328  768 771 777 806 -hsync -vsync (56.5 kHz e)
[    97.987] (**) NOUVEAU(0):  Driver mode "1024x768": 65.0 MHz (scaled from 0.0 MHz), 48.4 kHz, 60.0 Hz
[    97.987] (II) NOUVEAU(0): Modeline "1024x768"x60.0   65.00  1024 1048 1184 1344  768 771 777 806 -hsync -vsync (48.4 kHz e)
[    97.987] (**) NOUVEAU(0):  Driver mode "832x624": 57.3 MHz (scaled from 0.0 MHz), 49.7 kHz, 74.6 Hz
[    97.987] (II) NOUVEAU(0): Modeline "832x624"x74.6   57.28  832 864 928 1152  624 625 628 667 -hsync -vsync (49.7 kHz e)
[    97.987] (**) NOUVEAU(0):  Driver mode "800x600": 50.0 MHz (scaled from 0.0 MHz), 48.1 kHz, 72.2 Hz
[    97.987] (II) NOUVEAU(0): Modeline "800x600"x72.2   50.00  800 856 976 1040  600 637 643 666 +hsync +vsync (48.1 kHz e)
[    97.987] (**) NOUVEAU(0):  Driver mode "800x600": 49.5 MHz (scaled from 0.0 MHz), 46.9 kHz, 75.0 Hz
[    97.987] (II) NOUVEAU(0): Modeline "800x600"x75.0   49.50  800 816 896 1056  600 601 604 625 +hsync +vsync (46.9 kHz e)
[    97.987] (**) NOUVEAU(0):  Driver mode "800x600": 40.0 MHz (scaled from 0.0 MHz), 37.9 kHz, 60.3 Hz
[    97.987] (II) NOUVEAU(0): Modeline "800x600"x60.3   40.00  800 840 968 1056  600 601 605 628 +hsync +vsync (37.9 kHz e)
[    97.987] (**) NOUVEAU(0):  Driver mode "800x600": 36.0 MHz (scaled from 0.0 MHz), 35.2 kHz, 56.2 Hz
[    97.987] (II) NOUVEAU(0): Modeline "800x600"x56.2   36.00  800 824 896 1024  600 601 603 625 +hsync +vsync (35.2 kHz e)
[    97.987] (**) NOUVEAU(0):  Driver mode "720x576": 27.0 MHz (scaled from 0.0 MHz), 31.2 kHz, 50.0 Hz
[    97.987] (II) NOUVEAU(0): Modeline "720x576"x50.0   27.00  720 732 796 864  576 581 586 625 -hsync -vsync (31.2 kHz e)
[    97.987] (**) NOUVEAU(0):  Driver mode "720x480": 27.0 MHz (scaled from 0.0 MHz), 31.5 kHz, 60.0 Hz
[    97.987] (II) NOUVEAU(0): Modeline "720x480"x60.0   27.03  720 736 798 858  480 489 495 525 -hsync -vsync (31.5 kHz e)
[    97.987] (**) NOUVEAU(0):  Driver mode "720x480": 27.0 MHz (scaled from 0.0 MHz), 31.5 kHz, 59.9 Hz
[    97.987] (II) NOUVEAU(0): Modeline "720x480"x59.9   27.00  720 736 798 858  480 489 495 525 -hsync -vsync (31.5 kHz e)
[    97.987] (**) NOUVEAU(0):  Driver mode "640x480": 31.5 MHz (scaled from 0.0 MHz), 37.5 kHz, 75.0 Hz
[    97.987] (II) NOUVEAU(0): Modeline "640x480"x75.0   31.50  640 656 720 840  480 481 484 500 -hsync -vsync (37.5 kHz e)
[    97.987] (**) NOUVEAU(0):  Driver mode "640x480": 31.5 MHz (scaled from 0.0 MHz), 37.9 kHz, 72.8 Hz
[    97.987] (II) NOUVEAU(0): Modeline "640x480"x72.8   31.50  640 664 704 832  480 489 491 520 -hsync -vsync (37.9 kHz e)
[    97.987] (**) NOUVEAU(0):  Driver mode "640x480": 30.2 MHz (scaled from 0.0 MHz), 35.0 kHz, 66.7 Hz
[    97.987] (II) NOUVEAU(0): Modeline "640x480"x66.7   30.24  640 704 768 864  480 483 486 525 -hsync -vsync (35.0 kHz e)
[    97.987] (**) NOUVEAU(0):  Driver mode "640x480": 25.2 MHz (scaled from 0.0 MHz), 31.5 kHz, 60.0 Hz
[    97.987] (II) NOUVEAU(0): Modeline "640x480"x60.0   25.20  640 656 752 800  480 490 492 525 -hsync -vsync (31.5 kHz e)
[    97.987] (**) NOUVEAU(0):  Driver mode "640x480": 25.2 MHz (scaled from 0.0 MHz), 31.5 kHz, 59.9 Hz
[    97.987] (II) NOUVEAU(0): Modeline "640x480"x59.9   25.18  640 656 752 800  480 490 492 525 -hsync -vsync (31.5 kHz e)
[    97.987] (**) NOUVEAU(0):  Driver mode "720x400": 28.3 MHz (scaled from 0.0 MHz), 31.5 kHz, 70.1 Hz
[    97.987] (II) NOUVEAU(0): Modeline "720x400"x70.1   28.32  720 738 846 900  400 412 414 449 -hsync +vsync (31.5 kHz e)
[    97.987] (==) NOUVEAU(0): DPI set to (96, 96)
[    97.987] (II) Loading sub module "fb"
[    97.988] (II) LoadModule: "fb"
[    97.988] (II) Loading /usr/lib64/xorg/modules/libfb.so
[    97.988] (II) Module fb: vendor="X.Org Foundation"
[    97.988] 	compiled for 1.14.99.905, module version = 1.0.0
[    97.988] 	ABI class: X.Org ANSI C Emulation, version 0.4
[    97.988] (II) Loading sub module "exa"
[    97.988] (II) LoadModule: "exa"
[    97.988] (II) Loading /usr/lib64/xorg/modules/libexa.so
[    97.988] (II) Module exa: vendor="X.Org Foundation"
[    97.988] 	compiled for 1.14.99.905, module version = 2.6.0
[    97.988] 	ABI class: X.Org Video Driver, version 15.0
[    97.988] (II) Loading sub module "shadowfb"
[    97.988] (II) LoadModule: "shadowfb"
[    97.988] (II) Loading /usr/lib64/xorg/modules/libshadowfb.so
[    97.989] (II) Module shadowfb: vendor="X.Org Foundation"
[    97.989] 	compiled for 1.14.99.905, module version = 1.0.0
[    97.989] 	ABI class: X.Org ANSI C Emulation, version 0.4
[    97.989] (II) UnloadModule: "modesetting"
[    97.989] (II) Unloading modesetting
[    97.989] (II) UnloadModule: "fbdev"
[    97.989] (II) Unloading fbdev
[    97.989] (II) UnloadSubModule: "fbdevhw"
[    97.989] (II) Unloading fbdevhw
[    97.989] (II) UnloadModule: "vesa"
[    97.989] (II) Unloading vesa
[    97.989] (--) Depth 24 pixmap format is 32 bpp
[    97.990] (II) NOUVEAU(0): Opened GPU channel 0
[    97.992] (II) NOUVEAU(0): [DRI2] Setup complete
[    97.992] (II) NOUVEAU(0): [DRI2]   DRI driver: nouveau
[    97.992] (II) NOUVEAU(0): [DRI2]   VDPAU driver: nouveau
[    97.993] (II) EXA(0): Driver allocated offscreen pixmaps
[    97.993] (II) EXA(0): Driver registered support for the following operations:
[    97.993] (II)         Solid
[    97.993] (II)         Copy
[    97.993] (II)         Composite (RENDER acceleration)
[    97.993] (II)         UploadToScreen
[    97.993] (II)         DownloadFromScreen
[    97.993] (==) NOUVEAU(0): Backing store enabled
[    97.993] (==) NOUVEAU(0): Silken mouse enabled
[    97.993] (II) NOUVEAU(0): [XvMC] Associated with Nouveau GeForce 8/9 Textured Video.
[    97.993] (II) NOUVEAU(0): [XvMC] Extension initialized.
[    97.993] (==) NOUVEAU(0): DPMS enabled
[    97.993] (II) NOUVEAU(0): RandR 1.2 enabled, ignore the following RandR disabled message.
[    97.993] (--) RandR disabled
[    98.016] (II) AIGLX: enabled GLX_MESA_copy_sub_buffer
[    98.016] (II) AIGLX: enabled GLX_ARB_create_context
[    98.016] (II) AIGLX: enabled GLX_ARB_create_context_profile
[    98.016] (II) AIGLX: enabled GLX_EXT_create_context_es2_profile
[    98.016] (II) AIGLX: enabled GLX_INTEL_swap_event
[    98.016] (II) AIGLX: enabled GLX_SGI_swap_control and GLX_MESA_swap_control
[    98.016] (II) AIGLX: enabled GLX_EXT_framebuffer_sRGB
[    98.016] (II) AIGLX: enabled GLX_ARB_fbconfig_float
[    98.016] (II) AIGLX: GLX_EXT_texture_from_pixmap backed by buffer objects
[    98.016] (II) AIGLX: Loaded and initialized nouveau
[    98.016] (II) GLX: Initialized DRI2 GL provider for screen 0
[    98.020] (II) NOUVEAU(0): NVEnterVT is called.
[    98.053] (II) NOUVEAU(0): Setting screen physical size to 508 x 285
[    98.053] resize called 1920 1080
[    98.113] (II) config/udev: Adding input device Power Button (/dev/input/event3)
[    98.113] (**) Power Button: Applying InputClass "evdev keyboard catchall"
[    98.113] (**) Power Button: Applying InputClass "evdev keyboard catchall"
[    98.113] (**) Power Button: Applying InputClass "LocalKeyboard"
[    98.113] (II) LoadModule: "evdev"
[    98.114] (II) Loading /usr/lib64/xorg/modules/input/evdev_drv.so
[    98.114] (II) Module evdev: vendor="X.Org Foundation"
[    98.114] 	compiled for 1.14.99.905, module version = 2.8.2
[    98.114] 	Module class: X.Org XInput Driver
[    98.114] 	ABI class: X.Org XInput driver, version 20.0
[    98.114] (II) Using input driver 'evdev' for 'Power Button'
[    98.114] (**) Power Button: always reports core events
[    98.114] (**) evdev: Power Button: Device: "/dev/input/event3"
[    98.114] (--) evdev: Power Button: Vendor 0 Product 0x1
[    98.114] (--) evdev: Power Button: Found keys
[    98.114] (II) evdev: Power Button: Configuring as keyboard
[    98.114] (**) Option "config_info" "udev:/sys/devices/LNXSYSTM:00/LNXPWRBN:00/input/input3/event3"
[    98.114] (II) XINPUT: Adding extended input device "Power Button" (type: KEYBOARD, id 6)
[    98.114] (**) Option "xkb_rules" "evdev"
[    98.114] (**) Option "xkb_model" "pc104"
[    98.114] (**) Option "xkb_layout" "gb"
[    98.130] (II) config/udev: Adding input device Power Button (/dev/input/event2)
[    98.131] (**) Power Button: Applying InputClass "evdev keyboard catchall"
[    98.131] (**) Power Button: Applying InputClass "evdev keyboard catchall"
[    98.131] (**) Power Button: Applying InputClass "LocalKeyboard"
[    98.131] (II) Using input driver 'evdev' for 'Power Button'
[    98.131] (**) Power Button: always reports core events
[    98.131] (**) evdev: Power Button: Device: "/dev/input/event2"
[    98.131] (--) evdev: Power Button: Vendor 0 Product 0x1
[    98.131] (--) evdev: Power Button: Found keys
[    98.131] (II) evdev: Power Button: Configuring as keyboard
[    98.131] (**) Option "config_info" "udev:/sys/devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input2/event2"
[    98.131] (II) XINPUT: Adding extended input device "Power Button" (type: KEYBOARD, id 7)
[    98.131] (**) Option "xkb_rules" "evdev"
[    98.131] (**) Option "xkb_model" "pc104"
[    98.131] (**) Option "xkb_layout" "gb"
[    98.131] (II) config/udev: Adding drm device (/dev/dri/card0)
[    98.131] (II) config/udev: Adding input device HDA NVidia HDMI (/dev/input/event12)
[    98.131] (II) No input driver specified, ignoring this device.
[    98.131] (II) This device may have been added with another device file.
[    98.131] (II) config/udev: Adding input device CH PRODUCTS CH FLIGHT SIM YOKE USB  (/dev/input/event1)
[    98.131] (II) No input driver specified, ignoring this device.
[    98.131] (II) This device may have been added with another device file.
[    98.131] (II) config/udev: Adding input device CH PRODUCTS CH FLIGHT SIM YOKE USB  (/dev/input/js0)
[    98.131] (II) No input driver specified, ignoring this device.
[    98.131] (II) This device may have been added with another device file.
[    98.132] (II) config/udev: Adding input device HD Pro Webcam C920 (/dev/input/event14)
[    98.132] (**) HD Pro Webcam C920: Applying InputClass "evdev keyboard catchall"
[    98.132] (**) HD Pro Webcam C920: Applying InputClass "evdev keyboard catchall"
[    98.132] (**) HD Pro Webcam C920: Applying InputClass "LocalKeyboard"
[    98.132] (II) Using input driver 'evdev' for 'HD Pro Webcam C920'
[    98.132] (**) HD Pro Webcam C920: always reports core events
[    98.132] (**) evdev: HD Pro Webcam C920: Device: "/dev/input/event14"
[    98.132] (--) evdev: HD Pro Webcam C920: Vendor 0x46d Product 0x82d
[    98.132] (--) evdev: HD Pro Webcam C920: Found keys
[    98.132] (II) evdev: HD Pro Webcam C920: Configuring as keyboard
[    98.132] (**) Option "config_info" "udev:/sys/devices/pci0000:00/0000:00:13.2/usb6/6-5/6-5:1.0/input/input14/event14"
[    98.132] (II) XINPUT: Adding extended input device "HD Pro Webcam C920" (type: KEYBOARD, id 8)
[    98.132] (**) Option "xkb_rules" "evdev"
[    98.132] (**) Option "xkb_model" "pc104"
[    98.132] (**) Option "xkb_layout" "gb"
[    98.132] (II) config/udev: Adding input device HDA ATI SB Line Out Side (/dev/input/event5)
[    98.132] (II) No input driver specified, ignoring this device.
[    98.132] (II) This device may have been added with another device file.
[    98.132] (II) config/udev: Adding input device HDA ATI SB Front Headphone (/dev/input/event4)
[    98.132] (II) No input driver specified, ignoring this device.
[    98.132] (II) This device may have been added with another device file.
[    98.132] (II) config/udev: Adding input device HDA ATI SB Front Mic (/dev/input/event11)
[    98.132] (II) No input driver specified, ignoring this device.
[    98.132] (II) This device may have been added with another device file.
[    98.133] (II) config/udev: Adding input device HDA ATI SB Rear Mic (/dev/input/event10)
[    98.133] (II) No input driver specified, ignoring this device.
[    98.133] (II) This device may have been added with another device file.
[    98.133] (II) config/udev: Adding input device HDA ATI SB Line (/dev/input/event9)
[    98.133] (II) No input driver specified, ignoring this device.
[    98.133] (II) This device may have been added with another device file.
[    98.133] (II) config/udev: Adding input device HDA ATI SB Line Out Front (/dev/input/event8)
[    98.133] (II) No input driver specified, ignoring this device.
[    98.133] (II) This device may have been added with another device file.
[    98.133] (II) config/udev: Adding input device HDA ATI SB Line Out Surround (/dev/input/event7)
[    98.133] (II) No input driver specified, ignoring this device.
[    98.133] (II) This device may have been added with another device file.
[    98.133] (II) config/udev: Adding input device HDA ATI SB Line Out CLFE (/dev/input/event6)
[    98.133] (II) No input driver specified, ignoring this device.
[    98.133] (II) This device may have been added with another device file.
[    98.133] (II) config/udev: Adding input device Logitech Trackball (/dev/input/event13)
[    98.133] (**) Logitech Trackball: Applying InputClass "evdev pointer catchall"
[    98.133] (**) Logitech Trackball: Applying InputClass "evdev pointer catchall"
[    98.133] (II) Using input driver 'evdev' for 'Logitech Trackball'
[    98.133] (**) Logitech Trackball: always reports core events
[    98.133] (**) evdev: Logitech Trackball: Device: "/dev/input/event13"
[    98.133] (--) evdev: Logitech Trackball: Vendor 0x46d Product 0xc404
[    98.133] (--) evdev: Logitech Trackball: Found 9 mouse buttons
[    98.133] (--) evdev: Logitech Trackball: Found scroll wheel(s)
[    98.133] (--) evdev: Logitech Trackball: Found relative axes
[    98.133] (--) evdev: Logitech Trackball: Found x and y relative axes
[    98.134] (II) evdev: Logitech Trackball: Configuring as mouse
[    98.134] (II) evdev: Logitech Trackball: Adding scrollwheel support
[    98.134] (**) evdev: Logitech Trackball: YAxisMapping: buttons 4 and 5
[    98.134] (**) evdev: Logitech Trackball: EmulateWheelButton: 4, EmulateWheelInertia: 10, EmulateWheelTimeout: 200
[    98.134] (**) Option "config_info" "udev:/sys/devices/pci0000:00/0000:00:16.0/usb11/11-1/11-1:1.0/input/input13/event13"
[    98.134] (II) XINPUT: Adding extended input device "Logitech Trackball" (type: MOUSE, id 9)
[    98.134] (II) evdev: Logitech Trackball: initialized for relative axes.
[    98.134] (**) Logitech Trackball: (accel) keeping acceleration scheme 1
[    98.134] (**) Logitech Trackball: (accel) acceleration profile 0
[    98.134] (**) Logitech Trackball: (accel) acceleration factor: 2.000
[    98.134] (**) Logitech Trackball: (accel) acceleration threshold: 4
[    98.134] (II) config/udev: Adding input device Logitech Trackball (/dev/input/mouse0)
[    98.134] (II) No input driver specified, ignoring this device.
[    98.134] (II) This device may have been added with another device file.
[    98.134] (II) config/udev: Adding input device AT Translated Set 2 keyboard (/dev/input/event0)
[    98.134] (**) AT Translated Set 2 keyboard: Applying InputClass "evdev keyboard catchall"
[    98.134] (**) AT Translated Set 2 keyboard: Applying InputClass "evdev keyboard catchall"
[    98.134] (**) AT Translated Set 2 keyboard: Applying InputClass "LocalKeyboard"
[    98.134] (II) Using input driver 'evdev' for 'AT Translated Set 2 keyboard'
[    98.134] (**) AT Translated Set 2 keyboard: always reports core events
[    98.134] (**) evdev: AT Translated Set 2 keyboard: Device: "/dev/input/event0"
[    98.134] (--) evdev: AT Translated Set 2 keyboard: Vendor 0x1 Product 0x1
[    98.134] (--) evdev: AT Translated Set 2 keyboard: Found keys
[    98.134] (II) evdev: AT Translated Set 2 keyboard: Configuring as keyboard
[    98.134] (**) Option "config_info" "udev:/sys/devices/platform/i8042/serio0/input/input0/event0"
[    98.134] (II) XINPUT: Adding extended input device "AT Translated Set 2 keyboard" (type: KEYBOARD, id 10)
[    98.134] (**) Option "xkb_rules" "evdev"
[    98.134] (**) Option "xkb_model" "pc104"
[    98.134] (**) Option "xkb_layout" "gb"
[   120.452] (II) NOUVEAU(0): EDID vendor "SAM", prod id 1941
[   120.452] (II) NOUVEAU(0): Using EDID range info for horizontal sync
[   120.452] (II) NOUVEAU(0): Using EDID range info for vertical refresh
[   120.452] (II) NOUVEAU(0): Printing DDC gathered Modelines:
[   120.452] (II) NOUVEAU(0): Modeline "1920x1080"x0.0  148.50  1920 2008 2052 2200  1080 1084 1089 1125 +hsync +vsync (67.5 kHz eP)
[   120.452] (II) NOUVEAU(0): Modeline "1920x1080"x0.0  148.50  1920 2448 2492 2640  1080 1084 1089 1125 +hsync +vsync (56.2 kHz e)
[   120.452] (II) NOUVEAU(0): Modeline "1280x720"x0.0   74.25  1280 1390 1430 1650  720 725 730 750 +hsync +vsync (45.0 kHz e)
[   120.452] (II) NOUVEAU(0): Modeline "1280x720"x0.0   74.25  1280 1720 1760 1980  720 725 730 750 +hsync +vsync (37.5 kHz e)
[   120.452] (II) NOUVEAU(0): Modeline "720x576"x0.0   27.00  720 732 796 864  576 581 586 625 -hsync -vsync (31.2 kHz e)
[   120.452] (II) NOUVEAU(0): Modeline "720x480"x0.0   27.00  720 736 798 858  480 489 495 525 -hsync -vsync (31.5 kHz e)
[   120.452] (II) NOUVEAU(0): Modeline "800x600"x0.0   40.00  800 840 968 1056  600 601 605 628 +hsync +vsync (37.9 kHz e)
[   120.452] (II) NOUVEAU(0): Modeline "800x600"x0.0   36.00  800 824 896 1024  600 601 603 625 +hsync +vsync (35.2 kHz e)
[   120.452] (II) NOUVEAU(0): Modeline "640x480"x0.0   31.50  640 656 720 840  480 481 484 500 -hsync -vsync (37.5 kHz e)
[   120.452] (II) NOUVEAU(0): Modeline "640x480"x0.0   31.50  640 664 704 832  480 489 492 520 -hsync -vsync (37.9 kHz e)
[   120.452] (II) NOUVEAU(0): Modeline "640x480"x0.0   30.24  640 704 768 864  480 483 486 525 -hsync -vsync (35.0 kHz e)
[   120.452] (II) NOUVEAU(0): Modeline "640x480"x0.0   25.18  640 656 752 800  480 490 492 525 -hsync -vsync (31.5 kHz e)
[   120.452] (II) NOUVEAU(0): Modeline "720x400"x0.0   28.32  720 738 846 900  400 412 414 449 -hsync +vsync (31.5 kHz e)
[   120.452] (II) NOUVEAU(0): Modeline "1280x1024"x0.0  135.00  1280 1296 1440 1688  1024 1025 1028 1066 +hsync +vsync (80.0 kHz e)
[   120.452] (II) NOUVEAU(0): Modeline "1024x768"x0.0   78.75  1024 1040 1136 1312  768 769 772 800 +hsync +vsync (60.0 kHz e)
[   120.452] (II) NOUVEAU(0): Modeline "1024x768"x0.0   75.00  1024 1048 1184 1328  768 771 777 806 -hsync -vsync (56.5 kHz e)
[   120.452] (II) NOUVEAU(0): Modeline "1024x768"x0.0   65.00  1024 1048 1184 1344  768 771 777 806 -hsync -vsync (48.4 kHz e)
[   120.452] (II) NOUVEAU(0): Modeline "832x624"x0.0   57.28  832 864 928 1152  624 625 628 667 -hsync -vsync (49.7 kHz e)
[   120.452] (II) NOUVEAU(0): Modeline "800x600"x0.0   49.50  800 816 896 1056  600 601 604 625 +hsync +vsync (46.9 kHz e)
[   120.452] (II) NOUVEAU(0): Modeline "800x600"x0.0   50.00  800 856 976 1040  600 637 643 666 +hsync +vsync (48.1 kHz e)
[   120.452] (II) NOUVEAU(0): Modeline "1152x864"x0.0  108.00  1152 1216 1344 1600  864 865 868 900 +hsync +vsync (67.5 kHz e)
[   120.452] (II) NOUVEAU(0): Modeline "1280x800"x0.0   71.00  1280 1328 1360 1440  800 803 809 823 +hsync -vsync (49.3 kHz e)
[   120.452] (II) NOUVEAU(0): Modeline "1280x960"x0.0  108.00  1280 1376 1488 1800  960 961 964 1000 +hsync +vsync (60.0 kHz e)
[   120.452] (II) NOUVEAU(0): Modeline "1280x1024"x0.0  108.00  1280 1328 1440 1688  1024 1025 1028 1066 +hsync +vsync (64.0 kHz e)
[   120.452] (II) NOUVEAU(0): Modeline "1440x900"x0.0   88.75  1440 1488 1520 1600  900 903 909 926 +hsync -vsync (55.5 kHz e)
[   120.452] (II) NOUVEAU(0): Modeline "1600x1200"x0.0  162.00  1600 1664 1856 2160  1200 1201 1204 1250 +hsync +vsync (75.0 kHz e)
[   120.452] (II) NOUVEAU(0): Modeline "1680x1050"x0.0  119.00  1680 1728 1760 1840  1050 1053 1059 1080 +hsync -vsync (64.7 kHz e)
[   120.452] (II) NOUVEAU(0): Modeline "1440x900"x0.0  136.75  1440 1536 1688 1936  900 903 909 942 -hsync +vsync (70.6 kHz e)
[   126.549] (II) NOUVEAU(0): EDID vendor "SAM", prod id 1941
[   126.549] (II) NOUVEAU(0): Using hsync ranges from config file
[   126.549] (II) NOUVEAU(0): Using vrefresh ranges from config file
[   126.549] (II) NOUVEAU(0): Printing DDC gathered Modelines:
[   126.549] (II) NOUVEAU(0): Modeline "1920x1080"x0.0  148.50  1920 2008 2052 2200  1080 1084 1089 1125 +hsync +vsync (67.5 kHz eP)
[   126.549] (II) NOUVEAU(0): Modeline "1920x1080"x0.0  148.50  1920 2448 2492 2640  1080 1084 1089 1125 +hsync +vsync (56.2 kHz e)
[   126.549] (II) NOUVEAU(0): Modeline "1280x720"x0.0   74.25  1280 1390 1430 1650  720 725 730 750 +hsync +vsync (45.0 kHz e)
[   126.549] (II) NOUVEAU(0): Modeline "1280x720"x0.0   74.25  1280 1720 1760 1980  720 725 730 750 +hsync +vsync (37.5 kHz e)
[   126.549] (II) NOUVEAU(0): Modeline "720x576"x0.0   27.00  720 732 796 864  576 581 586 625 -hsync -vsync (31.2 kHz e)
[   126.549] (II) NOUVEAU(0): Modeline "720x480"x0.0   27.00  720 736 798 858  480 489 495 525 -hsync -vsync (31.5 kHz e)
[   126.549] (II) NOUVEAU(0): Modeline "800x600"x0.0   40.00  800 840 968 1056  600 601 605 628 +hsync +vsync (37.9 kHz e)
[   126.549] (II) NOUVEAU(0): Modeline "800x600"x0.0   36.00  800 824 896 1024  600 601 603 625 +hsync +vsync (35.2 kHz e)
[   126.549] (II) NOUVEAU(0): Modeline "640x480"x0.0   31.50  640 656 720 840  480 481 484 500 -hsync -vsync (37.5 kHz e)
[   126.549] (II) NOUVEAU(0): Modeline "640x480"x0.0   31.50  640 664 704 832  480 489 492 520 -hsync -vsync (37.9 kHz e)
[   126.549] (II) NOUVEAU(0): Modeline "640x480"x0.0   30.24  640 704 768 864  480 483 486 525 -hsync -vsync (35.0 kHz e)
[   126.549] (II) NOUVEAU(0): Modeline "640x480"x0.0   25.18  640 656 752 800  480 490 492 525 -hsync -vsync (31.5 kHz e)
[   126.549] (II) NOUVEAU(0): Modeline "720x400"x0.0   28.32  720 738 846 900  400 412 414 449 -hsync +vsync (31.5 kHz e)
[   126.549] (II) NOUVEAU(0): Modeline "1280x1024"x0.0  135.00  1280 1296 1440 1688  1024 1025 1028 1066 +hsync +vsync (80.0 kHz e)
[   126.549] (II) NOUVEAU(0): Modeline "1024x768"x0.0   78.75  1024 1040 1136 1312  768 769 772 800 +hsync +vsync (60.0 kHz e)
[   126.549] (II) NOUVEAU(0): Modeline "1024x768"x0.0   75.00  1024 1048 1184 1328  768 771 777 806 -hsync -vsync (56.5 kHz e)
[   126.549] (II) NOUVEAU(0): Modeline "1024x768"x0.0   65.00  1024 1048 1184 1344  768 771 777 806 -hsync -vsync (48.4 kHz e)
[   126.549] (II) NOUVEAU(0): Modeline "832x624"x0.0   57.28  832 864 928 1152  624 625 628 667 -hsync -vsync (49.7 kHz e)
[   126.549] (II) NOUVEAU(0): Modeline "800x600"x0.0   49.50  800 816 896 1056  600 601 604 625 +hsync +vsync (46.9 kHz e)
[   126.549] (II) NOUVEAU(0): Modeline "800x600"x0.0   50.00  800 856 976 1040  600 637 643 666 +hsync +vsync (48.1 kHz e)
[   126.549] (II) NOUVEAU(0): Modeline "1152x864"x0.0  108.00  1152 1216 1344 1600  864 865 868 900 +hsync +vsync (67.5 kHz e)
[   126.549] (II) NOUVEAU(0): Modeline "1280x800"x0.0   71.00  1280 1328 1360 1440  800 803 809 823 +hsync -vsync (49.3 kHz e)
[   126.549] (II) NOUVEAU(0): Modeline "1280x960"x0.0  108.00  1280 1376 1488 1800  960 961 964 1000 +hsync +vsync (60.0 kHz e)
[   126.549] (II) NOUVEAU(0): Modeline "1280x1024"x0.0  108.00  1280 1328 1440 1688  1024 1025 1028 1066 +hsync +vsync (64.0 kHz e)
[   126.549] (II) NOUVEAU(0): Modeline "1440x900"x0.0   88.75  1440 1488 1520 1600  900 903 909 926 +hsync -vsync (55.5 kHz e)
[   126.549] (II) NOUVEAU(0): Modeline "1600x1200"x0.0  162.00  1600 1664 1856 2160  1200 1201 1204 1250 +hsync +vsync (75.0 kHz e)
[   126.549] (II) NOUVEAU(0): Modeline "1680x1050"x0.0  119.00  1680 1728 1760 1840  1050 1053 1059 1080 +hsync -vsync (64.7 kHz e)
[   126.549] (II) NOUVEAU(0): Modeline "1440x900"x0.0  136.75  1440 1536 1688 1936  900 903 909 942 -hsync +vsync (70.6 kHz e)

--------------070107000107040402070200--
