Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933243AbaEGOBB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 10:01:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21794 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932243AbaEGOBA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 10:01:00 -0400
Date: Wed, 7 May 2014 16:00:06 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Sasha Levin <sasha.levin@oracle.com>, Steven Rostedt <rostedt@goodmis.org>
Cc: roland@redhat.com, LKML <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>
Subject: Re: ptrace: gpf in syscall_trace_enter
Message-ID: <20140507140006.GA17419@redhat.com>
References: <53698021.5020108@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53698021.5020108@oracle.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 05/06, Sasha Levin wrote:
>
> Hi all,
>
> While fuzzing with trinity inside a KVM tools guest running the latest -next
> kernel I've stumbled on the following spew:

This is not ptrace ;)

At first glance, tracepoint->funcs corruption. Add Steven.

> [ 3029.100936] general protection fault: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
> [ 3029.102198] Dumping ftrace buffer:
> [ 3029.102928]    (ftrace buffer empty)
> [ 3029.103644] Modules linked in:
> [ 3029.104732] CPU: 16 PID: 4959 Comm: sleep Tainted: G    B         3.15.0-rc4-next-20140506-sasha-00021-gc164334-dirty #447
> [ 3029.108662] task: ffff8805472f8000 ti: ffff880547e3e000 task.ti: ffff880547e3e000
> [ 3029.109900] RIP: syscall_trace_enter (include/trace/events/syscalls.h:16 arch/x86/kernel/ptrace.c:1488)
> [ 3029.110064] RSP: 0018:ffff880547e3ff28  EFLAGS: 00010286
> [ 3029.110064] RAX: 0000000000000000 RBX: ffff880547e3ff58 RCX: 0000000000000001
> [ 3029.110064] RDX: 000000000000000c RSI: ffff880547e3ff58 RDI: 6b6b6b6b6b6b6b6b
> [ 3029.110064] RBP: ffff880547e3ff48 R08: 0000000000000000 R09: 0000000000000001
> [ 3029.110064] R10: 0000000000000000 R11: 0000000000000000 R12: 000000000000000c
> [ 3029.110064] R13: 0000000000000000 R14: ffff880039583d50 R15: 0000000000001000
> [ 3029.110064] FS:  0000000000000000(0000) GS:ffff8803d6e00000(0000) knlGS:0000000000000000
> [ 3029.110064] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [ 3029.110064] CR2: 00007fe08b205130 CR3: 000000061d271000 CR4: 00000000000006a0
> [ 3029.110064] DR0: 00000000006df000 DR1: 0000000000000000 DR2: 0000000000000000
> [ 3029.110064] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000600
> [ 3029.110064] Stack:
> [ 3029.110064]  0000000000400040 0000000000000009 00007fffe95ab4b9 0000000000000000
> [ 3029.110064]  00007fe08afe64e0 ffffffffaa585625 0000000000001000 0000000000000000
> [ 3029.110064]  00007fffe95ab4b9 0000000000000009 00007fe08afe64e0 0000000000400040
> [ 3029.110064] Call Trace:
> [ 3029.110064] tracesys (arch/x86/kernel/entry_64.S:736)
> [ 3029.110064] Code: c6 05 e0 9f f0 05 01 e8 3d 30 14 00 4d 85 f6 75 10 65 ff 0c 25 a0 da 00 00 0f 84 ca 00 00 00 eb 19 49 8b 7e 08 4c 89 e2 48 89 de <41> ff 16 49 83 c6 10 49 83 3e 00 75 e9 eb d7 4c 8b 63 78 0f 1f
> [ 3029.110064] RIP syscall_trace_enter (include/trace/events/syscalls.h:16 arch/x86/kernel/ptrace.c:1488)
> [ 3029.110064]  RSP <ffff880547e3ff28>
> 
> 
> Thanks,
> Sasha

