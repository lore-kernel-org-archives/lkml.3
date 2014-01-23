Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753191AbaAWLJS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 06:09:18 -0500
Received: from canopus.corp.1gb.ru ([81.177.167.38]:61131 "EHLO
	canopus.corp.1gb.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752406AbaAWLJQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 06:09:16 -0500
X-Greylist: delayed 327 seconds by postgrey-1.27 at vger.kernel.org; Thu, 23 Jan 2014 06:09:15 EST
Date: Thu, 23 Jan 2014 15:03:47 +0400
From: Alexey Vlasov <renton@renton.name>
To: linux-kernel@vger.kernel.org
Subject: Unstable kernels work after 2.6.3x
Message-ID: <20140123110346.GC2338@canopus.corp.1gb.ru>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="OgqxwSJOaUobr8KG"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--OgqxwSJOaUobr8KG
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hello,

I've already written that after release of version 2.6.32 something
strange happened either in the kernel or with its base features, namely
since then there was not released even a single kernel, which would at
least on my hosting work consistently and without bugs.

That's the history of kernel crashes on one of my servers:
1.1 2013-02-14 22:47:01 - 3.7.3
1.2 2013-03-07 00:48:25 - 3.7.3
1.3 2013-03-07 13:59:45 - 3.7.3
1.4 2013-03-10 01:20 - 3.7.3
1.5 2013-03-14 00:47 - 3.8.2
1.6 2013-03-15 00:57 - 3.8.2
1.10 2013-03-17 04:00 - 3.8.2
1.14 2013-03-24 22:42 - 3.8.2
1.15 2013-03-25 01:30 - 3.8.2
1.16 2013-03-25 02:57 - 3.7.3
1.17 2013-04-02 06:09 - 3.8.4
1.18 2013-04-12 21:50 - 3.8.4
1.22 2013-06-02 20:12 - 3.8.4
1.23 2013-06-09 16:33 - 3.8.4
1.24 2013-07-28 02:00 - 3.9.4
1.25 2013-08-17 16:45 - 3.9.4
1.26 2013-09-03 21:07 - 3.10.10
1.27 2013-09-07 21:07 - 3.11.0
1.28 2013-09-15 06:18 - 3.11.0
1.29 2013-10-01 21:51 - 3.11.0
1.31 2013-10-11 22:02 - 3.11.4
1.34 2013-10-26 06:32 - 3.11.4
1.36 2013-11-05 06:26 - 3.11.4
1.37 2013-11-17 15:06 - 3.11.4
1.38 2013-12-07 08:29 - 3.9.11
(date - kernel version)

And this is a server with an old one:
# uname -a
Linux l7 2.6.25-r9-1gb-s #3 SMP Fri Nov 14 18:15:42 MSK 2008 x86_64
Intel(R) Xeon(R) CPU E5430 @ 2.66GHz GenuineIntel GNU/Linux
# uptime
 13:29:40 up 731 days, 14:26,  5 users,  load average: 27.56, 18.75, 18.86

Another:
# uname -a
Linux l5 2.6.25-r7-1gb #4 SMP Fri Aug 29 18:43:15 MSD 2008 x86_64
Intel(R) Xeon(R) CPU E5345 @ 2.33GHz GenuineIntel GNU/Linux
# uptime
 13:31:48 up 733 days, 16:18,  5 users,  load average: 13.12, 10.79, 10.67

And it's not just some trash standing in the closet, it's a highloaded
server with several thousand websites and that also perform function of
a gateway for VPS customers.

I certainly can, in some way, understand all these hangings and
failures, but it is difficult and sometimes impossible to explain them
to our clients when they see their non-performing web-sites.

Here's one of the latest of bugs:
(3.12.3_kpanic.txt in attach)

I'm completely satisfied with this kernel specifically, if I could
somehow manage to fix this particular bug, it would be great. I don't
want to try again to move to another new kernel, I've already had such an
experience. If it is possible, can you just release a patch for
particularly this kernel?

Thank you in advance.

-- 
BRGDS. Alexey Vlasov.

--OgqxwSJOaUobr8KG
Content-Type: text/plain; charset=utf-8
Content-Disposition: attachment; filename="3.12.3_kpanic.txt"

Jan 18 02:37:50 l24 [3461838.276970] BUG: unable to handle kernel paging request at 00000000ee55d9c8
Jan 18 02:37:50 l24 [3461838.319959] IP: [<ffffffff810f0a30>] kmem_cache_alloc+0x50/0xc0
Jan 18 02:37:50 l24 [3461838.356616] PGD 6ce07b067 PUD 0
Jan 18 02:37:50 l24 [3461838.377203] Oops: 0000 [#1] SMP 
Jan 18 02:37:50 l24 [3461838.397794] Modules linked in: flashcache(O) netconsole
Jan 18 02:37:50 l24 [3461838.430454] CPU: 15 PID: 7797 Comm: v3w_http_loadti Tainted: G          IO 3.12.3-1gb-cm #1
Jan 18 02:37:50 l24 [3461838.481706] Hardware name: Intel Corporation S5520UR/S5520UR, BIOS S5500.86B.01.00.0061.030920121535 03/09/2012
Jan 18 02:37:50 l24 [3461838.543378] task: ffff881a0f11e0f0 ti: ffff880189240000 task.ti: ffff880189240000
Jan 18 02:37:50 l24 [3461838.813383] RIP: 0010:[<ffffffff810f0a30>] [<ffffffff810f0a30>] kmem_cache_alloc+0x50/0xc0
Jan 18 02:37:50 l24 [3461838.864721] RSP: 0018:ffff880189241dc0  EFLAGS: 00010282
Jan 18 02:37:50 l24 [3461838.897674] RAX: 0000000000000000 RBX: ffff8810a842ac10 RCX: 00000000000001b6
Jan 18 02:37:50 l24 [3461838.941635] RDX: 00000000bb320459 RSI: 00000000000000d0 RDI: 0000000000014340
Jan 18 02:37:50 l24 [3461838.985599] RBP: ffff880189241de0 R08: ffff881c6fcf4340 R09: ffffffff81062f68
Jan 18 02:37:51 l24 [3461839.029557] R10: 0000000000000000 R11: 0000000000000000 R12: ffff88102f803800
Jan 18 02:37:51 l24 [3461839.073525] R13: 00000000ee55d9c8 R14: 00000000000000d0 R15: 00007fbce95779d0
Jan 18 02:37:51 l24 [3461839.117497] FS:  00007fbce9577700(0000) GS:ffff881c6fce0000(0000) knlGS:0000000000000000
Jan 18 02:37:51 l24 [3461839.168441] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
Jan 18 02:37:51 l24 [3461839.204006] CR2: 00000000ee55d9c8 CR3: 0000000a3900f000 CR4: 00000000000007e0
Jan 18 02:37:51 l24 [3461839.360725] Stack:
Jan 18 02:37:51 l24 [3461839.373892]  ffff8810a842ac10 0000000000000000 ffff8810a842ac10 0000000000000000
Jan 18 02:37:51 l24 [3461839.419631]  ffff880189241e00 ffffffff81062f68 ffff8810a842ac10 0000000000000000
Jan 18 02:37:51 l24 [3461839.465448]  ffff880189241e30 ffffffff81063531 ffff880189241e30 0000000001200011
Jan 18 02:37:51 l24 [3461839.511230] Call Trace:
Jan 18 02:37:51 l24 [3461839.527013]  [<ffffffff81062f68>] prepare_creds+0x18/0xc0
Jan 18 02:37:51 l24 [3461839.560494]  [<ffffffff81063531>] copy_creds+0x61/0x130
Jan 18 02:37:51 l24 [3461839.592935]  [<ffffffff8103f6b4>] copy_process+0x384/0x1430
Jan 18 02:37:51 l24 [3461839.627455]  [<ffffffff810669d5>] ? check_preempt_curr+0x75/0xa0
Jan 18 02:37:51 l24 [3461839.664581]  [<ffffffff8106910f>] ? wake_up_new_task+0xff/0x140
Jan 18 02:37:51 l24 [3461839.701183]  [<ffffffff81040888>] do_fork+0x68/0x210
Jan 18 02:37:51 l24 [3461839.732053]  [<ffffffff81119aab>] ? get_unused_fd_flags+0x2b/0x30
Jan 18 02:37:51 l24 [3461839.769696]  [<ffffffff8104edfb>] ? __set_current_blocked+0x3b/0x60
Jan 18 02:37:51 l24 [3461839.808376]  [<ffffffff81040ab1>] SyS_clone+0x11/0x20
Jan 18 02:37:51 l24 [3461839.839779]  [<ffffffff814f1749>] stub_clone+0x69/0x90
Jan 18 02:37:51 l24 [3461839.871708]  [<ffffffff814f14a2>] ? system_call_fastpath+0x16/0x1b
Jan 18 02:37:51 l24 [3461839.909867] Code: 4d 8b 04 24 65 4c 03 04 25 08 cc 00 00 49 8b 50 08 4d 8b 28 49 8b 40 10 4d 85 ed 74 68 48 85 c0 74 63 49 63 44 24 20 49 8b 3c 24 8b 5c 05 00 48 8d 4a 01 4c 89 e8 65 48 0f c7 0f 0f 94 c0 84
Jan 18 02:37:52 l24 [3461840.248720] RIP [<ffffffff810f0a30>] kmem_cache_alloc+0x50/0xc0
Jan 18 02:37:52 l24 [3461840.506744]  RSP <ffff880189241dc0>
Jan 18 02:37:52 l24 [3461840.528770] CR2: 00000000ee55d9c8
Jan 18 02:37:52 l24 [3461840.550229] ---[ end trace f544a39473ca64c0 ]---
Jan 18 02:37:52 l24 [3461840.700932] BUG: unable to handle kernel paging request at 00000000ee55d9c8
Jan 18 02:37:52 l24 [3461840.744082] IP: [<ffffffff810f0a30>] kmem_cache_alloc+0x50/0xc0
Jan 18 02:37:52 l24 [3461840.780862] PGD 1960d43067 PUD 0 
Jan 18 02:37:52 l24 [3461840.802137] Oops: 0000 [#2] SMP
Jan 18 02:37:52 l24 [3461840.822898] Modules linked in: flashcache(O) netconsole
Jan 18 02:37:52 l24 [3461840.855769] CPU: 15 PID: 9159 Comm: v3w_http_loadti Tainted: G      D   IO 3.12.3-1gb-cm #1
Jan 18 02:37:52 l24 [3461840.907074] Hardware name: Intel Corporation S5520UR/S5520UR, BIOS S5500.86B.01.00.0061.030920121535 03/09/2012
Jan 18 02:37:53 l24 [3461841.192871] task: ffff8816ee9ee9c0 ti: ffff88150ef7e000 task.ti: ffff88150ef7e000
Jan 18 02:37:53 l24 [3461841.238976] RIP: 0010:[<ffffffff810f0a30>] [<ffffffff810f0a30>] kmem_cache_alloc+0x50/0xc0
Jan 18 02:37:53 l24 [3461841.290414] RSP: 0018:ffff88150ef7fea8  EFLAGS: 00010282
Jan 18 02:37:53 l24 [3461841.323427] RAX: 0000000000000000 RBX: 0000000000000001 RCX: 00007fffa30f6db0
Jan 18 02:37:53 l24 [3461841.367442] RDX: 00000000bb320459 RSI: 00000000000000d0 RDI: 0000000000014340
Jan 18 02:37:53 l24 [3461841.411456] RBP: ffff88150ef7fec8 R08: ffff881c6fcf4340 R09: ffffffff81062f68
Jan 18 02:37:53 l24 [3461841.455479] R10: 00007fffa30f6db0 R11: 0000000000000246 R12: ffff88102f803800
Jan 18 02:37:53 l24 [3461841.499500] R13: 00000000ee55d9c8 R14: 00000000000000d0 R15: 00007fffa30f719c
Jan 18 02:37:53 l24 [3461841.543518] FS:  00007fbce9577700(0000) GS:ffff881c6fce0000(0000) knlGS:0000000000000000
Jan 18 02:37:53 l24 [3461841.593266] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Jan 18 02:37:53 l24 [3461841.628833] CR2: 00000000ee55d9c8 CR3: 0000001495d54000 CR4: 00000000000007e0
Jan 18 02:37:53 l24 [3461841.672849] Stack:
Jan 18 02:37:53 l24 [3461841.686081]  0000000000000001 00000000ffffff9c 000000000237b5e0 00007fffa30f7100
Jan 18 02:37:53 l24 [3461841.732163]  ffff88150ef7fee8 ffffffff81062f68 0000000000000001 00000000ffffff9c
Jan 18 02:37:53 l24 [3461841.778255]  ffff88150ef7ff68 ffffffff810fc425 0000000020000dca ffff81ed0fd00002
Jan 18 02:37:53 l24 [3461841.936122] Call Trace:
Jan 18 02:37:53 l24 [3461841.951968]  [<ffffffff81062f68>] prepare_creds+0x18/0xc0
Jan 18 02:37:53 l24 [3461841.985518]  [<ffffffff810fc425>] SyS_faccessat+0x55/0x240
Jan 18 02:37:53 l24 [3461842.019583]  [<ffffffff810fc623>] SyS_access+0x13/0x20
Jan 18 02:37:54 l24 [3461842.051554]  [<ffffffff814f14a2>] system_call_fastpath+0x16/0x1b
Jan 18 02:37:54 l24 [3461842.088730] Code: 4d 8b 04 24 65 4c 03 04 25 08 cc 00 00 49 8b 50 08 4d 8b 28 49 8b 40 10 4d 85 ed 74 68 48 85 c0 74 63 49 63 44 24 20 49 8b 3c 8b 5c 05 00 48 8d 4a 01 4c 89 e8 65 48 0f c7 0f 0f 94 c0 84
Jan 18 02:37:54 l24 [3461842.211111] RIP [<ffffffff810f0a30>] kmem_cache_alloc+0x50/0xc0
Jan 18 02:37:54 l24 [3461842.248420]  RSP <ffff88150ef7fea8>
Jan 18 02:37:54 l24 [3461842.270496] CR2: 00000000ee55d9c8
Jan 18 02:37:54 l24 [3461842.291558] ---[ end trace f544a39473ca64c1 ]---
Jan 18 02:37:54 l24 [3461842.350827] BUG: unable to handle kernel paging request at 00000000ee55d9c8
Jan 18 02:37:54 l24 [3461842.393956] IP: [<ffffffff810f0a30>] kmem_cache_alloc+0x50/0xc0
Jan 18 02:37:54 l24 [3461842.430766] PGD 14457fd067 PUD 0 
Jan 18 02:37:54 l24 [3461842.452065] Oops: 0000 [#3] SMP 
Jan 18 02:37:54 l24 [3461842.472836] Modules linked in: flashcache(O) netconsole
Jan 18 02:37:54 l24 [3461842.505692] CPU: 15 PID: 9889 Comm: bash Tainted: G      D   IO 3.12.3-1gb-cm #1
Jan 18 02:37:54 l24 [3461842.551274] Hardware name: Intel Corporation S5520UR/S5520UR, BIOS S5500.86B.01.00.0061.030920121535 03/09/2012
Jan 18 02:37:54 l24 [3461842.613001] task: ffff881b5d6da340 ti: ffff8815e7caa000 task.ti: ffff8815e7caa000
Jan 18 02:37:54 l24 [3461842.659116] RIP: 0010:[<ffffffff810f0a30>] [<ffffffff810f0a30>] kmem_cache_alloc+0x50/0xc0
Jan 18 02:37:54 l24 [3461842.710569] RSP: 0018:ffff8815e7cabdc0  EFLAGS: 00010282
Jan 18 02:37:54 l24 [3461842.743586] RAX: 0000000000000000 RBX: ffff8810a842b4e0 RCX: 00000000000001a7
Jan 18 02:37:54 l24 [3461842.787608] RDX: 00000000bb320463 RSI: 00000000000000d0 RDI: 0000000000014340
Jan 18 02:37:54 l24 [3461842.831629] RBP: ffff8815e7cabde0 R08: ffff881c6fcf4340 R09: ffffffff81062f68
Jan 18 02:37:54 l24 [3461842.875646] R10: 0000000000000000 R11: 0000000000000000 R12: ffff88102f803800
Jan 18 02:37:54 l24 [3461842.919665] R13: 00000000ee55d9c8 R14: 00000000000000d0 R15: 00007f030ac079d0
Jan 18 02:37:54 l24 [3461842.963687] FS:  00007f030ac07700(0000) GS:ffff881c6fce0000(0000) knlGS:0000000000000000
Jan 18 02:37:54 l24 [3461843.013432] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
Jan 18 02:37:55 l24 [3461843.049043] CR2: 00000000ee55d9c8 CR3: 000000188de6b000 CR4: 00000000000007e0
Jan 18 02:37:55 l24 [3461843.093060] Stack:
Jan 18 02:37:55 l24 [3461843.106287]  ffff8810a842b4e0 0000000000000000 ffff8810a842b4e0 0000000000000000
Jan 18 02:37:55 l24 [3461843.152361]  ffff8815e7cabe00 ffffffff81062f68 ffff8810a842b4e0 0000000000000000
Jan 18 02:37:55 l24 [3461843.198432]  ffff8815e7cabe30 ffffffff81063531 ffff8815e7cabe30 0000000001200011
Jan 18 02:37:55 l24 [3461843.244458] Call Trace:
Jan 18 02:37:55 l24 [3461843.260289]  [<ffffffff81062f68>] prepare_creds+0x18/0xc0
Jan 18 02:37:55 l24 [3461843.293826]  [<ffffffff81063531>] copy_creds+0x61/0x130
Jan 18 02:37:55 l24 [3461843.773443]  [<ffffffff8103f6b4>] copy_process+0x384/0x1430
Jan 18 02:37:55 l24 [3461843.808026]  [<ffffffff81040888>] do_fork+0x68/0x210
Jan 18 02:37:55 l24 [3461843.838969]  [<ffffffff8104edfb>] ? __set_current_blocked+0x3b/0x60
Jan 18 02:37:55 l24 [3461843.877714]  [<ffffffff81040ab1>] SyS_clone+0x11/0x20
Jan 18 02:37:55 l24 [3461843.909169]  [<ffffffff814f1749>] stub_clone+0x69/0x90
Jan 18 02:37:55 l24 [3461843.941145]  [<ffffffff814f14a2>] ? system_call_fastpath+0x16/0x1b
Jan 18 02:37:55 l24 [3461843.979365] Code: 4d 8b 04 24 65 4c 03 04 25 08 cc 00 00 49 8b 50 08 4d 8b 28 49 8b 40 10 4d 85 ed 74 68 48 85 c0 74 63 49 63 44 24 20 49 8b 3c 8b 5c 05 00 48 8d 4a 01 4c 89 e8 65 48 0f c7 0f 0f 94 c0 84
Jan 18 02:37:56 l24 [3461844.101821] RIP [<ffffffff810f0a30>] kmem_cache_alloc+0x50/0xc0
Jan 18 02:37:56 l24 [3461844.139135] RSP <ffff8815e7cabdc0>
Jan 18 02:37:56 l24 [3461844.161205] CR2: 00000000ee55d9c8


--OgqxwSJOaUobr8KG--
