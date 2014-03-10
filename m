Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754071AbaCJQip (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 12:38:45 -0400
Received: from mail-qc0-f171.google.com ([209.85.216.171]:36780 "EHLO
	mail-qc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753409AbaCJQin (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 12:38:43 -0400
MIME-Version: 1.0
In-Reply-To: <1825482.79WA6myBva@grover>
References: <1825482.79WA6myBva@grover>
Date: Mon, 10 Mar 2014 12:38:42 -0400
Message-ID: <CADnq5_Ps61MBXQBSXxetTuyONaU=h0_qtiUaes8XWJwDLCkCVg@mail.gmail.com>
Subject: Re: [BUG] 3.14-rc6 problems with an R7 260X
From: Alex Deucher <alexdeucher@gmail.com>
To: Ed Tomlinson <edt@aei.ca>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Maling list - DRI developers 
	<dri-devel@lists.freedesktop.org>,
        Dave Airlie <airlied@linux.ie>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 10, 2014 at 11:47 AM, Ed Tomlinson <edt@aei.ca> wrote:
> Hi,
>
> I recently added a R7 260X to my system.  While the card works with 3.13 its supposed work much better with 14-rc.
> This is not the case.  My system is unstable without radeon.dpm=0 which was the default in .13.  Here are some extracts
> from the logs of the latest fun with dpm enabled:
>
> with 3.14-rc6 (with an up to date arch, stable X and mesa-git (10.2) mesa 10.1 and 10.0 also show very similar problems.
>
> Mar 10 10:45:04 localhost kernel: [    0.000000] Command line: BOOT_IMAGE=/vmlinuz-linux-mainline root=/dev/sda3 ro console=tty0 verbose
>
> Mar 10 10:45:04 localhost kernel: [    3.258402] [drm] radeon kernel modesetting enabled.
> Mar 10 10:45:04 localhost kernel: [    3.258421] checking generic (e0000000 300000) vs hw (e0000000 10000000)
> Mar 10 10:45:04 localhost kernel: [    3.258422] fb: conflicting fb hw usage radeondrmfb vs VESA VGA - removing generic driver
> Mar 10 10:45:04 localhost kernel: [    3.270529] Console: switching to colour dummy device 80x25
> Mar 10 10:45:04 localhost kernel: [    3.270757] [drm] initializing kernel modesetting (BONAIRE 0x1002:0x6658 0x174B:0xE253).
> Mar 10 10:45:04 localhost kernel: [    3.270781] [drm] register mmio base: 0xF0800000
> Mar 10 10:45:04 localhost kernel: [    3.270782] [drm] register mmio size: 262144
> Mar 10 10:45:04 localhost kernel: [    3.270785] [drm] doorbell mmio base: 0xF0000000
> Mar 10 10:45:04 localhost kernel: [    3.270786] [drm] doorbell mmio size: 8388608
> Mar 10 10:45:04 localhost kernel: [    3.270837] ATOM BIOS: Bonaire
> Mar 10 10:45:04 localhost kernel: [    3.270884] radeon 0000:01:00.0: VRAM: 2048M 0x0000000000000000 - 0x000000007FFFFFFF (2048M used)
> Mar 10 10:45:04 localhost kernel: [    3.270884] radeon 0000:01:00.0: GTT: 1024M 0x0000000080000000 - 0x00000000BFFFFFFF
> Mar 10 10:45:04 localhost kernel: [    3.270885] [drm] Detected VRAM RAM=2048M, BAR=256M
> Mar 10 10:45:04 localhost kernel: [    3.270886] [drm] RAM width 128bits DDR
> Mar 10 10:45:04 localhost kernel: [    3.270925] [TTM] Zone  kernel: Available graphics memory: 8145248 kiB
> Mar 10 10:45:04 localhost kernel: [    3.270926] [TTM] Zone   dma32: Available graphics memory: 2097152 kiB
> Mar 10 10:45:04 localhost kernel: [    3.270927] [TTM] Initializing pool allocator
> Mar 10 10:45:04 localhost kernel: [    3.270929] [TTM] Initializing DMA pool allocator
> Mar 10 10:45:04 localhost kernel: [    3.270940] [drm] radeon: 2048M of VRAM memory ready
> Mar 10 10:45:04 localhost kernel: [    3.270940] [drm] radeon: 1024M of GTT memory ready.
> Mar 10 10:45:04 localhost kernel: [    3.270948] [drm] Loading BONAIRE Microcode
> Mar 10 10:45:04 localhost kernel: [    3.276841] nct6775: Found NCT6776D/F or compatible chip at 0x2e:0x290
> Mar 10 10:45:04 localhost kernel: [    3.280263] [drm] Internal thermal controller with fan control
> Mar 10 10:45:04 localhost kernel: [    3.280294] [drm] probing gen 2 caps for device 8086:c01 = 261ad03/e
> Mar 10 10:45:04 localhost kernel: [    3.286710] [drm] radeon: dpm initialized
> Mar 10 10:45:04 localhost kernel: [    3.288706] [drm] GART: num cpu pages 262144, num gpu pages 262144
> Mar 10 10:45:04 localhost kernel: [    3.289112] [drm] probing gen 2 caps for device 8086:c01 = 261ad03/e
> Mar 10 10:45:04 localhost kernel: [    3.289114] [drm] PCIE gen 3 link speeds already enabled
> Mar 10 10:45:04 localhost kernel: [    3.299762] [drm] PCIE GART of 1024M enabled (table at 0x0000000000277000).
>
> from xorg's log
>
> [    55.320] (II) RADEON(0): Creating default Display subsection in Screen section
>         "Default Screen Section" for depth/fbbpp 24/32
> [    55.320] (==) RADEON(0): Depth 24, (--) framebuffer bpp 32
> [    55.320] (II) RADEON(0): Pixel depth = 24 bits stored in 4 bytes (32 bpp pixmaps)
> [    55.320] (==) RADEON(0): Default visual is TrueColor
> [    55.320] (==) RADEON(0): RGB weight 888
> [    55.320] (II) RADEON(0): Using 8 bits per RGB (8 bit DAC)
> [    55.320] (--) RADEON(0): Chipset: "BONAIRE" (ChipID = 0x6658)
> [    55.320] (II) Loading sub module "dri2"
> [    55.320] (II) LoadModule: "dri2"
> [    55.320] (II) Module "dri2" already built-in
> [    55.320] (II) Loading sub module "glamoregl"
> [    55.320] (II) LoadModule: "glamoregl"
> [    55.320] (II) Loading /usr/lib/xorg/modules/libglamoregl.so
> [    55.320] (II) Module glamoregl: vendor="X.Org Foundation"
> [    55.320]    compiled for 1.15.0, module version = 0.6.0
> [    55.320]    ABI class: X.Org ANSI C Emulation, version 0.4
> [    55.320] (II) glamor: OpenGL accelerated X.org driver based.
> [    55.832] (II) glamor: EGL version 1.4 (DRI2):
> [    55.845] (II) RADEON(0): glamor detected, initialising EGL layer.
> [    55.845] (II) RADEON(0): KMS Color Tiling: disabled
> [    55.845] (II) RADEON(0): KMS Color Tiling 2D: disabled
> [    55.845] (II) RADEON(0): KMS Pageflipping: enabled
> [    55.845] (II) RADEON(0): SwapBuffers wait for vsync: enabled
> [    55.856] (II) RADEON(0): Output DisplayPort-1 has no monitor section
> [    55.858] (II) RADEON(0): Output HDMI-3 has no monitor section
> [    55.861] (II) RADEON(0): Output DVI-0 has no monitor section
> [    55.891] (II) RADEON(0): Output DVI-1 has no monitor section
> [    55.903] (II) RADEON(0): EDID for output DisplayPort-1
> [    55.905] (II) RADEON(0): EDID for output HDMI-3
> [    55.907] (II) RADEON(0): EDID for output DVI-0
> [    55.938] (II) RADEON(0): EDID for output DVI-1
> [    55.938] (II) RADEON(0): Manufacturer: SAM  Model: 2b5  Serial#: 1213542964
> [    55.938] (II) RADEON(0): Year: 2008  Week: 14
> [    55.938] (II) RADEON(0): EDID Version: 1.3
> [    55.938] (II) RADEON(0): Analog Display Input,  Input Voltage Level: 0.700/0.300 V
> [    55.938] (II) RADEON(0): Sync:  Separate  Composite  SyncOnGreen
> [    55.938] (II) RADEON(0): Max Image Size [cm]: horiz.: 52  vert.: 32
> [    55.938] (II) RADEON(0): Gamma: 2.60
> [    55.938] (II) RADEON(0): DPMS capabilities: Off; RGB/Color Display
> [    55.938] (II) RADEON(0): First detailed timing is preferred mode
> [    55.938] (II) RADEON(0): redX: 0.653 redY: 0.337   greenX: 0.295 greenY: 0.607
> [    55.938] (II) RADEON(0): blueX: 0.144 blueY: 0.075   whiteX: 0.312 whiteY: 0.329
> [    55.938] (II) RADEON(0): Supported established timings:Mar 10 10:48:28 localhost systemd[775]: Time has been changed
>
> and from the system log when the fun starts (there is nothing new int the xorg log)
>
> Mar 10 10:48:28 localhost systemd[1]: Time has been changed
> Mar 10 10:48:52 localhost kernel: [  231.782359] radeon 0000:01:00.0: GPU fault detected: 146 0x0aa20804
> Mar 10 10:48:52 localhost kernel: [  231.782361] radeon 0000:01:00.0:   VM_CONTEXT1_PROTECTION_FAULT_ADDR   0x00002F55
> Mar 10 10:48:52 localhost kernel: [  231.782362] radeon 0000:01:00.0:   VM_CONTEXT1_PROTECTION_FAULT_STATUS 0x02008004
> Mar 10 10:48:52 localhost kernel: [  231.782363] VM fault (0x04, vmid 1) at page 12117, read from 'TC0' (0x54433000) (8)
> Mar 10 10:48:52 localhost kernel: [  231.782366] radeon 0000:01:00.0: GPU fault detected: 146 0x0aa20404
> Mar 10 10:48:52 localhost kernel: [  231.782367] radeon 0000:01:00.0:   VM_CONTEXT1_PROTECTION_FAULT_ADDR   0x00000000
> Mar 10 10:48:52 localhost kernel: [  231.782367] radeon 0000:01:00.0:   VM_CONTEXT1_PROTECTION_FAULT_STATUS 0x00000000
> Mar 10 10:48:52 localhost kernel: [  231.782368] VM fault (0x00, vmid 0) at page 0, read from '' (0x00000000) (0)
> Mar 10 10:48:52 localhost kernel: [  231.782374] radeon 0000:01:00.0: GPU fault detected: 146 0x0aa24404
> Mar 10 10:48:52 localhost kernel: [  231.782374] radeon 0000:01:00.0:   VM_CONTEXT1_PROTECTION_FAULT_ADDR   0x00002F55
> Mar 10 10:48:52 localhost kernel: [  231.782375] radeon 0000:01:00.0:   VM_CONTEXT1_PROTECTION_FAULT_STATUS 0x02044004
> Mar 10 10:48:52 localhost kernel: [  231.782376] VM fault (0x04, vmid 1) at page 12117, read from 'TC3' (0x54433300) (68)
> Mar 10 10:48:52 localhost kernel: [  231.782378] radeon 0000:01:00.0: GPU fault detected: 146 0x0aa24804
> Mar 10 10:48:52 localhost kernel: [  231.782379] radeon 0000:01:00.0:   VM_CONTEXT1_PROTECTION_FAULT_ADDR   0x00000000
> Mar 10 10:48:52 localhost kernel: [  231.782379] radeon 0000:01:00.0:   VM_CONTEXT1_PROTECTION_FAULT_STATUS 0x00000000
> Mar 10 10:48:52 localhost kernel: [  231.782380] VM fault (0x00, vmid 0) at page 0, read from '' (0x00000000) (0)
> Mar 10 10:48:52 localhost kernel: [  231.782382] radeon 0000:01:00.0: GPU fault detected: 146 0x0aa24804
> Mar 10 10:48:52 localhost kernel: [  231.782383] radeon 0000:01:00.0:   VM_CONTEXT1_PROTECTION_FAULT_ADDR   0x00000000
> Mar 10 10:48:52 localhost kernel: [  231.782383] radeon 0000:01:00.0:   VM_CONTEXT1_PROTECTION_FAULT_STATUS 0x00000000
> Mar 10 10:48:52 localhost kernel: [  231.782384] VM fault (0x00, vmid 0) at page 0, read from '' (0x00000000) (0)
> Mar 10 10:48:52 localhost kernel: [  231.782386] radeon 0000:01:00.0: GPU fault detected: 146 0x0aa20804
> Mar 10 10:48:52 localhost kernel: [  231.782387] radeon 0000:01:00.0:   VM_CONTEXT1_PROTECTION_FAULT_ADDR   0x00000000
> Mar 10 10:48:52 localhost kernel: [  231.782388] radeon 0000:01:00.0:   VM_CONTEXT1_PROTECTION_FAULT_STATUS 0x00000000
> Mar 10 10:48:52 localhost kernel: [  231.782388] VM fault (0x00, vmid 0) at page 0, read from '' (0x00000000) (0)
> Mar 10 10:48:52 localhost kernel: [  231.782391] radeon 0000:01:00.0: GPU fault detected: 146 0x0aa20404
> Mar 10 10:48:52 localhost kernel: [  231.782391] radeon 0000:01:00.0:   VM_CONTEXT1_PROTECTION_FAULT_ADDR   0x00000000
> Mar 10 10:48:52 localhost kernel: [  231.782392] radeon 0000:01:00.0:   VM_CONTEXT1_PROTECTION_FAULT_STATUS 0x00000000
> Mar 10 10:48:52 localhost kernel: [  231.782392] VM fault (0x00, vmid 0) at page 0, read from '' (0x00000000) (0)
> Mar 10 10:48:52 localhost kernel: [  231.782398] radeon 0000:01:00.0: GPU fault detected: 146 0x0aa24404
> Mar 10 10:48:52 localhost kernel: [  231.782399] radeon 0000:01:00.0:   VM_CONTEXT1_PROTECTION_FAULT_ADDR   0x00000000
> Mar 10 10:48:52 localhost kernel: [  231.782399] radeon 0000:01:00.0:   VM_CONTEXT1_PROTECTION_FAULT_STATUS 0x00000000
>
> The above type of errors repeat hundreds of times and eventually the display freezes (this box does not have a serial console and it did not check with ssh)
>
> When X started I did notice some corruption.  There are sets of two rectangles about of a height of 2 or 3 mm, width of 25m or so with a second
> about a cm below.  The often occurs in chomium especially when scrolling.  Runing the  unigine-sanctuary or unigine-tropics demo/benchmark
> programs also produce the above problems and eventually stall.
>
> The problem is reproducible - I am not that familiar with gpu problems though, what else will help debug this?
>

Please file a bug at https://bugs.freedesktop.org (Product: DRI,
Component: DRM/Radeon) and attach your dmesg output and xorg log.

Alex
