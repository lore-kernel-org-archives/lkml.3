Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755257Ab3ARUhE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 15:37:04 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:45909 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754153Ab3ARUhD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 15:37:03 -0500
Date: Fri, 18 Jan 2013 21:36:57 +0100
From: Pavel Machek <pavel@ucw.cz>
To: kernel list <linux-kernel@vger.kernel.org>, perex@perex.cz, tiwai@suse.de
Subject: Null pointer dereference when accessing /dev/dsp1 with USB speakers
Message-ID: <20130118203657.GA3555@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

I have USB speakers 

Bus 004 Device 002: ID 04fa:4201 Dallas Semiconductor DS4201 Audio DAC

... which make problems again
(https://lkml.org/lkml/2008/3/20/274). They refuse to produce sound,
so I updated to 3.8.0-rc2 in hope that would help... and tried testing
them by "cat /bin/bash > /dev/dsp1". Instant crash :-(.

I guess this will happen in more than one config...?

Slab corruption... Not sure if it is related. Never seen anything like
that on this X60.
								Pavel

Jan 18 21:23:00 amd kernel: Slab corruption (Tainted: G        W   ):
size-128 start=edd71b40, len=128
Jan 18 21:23:00 amd kernel: 070: 6b 6b 6b 6b 6b 6b 6b 6b 00 6b 6b 6b
6b 6b 6b a5  kkkkkkkk.kkkkkk.
Jan 18 21:23:00 amd kernel: Prev obj: start=edd71ac0, len=128
Jan 18 21:23:00 amd kernel: 000: 00 7f e9 e9 c8 2f 40 f0 00 00 00 00
00 00 00 00  ...../@.........
Jan 18 21:23:00 amd kernel: 010: 00 00 00 00 00 00 00 00 00 6c 94 e9
00 00 00 00  .........l......
Jan 18 21:23:00 amd kernel: Next obj: start=edd71bc0, len=128
Jan 18 21:23:00 amd kernel: 000: 40 12 d7 ed 40 11 d7 ed 02 00 00 00
02 00 00 00  @...@...........
Jan 18 21:23:00 amd kernel: 010: 00 00 00 00 00 00 00 00 20 53 77 69
74 63 68 00  ........ Switch.
Jan 18 21:23:00 amd kernel: 8:0: cannot get min/max values for control
5 (id 8)
Jan 18 21:23:00 amd kernel: 8:0: cannot get min/max values for control
6 (id 8)
Jan 18 21:23:00 amd kernel: 8:0: cannot get min/max values for control
1 (id 8)
Jan 18 21:23:00 amd kernel: 8:0: cannot get min/max values for control
2 (id 8)
Jan 18 21:23:00 amd kernel: usb 4-1: adding 4-1:1.1 (config #1,
interface 1)
Jan 18 21:23:00 amd kernel: hub 4-0:1.0: state 7 ports 2 chg 0000 evt
0002
Jan 18 21:25:40 amd kernel: BUG: unable to handle kernel NULL pointer
dereference at 00000010
Jan 18 21:25:40 amd kernel: IP: [<c07b56b0>]
snd_usb_pcm_prepare+0x200/0x380
Jan 18 21:25:40 amd kernel: *pde = 00000000 
Jan 18 21:25:40 amd kernel: Oops: 0000 [#1] SMP DEBUG_PAGEALLOC
Jan 18 21:25:40 amd kernel: Modules linked in:
Jan 18 21:25:40 amd kernel: Pid: 11028, comm: cat Tainted: G        W
3.8.0-rc2+ #240 LENOVO 17097HU/17097HU
Jan 18 21:25:40 amd kernel: EIP: 0060:[<c07b56b0>] EFLAGS: 00010246
CPU: 0
Jan 18 21:25:40 amd kernel: EIP is at snd_usb_pcm_prepare+0x200/0x380
Jan 18 21:25:40 amd kernel: EAX: 00000000 EBX: eecd6e10 ECX: 00000002
EDX: 00000000
Jan 18 21:25:40 amd kernel: ESI: 0000bb80 EDI: e9f1ac00 EBP: f0cd3e14
ESP: f0cd3db8
Jan 18 21:25:40 amd kernel: DS: 007b ES: 007b FS: 00d8 GS: 0033 SS:
0068
Jan 18 21:25:40 amd kernel: CR0: 8005003b CR2: 00000010 CR3: 2defa000
CR4: 00000790
Jan 18 21:25:40 amd kernel: DR0: 00000000 DR1: 00000000 DR2: 00000000
DR3: 00000000
Jan 18 21:25:40 amd kernel: DR6: ffff0ff0 DR7: 00000400
Jan 18 21:25:40 amd kernel: Process cat (pid: 11028, ti=f0cd2000
task=ecb1a670 task.ti=f0cd2000)
Jan 18 21:25:40 amd kernel: Stack:
Jan 18 21:25:40 amd kernel: 0000c030 0000bb80 edd717c0 edea0000
00000000 00000000 e9f1ac00 eecd6e10
Jan 18 21:25:40 amd kernel: edd717c0 0000bb80 00000002 eecd6e00
edea0000 0000c030 00000001 00000000
Jan 18 21:25:40 amd kernel: 00000004 00000000 eecd6f24 00000000
ecba4e00 00000000 00000000 f0cd3e20
Jan 18 21:25:40 amd kernel: Call Trace:
Jan 18 21:25:40 amd kernel: [<c071af8f>] snd_pcm_do_prepare+0xf/0x20
Jan 18 21:25:40 amd kernel: [<c071ab3b>]
snd_pcm_action_single+0x2b/0x60
Jan 18 21:25:40 amd kernel: [<c071c23b>]
snd_pcm_action_nonatomic+0x6b/0x70
Jan 18 21:25:40 amd kernel: [<c071f0c3>]
snd_pcm_common_ioctl1+0x683/0xd90
Jan 18 21:25:40 amd kernel: [<c0921d58>] ? mutex_unlock+0x8/0x10
Jan 18 21:25:40 amd kernel: [<c072cd91>] ?
snd_pcm_oss_change_params+0x231/0xe90
Jan 18 21:25:40 amd kernel: [<c071fc1b>]
snd_pcm_playback_ioctl1+0x4b/0x3f0
Jan 18 21:25:40 amd kernel: [<c0720047>]
snd_pcm_kernel_ioctl+0x37/0x70
Jan 18 21:25:40 amd kernel: [<c072b099>] snd_pcm_oss_prepare+0x19/0x80
Jan 18 21:25:40 amd kernel: [<c072da2f>]
snd_pcm_oss_make_ready+0x3f/0x70
Jan 18 21:25:40 amd kernel: [<c072e1f8>] snd_pcm_oss_write+0x58/0x1f0
Jan 18 21:25:40 amd kernel: [<c02d1eca>] vfs_write+0x9a/0x140
Jan 18 21:25:40 amd kernel: [<c072e1a0>] ?
snd_pcm_oss_poll+0x280/0x280
Jan 18 21:25:40 amd kernel: [<c02d2039>] sys_write+0x49/0x80
Jan 18 21:25:40 amd kernel: [<c0925338>] sysenter_do_call+0x12/0x31
Jan 18 21:25:40 amd kernel: Code: 00 00 89 5d c0 89 4d cc 0f b6 4d cc
89 7d bc f6 c1 20 0f 94 c0 0f 95 c2 d3 e0 89 45 e4 89 f0 8b 75 c8 d3
e2 89 55 e8 8d 74 26 00 <8b> 78 10 85 ff 74 39 8b 55 e4 8b 4d e8 23 50
08 23 48 0c 09 d1
Jan 18 21:25:40 amd kernel: EIP: [<c07b56b0>]
snd_usb_pcm_prepare+0x200/0x380 SS:ESP 0068:f0cd3db8
Jan 18 21:25:40 amd kernel: CR2: 0000000000000010
Jan 18 21:25:40 amd kernel: ---[ end trace 1703ba0bf24c8e32 ]---
Jan 18 21:27:03 amd kernel: imklog 4.6.4, log source = /proc/kmsg started.


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
