Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753970Ab3AMA60 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2013 19:58:26 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:64372 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751756Ab3AMA6Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2013 19:58:24 -0500
MIME-Version: 1.0
Date: Sat, 12 Jan 2013 19:58:22 -0500
X-Google-Sender-Auth: D143SFmiTHtkscr-EXjk8A10TJk
Message-ID: <CAKb7UvhR5+qO1q9k6uaYeyBPJy4dCbTJ1J0g1NoGzaiH5Fn8aA@mail.gmail.com>
Subject: Nouveau hang on 3.6.11
From: Ilia Mirkin <imirkin@alum.mit.edu>
To: linux-kernel@vger.kernel.org
Cc: bskeggs@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I recently upgraded to 3.6.11, and just saw this hang for the first
time. It happened within a minute of the monitor going to sleep (which
in turn coincides with a non-GL screensaver running). It should be
noted that Chrome is running with --ignore-gpu-blacklist, but I've
been doing that for quite a while. I know that there's perf stuff in
the NMI trace, but I was not (knowingly) running perf at the time. The
CPU is an Intel Core i7-920, the video card is a NVIDIA Corporation
G96 [GeForce 9500 GT] [10de:0640] (rev a1).

I can upgrade to the latest kernel if necessary, but this is the first
time I've seen this so I have no reliable way of triggering it.

Messages on boot:

[    4.339304] [drm] Initialized drm 1.1.0 20060810
[    4.355779] MXM: GUID detected in BIOS
[    4.356203] [drm] nouveau 0000:02:00.0: Detected an NV50 generation
card (0x096000c1)
[    4.359084] [drm] nouveau 0000:02:00.0: Checking PRAMIN for VBIOS
[    4.418932] [drm] nouveau 0000:02:00.0: ... appears to be valid
[    4.418934] [drm] nouveau 0000:02:00.0: Using VBIOS from PRAMIN
[    4.418937] [drm] nouveau 0000:02:00.0: BIT BIOS found
[    4.418939] [drm] nouveau 0000:02:00.0: Bios version 62.94.2a.00
[    4.418941] [drm] nouveau 0000:02:00.0: TMDS table version 2.0
[    4.419348] [drm] nouveau 0000:02:00.0: MXM: no VBIOS data, nothing to do
[    4.419350] [drm] nouveau 0000:02:00.0: DCB version 4.0
[    4.419352] [drm] nouveau 0000:02:00.0: DCB outp 00: 02000300 00000028
[    4.419354] [drm] nouveau 0000:02:00.0: DCB outp 01: 01000302 00020030
[    4.419355] [drm] nouveau 0000:02:00.0: DCB outp 02: 04011310 00000028
[    4.419356] [drm] nouveau 0000:02:00.0: DCB outp 03: 02011312 00020030
[    4.419358] [drm] nouveau 0000:02:00.0: DCB conn 00: 00001030
[    4.419360] [drm] nouveau 0000:02:00.0: DCB conn 01: 00002130
[    4.419363] [drm] nouveau 0000:02:00.0: Parsing VBIOS init table 0
at offset 0xD0BE
[    4.444655] [drm] nouveau 0000:02:00.0: Parsing VBIOS init table 1
at offset 0xD4D3
[    4.447676] [drm] nouveau 0000:02:00.0: Parsing VBIOS init table 2
at offset 0xE4C4
[    4.447685] [drm] nouveau 0000:02:00.0: Parsing VBIOS init table 3
at offset 0xE60D
[    4.448761] [drm] nouveau 0000:02:00.0: Parsing VBIOS init table 4
at offset 0xE849
[    4.448763] [drm] nouveau 0000:02:00.0: Parsing VBIOS init table at
offset 0xE8AE
[    4.468757] [drm] nouveau 0000:02:00.0: 0xE8AE: Condition still not
met after 20ms, skipping following opcodes
[    4.473557] [TTM] Zone  kernel: Available graphics memory: 3050182 kiB
[    4.473561] [TTM] Zone   dma32: Available graphics memory: 2097152 kiB
[    4.473563] [TTM] Initializing pool allocator
[    4.473568] [TTM] Initializing DMA pool allocator
[    4.473580] [drm] nouveau 0000:02:00.0: Detected 1024MiB VRAM (DDR2)
[    4.473586] mtrr: type mismatch for d0000000,10000000 old:
write-back new: write-combining
[    4.473600] [drm] nouveau 0000:02:00.0: 512 MiB GART (aperture)
[    4.517920] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[    4.517923] [drm] No driver support for vblank timestamp query.
[    4.522957] [drm] nouveau 0000:02:00.0: 1 available performance level(s)
[    4.522962] [drm] nouveau 0000:02:00.0: 3: core 550MHz shader
1375MHz memory 400MHz fanspeed 100%
[    4.522966] [drm] nouveau 0000:02:00.0: c: core 400MHz shader
800MHz memory 499MHz fanspeed 100%
[    4.567071] [drm] nouveau 0000:02:00.0: MM: using CRYPT for buffer copies
[    4.686942] [drm] nouveau 0000:02:00.0: allocated 1920x1200 fb:
0x2c0000, bo ffff8801a628e800
[    4.687095] fbcon: nouveaufb (fb0) is primary device
[    4.711940] Console: switching to colour frame buffer device 240x75
[    4.714822] fb0: nouveaufb frame buffer device
[    4.714824] drm: registered panic notifier
[    4.714857] [drm] Initialized nouveau 1.0.0 20120316 for
0000:02:00.0 on minor 0


Message on hang:

[837686.468812] [drm] nouveau 0000:02:00.0: nv50cal_space: -16
[837686.490446] [drm] nouveau 0000:02:00.0: nv50cal_space: -16
[837686.511742] [drm] nouveau 0000:02:00.0: nv50cal_space: -16
[837725.012153] SysRq : Emergency Sync
[837725.045587] Emergency Sync complete
[837725.380953] ------------[ cut here ]------------
[837725.380962] WARNING: at kernel/watchdog.c:242
watchdog_overflow_callback+0x9b/0xa6()
[837725.380964] Hardware name: EX58-UD3R
[837725.380966] Watchdog detected hard LOCKUP on cpu 4
[837725.380967] Modules linked in: it87 hwmon_vid bridge stp llc btusb
bluetooth crc16 nouveau fbcon font bitblit softcursor tt backlight
i2c_algo_bit cfbcopyarea mxm_wmi wmi cfbimgblt cfbfillrect
[837725.380994] Pid: 23949, comm: chrome Not tainted 3.6.11-gentoo #3
[837725.380996] Call Trace:
[837725.380998]  <NMI>  [<ffffffff810cf168>] ?
watchdog_overflow_callback+0x9b/0xa6
[837725.381008]  [<ffffffff8106e059>] warn_slowpath_common+0x85/0x9d
[837725.381012]  [<ffffffff8106e114>] warn_slowpath_fmt+0x46/0x48
[837725.381016]  [<ffffffff810999dc>] ? sched_cloc_cpu+0x42/0xc6
[837725.381020]  [<ffffffff810cf168>] watchdog_overflow_callback+0x9b/0xa6
[837725.381025]  [<ffffffff810fae4e>] __perf_event_overflow+0x134/0x1be
[837725.381031]  [<ffffffff8104680e>] ? x86_perf_event_set_period+0x107/0x113
[837725.381035]  [<ffffffff810fb53e>] perf_event_overflow+0x14/0x16
[837725.381039]  [<ffffffff8104acac>] intel_pmu_handle_irq+0x248/0x2ac
[837725.381045]  [<ffffffff816b167b>] perf_event_nmi_handler+0x19/0x1b
[837725.381048]  [<ffffffff816b0fa5>] nmi_handle.clone.0+0x48/0x6d
[837725.381051]  [<ffffffff816b106c>] do_nmi+0xa2/0x2c3
[837725.381057]  [<ffffffff816b07d0>] end_repeat_nmi+0x1e/0x2e
[837725.381085]  [<ffffffffa00ee4be>] ?
nv84_fence_context_del+0x38/0x40 [nouveau]
[837725.381090]  [<ffffffff816b00df>] ? _raw_spin_lock_irqsave+0x25/0x2c
[837725.381094]  [<ffffffff816b00df>] ? _raw_spin_lock_irqsave+0x25/0x2c
[837725.381098]  [<ffffffff816b00df>] ? _raw_spin_lock_irqsave+0x25/0x2c
[837725.381100]  <<EOE>>  [<ffffffffa0123c5d>]
nv84_instmem_flush+0x2b/0x9a [nouveau]
[837725.381149]  [<ffffffffa00eaefc>]
nv50_fifo_playlist_update+0x9d/0xe7 [nouveau]
[837725.381172]  [<ffffffffa00eb7ae>] nv84_fifo_context_del+0x69/0x17d [nouveau]
[837725.381184]  [<ffffffffa00c4dc5>]
nouveau_channel_put_unlocked+0xab/0x179 [nouveau]
[837725.381189]  [<ffffffff816ae755>] ? mutex_lock+0x16/0x37
[837725.381200]  [<ffffffffa00c4eb8>] nouveau_channel_put+0x25/0x29 [nouveau]
[837725.381212]  [<ffffffffa00c55aa>]
nouveau_channel_cleanup+0xc6/0xdc [nouveau]
[837725.381224]  [<ffffffffa00c4048>] nouveau_preclose+0xe/0x10 [nouveau]
[837725.381235]  [<ffffffffa0038e28>] drm_release+0x75/0x520 [drm]
[837725.381240]  [<ffffffff8113f7f4>] __fput+0xfe/0x1ba
[837725.381245]  [<ffffffff8113f8be>] ____fput+0xe/0x10
[837725.381249]  [<ffffffff81088167>] task_work_run+0x63/0x7c
[837725.381253]  [<ffffffff81072ec4>] do_exit+0x29f/0x814
[837725.381257]  [<ffffffff8107d6d6>] ? recalc_sigpending_tsk+0x3c/0x43
[837725.381262]  [<ffffffff810736c4>] do_group_exit+0x79/0xa1
[837725.381266]  [<ffffffff8107fa13>] get_signal_to_deliver+0x4a9/0x4e4
[837725.381271]  [<ffffffff810382ba>] do_signal+0x31/0x5d1
[837725.381275]  [<ffffffff8114d39b>] ? do_vfs_ioctl+0x452/0x493
[837725.381280]  [<ffffffff810d425e>] ? __secure_computing+0xa4/0x1bc
[837725.381284]  [<ffffffff810388c8>] do_notify_resume+0x55/0xa0
[837725.381288]  [<ffffffff816b6baa>] int_signal+0x12/0x17
[837725.381291] ---[ end trace db4d6e51ec4a9ed8 ]---
[837725.388458] SysRq : Emergency Remount R/O

Let me know if there's additional information I can provide.

Thanks,

  -ilia
