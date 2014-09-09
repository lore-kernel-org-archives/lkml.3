Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751156AbaIIRsD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 13:48:03 -0400
Received: from mail-qc0-f180.google.com ([209.85.216.180]:50969 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750882AbaIIRsB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 13:48:01 -0400
From: Vince Weaver <vincent.weaver@maine.edu>
X-Google-Original-From: Vince Weaver <vince@vincent-weaver-1.umelst.maine.edu>
Date: Tue, 9 Sep 2014 13:53:50 -0400 (EDT)
To: Vince Weaver <vincent.weaver@maine.edu>
cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: perf: perf_fuzzer triggers instant reboot
In-Reply-To: <alpine.DEB.2.11.1409091317550.15651@vincent-weaver-1.umelst.maine.edu>
Message-ID: <alpine.DEB.2.11.1409091352260.15874@vincent-weaver-1.umelst.maine.edu>
References: <alpine.DEB.2.11.1409081343270.29974@vincent-weaver-1.umelst.maine.edu> <20140908185115.GI6758@twins.programming.kicks-ass.net> <alpine.DEB.2.11.1409091203500.14857@vincent-weaver-1.umelst.maine.edu>
 <alpine.DEB.2.11.1409091317550.15651@vincent-weaver-1.umelst.maine.edu>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


OK so trying to use ftrace to track this issue, and this happens (on 
core2, 3.17-rc4)

[  295.992012] PANIC: double fault, error_code: 0x0
[  295.992012] CPU: 1 PID: 2916 Comm: trace-cmd Not tainted 3.17.0-rc4+ #82
[  295.992012] Hardware name: AOpen   DE7000/nMCP7ALPx-DE R1.06 Oct.19.2012, BIOS 080015  10/19/2012
[  295.992012] task: ffff8800cb20a800 ti: ffff8800ca30c000 task.ti: ffff8800ca30c000
[  295.992012] RIP: 0010:[<ffffffff81037b92>]  [<ffffffff81037b92>] perf_trace_x86_exceptions+0x2d/0xb7
[  295.992012] RSP: 0018:ffff8800bfffff58  EFLAGS: 00010082
[  295.992012] RAX: 0000000000000001 RBX: ffff880037c9f490 RCX: 0000000000000000
[  295.992012] RDX: ffff8800c0000098 RSI: ffffe8ffffc81010 RDI: ffffffff81a26600
[  295.992012] RBP: ffff8800c0000058 R08: 0000000000044ea5 R09: ffffe8ffffc81010
[  295.992012] R10: 0000000000000000 R11: ffff8800ca30fc48 R12: ffff8800c0000098
[  295.992012] R13: ffffe8ffffc81010 R14: 0000000000000000 R15: ffffffff81a26600
[  295.992012] FS:  00007f4217f82700(0000) GS:ffff88011fc80000(0000) knlGS:0000000000000000
[  295.992012] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  295.992012] CR2: ffff8800bfffff48 CR3: 00000000ca0b9000 CR4: 00000000000407e0
[  295.992012] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  295.992012] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000600
[  295.992012] Stack:
[  295.992012] PANIC: double fault, error_code: 0x0

and the system reboots.

Vince
