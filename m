Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757251AbaDHO1M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 10:27:12 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:50455 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757197AbaDHO1K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 10:27:10 -0400
Message-ID: <53440730.3070507@oracle.com>
Date: Tue, 08 Apr 2014 10:26:56 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>, fweisbec@gmail.com,
        Ingo Molnar <mingo@kernel.org>
CC: Dave Jones <davej@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Subject: ftrace: ftrace_bug, ftrace failed to modify nva3_ram_init
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

While fuzzing with trinity inside a KVM tools guest running the latest -next
kernel, I've stumbled on the following:

[ 2983.109380] WARNING: CPU: 0 PID: 744 at kernel/trace/ftrace.c:1704 ftrace_bug+0xb0/0x280()
[ 2983.110893] Modules linked in:
[ 2983.111439] CPU: 0 PID: 744 Comm: trinity-main Tainted: G        W     3.14.0-next-20140407-sasha-00023-gd35b0d6 #382
[ 2983.112845]  0000000000000009 ffff88002c4e3b88 ffffffffa252ee51 0000000000002420
[ 2983.113993]  0000000000000000 ffff88002c4e3bc8 ffffffff9f15a2dc ffffffff9fffffc0
[ 2983.115134]  ffff88018aaad530 ffffffffa0000000 000000000000ad53 ffffffffa6486e10
[ 2983.116221] Call Trace:
[ 2983.116603] dump_stack (lib/dump_stack.c:52)
[ 2983.117306] warn_slowpath_common (kernel/panic.c:419)
[ 2983.118252] ? nva3_ram_prog (drivers/gpu/drm/nouveau/core/subdev/fb/ramnva3.c:318)
[ 2983.119091] ? nva3_ram_tidy (drivers/gpu/drm/nouveau/core/subdev/fb/ramnva3.c:326)
[ 2983.119836] ? __fentry__ (arch/x86/kernel/entry_64.S:106)
[ 2983.121379] warn_slowpath_null (kernel/panic.c:454)
[ 2983.122635] ftrace_bug (kernel/trace/ftrace.c:1704 (discriminator 3))
[ 2983.123688] ftrace_replace_code (arch/x86/kernel/ftrace.c:625 (discriminator 3))
[ 2983.124938] ftrace_modify_all_code (kernel/trace/ftrace.c:2011)
[ 2983.126208] arch_ftrace_update_code (arch/x86/include/asm/atomic.h:103 arch/x86/kernel/ftrace.c:680)
[ 2983.127613] ftrace_run_update_code (kernel/trace/ftrace.c:2088)
[ 2983.128540] ftrace_startup_enable (kernel/trace/ftrace.c:2114)
[ 2983.129392] ftrace_startup (kernel/trace/ftrace.c:2146)
[ 2983.130679] register_ftrace_function (kernel/trace/ftrace.c:4864)
[ 2983.131667] perf_ftrace_event_register (kernel/trace/trace_event_perf.c:356)
[ 2983.132590] perf_trace_init (kernel/trace/trace_event_perf.c:187 kernel/trace/trace_event_perf.c:206)
[ 2983.133377] ? __lock_is_held (kernel/locking/lockdep.c:3516)
[ 2983.134181] perf_tp_event_init (kernel/events/core.c:5937)
[ 2983.135043] perf_init_event (kernel/events/core.c:6598)
[ 2983.135882] ? perf_pmu_unregister (kernel/events/core.c:6577)
[ 2983.136803] perf_event_alloc (kernel/events/core.c:6754)
[ 2983.137831] SYSC_perf_event_open (kernel/events/core.c:7062)
[ 2983.138798] ? preempt_count_sub (kernel/sched/core.c:2526)
[ 2983.139643] ? context_tracking_user_exit (arch/x86/include/asm/paravirt.h:809 (discriminator 2) kernel/context_tracking.c:182 (discriminator 2))
[ 2983.140912] ? context_tracking_user_exit (arch/x86/include/asm/paravirt.h:809 (discriminator 2) kernel/context_tracking.c:182 (discriminator 2))
[ 2983.141941] SyS_perf_event_open (kernel/events/core.c:6990)
[ 2983.142771] tracesys (arch/x86/kernel/entry_64.S:749)
[ 2983.144740] ---[ end trace 6321065f5978f85b ]---
[ 2983.145355] ftrace failed to modify nva3_ram_init (drivers/gpu/drm/nouveau/core/subdev/fb/ramnva3.c:326)
[ 2983.146357]  actual: 90:66:66:66:90
[ 2983.147116] Failed on adding breakpoints (44371):


Thanks,
Sasha
