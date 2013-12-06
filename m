Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758605Ab3LFNid (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 08:38:33 -0500
Received: from mail-ob0-f172.google.com ([209.85.214.172]:33178 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758531Ab3LFNi3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 08:38:29 -0500
MIME-Version: 1.0
In-Reply-To: <20131206133015.GA27211@glanzmann.de>
References: <20131206074455.GB21029@glanzmann.de>
	<CAKb7Uvht8=ydSgCe-mKpoR3LRvf1KJw2_CAV_0zeh2t4nt9nww@mail.gmail.com>
	<20131206133015.GA27211@glanzmann.de>
Date: Fri, 6 Dec 2013 08:38:28 -0500
X-Google-Sender-Auth: dqCMOuU_K6T7AcjEyeqGbAPMYpk
Message-ID: <CAKb7UvhgboLR_w_15dk+t_s3EkJDgHQgN5ASfAOvJJ-ACfrRuw@mail.gmail.com>
Subject: Re: Regression: drm/nouveau/clk: implement power state and engine
 clock control in core (7c856522069755ab9d163a24ac332cd3cb35fe30) breaks
 GeForce 9400 on Intel Mac Mini Model November 2010 model
From: Ilia Mirkin <imirkin@alum.mit.edu>
To: Thomas Glanzmann <thomas@glanzmann.de>, Ilia Mirkin <imirkin@alum.mit.edu>,
        Ben Skeggs <bskeggs@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        "nouveau@lists.freedesktop.org" <nouveau@lists.freedesktop.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 6, 2013 at 8:30 AM, Thomas Glanzmann <thomas@glanzmann.de> wrote:
> Hello Ilia,
>
>> > [    7.569394] nouveau  [  DEVICE][0000:02:00.0] BOOT0  : 0x0ac080b1
>> > [    7.569460] nouveau  [  DEVICE][0000:02:00.0] Chipset: MCP79/MCP7A (NVAC)
>> > [    7.569530] nouveau  [  DEVICE][0000:02:00.0] Family : NV50
>> > [    7.571151] nouveau  [   VBIOS][0000:02:00.0] checking PRAMIN for image...
>> > [    7.633082] nouveau  [   VBIOS][0000:02:00.0] ... appears to be valid
>> > [    7.633155] nouveau  [   VBIOS][0000:02:00.0] using image from PRAMIN
>> > [    7.633468] nouveau  [   VBIOS][0000:02:00.0] BIT signature found
>> > [    7.633533] nouveau  [   VBIOS][0000:02:00.0] version 62.79.4e.00.01
>> > [    7.654309] nouveau  [     PMC][0000:02:00.0] MSI interrupts enabled
>> > [    7.654417] nouveau  [     PFB][0000:02:00.0] RAM type: stolen system memory
>> > [    7.654481] nouveau  [     PFB][0000:02:00.0] RAM size: 256 MiB
>> > [    7.654546] nouveau  [     PFB][0000:02:00.0]    ZCOMP: 0 tags
>> > [    7.687282] nouveau  [  PTHERM][0000:02:00.0] FAN control: none / external
>> > [    7.687366] nouveau  [  PTHERM][0000:02:00.0] fan management: automatic
>> > [    7.687429] nouveau  [  PTHERM][0000:02:00.0] internal sensor: yes
>> > [    7.687500] nouveau  [     CLK][0000:02:00.0] 03: core 150 MHz shader 300 MHz
>> > [    7.687575] nouveau  [     CLK][0000:02:00.0] 05: core 150 MHz shader 300 MHz
>> > [    7.687648] nouveau  [     CLK][0000:02:00.0] 0e: core 350 MHz shader 800 MHz
>> > [    7.687721] nouveau  [     CLK][0000:02:00.0] 0f: core 450 MHz shader 1100 MHz
>> > [    7.687806] nouveau E[     CLK][0000:02:00.0] 17 freq unknown
>> > [    7.687867] nouveau E[     CLK][0000:02:00.0] init failed, -22
>
>> http://lists.freedesktop.org/archives/nouveau/2013-December/015304.html
>
> thank you. I tried to cherry pick this patch on top of Linux tip, but
> was not able to:
>
>   CC [M]  drivers/gpu/drm/nouveau/core/subdev/clock/nvaa.o
> drivers/gpu/drm/nouveau/core/subdev/clock/nvaa.c:478:8: error: redefinition of 'struct nvaa_clock_priv'

Something very funny happened. Are you sure you applied the patch
correctly? The file should only be 445 lines long, I'm guessing you
double-applied it?

> drivers/gpu/drm/nouveau/core/subdev/clock/nvaa.c:33:8: note: originally defined here
> drivers/gpu/drm/nouveau/core/subdev/clock/nvaa.c:488:1: error: redefinition of 'read_div'
> drivers/gpu/drm/nouveau/core/subdev/clock/nvaa.c:43:1: note: previous definition of 'read_div' was here
> drivers/gpu/drm/nouveau/core/subdev/clock/nvaa.c:494:1: error: redefinition of 'read_pll'
> drivers/gpu/drm/nouveau/core/subdev/clock/nvaa.c:49:1: note: previous definition of 'read_pll' was here
> drivers/gpu/drm/nouveau/core/subdev/clock/nvaa.c:525:1: error: redefinition of 'nvaa_clock_read'
> drivers/gpu/drm/nouveau/core/subdev/clock/nvaa.c:80:1: note: previous definition of 'nvaa_clock_read' was here
> drivers/gpu/drm/nouveau/core/subdev/clock/nvaa.c:607:1: error: conflicting types for 'calc_pll'
> drivers/gpu/drm/nouveau/core/subdev/clock/nvaa.c:162:1: note: previous definition of 'calc_pll' was here
> drivers/gpu/drm/nouveau/core/subdev/clock/nvaa.c:628:1: error: redefinition of 'calc_P'
> drivers/gpu/drm/nouveau/core/subdev/clock/nvaa.c:183:1: note: previous definition of 'calc_P' was here
> drivers/gpu/drm/nouveau/core/subdev/clock/nvaa.c:646:1: error: redefinition of 'nvaa_clock_calc'
> drivers/gpu/drm/nouveau/core/subdev/clock/nvaa.c:201:1: note: previous definition of 'nvaa_clock_calc' was here
> drivers/gpu/drm/nouveau/core/subdev/clock/nvaa.c:744:1: error: redefinition of 'nvaa_clock_prog'
> drivers/gpu/drm/nouveau/core/subdev/clock/nvaa.c:299:1: note: previous definition of 'nvaa_clock_prog' was here
> drivers/gpu/drm/nouveau/core/subdev/clock/nvaa.c:847:1: error: redefinition of 'nvaa_clock_tidy'
> drivers/gpu/drm/nouveau/core/subdev/clock/nvaa.c:402:1: note: previous definition of 'nvaa_clock_tidy' was here
> drivers/gpu/drm/nouveau/core/subdev/clock/nvaa.c:852:1: error: redefinition of 'nvaa_domains'
> drivers/gpu/drm/nouveau/core/subdev/clock/nvaa.c:407:1: note: previous definition of 'nvaa_domains' was here
> drivers/gpu/drm/nouveau/core/subdev/clock/nvaa.c:862:1: error: redefinition of 'nvaa_clock_ctor'
> drivers/gpu/drm/nouveau/core/subdev/clock/nvaa.c:417:1: note: previous definition of 'nvaa_clock_ctor' was here
> drivers/gpu/drm/nouveau/core/subdev/clock/nvaa.c:882:1: error: redefinition of 'nvaa_clock_oclass'
> drivers/gpu/drm/nouveau/core/subdev/clock/nvaa.c:437:1: note: previous definition of 'nvaa_clock_oclass' was here
> make[4]: *** [drivers/gpu/drm/nouveau/core/subdev/clock/nvaa.o] Error 1
> make[3]: *** [drivers/gpu/drm/nouveau] Error 2
> make[2]: *** [drivers/gpu/drm] Error 2
> make[1]: *** [drivers/gpu] Error 2
> make: *** [drivers] Error 2
>
> Probably I'm missing a dependency.
>
> Than I checked out drm-nouveau-next of
> git://anongit.freedesktop.org/nouveau/linux-2.6 and tried again. This time it

It's in Dave Airlie's drm-fixes branch, which should get submitted to
3.13 at some point.

> worked. Thank you. Will the fix wander to upstream before v3.13?
> Otherwise I would appreciate a heads-up when it wanders upstream, so
> that I can test again.
>
> [    7.964230] nouveau  [  DEVICE][0000:02:00.0] BOOT0  : 0x0ac080b1
> [    7.964232] nouveau  [  DEVICE][0000:02:00.0] Chipset: MCP79/MCP7A (NVAC)
> [    7.964233] nouveau  [  DEVICE][0000:02:00.0] Family : NV50
> [    7.965828] nouveau  [   VBIOS][0000:02:00.0] checking PRAMIN for image...
> [    8.027695] nouveau  [   VBIOS][0000:02:00.0] ... appears to be valid
> [    8.027769] nouveau  [   VBIOS][0000:02:00.0] using image from PRAMIN
> [    8.028070] nouveau  [   VBIOS][0000:02:00.0] BIT signature found
> [    8.028134] nouveau  [   VBIOS][0000:02:00.0] version 62.79.4e.00.01
> [    8.061976] nouveau  [     PFB][0000:02:00.0] RAM type: stolen system memory
> [    8.062051] nouveau  [     PFB][0000:02:00.0] RAM size: 256 MiB
> [    8.062122] nouveau  [     PFB][0000:02:00.0]    ZCOMP: 0 tags
> [    8.086562] [TTM] Zone  kernel: Available graphics memory: 1887908 kiB
> [    8.086633] [TTM] Initializing pool allocator
> [    8.086707] [TTM] Initializing DMA pool allocator
> [    8.088703] nouveau  [     DRM] VRAM: 256 MiB
> [    8.088774] nouveau  [     DRM] GART: 512 MiB
> [    8.088843] nouveau  [     DRM] BIT BIOS found
> [    8.088902] nouveau  [     DRM] Bios version 62.79.4e.00
> [    8.088969] nouveau  [     DRM] TMDS table version 2.0
> [    8.089030] nouveau  [     DRM] DCB version 4.0
> [    8.089096] nouveau  [     DRM] DCB outp 00: 02021286 0f220010
> [    8.089157] nouveau  [     DRM] DCB outp 01: 01000122 00000010
> [    8.089222] nouveau  [     DRM] DCB outp 02: 01000120 0000001e
> [    8.089283] nouveau  [     DRM] DCB outp 03: 02021232 00000010
> [    8.089349] nouveau  [     DRM] DCB conn 00: 00001020
> [    8.089459] nouveau  [     DRM] DCB conn 01: 0000a146
> [    8.089565] nouveau  [     DRM] DCB conn 02: 00005246
> [    8.099341] nouveau W[     DRM] unknown connector type 20
> [    8.100025] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
> [    8.100090] [drm] No driver support for vblank timestamp query.
> [    8.300673] nouveau  [     DRM] 4 available performance level(s)
> [    8.300759] nouveau  [     DRM] 0: core 150MHz shader 300MHz voltage 900mV fanspeed 100%
> [    8.300839] nouveau  [     DRM] 1: core 150MHz shader 300MHz voltage 900mV fanspeed 100%
> [    8.300921] nouveau  [     DRM] 2: core 350MHz shader 800MHz voltage 900mV fanspeed 100%
> [    8.301001] nouveau  [     DRM] 3: core 450MHz shader 1100MHz voltage 1010mV fanspeed 100%
> [    8.301080] nouveau  [     DRM] c:
> [    8.325812] nouveau  [     DRM] MM: using M2MF for buffer copies

This boot log is from a kernel that does not include any of nouveau's
v3.13 changes. (See how it says "performance levels", and it's printed
under [DRM]... the new kernel should say [CLK] and the output format
is different.)

  -ilia
