Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758712Ab3LFOOF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 09:14:05 -0500
Received: from infra.glanzmann.de ([78.47.70.69]:55311 "EHLO
	infra.glanzmann.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758110Ab3LFON6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 09:13:58 -0500
Date: Fri, 6 Dec 2013 15:13:56 +0100
From: Thomas Glanzmann <thomas@glanzmann.de>
To: Ilia Mirkin <imirkin@alum.mit.edu>
Cc: Ben Skeggs <bskeggs@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        "nouveau@lists.freedesktop.org" <nouveau@lists.freedesktop.org>
Subject: Re: Regression: drm/nouveau/clk: implement power state and engine
 clock control in core (7c856522069755ab9d163a24ac332cd3cb35fe30) breaks
 GeForce 9400 on Intel Mac Mini Model November 2010 model
Message-ID: <20131206141356.GA27793@glanzmann.de>
Mail-Followup-To: Thomas Glanzmann <thomas@glanzmann.de>,
	Ilia Mirkin <imirkin@alum.mit.edu>, Ben Skeggs <bskeggs@redhat.com>,
	LKML <linux-kernel@vger.kernel.org>,
	"nouveau@lists.freedesktop.org" <nouveau@lists.freedesktop.org>
References: <20131206074455.GB21029@glanzmann.de>
 <CAKb7Uvht8=ydSgCe-mKpoR3LRvf1KJw2_CAV_0zeh2t4nt9nww@mail.gmail.com>
 <20131206133015.GA27211@glanzmann.de>
 <CAKb7UvhgboLR_w_15dk+t_s3EkJDgHQgN5ASfAOvJJ-ACfrRuw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKb7UvhgboLR_w_15dk+t_s3EkJDgHQgN5ASfAOvJJ-ACfrRuw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Ilia,

> >   CC [M]  drivers/gpu/drm/nouveau/core/subdev/clock/nvaa.o
> > drivers/gpu/drm/nouveau/core/subdev/clock/nvaa.c:478:8: error: redefinition of 'struct nvaa_clock_priv'

> Something very funny happened. Are you sure you applied the patch
> correctly? The file should only be 445 lines long, I'm guessing you
> double-applied it?

probably I did. I checked out Linux tip again and applied the patch on
top of it and rebuild. Funny that it applied twice. ;-)

Now it works:

[    7.060467] [drm] hdmi device  not found 2 0 1
[    7.060645] nouveau  [  DEVICE][0000:02:00.0] BOOT0  : 0x0ac080b1
[    7.060708] nouveau  [  DEVICE][0000:02:00.0] Chipset: MCP79/MCP7A (NVAC)
[    7.060775] nouveau  [  DEVICE][0000:02:00.0] Family : NV50
[    7.062211] nouveau  [   VBIOS][0000:02:00.0] checking PRAMIN for image...
[    7.124272] nouveau  [   VBIOS][0000:02:00.0] ... appears to be valid
[    7.124344] nouveau  [   VBIOS][0000:02:00.0] using image from PRAMIN
[    7.124655] nouveau  [   VBIOS][0000:02:00.0] BIT signature found
[    7.124719] nouveau  [   VBIOS][0000:02:00.0] version 62.79.4e.00.01
[    7.146799] nouveau  [     PMC][0000:02:00.0] MSI interrupts enabled
[    7.146907] nouveau  [     PFB][0000:02:00.0] RAM type: stolen system memory
[    7.146971] nouveau  [     PFB][0000:02:00.0] RAM size: 256 MiB
[    7.147037] nouveau  [     PFB][0000:02:00.0]    ZCOMP: 0 tags
[    7.178002] nouveau  [  PTHERM][0000:02:00.0] FAN control: none / external
[    7.178093] nouveau  [  PTHERM][0000:02:00.0] fan management: automatic
[    7.178157] nouveau  [  PTHERM][0000:02:00.0] internal sensor: yes
[    7.178242] nouveau  [     CLK][0000:02:00.0] 03: core 150 MHz shader 300 MHz vdec 150 MHz
[    7.178318] nouveau  [     CLK][0000:02:00.0] 05: core 150 MHz shader 300 MHz vdec 150 MHz
[    7.178397] nouveau  [     CLK][0000:02:00.0] 0e: core 350 MHz shader 800 MHz vdec 350 MHz
[    7.178472] nouveau  [     CLK][0000:02:00.0] 0f: core 450 MHz shader 1100 MHz vdec 450 MHz
[    7.178565] nouveau  [     CLK][0000:02:00.0] --: core 350 MHz shader 800 MHz vdec 350 MHz
[    7.178939] [TTM] Zone  kernel: Available graphics memory: 1887714 kiB
[    7.179004] [TTM] Initializing pool allocator
[    7.179076] [TTM] Initializing DMA pool allocator
[    7.179150] nouveau  [     DRM] VRAM: 256 MiB
[    7.179211] nouveau  [     DRM] GART: 1048576 MiB
[    7.179279] nouveau  [     DRM] TMDS table version 2.0
[    7.179340] nouveau  [     DRM] DCB version 4.0
[    7.179405] nouveau  [     DRM] DCB outp 00: 02021286 0f220010
[    7.179467] nouveau  [     DRM] DCB outp 01: 01000122 00000010
[    7.179533] nouveau  [     DRM] DCB outp 02: 01000120 0000001e
[    7.179592] nouveau  [     DRM] DCB outp 03: 02021232 00000010
[    7.179657] nouveau  [     DRM] DCB conn 00: 00001020
[    7.179766] nouveau  [     DRM] DCB conn 01: 0000a146
[    7.179876] nouveau  [     DRM] DCB conn 02: 00005246
[    7.190038] nouveau W[     DRM] unknown connector type 20
[    7.190163] [drm] Supports vblank timestamp caching Rev 2 (21.10.2013).
[    7.190227] [drm] No driver support for vblank timestamp query.
[    7.203767] nouveau  [     DRM] MM: using M2MF for buffer copies
[    7.223049] usb 3-5: New USB device found, idVendor=05ac, idProduct=8242
[    7.223133] usb 3-5: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    7.223217] usb 3-5: Product: IR Receiver
[    7.223290] usb 3-5: Manufacturer: Apple Computer, Inc.
[    7.294016] nouveau  [     DRM] allocated 1920x1200 fb: 0x50000, bo ffff88013a5b8000
[    7.295068] fbcon: nouveaufb (fb0) is primary device
[    7.362022] Console: switching to colour frame buffer device 240x75
[    7.366083] nouveau 0000:02:00.0: fb0: nouveaufb frame buffer device
[    7.366099] nouveau 0000:02:00.0: registered panic notifier
[    7.366136] [drm] Initialized nouveau 1.1.1 20120801 for 0000:02:00.0 on minor 0

> It's in Dave Airlie's drm-fixes branch, which should get submitted to
> 3.13 at some point.

Perfect.

> This boot log is from a kernel that does not include any of nouveau's
> v3.13 changes. (See how it says "performance levels", and it's printed
> under [DRM]... the new kernel should say [CLK] and the output format
> is different.)

I was also wondering why it was telling me that this is v3.8 so I
probably used the wrong branch.

Thanks again. Btw. Yesterday I already bisected the problem and always
booted the same kernel. So I had to repeat the bisecting this morning.
40 Kernels later I had identified the commit. And the Mac Mini takes an
awful long time to boot. And the core duo is also not the fastet CPU
around.

Cheers,
        Thomas
