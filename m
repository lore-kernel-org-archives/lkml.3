Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758575Ab3CYOzE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 10:55:04 -0400
Received: from mx.scalarmail.ca ([98.158.95.75]:42066 "EHLO
	ironport-01.sms.scalar.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758522Ab3CYOy7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 10:54:59 -0400
X-Greylist: delayed 570 seconds by postgrey-1.27 at vger.kernel.org; Mon, 25 Mar 2013 10:54:59 EDT
Date: Mon, 25 Mar 2013 10:45:24 -0400
From: Nick Bowler <nbowler@elliptictech.com>
To: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: Black screen with nouveau in 3.8.x (regression)
Message-ID: <20130325144524.GA3735@elliptictech.com>
References: <20130307150618.GA31832@elliptictech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130307150618.GA31832@elliptictech.com>
Organization: Elliptic Technologies Inc.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ping?

On 2013-03-07 10:06 -0500, Nick Bowler wrote:
> Yesterday I upgraded one of my machines to 3.8.2 from 3.6.6.  This
> machine has an old NV36 AGP board.  With the new kernel, as soon as
> nouveau takes over the console the display connected via DVI goes dark
> (the monitor goes into standby mode).  The display connected via VGA
> continues to work fine.
> 
> Starting Xorg does not correct the problem.  Nouveau seems to know
> that the display is connected:
> 
>   % cat /sys/class/drm/card0-DVI-I-1/status
>   connected
> 
> I don't see anything unusual in the log either (full log attached):
> 
>   % dmesg -t | grep -iE 'drm|nouveau'
>   [drm] Initialized drm 1.1.0 20060810
>   nouveau  [  DEVICE][0000:01:00.0] BOOT0  : 0x436200a1
>   nouveau  [  DEVICE][0000:01:00.0] Chipset: NV36 (NV36)
>   nouveau  [  DEVICE][0000:01:00.0] Family : NV30
>   nouveau  [   VBIOS][0000:01:00.0] checking PRAMIN for image...
>   nouveau  [   VBIOS][0000:01:00.0] ... appears to be valid
>   nouveau  [   VBIOS][0000:01:00.0] using image from PRAMIN
>   nouveau  [   VBIOS][0000:01:00.0] BMP version 5.28
>   nouveau  [   VBIOS][0000:01:00.0] version 04.36.20.21
>   nouveau W[  PTIMER][0000:01:00.0] unknown input clock freq
>   nouveau  [     PFB][0000:01:00.0] RAM type: DDR1
>   nouveau  [     PFB][0000:01:00.0] RAM size: 256 MiB
>   nouveau 0000:01:00.0: putting AGP V3 device into 8x mode
>   nouveau  [     DRM] VRAM: 255 MiB
>   nouveau  [     DRM] GART: 64 MiB
>   nouveau  [     DRM] BMP BIOS found
>   nouveau  [     DRM] BMP version 5.40
>   nouveau  [     DRM] Bios version 04.36.20.21
>   nouveau  [     DRM] DCB version 2.2
>   nouveau  [     DRM] DCB outp 00: 01000300 00009c40
>   nouveau  [     DRM] DCB outp 01: 02010310 00009c40
>   nouveau  [     DRM] DCB outp 02: 04000302 00000000
>   nouveau  [     DRM] DCB outp 03: 02020321 00000303
>   nouveau  [     DRM] Loading NV17 power sequencing microcode
>   nouveau  [     DRM] Saving VGA fonts
>   [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
>   [drm] No driver support for vblank timestamp query.
>   nouveau  [     DRM] 0xE51A: Parsing digital output script table
>   nouveau  [     DRM] 0 available performance level(s)
>   nouveau  [     DRM] c: core 425MHz memory 501MHz voltage 1350mV
>   nouveau  [     DRM] MM: using M2MF for buffer copies
>   nouveau  [     DRM] Setting dpms mode 3 on vga encoder (output 0)
>   nouveau  [     DRM] Setting dpms mode 3 on vga encoder (output 1)
>   nouveau  [     DRM] Setting dpms mode 3 on tmds encoder (output 2)
>   nouveau  [     DRM] Setting dpms mode 3 on TV encoder (output 3)
>   nouveau  [     DRM] allocated 1280x1024 fb: 0x9000, bo ffff88007b6ae000
>   fbcon: nouveaufb (fb0) is primary device
>   nouveau  [     DRM] 0xE51A: Parsing digital output script table
>   nouveau  [     DRM] Setting dpms mode 0 on tmds encoder (output 2)
>   nouveau  [     DRM] Output DVI-I-1 is running on CRTC 0 using output C
>   nouveau  [     DRM] Setting dpms mode 0 on vga encoder (output 1)
>   nouveau  [     DRM] Output VGA-1 is running on CRTC 1 using output B
>   fb0: nouveaufb frame buffer device
>   drm: registered panic notifier
>   [drm] Initialized nouveau 1.1.0 20120801 for 0000:01:00.0 on minor 0
> 
> I started a bisection... here's the first steps so far.  I will try to
> finish the procedure over the next couple days but I'm reporting this
> now in case someone needs me to get some other info.
[...]

On 2013-03-08 09:28 -0500, Nick Bowler wrote:
> I carried this on a bit further, but it seems that most of the remaining
> commits bisect wants to test do not compile, so there is a huge number
> of skipped commits.  Not exactly a lot of fun...
> 
> git bisect start 'drivers/gpu/drm'
> # good: [3820288942d1c1524c3ee85cbf503fee1533cfc3] Linux 3.6.6
> git bisect good 3820288942d1c1524c3ee85cbf503fee1533cfc3
> # bad: [19b00d2dc9bedf0856e366cb7b9c7733ded659e4] Linux 3.8.2
> git bisect bad 19b00d2dc9bedf0856e366cb7b9c7733ded659e4
> # good: [a0d271cbfed1dd50278c6b06bead3d00ba0a88f9] Linux 3.6
> git bisect good a0d271cbfed1dd50278c6b06bead3d00ba0a88f9
> # bad: [daed2dbb7ea4d179e472396ce46377fe758d5faf] drm/i915: use the CPU and PCH transcoders on lpt_pch_enable
> git bisect bad daed2dbb7ea4d179e472396ce46377fe758d5faf
> # good: [df86b5765a48d5f557489577652bd6df145b0e1b] drm/savage: re-add busmaster enable, regression fix
> git bisect good df86b5765a48d5f557489577652bd6df145b0e1b
> # bad: [39df01cd6ce9f6dd755ace0030e2bebe75da7727] Merge branch 'drm-fixes-3.7' of git://people.freedesktop.org/~agd5f/linux into drm-fixes
> git bisect bad 39df01cd6ce9f6dd755ace0030e2bebe75da7727
> # bad: [b9f10852fcb1f09369d931dcbfbaad89ad1da4ad] drm/nv98/crypt: fix fuc build with latest envyas
> git bisect bad b9f10852fcb1f09369d931dcbfbaad89ad1da4ad
> # bad: [b10f20d590aa040e4028c04a70a27b9ad6650ba8] drm/nvc0-/gr: remove reset-after-grctx-construction hack
> git bisect bad b10f20d590aa040e4028c04a70a27b9ad6650ba8
> # skip: [18c9b959fd8ea6f3602efbedad788f53e305e6f1] drm/nouveau/gpuobj: create wrapper functions for mapping gpuobj into vm/bar
> git bisect skip 18c9b959fd8ea6f3602efbedad788f53e305e6f1
> # skip: [092599da308bf56b96c849ecdd315b8a1a13ca52] drm/nv50/instmem: remove use of nouveau_gpuobj_new_fake()
> git bisect skip 092599da308bf56b96c849ecdd315b8a1a13ca52
> # skip: [4196faa8623264b79279a06fd186654c959f2767] drm/nouveau/i2c: port to subdev interfaces
> git bisect skip 4196faa8623264b79279a06fd186654c959f2767
> # skip: [9da226f698c01b268b9172050df4150f269a7613] drm/nvc0/fifo: handle bar1 control regs much like fifo/nve0
> git bisect skip 9da226f698c01b268b9172050df4150f269a7613
> # skip: [8aceb7de47ea2491abc1a577dc875b19e9947a54] drm/nouveau/clk: implement stub clock subdev
> git bisect skip 8aceb7de47ea2491abc1a577dc875b19e9947a54
> # skip: [70ee6f1cd6911098ddd4c11ee21b69dbe51fb3f9] drm/nv04-nv40/fifo: remove use of nouveau_gpuobj_new_fake()
> git bisect skip 70ee6f1cd6911098ddd4c11ee21b69dbe51fb3f9
> # skip: [f589be88caf32501a734e531180d5df5d6089ef3] drm/nouveau/pageflip: kick flip handling out of engsw and into fence
> git bisect skip f589be88caf32501a734e531180d5df5d6089ef3
> # skip: [73a60c0d218a292f8ef29d3467726ff26ed366fc] drm/nouveau/gpuobj: remove flags for vm-mappings
> git bisect skip 73a60c0d218a292f8ef29d3467726ff26ed366fc
> # skip: [70790f4f819875e8f390871fd15bbbf823f28e1b] drm/nouveau/clock: pull in the implementation from all over the place
> git bisect skip 70790f4f819875e8f390871fd15bbbf823f28e1b
> # skip: [5787640db6ae722aeadb394d480c7ca21b603e34] drm/nv04-nv40/instmem: remove use of nouveau_gpuobj_new_fake()
> git bisect skip 5787640db6ae722aeadb394d480c7ca21b603e34
> # skip: [cb75d97e9c77743ecfcc43375be135a55a4d9b25] drm/nouveau: implement devinit subdev, and new init table parser
> git bisect skip cb75d97e9c77743ecfcc43375be135a55a4d9b25
> # skip: [8a9b889e668a5bc2f4031015fe4893005c43403d] drm/nouveau: remove last use of nouveau_gpuobj_new_fake()
> git bisect skip 8a9b889e668a5bc2f4031015fe4893005c43403d
> # skip: [a73c5c526a8a39b2e61709c753d44be597c9a4c0] drm/nvc0-nve0/graph: rename dev to priv, no code changes
> git bisect skip a73c5c526a8a39b2e61709c753d44be597c9a4c0
> # good: [d6ba6d215a538a58f0f0026f0961b0b9125e8042] drm/nvc0/fence: restore pre-suspend fence buffer context on resume
> git bisect good d6ba6d215a538a58f0f0026f0961b0b9125e8042
> # skip: [7d9115dee978e8540734c456c925d71a37752b8d] drm/nouveau/mc: port to subdev interfaces
> git bisect skip 7d9115dee978e8540734c456c925d71a37752b8d
> # good: [3a92d37e4099054fe187b485a9d27c439c10eca7] drm/nouveau/gem: use bo.offset rather than mm_node.start
> git bisect good 3a92d37e4099054fe187b485a9d27c439c10eca7
> # skip: [5a5c7432bbbd2e318dff107b4ff960ab543a7cef] drm/nouveau/timer: port to subdev interfaces
> git bisect skip 5a5c7432bbbd2e318dff107b4ff960ab543a7cef
> # bad: [77145f1cbdf8d28b46ff8070ca749bad821e0774] drm/nouveau: port remainder of drm code, and rip out compat layer
> git bisect bad 77145f1cbdf8d28b46ff8070ca749bad821e0774
> # skip: [51a3d3425663698a79e8a9d01998a8a32ddee13b] drm/nouveau/backlight: remove dependence on nouveau_drv.h
> git bisect skip 51a3d3425663698a79e8a9d01998a8a32ddee13b

Thanks,
-- 
Nick Bowler, Elliptic Technologies (http://www.elliptictech.com/)
