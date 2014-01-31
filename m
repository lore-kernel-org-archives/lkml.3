Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754532AbaAaVO6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 16:14:58 -0500
Received: from mail-pa0-f50.google.com ([209.85.220.50]:57552 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754108AbaAaVO4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 16:14:56 -0500
MIME-Version: 1.0
From: Darrin Burger <aenigma1372@gmail.com>
Date: Fri, 31 Jan 2014 16:09:46 -0500
Message-ID: <CABL-Nzmh6Eh3E2mS4GGPR8eO=U2k4HN4CRnFfWt6nbgTHHu4kw@mail.gmail.com>
Subject: Fwd: PROBLEM: Possible CPU idle / e1000e bug causing soft/hard lock-ups.
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: linux-pm <linux-pm@vger.kernel.org>,
        "daniel.lezcano" <daniel.lezcano@linaro.org>, rjw <rjw@rjwysocki.net>,
        e1000-devel <e1000-devel@lists.sourceforge.net>,
        "jeffrey.t.kirsher" <jeffrey.t.kirsher@intel.com>,
        "jesse.brandeburg" <jesse.brandeburg@intel.com>,
        "bruce.w.allan" <bruce.w.allan@intel.com>,
        "carolyn.wyborny" <carolyn.wyborny@intel.com>,
        "donald.c.skidmore" <donald.c.skidmore@intel.com>,
        "gregory.v.rose" <gregory.v.rose@intel.com>,
        "alexander.h.duyck" <alexander.h.duyck@intel.com>,
        "john.ronciak" <john.ronciak@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry, appears first message wasn't accepted due to HTML formatting,
resending in plain text.

---------- Forwarded message ----------
From: Darrin Burger <aenigma1372@gmail.com>
Date: Fri, Jan 31, 2014 at 4:03 PM
Subject: PROBLEM: Possible CPU idle / e1000e bug causing soft/hard lock-ups.
To: linux-kernel@vger.kernel.org
Cc: linux-pm@vger.kernel.org, daniel.lezcano@linaro.org,
rjw@rjwysocki.net, e1000-devel@lists.sourceforge.net,
jeffrey.t.kirsher@intel.com, jesse.brandeburg@intel.com,
bruce.w.allan@intel.com, carolyn.wyborny@intel.com,
donald.c.skidmore@intel.com, gregory.v.rose@intel.com,
alexander.h.duyck@intel.com, john.ronciak@intel.com


Hello,

I'd like to begin by apologizing in advance if I'm submitting this bug
improperly or am not including all relevant information, as this is my
first kernel bug report submission.  With that being said, following
the template given on
https://www.kernel.org/pub/linux/docs/lkml/reporting-bugs.html, the
information that I can locate that is relevant to this bug is as
follows:

[1.] One line summary of the problem:

System randomly (but somewhat frequently) has kernel soft/hard
lock-ups fairly often, which appears may be related to CPU idle/PM or
e1000e driver bug.



[2.] Full description of the problem/report:

When actively using the system, soft-lockups occur randomly, but on a
fairly frequent basis.  When system is idle, the frequency of
soft-lockups increases and ultimately results in a hard-lockup fairly
often.  It appears that this may be related to either a bug in the CPU
idle/PM code or the e1000e network driver.  I've had this happen in
both kernels 3.13.x and 3.12.x (and I believe it also happened in
kernels 3.10.x and 3.11.x, but I'm not positive).



[3.] Keywords (i.e., modules, networking, kernel):

CPU idle, PM, e1000


[4.] Kernel version (from /proc/version):


Linux version 3.13.1 (root@MainDesktop1) (gcc version 4.8.1
(Ubuntu/Linaro 4.8.1-10ubuntu9) ) #1 SMP PREEMPT Thu Jan 30 16:41:24
EST 2014


[5.] Output of Oops.. message (if applicable) with symbolic information
     resolved (see Documentation/oops-tracing.txt):

Have a few of these saved, please see below:


Jan 28 16:41:09 MainDesktop1 kernel: [91169.276137] BUG: soft lockup -
CPU#3 stuck for 174s! [swapper/3:0]

Jan 28 16:41:09 MainDesktop1 kernel: [91169.276142] Modules linked in:
nls_iso8859_1 psmouse serio_raw
Jan 28 16:41:09 MainDesktop1 kernel: [91169.276150] BUG: soft lockup -
CPU#2 stuck for 174s! [swapper/2:0]
Jan 28 16:41:09 MainDesktop1 kernel: [91169.276158] CPU: 3 PID: 0
Comm: swapper/3 Tainted: G        W    3.13.0 #2

Jan 28 16:41:09 MainDesktop1 kernel: [91169.276161] Hardware name: To
be filled by O.E.M. To be filled by O.E.M./CROSSHAIR V FORMULA-Z, BIOS
1701 10/28/2013
Jan 28 16:41:09 MainDesktop1 kernel: [91169.276164] task:
ffff88062df30000 ti: ffff88062df2a000 task.ti: ffff88062df2a000

Jan 28 16:41:09 MainDesktop1 kernel: [91169.276151] Modules linked in:
nls_iso8859_1 psmouse
Jan 28 16:41:09 MainDesktop1 kernel: [91169.276166] RIP:
0010:[<ffffffff8104c388>]  [<ffffffff8104c388>]
default_idle+0x18/0x100

Jan 28 16:41:09 MainDesktop1 kernel: [91169.276173] RSP:
0018:ffff88062df2be90  EFLAGS: 00000202
Jan 28 16:41:09 MainDesktop1 kernel: [91169.276174] RAX:
0000000000000003 RBX: ffffffff81065944 RCX: 0000000000003c94

Jan 28 16:41:09 MainDesktop1 kernel: [91169.276176] RDX:
0000000000000002 RSI: 0000000000000086 RDI: 00000000ffffffff
Jan 28 16:41:09 MainDesktop1 kernel: [91169.276178] RBP:
ffff88062df2bea0 R08: 0000000000000000 R09: 0000000000000000

Jan 28 16:41:09 MainDesktop1 kernel: [91169.276179] R10:
0000000000000000 R11: 0000000000000000 R12: ffff88064fd8cbc0
Jan 28 16:41:09 MainDesktop1 kernel: [91169.276181] R13:
0000000000000046 R14: ffff88062df2be08 R15: 0000000000000000

Jan 28 16:41:09 MainDesktop1 kernel: [91169.276183] FS:
00007fa90f0f8700(0000) GS:ffff88064fd80000(0000)
knlGS:00000000f48b4880
Jan 28 16:41:09 MainDesktop1 kernel: [91169.276184] CS:  0010 DS: 0000
ES: 0000 CR0: 000000008005003b

Jan 28 16:41:09 MainDesktop1 kernel: [91169.276186] CR2:
00007fa90cb5f000 CR3: 0000000627a49000 CR4: 00000000000007e0
Jan 28 16:41:09 MainDesktop1 kernel: [91169.276187] Stack:
Jan 28 16:41:09 MainDesktop1 kernel: [91169.276188]  ffff88062df2beb4
ffff88062df2bfd8 ffff88062df2bec0 ffffffff8104c4b5

Jan 28 16:41:09 MainDesktop1 kernel: [91169.276194]  0000000382fa8ce0
0000000000000003 ffff88062df2bed0 ffffffff8104cd16
Jan 28 16:41:09 MainDesktop1 kernel: [91169.276199]  ffff88062df2bf20
ffffffff81137790 ffff88062df2bfd8 ffff88062df2bfd8

Jan 28 16:41:09 MainDesktop1 kernel: [91169.276204] Call Trace:
Jan 28 16:41:09 MainDesktop1 kernel: [91169.276206]  serio_raw
Jan 28 16:41:09 MainDesktop1 kernel: [91169.276210] CPU: 2 PID: 0
Comm: swapper/2 Tainted: G        W    3.13.0 #2

Jan 28 16:41:09 MainDesktop1 kernel: [91169.276212] Hardware name: To
be filled by O.E.M. To be filled by O.E.M./CROSSHAIR V FORMULA-Z, BIOS
1701 10/28/2013
Jan 28 16:41:09 MainDesktop1 kernel: [91169.276214] task:
ffff88062df1de80 ti: ffff88062df28000 task.ti: ffff88062df28000

Jan 28 16:41:09 MainDesktop1 kernel: [91169.276221] RIP:
0010:[<ffffffff8104c388>]  [<ffffffff8104c388>]
default_idle+0x18/0x100
Jan 28 16:41:09 MainDesktop1 kernel: [91169.276222] RSP:
0018:ffff88062df29e90  EFLAGS: 00000202

Jan 28 16:41:09 MainDesktop1 kernel: [91169.276224] RAX:
0000000000000002 RBX: ffffffff81065944 RCX: 0000000000003c98
Jan 28 16:41:09 MainDesktop1 kernel: [91169.276226] RDX:
0000000000000002 RSI: 0000000000000086 RDI: 00000000ffffffff

Jan 28 16:41:09 MainDesktop1 kernel: [91169.276227] RBP:
ffff88062df29ea0 R08: 0000000000000000 R09: 0000000000000000
Jan 28 16:41:09 MainDesktop1 kernel: [91169.276229] R10:
0000000000000000 R11: 0000000000000000 R12: ffff88064fd0cbc0

Jan 28 16:41:09 MainDesktop1 kernel: [91169.276230] R13:
0000000000000046 R14: ffff88062df29e08 R15: 0000000000000000
Jan 28 16:41:09 MainDesktop1 kernel: [91169.276232] FS:
00007fcbe45a5700(0000) GS:ffff88064fd00000(0000)
knlGS:00000000f48b4880

Jan 28 16:41:09 MainDesktop1 kernel: [91169.276234] CS:  0010 DS: 0000
ES: 0000 CR0: 000000008005003b
Jan 28 16:41:09 MainDesktop1 kernel: [91169.276236] CR2:
00007fcbecb04008 CR3: 0000000433070000 CR4: 00000000000007e0

Jan 28 16:41:09 MainDesktop1 kernel: [91169.276237] Stack:
Jan 28 16:41:09 MainDesktop1 kernel: [91169.276242]
[<ffffffff8104c4b5>] amd_e400_idle+0x45/0xf0
Jan 28 16:41:09 MainDesktop1 kernel: [91169.276238]  ffff88062df29eb4
ffff88062df29fd8 ffff88062df29ec0

Jan 28 16:41:09 MainDesktop1 kernel: [91169.276244]
[<ffffffff8104cd16>] arch_cpu_idle+0x26/0x30
Jan 28 16:41:09 MainDesktop1 kernel: [91169.276247]
[<ffffffff81137790>] cpu_startup_entry+0xc0/0x2b0
Jan 28 16:41:09 MainDesktop1 kernel: [91169.276252]
[<ffffffff81064075>] start_secondary+0x1f5/0x250

Jan 28 16:41:09 MainDesktop1 kernel: [91169.276255] Code:  ffffffff8104c4b5
Jan 28 16:41:09 MainDesktop1 kernel: [91169.276259] a8
Jan 28 16:41:09 MainDesktop1 kernel: [91169.276261]  0000000282fa8ce0
0000000000000002 ffff88062df29ed0 ffffffff8104cd16

Jan 28 16:41:09 MainDesktop1 kernel: [91169.276266]  ffff88062df29f20
ffffffff81137790 ffff88062df29fd8 ffff88062df29fd8
Jan 28 16:41:09 MainDesktop1 kernel: [91169.276272] Call Trace:
Jan 28 16:41:09 MainDesktop1 kernel: [91169.276273] 18
[<ffffffff8104c4b5>] amd_e400_idle+0x45/0xf0

Jan 28 16:41:09 MainDesktop1 kernel: [91169.276278] 83 48
Jan 28 16:41:09 MainDesktop1 kernel: [91169.276280]
[<ffffffff8104cd16>] arch_cpu_idle+0x26/0x30
Jan 28 16:41:09 MainDesktop1 kernel: [91169.276283]
[<ffffffff81137790>] cpu_startup_entry+0xc0/0x2b0

Jan 28 16:41:09 MainDesktop1 kernel: [91169.276287]
[<ffffffff81064075>] start_secondary+0x1f5/0x250
Jan 28 16:41:09 MainDesktop1 kernel: [91169.276291] Code: 89 e5 e8 78
Jan 28 16:41:09 MainDesktop1 kernel: [91169.276295] a8 18 83 48

Jan 28 16:41:09 MainDesktop1 kernel: [91169.276299] 5d 0c 00 5d c3 66
0f 1f 44 00 00 66 66 66 66 90 55 48 89 e5 41 54 53 e8 cf ab 83 00 66
66 66 66 90 fb f4 <e8> c3 ab 83 00 41 89 c4 66 66 66 66 90 5b 41 5c 5d
c3 66 0f 1f

Jan 28 16:41:09 MainDesktop1 kernel: [91169.276355] 89 e5 e8 78 5d 0c
00 5d c3 66 0f 1f 44 00 00 66 66 66 66 90 55 48 89 e5 41 54 53 e8 cf
ab 83 00 66 66 66 66 90 fb f4 <e8> c3 ab 83 00 41 89 c4 66 66 66 66 90
5b 41 5c 5d c3 66 0f 1f

Jan 28 16:41:09 MainDesktop1 kernel: [91169.276409] BUG: soft lockup -
CPU#1 stuck for 175s! [swapper/1:0]
Jan 28 16:41:09 MainDesktop1 kernel: [91169.276414] BUG: soft lockup -
CPU#0 stuck for 175s! [swapper/0:0]
Jan 28 16:41:09 MainDesktop1 kernel: [91169.276415] Modules linked in:
nls_iso8859_1 psmouse serio_raw

Jan 28 16:41:09 MainDesktop1 kernel: [91169.276423] Modules linked in:
nls_iso8859_1 psmouse serio_raw
Jan 28 16:41:09 MainDesktop1 kernel: [91169.276432] CPU: 1 PID: 0
Comm: swapper/1 Tainted: G        W    3.13.0 #2

Jan 28 16:41:09 MainDesktop1 kernel: [91169.276434]
Jan 28 16:41:09 MainDesktop1 kernel: [91169.276436] CPU: 0 PID: 0
Comm: swapper/0 Tainted: G        W    3.13.0 #2
Jan 28 16:41:09 MainDesktop1 kernel: [91169.276438] Hardware name: To
be filled by O.E.M. To be filled by O.E.M./CROSSHAIR V FORMULA-Z, BIOS
1701 10/28/2013

Jan 28 16:41:09 MainDesktop1 kernel: [91169.276441] task:
ffffffff82e11480 ti: ffffffff82e00000 task.ti: ffffffff82e00000
Jan 28 16:41:09 MainDesktop1 kernel: [91169.276448] RIP:
0010:[<ffffffff823382a6>]  [<ffffffff823382a6>]
__slab_alloc.isra.56+0x373/0x3d9

Jan 28 16:41:09 MainDesktop1 kernel: [91169.276451] Hardware name: To
be filled by O.E.M. To be filled by O.E.M./CROSSHAIR V FORMULA-Z, BIOS
1701 10/28/2013
Jan 28 16:41:09 MainDesktop1 kernel: [91169.276453] task:
ffff88062df1c6e0 ti: ffff88062df26000 task.ti: ffff88062df26000

Jan 28 16:41:09 MainDesktop1 kernel: [91169.276459] RIP:
0010:[<ffffffff8104c4c9>]  [<ffffffff8104c4c9>]
amd_e400_idle+0x59/0xf0
Jan 28 16:41:09 MainDesktop1 kernel: [91169.276462] RSP:
0018:ffff88064fc03690  EFLAGS: 00000287

Jan 28 16:41:09 MainDesktop1 kernel: [91169.276464] RAX:
ffff8805baf48e00 RBX: 000000014fc03620 RCX: 0000000180100010
Jan 28 16:41:09 MainDesktop1 kernel: [91169.276465] RDX:
0000000000000503 RSI: ffffea0016ebd200 RDI: 00000000ffffffff

Jan 28 16:41:09 MainDesktop1 kernel: [91169.276467] RBP:
ffff88064fc03738 R08: 0000000000000000 R09: 0000000180100010
Jan 28 16:41:09 MainDesktop1 kernel: [91169.276469] R10:
0000000000000000 R11: 0000000000000000 R12: ffff88064fc03608

Jan 28 16:41:09 MainDesktop1 kernel: [91169.276470] R13:
ffffffff82352f0a R14: ffff88064fc03738 R15: ffff880637001700
Jan 28 16:41:09 MainDesktop1 kernel: [91169.276472] FS:
00007f33cbfff700(0000) GS:ffff88064fc00000(0000)
knlGS:00000000f48b4880

Jan 28 16:41:09 MainDesktop1 kernel: [91169.276474] CS:  0010 DS: 0000
ES: 0000 CR0: 000000008005003b
Jan 28 16:41:09 MainDesktop1 kernel: [91169.276475] CR2:
00007f33e0ffa019 CR3: 000000055b52c000 CR4: 00000000000007f0

Jan 28 16:41:09 MainDesktop1 kernel: [91169.276477] Stack:
Jan 28 16:41:09 MainDesktop1 kernel: [91169.276480] RSP:
0018:ffff88062df27eb8  EFLAGS: 00000286
Jan 28 16:41:09 MainDesktop1 kernel: [91169.276484] RAX:
0000000000000001 RBX: ffffffff8234a509 RCX: 0000000000003c9a

Jan 28 16:41:09 MainDesktop1 kernel: [91169.276485] RDX:
0000000000000002 RSI: 0000000000000086 RDI: 00000000ffffffff
Jan 28 16:41:09 MainDesktop1 kernel: [91169.276487] RBP:
ffff88062df27ec0 R08: 0000000000000000 R09: 0000000000000000

Jan 28 16:41:09 MainDesktop1 kernel: [91169.276488] R10:
0000000000000000 R11: 0000000000000000 R12: ffffffff8234aa22
Jan 28 16:41:09 MainDesktop1 kernel: [91169.276490] R13:
0000000000000000 R14: ffffffff81065944 R15: ffff88062df27ea0

Jan 28 16:41:09 MainDesktop1 kernel: [91169.276492] FS:
00007f8e0435e700(0000) GS:ffff88064fc80000(0000)
knlGS:00000000f354bb40
Jan 28 16:41:09 MainDesktop1 kernel: [91169.276494] CS:  0010 DS: 0000
ES: 0000 CR0: 000000008005003b

Jan 28 16:41:09 MainDesktop1 kernel: [91169.276495] CR2:
00007fcbecb52000 CR3: 000000008c8ec000 CR4: 00000000000007e0
Jan 28 16:41:09 MainDesktop1 kernel: [91169.276497] Stack:
Jan 28 16:41:09 MainDesktop1 kernel: [91169.276478]  9c637cf100000002
ffffffff82f53258 ffff88017b9c95a8 ffffffff82f52880

Jan 28 16:41:09 MainDesktop1 kernel: [91169.276498]  0000000000000001
ffff88062df27ed0 ffffffff8104cd16 ffff88062df27f20
Jan 28 16:41:09 MainDesktop1 kernel: [91169.276504]  ffffffff81137790
ffff88062df27fd8 ffff88062df27fd8 54ba2f5d6faec8f3

Jan 28 16:41:09 MainDesktop1 kernel: [91169.276509]  000000000000cb90
0000000000000001 0000000000000000 0000000000000000
Jan 28 16:41:09 MainDesktop1 kernel: [91169.276514] Call Trace:
Jan 28 16:41:09 MainDesktop1 kernel: [91169.276516]

Jan 28 16:41:09 MainDesktop1 kernel: [91169.276517]
[<ffffffff8104cd16>] arch_cpu_idle+0x26/0x30
Jan 28 16:41:09 MainDesktop1 kernel: [91169.276524]
[<ffffffff81137790>] cpu_startup_entry+0xc0/0x2b0
Jan 28 16:41:09 MainDesktop1 kernel: [91169.276527]
[<ffffffff81064075>] start_secondary+0x1f5/0x250

Jan 28 16:41:09 MainDesktop1 kernel: [91169.276529] Code: 4b
Jan 28 16:41:09 MainDesktop1 kernel: [91169.276530]  ffff88017b9c94bc
ffff88064fc15b70 00000020810f0032 0000000000000287
Jan 28 16:41:09 MainDesktop1 kernel: [91169.276533] 48 8d 5d f4 48 89
de bf 04 00 00 00 e8 90 f4 0f 00 e8 bb fe ff ff fa 48 8d 75 f4 bf 05
00 00 00 e8 7c f4 0f 00 fb 48 83 c4 08 <5b> 5d c3 0f 1f 40 00 b9 55 00
01 c0 0f 32 a9 00 00 00 18 75 39

Jan 28 16:41:09 MainDesktop1 kernel: [91169.276596]
Jan 28 16:41:09 MainDesktop1 kernel: [91169.276597]  ffffffff8211abfd
ffffffff8211abfd ffffffff82088df2 0000000100100010
Jan 28 16:41:09 MainDesktop1 kernel: [91169.276599] Call Trace:

Jan 28 16:41:09 MainDesktop1 kernel: [91169.276601]  <IRQ>
Jan 28 16:41:09 MainDesktop1 kernel: [91169.276602]
[<ffffffff8211abfd>] ? ipt_do_table+0x2fd/0x5c0
Jan 28 16:41:09 MainDesktop1 kernel: [91169.276608]
[<ffffffff8211abfd>] ? ipt_do_table+0x2fd/0x5c0

Jan 28 16:41:09 MainDesktop1 kernel: [91169.276612]
[<ffffffff82088df2>] ? ____nf_conntrack_find+0x122/0x160
Jan 28 16:41:09 MainDesktop1 kernel: [91169.276615]
[<ffffffff810f0032>] ? local_bh_enable+0x42/0xa0

Jan 28 16:41:09 MainDesktop1 kernel: [91169.276616]
[<ffffffff8211abfd>] ? ipt_do_table+0x2fd/0x5c0
Jan 28 16:41:09 MainDesktop1 kernel: [91169.276620]
[<ffffffff81213f7b>] kmem_cache_alloc+0x13b/0x180

Jan 28 16:41:09 MainDesktop1 kernel: [91169.276623]
[<ffffffff8200f609>] skb_clone+0x49/0xb0
Jan 28 16:41:09 MainDesktop1 kernel: [91169.276625]
[<ffffffff8201dd0b>] dev_queue_xmit_nit+0xfb/0x220
Jan 28 16:41:09 MainDesktop1 kernel: [91169.276628]
[<ffffffff8201fee4>] dev_hard_start_xmit+0x2f4/0x580

Jan 28 16:41:09 MainDesktop1 kernel: [91169.276630]
[<ffffffff820204d9>] __dev_queue_xmit+0x369/0x4e0
Jan 28 16:41:09 MainDesktop1 kernel: [91169.276632]
[<ffffffff82020660>] dev_queue_xmit+0x10/0x20
Jan 28 16:41:09 MainDesktop1 kernel: [91169.276634]
[<ffffffff820c2421>] ip_finish_output+0x2c1/0x380

Jan 28 16:41:09 MainDesktop1 kernel: [91169.276636]
[<ffffffff820c37c8>] ip_output+0x58/0x90
Jan 28 16:41:09 MainDesktop1 kernel: [91169.276638]
[<ffffffff820c2f15>] ip_local_out+0x25/0x30
Jan 28 16:41:09 MainDesktop1 kernel: [91169.276640]
[<ffffffff820c3280>] ip_queue_xmit+0x140/0x3e0

Jan 28 16:41:09 MainDesktop1 kernel: [91169.276643]
[<ffffffff820d9b43>] tcp_transmit_skb+0x453/0x8c0
Jan 28 16:41:09 MainDesktop1 kernel: [91169.276645]
[<ffffffff820dc6e4>] tcp_send_ack+0xa4/0xf0
Jan 28 16:41:09 MainDesktop1 kernel: [91169.276647]
[<ffffffff820cfefe>] __tcp_ack_snd_check+0x5e/0x90

Jan 28 16:41:09 MainDesktop1 kernel: [91169.276650]
[<ffffffff820d6799>] tcp_rcv_established+0x209/0x660
Jan 28 16:41:09 MainDesktop1 kernel: [91169.276652]
[<ffffffff820e049d>] tcp_v4_do_rcv+0x1cd/0x490

Jan 28 16:41:09 MainDesktop1 kernel: [91169.276654]
[<ffffffff820e277f>] tcp_v4_rcv+0x74f/0x770
Jan 28 16:41:09 MainDesktop1 kernel: [91169.276657]
[<ffffffff820bdeb0>] ? ip_rcv_finish+0x350/0x350
Jan 28 16:41:09 MainDesktop1 kernel: [91169.276659]
[<ffffffff820828ef>] ? nf_hook_slow+0xdf/0x120

Jan 28 16:41:09 MainDesktop1 kernel: [91169.276661]
[<ffffffff820bdeb0>] ? ip_rcv_finish+0x350/0x350
Jan 28 16:41:09 MainDesktop1 kernel: [91169.276663]
[<ffffffff820bdf38>] ip_local_deliver_finish+0x88/0x1e0

Jan 28 16:41:09 MainDesktop1 kernel: [91169.276665]
[<ffffffff820be218>] ip_local_deliver+0x48/0x80
Jan 28 16:41:09 MainDesktop1 kernel: [91169.276667]
[<ffffffff820bdbe8>] ip_rcv_finish+0x88/0x350
Jan 28 16:41:09 MainDesktop1 kernel: [91169.276669]
[<ffffffff820be4f0>] ip_rcv+0x2a0/0x3d0

Jan 28 16:41:09 MainDesktop1 kernel: [91169.276671]
[<ffffffff8201e47e>] __netif_receive_skb_core+0x64e/0x840
Jan 28 16:41:09 MainDesktop1 kernel: [91169.276673]
[<ffffffff8201e691>] __netif_receive_skb+0x21/0x70

Jan 28 16:41:09 MainDesktop1 kernel: [91169.276675]
[<ffffffff8201e703>] netif_receive_skb+0x23/0xb0
Jan 28 16:41:09 MainDesktop1 kernel: [91169.276678]
[<ffffffff82196a6a>] br_handle_frame_finish+0x1fa/0x3e0

Jan 28 16:41:09 MainDesktop1 kernel: [91169.276680]
[<ffffffff82196dd5>] br_handle_frame+0x185/0x260
Jan 28 16:41:09 MainDesktop1 kernel: [91169.276682]
[<ffffffff8201e06a>] __netif_receive_skb_core+0x23a/0x840

Jan 28 16:41:09 MainDesktop1 kernel: [91169.276684]
[<ffffffff8201e691>] __netif_receive_skb+0x21/0x70
Jan 28 16:41:09 MainDesktop1 kernel: [91169.276686]
[<ffffffff8201e703>] netif_receive_skb+0x23/0xb0

Jan 28 16:41:09 MainDesktop1 kernel: [91169.276688]
[<ffffffff8201f188>] napi_gro_receive+0x88/0xc0
Jan 28 16:41:09 MainDesktop1 kernel: [91169.276691]
[<ffffffff81bbbeeb>] e1000_receive_skb+0x8b/0x100

Jan 28 16:41:09 MainDesktop1 kernel: [91169.276693]
[<ffffffff81bbd31e>] e1000_clean_rx_irq+0x23e/0x3c0
Jan 28 16:41:09 MainDesktop1 kernel: [91169.276695]
[<ffffffff81bc4e08>] e1000e_poll+0x78/0x300
Jan 28 16:41:09 MainDesktop1 kernel: [91169.276697]
[<ffffffff8201ea49>] net_rx_action+0x129/0x230

Jan 28 16:41:09 MainDesktop1 kernel: [91169.276700]
[<ffffffff810efcfc>] __do_softirq+0xdc/0x2b0
Jan 28 16:41:09 MainDesktop1 kernel: [91169.276702]
[<ffffffff810f0185>] irq_exit+0x75/0x80
Jan 28 16:41:09 MainDesktop1 kernel: [91169.276705]
[<ffffffff82353f83>] do_IRQ+0x63/0xd0

Jan 28 16:41:09 MainDesktop1 kernel: [91169.276708]
[<ffffffff8234aeaa>] common_interrupt+0x6a/0x6a
Jan 28 16:41:09 MainDesktop1 kernel: [91169.276709]  <EOI>
Jan 28 16:41:09 MainDesktop1 kernel: [91169.276710]
[<ffffffff8104c388>] ? default_idle+0x18/0x100

Jan 28 16:41:09 MainDesktop1 kernel: [91169.276714]
[<ffffffff8104c381>] ? default_idle+0x11/0x100
Jan 28 16:41:09 MainDesktop1 kernel: [91169.276716]
[<ffffffff8104c4b5>] amd_e400_idle+0x45/0xf0
Jan 28 16:41:09 MainDesktop1 kernel: [91169.276718]
[<ffffffff8104cd16>] arch_cpu_idle+0x26/0x30

Jan 28 16:41:09 MainDesktop1 kernel: [91169.276721]
[<ffffffff81137790>] cpu_startup_entry+0xc0/0x2b0
Jan 28 16:41:09 MainDesktop1 kernel: [91169.276724]
[<ffffffff82331c14>] rest_init+0x84/0x90
Jan 28 16:41:09 MainDesktop1 kernel: [91169.276728]
[<ffffffff82fd4ea1>] start_kernel+0x416/0x422

Jan 28 16:41:09 MainDesktop1 kernel: [91169.276730]
[<ffffffff82fd4894>] ? repair_env_string+0x5c/0x5c
Jan 28 16:41:09 MainDesktop1 kernel: [91169.276732]
[<ffffffff82fd45a3>] x86_64_start_reservations+0x2a/0x2c

Jan 28 16:41:09 MainDesktop1 kernel: [91169.276734]
[<ffffffff82fd469b>] x86_64_start_kernel+0xf6/0xf9
Jan 28 16:41:09 MainDesktop1 kernel: [91169.276735] Code: c0 75 dd 48
63 43 20 4c 89 e6 48 89 df 49 8b 14 07 e8 cf a9 ed fe 49 c7 45 10 00
00 00 00 49 c7 45 00 00 00 00 00 ff 74 24 38 9d <4c> 89 f8 eb 52 49 8b
55 00 4c 89 f6 48 89 df e8 a6 a9 ed fe 49

Jan 28 16:41:09 MainDesktop1 kernel: [91169.277931] Hangcheck:
hangcheck value past margin!
Jan 28 16:41:09 MainDesktop1 rtkit-daemon[5807]: The canary thread is
apparently starving. Taking action.
Jan 28 16:41:09 MainDesktop1 rtkit-daemon[5807]: Demoting known
real-time threads.

Jan 28 16:41:09 MainDesktop1 rtkit-daemon[5807]: Successfully demoted
thread 6856 of process 6847 (n/a).
Jan 28 16:41:09 MainDesktop1 rtkit-daemon[5807]: Successfully demoted
thread 6855 of process 6847 (n/a).
Jan 28 16:41:09 MainDesktop1 rtkit-daemon[5807]: Successfully demoted
thread 6852 of process 6847 (n/a).

Jan 28 16:41:09 MainDesktop1 rtkit-daemon[5807]: Successfully demoted
thread 6851 of process 6847 (n/a).
Jan 28 16:41:09 MainDesktop1 rtkit-daemon[5807]: Successfully demoted
thread 6848 of process 6847 (n/a).
Jan 28 16:41:09 MainDesktop1 rtkit-daemon[5807]: Successfully demoted
thread 6847 of process 6847 (n/a).

Jan 28 16:41:09 MainDesktop1 rtkit-daemon[5807]: Demoted 6 threads.







Jan 27 23:52:17 MainDesktop1 kernel: [31134.056229] ------------[ cut
here ]------------
Jan 27 23:52:17 MainDesktop1 kernel: [31134.056238] WARNING: CPU: 0
PID: 0 at kernel/watchdog.c:245 watchdog_overflow_callback+0x98/0xc0()

Jan 27 23:52:17 MainDesktop1 kernel: [31134.056240] Watchdog detected
hard LOCKUP on cpu 0
Jan 27 23:52:17 MainDesktop1 kernel: [31134.056241] Modules linked in:
psmouse serio_raw
Jan 27 23:52:17 MainDesktop1 kernel: [31134.056246] CPU: 0 PID: 0
Comm: swapper/0 Not tainted 3.13.0 #2

Jan 27 23:52:17 MainDesktop1 kernel: [31134.056247] Hardware name: To
be filled by O.E.M. To be filled by O.E.M./CROSSHAIR V FORMULA-Z, BIOS
1701 10/28/2013
Jan 27 23:52:17 MainDesktop1 kernel: [31134.056249]  0000000000000009
ffff88064fc06c30 ffffffff8233d7a8 ffff88064fc06c78

Jan 27 23:52:17 MainDesktop1 kernel: [31134.056252]  ffff88064fc06c68
ffffffff810eab3c ffff88063700d800 0000000000000000
Jan 27 23:52:17 MainDesktop1 kernel: [31134.056254]  ffff88064fc06d80
0000000000000000 ffff88064fc06ef8 ffff88064fc06cc8

Jan 27 23:52:17 MainDesktop1 kernel: [31134.056257] Call Trace:
Jan 27 23:52:17 MainDesktop1 kernel: [31134.056258]  <NMI>
[<ffffffff8233d7a8>] dump_stack+0x4e/0x7a
Jan 27 23:52:17 MainDesktop1 kernel: [31134.056265]
[<ffffffff810eab3c>] warn_slowpath_common+0x8c/0xc0

Jan 27 23:52:17 MainDesktop1 kernel: [31134.056268]
[<ffffffff810eabbc>] warn_slowpath_fmt+0x4c/0x50
Jan 27 23:52:17 MainDesktop1 kernel: [31134.056270]
[<ffffffff81183a60>] ? restart_watchdog_hrtimer+0x50/0x50

Jan 27 23:52:17 MainDesktop1 kernel: [31134.056272]
[<ffffffff81183af8>] watchdog_overflow_callback+0x98/0xc0
Jan 27 23:52:17 MainDesktop1 kernel: [31134.056275]
[<ffffffff811bac09>] __perf_event_overflow+0x99/0x230

Jan 27 23:52:17 MainDesktop1 kernel: [31134.056277]
[<ffffffff811b9995>] ? perf_event_update_userpage+0xe5/0x160
Jan 27 23:52:17 MainDesktop1 kernel: [31134.056279]
[<ffffffff811bb724>] perf_event_overflow+0x14/0x20

Jan 27 23:52:17 MainDesktop1 kernel: [31134.056282]
[<ffffffff810578d2>] x86_pmu_handle_irq+0x142/0x190
Jan 27 23:52:17 MainDesktop1 kernel: [31134.056285]
[<ffffffff8234c659>] perf_event_nmi_handler+0x39/0x60

Jan 27 23:52:17 MainDesktop1 kernel: [31134.056287]
[<ffffffff8234bdf3>] nmi_handle.isra.3+0x73/0x1b0
Jan 27 23:52:17 MainDesktop1 kernel: [31134.056290]
[<ffffffff8234c099>] do_nmi+0x169/0x330
Jan 27 23:52:17 MainDesktop1 kernel: [31134.056292]
[<ffffffff8234b417>] end_repeat_nmi+0x1e/0x2e

Jan 27 23:52:17 MainDesktop1 kernel: [31134.056295]
[<ffffffff81145496>] ? __getnstimeofday+0x86/0xc0
Jan 27 23:52:17 MainDesktop1 kernel: [31134.056297]
[<ffffffff81145496>] ? __getnstimeofday+0x86/0xc0

Jan 27 23:52:17 MainDesktop1 kernel: [31134.056300]
[<ffffffff81145496>] ? __getnstimeofday+0x86/0xc0
Jan 27 23:52:17 MainDesktop1 kernel: [31134.056300]  <<EOE>>  <IRQ>
[<ffffffff811454de>] getnstimeofday+0xe/0x30

Jan 27 23:52:17 MainDesktop1 kernel: [31134.056305]
[<ffffffff81145566>] ktime_get_real+0x16/0x50
Jan 27 23:52:17 MainDesktop1 kernel: [31134.056308]
[<ffffffff8201e728>] netif_receive_skb+0x48/0xb0
Jan 27 23:52:17 MainDesktop1 kernel: [31134.056309]
[<ffffffff8201f188>] napi_gro_receive+0x88/0xc0

Jan 27 23:52:17 MainDesktop1 kernel: [31134.056312]
[<ffffffff81bbbeeb>] e1000_receive_skb+0x8b/0x100
Jan 27 23:52:17 MainDesktop1 kernel: [31134.056314]
[<ffffffff81bbd31e>] e1000_clean_rx_irq+0x23e/0x3c0

Jan 27 23:52:17 MainDesktop1 kernel: [31134.056316]
[<ffffffff81bc4e08>] e1000e_poll+0x78/0x300
Jan 27 23:52:17 MainDesktop1 kernel: [31134.056318]
[<ffffffff8201ea49>] net_rx_action+0x129/0x230
Jan 27 23:52:17 MainDesktop1 kernel: [31134.056321]
[<ffffffff810efcfc>] __do_softirq+0xdc/0x2b0

Jan 27 23:52:17 MainDesktop1 kernel: [31134.056323]
[<ffffffff810f0185>] irq_exit+0x75/0x80
Jan 27 23:52:17 MainDesktop1 kernel: [31134.056325]
[<ffffffff82353f83>] do_IRQ+0x63/0xd0
Jan 27 23:52:17 MainDesktop1 kernel: [31134.056328]
[<ffffffff8234aeaa>] common_interrupt+0x6a/0x6a

Jan 27 23:52:17 MainDesktop1 kernel: [31134.056329]  <EOI>
[<ffffffff8104c388>] ? default_idle+0x18/0x100
Jan 27 23:52:17 MainDesktop1 kernel: [31134.056332]
[<ffffffff8104c381>] ? default_idle+0x11/0x100

Jan 27 23:52:17 MainDesktop1 kernel: [31134.056334]
[<ffffffff8104c4b5>] amd_e400_idle+0x45/0xf0
Jan 27 23:52:17 MainDesktop1 kernel: [31134.056335]
[<ffffffff8104cd16>] arch_cpu_idle+0x26/0x30
Jan 27 23:52:17 MainDesktop1 kernel: [31134.056338]
[<ffffffff81137790>] cpu_startup_entry+0xc0/0x2b0

Jan 27 23:52:17 MainDesktop1 kernel: [31134.056340]
[<ffffffff82331c14>] rest_init+0x84/0x90
Jan 27 23:52:17 MainDesktop1 kernel: [31134.056344]
[<ffffffff82fd4ea1>] start_kernel+0x416/0x422
Jan 27 23:52:17 MainDesktop1 kernel: [31134.056346]
[<ffffffff82fd4894>] ? repair_env_string+0x5c/0x5c

Jan 27 23:52:17 MainDesktop1 kernel: [31134.056348]
[<ffffffff82fd45a3>] x86_64_start_reservations+0x2a/0x2c
Jan 27 23:52:17 MainDesktop1 kernel: [31134.056350]
[<ffffffff82fd469b>] x86_64_start_kernel+0xf6/0xf9

Jan 27 23:52:17 MainDesktop1 kernel: [31134.056351] ---[ end trace
4dc51809ef494ff0 ]---
Jan 27 23:52:17 MainDesktop1 kernel: [31134.056353] perf samples too
long (2707 > 2500), lowering kernel.perf_event_max_sample_rate to
50000

Jan 27 23:52:17 MainDesktop1 kernel: [31146.547431] ------------[ cut
here ]------------
Jan 27 23:52:17 MainDesktop1 kernel: [31146.547441] WARNING: CPU: 1
PID: 0 at kernel/watchdog.c:245 watchdog_overflow_callback+0x98/0xc0()

Jan 27 23:52:17 MainDesktop1 kernel: [31146.547442] Watchdog detected
hard LOCKUP on cpu 1
Jan 27 23:52:17 MainDesktop1 kernel: [31146.547444] Modules linked in:
psmouse serio_raw
Jan 27 23:52:17 MainDesktop1 kernel: [31146.547449] CPU: 1 PID: 0
Comm: swapper/1 Tainted: G        W    3.13.0 #2

Jan 27 23:52:17 MainDesktop1 kernel: [31146.547451] Hardware name: To
be filled by O.E.M. To be filled by O.E.M./CROSSHAIR V FORMULA-Z, BIOS
1701 10/28/2013
Jan 27 23:52:17 MainDesktop1 kernel: [31146.547452]  0000000000000009
ffff88064fc86c30 ffffffff8233d7a8 ffff88064fc86c78

Jan 27 23:52:17 MainDesktop1 kernel: [31146.547455]  ffff88064fc86c68
ffffffff810eab3c ffff88062df5c000 0000000000000000
Jan 27 23:52:17 MainDesktop1 kernel: [31146.547457]  ffff88064fc86d80
0000000000000000 ffff88064fc86ef8 ffff88064fc86cc8

Jan 27 23:52:17 MainDesktop1 kernel: [31146.547460] Call Trace:
Jan 27 23:52:17 MainDesktop1 kernel: [31146.547461]  <NMI>
[<ffffffff8233d7a8>] dump_stack+0x4e/0x7a
Jan 27 23:52:17 MainDesktop1 kernel: [31146.547469]
[<ffffffff810eab3c>] warn_slowpath_common+0x8c/0xc0

Jan 27 23:52:17 MainDesktop1 kernel: [31146.547471]
[<ffffffff810eabbc>] warn_slowpath_fmt+0x4c/0x50
Jan 27 23:52:17 MainDesktop1 kernel: [31146.547473]
[<ffffffff81183a60>] ? restart_watchdog_hrtimer+0x50/0x50

Jan 27 23:52:17 MainDesktop1 kernel: [31146.547475]
[<ffffffff81183af8>] watchdog_overflow_callback+0x98/0xc0
Jan 27 23:52:17 MainDesktop1 kernel: [31146.547478]
[<ffffffff811bac09>] __perf_event_overflow+0x99/0x230

Jan 27 23:52:17 MainDesktop1 kernel: [31146.547480]
[<ffffffff811b9995>] ? perf_event_update_userpage+0xe5/0x160
Jan 27 23:52:17 MainDesktop1 kernel: [31146.547482]
[<ffffffff811bb724>] perf_event_overflow+0x14/0x20

Jan 27 23:52:17 MainDesktop1 kernel: [31146.547485]
[<ffffffff810578d2>] x86_pmu_handle_irq+0x142/0x190
Jan 27 23:52:17 MainDesktop1 kernel: [31146.547488]
[<ffffffff8234c659>] perf_event_nmi_handler+0x39/0x60

Jan 27 23:52:17 MainDesktop1 kernel: [31146.547490]
[<ffffffff8234bdf3>] nmi_handle.isra.3+0x73/0x1b0
Jan 27 23:52:17 MainDesktop1 kernel: [31146.547493]
[<ffffffff8234c008>] do_nmi+0xd8/0x330
Jan 27 23:52:17 MainDesktop1 kernel: [31146.547495]
[<ffffffff8234b417>] end_repeat_nmi+0x1e/0x2e

Jan 27 23:52:17 MainDesktop1 kernel: [31146.547498]
[<ffffffff81137832>] ? cpu_startup_entry+0x162/0x2b0
Jan 27 23:52:17 MainDesktop1 kernel: [31146.547500]
[<ffffffff81137832>] ? cpu_startup_entry+0x162/0x2b0

Jan 27 23:52:17 MainDesktop1 kernel: [31146.547502]
[<ffffffff81137832>] ? cpu_startup_entry+0x162/0x2b0
Jan 27 23:52:17 MainDesktop1 kernel: [31146.547503]  <<EOE>>
[<ffffffff81064075>] start_secondary+0x1f5/0x250

Jan 27 23:52:17 MainDesktop1 kernel: [31146.547506] ---[ end trace
4dc51809ef494ff1 ]---
Jan 27 23:52:17 MainDesktop1 kernel: [31164.364831] ------------[ cut
here ]------------
Jan 27 23:52:17 MainDesktop1 kernel: [31164.364841] WARNING: CPU: 2
PID: 0 at kernel/watchdog.c:245 watchdog_overflow_callback+0x98/0xc0()

Jan 27 23:52:17 MainDesktop1 kernel: [31164.364843] Watchdog detected
hard LOCKUP on cpu 2
Jan 27 23:52:17 MainDesktop1 kernel: [31164.364844] Modules linked in:
psmouse serio_raw
Jan 27 23:52:17 MainDesktop1 kernel: [31164.364850] CPU: 2 PID: 0
Comm: swapper/2 Tainted: G        W    3.13.0 #2

Jan 27 23:52:17 MainDesktop1 kernel: [31164.364851] Hardware name: To
be filled by O.E.M. To be filled by O.E.M./CROSSHAIR V FORMULA-Z, BIOS
1701 10/28/2013
Jan 27 23:52:17 MainDesktop1 kernel: [31164.364853]  0000000000000009
ffff88064fd06c30 ffffffff8233d7a8 ffff88064fd06c78

Jan 27 23:52:17 MainDesktop1 kernel: [31164.364856]  ffff88064fd06c68
ffffffff810eab3c ffff88062df84000 0000000000000000
Jan 27 23:52:17 MainDesktop1 kernel: [31164.364859]  ffff88064fd06d80
0000000000000000 ffff88064fd06ef8 ffff88064fd06cc8

Jan 27 23:52:17 MainDesktop1 kernel: [31164.364861] Call Trace:
Jan 27 23:52:17 MainDesktop1 kernel: [31164.364862]  <NMI>
[<ffffffff8233d7a8>] dump_stack+0x4e/0x7a
Jan 27 23:52:17 MainDesktop1 kernel: [31164.364869]
[<ffffffff810eab3c>] warn_slowpath_common+0x8c/0xc0

Jan 27 23:52:17 MainDesktop1 kernel: [31164.364872]
[<ffffffff810eabbc>] warn_slowpath_fmt+0x4c/0x50
Jan 27 23:52:17 MainDesktop1 kernel: [31164.364874]
[<ffffffff81183a60>] ? restart_watchdog_hrtimer+0x50/0x50

Jan 27 23:52:17 MainDesktop1 kernel: [31164.364876]
[<ffffffff81183af8>] watchdog_overflow_callback+0x98/0xc0
Jan 27 23:52:17 MainDesktop1 kernel: [31164.364879]
[<ffffffff811bac09>] __perf_event_overflow+0x99/0x230

Jan 27 23:52:17 MainDesktop1 kernel: [31164.364881]
[<ffffffff811b9995>] ? perf_event_update_userpage+0xe5/0x160
Jan 27 23:52:17 MainDesktop1 kernel: [31164.364883]
[<ffffffff811bb724>] perf_event_overflow+0x14/0x20

Jan 27 23:52:17 MainDesktop1 kernel: [31164.364887]
[<ffffffff810578d2>] x86_pmu_handle_irq+0x142/0x190
Jan 27 23:52:17 MainDesktop1 rtkit-daemon[5807]: The canary thread is
apparently starving. Taking action.

Jan 27 23:52:17 MainDesktop1 kernel: [31164.364890]
[<ffffffff8234c659>] perf_event_nmi_handler+0x39/0x60
Jan 27 23:52:17 MainDesktop1 rtkit-daemon[5807]: Demoting known
real-time threads.
Jan 27 23:52:17 MainDesktop1 rtkit-daemon[5807]: Successfully demoted
thread 6856 of process 6847 (n/a).

Jan 27 23:52:17 MainDesktop1 kernel: [31164.364892]
[<ffffffff8234bdf3>] nmi_handle.isra.3+0x73/0x1b0
Jan 27 23:52:17 MainDesktop1 rtkit-daemon[5807]: Successfully demoted
thread 6855 of process 6847 (n/a).
Jan 27 23:52:17 MainDesktop1 kernel: [31164.364894]
[<ffffffff8234c008>] do_nmi+0xd8/0x330

Jan 27 23:52:17 MainDesktop1 kernel: [31164.364897]
[<ffffffff8234b417>] end_repeat_nmi+0x1e/0x2e
Jan 27 23:52:17 MainDesktop1 rtkit-daemon[5807]: Successfully demoted
thread 6852 of process 6847 (n/a).
Jan 27 23:52:17 MainDesktop1 kernel: [31164.364900]
[<ffffffff81137832>] ? cpu_startup_entry+0x162/0x2b0

Jan 27 23:52:17 MainDesktop1 rtkit-daemon[5807]: Successfully demoted
thread 6851 of process 6847 (n/a).
Jan 27 23:52:17 MainDesktop1 kernel: [31164.364902]
[<ffffffff81137832>] ? cpu_startup_entry+0x162/0x2b0

Jan 27 23:52:17 MainDesktop1 rtkit-daemon[5807]: Successfully demoted
thread 6848 of process 6847 (n/a).
Jan 27 23:52:17 MainDesktop1 kernel: [31164.364904]
[<ffffffff81137832>] ? cpu_startup_entry+0x162/0x2b0

Jan 27 23:52:17 MainDesktop1 rtkit-daemon[5807]: Successfully demoted
thread 6847 of process 6847 (n/a).
Jan 27 23:52:17 MainDesktop1 kernel: [31164.364905]  <<EOE>>
[<ffffffff81064075>] start_secondary+0x1f5/0x250

Jan 27 23:52:17 MainDesktop1 rtkit-daemon[5807]: Demoted 6 threads.
Jan 27 23:52:17 MainDesktop1 kernel: [31164.364909] ---[ end trace
4dc51809ef494ff2 ]---
Jan 27 23:52:17 MainDesktop1 kernel: [31181.580788] ------------[ cut
here ]------------

Jan 27 23:52:17 MainDesktop1 kernel: [31181.580798] WARNING: CPU: 3
PID: 0 at kernel/watchdog.c:245 watchdog_overflow_callback+0x98/0xc0()
Jan 27 23:52:17 MainDesktop1 kernel: [31181.580800] Watchdog detected
hard LOCKUP on cpu 3

Jan 27 23:52:17 MainDesktop1 kernel: [31181.580801] Modules linked in:
psmouse serio_raw
Jan 27 23:52:17 MainDesktop1 kernel: [31181.580806] CPU: 3 PID: 0
Comm: swapper/3 Tainted: G        W    3.13.0 #2
Jan 27 23:52:17 MainDesktop1 kernel: [31181.580808] Hardware name: To
be filled by O.E.M. To be filled by O.E.M./CROSSHAIR V FORMULA-Z, BIOS
1701 10/28/2013

Jan 27 23:52:17 MainDesktop1 kernel: [31181.580809]  0000000000000009
ffff88064fd86c30 ffffffff8233d7a8 ffff88064fd86c78
Jan 27 23:52:17 MainDesktop1 kernel: [31181.580812]  ffff88064fd86c68
ffffffff810eab3c ffff88062dfd8000 0000000000000000

Jan 27 23:52:17 MainDesktop1 kernel: [31181.580814]  ffff88064fd86d80
0000000000000000 ffff88064fd86ef8 ffff88064fd86cc8
Jan 27 23:52:17 MainDesktop1 kernel: [31181.580817] Call Trace:
Jan 27 23:52:17 MainDesktop1 kernel: [31181.580818]  <NMI>
[<ffffffff8233d7a8>] dump_stack+0x4e/0x7a

Jan 27 23:52:17 MainDesktop1 kernel: [31181.580825]
[<ffffffff810eab3c>] warn_slowpath_common+0x8c/0xc0
Jan 27 23:52:17 MainDesktop1 kernel: [31181.580827]
[<ffffffff810eabbc>] warn_slowpath_fmt+0x4c/0x50

Jan 27 23:52:17 MainDesktop1 kernel: [31181.580830]
[<ffffffff81183a60>] ? restart_watchdog_hrtimer+0x50/0x50
Jan 27 23:52:17 MainDesktop1 kernel: [31181.580832]
[<ffffffff81183af8>] watchdog_overflow_callback+0x98/0xc0

Jan 27 23:52:17 MainDesktop1 kernel: [31181.580835]
[<ffffffff811bac09>] __perf_event_overflow+0x99/0x230
Jan 27 23:52:17 MainDesktop1 kernel: [31181.580837]
[<ffffffff811b9995>] ? perf_event_update_userpage+0xe5/0x160

Jan 27 23:52:17 MainDesktop1 kernel: [31181.580839]
[<ffffffff811bb724>] perf_event_overflow+0x14/0x20
Jan 27 23:52:17 MainDesktop1 kernel: [31181.580842]
[<ffffffff810578d2>] x86_pmu_handle_irq+0x142/0x190

Jan 27 23:52:17 MainDesktop1 kernel: [31181.580845]
[<ffffffff8234c659>] perf_event_nmi_handler+0x39/0x60
Jan 27 23:52:17 MainDesktop1 kernel: [31181.580847]
[<ffffffff8234bdf3>] nmi_handle.isra.3+0x73/0x1b0

Jan 27 23:52:17 MainDesktop1 kernel: [31181.580850]
[<ffffffff8234c008>] do_nmi+0xd8/0x330
Jan 27 23:52:17 MainDesktop1 kernel: [31181.580852]
[<ffffffff8234b417>] end_repeat_nmi+0x1e/0x2e
Jan 27 23:52:17 MainDesktop1 kernel: [31181.580855]
[<ffffffff81137832>] ? cpu_startup_entry+0x162/0x2b0

Jan 27 23:52:17 MainDesktop1 kernel: [31181.580857]
[<ffffffff81137832>] ? cpu_startup_entry+0x162/0x2b0
Jan 27 23:52:17 MainDesktop1 kernel: [31181.580859]
[<ffffffff81137832>] ? cpu_startup_entry+0x162/0x2b0

Jan 27 23:52:17 MainDesktop1 kernel: [31181.580860]  <<EOE>>
[<ffffffff81064075>] start_secondary+0x1f5/0x250
Jan 27 23:52:17 MainDesktop1 kernel: [31181.580864] ---[ end trace
4dc51809ef494ff3 ]---

Jan 27 23:52:17 MainDesktop1 CRON[19287]: (root) CMD (if [ -x
/etc/munin/plugins/apt_all ]; then munin-run apt_all update 7200 12
>/dev/null; elif [ -x /etc/munin/plugins/apt ]; then munin-run apt
update 7200 12 >/dev/null; fi)

Jan 27 23:53:20 MainDesktop1 kernel: [31634.421552] BUG: soft lockup -
CPU#0 stuck for 283s! [swapper/0:0]
Jan 27 23:53:20 MainDesktop1 kernel: [31634.421557] Modules linked in:
psmouse serio_raw
Jan 27 23:53:20 MainDesktop1 kernel: [31634.421563] CPU: 0 PID: 0
Comm: swapper/0 Tainted: G        W    3.13.0 #2

Jan 27 23:53:20 MainDesktop1 kernel: [31634.421564] Hardware name: To
be filled by O.E.M. To be filled by O.E.M./CROSSHAIR V FORMULA-Z, BIOS
1701 10/28/2013
Jan 27 23:53:20 MainDesktop1 kernel: [31634.421566] task:
ffffffff82e11480 ti: ffffffff82e00000 task.ti: ffffffff82e00000

Jan 27 23:53:20 MainDesktop1 kernel: [31634.421568] RIP:
0010:[<ffffffff8104c388>]  [<ffffffff8104c388>]
default_idle+0x18/0x100
Jan 27 23:53:20 MainDesktop1 kernel: [31634.421573] RSP:
0018:ffffffff82e01ed8  EFLAGS: 00000202

Jan 27 23:53:20 MainDesktop1 kernel: [31634.421575] RAX:
0000000000000000 RBX: ffffffff82e01e60 RCX: 0000000000001abd
Jan 27 23:53:20 MainDesktop1 kernel: [31634.421576] RDX:
0000000000000002 RSI: 0000000000000092 RDI: 00000000ffffffff

Jan 27 23:53:20 MainDesktop1 kernel: [31634.421577] RBP:
ffffffff82e01ee8 R08: 0000000000000000 R09: 0000000000000000
Jan 27 23:53:20 MainDesktop1 kernel: [31634.421578] R10:
0000000000000000 R11: 0000000000000000 R12: 0000000000000046

Jan 27 23:53:20 MainDesktop1 kernel: [31634.421579] R13:
ffffffff82e01e50 R14: 0000000000000000 R15: ffff880627b2c748
Jan 27 23:53:20 MainDesktop1 kernel: [31634.421581] FS:
00007fa90f0f8700(0000) GS:ffff88064fc00000(0000)
knlGS:00000000f48b4880

Jan 27 23:53:20 MainDesktop1 kernel: [31634.421582] CS:  0010 DS: 0000
ES: 0000 CR0: 000000008005003b
Jan 27 23:53:20 MainDesktop1 kernel: [31634.421583] CR2:
000000000000000b CR3: 0000000627a49000 CR4: 00000000000007f0

Jan 27 23:53:20 MainDesktop1 kernel: [31634.421584] Stack:
Jan 27 23:53:20 MainDesktop1 kernel: [31634.421585]  ffffffff82e01efc
ffffffff82e01fd8 ffffffff82e01f08 ffffffff8104c4b5
Jan 27 23:53:20 MainDesktop1 kernel: [31634.421588]  0000000082fa8ce0
0000000000000000 ffffffff82e01f18 ffffffff8104cd16

Jan 27 23:53:20 MainDesktop1 kernel: [31634.421590]  ffffffff82e01f68
ffffffff81137790 ffffffff82e01fd8 ffffffff82e01fd8
Jan 27 23:53:20 MainDesktop1 kernel: [31634.421592] Call Trace:
Jan 27 23:53:20 MainDesktop1 kernel: [31634.421596]
[<ffffffff8104c4b5>] amd_e400_idle+0x45/0xf0

Jan 27 23:53:20 MainDesktop1 kernel: [31634.421599]
[<ffffffff8104cd16>] arch_cpu_idle+0x26/0x30
Jan 27 23:53:20 MainDesktop1 kernel: [31634.421602]
[<ffffffff81137790>] cpu_startup_entry+0xc0/0x2b0
Jan 27 23:53:20 MainDesktop1 kernel: [31634.421605]
[<ffffffff82331c14>] rest_init+0x84/0x90

Jan 27 23:53:20 MainDesktop1 kernel: [31634.421609]
[<ffffffff82fd4ea1>] start_kernel+0x416/0x422
Jan 27 23:53:20 MainDesktop1 kernel: [31634.421611]
[<ffffffff82fd4894>] ? repair_env_string+0x5c/0x5c

Jan 27 23:53:20 MainDesktop1 kernel: [31634.421613]
[<ffffffff82fd45a3>] x86_64_start_reservations+0x2a/0x2c
Jan 27 23:53:20 MainDesktop1 kernel: [31634.421615]
[<ffffffff82fd469b>] x86_64_start_kernel+0xf6/0xf9

Jan 27 23:53:20 MainDesktop1 kernel: [31634.421616] Code: a8 18 83 48
89 e5 e8 78 5d 0c 00 5d c3 66 0f 1f 44 00 00 66 66 66 66 90 55 48 89
e5 41 54 53 e8 cf ab 83 00 66 66 66 66 90 fb f4 <e8> c3 ab 83 00 41 89
c4 66 66 66 66 90 5b 41 5c 5d c3 66 0f 1f

Jan 27 23:53:20 MainDesktop1 kernel: [31634.435538] BUG: soft lockup -
CPU#1 stuck for 283s! [swapper/1:0]
Jan 27 23:53:20 MainDesktop1 kernel: [31634.435542] Modules linked in:
psmouse serio_raw
Jan 27 23:53:20 MainDesktop1 kernel: [31634.435547] CPU: 1 PID: 0
Comm: swapper/1 Tainted: G        W    3.13.0 #2

Jan 27 23:53:20 MainDesktop1 kernel: [31634.435548] Hardware name: To
be filled by O.E.M. To be filled by O.E.M./CROSSHAIR V FORMULA-Z, BIOS
1701 10/28/2013
Jan 27 23:53:20 MainDesktop1 kernel: [31634.435551] task:
ffff88062df1c6e0 ti: ffff88062df26000 task.ti: ffff88062df26000

Jan 27 23:53:20 MainDesktop1 kernel: [31634.435552] RIP:
0010:[<ffffffff8104c388>]  [<ffffffff8104c388>]
default_idle+0x18/0x100
Jan 27 23:53:20 MainDesktop1 kernel: [31634.435557] RSP:
0018:ffff88062df27e90  EFLAGS: 00000202

Jan 27 23:53:20 MainDesktop1 kernel: [31634.435558] RAX:
0000000000000001 RBX: ffffffff81065944 RCX: 0000000000001c43
Jan 27 23:53:20 MainDesktop1 kernel: [31634.435559] RDX:
0000000000000002 RSI: 0000000000000086 RDI: 00000000ffffffff

Jan 27 23:53:20 MainDesktop1 kernel: [31634.435561] RBP:
ffff88062df27ea0 R08: 0000000000000000 R09: 0000000000000000
Jan 27 23:53:20 MainDesktop1 kernel: [31634.435562] R10:
0000000000000000 R11: 0000000000000000 R12: ffff88064fc8cbc0

Jan 27 23:53:20 MainDesktop1 kernel: [31634.435563] R13:
0000000000000046 R14: ffff88062df27e08 R15: 0000000000000000
Jan 27 23:53:20 MainDesktop1 kernel: [31634.435564] FS:
00007f8e0435e700(0000) GS:ffff88064fc80000(0000)
knlGS:00000000f354bb40

Jan 27 23:53:20 MainDesktop1 kernel: [31634.435566] CS:  0010 DS: 0000
ES: 0000 CR0: 000000008005003b
Jan 27 23:53:20 MainDesktop1 kernel: [31634.435567] CR2:
000000000000000b CR3: 000000008c8ec000 CR4: 00000000000007e0

Jan 27 23:53:20 MainDesktop1 kernel: [31634.435568] Stack:
Jan 27 23:53:20 MainDesktop1 kernel: [31634.435569]  ffff88062df27eb4
ffff88062df27fd8 ffff88062df27ec0 ffffffff8104c4b5
Jan 27 23:53:20 MainDesktop1 kernel: [31634.435571]  0000000182fa8ce0
0000000000000001 ffff88062df27ed0 ffffffff8104cd16

Jan 27 23:53:20 MainDesktop1 kernel: [31634.435573]  ffff88062df27f20
ffffffff81137790 ffff88062df27fd8 ffff88062df27fd8
Jan 27 23:53:20 MainDesktop1 kernel: [31634.435576] Call Trace:
Jan 27 23:53:20 MainDesktop1 kernel: [31634.435579]
[<ffffffff8104c4b5>] amd_e400_idle+0x45/0xf0

Jan 27 23:53:20 MainDesktop1 kernel: [31634.435582]
[<ffffffff8104cd16>] arch_cpu_idle+0x26/0x30
Jan 27 23:53:20 MainDesktop1 kernel: [31634.435585]
[<ffffffff81137790>] cpu_startup_entry+0xc0/0x2b0
Jan 27 23:53:20 MainDesktop1 kernel: [31634.435587]
[<ffffffff81064075>] start_secondary+0x1f5/0x250

Jan 27 23:53:20 MainDesktop1 kernel: [31634.435589] Code: a8 18 83 48
89 e5 e8 78 5d 0c 00 5d c3 66 0f 1f 44 00 00 66 66 66 66 90 55 48 89
e5 41 54 53 e8 cf ab 83 00 66 66 66 66 90 fb f4 <e8> c3 ab 83 00 41 89
c4 66 66 66 66 90 5b 41 5c 5d c3 66 0f 1f

Jan 27 23:53:20 MainDesktop1 kernel: [31634.449521] BUG: soft lockup -
CPU#2 stuck for 283s! [swapper/2:0]
Jan 27 23:53:20 MainDesktop1 kernel: [31634.449525] Modules linked in:
psmouse serio_raw
Jan 27 23:53:20 MainDesktop1 kernel: [31634.449531] CPU: 2 PID: 0
Comm: swapper/2 Tainted: G        W    3.13.0 #2

Jan 27 23:53:20 MainDesktop1 kernel: [31634.449533] Hardware name: To
be filled by O.E.M. To be filled by O.E.M./CROSSHAIR V FORMULA-Z, BIOS
1701 10/28/2013
Jan 27 23:53:20 MainDesktop1 kernel: [31634.449535] task:
ffff88062df1de80 ti: ffff88062df28000 task.ti: ffff88062df28000

Jan 27 23:53:20 MainDesktop1 kernel: [31634.449536] RIP:
0010:[<ffffffff8234a543>]  [<ffffffff8234a543>]
_raw_spin_unlock_irq+0x13/0x40
Jan 27 23:53:20 MainDesktop1 kernel: [31634.449542] RSP:
0018:ffff88062df29e30  EFLAGS: 00000286

Jan 27 23:53:20 MainDesktop1 kernel: [31634.449544] RAX:
0000000000000002 RBX: ffff88062df29de0 RCX: ffff88064fd0a000
Jan 27 23:53:20 MainDesktop1 kernel: [31634.449545] RDX:
ffff88062df29fd8 RSI: ffff88062df1de80 RDI: 0000000000000001

Jan 27 23:53:20 MainDesktop1 kernel: [31634.449546] RBP:
ffff88062df29e30 R08: ffff88062df28000 R09: 0000000000000000
Jan 27 23:53:20 MainDesktop1 kernel: [31634.449547] R10:
0000000000000000 R11: 0000000000000000 R12: 0000000000000003

Jan 27 23:53:20 MainDesktop1 kernel: [31634.449549] R13:
ffffffff82e1d2c0 R14: ffffffff81145382 R15: ffff88062df29db0
Jan 27 23:53:20 MainDesktop1 kernel: [31634.449550] FS:
00007fa90f8f9700(0000) GS:ffff88064fd00000(0000)
knlGS:00000000f48b4880

Jan 27 23:53:20 MainDesktop1 kernel: [31634.449552] CS:  0010 DS: 0000
ES: 0000 CR0: 000000008005003b
Jan 27 23:53:20 MainDesktop1 kernel: [31634.449553] CR2:
00007fa4c803d000 CR3: 0000000627a49000 CR4: 00000000000007e0

Jan 27 23:53:20 MainDesktop1 kernel: [31634.449554] Stack:
Jan 27 23:53:20 MainDesktop1 kernel: [31634.449555]  ffff88062df29e60
ffffffff81116e4a 0000000000000000 0000000000012d00
Jan 27 23:53:20 MainDesktop1 kernel: [31634.449558]  ffff8806281ea300
ffff880627b8bd48 ffff88062df29ec0 ffffffff82346ab6

Jan 27 23:53:20 MainDesktop1 kernel: [31634.449560]  ffff88062df1de80
ffff88062df29fd8 0000000000012d00 0000000000012d00
Jan 27 23:53:20 MainDesktop1 kernel: [31634.449562] Call Trace:
Jan 27 23:53:20 MainDesktop1 kernel: [31634.449567]
[<ffffffff81116e4a>] finish_task_switch+0x4a/0xe0

Jan 27 23:53:20 MainDesktop1 kernel: [31634.449570]
[<ffffffff82346ab6>] __schedule+0x386/0x7d0
Jan 27 23:53:20 MainDesktop1 kernel: [31634.449572]
[<ffffffff82347403>] schedule_preempt_disabled+0x33/0x80

Jan 27 23:53:20 MainDesktop1 kernel: [31634.449575]
[<ffffffff81137885>] cpu_startup_entry+0x1b5/0x2b0
Jan 27 23:53:20 MainDesktop1 kernel: [31634.449577]
[<ffffffff81064075>] start_secondary+0x1f5/0x250

Jan 27 23:53:20 MainDesktop1 kernel: [31634.449579] Code: 64 1d d0 fe
5d 0f 1f 00 c3 66 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 66 66 66
66 90 55 48 89 e5 66 83 07 01 fb bf 01 00 00 00 <e8> 58 3f 00 00 65 8b
04 25 e0 b7 00 00 85 c0 74 02 5d c3 e8 25

Jan 27 23:53:20 MainDesktop1 kernel: [31634.463513] BUG: soft lockup -
CPU#3 stuck for 283s! [swapper/3:0]
Jan 27 23:53:20 MainDesktop1 kernel: [31634.463517] Modules linked in:
psmouse serio_raw
Jan 27 23:53:20 MainDesktop1 kernel: [31634.463521] CPU: 3 PID: 0
Comm: swapper/3 Tainted: G        W    3.13.0 #2

Jan 27 23:53:20 MainDesktop1 kernel: [31634.463523] Hardware name: To
be filled by O.E.M. To be filled by O.E.M./CROSSHAIR V FORMULA-Z, BIOS
1701 10/28/2013
Jan 27 23:53:20 MainDesktop1 kernel: [31634.463526] task:
ffff88062df30000 ti: ffff88062df2a000 task.ti: ffff88062df2a000

Jan 27 23:53:20 MainDesktop1 kernel: [31634.463527] RIP:
0010:[<ffffffff8104c388>]  [<ffffffff8104c388>]
default_idle+0x18/0x100
Jan 27 23:53:20 MainDesktop1 kernel: [31634.463532] RSP:
0018:ffff88062df2be90  EFLAGS: 00000202

Jan 27 23:53:20 MainDesktop1 kernel: [31634.463534] RAX:
0000000000000003 RBX: ffffffff81065944 RCX: 0000000000001fd8
Jan 27 23:53:20 MainDesktop1 kernel: [31634.463535] RDX:
0000000000000002 RSI: 0000000000000086 RDI: 00000000ffffffff

Jan 27 23:53:20 MainDesktop1 kernel: [31634.463536] RBP:
ffff88062df2bea0 R08: 0000000000000000 R09: 0000000000000000
Jan 27 23:53:20 MainDesktop1 kernel: [31634.463537] R10:
0000000000000000 R11: 0000000000000000 R12: ffff88064fd8cbc0

Jan 27 23:53:20 MainDesktop1 kernel: [31634.463538] R13:
0000000000000046 R14: ffff88062df2be08 R15: ffff88064fd8cbc0
Jan 27 23:53:20 MainDesktop1 kernel: [31634.463540] FS:
00007f8e0435e700(0000) GS:ffff88064fd80000(0000)
knlGS:00000000f48b4880

Jan 27 23:53:20 MainDesktop1 kernel: [31634.463541] CS:  0010 DS: 0000
ES: 0000 CR0: 000000008005003b
Jan 27 23:53:20 MainDesktop1 kernel: [31634.463542] CR2:
000000000000000b CR3: 000000008c8ec000 CR4: 00000000000007e0

Jan 27 23:53:20 MainDesktop1 kernel: [31634.463543] Stack:
Jan 27 23:53:20 MainDesktop1 kernel: [31634.463544]  ffff88062df2beb4
ffff88062df2bfd8 ffff88062df2bec0 ffffffff8104c4b5
Jan 27 23:53:20 MainDesktop1 kernel: [31634.463547]  0000000382fa8ce0
0000000000000003 ffff88062df2bed0 ffffffff8104cd16

Jan 27 23:53:20 MainDesktop1 kernel: [31634.463549]  ffff88062df2bf20
ffffffff81137790 ffff88062df2bfd8 ffff88062df2bfd8
Jan 27 23:53:20 MainDesktop1 kernel: [31634.463551] Call Trace:
Jan 27 23:53:20 MainDesktop1 kernel: [31634.463555]
[<ffffffff8104c4b5>] amd_e400_idle+0x45/0xf0

Jan 27 23:53:20 MainDesktop1 kernel: [31634.463557]
[<ffffffff8104cd16>] arch_cpu_idle+0x26/0x30
Jan 27 23:53:20 MainDesktop1 kernel: [31634.463560]
[<ffffffff81137790>] cpu_startup_entry+0xc0/0x2b0
Jan 27 23:53:20 MainDesktop1 kernel: [31634.463562]
[<ffffffff81064075>] start_secondary+0x1f5/0x250

Jan 27 23:53:20 MainDesktop1 kernel: [31634.463563] Code: a8 18 83 48
89 e5 e8 78 5d 0c 00 5d c3 66 0f 1f 44 00 00 66 66 66 66 90 55 48 89
e5 41 54 53 e8 cf ab 83 00 66 66 66 66 90 fb f4 <e8> c3 ab 83 00 41 89
c4 66 66 66 66 90 5b 41 5c 5d c3 66 0f 1f

Jan 27 23:55:01 MainDesktop1 CRON[19384]: (root) CMD (command -v
debian-sa1 > /dev/null && debian-sa1 1 1)
Jan 27 23:55:01 MainDesktop1 CRON[19386]: (root) CMD (if [ -x
/etc/munin/plugins/apt_all ]; then munin-run apt_all update 7200 12
>/dev/null; elif [ -x /etc/munin/plugins/apt ]; then munin-run apt
update 7200 12 >/dev/null; fi)

Jan 27 23:59:50 MainDesktop1 kernel: [32023.880898] BUG: soft lockup -
CPU#2 stuck for 214s! [swapper/2:0]
Jan 27 23:59:50 MainDesktop1 kernel: [32023.880905] BUG: soft lockup -
CPU#3 stuck for 214s! [swapper/3:0]
Jan 27 23:59:50 MainDesktop1 kernel: [32023.880909] Modules linked in: psmouse

Jan 27 23:59:50 MainDesktop1 kernel: [32023.880909] Modules linked in:
psmouse serio_raw
Jan 27 23:59:50 MainDesktop1 kernel: [32023.880915]  serio_raw
Jan 27 23:59:50 MainDesktop1 kernel: [32023.880920] CPU: 2 PID: 0
Comm: swapper/2 Tainted: G        W    3.13.0 #2

Jan 27 23:59:50 MainDesktop1 kernel: [32023.880921]
Jan 27 23:59:50 MainDesktop1 kernel: [32023.880924] CPU: 3 PID: 0
Comm: swapper/3 Tainted: G        W    3.13.0 #2
Jan 27 23:59:50 MainDesktop1 kernel: [32023.880925] Hardware name: To
be filled by O.E.M. To be filled by O.E.M./CROSSHAIR V FORMULA-Z, BIOS
1701 10/28/2013

Jan 27 23:59:50 MainDesktop1 kernel: [32023.880928] task:
ffff88062df30000 ti: ffff88062df2a000 task.ti: ffff88062df2a000
Jan 27 23:59:50 MainDesktop1 kernel: [32023.880935] RIP:
0010:[<ffffffff8104c388>]  [<ffffffff8104c388>]
default_idle+0x18/0x100

Jan 27 23:59:50 MainDesktop1 kernel: [32023.880939] BUG: soft lockup -
CPU#1 stuck for 214s! [swapper/1:0]
Jan 27 23:59:50 MainDesktop1 kernel: [32023.880941] RSP:
0018:ffff88062df2be90  EFLAGS: 00000202
Jan 27 23:59:50 MainDesktop1 kernel: [32023.880943] RAX:
0000000000000003 RBX: ffffffff8114c90c RCX: 0000000000000020

Jan 27 23:59:50 MainDesktop1 kernel: [32023.880946] RDX:
0000000000000002 RSI: 0000000000000086 RDI: 00000000ffffffff
Jan 27 23:59:50 MainDesktop1 kernel: [32023.880948] RBP:
ffff88062df2bea0 R08: 0000000000000000 R09: 0000000000000000

Jan 27 23:59:50 MainDesktop1 kernel: [32023.880950] Modules linked in:
psmouse serio_raw
Jan 27 23:59:50 MainDesktop1 kernel: [32023.880950] R10:
0000000000000000 R11: 0000000000000000 R12: 0000000000000001
Jan 27 23:59:50 MainDesktop1 kernel: [32023.880953] CPU: 1 PID: 0
Comm: swapper/1 Tainted: G        W    3.13.0 #2

Jan 27 23:59:50 MainDesktop1 kernel: [32023.880955] R13:
00001c1df28dab40 R14: ffffffff82e1d2c0 R15: ffffffff8114bdc6
Jan 27 23:59:50 MainDesktop1 kernel: [32023.880956] Hardware name: To
be filled by O.E.M. To be filled by O.E.M./CROSSHAIR V FORMULA-Z, BIOS
1701 10/28/2013

Jan 27 23:59:50 MainDesktop1 kernel: [32023.880958] FS:
00007fa4cc0ff700(0000) GS:ffff88064fd80000(0000)
knlGS:00000000f48b4880
Jan 27 23:59:50 MainDesktop1 kernel: [32023.880960] task:
ffff88062df1c6e0 ti: ffff88062df26000 task.ti: ffff88062df26000

Jan 27 23:59:50 MainDesktop1 kernel: [32023.880961] CS:  0010 DS: 0000
ES: 0000 CR0: 000000008005003b
Jan 27 23:59:50 MainDesktop1 kernel: [32023.880964] CR2:
00007fa4b72eb000 CR3: 00000005bdf57000 CR4: 00000000000007e0

Jan 27 23:59:50 MainDesktop1 kernel: [32023.880970] RIP:
0010:[<ffffffff8104c388>]  [<ffffffff8104c388>]
default_idle+0x18/0x100
Jan 27 23:59:50 MainDesktop1 kernel: [32023.880970] Stack:
Jan 27 23:59:50 MainDesktop1 kernel: [32023.880972] RSP:
0018:ffff88062df27e90  EFLAGS: 00000202

Jan 27 23:59:50 MainDesktop1 kernel: [32023.880974] RAX:
0000000000000001 RBX: ffffffff81065944 RCX: 0000000000001012
Jan 27 23:59:50 MainDesktop1 kernel: [32023.880977] RDX:
0000000000000002 RSI: 0000000000000086 RDI: 00000000ffffffff

Jan 27 23:59:50 MainDesktop1 kernel: [32023.880979] RBP:
ffff88062df27ea0 R08: 0000000000000000 R09: 0000000000000000
Jan 27 23:59:50 MainDesktop1 kernel: [32023.880981] R10:
0000000000000000 R11: 0000000000000000 R12: ffff88064fc8cbc0

Jan 27 23:59:50 MainDesktop1 kernel: [32023.880982]  ffff88062df2beb4
ffff88062df2bfd8 ffff88062df2bec0 ffffffff8104c4b5
Jan 27 23:59:50 MainDesktop1 kernel: [32023.880983] R13:
0000000000000046 R14: ffff88062df27e08 R15: 0000000000000000

Jan 27 23:59:50 MainDesktop1 kernel: [32023.880986] FS:
00007fcbe45a5700(0000) GS:ffff88064fc80000(0000)
knlGS:00000000f354bb40
Jan 27 23:59:50 MainDesktop1 kernel: [32023.880988] CS:  0010 DS: 0000
ES: 0000 CR0: 000000008005003b

Jan 27 23:59:50 MainDesktop1 kernel: [32023.880990] CR2:
000000000000000b CR3: 0000000433070000 CR4: 00000000000007e0
Jan 27 23:59:50 MainDesktop1 kernel: [32023.880992] Stack:
Jan 27 23:59:50 MainDesktop1 kernel: [32023.880993]  0000000382fa8ce0
0000000000000003 ffff88062df2bed0 ffffffff8104cd16

Jan 27 23:59:50 MainDesktop1 kernel: [32023.880995]  ffff88062df27eb4
Jan 27 23:59:50 MainDesktop1 kernel: [32023.880996]  ffff88062df2bf20
Jan 27 23:59:50 MainDesktop1 kernel: [32023.880997]  ffff88062df27fd8
Jan 27 23:59:50 MainDesktop1 kernel: [32023.880999]  ffffffff81137790

Jan 27 23:59:50 MainDesktop1 kernel: [32023.881000]  ffff88062df27ec0
Jan 27 23:59:50 MainDesktop1 kernel: [32023.881002]  ffff88062df2bfd8
Jan 27 23:59:50 MainDesktop1 kernel: [32023.881002]  ffffffff8104c4b5
Jan 27 23:59:50 MainDesktop1 kernel: [32023.881004]

Jan 27 23:59:50 MainDesktop1 kernel: [32023.881005]  ffff88062df2bfd8
Jan 27 23:59:50 MainDesktop1 kernel: [32023.881007] Call Trace:
Jan 27 23:59:50 MainDesktop1 kernel: [32023.881010]  0000000182fa8ce0
0000000000000001 ffff88062df27ed0

Jan 27 23:59:50 MainDesktop1 kernel: [32023.881013]
[<ffffffff8104c4b5>] amd_e400_idle+0x45/0xf0
Jan 27 23:59:50 MainDesktop1 kernel: [32023.881015]  ffffffff8104cd16
Jan 27 23:59:50 MainDesktop1 kernel: [32023.881018]
[<ffffffff8104cd16>] arch_cpu_idle+0x26/0x30

Jan 27 23:59:50 MainDesktop1 kernel: [32023.881020]  ffff88062df27f20
ffffffff81137790
Jan 27 23:59:50 MainDesktop1 kernel: [32023.881024]
[<ffffffff81137790>] cpu_startup_entry+0xc0/0x2b0
Jan 27 23:59:50 MainDesktop1 kernel: [32023.881026]  ffff88062df27fd8
ffff88062df27fd8

Jan 27 23:59:50 MainDesktop1 kernel: [32023.881027]
Jan 27 23:59:50 MainDesktop1 kernel: [32023.881030]
[<ffffffff81064075>] start_secondary+0x1f5/0x250
Jan 27 23:59:50 MainDesktop1 kernel: [32023.881031] Call Trace:

Jan 27 23:59:50 MainDesktop1 kernel: [32023.881034] Code:
Jan 27 23:59:50 MainDesktop1 kernel: [32023.881037]
[<ffffffff8104c4b5>] amd_e400_idle+0x45/0xf0
Jan 27 23:59:50 MainDesktop1 kernel: [32023.881039] a8 18

Jan 27 23:59:50 MainDesktop1 kernel: [32023.881042]
[<ffffffff8104cd16>] arch_cpu_idle+0x26/0x30
Jan 27 23:59:50 MainDesktop1 kernel: [32023.881043] 83 48
Jan 27 23:59:50 MainDesktop1 kernel: [32023.881048]
[<ffffffff81137790>] cpu_startup_entry+0xc0/0x2b0

Jan 27 23:59:50 MainDesktop1 kernel: [32023.881049] 89 e5
Jan 27 23:59:50 MainDesktop1 kernel: [32023.881053]
[<ffffffff81064075>] start_secondary+0x1f5/0x250
Jan 27 23:59:50 MainDesktop1 kernel: [32023.881056] e8 78 5d

Jan 27 23:59:50 MainDesktop1 kernel: [32023.881057] Code:
Jan 27 23:59:50 MainDesktop1 kernel: [32023.881058] 0c
Jan 27 23:59:50 MainDesktop1 kernel: [32023.881060] a8
Jan 27 23:59:50 MainDesktop1 kernel: [32023.881061] 00

Jan 27 23:59:50 MainDesktop1 kernel: [32023.881062] 18
Jan 27 23:59:50 MainDesktop1 kernel: [32023.881063] 5d
Jan 27 23:59:50 MainDesktop1 kernel: [32023.881064] 83
Jan 27 23:59:50 MainDesktop1 kernel: [32023.881065] c3

Jan 27 23:59:50 MainDesktop1 kernel: [32023.881067] 48
Jan 27 23:59:50 MainDesktop1 kernel: [32023.881067] 66
Jan 27 23:59:50 MainDesktop1 kernel: [32023.881069] 89
Jan 27 23:59:50 MainDesktop1 kernel: [32023.881070] 0f

Jan 27 23:59:50 MainDesktop1 kernel: [32023.881071] e5
Jan 27 23:59:50 MainDesktop1 kernel: [32023.881072] 1f
Jan 27 23:59:50 MainDesktop1 kernel: [32023.881073] e8
Jan 27 23:59:50 MainDesktop1 kernel: [32023.881074] 44

Jan 27 23:59:50 MainDesktop1 kernel: [32023.881076] 78
Jan 27 23:59:50 MainDesktop1 kernel: [32023.881077] 00
Jan 27 23:59:50 MainDesktop1 kernel: [32023.881078] 5d
Jan 27 23:59:50 MainDesktop1 kernel: [32023.881079] 00

Jan 27 23:59:50 MainDesktop1 kernel: [32023.881081] 0c
Jan 27 23:59:50 MainDesktop1 kernel: [32023.881081] 66
Jan 27 23:59:50 MainDesktop1 kernel: [32023.881083] 00
Jan 27 23:59:50 MainDesktop1 kernel: [32023.881084] 66

Jan 27 23:59:50 MainDesktop1 kernel: [32023.881085] 5d
Jan 27 23:59:50 MainDesktop1 kernel: [32023.881086] 66
Jan 27 23:59:50 MainDesktop1 kernel: [32023.881087] c3
Jan 27 23:59:50 MainDesktop1 kernel: [32023.881088] 66

Jan 27 23:59:50 MainDesktop1 kernel: [32023.881090] 66
Jan 27 23:59:50 MainDesktop1 kernel: [32023.881091] 90
Jan 27 23:59:50 MainDesktop1 kernel: [32023.881092] 0f
Jan 27 23:59:50 MainDesktop1 kernel: [32023.881093] 55

Jan 27 23:59:50 MainDesktop1 kernel: [32023.881095] 1f
Jan 27 23:59:50 MainDesktop1 rtkit-daemon[5807]: The canary thread is
apparently starving. Taking action.
Jan 27 23:59:50 MainDesktop1 rtkit-daemon[5807]: Demoting known
real-time threads.

Jan 27 23:59:50 MainDesktop1 rtkit-daemon[5807]: Successfully demoted
thread 6856 of process 6847 (n/a).
Jan 27 23:59:50 MainDesktop1 rtkit-daemon[5807]: Successfully demoted
thread 6855 of process 6847 (n/a).
Jan 27 23:59:50 MainDesktop1 rtkit-daemon[5807]: Successfully demoted
thread 6852 of process 6847 (n/a).

Jan 27 23:59:50 MainDesktop1 rtkit-daemon[5807]: Successfully demoted
thread 6851 of process 6847 (n/a).
Jan 27 23:59:50 MainDesktop1 rtkit-daemon[5807]: Successfully demoted
thread 6848 of process 6847 (n/a).
Jan 27 23:59:50 MainDesktop1 rtkit-daemon[5807]: Successfully demoted
thread 6847 of process 6847 (n/a).

Jan 27 23:59:50 MainDesktop1 rtkit-daemon[5807]: Demoted 6 threads.
Jan 27 23:59:50 MainDesktop1 kernel: [32023.881095] 48
Jan 27 23:59:50 MainDesktop1 kernel: [32023.881097] 44
Jan 27 23:59:50 MainDesktop1 kernel: [32023.881098] 89

Jan 27 23:59:50 MainDesktop1 kernel: [32023.881099] 00
Jan 27 23:59:50 MainDesktop1 kernel: [32023.881100] e5
Jan 27 23:59:50 MainDesktop1 kernel: [32023.881101] 00
Jan 27 23:59:50 MainDesktop1 kernel: [32023.881102] 41

Jan 27 23:59:50 MainDesktop1 kernel: [32023.881104] 66
Jan 27 23:59:50 MainDesktop1 kernel: [32023.881105] 54
Jan 27 23:59:50 MainDesktop1 kernel: [32023.881106] 66
Jan 27 23:59:50 MainDesktop1 kernel: [32023.881107] 53

Jan 27 23:59:50 MainDesktop1 kernel: [32023.881108] 66
Jan 27 23:59:50 MainDesktop1 kernel: [32023.881109] e8
Jan 27 23:59:50 MainDesktop1 kernel: [32023.881111] 66
Jan 27 23:59:50 MainDesktop1 kernel: [32023.881111] cf

Jan 27 23:59:50 MainDesktop1 kernel: [32023.881113] 90
Jan 27 23:59:50 MainDesktop1 kernel: [32023.881114] ab
Jan 27 23:59:50 MainDesktop1 kernel: [32023.881115] 55
Jan 27 23:59:50 MainDesktop1 kernel: [32023.881116] 83

Jan 27 23:59:50 MainDesktop1 kernel: [32023.881117] 48
Jan 27 23:59:50 MainDesktop1 kernel: [32023.881118] 00
Jan 27 23:59:50 MainDesktop1 kernel: [32023.881120] 89
Jan 27 23:59:50 MainDesktop1 kernel: [32023.881120] 66

Jan 27 23:59:50 MainDesktop1 kernel: [32023.881122] e5
Jan 27 23:59:50 MainDesktop1 kernel: [32023.881123] 66
Jan 27 23:59:50 MainDesktop1 kernel: [32023.881124] 41
Jan 27 23:59:50 MainDesktop1 kernel: [32023.881125] 66

Jan 27 23:59:50 MainDesktop1 kernel: [32023.881126] 54
Jan 27 23:59:50 MainDesktop1 kernel: [32023.881127] 66
Jan 27 23:59:50 MainDesktop1 kernel: [32023.881129] 53
Jan 27 23:59:50 MainDesktop1 kernel: [32023.881129] 90

Jan 27 23:59:50 MainDesktop1 kernel: [32023.881131] e8
Jan 27 23:59:50 MainDesktop1 kernel: [32023.881132] fb
Jan 27 23:59:50 MainDesktop1 kernel: [32023.881133] cf
Jan 27 23:59:50 MainDesktop1 kernel: [32023.881134] f4

Jan 27 23:59:50 MainDesktop1 kernel: [32023.881136] ab
Jan 27 23:59:50 MainDesktop1 kernel: [32023.881136] <e8>
Jan 27 23:59:50 MainDesktop1 kernel: [32023.881138] 83
Jan 27 23:59:50 MainDesktop1 kernel: [32023.881139] c3

Jan 27 23:59:50 MainDesktop1 kernel: [32023.881140] 00
Jan 27 23:59:50 MainDesktop1 kernel: [32023.881141] ab
Jan 27 23:59:50 MainDesktop1 kernel: [32023.881142] 66
Jan 27 23:59:50 MainDesktop1 kernel: [32023.881143] 83

Jan 27 23:59:50 MainDesktop1 kernel: [32023.881145] 66
Jan 27 23:59:50 MainDesktop1 kernel: [32023.881146] 00
Jan 27 23:59:50 MainDesktop1 kernel: [32023.881147] 66
Jan 27 23:59:50 MainDesktop1 kernel: [32023.881148] 41

Jan 27 23:59:50 MainDesktop1 kernel: [32023.881149] 66
Jan 27 23:59:50 MainDesktop1 kernel: [32023.881150] 89
Jan 27 23:59:50 MainDesktop1 kernel: [32023.881152] 90
Jan 27 23:59:50 MainDesktop1 kernel: [32023.881152] c4

Jan 27 23:59:50 MainDesktop1 kernel: [32023.881154] fb
Jan 27 23:59:50 MainDesktop1 kernel: [32023.881155] 66
Jan 27 23:59:50 MainDesktop1 kernel: [32023.881156] f4
Jan 27 23:59:50 MainDesktop1 kernel: [32023.881157] 66

Jan 27 23:59:50 MainDesktop1 kernel: [32023.881158] <e8>
Jan 27 23:59:50 MainDesktop1 kernel: [32023.881159] 66
Jan 27 23:59:50 MainDesktop1 kernel: [32023.881161] c3
Jan 27 23:59:50 MainDesktop1 kernel: [32023.881162] 66

Jan 27 23:59:50 MainDesktop1 kernel: [32023.881163] ab
Jan 27 23:59:50 MainDesktop1 kernel: [32023.881164] 90
Jan 27 23:59:50 MainDesktop1 kernel: [32023.881166] 83
Jan 27 23:59:50 MainDesktop1 kernel: [32023.881166] 5b

Jan 27 23:59:50 MainDesktop1 kernel: [32023.881168] 00
Jan 27 23:59:50 MainDesktop1 kernel: [32023.881169] 41
Jan 27 23:59:50 MainDesktop1 kernel: [32023.881170] 41
Jan 27 23:59:50 MainDesktop1 kernel: [32023.881171] 5c

Jan 27 23:59:50 MainDesktop1 kernel: [32023.881172] 89
Jan 27 23:59:50 MainDesktop1 kernel: [32023.881173] 5d
Jan 27 23:59:50 MainDesktop1 kernel: [32023.881175] c4
Jan 27 23:59:50 MainDesktop1 kernel: [32023.881176] c3

Jan 27 23:59:50 MainDesktop1 kernel: [32023.881177] 66
Jan 27 23:59:50 MainDesktop1 kernel: [32023.881178] 66
Jan 27 23:59:50 MainDesktop1 kernel: [32023.881179] 66
Jan 27 23:59:50 MainDesktop1 kernel: [32023.881180] 0f

Jan 27 23:59:50 MainDesktop1 kernel: [32023.881182] 66
Jan 27 23:59:50 MainDesktop1 kernel: [32023.881182] 1f
Jan 27 23:59:50 MainDesktop1 kernel: [32023.881184]
Jan 27 23:59:50 MainDesktop1 kernel: [32023.881193] 66 90 5b 41 5c 5d
c3 66 0f 1f

Jan 27 23:59:50 MainDesktop1 kernel: [32023.881218] Hardware name: To
be filled by O.E.M. To be filled by O.E.M./CROSSHAIR V FORMULA-Z, BIOS
1701 10/28/2013
Jan 27 23:59:50 MainDesktop1 kernel: [32023.881220] task:
ffff88062df1de80 ti: ffff88062df28000 task.ti: ffff88062df28000

Jan 27 23:59:50 MainDesktop1 kernel: [32023.881221] RIP:
0010:[<ffffffff8104c388>]  [<ffffffff8104c388>]
default_idle+0x18/0x100
Jan 27 23:59:50 MainDesktop1 kernel: [32023.881227] RSP:
0018:ffff88062df29e90  EFLAGS: 00000202

Jan 27 23:59:50 MainDesktop1 kernel: [32023.881229] RAX:
0000000000000002 RBX: ffffffff8114c90c RCX: 0000000000000020
Jan 27 23:59:50 MainDesktop1 kernel: [32023.881230] RDX:
0000000000000002 RSI: 0000000000000086 RDI: 00000000ffffffff

Jan 27 23:59:50 MainDesktop1 kernel: [32023.881231] RBP:
ffff88062df29ea0 R08: 0000000000000000 R09: 0000000000000000
Jan 27 23:59:50 MainDesktop1 kernel: [32023.881232] R10:
0000000000000000 R11: 0000000000000000 R12: 0000000000000001

Jan 27 23:59:50 MainDesktop1 kernel: [32023.881234] R13:
00001c1df2813865 R14: ffffffff82e1d2c0 R15: ffffffff8114bdc6
Jan 27 23:59:50 MainDesktop1 kernel: [32023.881235] FS:
00007f8e0435e700(0000) GS:ffff88064fd00000(0000)
knlGS:00000000f48b4880

Jan 27 23:59:50 MainDesktop1 kernel: [32023.881236] CS:  0010 DS: 0000
ES: 0000 CR0: 000000008005003b
Jan 27 23:59:50 MainDesktop1 kernel: [32023.881238] CR2:
000000000000000b CR3: 000000008c8ec000 CR4: 00000000000007e0

Jan 27 23:59:50 MainDesktop1 kernel: [32023.881239] Stack:
Jan 27 23:59:50 MainDesktop1 kernel: [32023.881240]  ffff88062df29eb4
ffff88062df29fd8 ffff88062df29ec0 ffffffff8104c4b5
Jan 27 23:59:50 MainDesktop1 kernel: [32023.881243]  0000000282fa8ce0
0000000000000002 ffff88062df29ed0 ffffffff8104cd16

Jan 27 23:59:50 MainDesktop1 kernel: [32023.881245]  ffff88062df29f20
ffffffff81137790 ffff88062df29fd8 ffff88062df29fd8
Jan 27 23:59:50 MainDesktop1 kernel: [32023.881247] Call Trace:
Jan 27 23:59:50 MainDesktop1 kernel: [32023.881252]
[<ffffffff8104c4b5>] amd_e400_idle+0x45/0xf0

Jan 27 23:59:50 MainDesktop1 kernel: [32023.881254]
[<ffffffff8104cd16>] arch_cpu_idle+0x26/0x30
Jan 27 23:59:50 MainDesktop1 kernel: [32023.881258]
[<ffffffff81137790>] cpu_startup_entry+0xc0/0x2b0
Jan 27 23:59:50 MainDesktop1 kernel: [32023.881260]
[<ffffffff81064075>] start_secondary+0x1f5/0x250

Jan 27 23:59:50 MainDesktop1 kernel: [32023.881262] Code: a8 18 83 48
89 e5 e8 78 5d 0c 00 5d c3 66 0f 1f 44 00 00 66 66 66 66 90 55 48 89
e5 41 54 53 e8 cf ab 83 00 66 66 66 66 90 fb f4 <e8> c3 ab 83 00 41 89
c4 66 66 66 66 90 5b 41 5c 5d c3 66 0f 1f

Jan 27 23:59:50 MainDesktop1 kernel: [32023.881296] BUG: soft lockup -
CPU#0 stuck for 214s! [swapper/0:0]
Jan 27 23:59:50 MainDesktop1 kernel: [32023.881301] Modules linked in:
psmouse serio_raw
Jan 27 23:59:50 MainDesktop1 kernel: [32023.881306] CPU: 0 PID: 0
Comm: swapper/0 Tainted: G        W    3.13.0 #2

Jan 27 23:59:50 MainDesktop1 kernel: [32023.881308] Hardware name: To
be filled by O.E.M. To be filled by O.E.M./CROSSHAIR V FORMULA-Z, BIOS
1701 10/28/2013
Jan 27 23:59:50 MainDesktop1 kernel: [32023.881311] task:
ffffffff82e11480 ti: ffffffff82e00000 task.ti: ffffffff82e00000

Jan 27 23:59:50 MainDesktop1 kernel: [32023.881312] RIP:
0010:[<ffffffff82082853>]  [<ffffffff82082853>]
nf_hook_slow+0x43/0x120
Jan 27 23:59:50 MainDesktop1 kernel: [32023.881318] RSP:
0018:ffff88064fc03830  EFLAGS: 00000212

Jan 27 23:59:50 MainDesktop1 kernel: [32023.881319] RAX:
0000000000000140 RBX: ffffffff820c11d0 RCX: 0000000000000002
Jan 27 23:59:50 MainDesktop1 kernel: [32023.881320] RDX:
0000000000000002 RSI: 0000000000000004 RDI: 0000000000000002

Jan 27 23:59:50 MainDesktop1 kernel: [32023.881322] RBP:
ffff88064fc03888 R08: ffff8806294d2000 R09: ffffffff820c2160
Jan 27 23:59:50 MainDesktop1 kernel: [32023.881323] R10:
0000000000000000 R11: ffff8806294d2000 R12: ffff88064fc037a8

Jan 27 23:59:50 MainDesktop1 kernel: [32023.881324] R13:
ffffffff82352f0a R14: ffff88064fc03888 R15: 0000000000000004
Jan 27 23:59:50 MainDesktop1 kernel: [32023.881326] FS:
00007f473dbbea40(0000) GS:ffff88064fc00000(0000)
knlGS:00000000f48b4880

Jan 27 23:59:50 MainDesktop1 kernel: [32023.881327] CS:  0010 DS: 0000
ES: 0000 CR0: 000000008005003b
Jan 27 23:59:50 MainDesktop1 kernel: [32023.881328] CR2:
00007fa3dad66019 CR3: 0000000405993000 CR4: 00000000000007f0

Jan 27 23:59:50 MainDesktop1 kernel: [32023.881329] Stack:
Jan 27 23:59:50 MainDesktop1 kernel: [32023.881330]  ffffffff820828ef
ffffffff820c11d0 0000000280000000 00000002c3c89000
Jan 27 23:59:50 MainDesktop1 kernel: [32023.881333]  ffff8806294d2000
ffff8806294d2000 ffff8801c3c89200 ffff8805167cb504

Jan 27 23:59:50 MainDesktop1 kernel: [32023.881335]  ffff8804bc14e900
0000000000000000 ffff880526d530c0 ffff88064fc038a8
Jan 27 23:59:50 MainDesktop1 kernel: [32023.881337] Call Trace:
Jan 27 23:59:50 MainDesktop1 kernel: [32023.881339]  <IRQ>

Jan 27 23:59:50 MainDesktop1 kernel: [32023.881340]
[<ffffffff820828ef>] ? nf_hook_slow+0xdf/0x120
Jan 27 23:59:50 MainDesktop1 kernel: [32023.881345]
[<ffffffff820c11d0>] ? ip_forward_options+0x1c0/0x1c0

Jan 27 23:59:50 MainDesktop1 kernel: [32023.881348]
[<ffffffff820c37f2>] ip_output+0x82/0x90
Jan 27 23:59:50 MainDesktop1 kernel: [32023.881350]
[<ffffffff820c2f15>] ip_local_out+0x25/0x30
Jan 27 23:59:50 MainDesktop1 kernel: [32023.881352]
[<ffffffff820c3084>] ip_build_and_send_pkt+0x164/0x220

Jan 27 23:59:50 MainDesktop1 kernel: [32023.881354]
[<ffffffff820e17a7>] tcp_v4_conn_request+0x6a7/0xcf0
Jan 27 23:59:50 MainDesktop1 kernel: [32023.881358]
[<ffffffff822f7c0b>] ? netlbl_unlabel_getattr+0x4b/0x120

Jan 27 23:59:50 MainDesktop1 kernel: [32023.881361]
[<ffffffff820d70e0>] tcp_rcv_state_process+0x1b0/0xdf0
Jan 27 23:59:50 MainDesktop1 kernel: [32023.881363]
[<ffffffff820c720b>] ? __inet_lookup_established+0xdb/0x140

Jan 27 23:59:50 MainDesktop1 kernel: [32023.881365]
[<ffffffff820e0570>] tcp_v4_do_rcv+0x2a0/0x490
Jan 27 23:59:50 MainDesktop1 kernel: [32023.881367]
[<ffffffff820e277f>] tcp_v4_rcv+0x74f/0x770
Jan 27 23:59:50 MainDesktop1 kernel: [32023.881370]
[<ffffffff820bdeb0>] ? ip_rcv_finish+0x350/0x350

Jan 27 23:59:50 MainDesktop1 kernel: [32023.881373]
[<ffffffff820bdf38>] ip_local_deliver_finish+0x88/0x1e0
Jan 27 23:59:50 MainDesktop1 kernel: [32023.881374]
[<ffffffff820be218>] ip_local_deliver+0x48/0x80

Jan 27 23:59:50 MainDesktop1 kernel: [32023.881377]
[<ffffffff820bdbe8>] ip_rcv_finish+0x88/0x350
Jan 27 23:59:50 MainDesktop1 kernel: [32023.881378]
[<ffffffff820be4f0>] ip_rcv+0x2a0/0x3d0
Jan 27 23:59:50 MainDesktop1 kernel: [32023.881381]
[<ffffffff8201e47e>] __netif_receive_skb_core+0x64e/0x840

Jan 27 23:59:50 MainDesktop1 kernel: [32023.881383]
[<ffffffff8201e691>] __netif_receive_skb+0x21/0x70
Jan 27 23:59:50 MainDesktop1 kernel: [32023.881385]
[<ffffffff8201e703>] netif_receive_skb+0x23/0xb0

Jan 27 23:59:50 MainDesktop1 kernel: [32023.881388]
[<ffffffff82196a6a>] br_handle_frame_finish+0x1fa/0x3e0
Jan 27 23:59:50 MainDesktop1 kernel: [32023.881390]
[<ffffffff82196dd5>] br_handle_frame+0x185/0x260

Jan 27 23:59:50 MainDesktop1 kernel: [32023.881392]
[<ffffffff8201e06a>] __netif_receive_skb_core+0x23a/0x840
Jan 27 23:59:50 MainDesktop1 kernel: [32023.881394]
[<ffffffff8201e691>] __netif_receive_skb+0x21/0x70

Jan 27 23:59:50 MainDesktop1 kernel: [32023.881396]
[<ffffffff8201e703>] netif_receive_skb+0x23/0xb0
Jan 27 23:59:50 MainDesktop1 kernel: [32023.881398]
[<ffffffff8201f188>] napi_gro_receive+0x88/0xc0

Jan 27 23:59:50 MainDesktop1 kernel: [32023.881401]
[<ffffffff81bbbeeb>] e1000_receive_skb+0x8b/0x100
Jan 27 23:59:50 MainDesktop1 kernel: [32023.881403]
[<ffffffff81bbd31e>] e1000_clean_rx_irq+0x23e/0x3c0

Jan 27 23:59:50 MainDesktop1 kernel: [32023.881405]
[<ffffffff81bc4e08>] e1000e_poll+0x78/0x300
Jan 27 23:59:50 MainDesktop1 kernel: [32023.881407]
[<ffffffff8201ea49>] net_rx_action+0x129/0x230
Jan 27 23:59:50 MainDesktop1 kernel: [32023.881411]
[<ffffffff810efcfc>] __do_softirq+0xdc/0x2b0

Jan 27 23:59:50 MainDesktop1 kernel: [32023.881413]
[<ffffffff810f0185>] irq_exit+0x75/0x80
Jan 27 23:59:50 MainDesktop1 kernel: [32023.881416]
[<ffffffff82353f83>] do_IRQ+0x63/0xd0
Jan 27 23:59:50 MainDesktop1 kernel: [32023.881419]
[<ffffffff8234aeaa>] common_interrupt+0x6a/0x6a

Jan 27 23:59:50 MainDesktop1 kernel: [32023.881420]  <EOI>
Jan 27 23:59:50 MainDesktop1 kernel: [32023.881421]
[<ffffffff8104c388>] ? default_idle+0x18/0x100
Jan 27 23:59:50 MainDesktop1 kernel: [32023.881425]
[<ffffffff8104c381>] ? default_idle+0x11/0x100

Jan 27 23:59:50 MainDesktop1 kernel: [32023.881426]
[<ffffffff8104c4b5>] amd_e400_idle+0x45/0xf0
Jan 27 23:59:50 MainDesktop1 kernel: [32023.881428]
[<ffffffff8104cd16>] arch_cpu_idle+0x26/0x30
Jan 27 23:59:50 MainDesktop1 kernel: [32023.881431]
[<ffffffff81137790>] cpu_startup_entry+0xc0/0x2b0

Jan 27 23:59:50 MainDesktop1 kernel: [32023.881434]
[<ffffffff82331c14>] rest_init+0x84/0x90
Jan 27 23:59:50 MainDesktop1 kernel: [32023.881437]
[<ffffffff82fd4ea1>] start_kernel+0x416/0x422
Jan 27 23:59:50 MainDesktop1 kernel: [32023.881439]
[<ffffffff82fd4894>] ? repair_env_string+0x5c/0x5c

Jan 27 23:59:50 MainDesktop1 kernel: [32023.881442]
[<ffffffff82fd45a3>] x86_64_start_reservations+0x2a/0x2c
Jan 27 23:59:50 MainDesktop1 kernel: [32023.881444]
[<ffffffff82fd469b>] x86_64_start_kernel+0xf6/0xf9

Jan 27 23:59:50 MainDesktop1 kernel: [32023.881444] Code: 41 54 49 89
d4 53 89 f3 48 83 ec 30 4c 89 45 c8 e8 e3 b2 0b ff 41 0f b6 c6 89 c1
89 45 bc 89 d8 48 63 d1 48 8d 04 d0 48 c1 e0 04 <48> 05 40 0f fb 82 48
89 45 c0 48 89 45 d0 0f 1f 80 00 00 00 00

Jan 27 23:59:50 MainDesktop1 kernel: [32023.882617] Hangcheck:
hangcheck value past margin!






Jan 25 12:26:02 MainDesktop1 rtkit-daemon[5815]: The canary thread is
apparently starving. Taking action.

Jan 25 12:26:02 MainDesktop1 rtkit-daemon[5815]: Demoting known
real-time threads.
Jan 25 12:26:02 MainDesktop1 rtkit-daemon[5815]: Successfully demoted
thread 6914 of process 6890 (n/a).
Jan 25 12:26:02 MainDesktop1 rtkit-daemon[5815]: Successfully demoted
thread 6913 of process 6890 (n/a).

Jan 25 12:26:02 MainDesktop1 rtkit-daemon[5815]: Successfully demoted
thread 6906 of process 6890 (n/a).
Jan 25 12:26:02 MainDesktop1 rtkit-daemon[5815]: Successfully demoted
thread 6905 of process 6890 (n/a).
Jan 25 12:26:02 MainDesktop1 rtkit-daemon[5815]: Successfully demoted
thread 6899 of process 6890 (n/a).

Jan 25 12:26:02 MainDesktop1 rtkit-daemon[5815]: Successfully demoted
thread 6890 of process 6890 (n/a).
Jan 25 12:26:02 MainDesktop1 rtkit-daemon[5815]: Demoted 6 threads.
Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504196] BUG: soft lockup -
CPU#3 stuck for 282s! [swapper/3:0]

Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504200] Modules linked in:
psmouse serio_raw
Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504206] CPU: 3 PID: 0
Comm: swapper/3 Not tainted 3.13.0 #2
Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504207] Hardware name: To
be filled by O.E.M. To be filled by O.E.M./CROSSHAIR V FORMULA-Z, BIOS
1701 10/28/2013

Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504210] task:
ffff88062de30000 ti: ffff88062de2a000 task.ti: ffff88062de2a000
Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504212] RIP:
0010:[<ffffffff8104c388>]  [<ffffffff8104c388>]
default_idle+0x18/0x100

Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504217] RSP:
0018:ffff88062de2be90  EFLAGS: 00000202
Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504218] RAX:
0000000000000003 RBX: ffffffff81065944 RCX: 00000000000042fa

Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504220] RDX:
0000000000000002 RSI: 0000000000000086 RDI: 00000000ffffffff
Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504221] RBP:
ffff88062de2bea0 R08: 0000000000000000 R09: 0000000000000000

Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504222] R10:
0000000000000000 R11: 0000000000000000 R12: ffff88064fd8cbc0
Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504223] R13:
0000000000000046 R14: ffff88062de2be08 R15: 0000000000000000

Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504225] FS:
00007f6833a09700(0000) GS:ffff88064fd80000(0000)
knlGS:00000000f75a0900
Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504226] CS:  0010 DS: 0000
ES: 0000 CR0: 000000008005003b

Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504227] CR2:
00007f33d80c1000 CR3: 00000006289db000 CR4: 00000000000007e0
Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504228] Stack:
Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504229]  ffff88062de2beb4
ffff88062de2bfd8 ffff88062de2bec0 ffffffff8104c4b5

Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504232]  0000000382fa8ce0
0000000000000003 ffff88062de2bed0 ffffffff8104cd16
Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504234]  ffff88062de2bf20
ffffffff81137790 ffff88062de2bfd8 ffff88062de2bfd8

Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504236] Call Trace:
Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504240]
[<ffffffff8104c4b5>] amd_e400_idle+0x45/0xf0
Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504242]
[<ffffffff8104cd16>] arch_cpu_idle+0x26/0x30

Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504246]
[<ffffffff81137790>] cpu_startup_entry+0xc0/0x2b0
Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504248]
[<ffffffff81064075>] start_secondary+0x1f5/0x250

Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504250] Code: a8 18 83 48
89 e5 e8 78 5d 0c 00 5d c3 66 0f 1f 44 00 00 66 66 66 66 90 55 48 89
e5 41 54 53 e8 cf ab 83 00 66 66 66 66 90 fb f4 <e8> c3 ab 83 00 41 89
c4 66 66 66 66 90 5b 41 5c 5d c3 66 0f 1f

Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504299] BUG: soft lockup -
CPU#2 stuck for 282s! [swapper/2:0]
Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504303] BUG: soft lockup -
CPU#1 stuck for 282s! [swapper/1:0]
Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504307] BUG: soft lockup -
CPU#0 stuck for 282s! [swapper/0:0]

Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504312] Modules linked in:
Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504313] Modules linked in:
Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504315]  psmouse
Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504316]  psmouse

Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504318]  serio_raw
Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504319]
Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504320]  serio_raw
Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504323] CPU: 1 PID: 0
Comm: swapper/1 Not tainted 3.13.0 #2

Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504325] CPU: 0 PID: 0
Comm: swapper/0 Not tainted 3.13.0 #2
Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504327] Hardware name: To
be filled by O.E.M. To be filled by O.E.M./CROSSHAIR V FORMULA-Z, BIOS
1701 10/28/2013

Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504328] Hardware name: To
be filled by O.E.M. To be filled by O.E.M./CROSSHAIR V FORMULA-Z, BIOS
1701 10/28/2013
Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504330] task:
ffff88062de1c6e0 ti: ffff88062de26000 task.ti: ffff88062de26000

Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504332] task:
ffffffff82e11480 ti: ffffffff82e00000 task.ti: ffffffff82e00000
Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504335] RIP:
0010:[<ffffffff8104c4c9>]
Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504340]
[<ffffffff8104c4c9>] amd_e400_idle+0x59/0xf0

Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504344] RIP:
0010:[<ffffffff8201ec47>]  [<ffffffff8201ec47>]
dev_gro_receive+0xf7/0x380
Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504346] RSP:
0018:ffff88062de27eb8  EFLAGS: 00000286

Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504347] RSP:
0018:ffff88064fc03d50  EFLAGS: 00000202
Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504349] RAX:
0000000000000001 RBX: ffffffff8234a509 RCX: 0000000000004336

Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504350] RAX:
0000000000000002 RBX: ffff88064fc03cf0 RCX: ffff880560150000
Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504351] RDX:
0000000000000002 RSI: 0000000000000086 RDI: 00000000ffffffff

Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504353] RDX:
00000000000005dc RSI: 000000010008d4b3 RDI: ffff88062c0ec600
Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504354] RBP:
ffff88062de27ec0 R08: 0000000000000000 R09: 0000000000000000

Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504355] RBP:
ffff88064fc03d88 R08: 000000010008d4b3 R09: 0000000000046afa
Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504357] R10:
0000000000000000 R11: 0000000000000000 R12: ffffffff8114bcd9

Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504358] R10:
0000000000000000 R11: 0000000000000b50 R12: ffff88064fc03cc8
Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504360] R13:
ffff88062de27e38 R14: ffffffff81065944 R15: ffff88062de27e18

Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504361] R13:
ffffffff82352f0a R14: ffff88064fc03d88 R15: ffff8804fbb4d300
Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504363] FS:
00007fe008a9e740(0000) GS:ffff88064fc80000(0000)
knlGS:00000000f75a0900

Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504365] FS:
00007fdff39ff700(0000) GS:ffff88064fc00000(0000)
knlGS:0000000000000000
Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504366] CS:  0010 DS: 0000
ES: 0000 CR0: 000000008005003b

Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504367] CS:  0010 DS: 0000
ES: 0000 CR0: 000000008005003b
Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504370] CR2:
00007f1da6823019 CR3: 00000005ba29e000 CR4: 00000000000007e0

Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504371] CR2:
00007f1d3cccc000 CR3: 00000005ba29e000 CR4: 00000000000007f0
Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504372] Stack:
Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504373] Stack:

Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504375]  0000000000000001
Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504376]  000000000000000e
Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504377]  ffff88062de27ed0
Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504379]  ffffffff82fbae88

Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504379]  ffffffff8104cd16
Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504381]  ffff8804fbb4d300
Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504382]  ffff88062de27f20
Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504383]

Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504384]  ffff88061d948ad0
Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504386]  ffffffff81137790
Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504388]  0000000000000000
Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504388]  ffff88062de27fd8

Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504390]  ffff88061d948000
Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504391]  ffff88062de27fd8
Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504393]  0000000000000000
Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504394]  9412f50f732126ae

Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504395]
Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504396]  ffff88064fc03da8
Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504398]  000000000000cb90
Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504399]  ffffffff8201f12e

Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504401]  0000000000000001
Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504402]  ffff8804fbb4d300
Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504403]  0000000000000000
Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504404]  ffff88061d948740

Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504405]  0000000000000000
Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504407]
Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504407]  ffff88064fc03de0
Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504409] Call Trace:

Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504410] Call Trace:
Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504411]  <IRQ>
Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504414]
[<ffffffff8104cd16>] arch_cpu_idle+0x26/0x30

Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504418]
[<ffffffff8201f12e>] napi_gro_receive+0x2e/0xc0
Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504422]
[<ffffffff81137790>] cpu_startup_entry+0xc0/0x2b0

Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504426]
[<ffffffff81bbbeeb>] e1000_receive_skb+0x8b/0x100
Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504429]
[<ffffffff81064075>] start_secondary+0x1f5/0x250

Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504432]
[<ffffffff81bbd31e>] e1000_clean_rx_irq+0x23e/0x3c0
Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504433] Code:
Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504436]
[<ffffffff8201b9f5>] ? dev_kfree_skb_any+0x35/0x40

Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504438] 4b 48
Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504441]
[<ffffffff81bc4e08>] e1000e_poll+0x78/0x300
Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504443] 8d 5d

Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504446]
[<ffffffff8201ea49>] net_rx_action+0x129/0x230
Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504447] f4 48
Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504451]
[<ffffffff810efcfc>] __do_softirq+0xdc/0x2b0

Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504453] 89 de
Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504456]
[<ffffffff810f0185>] irq_exit+0x75/0x80
Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504457] bf 04

Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504462]
[<ffffffff82353f83>] do_IRQ+0x63/0xd0
Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504463] 00 00
Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504467]
[<ffffffff8234aeaa>] common_interrupt+0x6a/0x6a

Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504469] 00 e8
Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504469]  <EOI>
Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504471] 90
Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504474]
[<ffffffff8104c388>] ? default_idle+0x18/0x100

Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504476] f4 0f
Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504478]
[<ffffffff8104c381>] ? default_idle+0x11/0x100
Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504480] 00 e8

Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504482]
[<ffffffff8104c4b5>] amd_e400_idle+0x45/0xf0
Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504484] bb fe
Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504486] Hangcheck:
hangcheck value past margin!

Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504488]
[<ffffffff8104cd16>] arch_cpu_idle+0x26/0x30
Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504490] ff ff
Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504494]
[<ffffffff81137790>] cpu_startup_entry+0xc0/0x2b0

Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504495] fa 48
Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504499]
[<ffffffff82331c14>] rest_init+0x84/0x90
Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504501] 8d 75

Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504505]
[<ffffffff82fd4ea1>] start_kernel+0x416/0x422
Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504506] f4 bf
Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504509]
[<ffffffff82fd4894>] ? repair_env_string+0x5c/0x5c

Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504511] 05 00
Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504514]
[<ffffffff82fd45a3>] x86_64_start_reservations+0x2a/0x2c
Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504516] 00 00

Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504519]
[<ffffffff82fd469b>] x86_64_start_kernel+0xf6/0xf9
Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504520] e8 7c
Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504521] Code:

Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504523] f4
Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504524] 48
Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504525] 0f
Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504526] 03

Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504528] 00
Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504529] 83
Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504530] fb
Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504531] c8

Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504532] 48
Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504533] 00
Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504535] 83
Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504536] 00

Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504537] c4
Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504538] 00
Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504539] 08
Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504540] 44

Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504542] <5b>
Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504543] 8b
Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504544] 5d
Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504545] 60

Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504546] c3
Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504547] 3c
Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504549] 0f
Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504550] 45

Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504551] 1f
Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504552] 85
Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504553] 40
Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504555] e4

Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504556] 00
Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504557] 0f
Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504558] b9
Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504559] 84

Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504561] 55
Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504561] 59
Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504563] 00
Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504564] 02

Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504565] 01
Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504566] 00
Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504567] c0
Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504568] 00

Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504569] 0f
Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504570] 44
Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504572] 32
Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504573] 89

Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504574] a9
Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504575] e8
Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504576] 00
Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504577] 48

Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504578] 00
Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504579] 8b
Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504581] 00
Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504581] 5d

Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504583] 18
Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504584] d8
Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504585] 75
Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504586] 4c

Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504587] 39
Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504588]
Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504620] 8b 65 e0 4c 8b 6d
e8 4c 8b 75 f0 4c 8b 7d f8 <c9> c3 0f 1f 80 00 00 00 00 48 83 7a 08 00
0f 85 4c ff ff ff 8b

Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504633] Modules linked in:
psmouse serio_raw
Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504639] CPU: 2 PID: 0
Comm: swapper/2 Not tainted 3.13.0 #2
Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504641] Hardware name: To
be filled by O.E.M. To be filled by O.E.M./CROSSHAIR V FORMULA-Z, BIOS
1701 10/28/2013

Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504643] task:
ffff88062de1de80 ti: ffff88062de28000 task.ti: ffff88062de28000
Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504645] RIP:
0010:[<ffffffff8104c4c9>]  [<ffffffff8104c4c9>]
amd_e400_idle+0x59/0xf0

Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504651] RSP:
0018:ffff88062de29eb8  EFLAGS: 00000286
Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504652] RAX:
0000000000000001 RBX: ffffffff8234a509 RCX: 0000000000004337

Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504654] RDX:
0000000000000002 RSI: 0000000000000086 RDI: 00000000ffffffff
Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504655] RBP:
ffff88062de29ec0 R08: 0000000000000000 R09: 0000000000000000

Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504656] R10:
0000000000000000 R11: 0000000000000000 R12: ffffffff8114bcd9
Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504657] R13:
ffff88062de29e38 R14: ffffffff81065944 R15: ffff88062de29e18

Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504659] FS:
00007fdfccbff700(0000) GS:ffff88064fd00000(0000)
knlGS:0000000000000000
Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504660] CS:  0010 DS: 0000
ES: 0000 CR0: 000000008005003b

Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504661] CR2:
00007f33d80c1000 CR3: 00000005ba29e000 CR4: 00000000000007e0
Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504662] Stack:
Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504664]  0000000000000002
ffff88062de29ed0 ffffffff8104cd16 ffff88062de29f20

Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504666]  ffffffff81137790
ffff88062de29fd8 ffff88062de29fd8 0f51c052dba8e4e8
Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504668]  000000000000cb90
0000000000000002 0000000000000000 0000000000000000

Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504670] Call Trace:
Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504675]
[<ffffffff8104cd16>] arch_cpu_idle+0x26/0x30
Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504678]
[<ffffffff81137790>] cpu_startup_entry+0xc0/0x2b0

Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504681]
[<ffffffff81064075>] start_secondary+0x1f5/0x250
Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504682] Code: 4b 48 8d 5d
f4 48 89 de bf 04 00 00 00 e8 90 f4 0f 00 e8 bb fe ff ff fa 48 8d 75
f4 bf 05 00 00 00 e8 7c f4 0f 00 fb 48 83 c4 08 <5b> 5d c3 0f 1f 40 00
b9 55 00 01 c0 0f 32 a9 00 00 00 18 75 39

Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.504871] Clocksource tsc
unstable (delta = 299965967964 ns)
Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.509855] TCP: TCP: Possible
SYN flooding on port 9990. Sending cookies.  Check SNMP counters.

Jan 25 12:26:02 MainDesktop1 kernel: [ 1178.513986] Switched to clocksource hpet







Jan 11 03:38:27 MainDesktop1 kernel: [45002.235728] BUG: soft lockup -
CPU#3 stuck for 115s! [swapper/3:0]

Jan 11 03:38:27 MainDesktop1 kernel: [45002.235733] Modules linked in:
psmouse serio_raw
Jan 11 03:38:27 MainDesktop1 kernel: [45002.235738] CPU: 3 PID: 0
Comm: swapper/3 Not tainted 3.13.0-rc7 #1
Jan 11 03:38:27 MainDesktop1 kernel: [45002.235740] Hardware name: To
be filled by O.E.M. To be filled by O.E.M./CROSSHAIR V FORMULA-Z, BIOS
1701 10/28/2013

Jan 11 03:38:27 MainDesktop1 kernel: [45002.235742] task:
ffff88033e628000 ti: ffff88033e622000 task.ti: ffff88033e622000
Jan 11 03:38:27 MainDesktop1 kernel: [45002.235744] RIP:
0010:[<ffffffff8104c388>]  [<ffffffff8104c388>]
default_idle+0x18/0x100

Jan 11 03:38:27 MainDesktop1 kernel: [45002.235749] RSP:
0018:ffff88033e623e90  EFLAGS: 00000202
Jan 11 03:38:27 MainDesktop1 kernel: [45002.235751] RAX:
0000000000000003 RBX: ffffffff8114c86c RCX: 0000000000000020

Jan 11 03:38:27 MainDesktop1 kernel: [45002.235752] RDX:
0000000000000002 RSI: 0000000000000086 RDI: 00000000ffffffff
Jan 11 03:38:27 MainDesktop1 kernel: [45002.235753] RBP:
ffff88033e623ea0 R08: 0000000000000000 R09: 0000000000000000

Jan 11 03:38:27 MainDesktop1 kernel: [45002.235754] R10:
0000000000000000 R11: 0000000000000000 R12: 0000000000000001
Jan 11 03:38:27 MainDesktop1 kernel: [45002.235755] R13:
000025d6f3972d00 R14: ffffffff8321d2c0 R15: ffffffff8114bd26

Jan 11 03:38:27 MainDesktop1 kernel: [45002.235757] FS:
00007f57037faa00(0000) GS:ffff88034fd80000(0000)
knlGS:00000000f31ffb40
Jan 11 03:38:27 MainDesktop1 kernel: [45002.235758] CS:  0010 DS: 0000
ES: 0000 CR0: 000000008005003b

Jan 11 03:38:27 MainDesktop1 kernel: [45002.235760] CR2:
00007f4c12ab8000 CR3: 0000000204ea6000 CR4: 00000000000007e0
Jan 11 03:38:27 MainDesktop1 kernel: [45002.235760] Stack:
Jan 11 03:38:27 MainDesktop1 kernel: [45002.235761]  ffff88033e623eb4
ffff88033e623fd8 ffff88033e623ec0 ffffffff8104c4b5

Jan 11 03:38:27 MainDesktop1 kernel: [45002.235764]  00000003833b7020
0000000000000003 ffff88033e623ed0 ffffffff8104cd16
Jan 11 03:38:27 MainDesktop1 kernel: [45002.235766]  ffff88033e623f20
ffffffff811376f0 ffff88033e623fd8 ffff88033e623fd8

Jan 11 03:38:27 MainDesktop1 kernel: [45002.235768] Call Trace:
Jan 11 03:38:27 MainDesktop1 kernel: [45002.235772]
[<ffffffff8104c4b5>] amd_e400_idle+0x45/0xf0
Jan 11 03:38:27 MainDesktop1 kernel: [45002.235774]
[<ffffffff8104cd16>] arch_cpu_idle+0x26/0x30

Jan 11 03:38:27 MainDesktop1 kernel: [45002.235777]
[<ffffffff811376f0>] cpu_startup_entry+0xc0/0x2b0
Jan 11 03:38:27 MainDesktop1 kernel: [45002.235780]
[<ffffffff81064075>] start_secondary+0x1f5/0x250

Jan 11 03:38:27 MainDesktop1 kernel: [45002.235781] Code: 98 5a 83 48
89 e5 e8 58 5d 0c 00 5d c3 66 0f 1f 44 00 00 66 66 66 66 90 55 48 89
e5 41 54 53 e8 cf c5 83 00 66 66 66 66 90 fb f4 <e8> c3 c5 83 00 41 89
c4 66 66 66 66 90 5b 41 5c 5d c3 66 0f 1f

Jan 11 03:38:27 MainDesktop1 kernel: [45002.235870] BUG: soft lockup -
CPU#2 stuck for 115s! [swapper/2:0]
Jan 11 03:38:27 MainDesktop1 kernel: [45002.235874] BUG: soft lockup -
CPU#1 stuck for 115s! [swapper/1:0]
Jan 11 03:38:27 MainDesktop1 kernel: [45002.235878] BUG: soft lockup -
CPU#0 stuck for 115s! [swapper/0:0]

Jan 11 03:38:27 MainDesktop1 kernel: [45002.235883] Modules linked in:
Jan 11 03:38:27 MainDesktop1 kernel: [45002.235885] Modules linked in:
Jan 11 03:38:27 MainDesktop1 kernel: [45002.235886]  psmouse
Jan 11 03:38:27 MainDesktop1 kernel: [45002.235888]  psmouse

Jan 11 03:38:27 MainDesktop1 kernel: [45002.235889]  serio_raw
Jan 11 03:38:27 MainDesktop1 kernel: [45002.235890]
Jan 11 03:38:27 MainDesktop1 kernel: [45002.235891]  serio_raw
Jan 11 03:38:27 MainDesktop1 kernel: [45002.235894] CPU: 1 PID: 0
Comm: swapper/1 Not tainted 3.13.0-rc7 #1

Jan 11 03:38:27 MainDesktop1 kernel: [45002.235896] CPU: 0 PID: 0
Comm: swapper/0 Not tainted 3.13.0-rc7 #1
Jan 11 03:38:27 MainDesktop1 kernel: [45002.235898] Hardware name: To
be filled by O.E.M. To be filled by O.E.M./CROSSHAIR V FORMULA-Z, BIOS
1701 10/28/2013

Jan 11 03:38:27 MainDesktop1 kernel: [45002.235900] Hardware name: To
be filled by O.E.M. To be filled by O.E.M./CROSSHAIR V FORMULA-Z, BIOS
1701 10/28/2013
Jan 11 03:38:27 MainDesktop1 kernel: [45002.235901] task:
ffff88033e6146e0 ti: ffff88033e61e000 task.ti: ffff88033e61e000

Jan 11 03:38:27 MainDesktop1 kernel: [45002.235904] task:
ffffffff83211480 ti: ffffffff83200000 task.ti: ffffffff83200000
Jan 11 03:38:27 MainDesktop1 kernel: [45002.235907] RIP:
0010:[<ffffffff8104c4c9>]
Jan 11 03:38:27 MainDesktop1 kernel: [45002.235912]
[<ffffffff8104c4c9>] amd_e400_idle+0x59/0xf0

Jan 11 03:38:27 MainDesktop1 kernel: [45002.235917] RIP:
0010:[<ffffffff824dd4bf>]  [<ffffffff824dd4bf>]
_raw_spin_unlock_irqrestore+0xf/0x40
Jan 11 03:38:27 MainDesktop1 kernel: [45002.235919] RSP:
0018:ffff88033e61feb8  EFLAGS: 00000286

Jan 11 03:38:27 MainDesktop1 kernel: [45002.235921] RSP:
0018:ffff88034fc033c8  EFLAGS: 00000296
Jan 11 03:38:27 MainDesktop1 kernel: [45002.235922] RAX:
0000000000000001 RBX: ffffffff824dd4c9 RCX: 000000000000726c

Jan 11 03:38:27 MainDesktop1 kernel: [45002.235924] RAX:
0000000000000001 RBX: ffff88033e0a0898 RCX: 000000000000000c
Jan 11 03:38:27 MainDesktop1 kernel: [45002.235925] RDX:
0000000000000002 RSI: 0000000000000086 RDI: 00000000ffffffff

Jan 11 03:38:27 MainDesktop1 kernel: [45002.235926] RDX:
30000001c2c32001 RSI: 0000000000000296 RDI: ffff88032b0d7830
Jan 11 03:38:27 MainDesktop1 kernel: [45002.235927] RBP:
ffff88033e61fec0 R08: 0000000000000000 R09: 0000000000000000

Jan 11 03:38:27 MainDesktop1 kernel: [45002.235929] RBP:
ffff88034fc033c8 R08: ffff88032b2a2eb0 R09: ffff88032b0d7dd0
Jan 11 03:38:27 MainDesktop1 kernel: [45002.235930] R10:
0000000000000000 R11: 0000000000000000 R12: ffffffff8114bc39

Jan 11 03:38:27 MainDesktop1 kernel: [45002.235932] R10:
ffff88032b0d7810 R11: 0000000000000001 R12: ffff88034fc03338
Jan 11 03:38:27 MainDesktop1 kernel: [45002.235933] R13:
ffff88033e61fe38 R14: ffffffff81065944 R15: ffff88033e61fe18

Jan 11 03:38:27 MainDesktop1 kernel: [45002.235935] R13:
ffffffff824e5eca R14: ffff88034fc033c8 R15: ffff88032b0d7830
Jan 11 03:38:27 MainDesktop1 kernel: [45002.235937] FS:
00007f4dba497740(0000) GS:ffff88034fc80000(0000)
knlGS:00000000f31ffb40

Jan 11 03:38:27 MainDesktop1 kernel: [45002.235939] FS:
00007f57037faa00(0000) GS:ffff88034fc00000(0000)
knlGS:00000000f7390a80
Jan 11 03:38:27 MainDesktop1 kernel: [45002.235940] CS:  0010 DS: 0000
ES: 0000 CR0: 000000008005003b

Jan 11 03:38:27 MainDesktop1 kernel: [45002.235942] CS:  0010 DS: 0000
ES: 0000 CR0: 000000008005003b
Jan 11 03:38:27 MainDesktop1 kernel: [45002.235943] CR2:
00007f4bff886000 CR3: 000000023e901000 CR4: 00000000000007e0

Jan 11 03:38:27 MainDesktop1 kernel: [45002.235945] CR2:
00007f4c12c60000 CR3: 000000023f311000 CR4: 00000000000007f0
Jan 11 03:38:27 MainDesktop1 kernel: [45002.235946] Stack:
Jan 11 03:38:27 MainDesktop1 kernel: [45002.235947] Stack:

Jan 11 03:38:27 MainDesktop1 kernel: [45002.235949]  0000000000000001
Jan 11 03:38:27 MainDesktop1 kernel: [45002.235950]  ffff88034fc03420
Jan 11 03:38:27 MainDesktop1 kernel: [45002.235952]  ffff88033e61fed0
Jan 11 03:38:27 MainDesktop1 kernel: [45002.235953]  ffffffff82071976

Jan 11 03:38:27 MainDesktop1 kernel: [45002.235955]  ffffffff8104cd16
Jan 11 03:38:27 MainDesktop1 kernel: [45002.235956]  ffffffffffffffff
Jan 11 03:38:27 MainDesktop1 kernel: [45002.235957]  ffff88033e61ff20
Jan 11 03:38:27 MainDesktop1 kernel: [45002.235958]

Jan 11 03:38:27 MainDesktop1 kernel: [45002.235959]  0000000000000296
Jan 11 03:38:27 MainDesktop1 kernel: [45002.235962]  ffffffff811376f0
Jan 11 03:38:27 MainDesktop1 kernel: [45002.235963]  0000000000000036
Jan 11 03:38:27 MainDesktop1 kernel: [45002.235964]  ffff88033e61ffd8

Jan 11 03:38:27 MainDesktop1 kernel: [45002.235965]  00000001c2c324fa
Jan 11 03:38:27 MainDesktop1 kernel: [45002.235967]  ffff88033e61ffd8
Jan 11 03:38:27 MainDesktop1 kernel: [45002.235968]  ffffc90009af5320
Jan 11 03:38:27 MainDesktop1 kernel: [45002.235969]  c4555b33790cafb3

Jan 11 03:38:27 MainDesktop1 kernel: [45002.235970]
Jan 11 03:38:27 MainDesktop1 kernel: [45002.235971]  0000000000000014
Jan 11 03:38:27 MainDesktop1 kernel: [45002.235973]  000000000000cb90
Jan 11 03:38:27 MainDesktop1 kernel: [45002.235974]  0000000000000036

Jan 11 03:38:27 MainDesktop1 kernel: [45002.235976]  0000000000000001
Jan 11 03:38:27 MainDesktop1 kernel: [45002.235977]  ffff88033e0a0898
Jan 11 03:38:27 MainDesktop1 kernel: [45002.235978]  0000000000000000
Jan 11 03:38:27 MainDesktop1 kernel: [45002.235979]  0000000000000036

Jan 11 03:38:27 MainDesktop1 kernel: [45002.235981]  0000000000000000
Jan 11 03:38:27 MainDesktop1 kernel: [45002.235982]
Jan 11 03:38:27 MainDesktop1 kernel: [45002.235983]  ffff88034fc034a8
Jan 11 03:38:27 MainDesktop1 kernel: [45002.235984] Call Trace:

Jan 11 03:38:27 MainDesktop1 kernel: [45002.235985] Call Trace:
Jan 11 03:38:27 MainDesktop1 kernel: [45002.235990]
[<ffffffff8104cd16>] arch_cpu_idle+0x26/0x30
Jan 11 03:38:27 MainDesktop1 kernel: [45002.235991]  <IRQ>

Jan 11 03:38:27 MainDesktop1 kernel: [45002.235996]
[<ffffffff82071976>] map_page+0xb6/0xf0
Jan 11 03:38:27 MainDesktop1 kernel: [45002.235999]
[<ffffffff811376f0>] cpu_startup_entry+0xc0/0x2b0
Jan 11 03:38:27 MainDesktop1 kernel: [45002.236004]
[<ffffffff81cc0a06>] e1000_xmit_frame+0x436/0xe10

Jan 11 03:38:27 MainDesktop1 kernel: [45002.236005]
[<ffffffff81064075>] start_secondary+0x1f5/0x250
Jan 11 03:38:27 MainDesktop1 kernel: [45002.236009]
[<ffffffff824dd4c9>] ? _raw_spin_unlock_irqrestore+0x19/0x40

Jan 11 03:38:27 MainDesktop1 kernel: [45002.236011] Code: 4b
Jan 11 03:38:27 MainDesktop1 kernel: [45002.236015]
[<ffffffff82141fa1>] dev_hard_start_xmit+0x541/0x600
Jan 11 03:38:27 MainDesktop1 kernel: [45002.236017] 48 8d

Jan 11 03:38:27 MainDesktop1 kernel: [45002.236020]
[<ffffffff8216b550>] sch_direct_xmit+0x100/0x1d0
Jan 11 03:38:27 MainDesktop1 kernel: [45002.236022] 5d f4
Jan 11 03:38:27 MainDesktop1 kernel: [45002.236025]
[<ffffffff8214226e>] dev_queue_xmit+0x20e/0x4e0

Jan 11 03:38:27 MainDesktop1 kernel: [45002.236026] 48 89
Jan 11 03:38:27 MainDesktop1 kernel: [45002.236030]
[<ffffffff82300bfb>] br_dev_queue_push_xmit+0x7b/0xc0
Jan 11 03:38:27 MainDesktop1 kernel: [45002.236032] de bf

Jan 11 03:38:27 MainDesktop1 kernel: [45002.236035]
[<ffffffff82300e12>] br_forward_finish+0x22/0x60
Jan 11 03:38:27 MainDesktop1 kernel: [45002.236037] 04 00
Jan 11 03:38:27 MainDesktop1 kernel: [45002.236040]
[<ffffffff82300e9e>] __br_deliver+0x4e/0x100

Jan 11 03:38:27 MainDesktop1 kernel: [45002.236042] 00 00
Jan 11 03:38:27 MainDesktop1 kernel: [45002.236045]
[<ffffffff823011e3>] br_deliver+0x73/0x80
Jan 11 03:38:27 MainDesktop1 kernel: [45002.236047] e8 f0

Jan 11 03:38:27 MainDesktop1 kernel: [45002.236050]
[<ffffffff822fea04>] br_dev_xmit+0x164/0x2a0
Jan 11 03:38:27 MainDesktop1 kernel: [45002.236052] f3 0f
Jan 11 03:38:27 MainDesktop1 kernel: [45002.236055]
[<ffffffff82141fa1>] dev_hard_start_xmit+0x541/0x600

Jan 11 03:38:27 MainDesktop1 kernel: [45002.236056] 00 e8
Jan 11 03:38:27 MainDesktop1 kernel: [45002.236059]
[<ffffffff821423cb>] dev_queue_xmit+0x36b/0x4e0
Jan 11 03:38:27 MainDesktop1 kernel: [45002.236061] bb fe

Jan 11 03:38:27 MainDesktop1 kernel: [45002.236065]
[<ffffffff8221f690>] ? ip_fragment+0x840/0x840
Jan 11 03:38:27 MainDesktop1 kernel: [45002.236066] ff ff
Jan 11 03:38:27 MainDesktop1 kernel: [45002.236069]
[<ffffffff8221f951>] ip_finish_output+0x2c1/0x380

Jan 11 03:38:27 MainDesktop1 kernel: [45002.236071] fa 48
Jan 11 03:38:27 MainDesktop1 kernel: [45002.236074]
[<ffffffff82220cf8>] ip_output+0x58/0x90
Jan 11 03:38:27 MainDesktop1 kernel: [45002.236076] 8d 75

Jan 11 03:38:27 MainDesktop1 kernel: [45002.236079]
[<ffffffff82220445>] ip_local_out+0x25/0x30
Jan 11 03:38:27 MainDesktop1 kernel: [45002.236081] f4 bf
Jan 11 03:38:27 MainDesktop1 kernel: [45002.236084]
[<ffffffff822207b0>] ip_queue_xmit+0x140/0x3e0

Jan 11 03:38:27 MainDesktop1 kernel: [45002.236085] 05 00
Jan 11 03:38:27 MainDesktop1 kernel: [45002.236089]
[<ffffffff82237073>] tcp_transmit_skb+0x453/0x8c0
Jan 11 03:38:27 MainDesktop1 kernel: [45002.236091] 00 00

Jan 11 03:38:27 MainDesktop1 kernel: [45002.236093]
[<ffffffff82239c14>] tcp_send_ack+0xa4/0xf0
Jan 11 03:38:27 MainDesktop1 kernel: [45002.236095] e8 dc
Jan 11 03:38:27 MainDesktop1 kernel: [45002.236098]
[<ffffffff8222d42e>] __tcp_ack_snd_check+0x5e/0x90

Jan 11 03:38:27 MainDesktop1 kernel: [45002.236100] f3 0f
Jan 11 03:38:27 MainDesktop1 kernel: [45002.236103]
[<ffffffff82234e66>] tcp_rcv_state_process+0xa06/0xdf0
Jan 11 03:38:27 MainDesktop1 kernel: [45002.236105] 00 fb

Jan 11 03:38:27 MainDesktop1 kernel: [45002.236108]
[<ffffffff8223daa0>] tcp_v4_do_rcv+0x2a0/0x490
Jan 11 03:38:27 MainDesktop1 kernel: [45002.236110] 48 83
Jan 11 03:38:27 MainDesktop1 kernel: [45002.236112]
[<ffffffff8223fce8>] tcp_v4_rcv+0x788/0x7a0

Jan 11 03:38:27 MainDesktop1 kernel: [45002.236114] c4 08
Jan 11 03:38:27 MainDesktop1 kernel: [45002.236117]
[<ffffffff8221b310>] ? ip_rcv_finish+0x350/0x350
Jan 11 03:38:27 MainDesktop1 kernel: [45002.236119] <5b> 5d

Jan 11 03:38:27 MainDesktop1 kernel: [45002.236123]
[<ffffffff821a581f>] ? nf_hook_slow+0xdf/0x120
Jan 11 03:38:27 MainDesktop1 kernel: [45002.236124] c3 0f
Jan 11 03:38:27 MainDesktop1 kernel: [45002.236127]
[<ffffffff8221b310>] ? ip_rcv_finish+0x350/0x350

Jan 11 03:38:27 MainDesktop1 kernel: [45002.236129] 1f 40
Jan 11 03:38:27 MainDesktop1 kernel: [45002.236132]
[<ffffffff8221b3b8>] ip_local_deliver_finish+0xa8/0x220
Jan 11 03:38:27 MainDesktop1 kernel: [45002.236134] 00 b9

Jan 11 03:38:27 MainDesktop1 kernel: [45002.236137]
[<ffffffff8221b6b8>] ip_local_deliver+0x48/0x80
Jan 11 03:38:27 MainDesktop1 kernel: [45002.236138] 55 00
Jan 11 03:38:27 MainDesktop1 kernel: [45002.236141]
[<ffffffff8221b048>] ip_rcv_finish+0x88/0x350

Jan 11 03:38:27 MainDesktop1 kernel: [45002.236143] 01 c0
Jan 11 03:38:27 MainDesktop1 kernel: [45002.236146]
[<ffffffff8221b990>] ip_rcv+0x2a0/0x3d0
Jan 11 03:38:27 MainDesktop1 kernel: [45002.236148] 0f 32

Jan 11 03:38:27 MainDesktop1 kernel: [45002.236151]
[<ffffffff821402ee>] __netif_receive_skb_core+0x64e/0x840
Jan 11 03:38:27 MainDesktop1 kernel: [45002.236153] a9 00
Jan 11 03:38:27 MainDesktop1 kernel: [45002.236156]
[<ffffffff82140501>] __netif_receive_skb+0x21/0x70

Jan 11 03:38:27 MainDesktop1 kernel: [45002.236157] 00 00
Jan 11 03:38:27 MainDesktop1 kernel: [45002.236160]
[<ffffffff82140573>] netif_receive_skb+0x23/0xb0
Jan 11 03:38:27 MainDesktop1 kernel: [45002.236162] 18 75

Jan 11 03:38:27 MainDesktop1 kernel: [45002.236165]
[<ffffffff8230204a>] br_handle_frame_finish+0x1fa/0x3e0
Jan 11 03:38:27 MainDesktop1 kernel: [45002.236166] 39
Jan 11 03:38:27 MainDesktop1 kernel: [45002.236170]
[<ffffffff8230912a>] br_nf_pre_routing_finish+0x17a/0x390

Jan 11 03:38:27 MainDesktop1 kernel: [45002.236173]
[<ffffffff823095e1>] br_nf_pre_routing+0x2a1/0x650
Jan 11 03:38:27 MainDesktop1 kernel: [45002.236176]
[<ffffffff82301e50>] ? br_handle_local_finish+0x60/0x60

Jan 11 03:38:27 MainDesktop1 kernel: [45002.236179]
[<ffffffff821a5732>] nf_iterate+0x92/0xa0
Jan 11 03:38:27 MainDesktop1 kernel: [45002.236181]
[<ffffffff82301e50>] ? br_handle_local_finish+0x60/0x60

Jan 11 03:38:27 MainDesktop1 kernel: [45002.236184]
[<ffffffff821a57bc>] nf_hook_slow+0x7c/0x120
Jan 11 03:38:27 MainDesktop1 kernel: [45002.236187]
[<ffffffff82301e50>] ? br_handle_local_finish+0x60/0x60

Jan 11 03:38:27 MainDesktop1 kernel: [45002.236190]
[<ffffffff823023e0>] br_handle_frame+0x1b0/0x260
Jan 11 03:38:27 MainDesktop1 kernel: [45002.236193]
[<ffffffff8213feda>] __netif_receive_skb_core+0x23a/0x840

Jan 11 03:38:27 MainDesktop1 kernel: [45002.236196]
[<ffffffff82140501>] __netif_receive_skb+0x21/0x70
Jan 11 03:38:27 MainDesktop1 kernel: [45002.236198]
[<ffffffff82140573>] netif_receive_skb+0x23/0xb0

Jan 11 03:38:27 MainDesktop1 kernel: [45002.236201]
[<ffffffff82140ff8>] napi_gro_receive+0x88/0xc0
Jan 11 03:38:27 MainDesktop1 kernel: [45002.236204]
[<ffffffff81cbdd2b>] e1000_receive_skb+0x8b/0x100

Jan 11 03:38:27 MainDesktop1 kernel: [45002.236207]
[<ffffffff81cbf15e>] e1000_clean_rx_irq+0x23e/0x3c0
Jan 11 03:38:27 MainDesktop1 kernel: [45002.236210]
[<ffffffff81cc6c48>] e1000e_poll+0x78/0x300
Jan 11 03:38:27 MainDesktop1 kernel: [45002.236213]
[<ffffffff821408b9>] net_rx_action+0x129/0x230

Jan 11 03:38:27 MainDesktop1 kernel: [45002.236218]
[<ffffffff810efcdc>] __do_softirq+0xdc/0x2b0
Jan 11 03:38:27 MainDesktop1 kernel: [45002.236220]
[<ffffffff810f0165>] irq_exit+0x75/0x80
Jan 11 03:38:27 MainDesktop1 kernel: [45002.236224]
[<ffffffff824e6f43>] do_IRQ+0x63/0xd0

Jan 11 03:38:27 MainDesktop1 kernel: [45002.236227]
[<ffffffff824dde6a>] common_interrupt+0x6a/0x6a
Jan 11 03:38:27 MainDesktop1 kernel: [45002.236229]  <EOI>
Jan 11 03:38:27 MainDesktop1 kernel: [45002.236232]
[<ffffffff8104c388>] ? default_idle+0x18/0x100

Jan 11 03:38:27 MainDesktop1 kernel: [45002.236235]
[<ffffffff8104c381>] ? default_idle+0x11/0x100
Jan 11 03:38:27 MainDesktop1 kernel: [45002.236237]
[<ffffffff8104c4b5>] amd_e400_idle+0x45/0xf0
Jan 11 03:38:27 MainDesktop1 kernel: [45002.236240]
[<ffffffff8104cd16>] arch_cpu_idle+0x26/0x30

Jan 11 03:38:27 MainDesktop1 kernel: [45002.236244]
[<ffffffff811376f0>] cpu_startup_entry+0xc0/0x2b0
Jan 11 03:38:27 MainDesktop1 kernel: [45002.236248]
[<ffffffff824c35a4>] rest_init+0x84/0x90
Jan 11 03:38:27 MainDesktop1 kernel: [45002.236253]
[<ffffffff833e6ea1>] start_kernel+0x416/0x422

Jan 11 03:38:27 MainDesktop1 kernel: [45002.236256]
[<ffffffff833e6894>] ? repair_env_string+0x5c/0x5c
Jan 11 03:38:27 MainDesktop1 kernel: [45002.236259]
[<ffffffff833e65a3>] x86_64_start_reservations+0x2a/0x2c

Jan 11 03:38:27 MainDesktop1 kernel: [45002.236262]
[<ffffffff833e669b>] x86_64_start_kernel+0xf6/0xf9
Jan 11 03:38:27 MainDesktop1 kernel: [45002.236263] Code: c3 e8
Jan 11 03:38:27 MainDesktop1 kernel: [45002.236267] Modules linked in:
psmouse serio_raw

Jan 11 03:38:27 MainDesktop1 kernel: [45002.236274] CPU: 2 PID: 0
Comm: swapper/2 Not tainted 3.13.0-rc7 #1
Jan 11 03:38:27 MainDesktop1 kernel: [45002.236278] Hardware name: To
be filled by O.E.M. To be filled by O.E.M./CROSSHAIR V FORMULA-Z, BIOS
1701 10/28/2013

Jan 11 03:38:27 MainDesktop1 kernel: [45002.236281] task:
ffff88033e615e80 ti: ffff88033e620000 task.ti: ffff88033e620000
Jan 11 03:38:27 MainDesktop1 kernel: [45002.236276] e6 ed
Jan 11 03:38:27 MainDesktop1 kernel: [45002.236283] RIP:
0010:[<ffffffff8104c4c9>]  [<ffffffff8104c4c9>]
amd_e400_idle+0x59/0xf0

Jan 11 03:38:27 MainDesktop1 kernel: [45002.236289] RSP:
0018:ffff88033e621eb8  EFLAGS: 00000286
Jan 11 03:38:27 MainDesktop1 kernel: [45002.236291] RAX:
0000000080000001 RBX: ffffffff824dd4c9 RCX: 000000000000726b

Jan 11 03:38:27 MainDesktop1 kernel: [45002.236292] RDX:
0000000000000002 RSI: 0000000000000086 RDI: 00000000ffffffff
Jan 11 03:38:27 MainDesktop1 kernel: [45002.236294] RBP:
ffff88033e621ec0 R08: 0000000000000000 R09: 0000000000000000

Jan 11 03:38:27 MainDesktop1 kernel: [45002.236295] R10:
0000000000000000 R11: 0000000000000000 R12: ffffffff824dd9e2
Jan 11 03:38:27 MainDesktop1 kernel: [45002.236297] R13:
0000000000000000 R14: ffffffff81065944 R15: ffff88033e621ea0

Jan 11 03:38:27 MainDesktop1 kernel: [45002.236299] FS:
00007fad5916b700(0000) GS:ffff88034fd00000(0000)
knlGS:00000000f29feb40
Jan 11 03:38:27 MainDesktop1 kernel: [45002.236301] CS:  0010 DS: 0000
ES: 0000 CR0: 000000008005003b

Jan 11 03:38:27 MainDesktop1 kernel: [45002.236302] CR2:
00007fad61ec3008 CR3: 000000021e5c3000 CR4: 00000000000007e0
Jan 11 03:38:27 MainDesktop1 kernel: [45002.236304] Stack:
Jan 11 03:38:27 MainDesktop1 kernel: [45002.236305]  0000000000000002
ffff88033e621ed0 ffffffff8104cd16 ffff88033e621f20

Jan 11 03:38:27 MainDesktop1 kernel: [45002.236310]  ffffffff811376f0
ffff88033e621fd8 ffff88033e621fd8 2ecb18a281eab02a
Jan 11 03:38:27 MainDesktop1 kernel: [45002.236315]  000000000000cb90
0000000000000002 0000000000000000 0000000000000000

Jan 11 03:38:27 MainDesktop1 kernel: [45002.236320] Call Trace:
Jan 11 03:38:27 MainDesktop1 kernel: [45002.236322] b6
[<ffffffff8104cd16>] arch_cpu_idle+0x26/0x30
Jan 11 03:38:27 MainDesktop1 kernel: [45002.236329]
[<ffffffff811376f0>] cpu_startup_entry+0xc0/0x2b0

Jan 11 03:38:27 MainDesktop1 kernel: [45002.236330] fe 5d
Jan 11 03:38:27 MainDesktop1 kernel: [45002.236332]
[<ffffffff81064075>] start_secondary+0x1f5/0x250
Jan 11 03:38:27 MainDesktop1 kernel: [45002.236335] Code: 0f 1f 44 00 00 c3

Jan 11 03:38:27 MainDesktop1 kernel: [45002.236341] 4b 48 8d 5d
Jan 11 03:38:27 MainDesktop1 kernel: [45002.236344] 66 66 66 66 66 66
2e 0f 1f 84 00 00 00 00 00 66 66 66 66 90 55 48 89 e5 66 83 07 01 56
9d <bf> 01 00 00 00 e8 97 3f 00 00 65 8b 04 25 e0 b7 00 00 85 c0 74

Jan 11 03:38:27 MainDesktop1 kernel: [45002.236393] f4 48 89 de bf 04
00 00 00 e8 f0 f3 0f 00 e8 bb fe ff ff fa 48 8d 75 f4 bf 05 00 00 00
e8 dc f3 0f 00 fb 48 83 c4 08 <5b> 5d c3 0f 1f 40 00 b9 55 00 01 c0 0f
32 a9 00 00 00 18 75 39

Jan 11 03:38:27 MainDesktop1 rtkit-daemon[5825]: The canary thread is
apparently starving. Taking action.
Jan 11 03:38:27 MainDesktop1 rtkit-daemon[5825]: Demoting known
real-time threads.
Jan 11 03:38:27 MainDesktop1 rtkit-daemon[5825]: Successfully demoted
thread 6857 of process 6844 (n/a).

Jan 11 03:38:27 MainDesktop1 rtkit-daemon[5825]: Successfully demoted
thread 6856 of process 6844 (n/a).
Jan 11 03:38:27 MainDesktop1 rtkit-daemon[5825]: Successfully demoted
thread 6854 of process 6844 (n/a).
Jan 11 03:38:27 MainDesktop1 rtkit-daemon[5825]: Successfully demoted
thread 6853 of process 6844 (n/a).

Jan 11 03:38:27 MainDesktop1 rtkit-daemon[5825]: Successfully demoted
thread 6850 of process 6844 (n/a).
Jan 11 03:38:27 MainDesktop1 rtkit-daemon[5825]: Successfully demoted
thread 6844 of process 6844 (n/a).
Jan 11 03:38:27 MainDesktop1 rtkit-daemon[5825]: Demoted 6 threads.




[6.] A small shell script or example program which triggers the
     problem (if possible):

I can't locate a way to reproduce this on command unfortunately.



[7.] Environment:

Unclear of what information is required here, please advise.


[7.1.] Software (add the output of the ver_linux script here)

root@MainDesktop1:/usr/src/linux-3.13.1# scripts/ver_linux
If some fields are empty or look unusual you may have an old version.
Compare to the current minimal requirements in Documentation/Changes.

Linux MainDesktop1 3.13.1 #1 SMP PREEMPT Thu Jan 30 16:41:24 EST 2014
x86_64 x86_64 x86_64 GNU/Linux


Gnu C                  4.8
Gnu make               3.81
binutils               2.23.52.20130913
util-linux             2.20.1
mount                  support
module-init-tools      9
e2fsprogs              1.42.8

pcmciautils            018
PPP                    2.4.5
Linux C Library        2.17
Dynamic linker (ldd)   2.17
Procps                 3.3.3
Net-tools              1.60
Kbd                    1.15.5
Sh-utils               8.20

wireless-tools         30
Modules Loaded         psmouse serio_raw
root@MainDesktop1:/usr/src/linux-3.13.1#


[7.2.] Processor information (from /proc/cpuinfo):

root@MainDesktop1:/usr/src/linux-3.13.1# cat /proc/cpuinfo

processor : 0
vendor_id : AuthenticAMD
cpu family : 16
model : 4
model name : AMD Phenom(tm) II X4 945 Processor
stepping : 2
microcode : 0x10000c6
cpu MHz : 3010.169
cache size : 512 KB
physical id : 0

siblings : 4
core id : 0
cpu cores : 4
apicid : 0
initial apicid : 0
fpu : yes
fpu_exception : yes
cpuid level : 5
wp : yes
flags : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt
pdpe1gb rdtscp lm 3dnowext 3dnow constant_tsc rep_good nopl
nonstop_tsc extd_apicid pni monitor cx16 popcnt lahf_lm cmp_legacy svm
extapic cr8_legacy abm sse4a misalignsse 3dnowprefetch osvw ibs skinit
wdt nodeid_msr hw_pstate npt lbrv svm_lock nrip_save

bogomips : 6020.33
TLB size : 1024 4K pages
clflush size : 64
cache_alignment : 64
address sizes : 48 bits physical, 48 bits virtual
power management: ts ttp tm stc 100mhzsteps hwpstate

processor : 1

vendor_id : AuthenticAMD
cpu family : 16
model : 4
model name : AMD Phenom(tm) II X4 945 Processor
stepping : 2
microcode : 0x10000c6
cpu MHz : 3010.169
cache size : 512 KB
physical id : 0
siblings : 4

core id : 1
cpu cores : 4
apicid : 1
initial apicid : 1
fpu : yes
fpu_exception : yes
cpuid level : 5
wp : yes
flags : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt
pdpe1gb rdtscp lm 3dnowext 3dnow constant_tsc rep_good nopl
nonstop_tsc extd_apicid pni monitor cx16 popcnt lahf_lm cmp_legacy svm
extapic cr8_legacy abm sse4a misalignsse 3dnowprefetch osvw ibs skinit
wdt nodeid_msr hw_pstate npt lbrv svm_lock nrip_save

bogomips : 6020.33
TLB size : 1024 4K pages
clflush size : 64
cache_alignment : 64
address sizes : 48 bits physical, 48 bits virtual
power management: ts ttp tm stc 100mhzsteps hwpstate

processor : 2

vendor_id : AuthenticAMD
cpu family : 16
model : 4
model name : AMD Phenom(tm) II X4 945 Processor
stepping : 2
microcode : 0x10000c6
cpu MHz : 3010.169
cache size : 512 KB
physical id : 0
siblings : 4

core id : 2
cpu cores : 4
apicid : 2
initial apicid : 2
fpu : yes
fpu_exception : yes
cpuid level : 5
wp : yes
flags : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt
pdpe1gb rdtscp lm 3dnowext 3dnow constant_tsc rep_good nopl
nonstop_tsc extd_apicid pni monitor cx16 popcnt lahf_lm cmp_legacy svm
extapic cr8_legacy abm sse4a misalignsse 3dnowprefetch osvw ibs skinit
wdt nodeid_msr hw_pstate npt lbrv svm_lock nrip_save

bogomips : 6020.33
TLB size : 1024 4K pages
clflush size : 64
cache_alignment : 64
address sizes : 48 bits physical, 48 bits virtual
power management: ts ttp tm stc 100mhzsteps hwpstate

processor : 3

vendor_id : AuthenticAMD
cpu family : 16
model : 4
model name : AMD Phenom(tm) II X4 945 Processor
stepping : 2
microcode : 0x10000c6
cpu MHz : 3010.169
cache size : 512 KB
physical id : 0
siblings : 4

core id : 3
cpu cores : 4
apicid : 3
initial apicid : 3
fpu : yes
fpu_exception : yes
cpuid level : 5
wp : yes
flags : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt
pdpe1gb rdtscp lm 3dnowext 3dnow constant_tsc rep_good nopl
nonstop_tsc extd_apicid pni monitor cx16 popcnt lahf_lm cmp_legacy svm
extapic cr8_legacy abm sse4a misalignsse 3dnowprefetch osvw ibs skinit
wdt nodeid_msr hw_pstate npt lbrv svm_lock nrip_save

bogomips : 6020.33
TLB size : 1024 4K pages
clflush size : 64
cache_alignment : 64
address sizes : 48 bits physical, 48 bits virtual
power management: ts ttp tm stc 100mhzsteps hwpstate

root@MainDesktop1:/usr/src/linux-3.13.1#



[7.3.] Module information (from /proc/modules):

root@MainDesktop1:/usr/src/linux-3.13.1# cat /proc/modules
psmouse 89853 0 - Live 0xffffffffa000a000
serio_raw 5005 0 - Live 0xffffffffa0000000
root@MainDesktop1:/usr/src/linux-3.13.1#



[7.4.] Loaded driver and hardware information (/proc/ioports, /proc/iomem):

root@MainDesktop1:/usr/src/linux-3.13.1# cat /proc/ioports
0000-03af : PCI Bus 0000:00
  0000-001f : dma1
  0020-0021 : pic1

  0040-0043 : timer0
  0050-0053 : timer1
  0060-0060 : keyboard
  0062-0062 : EC data
  0064-0064 : keyboard
  0066-0066 : EC cmd
  0070-0071 : rtc0
  0080-008f : dma page reg
  00a0-00a1 : pic2

  00c0-00df : dma2
  00f0-00ff : fpu
  0290-02af : pnp 00:02
03b0-03df : PCI Bus 0000:00
03e0-0cf7 : PCI Bus 0000:00
  03e8-03ef : lirc_sir
  040b-040b : pnp 00:01
  04d0-04d1 : pnp 00:06
  04d6-04d6 : pnp 00:01

  0800-0803 : ACPI PM1a_EVT_BLK
  0804-0805 : ACPI PM1a_CNT_BLK
  0808-080b : ACPI PM_TMR
  0810-0815 : ACPI CPU throttle
  0820-0827 : ACPI GPE0_BLK
  0900-090f : pnp 00:01
  0910-091f : pnp 00:01
  0b20-0b3f : pnp 00:01

  0c00-0c01 : pnp 00:01
  0c14-0c14 : pnp 00:01
  0c50-0c51 : pnp 00:01
  0c52-0c52 : pnp 00:01
  0c6c-0c6c : pnp 00:01
  0c6f-0c6f : pnp 00:01
  0cd0-0cd1 : pnp 00:01
  0cd2-0cd3 : pnp 00:01
  0cd4-0cd5 : pnp 00:01

  0cd6-0cd7 : pnp 00:01
    0cd6-0cd7 : SB800 TCO
  0cd8-0cdf : pnp 00:01
0cf8-0cff : PCI conf1
0d00-ffff : PCI Bus 0000:00
  9000-9fff : PCI Bus 0000:09
    9000-90ff : 0000:09:00.0
  a000-afff : PCI Bus 0000:08

    a000-a0ff : 0000:08:00.0
      a000-a0ff : 3w-9xxx
  b000-bfff : PCI Bus 0000:07
    b000-b01f : 0000:07:00.0
      b000-b01f : ahci
    b020-b023 : 0000:07:00.0
      b020-b023 : ahci
    b030-b037 : 0000:07:00.0

      b030-b037 : ahci
    b040-b043 : 0000:07:00.0
      b040-b043 : ahci
    b050-b057 : 0000:07:00.0
      b050-b057 : ahci
  c000-cfff : PCI Bus 0000:03
    c000-c01f : 0000:03:00.0
  d000-dfff : PCI Bus 0000:02

    d000-d01f : 0000:02:00.0
      d000-d01f : ahci
    d020-d023 : 0000:02:00.0
      d020-d023 : ahci
    d030-d037 : 0000:02:00.0
      d030-d037 : ahci
    d040-d043 : 0000:02:00.0
      d040-d043 : ahci

    d050-d057 : 0000:02:00.0
      d050-d057 : ahci
  e000-efff : PCI Bus 0000:01
    e000-e0ff : 0000:01:00.0
  f000-f00f : 0000:00:11.0
    f000-f00f : ahci
  f010-f013 : 0000:00:11.0
    f010-f013 : ahci

  f020-f027 : 0000:00:11.0
    f020-f027 : ahci
  f030-f033 : 0000:00:11.0
    f030-f033 : ahci
  f040-f047 : 0000:00:11.0
    f040-f047 : ahci
  fe00-fefe : pnp 00:01
root@MainDesktop1:/usr/src/linux-3.13.1#



root@MainDesktop1:/usr/src/linux-3.13.1# cat /proc/iomem
00000000-00000fff : reserved
00001000-0009dfff : System RAM
0009e000-0009ffff : reserved
000a0000-000bffff : PCI Bus 0000:00
000c0000-000dffff : PCI Bus 0000:00

  000c0000-000cffff : Video ROM
000e0000-000fffff : reserved
  000f0000-000fffff : System ROM
00100000-aa5d5fff : System RAM
  01000000-02356f38 : Kernel code
  02356f39-02fbeb3f : Kernel data
  03181000-03437fff : Kernel bss

aa5d6000-aaa09fff : reserved
aaa0a000-aaa19fff : ACPI Tables
aaa1a000-ab81cfff : ACPI Non-volatile Storage
ab81d000-aca36fff : reserved
aca37000-aca37fff : System RAM
aca38000-acc3dfff : ACPI Non-volatile Storage

acc3e000-ad081fff : System RAM
ad082000-ad7f2fff : reserved
ad7f3000-ad7fffff : System RAM
ad800000-afffffff : RAM buffer
b0000000-ffffffff : PCI Bus 0000:00
  b0000000-bfffffff : PCI Bus 0000:09
    b0000000-bfffffff : 0000:09:00.0

  c0000000-cfffffff : PCI Bus 0000:01
    c0000000-cfffffff : 0000:01:00.0
      c0000000-c07e8fff : BOOTFB
  d0000000-d1ffffff : PCI Bus 0000:08
    d0000000-d1ffffff : 0000:08:00.0
      d0000000-d1ffffff : 3w-9xxx

  e0000000-efffffff : pnp 00:00
  f8000000-fbffffff : reserved
  fe100000-fe1fffff : PCI Bus 0000:0c
    fe100000-fe1fffff : PCI Bus 0000:0d
      fe100000-fe103fff : 0000:0d:00.0
        fe100000-fe103fff : ICH HD audio

  fe200000-fe2fffff : PCI Bus 0000:09
    fe200000-fe23ffff : 0000:09:00.0
    fe240000-fe25ffff : 0000:09:00.0
    fe260000-fe263fff : 0000:09:00.1
  fe300000-fe3fffff : PCI Bus 0000:08
    fe300000-fe31ffff : 0000:08:00.0

    fe320000-fe320fff : 0000:08:00.0
      fe320000-fe320fff : 3w-9xxx
  fe400000-fe4fffff : PCI Bus 0000:07
    fe400000-fe4001ff : 0000:07:00.0
      fe400000-fe4001ff : ahci
  fe500000-fe5fffff : PCI Bus 0000:06

    fe500000-fe507fff : 0000:06:00.0
      fe500000-fe507fff : xhci_hcd
  fe600000-fe6fffff : PCI Bus 0000:05
    fe600000-fe607fff : 0000:05:00.0
      fe600000-fe607fff : xhci_hcd
  fe700000-fe7fffff : PCI Bus 0000:04

    fe700000-fe707fff : 0000:04:00.0
      fe700000-fe707fff : xhci_hcd
  fe800000-fe8fffff : PCI Bus 0000:03
    fe800000-fe81ffff : 0000:03:00.0
      fe800000-fe81ffff : e1000e
    fe820000-fe823fff : 0000:03:00.0

      fe820000-fe823fff : e1000e
  fe900000-fe9fffff : PCI Bus 0000:02
    fe900000-fe9001ff : 0000:02:00.0
      fe900000-fe9001ff : ahci
  fea00000-feafffff : PCI Bus 0000:01
    fea00000-fea3ffff : 0000:01:00.0

    fea40000-fea5ffff : 0000:01:00.0
    fea60000-fea63fff : 0000:01:00.1
  feb00000-feb03fff : 0000:00:14.2
    feb00000-feb03fff : ICH HD audio
  feb04000-feb040ff : 0000:00:16.2
    feb04000-feb040ff : ehci_hcd

  feb05000-feb05fff : 0000:00:16.0
    feb05000-feb05fff : ohci_hcd
  feb06000-feb06fff : 0000:00:14.5
    feb06000-feb06fff : ohci_hcd
  feb07000-feb070ff : 0000:00:13.2
    feb07000-feb070ff : ehci_hcd

  feb08000-feb08fff : 0000:00:13.0
    feb08000-feb08fff : ohci_hcd
  feb09000-feb090ff : 0000:00:12.2
    feb09000-feb090ff : ehci_hcd
  feb0a000-feb0afff : 0000:00:12.0
    feb0a000-feb0afff : ohci_hcd

  feb0b000-feb0b3ff : 0000:00:11.0
    feb0b000-feb0b3ff : ahci
  feb20000-feb23fff : amd_iommu
  fec00000-fec00fff : reserved
    fec00000-fec003ff : IOAPIC 0
  fec10000-fec10fff : reserved
    fec10000-fec10fff : pnp 00:01

  fec20000-fec20fff : reserved
    fec20000-fec203ff : IOAPIC 1
  fed00000-fed00fff : reserved
    fed00000-fed00fff : pnp 00:01
      fed00000-fed003ff : HPET 0
  fed61000-fed70fff : reserved
    fed61000-fed70fff : pnp 00:01

  fed80000-fed8ffff : reserved
    fed80000-fed8ffff : pnp 00:01
      fed80b00-fed80b07 : SB800 TCO
  fee00000-fee00fff : Local APIC
    fee00000-fee00fff : pnp 00:01
  fef00000-ffffffff : reserved
    ff800000-ffffffff : pnp 00:01

100001000-64fffffff : System RAM
root@MainDesktop1:/usr/src/linux-3.13.1#


[7.5.] PCI information ('lspci -vvv' as root):

root@MainDesktop1:/usr/src/linux-3.13.1# lspci -vvv
00:00.0 Host bridge: Advanced Micro Devices, Inc. [AMD/ATI] RD890 PCI
to PCI bridge (external gfx0 port B) (rev 02)

Subsystem: Advanced Micro Devices, Inc. [AMD/ATI] RD890 PCI to PCI
bridge (external gfx0 port B)
Control: I/O- Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort+ >SERR- <PERR- INTx-

Capabilities: [f0] HyperTransport: MSI Mapping Enable+ Fixed+
Capabilities: [c4] HyperTransport: Slave or Primary Interface
Command: BaseUnitID=0 UnitCnt=20 MastHost- DefDir- DUL-
Link Control 0: CFlE- CST- CFE- <LkFail- Init+ EOC- TXO- <CRCErr=0
IsocEn- LSEn- ExtCTL- 64b-

Link Config 0: MLWI=16bit DwFcIn- MLWO=16bit DwFcOut- LWI=16bit
DwFcInEn- LWO=16bit DwFcOutEn-
Link Control 1: CFlE- CST- CFE- <LkFail+ Init- EOC+ TXO+ <CRCErr=0
IsocEn- LSEn- ExtCTL- 64b-
Link Config 1: MLWI=8bit DwFcIn- MLWO=8bit DwFcOut- LWI=8bit DwFcInEn-
LWO=8bit DwFcOutEn-

Revision ID: 3.00
Link Frequency 0: [b]
Link Error 0: <Prot- <Ovfl- <EOC- CTLTm-
Link Frequency Capability 0: 200MHz+ 300MHz- 400MHz+ 500MHz- 600MHz+
800MHz+ 1.0GHz+ 1.2GHz+ 1.4GHz- 1.6GHz- Vend-

Feature Capability: IsocFC+ LDTSTOP+ CRCTM- ECTLT- 64bA+ UIDRD-
Link Frequency 1: 200MHz
Link Error 1: <Prot- <Ovfl- <EOC- CTLTm-
Link Frequency Capability 1: 200MHz- 300MHz- 400MHz- 500MHz- 600MHz-
800MHz- 1.0GHz- 1.2GHz- 1.4GHz- 1.6GHz- Vend-

Error Handling: PFlE- OFlE- PFE- OFE- EOCFE- RFE- CRCFE- SERRFE- CF-
RE- PNFE- ONFE- EOCNFE- RNFE- CRCNFE- SERRNFE-
Prefetchable memory behind bridge Upper: 00-00
Bus Number: 00
Capabilities: [40] HyperTransport: Retry Mode

Capabilities: [54] HyperTransport: UnitID Clumping
Capabilities: [9c] HyperTransport: #1a
Capabilities: [70] MSI: Enable- Count=1/4 Maskable- 64bit-
Address: 00000000  Data: 0000

00:00.2 IOMMU: Advanced Micro Devices, Inc. [AMD/ATI] RD990 I/O Memory
Management Unit (IOMMU)

Subsystem: Advanced Micro Devices, Inc. [AMD/ATI] RD990 I/O Memory
Management Unit (IOMMU)
Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-

Interrupt: pin A routed to IRQ 72
Capabilities: [40] Secure device <?>
Capabilities: [54] MSI: Enable+ Count=1/1 Maskable- 64bit+
Address: 00000000fee0f00c  Data: 4122
Capabilities: [64] HyperTransport: MSI Mapping Enable+ Fixed+


00:02.0 PCI bridge: Advanced Micro Devices, Inc. [AMD/ATI] RD890 PCI
to PCI bridge (PCI express gpp port B) (prog-if 00 [Normal decode])
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-

Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0, Cache Line Size: 64 bytes
Bus: primary=00, secondary=01, subordinate=01, sec-latency=0

I/O behind bridge: 0000e000-0000efff
Memory behind bridge: fea00000-feafffff
Prefetchable memory behind bridge: 00000000c0000000-00000000cfffffff
Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- <SERR- <PERR-

BridgeCtl: Parity- SERR- NoISA- VGA+ MAbort- >Reset- FastB2B-
PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
Capabilities: [50] Power Management version 3
Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)

Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
Capabilities: [58] Express (v2) Root Port (Slot+), MSI 00
DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
ExtTag+ RBE+ FLReset-

DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
MaxPayload 128 bytes, MaxReadReq 128 bytes
DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-

LnkCap: Port #0, Speed 5GT/s, Width x16, ASPM L0s L1, Latency L0 <4us,
L1 unlimited
ClockPM- Surprise- LLActRep+ BwNot+
LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-

LnkSta: Speed 5GT/s, Width x16, TrErr- Train- SlotClk+ DLActive+
BWMgmt+ ABWMgmt+
SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surprise-
Slot #2, PowerLimit 75.000W; Interlock- NoCompl+
SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-

Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
Changed: MRL- PresDet- LinkState-
RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-

RootCap: CRSVisible-
RootSta: PME ReqID 0000, PMEStatus- PMEPending-
DevCap2: Completion Timeout: Range ABCD, TimeoutDis+ ARIFwd+
DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis- ARIFwd-
LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-,
Selectable De-emphasis: -3.5dB

Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
Compliance De-emphasis: -6dB
LnkSta2: Current De-emphasis Level: -3.5dB, EqualizationComplete-,
EqualizationPhase1-
EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-

Capabilities: [a0] MSI: Enable- Count=1/1 Maskable- 64bit-
Address: 00000000  Data: 0000
Capabilities: [b0] Subsystem: Advanced Micro Devices, Inc. [AMD/ATI] Device 5a14
Capabilities: [b8] HyperTransport: MSI Mapping Enable+ Fixed+

Capabilities: [100 v1] Vendor Specific Information: ID=0001 Rev=1 Len=010 <?>
Capabilities: [190 v1] Access Control Services
ACSCap: SrcValid+ TransBlk+ ReqRedir+ CmpltRedir+ UpstreamFwd+
EgressCtrl- DirectTrans+

ACSCtl: SrcValid+ TransBlk- ReqRedir+ CmpltRedir+ UpstreamFwd+
EgressCtrl- DirectTrans-
Kernel driver in use: pcieport

00:04.0 PCI bridge: Advanced Micro Devices, Inc. [AMD/ATI] RD890 PCI
to PCI bridge (PCI express gpp port D) (prog-if 00 [Normal decode])

Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-

Latency: 0, Cache Line Size: 64 bytes
Bus: primary=00, secondary=02, subordinate=02, sec-latency=0
I/O behind bridge: 0000d000-0000dfff
Memory behind bridge: fe900000-fe9fffff
Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff

Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- <SERR- <PERR-
BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-

Capabilities: [50] Power Management version 3
Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
Capabilities: [58] Express (v2) Root Port (Slot+), MSI 00

DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
ExtTag+ RBE+ FLReset-
DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+

MaxPayload 128 bytes, MaxReadReq 128 bytes
DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
LnkCap: Port #0, Speed 5GT/s, Width x2, ASPM L0s L1, Latency L0 <1us, L1 <8us
ClockPM- Surprise- LLActRep+ BwNot+

LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
LnkSta: Speed 5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+ BWMgmt+ ABWMgmt+
SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surprise-

Slot #4, PowerLimit 75.000W; Interlock- NoCompl+
SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-

Changed: MRL- PresDet- LinkState-
RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
RootCap: CRSVisible-
RootSta: PME ReqID 0000, PMEStatus- PMEPending-
DevCap2: Completion Timeout: Range ABCD, TimeoutDis+ ARIFwd+

DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis- ARIFwd-
LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-,
Selectable De-emphasis: -3.5dB
Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-

Compliance De-emphasis: -6dB
LnkSta2: Current De-emphasis Level: -3.5dB, EqualizationComplete-,
EqualizationPhase1-
EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
Capabilities: [a0] MSI: Enable- Count=1/1 Maskable- 64bit-

Address: 00000000  Data: 0000
Capabilities: [b0] Subsystem: Advanced Micro Devices, Inc. [AMD/ATI] Device 5a14
Capabilities: [b8] HyperTransport: MSI Mapping Enable+ Fixed+
Capabilities: [100 v1] Vendor Specific Information: ID=0001 Rev=1 Len=010 <?>

Capabilities: [190 v1] Access Control Services
ACSCap: SrcValid+ TransBlk+ ReqRedir+ CmpltRedir+ UpstreamFwd+
EgressCtrl- DirectTrans+
ACSCtl: SrcValid+ TransBlk- ReqRedir+ CmpltRedir+ UpstreamFwd+
EgressCtrl- DirectTrans-

Kernel driver in use: pcieport

00:05.0 PCI bridge: Advanced Micro Devices, Inc. [AMD/ATI] RD890 PCI
to PCI bridge (PCI express gpp port E) (prog-if 00 [Normal decode])
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-

Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0, Cache Line Size: 64 bytes
Bus: primary=00, secondary=03, subordinate=03, sec-latency=0

I/O behind bridge: 0000c000-0000cfff
Memory behind bridge: fe800000-fe8fffff
Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- <SERR- <PERR-

BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
Capabilities: [50] Power Management version 3
Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)

Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
Capabilities: [58] Express (v2) Root Port (Slot+), MSI 00
DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
ExtTag+ RBE+ FLReset-

DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
MaxPayload 128 bytes, MaxReadReq 128 bytes
DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-

LnkCap: Port #1, Speed 5GT/s, Width x1, ASPM L0s L1, Latency L0 <1us, L1 <8us
ClockPM- Surprise- LLActRep+ BwNot+
LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-

LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+
BWMgmt+ ABWMgmt-
SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surprise-
Slot #5, PowerLimit 75.000W; Interlock- NoCompl+
SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-

Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
Changed: MRL- PresDet- LinkState-
RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-

RootCap: CRSVisible-
RootSta: PME ReqID 0000, PMEStatus- PMEPending-
DevCap2: Completion Timeout: Range ABCD, TimeoutDis+ ARIFwd+
DevCtl2: Completion Timeout: 65ms to 210ms, TimeoutDis- ARIFwd-
LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-,
Selectable De-emphasis: -3.5dB

Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
Compliance De-emphasis: -6dB
LnkSta2: Current De-emphasis Level: -3.5dB, EqualizationComplete-,
EqualizationPhase1-
EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-

Capabilities: [a0] MSI: Enable- Count=1/1 Maskable- 64bit-
Address: 00000000  Data: 0000
Capabilities: [b0] Subsystem: Advanced Micro Devices, Inc. [AMD/ATI] Device 5a14
Capabilities: [b8] HyperTransport: MSI Mapping Enable+ Fixed+

Capabilities: [100 v1] Vendor Specific Information: ID=0001 Rev=1 Len=010 <?>
Capabilities: [190 v1] Access Control Services
ACSCap: SrcValid+ TransBlk+ ReqRedir+ CmpltRedir+ UpstreamFwd+
EgressCtrl- DirectTrans+

ACSCtl: SrcValid+ TransBlk- ReqRedir+ CmpltRedir+ UpstreamFwd+
EgressCtrl- DirectTrans-
Kernel driver in use: pcieport

00:06.0 PCI bridge: Advanced Micro Devices, Inc. [AMD/ATI] RD890 PCI
to PCI bridge (PCI express gpp port F) (prog-if 00 [Normal decode])

Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-

Latency: 0, Cache Line Size: 64 bytes
Bus: primary=00, secondary=04, subordinate=04, sec-latency=0
I/O behind bridge: 0000f000-00000fff
Memory behind bridge: fe700000-fe7fffff
Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff

Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort+ <SERR- <PERR-
BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-

Capabilities: [50] Power Management version 3
Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
Capabilities: [58] Express (v2) Root Port (Slot+), MSI 00

DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
ExtTag+ RBE+ FLReset-
DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+

MaxPayload 128 bytes, MaxReadReq 128 bytes
DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
LnkCap: Port #2, Speed 5GT/s, Width x1, ASPM L0s L1, Latency L0 <1us, L1 <8us
ClockPM- Surprise- LLActRep+ BwNot+

LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
LnkSta: Speed 5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+ BWMgmt+ ABWMgmt+
SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surprise-

Slot #6, PowerLimit 75.000W; Interlock- NoCompl+
SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-

Changed: MRL- PresDet- LinkState-
RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
RootCap: CRSVisible-
RootSta: PME ReqID 0000, PMEStatus- PMEPending-
DevCap2: Completion Timeout: Range ABCD, TimeoutDis+ ARIFwd+

DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis- ARIFwd-
LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-,
Selectable De-emphasis: -3.5dB
Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-

Compliance De-emphasis: -6dB
LnkSta2: Current De-emphasis Level: -3.5dB, EqualizationComplete-,
EqualizationPhase1-
EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
Capabilities: [a0] MSI: Enable- Count=1/1 Maskable- 64bit-

Address: 00000000  Data: 0000
Capabilities: [b0] Subsystem: Advanced Micro Devices, Inc. [AMD/ATI] Device 5a14
Capabilities: [b8] HyperTransport: MSI Mapping Enable+ Fixed+
Capabilities: [100 v1] Vendor Specific Information: ID=0001 Rev=1 Len=010 <?>

Capabilities: [190 v1] Access Control Services
ACSCap: SrcValid+ TransBlk+ ReqRedir+ CmpltRedir+ UpstreamFwd+
EgressCtrl- DirectTrans+
ACSCtl: SrcValid+ TransBlk- ReqRedir+ CmpltRedir+ UpstreamFwd+
EgressCtrl- DirectTrans-

Kernel driver in use: pcieport

00:07.0 PCI bridge: Advanced Micro Devices, Inc. [AMD/ATI] RD890 PCI
to PCI bridge (PCI express gpp port G) (prog-if 00 [Normal decode])
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-

Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0, Cache Line Size: 64 bytes
Bus: primary=00, secondary=05, subordinate=05, sec-latency=0

I/O behind bridge: 0000f000-00000fff
Memory behind bridge: fe600000-fe6fffff
Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort+ <SERR- <PERR-

BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
Capabilities: [50] Power Management version 3
Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)

Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
Capabilities: [58] Express (v2) Root Port (Slot+), MSI 00
DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
ExtTag+ RBE+ FLReset-

DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
MaxPayload 128 bytes, MaxReadReq 128 bytes
DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-

LnkCap: Port #3, Speed 5GT/s, Width x1, ASPM L0s L1, Latency L0 <1us, L1 <8us
ClockPM- Surprise- LLActRep+ BwNot+
LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-

LnkSta: Speed 5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+ BWMgmt+ ABWMgmt+
SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surprise-
Slot #7, PowerLimit 75.000W; Interlock- NoCompl+
SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-

Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
Changed: MRL- PresDet- LinkState-
RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-

RootCap: CRSVisible-
RootSta: PME ReqID 0000, PMEStatus- PMEPending-
DevCap2: Completion Timeout: Range ABCD, TimeoutDis+ ARIFwd+
DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis- ARIFwd-
LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-,
Selectable De-emphasis: -3.5dB

Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
Compliance De-emphasis: -6dB
LnkSta2: Current De-emphasis Level: -3.5dB, EqualizationComplete-,
EqualizationPhase1-
EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-

Capabilities: [a0] MSI: Enable- Count=1/1 Maskable- 64bit-
Address: 00000000  Data: 0000
Capabilities: [b0] Subsystem: Advanced Micro Devices, Inc. [AMD/ATI] Device 5a14
Capabilities: [b8] HyperTransport: MSI Mapping Enable+ Fixed+

Capabilities: [100 v1] Vendor Specific Information: ID=0001 Rev=1 Len=010 <?>
Capabilities: [190 v1] Access Control Services
ACSCap: SrcValid+ TransBlk+ ReqRedir+ CmpltRedir+ UpstreamFwd+
EgressCtrl- DirectTrans+

ACSCtl: SrcValid+ TransBlk- ReqRedir+ CmpltRedir+ UpstreamFwd+
EgressCtrl- DirectTrans-
Kernel driver in use: pcieport

00:09.0 PCI bridge: Advanced Micro Devices, Inc. [AMD/ATI] RD890 PCI
to PCI bridge (PCI express gpp port H) (prog-if 00 [Normal decode])

Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-

Latency: 0, Cache Line Size: 64 bytes
Bus: primary=00, secondary=06, subordinate=06, sec-latency=0
I/O behind bridge: 0000f000-00000fff
Memory behind bridge: fe500000-fe5fffff
Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff

Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort+ <SERR- <PERR-
BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-

Capabilities: [50] Power Management version 3
Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
Capabilities: [58] Express (v2) Root Port (Slot+), MSI 00

DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
ExtTag+ RBE+ FLReset-
DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+

MaxPayload 128 bytes, MaxReadReq 128 bytes
DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
LnkCap: Port #4, Speed 5GT/s, Width x1, ASPM L0s L1, Latency L0 <1us, L1 <8us
ClockPM- Surprise- LLActRep+ BwNot+

LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
LnkSta: Speed 5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+ BWMgmt+ ABWMgmt+
SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surprise-

Slot #9, PowerLimit 75.000W; Interlock- NoCompl+
SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-

Changed: MRL- PresDet- LinkState-
RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
RootCap: CRSVisible-
RootSta: PME ReqID 0000, PMEStatus- PMEPending-
DevCap2: Completion Timeout: Range ABCD, TimeoutDis+ ARIFwd+

DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis- ARIFwd-
LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-,
Selectable De-emphasis: -3.5dB
Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-

Compliance De-emphasis: -6dB
LnkSta2: Current De-emphasis Level: -3.5dB, EqualizationComplete-,
EqualizationPhase1-
EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
Capabilities: [a0] MSI: Enable- Count=1/1 Maskable- 64bit-

Address: 00000000  Data: 0000
Capabilities: [b0] Subsystem: Advanced Micro Devices, Inc. [AMD/ATI] Device 5a14
Capabilities: [b8] HyperTransport: MSI Mapping Enable+ Fixed+
Capabilities: [100 v1] Vendor Specific Information: ID=0001 Rev=1 Len=010 <?>

Capabilities: [190 v1] Access Control Services
ACSCap: SrcValid+ TransBlk+ ReqRedir+ CmpltRedir+ UpstreamFwd+
EgressCtrl- DirectTrans+
ACSCtl: SrcValid+ TransBlk- ReqRedir+ CmpltRedir+ UpstreamFwd+
EgressCtrl- DirectTrans-

Kernel driver in use: pcieport

00:0a.0 PCI bridge: Advanced Micro Devices, Inc. [AMD/ATI] RD890 PCI
to PCI bridge (external gfx1 port A) (prog-if 00 [Normal decode])
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-

Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0, Cache Line Size: 64 bytes
Bus: primary=00, secondary=07, subordinate=07, sec-latency=0

I/O behind bridge: 0000b000-0000bfff
Memory behind bridge: fe400000-fe4fffff
Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- <SERR- <PERR-

BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
Capabilities: [50] Power Management version 3
Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)

Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
Capabilities: [58] Express (v2) Root Port (Slot+), MSI 00
DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
ExtTag+ RBE+ FLReset-

DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
MaxPayload 128 bytes, MaxReadReq 128 bytes
DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-

LnkCap: Port #5, Speed 5GT/s, Width x1, ASPM L0s L1, Latency L0 <1us, L1 <8us
ClockPM- Surprise- LLActRep+ BwNot+
LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-

LnkSta: Speed 5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+ BWMgmt+ ABWMgmt+
SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surprise-
Slot #10, PowerLimit 75.000W; Interlock- NoCompl+
SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-

Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
Changed: MRL- PresDet- LinkState-
RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-

RootCap: CRSVisible-
RootSta: PME ReqID 0000, PMEStatus- PMEPending-
DevCap2: Completion Timeout: Range ABCD, TimeoutDis+ ARIFwd+
DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis- ARIFwd-
LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-,
Selectable De-emphasis: -3.5dB

Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
Compliance De-emphasis: -6dB
LnkSta2: Current De-emphasis Level: -3.5dB, EqualizationComplete-,
EqualizationPhase1-
EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-

Capabilities: [a0] MSI: Enable- Count=1/1 Maskable- 64bit-
Address: 00000000  Data: 0000
Capabilities: [b0] Subsystem: Advanced Micro Devices, Inc. [AMD/ATI] Device 5a14
Capabilities: [b8] HyperTransport: MSI Mapping Enable+ Fixed+

Capabilities: [100 v1] Vendor Specific Information: ID=0001 Rev=1 Len=010 <?>
Capabilities: [190 v1] Access Control Services
ACSCap: SrcValid+ TransBlk+ ReqRedir+ CmpltRedir+ UpstreamFwd+
EgressCtrl- DirectTrans+

ACSCtl: SrcValid+ TransBlk- ReqRedir+ CmpltRedir+ UpstreamFwd+
EgressCtrl- DirectTrans-
Kernel driver in use: pcieport

00:0b.0 PCI bridge: Advanced Micro Devices, Inc. [AMD/ATI] RD890 PCI
to PCI bridge (NB-SB link) (prog-if 00 [Normal decode])

Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-

Latency: 0, Cache Line Size: 64 bytes
Bus: primary=00, secondary=08, subordinate=08, sec-latency=0
I/O behind bridge: 0000a000-0000afff
Memory behind bridge: fe300000-fe3fffff
Prefetchable memory behind bridge: 00000000d0000000-00000000d1ffffff

Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- <SERR- <PERR-
BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-

Capabilities: [50] Power Management version 3
Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
Capabilities: [58] Express (v2) Root Port (Slot+), MSI 00

DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
ExtTag+ RBE+ FLReset-
DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+

MaxPayload 128 bytes, MaxReadReq 128 bytes
DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
LnkCap: Port #0, Speed 5GT/s, Width x16, ASPM L0s L1, Latency L0 <4us,
L1 unlimited
ClockPM- Surprise- LLActRep+ BwNot+

LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
LnkSta: Speed 2.5GT/s, Width x4, TrErr- Train- SlotClk+ DLActive+
BWMgmt+ ABWMgmt-
SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surprise-

Slot #11, PowerLimit 75.000W; Interlock- NoCompl+
SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-

Changed: MRL- PresDet- LinkState-
RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
RootCap: CRSVisible-
RootSta: PME ReqID 0000, PMEStatus- PMEPending-
DevCap2: Completion Timeout: Range ABCD, TimeoutDis+ ARIFwd+

DevCtl2: Completion Timeout: 65ms to 210ms, TimeoutDis- ARIFwd-
LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-,
Selectable De-emphasis: -3.5dB
Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-

Compliance De-emphasis: -6dB
LnkSta2: Current De-emphasis Level: -3.5dB, EqualizationComplete-,
EqualizationPhase1-
EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
Capabilities: [a0] MSI: Enable- Count=1/1 Maskable- 64bit-

Address: 00000000  Data: 0000
Capabilities: [b0] Subsystem: Advanced Micro Devices, Inc. [AMD/ATI] Device 5a14
Capabilities: [b8] HyperTransport: MSI Mapping Enable+ Fixed+
Capabilities: [100 v1] Vendor Specific Information: ID=0001 Rev=1 Len=010 <?>

Capabilities: [190 v1] Access Control Services
ACSCap: SrcValid+ TransBlk+ ReqRedir+ CmpltRedir+ UpstreamFwd+
EgressCtrl- DirectTrans+
ACSCtl: SrcValid+ TransBlk- ReqRedir+ CmpltRedir+ UpstreamFwd+
EgressCtrl- DirectTrans-

Kernel driver in use: pcieport

00:0d.0 PCI bridge: Advanced Micro Devices, Inc. [AMD/ATI] RD890 PCI
to PCI bridge (external gfx1 port B) (prog-if 00 [Normal decode])
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-

Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0, Cache Line Size: 64 bytes
Bus: primary=00, secondary=09, subordinate=09, sec-latency=0

I/O behind bridge: 00009000-00009fff
Memory behind bridge: fe200000-fe2fffff
Prefetchable memory behind bridge: 00000000b0000000-00000000bfffffff
Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- <SERR- <PERR-

BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
Capabilities: [50] Power Management version 3
Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)

Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
Capabilities: [58] Express (v2) Root Port (Slot+), MSI 00
DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
ExtTag+ RBE+ FLReset-

DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
MaxPayload 128 bytes, MaxReadReq 128 bytes
DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-

LnkCap: Port #0, Speed 5GT/s, Width x4, ASPM L0s L1, Latency L0 <4us,
L1 unlimited
ClockPM- Surprise- LLActRep+ BwNot+
LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-

LnkSta: Speed 5GT/s, Width x4, TrErr- Train- SlotClk+ DLActive+ BWMgmt+ ABWMgmt+
SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surprise-
Slot #13, PowerLimit 75.000W; Interlock- NoCompl+
SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-

Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
Changed: MRL- PresDet- LinkState-
RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-

RootCap: CRSVisible-
RootSta: PME ReqID 0000, PMEStatus- PMEPending-
DevCap2: Completion Timeout: Range ABCD, TimeoutDis+ ARIFwd+
DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis- ARIFwd-
LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-,
Selectable De-emphasis: -3.5dB

Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
Compliance De-emphasis: -6dB
LnkSta2: Current De-emphasis Level: -3.5dB, EqualizationComplete-,
EqualizationPhase1-
EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-

Capabilities: [a0] MSI: Enable- Count=1/1 Maskable- 64bit-
Address: 00000000  Data: 0000
Capabilities: [b0] Subsystem: Advanced Micro Devices, Inc. [AMD/ATI] Device 5a14
Capabilities: [b8] HyperTransport: MSI Mapping Enable+ Fixed+

Capabilities: [100 v1] Vendor Specific Information: ID=0001 Rev=1 Len=010 <?>
Capabilities: [190 v1] Access Control Services
ACSCap: SrcValid+ TransBlk+ ReqRedir+ CmpltRedir+ UpstreamFwd+
EgressCtrl- DirectTrans+

ACSCtl: SrcValid+ TransBlk- ReqRedir+ CmpltRedir+ UpstreamFwd+
EgressCtrl- DirectTrans-
Kernel driver in use: pcieport

00:11.0 SATA controller: Advanced Micro Devices, Inc. [AMD/ATI]
SB7x0/SB8x0/SB9x0 SATA Controller [AHCI mode] (rev 40) (prog-if 01
[AHCI 1.0])

Subsystem: ASUSTeK Computer Inc. Device 84dd
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-

Latency: 32
Interrupt: pin A routed to IRQ 19
Region 0: I/O ports at f040 [size=8]
Region 1: I/O ports at f030 [size=4]
Region 2: I/O ports at f020 [size=8]
Region 3: I/O ports at f010 [size=4]
Region 4: I/O ports at f000 [size=16]

Region 5: Memory at feb0b000 (32-bit, non-prefetchable) [size=1K]
Capabilities: [70] SATA HBA v1.0 InCfgSpace
Capabilities: [a4] PCI Advanced Features
AFCap: TP+ FLR+
AFCtrl: FLR-
AFStatus: TP-

Kernel driver in use: ahci

00:12.0 USB controller: Advanced Micro Devices, Inc. [AMD/ATI]
SB7x0/SB8x0/SB9x0 USB OHCI0 Controller (prog-if 10 [OHCI])
Subsystem: Advanced Micro Devices, Inc. [AMD/ATI] SB7x0/SB8x0/SB9x0
USB OHCI0 Controller

Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-

Latency: 32, Cache Line Size: 64 bytes
Interrupt: pin A routed to IRQ 18
Region 0: Memory at feb0a000 (32-bit, non-prefetchable) [size=4K]
Kernel driver in use: ohci-pci

00:12.2 USB controller: Advanced Micro Devices, Inc. [AMD/ATI]
SB7x0/SB8x0/SB9x0 USB EHCI Controller (prog-if 20 [EHCI])

Subsystem: Advanced Micro Devices, Inc. [AMD/ATI] SB7x0/SB8x0/SB9x0
USB EHCI Controller
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-

Latency: 32, Cache Line Size: 64 bytes
Interrupt: pin B routed to IRQ 17
Region 0: Memory at feb09000 (32-bit, non-prefetchable) [size=256]
Capabilities: [c0] Power Management version 2
Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold-)

Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
Bridge: PM- B3+
Capabilities: [e4] Debug port: BAR=1 offset=00e0
Kernel driver in use: ehci-pci

00:13.0 USB controller: Advanced Micro Devices, Inc. [AMD/ATI]
SB7x0/SB8x0/SB9x0 USB OHCI0 Controller (prog-if 10 [OHCI])

Subsystem: Advanced Micro Devices, Inc. [AMD/ATI] SB7x0/SB8x0/SB9x0
USB OHCI0 Controller
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-

Latency: 32, Cache Line Size: 64 bytes
Interrupt: pin A routed to IRQ 20
Region 0: Memory at feb08000 (32-bit, non-prefetchable) [size=4K]
Kernel driver in use: ohci-pci

00:13.2 USB controller: Advanced Micro Devices, Inc. [AMD/ATI]
SB7x0/SB8x0/SB9x0 USB EHCI Controller (prog-if 20 [EHCI])

Subsystem: Advanced Micro Devices, Inc. [AMD/ATI] SB7x0/SB8x0/SB9x0
USB EHCI Controller
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-

Latency: 32, Cache Line Size: 64 bytes
Interrupt: pin B routed to IRQ 21
Region 0: Memory at feb07000 (32-bit, non-prefetchable) [size=256]
Capabilities: [c0] Power Management version 2
Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold-)

Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
Bridge: PM- B3+
Capabilities: [e4] Debug port: BAR=1 offset=00e0
Kernel driver in use: ehci-pci

00:14.0 SMBus: Advanced Micro Devices, Inc. [AMD/ATI] SBx00 SMBus
Controller (rev 42)

Subsystem: Advanced Micro Devices, Inc. [AMD/ATI] SBx00 SMBus Controller
Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
Status: Cap- 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-


00:14.2 Audio device: Advanced Micro Devices, Inc. [AMD/ATI] SBx00
Azalia (Intel HDA) (rev 40)
Subsystem: ASUSTeK Computer Inc. Device 854b
Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-

Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=slow >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 32, Cache Line Size: 64 bytes
Interrupt: pin A routed to IRQ 16
Region 0: Memory at feb00000 (64-bit, non-prefetchable) [size=16K]

Capabilities: [50] Power Management version 2
Flags: PMEClk- DSI- D1- D2- AuxCurrent=55mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
Kernel driver in use: snd_hda_intel


00:14.3 ISA bridge: Advanced Micro Devices, Inc. [AMD/ATI]
SB7x0/SB8x0/SB9x0 LPC host controller (rev 40)
Subsystem: Advanced Micro Devices, Inc. [AMD/ATI] SB7x0/SB8x0/SB9x0
LPC host controller
Control: I/O+ Mem+ BusMaster+ SpecCycle+ MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-

Status: Cap- 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0

00:14.4 PCI bridge: Advanced Micro Devices, Inc. [AMD/ATI] SBx00 PCI
to PCI Bridge (rev 40) (prog-if 01 [Subtractive decode])

Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop+ ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-

Latency: 64
Bus: primary=00, secondary=0a, subordinate=0a, sec-latency=64
I/O behind bridge: 0000f000-00000fff
Memory behind bridge: fff00000-000fffff
Prefetchable memory behind bridge: fff00000-000fffff

Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort+ <SERR- <PERR-
BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-


00:14.5 USB controller: Advanced Micro Devices, Inc. [AMD/ATI]
SB7x0/SB8x0/SB9x0 USB OHCI2 Controller (prog-if 10 [OHCI])
Subsystem: Advanced Micro Devices, Inc. [AMD/ATI] SB7x0/SB8x0/SB9x0
USB OHCI2 Controller

Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-

Latency: 32, Cache Line Size: 64 bytes
Interrupt: pin C routed to IRQ 18
Region 0: Memory at feb06000 (32-bit, non-prefetchable) [size=4K]
Kernel driver in use: ohci-pci

00:15.0 PCI bridge: Advanced Micro Devices, Inc. [AMD/ATI]
SB700/SB800/SB900 PCI to PCI bridge (PCIE port 0) (prog-if 00 [Normal
decode])

Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-

Latency: 0, Cache Line Size: 64 bytes
Bus: primary=00, secondary=0b, subordinate=0b, sec-latency=0
I/O behind bridge: 0000f000-00000fff
Memory behind bridge: fff00000-000fffff
Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff

Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- <SERR- <PERR-
BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-

Capabilities: [50] Power Management version 3
Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
Capabilities: [58] Express (v2) Root Port (Slot-), MSI 00

DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
ExtTag+ RBE+ FLReset-
DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+

MaxPayload 128 bytes, MaxReadReq 128 bytes
DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
LnkCap: Port #247, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0
<64ns, L1 <1us
ClockPM- Surprise- LLActRep+ BwNot+

LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
LnkSta: Speed unknown, Width x16, TrErr- Train- SlotClk+ DLActive-
BWMgmt- ABWMgmt-
RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-

RootCap: CRSVisible-
RootSta: PME ReqID 0000, PMEStatus- PMEPending-
DevCap2: Completion Timeout: Range ABCD, TimeoutDis+ ARIFwd-
DevCtl2: Completion Timeout: 65ms to 210ms, TimeoutDis- ARIFwd-
LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-,
Selectable De-emphasis: -3.5dB

Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
Compliance De-emphasis: -6dB
LnkSta2: Current De-emphasis Level: -6dB, EqualizationComplete-,
EqualizationPhase1-
EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-

Capabilities: [a0] MSI: Enable- Count=1/1 Maskable- 64bit+
Address: 0000000000000000  Data: 0000
Capabilities: [b0] Subsystem: Advanced Micro Devices, Inc. [AMD/ATI] Device 0000
Capabilities: [b8] HyperTransport: MSI Mapping Enable+ Fixed+

Capabilities: [100 v1] Vendor Specific Information: ID=0001 Rev=1 Len=010 <?>
Kernel driver in use: pcieport

00:15.1 PCI bridge: Advanced Micro Devices, Inc. [AMD/ATI]
SB700/SB800/SB900 PCI to PCI bridge (PCIE port 1) (prog-if 00 [Normal
decode])

Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-

Latency: 0, Cache Line Size: 64 bytes
Bus: primary=00, secondary=0c, subordinate=0d, sec-latency=0
I/O behind bridge: 0000f000-00000fff
Memory behind bridge: fe100000-fe1fffff
Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff

Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort+ <SERR- <PERR-
BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-

Capabilities: [50] Power Management version 3
Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
Capabilities: [58] Express (v2) Root Port (Slot-), MSI 00

DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
ExtTag+ RBE+ FLReset-
DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+

MaxPayload 128 bytes, MaxReadReq 128 bytes
DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
LnkCap: Port #1, Speed 5GT/s, Width x1, ASPM L0s L1, Latency L0 <64ns, L1 <1us
ClockPM- Surprise- LLActRep+ BwNot+

LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+
BWMgmt+ ABWMgmt-
RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-

RootCap: CRSVisible-
RootSta: PME ReqID 0000, PMEStatus- PMEPending-
DevCap2: Completion Timeout: Range ABCD, TimeoutDis+ ARIFwd-
DevCtl2: Completion Timeout: 65ms to 210ms, TimeoutDis- ARIFwd-
LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-,
Selectable De-emphasis: -3.5dB

Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
Compliance De-emphasis: -6dB
LnkSta2: Current De-emphasis Level: -3.5dB, EqualizationComplete-,
EqualizationPhase1-
EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-

Capabilities: [a0] MSI: Enable- Count=1/1 Maskable- 64bit+
Address: 0000000000000000  Data: 0000
Capabilities: [b0] Subsystem: Advanced Micro Devices, Inc. [AMD/ATI] Device 0000
Capabilities: [b8] HyperTransport: MSI Mapping Enable+ Fixed+

Capabilities: [100 v1] Vendor Specific Information: ID=0001 Rev=1 Len=010 <?>
Kernel driver in use: pcieport

00:16.0 USB controller: Advanced Micro Devices, Inc. [AMD/ATI]
SB7x0/SB8x0/SB9x0 USB OHCI0 Controller (prog-if 10 [OHCI])

Subsystem: Advanced Micro Devices, Inc. [AMD/ATI] SB7x0/SB8x0/SB9x0
USB OHCI0 Controller
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-

Latency: 32, Cache Line Size: 64 bytes
Interrupt: pin A routed to IRQ 22
Region 0: Memory at feb05000 (32-bit, non-prefetchable) [size=4K]
Kernel driver in use: ohci-pci

00:16.2 USB controller: Advanced Micro Devices, Inc. [AMD/ATI]
SB7x0/SB8x0/SB9x0 USB EHCI Controller (prog-if 20 [EHCI])

Subsystem: Advanced Micro Devices, Inc. [AMD/ATI] SB7x0/SB8x0/SB9x0
USB EHCI Controller
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-

Latency: 32, Cache Line Size: 64 bytes
Interrupt: pin B routed to IRQ 23
Region 0: Memory at feb04000 (32-bit, non-prefetchable) [size=256]
Capabilities: [c0] Power Management version 2
Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold-)

Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
Bridge: PM- B3+
Capabilities: [e4] Debug port: BAR=1 offset=00e0
Kernel driver in use: ehci-pci

00:18.0 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 10h
Processor HyperTransport Configuration

Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-

Capabilities: [80] HyperTransport: Host or Secondary Interface
Command: WarmRst+ DblEnd- DevNum=0 ChainSide- HostHide+ Slave- <EOCErr- DUL-
Link Control: CFlE- CST- CFE- <LkFail- Init+ EOC- TXO- <CRCErr=0
IsocEn- LSEn+ ExtCTL- 64b-

Link Config: MLWI=16bit DwFcIn- MLWO=16bit DwFcOut- LWI=16bit
DwFcInEn- LWO=16bit DwFcOutEn-
Revision ID: 3.00
Link Frequency: [b]
Link Error: <Prot- <Ovfl- <EOC- CTLTm-
Link Frequency Capability: 200MHz+ 300MHz- 400MHz+ 500MHz- 600MHz+
800MHz+ 1.0GHz+ 1.2GHz+ 1.4GHz- 1.6GHz- Vend-

Feature Capability: IsocFC+ LDTSTOP+ CRCTM- ECTLT- 64bA+ UIDRD- ExtRS- UCnfE-

00:18.1 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 10h
Processor Address Map
Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-

Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-

00:18.2 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 10h
Processor DRAM Controller
Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-

Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-

00:18.3 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 10h
Processor Miscellaneous Control

Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-

Capabilities: [f0] Secure device <?>
Kernel driver in use: k10temp

00:18.4 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 10h
Processor Link Control
Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-

Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-

01:00.0 VGA compatible controller: Advanced Micro Devices, Inc.
[AMD/ATI] Pitcairn XT [Radeon HD 7870 GHz Edition] (prog-if 00 [VGA
controller])

Subsystem: XFX Pine Group Inc. Device 3250
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-

Latency: 0, Cache Line Size: 64 bytes
Interrupt: pin A routed to IRQ 73
Region 0: Memory at c0000000 (64-bit, prefetchable) [size=256M]
Region 2: Memory at fea00000 (64-bit, non-prefetchable) [size=256K]
Region 4: I/O ports at e000 [size=256]

Expansion ROM at fea40000 [disabled] [size=128K]
Capabilities: [48] Vendor Specific Information: Len=08 <?>
Capabilities: [50] Power Management version 3
Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1+,D2+,D3hot+,D3cold-)

Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
Capabilities: [58] Express (v2) Legacy Endpoint, MSI 00
DevCap: MaxPayload 256 bytes, PhantFunc 0, Latency L0s <4us, L1 unlimited
ExtTag+ AttnBtn- AttnInd- PwrInd- RBE+ FLReset-

DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
MaxPayload 128 bytes, MaxReadReq 512 bytes
DevSta: CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr- TransPend-

LnkCap: Port #0, Speed 8GT/s, Width x16, ASPM L0s L1, Latency L0 <64ns, L1 <1us
ClockPM- Surprise- LLActRep- BwNot-
LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-

LnkSta: Speed 5GT/s, Width x16, TrErr- Train- SlotClk+ DLActive-
BWMgmt- ABWMgmt-
DevCap2: Completion Timeout: Not Supported, TimeoutDis-
DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
LnkCtl2: Target Link Speed: 8GT/s, EnterCompliance- SpeedDis-,
Selectable De-emphasis: -6dB

Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
Compliance De-emphasis: -6dB
LnkSta2: Current De-emphasis Level: -3.5dB, EqualizationComplete-,
EqualizationPhase1-
EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-

Capabilities: [a0] MSI: Enable+ Count=1/1 Maskable- 64bit+
Address: 00000000fee00000  Data: 0000
Capabilities: [100 v1] Vendor Specific Information: ID=0001 Rev=1 Len=010 <?>
Capabilities: [150 v2] Advanced Error Reporting

UESta: DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF-
MalfTLP- ECRC- UnsupReq- ACSViol-
UEMsk: DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF-
MalfTLP- ECRC- UnsupReq- ACSViol-
UESvrt: DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+
MalfTLP+ ECRC- UnsupReq- ACSViol-

CESta: RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
CEMsk: RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
AERCap: First Error Pointer: 00, GenCap+ CGenEn- ChkCap+ ChkEn-
Capabilities: [270 v1] #19

Capabilities: [2b0 v1] Address Translation Service (ATS)
ATSCap: Invalidate Queue Depth: 00
ATSCtl: Enable+, Smallest Translation Unit: 00
Capabilities: [2c0 v1] #13
Capabilities: [2d0 v1] #1b
Kernel driver in use: radeon


01:00.1 Audio device: Advanced Micro Devices, Inc. [AMD/ATI] Cape
Verde/Pitcairn HDMI Audio [Radeon HD 7700/7800 Series]
Subsystem: XFX Pine Group Inc. Device aab0
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-

Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0, Cache Line Size: 64 bytes
Interrupt: pin B routed to IRQ 15
Region 0: Memory at fea60000 (64-bit, non-prefetchable) [size=16K]

Capabilities: [48] Vendor Specific Information: Len=08 <?>
Capabilities: [50] Power Management version 3
Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-

Capabilities: [58] Express (v2) Legacy Endpoint, MSI 00
DevCap: MaxPayload 256 bytes, PhantFunc 0, Latency L0s <4us, L1 unlimited
ExtTag+ AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-

RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
MaxPayload 128 bytes, MaxReadReq 512 bytes
DevSta: CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr- TransPend-
LnkCap: Port #0, Speed 8GT/s, Width x16, ASPM L0s L1, Latency L0 <64ns, L1 <1us

ClockPM- Surprise- LLActRep- BwNot-
LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
LnkSta: Speed 5GT/s, Width x16, TrErr- Train- SlotClk+ DLActive-
BWMgmt- ABWMgmt-

DevCap2: Completion Timeout: Not Supported, TimeoutDis-
DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-,
Selectable De-emphasis: -6dB
Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-

Compliance De-emphasis: -6dB
LnkSta2: Current De-emphasis Level: -3.5dB, EqualizationComplete-,
EqualizationPhase1-
EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
Capabilities: [a0] MSI: Enable- Count=1/1 Maskable- 64bit+

Address: 0000000000000000  Data: 0000
Capabilities: [100 v1] Vendor Specific Information: ID=0001 Rev=1 Len=010 <?>
Capabilities: [150 v2] Advanced Error Reporting
UESta: DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF-
MalfTLP- ECRC- UnsupReq- ACSViol-

UEMsk: DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF-
MalfTLP- ECRC- UnsupReq- ACSViol-
UESvrt: DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+
MalfTLP+ ECRC- UnsupReq- ACSViol-
CESta: RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+

CEMsk: RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
AERCap: First Error Pointer: 00, GenCap+ CGenEn- ChkCap+ ChkEn-
Kernel driver in use: pci-stub

02:00.0 SATA controller: ASMedia Technology Inc. ASM1062 Serial ATA
Controller (rev 01) (prog-if 01 [AHCI 1.0])

Subsystem: ASUSTeK Computer Inc. Device 84b7
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-

Latency: 0, Cache Line Size: 64 bytes
Interrupt: pin A routed to IRQ 74
Region 0: I/O ports at d050 [size=8]
Region 1: I/O ports at d040 [size=4]
Region 2: I/O ports at d030 [size=8]
Region 3: I/O ports at d020 [size=4]

Region 4: I/O ports at d000 [size=32]
Region 5: Memory at fe900000 (32-bit, non-prefetchable) [size=512]
Capabilities: [50] MSI: Enable+ Count=1/1 Maskable- 64bit-
Address: fee00000  Data: 0000
Capabilities: [78] Power Management version 3

Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
Capabilities: [80] Express (v2) Legacy Endpoint, MSI 00
DevCap: MaxPayload 512 bytes, PhantFunc 0, Latency L0s <1us, L1 <8us

ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
MaxPayload 128 bytes, MaxReadReq 512 bytes

DevSta: CorrErr+ UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
LnkCap: Port #1, Speed 5GT/s, Width x1, ASPM L0s, Latency L0 <512ns, L1 <2us
ClockPM- Surprise- LLActRep- BwNot-
LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+

ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
LnkSta: Speed 5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
DevCap2: Completion Timeout: Range ABC, TimeoutDis+
DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-

LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-,
Selectable De-emphasis: -6dB
Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
Compliance De-emphasis: -6dB

LnkSta2: Current De-emphasis Level: -3.5dB, EqualizationComplete-,
EqualizationPhase1-
EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
Capabilities: [100 v1] Virtual Channel
Caps: LPEVC=0 RefClk=100ns PATEntryBits=1

Arb: Fixed- WRR32- WRR64- WRR128-
Ctrl: ArbSelect=Fixed
Status: InProgress-
VC0: Caps: PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
Arb: Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
Ctrl: Enable+ ID=0 ArbSelect=Fixed TC/VC=01

Status: NegoPending- InProgress-
Kernel driver in use: ahci

03:00.0 Ethernet controller: Intel Corporation 82583V Gigabit Network Connection
Subsystem: ASUSTeK Computer Inc. Device 8457
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+

Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0, Cache Line Size: 64 bytes
Interrupt: pin A routed to IRQ 76
Region 0: Memory at fe800000 (32-bit, non-prefetchable) [size=128K]

Region 2: I/O ports at c000 [size=32]
Region 3: Memory at fe820000 (32-bit, non-prefetchable) [size=16K]
Capabilities: [c8] Power Management version 2
Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)

Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=1 PME-
Capabilities: [d0] MSI: Enable+ Count=1/1 Maskable- 64bit+
Address: 00000000fee00000  Data: 0000
Capabilities: [e0] Express (v1) Endpoint, MSI 00
DevCap: MaxPayload 256 bytes, PhantFunc 0, Latency L0s <512ns, L1 <64us

ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
DevCtl: Report errors: Correctable+ Non-Fatal+ Fatal+ Unsupported+
RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
MaxPayload 128 bytes, MaxReadReq 512 bytes

DevSta: CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr+ TransPend-
LnkCap: Port #1, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0
<128ns, L1 <64us
ClockPM- Surprise- LLActRep- BwNot-
LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+

ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive-
BWMgmt- ABWMgmt-
Capabilities: [a0] MSI-X: Enable- Count=1 Masked-
Vector table: BAR=3 offset=00000000

PBA: BAR=3 offset=00002000
Capabilities: [100 v1] Advanced Error Reporting
UESta: DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF-
MalfTLP- ECRC- UnsupReq- ACSViol-
UEMsk: DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF-
MalfTLP- ECRC- UnsupReq- ACSViol-

UESvrt: DLP+ SDES- TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+
MalfTLP+ ECRC- UnsupReq- ACSViol-
CESta: RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
CEMsk: RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+

AERCap: First Error Pointer: 00, GenCap- CGenEn- ChkCap- ChkEn-
Capabilities: [140 v1] Device Serial Number 60-a4-4c-ff-ff-63-f9-05
Kernel driver in use: e1000e

04:00.0 USB controller: ASMedia Technology Inc. ASM1042 SuperSpeed USB
Host Controller (prog-if 30 [XHCI])

Subsystem: ASUSTeK Computer Inc. Device 8488
Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-

Latency: 0, Cache Line Size: 64 bytes
Interrupt: pin A routed to IRQ 51
Region 0: Memory at fe700000 (64-bit, non-prefetchable) [size=32K]
Capabilities: [50] MSI: Enable- Count=1/8 Maskable- 64bit+
Address: 0000000000000000  Data: 0000

Capabilities: [68] MSI-X: Enable+ Count=8 Masked-
Vector table: BAR=0 offset=00002000
PBA: BAR=0 offset=00002080
Capabilities: [78] Power Management version 3
Flags: PMEClk- DSI- D1- D2- AuxCurrent=55mA PME(D0-,D1-,D2-,D3hot+,D3cold+)

Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
Capabilities: [80] Express (v2) Legacy Endpoint, MSI 00
DevCap: MaxPayload 512 bytes, PhantFunc 0, Latency L0s <64ns, L1 <2us
ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-

DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
MaxPayload 128 bytes, MaxReadReq 512 bytes
DevSta: CorrErr+ UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-

LnkCap: Port #1, Speed 5GT/s, Width x1, ASPM L0s L1, Latency L0
unlimited, L1 unlimited
ClockPM- Surprise- LLActRep- BwNot-
LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-

LnkSta: Speed 5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
DevCap2: Completion Timeout: Not Supported, TimeoutDis-
DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-,
Selectable De-emphasis: -6dB

Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
Compliance De-emphasis: -6dB
LnkSta2: Current De-emphasis Level: -3.5dB, EqualizationComplete-,
EqualizationPhase1-
EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-

Capabilities: [100 v1] Virtual Channel
Caps: LPEVC=0 RefClk=100ns PATEntryBits=1
Arb: Fixed- WRR32- WRR64- WRR128-
Ctrl: ArbSelect=Fixed
Status: InProgress-
VC0: Caps: PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-

Arb: Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
Ctrl: Enable+ ID=0 ArbSelect=Fixed TC/VC=01
Status: NegoPending- InProgress-
Kernel driver in use: xhci_hcd

05:00.0 USB controller: ASMedia Technology Inc. ASM1042 SuperSpeed USB
Host Controller (prog-if 30 [XHCI])

Subsystem: ASUSTeK Computer Inc. Device 8488
Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-

Latency: 0, Cache Line Size: 64 bytes
Interrupt: pin A routed to IRQ 50
Region 0: Memory at fe600000 (64-bit, non-prefetchable) [size=32K]
Capabilities: [50] MSI: Enable- Count=1/8 Maskable- 64bit+
Address: 0000000000000000  Data: 0000

Capabilities: [68] MSI-X: Enable+ Count=8 Masked-
Vector table: BAR=0 offset=00002000
PBA: BAR=0 offset=00002080
Capabilities: [78] Power Management version 3
Flags: PMEClk- DSI- D1- D2- AuxCurrent=55mA PME(D0-,D1-,D2-,D3hot+,D3cold+)

Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
Capabilities: [80] Express (v2) Legacy Endpoint, MSI 00
DevCap: MaxPayload 512 bytes, PhantFunc 0, Latency L0s <64ns, L1 <2us
ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-

DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
MaxPayload 128 bytes, MaxReadReq 512 bytes
DevSta: CorrErr+ UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-

LnkCap: Port #1, Speed 5GT/s, Width x1, ASPM L0s L1, Latency L0
unlimited, L1 unlimited
ClockPM- Surprise- LLActRep- BwNot-
LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-

LnkSta: Speed 5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
DevCap2: Completion Timeout: Not Supported, TimeoutDis-
DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-,
Selectable De-emphasis: -6dB

Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
Compliance De-emphasis: -6dB
LnkSta2: Current De-emphasis Level: -3.5dB, EqualizationComplete-,
EqualizationPhase1-
EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-

Capabilities: [100 v1] Virtual Channel
Caps: LPEVC=0 RefClk=100ns PATEntryBits=1
Arb: Fixed- WRR32- WRR64- WRR128-
Ctrl: ArbSelect=Fixed
Status: InProgress-
VC0: Caps: PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-

Arb: Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
Ctrl: Enable+ ID=0 ArbSelect=Fixed TC/VC=01
Status: NegoPending- InProgress-
Kernel driver in use: xhci_hcd

06:00.0 USB controller: ASMedia Technology Inc. ASM1042 SuperSpeed USB
Host Controller (prog-if 30 [XHCI])

Subsystem: ASUSTeK Computer Inc. Device 8488
Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-

Latency: 0, Cache Line Size: 64 bytes
Interrupt: pin A routed to IRQ 48
Region 0: Memory at fe500000 (64-bit, non-prefetchable) [size=32K]
Capabilities: [50] MSI: Enable- Count=1/8 Maskable- 64bit+
Address: 0000000000000000  Data: 0000

Capabilities: [68] MSI-X: Enable+ Count=8 Masked-
Vector table: BAR=0 offset=00002000
PBA: BAR=0 offset=00002080
Capabilities: [78] Power Management version 3
Flags: PMEClk- DSI- D1- D2- AuxCurrent=55mA PME(D0-,D1-,D2-,D3hot+,D3cold+)

Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
Capabilities: [80] Express (v2) Legacy Endpoint, MSI 00
DevCap: MaxPayload 512 bytes, PhantFunc 0, Latency L0s <64ns, L1 <2us
ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-

DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
MaxPayload 128 bytes, MaxReadReq 512 bytes
DevSta: CorrErr+ UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-

LnkCap: Port #1, Speed 5GT/s, Width x1, ASPM L0s L1, Latency L0
unlimited, L1 unlimited
ClockPM- Surprise- LLActRep- BwNot-
LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-

LnkSta: Speed 5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
DevCap2: Completion Timeout: Not Supported, TimeoutDis-
DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-,
Selectable De-emphasis: -6dB

Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
Compliance De-emphasis: -6dB
LnkSta2: Current De-emphasis Level: -3.5dB, EqualizationComplete-,
EqualizationPhase1-
EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-

Capabilities: [100 v1] Virtual Channel
Caps: LPEVC=0 RefClk=100ns PATEntryBits=1
Arb: Fixed- WRR32- WRR64- WRR128-
Ctrl: ArbSelect=Fixed
Status: InProgress-
VC0: Caps: PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-

Arb: Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
Ctrl: Enable+ ID=0 ArbSelect=Fixed TC/VC=01
Status: NegoPending- InProgress-
Kernel driver in use: xhci_hcd

07:00.0 SATA controller: ASMedia Technology Inc. ASM1062 Serial ATA
Controller (rev 01) (prog-if 01 [AHCI 1.0])

Subsystem: ASUSTeK Computer Inc. Device 84b7
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-

Latency: 0, Cache Line Size: 64 bytes
Interrupt: pin A routed to IRQ 75
Region 0: I/O ports at b050 [size=8]
Region 1: I/O ports at b040 [size=4]
Region 2: I/O ports at b030 [size=8]
Region 3: I/O ports at b020 [size=4]

Region 4: I/O ports at b000 [size=32]
Region 5: Memory at fe400000 (32-bit, non-prefetchable) [size=512]
Capabilities: [50] MSI: Enable+ Count=1/1 Maskable- 64bit-
Address: fee00000  Data: 0000
Capabilities: [78] Power Management version 3

Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
Capabilities: [80] Express (v2) Legacy Endpoint, MSI 00
DevCap: MaxPayload 512 bytes, PhantFunc 0, Latency L0s <1us, L1 <8us

ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
MaxPayload 128 bytes, MaxReadReq 512 bytes

DevSta: CorrErr+ UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
LnkCap: Port #1, Speed 5GT/s, Width x1, ASPM L0s, Latency L0 <512ns, L1 <2us
ClockPM- Surprise- LLActRep- BwNot-
LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+

ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
LnkSta: Speed 5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
DevCap2: Completion Timeout: Range ABC, TimeoutDis+
DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-

LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-,
Selectable De-emphasis: -6dB
Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
Compliance De-emphasis: -6dB

LnkSta2: Current De-emphasis Level: -3.5dB, EqualizationComplete-,
EqualizationPhase1-
EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
Capabilities: [100 v1] Virtual Channel
Caps: LPEVC=0 RefClk=100ns PATEntryBits=1

Arb: Fixed- WRR32- WRR64- WRR128-
Ctrl: ArbSelect=Fixed
Status: InProgress-
VC0: Caps: PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
Arb: Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
Ctrl: Enable+ ID=0 ArbSelect=Fixed TC/VC=01

Status: NegoPending- InProgress-
Kernel driver in use: ahci

08:00.0 RAID bus controller: 3ware Inc 9650SE SATA-II RAID PCIe (rev 01)
Subsystem: 3ware Inc 9650SE SATA-II RAID PCIe
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-

Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0, Cache Line Size: 64 bytes
Interrupt: pin A routed to IRQ 32
Region 0: Memory at d0000000 (64-bit, prefetchable) [size=32M]

Region 2: Memory at fe320000 (64-bit, non-prefetchable) [size=4K]
Region 4: I/O ports at a000 [size=256]
Expansion ROM at fe300000 [disabled] [size=128K]
Capabilities: [40] Power Management version 2
Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)

Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
Capabilities: [50] MSI: Enable- Count=1/32 Maskable- 64bit+
Address: 0000000000000000  Data: 0000
Capabilities: [70] Express (v1) Legacy Endpoint, MSI 00

DevCap: MaxPayload 512 bytes, PhantFunc 0, Latency L0s <128ns, L1 <2us
ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+

MaxPayload 128 bytes, MaxReadReq 512 bytes
DevSta: CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr- TransPend-
LnkCap: Port #0, Speed 2.5GT/s, Width x8, ASPM L0s L1, Latency L0
<512ns, L1 <64us
ClockPM- Surprise- LLActRep+ BwNot-

LnkCtl: ASPM Disabled; RCB 128 bytes Disabled- Retrain- CommClk-
ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
LnkSta: Speed 2.5GT/s, Width x4, TrErr- Train- SlotClk- DLActive+
BWMgmt- ABWMgmt-
Capabilities: [100 v1] Advanced Error Reporting

UESta: DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF-
MalfTLP- ECRC- UnsupReq+ ACSViol-
UEMsk: DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF-
MalfTLP- ECRC- UnsupReq- ACSViol-
UESvrt: DLP+ SDES- TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+
MalfTLP+ ECRC- UnsupReq- ACSViol-

CESta: RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
CEMsk: RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
AERCap: First Error Pointer: 00, GenCap+ CGenEn- ChkCap+ ChkEn-
Kernel driver in use: 3w-9xxx


09:00.0 VGA compatible controller: Advanced Micro Devices, Inc.
[AMD/ATI] Pitcairn PRO [Radeon HD 7850] (prog-if 00 [VGA controller])
Subsystem: PC Partner Limited / Sapphire Technology Radeon HD 7850 2GB
GDDR5 DVI-I/DVI-D/HDMI/DP

Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-

Interrupt: pin A routed to IRQ 10
Region 0: Memory at b0000000 (64-bit, prefetchable) [disabled] [size=256M]
Region 2: Memory at fe200000 (64-bit, non-prefetchable) [disabled] [size=256K]
Region 4: I/O ports at 9000 [disabled] [size=256]

Expansion ROM at fe240000 [disabled] [size=128K]
Capabilities: [48] Vendor Specific Information: Len=08 <?>
Capabilities: [50] Power Management version 3
Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1+,D2+,D3hot+,D3cold-)

Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
Capabilities: [58] Express (v2) Legacy Endpoint, MSI 00
DevCap: MaxPayload 256 bytes, PhantFunc 0, Latency L0s <4us, L1 unlimited
ExtTag+ AttnBtn- AttnInd- PwrInd- RBE+ FLReset-

DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
MaxPayload 128 bytes, MaxReadReq 512 bytes
DevSta: CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr- TransPend-

LnkCap: Port #0, Speed 8GT/s, Width x16, ASPM L0s L1, Latency L0 <64ns, L1 <1us
ClockPM- Surprise- LLActRep- BwNot-
LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-

LnkSta: Speed 5GT/s, Width x4, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
DevCap2: Completion Timeout: Not Supported, TimeoutDis-
DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
LnkCtl2: Target Link Speed: 8GT/s, EnterCompliance- SpeedDis-,
Selectable De-emphasis: -6dB

Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
Compliance De-emphasis: -6dB
LnkSta2: Current De-emphasis Level: -3.5dB, EqualizationComplete-,
EqualizationPhase1-
EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-

Capabilities: [a0] MSI: Enable- Count=1/1 Maskable- 64bit+
Address: 0000000000000000  Data: 0000
Capabilities: [100 v1] Vendor Specific Information: ID=0001 Rev=1 Len=010 <?>
Capabilities: [150 v2] Advanced Error Reporting

UESta: DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF-
MalfTLP- ECRC- UnsupReq- ACSViol-
UEMsk: DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF-
MalfTLP- ECRC- UnsupReq- ACSViol-
UESvrt: DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+
MalfTLP+ ECRC- UnsupReq- ACSViol-

CESta: RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
CEMsk: RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
AERCap: First Error Pointer: 00, GenCap+ CGenEn- ChkCap+ ChkEn-
Capabilities: [270 v1] #19

Capabilities: [2b0 v1] Address Translation Service (ATS)
ATSCap: Invalidate Queue Depth: 00
ATSCtl: Enable+, Smallest Translation Unit: 00
Capabilities: [2c0 v1] #13
Capabilities: [2d0 v1] #1b
Kernel driver in use: pci-stub


09:00.1 Audio device: Advanced Micro Devices, Inc. [AMD/ATI] Cape
Verde/Pitcairn HDMI Audio [Radeon HD 7700/7800 Series]
Subsystem: PC Partner Limited / Sapphire Technology Device aab0
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-

Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0, Cache Line Size: 64 bytes
Interrupt: pin B routed to IRQ 15
Region 0: Memory at fe260000 (64-bit, non-prefetchable) [size=16K]

Capabilities: [48] Vendor Specific Information: Len=08 <?>
Capabilities: [50] Power Management version 3
Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-

Capabilities: [58] Express (v2) Legacy Endpoint, MSI 00
DevCap: MaxPayload 256 bytes, PhantFunc 0, Latency L0s <4us, L1 unlimited
ExtTag+ AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-

RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
MaxPayload 128 bytes, MaxReadReq 512 bytes
DevSta: CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr- TransPend-
LnkCap: Port #0, Speed 8GT/s, Width x16, ASPM L0s L1, Latency L0 <64ns, L1 <1us

ClockPM- Surprise- LLActRep- BwNot-
LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
LnkSta: Speed 5GT/s, Width x4, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-

DevCap2: Completion Timeout: Not Supported, TimeoutDis-
DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-,
Selectable De-emphasis: -6dB
Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-

Compliance De-emphasis: -6dB
LnkSta2: Current De-emphasis Level: -3.5dB, EqualizationComplete-,
EqualizationPhase1-
EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
Capabilities: [a0] MSI: Enable- Count=1/1 Maskable- 64bit+

Address: 0000000000000000  Data: 0000
Capabilities: [100 v1] Vendor Specific Information: ID=0001 Rev=1 Len=010 <?>
Capabilities: [150 v2] Advanced Error Reporting
UESta: DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF-
MalfTLP- ECRC- UnsupReq- ACSViol-

UEMsk: DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF-
MalfTLP- ECRC- UnsupReq- ACSViol-
UESvrt: DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+
MalfTLP+ ECRC- UnsupReq- ACSViol-
CESta: RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+

CEMsk: RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
AERCap: First Error Pointer: 00, GenCap+ CGenEn- ChkCap+ ChkEn-
Kernel driver in use: pci-stub

0c:00.0 PCI bridge: Creative Labs [SB X-Fi Xtreme Audio] CA0110-IBG
PCI to PCIe Bridge (prog-if 00 [Normal decode])

Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-

Latency: 0, Cache Line Size: 64 bytes
Bus: primary=0c, secondary=0d, subordinate=0d, sec-latency=32
I/O behind bridge: 0000f000-00000fff
Memory behind bridge: fe100000-fe1fffff
Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff

Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort+ <SERR- <PERR-
BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-

Capabilities: [50] Power Management version 3
Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
Bridge: PM- B3+
Capabilities: [60] MSI: Enable- Count=1/16 Maskable- 64bit+

Address: 0000000000000000  Data: 0000
Capabilities: [80] Subsystem: Creative Labs Device 0010
Capabilities: [90] Express (v1) PCI/PCI-X Bridge, MSI 00
DevCap: MaxPayload 512 bytes, PhantFunc 0, Latency L0s <4us, L1 <64us

ExtTag- AttnBtn- AttnInd- PwrInd- RBE- FLReset-
DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+ BrConfRtry-
MaxPayload 128 bytes, MaxReadReq 512 bytes

DevSta: CorrErr- UncorrErr+ FatalErr- UnsuppReq+ AuxPwr- TransPend-
LnkCap: Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0
<512ns, L1 <16us
ClockPM- Surprise- LLActRep- BwNot-
LnkCtl: ASPM Disabled; Disabled- Retrain- CommClk+

ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive-
BWMgmt- ABWMgmt-
Capabilities: [100 v1] Advanced Error Reporting
UESta: DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF-
MalfTLP- ECRC- UnsupReq+ ACSViol-

UEMsk: DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF-
MalfTLP- ECRC- UnsupReq- ACSViol-
UESvrt: DLP+ SDES- TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+
MalfTLP+ ECRC- UnsupReq- ACSViol-
CESta: RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-

CEMsk: RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
AERCap: First Error Pointer: 14, GenCap+ CGenEn- ChkCap+ ChkEn-

0d:00.0 Audio device: Creative Labs [SB X-Fi Xtreme Audio] CA0110-IBG
Subsystem: Creative Labs SB1040

Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-

Latency: 32 (500ns min, 5000ns max)
Interrupt: pin A routed to IRQ 21
Region 0: Memory at fe100000 (32-bit, non-prefetchable) [size=16K]
Capabilities: [dc] Power Management version 3
Flags: PMEClk- DSI+ D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)

Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
Kernel driver in use: snd_hda_intel

root@MainDesktop1:/usr/src/linux-3.13.1#


[7.6.] SCSI information (from /proc/scsi/scsi):

root@MainDesktop1:/usr/src/linux-3.13.1# cat /proc/scsi/scsi

Attached devices:
Host: scsi0 Channel: 00 Id: 00 Lun: 00
  Vendor: AMCC     Model: 9650SE-8LP DISK  Rev: 4.10
  Type:   Direct-Access                    ANSI  SCSI revision: 05
Host: scsi0 Channel: 00 Id: 00 Lun: 01

  Vendor: AMCC     Model: 9650SE-8LP DISK  Rev: 4.10
  Type:   Direct-Access                    ANSI  SCSI revision: 05
Host: scsi3 Channel: 00 Id: 00 Lun: 00
  Vendor: HL-DT-ST Model: BD-RE  WH14NS40  Rev: 1.00

  Type:   CD-ROM                           ANSI  SCSI revision: 05
Host: scsi8 Channel: 00 Id: 00 Lun: 00
  Vendor: Generic- Model: Compact Flash    Rev: 1.00
  Type:   Direct-Access                    ANSI  SCSI revision: 00

Host: scsi8 Channel: 00 Id: 00 Lun: 01
  Vendor: Generic- Model: SM/xD-Picture    Rev: 1.00
  Type:   Direct-Access                    ANSI  SCSI revision: 00
Host: scsi8 Channel: 00 Id: 00 Lun: 02
  Vendor: Generic- Model: SD/MMC           Rev: 1.00

  Type:   Direct-Access                    ANSI  SCSI revision: 00
Host: scsi8 Channel: 00 Id: 00 Lun: 03
  Vendor: Generic- Model: MS/MS-Pro        Rev: 1.00
  Type:   Direct-Access                    ANSI  SCSI revision: 00

Host: scsi9 Channel: 00 Id: 00 Lun: 00
  Vendor: WD       Model: My Book 1140     Rev: 1019
  Type:   Direct-Access                    ANSI  SCSI revision: 06
Host: scsi9 Channel: 00 Id: 00 Lun: 01
  Vendor: WD       Model: SES Device       Rev: 1019

  Type:   Enclosure                        ANSI  SCSI revision: 06
root@MainDesktop1:/usr/src/linux-3.13.1#


[7.7.] Other information that might be relevant to the problem
       (please look in /proc and include all information that you
       think to be relevant):

Not sure what else needs to be included, please let me know if there's
any additional information required from /proc.


[X.] Other notes, patches, fixes, workarounds:

At this time, I'm not aware of any workarounds.  I believe at one
point I tried to disable C1E support in my BIOS and this resulted in
more lockups from what I recall.  If you could please look into this
issue, it would be greatly appreciated, as I use this as my primary
system and having frequent lock-ups is definitely causing some major
issues for me.  If you can point me in the right direction, I'd be
more than happy to assist in debugging or helping to investigate this
issue.  I've done some C coding years ago, but never on the Linux
kernel.  I've never done much debugging with GDB either, but with some
guidance, I'd have no issues with attempting to.

As I can't tell exactly where this bug is (whether it's a CPU idle/PM
bug or an e1000e bug.. or possibly elsewhere), I'm sending this to
both lists in hopes that I'll find the correct maintainer.  Thank you
in advance for you help.



Regards,
Darrin Burger
