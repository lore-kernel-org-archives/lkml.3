Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752350AbaDCOTz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 10:19:55 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:50588 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752219AbaDCOTy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 10:19:54 -0400
Message-ID: <533D6DE6.5080905@oracle.com>
Date: Thu, 03 Apr 2014 10:19:18 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>, paulus@samba.org,
        Ingo Molnar <mingo@kernel.org>, acme@ghostprotocols.net
CC: LKML <linux-kernel@vger.kernel.org>
Subject: perf: warning in perf_event_delayed_put
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

While fuzzing with trinity inside a KVM tools guest running the latest
-next kernel I've stumbled on the following warning, which I happen
to hit quite often:

[  357.437823] WARNING: CPU: 19 PID: 28 at kernel/events/core.c:7554 perf_event_delayed_put+0x64/0x80()
[child196:9542] Chose rand_syscalls.[  357.441036] Modules linked in:
[  357.442041] CPU: 19 PID: 28 Comm: rcuop/16 Not tainted 3.14.0-next-20140402-sasha-00013-g0cfaf7e-dirty #367
[  357.445082]  0000000000000009 ffff88003e37fcd8 ffffffff944beb13 0000000000000003
[  357.447245]  0000000000000000 ffff88003e37fd18
ffffffff9115a37c 0000000000000000
[  357.449747]  ffff880464e63000 ffff880464e63000 ffff880464e64a80 ffffffff95e8d170
[  357.453659] Call Trace:
[  357.454401] dump_stack (lib/dump_stack.c:52)
[  357.455735] warn_slowpath_common (kernel/panic.c:418)
[  357.457395] warn_slowpath_null (kernel/panic.c:453)
[  357.458618] perf_event_delayed_put (kernel/events/core.c:7554 (discriminator 3))
[  357.461861] delayed_put_task_struct (kernel/exit.c:165 include/linux/jump_label.h:105 include/trace/events/sched.h:207 kernel/exit.c:166)
[  357.463530] ? kill_orphaned_pgrp (kernel/exit.c:162)
[  357.465035] ? kill_orphaned_pgrp (kernel/exit.c:162)
[  357.466981] rcu_nocb_kthread (include/linux/rcupdate.h:324 kernel/rcu/rcu.h:115 kernel/rcu/tree_plugin.h:2338)
[  357.469129] ? rcu_nocb_kthread (kernel/rcu/rcu.h:84 kernel/rcu/tree_plugin.h:2336)
[  357.471961] ? preempt_count_sub (kernel/sched/core.c:2527)
[  357.473873] ? bit_waitqueue (kernel/sched/wait.c:291)
[  357.475647] ? rcu_cpu_notify (kernel/rcu/tree_plugin.h:2276)
[  357.477478] kthread (kernel/kthread.c:219)
[  357.479168] ? kthread_create_on_node (kernel/kthread.c:185)
[  357.482077] ret_from_fork (arch/x86/kernel/entry_64.S:555)
[  357.483628] ? kthread_create_on_node (kernel/kthread.c:185)


Thanks,
Sasha
