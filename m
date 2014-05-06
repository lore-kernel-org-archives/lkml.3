Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757925AbaEFPjW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 11:39:22 -0400
Received: from mail-qa0-f45.google.com ([209.85.216.45]:39874 "EHLO
	mail-qa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755170AbaEFPjU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 11:39:20 -0400
X-Google-Original-From: Vince Weaver <vince@vincent-weaver-1.umelst.maine.edu>
Date: Tue, 6 May 2014 11:42:58 -0400 (EDT)
From: Vince Weaver <vincent.weaver@maine.edu>
To: linux-kernel@vger.kernel.org
cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Cyrill Gorcunov <gorcunov@openvz.org>
Subject: perf_fuzzer crash on pentium 4
Message-ID: <alpine.DEB.2.10.1405061137560.3220@vincent-weaver-1.umelst.maine.edu>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


So just to be difficult I fired up the perf_fuzzer on a Pentium 4 machine.

It crashes more or less instantly (sorry for the line wrapping, 
just got the serial console hooked up and don't have minicom configured 
right yet).

this is 3.15-rc4 with the anti-memory corruption patch applied.

[   67.872274] BUG: unable to handle kernel NULL pointer dereference at 00000004
[   67.876146] IP: [<ffffffff81013df2>] p4_pmu_schedule_events+0xa5/0x331
[   67.876146] PGD 3cea7067 PUD 3cea8067 PMD 0 
[   67.876146] Oops: 0000 [#1] SMP 
[   67.876146] Modules linked in: loop snd_hda_codec_analog snd_hda_codec_genern
[   67.876146] CPU: 0 PID: 2192 Comm: perf_fuzzer Tainted: G        W     3.15.1
[   67.876146] Hardware name: LENOVO 88088NU/LENOVO, BIOS 2JKT37AUS 07/12/2007
[   67.876146] task: ffff88003c0610d0 ti: ffff88003c062000 task.ti: ffff88003c00
[   67.876146] RIP: 0010:[<ffffffff81013df2>]  [<ffffffff81013df2>] p4_pmu_sche1
[   67.876146] RSP: 0000:ffff88003f403d60  EFLAGS: 00010046
[   67.876146] RAX: 0000000000000000 RBX: 0000000000000001 RCX: 00000000000003a2
[   67.876146] RDX: ffff88003c0610d0 RSI: 0000000000000003 RDI: 0000000000000000
[   67.876146] RBP: 0000000000000000 R08: 0000000000000003 R09: 0000000000000000
[   67.876146] R10: 00007f156ab399d0 R11: 0000000000000246 R12: 0000000000000000
[   67.876146] R13: 0000000000000002 R14: ffff88003f403de8 R15: ffff88003b766000
[   67.876146] FS:  00007f156ab39700(0000) GS:ffff88003f400000(0000) knlGS:00000
[   67.876146] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   67.876146] CR2: 0000000000000004 CR3: 000000003c598000 CR4: 00000000000007f0
[   67.876146] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   67.876146] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000600
[   67.876146] Stack:
[   67.876146]  0000000000000002 0000000000000000 ffff88003f40bb50 0000000100003
[   67.876146]  0000000000000003 3000020c0403c200 0000000000000001 0000000000004
[   67.876146]  0000000000000000 ffff88003f40bb50 ffff88003f403de8 0000000000003
[   67.876146] Call Trace:
[   67.876146]  <IRQ> 
[   67.876146]  [<ffffffff810104c7>] ? x86_pmu_commit_txn+0x45/0x8b
[   67.876146]  [<ffffffff8104d6c6>] ? search_exception_tables+0x1d/0x2d
[   67.876146]  [<ffffffff8102cc65>] ? fixup_exception+0x10/0x53
[   67.876146]  [<ffffffff813e65dd>] ? do_general_protection+0x30/0x12d
[   67.876146]  [<ffffffff813e6082>] ? general_protection+0x22/0x30
[   67.876146]  [<ffffffff810ba5ef>] ? event_sched_in+0x129/0x136
[   67.876146]  [<ffffffff810ba68a>] ? group_sched_in+0x8e/0x138
[   67.876146]  [<ffffffff810bb1af>] ? __perf_event_enable+0xea/0x128
[   67.876146]  [<ffffffff810b76c0>] ? remote_function+0x13/0x3b
[   67.876146]  [<ffffffff81084fb7>] ? generic_smp_call_function_single_interrua
[   67.876146]  [<ffffffff810227db>] ? smp_call_function_single_interrupt+0xf/0c
[   67.876146]  [<ffffffff813ebbba>] ? call_function_single_interrupt+0x6a/0x70
[   67.876146]  <EOI> 
[   67.876146] Code: 08 49 8b 97 28 01 00 00 48 89 d5 48 c1 ed 39 83 e5 3f 83 f 
[   67.876146] RIP  [<ffffffff81013df2>] p4_pmu_schedule_events+0xa5/0x331
[   67.876146]  RSP <ffff88003f403d60>
[   67.876146] CR2: 0000000000000004
[   67.876146] ---[ end trace a88368266e292dfa ]---
[   67.876146] Kernel panic - not syncing: Fatal exception in interrupt
[   67.876146] Kernel Offset: 0x0 from 0xffffffff81000000 (relocation range: 0x)
[   67.876146] drm_kms_helper: panic occurred, switching back to text console
[   67.876146] ---[ end Kernel panic - not syncing: Fatal exception in interrupt
