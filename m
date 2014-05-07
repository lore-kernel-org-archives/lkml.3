Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933081AbaEGOEo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 10:04:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27377 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932352AbaEGOEn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 10:04:43 -0400
Date: Wed, 7 May 2014 16:04:22 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Sasha Levin <sasha.levin@oracle.com>, Steven Rostedt <rostedt@goodmis.org>
Cc: roland@redhat.com, LKML <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>
Subject: Re: ptrace: gpf in syscall_trace_enter
Message-ID: <20140507140422.GB17419@redhat.com>
References: <53698021.5020108@oracle.com> <53699F7C.1040308@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53699F7C.1040308@oracle.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/06, Sasha Levin wrote:
>
> On 05/06/2014 08:36 PM, Sasha Levin wrote:
> > Hi all,
> >
> > While fuzzing with trinity inside a KVM tools guest running the latest -next
> > kernel I've stumbled on the following spew:
>
> And another similar trace:

Again, this looks like __DO_TRACE() trying to call it_func_ptr->func().

> [ 6897.628729] general protection fault: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
> [ 6897.629654] Dumping ftrace buffer:
> [ 6897.630034]    (ftrace buffer empty)
> [ 6897.630034] Modules linked in:
> [ 6897.630034] CPU: 24 PID: 23736 Comm: trinity-c148 Tainted: G    B         3.15.0-rc4-next-20140506-sasha-00021-gc164334-dirty #447
> [ 6897.630034] task: ffff88002a870000 ti: ffff88000ef04000 task.ti: ffff88000ef04000
> [ 6897.630034] RIP: syscall_trace_leave (include/trace/events/syscalls.h:42 arch/x86/kernel/ptrace.c:1517)
> [ 6897.630034] RSP: 0000:ffff88000ef05f20  EFLAGS: 00010286
> [ 6897.630034] RAX: 0000000000000000 RBX: ffff88000ef05f58 RCX: 0000000000000001
> [ 6897.630034] RDX: fffffffffffffff2 RSI: ffff88000ef05f58 RDI: 6b6b6b6b6b6b6b6b
> [ 6897.630034] RBP: ffff88000ef05f40 R08: ffff880218c3c498 R09: 0000000100290024
> [ 6897.630034] R10: 0000000000000000 R11: 0000000000000000 R12: ffff8806c5d04630
> [ 6897.630034] R13: fffffffffffffff2 R14: 00000000000032e0 R15: 00000000000000af
> [ 6897.630034] FS:  00007f5541eec700(0000) GS:ffff880587000000(0000) knlGS:0000000000000000
> [ 6897.630034] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [ 6897.630034] CR2: 00007fff1ac95d78 CR3: 00000000036a0000 CR4: 00000000000006a0
> [ 6897.630034] DR0: 00000000006df000 DR1: 0000000000000000 DR2: 0000000000000000
> [ 6897.630034] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 00000000000f0602
> [ 6897.630034] Stack:
> [ 6897.630034]  00007f5541f0e2e0 00000000006e2000 00007f5541f0e2e0 0000000000000094
> [ 6897.630034]  0000000000000011 ffffffffb458577f 000000001008feff 00000000000000af
> [ 6897.630034]  00000000000032e0 0000000000000094 00007f5541f0e2e0 0000000000000011
> [ 6897.630034] Call Trace:
> [ 6897.630034] int_check_syscall_exit_work (arch/x86/kernel/entry_64.S:795)
> [ 6897.630034] Code: 05 d1 9d f0 05 01 e8 2d 2e 14 00 4d 85 e4 75 10 65 ff 0c 25 a0 da 00 00 0f 84 85 00 00 00 eb 1c 49 8b 7c 24 08 4c 89 ea 48 89 de <41> ff 14 24 49 83 c4 10 49 83 3c 24 00 75 e6 eb d4 0f 1f 40 00
> [ 6897.630034] RIP syscall_trace_leave (include/trace/events/syscalls.h:42 arch/x86/kernel/ptrace.c:1517)
> [ 6897.630034]  RSP <ffff88000ef05f20>
> 
> 
> Thanks,
> Sasha
> 

