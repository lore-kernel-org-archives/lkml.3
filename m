Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751610AbaCHG4Q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2014 01:56:16 -0500
Received: from mga01.intel.com ([192.55.52.88]:18112 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750925AbaCHG4P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2014 01:56:15 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,613,1389772800"; 
   d="scan'208";a="488365472"
Date: Sat, 8 Mar 2014 14:56:12 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>
Cc: Jiri Olsa <jolsa@redhat.com>, Stephane Eranian <eranian@google.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: [perf_swevent_init] BUG: unable to handle kernel paging request at
 b1793514
Message-ID: <20140308065612.GA6913@localhost>
References: <20140308065153.GA30311@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140308065153.GA30311@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Perhaps a related BUG. Here are 3 different back traces:

[   15.385846] sock: process `trinity-main' is using obsolete setsockopt SO_BSDCOMPAT
[   16.681572] BUG: unable to handle kernel paging request at b1793514
[   16.681595] IP: [<c1098ff8>] atomic_inc+0x3/0x8
[   16.681600] *pdpt = 000000000b203001 *pde = 0000000000000000 
[   16.681603] Oops: 0002 [#1] PREEMPT SMP DEBUG_PAGEALLOC
[   16.681615] Modules linked in:
[   16.681618] Pid: 506, comm: trinity-main Not tainted 3.7.0-03034-ge7b55b8 #29 Bochs Bochs
[   16.681619] EIP: 0060:[<c1098ff8>] EFLAGS: 00010246 CPU: 0
[   16.681621] EIP is at atomic_inc+0x3/0x8
[   16.681622] EAX: b1793514 EBX: ca412bf0 ECX: 00000007 EDX: cc23aa74
[   16.681623] ESI: 00000008 EDI: fbebebeb EBP: cb18feb8 ESP: cb18feb8
[   16.681626]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
[   16.681627] CR0: 8005003b CR2: b1793514 CR3: 0b9b8000 CR4: 000006b0
[   16.681632] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[   16.681635] DR6: ffff0ff0 DR7: 00000400
[   16.681636] Process trinity-main (pid: 506, ti=cb18e000 task=cc23a700 task.ti=cb18e000)
[   16.681636] Stack:
[   16.681640]  cb18fed0 c109ad3c 00000000 c1698a34 ca412bf0 00000000 cb18fee8 c109f004
[   16.681643]  c1698a34 00000000 ca412d38 ca412bf0 cb18ff04 c109f296 cb18ff40 ca412bf0
[   16.681646]  00000000 cc23a700 00000000 cb18ffac c109f98d ca412bf0 00000000 00000000
[   16.681646] Call Trace:
[   16.681650]  [<c109ad3c>] perf_swevent_init+0xd2/0xf2
[   16.681652]  [<c109f004>] perf_init_event+0x66/0xa4
[   16.681654]  [<c109f296>] perf_event_alloc+0x254/0x364
[   16.681656]  [<c109f98d>] sys_perf_event_open+0x327/0x640
[   16.681664]  [<c100a138>] ? perf_trace_sys_exit+0x60/0x6b
[   16.681680]  [<c14159b0>] syscall_call+0x7/0xb
[   16.681683]  [<c1410000>] ? create_elf_tables+0x9/0x44f
[   16.681704] Code: 5d e8 d0 24 16 00 c3 55 89 e5 9c 58 8d 74 26 00 5d c3 55 89 e5 50 9d 8d 74 26 00 5d c3 55 89 e5 fa 90 8d 74 26 00 5d c3 55 89 e5 <f0> ff 00 5d c3 55 89 e5 f0 ff 08 5d c3 55 89 e5 f0 ff 08 0f 94
[   16.681706] EIP: [<c1098ff8>] atomic_inc+0x3/0x8 SS:ESP 0068:cb18feb8
[   16.681707] CR2: 00000000b1793514
[   16.681709] ---[ end trace 694659a17400008f ]---
[   16.682806] caif:caif_disconnect_client(): nothing to disconnect


[   17.480694] process `trinity-main' is using obsolete setsockopt SO_BSDCOMPAT
[   18.299413] irda_setsockopt: not allowed to set MAXSDUSIZE for this socket type!
[   19.274966] irda_setsockopt: not allowed to set MAXSDUSIZE for this socket type!
[   19.750238] BUG: unable to handle kernel paging request at bfd38fa4             
[   19.751083] IP: [<c10bee27>] perf_swevent_init+0x124/0x151         
[   19.751083] *pdpt = 0000000008b4e001 *pde = 0000000000000000
[   19.751083] Oops: 0002 [#1] PREEMPT
[   19.751083] Modules linked in:
[   19.751083]
[   19.751083] Pid: 101, comm: trinity-main Not tainted 3.3.0 #142
[   19.751083] EIP: 0060:[<c10bee27>] EFLAGS: 00010246 CPU: 0     
[   19.751083] EIP is at perf_swevent_init+0x124/0x151       
[   19.751083] EAX: 00000000 EBX: 00000000 ECX: 00000007 EDX: 00000003
[   19.751083] ESI: cf47c240 EDI: ff732ecd EBP: c8b73ee4 ESP: c8b73ed8
[   19.751083]  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
[   19.751083] Process trinity-main (pid: 101, ti=c8b72000 task=cfd742b0 task.ti=c8b72000)
[   19.751083] Stack:
[   19.751083]  c19b2cf8 cf47c240 00000000 c8b73efc c10c6041 c19b2cf8 00000000 cf47c358
[   19.751083]  cf47c240 c8b73f18 c10c63a9 c8b73f58 cf47c240 cfd742b0 00000000 00000000
[   19.751083]  c8b73fac c10c70c0 cf47c240 00000000 00000000 00000000 cfd742b0 08e243bc
[   19.751083] Call Trace:
[   19.751083]  [<c10c6041>] perf_init_event+0xda/0x13d
[   19.751083]  [<c10c63a9>] perf_event_alloc+0x305/0x4e7
[   19.751083]  [<c10c70c0>] sys_perf_event_open+0x5a9/0xd63
[   19.751083]  [<c166ee9c>] sysenter_do_call+0x12/0x3c
[   19.751083] Code: 04 07 c2 01 83 15 6c 04 07 c2 00 83 05 c0 04 07 c2 01 83 15 c4 04 07 c2 00 85 db 75 34 83 05 c8 04 07 c2 01 83 15 cc 04 07 c2 00
<ff> 04 bd 70 d4 06 c2 83 05 d0 04 07 c2 01 83 15 d4 04 07 c2 00
[   19.751083] EIP: [<c10bee27>] perf_swevent_init+0x124/0x151 SS:ESP 0068:c8b73ed8
[   19.751083] CR2: 00000000bfd38fa4
[   19.801253] ---[ end trace 98a8ec73f746b7e9 ]---
[   19.849253] trinity-main used greatest stack depth: 6432 bytes left


[    2.440073] tsc: Refined TSC clocksource calibration: 2299.965 MHz
Kernel tests: Boot OK!
[   13.112920] BUG: unable to handle kernel paging request at fffffffe199c9770
[   13.114701] IP: [<ffffffff811431f3>] perf_swevent_init+0xeb/0x118
[   13.116012] PGD 1e0d067 PUD 0 
[   13.116012] Oops: 0002 [#1] SMP 
[   13.116012] Modules linked in:
[   13.116012] CPU 1 
[   13.116012] Pid: 7192, comm: trinity-main Not tainted 3.6.0-06761-g67966e0 #1 Bochs Bochs
[   13.116012] RIP: 0010:[<ffffffff811431f3>]  [<ffffffff811431f3>] perf_swevent_init+0xeb/0x118
[   13.116012] RSP: 0018:ffff88000f697e08  EFLAGS: 00010202
[   13.116012] RAX: ffff88000fadc260 RBX: ffff88000f63e400 RCX: ffff88000f697fd8
[   13.116012] RDX: 0000000000000000 RSI: 0000000000000055 RDI: ffffffff81e27958
[   13.116012] RBP: ffff88000f697e28 R08: ffffffff81f00260 R09: 0000000000000000
[   13.116012] R10: 00000001003024f9 R11: 0000040000000000 R12: ffffffffa5e183bc
[   13.116012] R13: 0000000000000200 R14: 0000000000000000 R15: ffff88000f63e400
[   13.116012] FS:  00007f05fb80e700(0000) GS:ffff88000e700000(0000) knlGS:0000000000000000
[   13.116012] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   13.116012] CR2: fffffffe199c9770 CR3: 000000000f619000 CR4: 00000000000006e0
[   13.116012] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   13.116012] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   13.116012] Process trinity-main (pid: 7192, threadinfo ffff88000f696000, task ffff88000fadc260)
[   13.116012] Stack:
[   13.116012]  ffffffff81e43430 ffff88000f63e400 0000000000000000 ffffffff81e326a0
[   13.116012]  ffff88000f697e58 ffffffff81147bd3 ffffffff81e43430 ffff88000f697ef0
[   13.116012]  0000000000000000 ffff88000fadc260 ffff88000f697ea0 ffffffff81147e8a
[   13.116012] Call Trace:
[   13.116012]  [<ffffffff81147bd3>] perf_init_event+0x91/0xc5
[   13.116012]  [<ffffffff81147e8a>] perf_event_alloc+0x283/0x391
[   13.116012]  [<ffffffff811486fa>] sys_perf_event_open+0x429/0x8d9
[   13.116012]  [<ffffffff81870a09>] tracesys+0xd0/0xd5
[   13.116012] Code: 3d c3 e2 8d 00 ff c3 be 00 02 00 00 48 63 d3 e8 fb 16 2c 00 3b 05 7e d1 db 00 89 c3 7c d4 e8 8d 63 f7 ff 44 89 f0 eb 27 4d 63 e4 <f0> 42 ff 04 a5 80 88 16 82 31 c0 48 c7 83 c0 02 00 00 63 30 14 
[   13.116012] RIP  [<ffffffff811431f3>] perf_swevent_init+0xeb/0x118
[   13.116012]  RSP <ffff88000f697e08>
[   13.116012] CR2: fffffffe199c9770
[   13.116012] ---[ end trace e89f72494f9b9777 ]---
[   13.116012] BUG: sleeping function called from invalid context at kernel/rwsem.c:20

Thanks,
Fengguang
