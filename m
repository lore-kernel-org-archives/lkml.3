Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161606AbaJ3Xld (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 19:41:33 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:36133 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161577AbaJ3Xlc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 19:41:32 -0400
Message-ID: <5452CCA3.5020000@oracle.com>
Date: Thu, 30 Oct 2014 19:41:23 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        htejun@gmail.com
Subject: Re: rcu_preempt detected stalls.
References: <20141013173504.GA27955@redhat.com> <543DDD5E.9080602@oracle.com> <20141023183917.GX4977@linux.vnet.ibm.com> <54494F2F.6020005@oracle.com> <20141023195808.GB4977@linux.vnet.ibm.com> <544A45F8.2030207@oracle.com> <20141024161337.GQ4977@linux.vnet.ibm.com> <544A80B3.9070800@oracle.com> <20141027211329.GJ5718@linux.vnet.ibm.com>
In-Reply-To: <20141027211329.GJ5718@linux.vnet.ibm.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/27/2014 05:13 PM, Paul E. McKenney wrote:
> Thank you!  I would complain about the FAULT_INJECTION messages, but
> they don't appear to be happening all that frequently.
> 
> The stack dumps do look different here.  I suspect that this is a real
> issue in the VM code.

The stack dumps are pretty much different with every trace.

I just got a "double trace" for the first time, maybe it'll help:

[ 5887.980026] INFO: rcu_preempt detected stalls on CPUs/tasks:
[ 5887.980028] INFO: rcu_sched detected stalls on CPUs/tasks:
[ 5887.980029]
[ 5887.980030]
[ 5887.980046] 	0: (210 ticks this GP) idle=f11/140000000000002/0 softirq=18456/18456 last_accelerate: 36b9/86cf, nonlazy_posted: 38271, ..
[ 5887.980054] 	0: (210 ticks this GP) idle=f11/140000000000002/0 softirq=18456/18456 last_accelerate: 36b9/86cf, nonlazy_posted: 38271, ..
[ 5887.980060] 	
[ 5887.980073] 	
[ 5887.980074] (detected by 11, t=20502 jiffies, g=16314, c=16313, q=0)
[ 5887.980079] (detected by 28, t=20502 jiffies, g=-284, c=-285, q=0)
[ 5887.980081] Task dump for CPU 0:
[ 5887.980084] Task dump for CPU 0:
[ 5887.980090] trinity-c175    R
[ 5887.980092] trinity-c175    R
[ 5887.980094]   running task
[ 5887.980116]   running task    12864 17785   9032 0x0008000c
[ 5887.980120] 12864 17785   9032 0x0008000c
[ 5887.980125]  ffffffff940ff458
[ 5887.980127]  ffffffff940ff458
[ 5887.980130]  0000000000000286
[ 5887.980132]  0000000000000286
[ 5887.980134]  ffffffff9d28b638
[ 5887.980137]  ffffffff9d28b638
[ 5887.980139]  ffff88014b88b000
[ 5887.980141]  ffff88014b88b000
[ 5887.980141]
[ 5887.980142]
[ 5887.980146]  ffff88014b88b000
[ 5887.980148]  ffff88014b88b000
[ 5887.980151]  ffffffff9d300b30
[ 5887.980153]  ffffffff9d300b30
[ 5887.980155]  0000000000000000
[ 5887.980157]  0000000000000000
[ 5887.980160]  ffff88013dc476a8
[ 5887.980161]  ffff88013dc476a8
[ 5887.980161]
[ 5887.980163]
[ 5887.980167]  ffffffff9423b078
[ 5887.980169]  ffffffff9423b078
[ 5887.980171]  0000000000000002
[ 5887.980173]  0000000000000002
[ 5887.980175]  0000000000000000
[ 5887.980177]  0000000000000000
[ 5887.980180]  ffff88013dc477c0
[ 5887.980181]  ffff88013dc477c0
[ 5887.980181]
[ 5887.980183]
[ 5887.980185] Call Trace:
[ 5887.980187] Call Trace:
[ 5887.980208] ? __change_page_attr_set_clr (arch/x86/mm/pageattr.c:1109 arch/x86/mm/pageattr.c:1279)
[ 5887.980219] ? __change_page_attr_set_clr (arch/x86/mm/pageattr.c:1109 arch/x86/mm/pageattr.c:1279)
[ 5887.980232] ? check_flags (kernel/locking/lockdep.c:3532)
[ 5887.980241] ? check_flags (kernel/locking/lockdep.c:3532)
[ 5887.980253] ? preempt_count_sub (kernel/sched/core.c:2641)
[ 5887.980262] ? preempt_count_sub (kernel/sched/core.c:2641)
[ 5887.980269] ? debug_check_no_locks_freed (kernel/locking/lockdep.c:4076)
[ 5887.980278] ? debug_check_no_locks_freed (kernel/locking/lockdep.c:4076)
[ 5887.980294] ? _raw_spin_unlock_irqrestore (./arch/x86/include/asm/preempt.h:95 include/linux/spinlock_api_smp.h:161 kernel/locking/spinlock.c:191)
[ 5887.980303] ? _raw_spin_unlock_irqrestore (./arch/x86/include/asm/preempt.h:95 include/linux/spinlock_api_smp.h:161 kernel/locking/spinlock.c:191)
[ 5887.980312] ? kernel_map_pages (arch/x86/mm/pageattr.c:1801 arch/x86/mm/pageattr.c:1821)
[ 5887.980319] ? kernel_map_pages (arch/x86/mm/pageattr.c:1801 arch/x86/mm/pageattr.c:1821)
[ 5887.980334] ? free_pages_prepare (mm/page_alloc.c:779)
[ 5887.980344] ? free_pages_prepare (mm/page_alloc.c:779)
[ 5887.980351] ? __free_pages_ok (mm/page_alloc.c:787)
[ 5887.980358] ? __free_pages_ok (mm/page_alloc.c:787)
[ 5887.980365] ? free_compound_page (mm/page_alloc.c:364)
[ 5887.980373] ? free_compound_page (mm/page_alloc.c:364)
[ 5887.980380] ? put_compound_page (mm/swap.c:262)
[ 5887.980389] ? put_compound_page (mm/swap.c:262)
[ 5887.980395] ? preempt_count_sub (kernel/sched/core.c:2641)
[ 5887.980404] ? preempt_count_sub (kernel/sched/core.c:2641)
[ 5887.980411] ? release_pages (mm/swap.c:917)
[ 5887.980419] ? release_pages (mm/swap.c:917)
[ 5887.980430] ? free_pages_and_swap_cache (mm/swap_state.c:274)
[ 5887.980440] ? free_pages_and_swap_cache (mm/swap_state.c:274)
[ 5887.980449] ? tlb_flush_mmu_free (mm/memory.c:254 (discriminator 3))
[ 5887.980458] ? tlb_flush_mmu_free (mm/memory.c:254 (discriminator 3))
[ 5887.980465] ? unmap_page_range (mm/memory.c:1220 mm/memory.c:1263 mm/memory.c:1284 mm/memory.c:1308)
[ 5887.980473] ? unmap_page_range (mm/memory.c:1220 mm/memory.c:1263 mm/memory.c:1284 mm/memory.c:1308)
[ 5887.980481] ? unmap_single_vma (mm/memory.c:1355)
[ 5887.980489] ? unmap_single_vma (mm/memory.c:1355)
[ 5887.980496] ? unmap_vmas (mm/memory.c:1382 (discriminator 3))
[ 5887.980503] ? unmap_vmas (mm/memory.c:1382 (discriminator 3))
[ 5887.980512] ? exit_mmap (mm/mmap.c:2855)
[ 5887.980521] ? exit_mmap (mm/mmap.c:2855)
[ 5887.980530] ? kmem_cache_free (include/trace/events/kmem.h:143 mm/slub.c:2715)
[ 5887.980538] ? kmem_cache_free (include/trace/events/kmem.h:143 mm/slub.c:2715)
[ 5887.980546] ? mmput (kernel/fork.c:674)
[ 5887.980554] ? mmput (kernel/fork.c:674)
[ 5887.980561] ? do_exit (./arch/x86/include/asm/thread_info.h:168 kernel/exit.c:462 kernel/exit.c:747)
[ 5887.980569] ? do_exit (./arch/x86/include/asm/thread_info.h:168 kernel/exit.c:462 kernel/exit.c:747)
[ 5887.980578] ? rcu_start_future_gp (kernel/rcu/tree.c:1364)
[ 5887.980589] ? rcu_start_future_gp (kernel/rcu/tree.c:1364)
[ 5887.980596] ? recalc_sigpending_tsk (include/linux/thread_info.h:71 include/linux/sched.h:2733 kernel/signal.c:137)
[ 5887.980605] ? recalc_sigpending_tsk (include/linux/thread_info.h:71 include/linux/sched.h:2733 kernel/signal.c:137)
[ 5887.980613] ? debug_lockdep_rcu_enabled (kernel/rcu/update.c:136 (discriminator 1))
[ 5887.980621] ? debug_lockdep_rcu_enabled (kernel/rcu/update.c:136 (discriminator 1))
[ 5887.980630] ? do_group_exit (./arch/x86/include/asm/current.h:14 kernel/exit.c:875)
[ 5887.980637] ? do_group_exit (./arch/x86/include/asm/current.h:14 kernel/exit.c:875)
[ 5887.980645] ? preempt_count_sub (kernel/sched/core.c:2641)
[ 5887.980651] ? preempt_count_sub (kernel/sched/core.c:2641)
[ 5887.980660] ? get_signal (kernel/signal.c:2358)
[ 5887.980667] ? get_signal (kernel/signal.c:2358)
[ 5887.980676] ? trace_hardirqs_off_caller (kernel/locking/lockdep.c:2621)
[ 5887.980683] ? trace_hardirqs_off_caller (kernel/locking/lockdep.c:2621)
[ 5887.980692] ? do_signal (arch/x86/kernel/signal.c:703)
[ 5887.980701] ? do_signal (arch/x86/kernel/signal.c:703)
[ 5887.980707] ? get_parent_ip (kernel/sched/core.c:2585)
[ 5887.980714] ? get_parent_ip (kernel/sched/core.c:2585)
[ 5887.980723] ? _raw_spin_unlock (./arch/x86/include/asm/preempt.h:95 include/linux/spinlock_api_smp.h:152 kernel/locking/spinlock.c:183)
[ 5887.980731] ? _raw_spin_unlock (./arch/x86/include/asm/preempt.h:95 include/linux/spinlock_api_smp.h:152 kernel/locking/spinlock.c:183)
[ 5887.980740] ? context_tracking_user_exit (include/linux/vtime.h:89 include/linux/jump_label.h:114 include/trace/events/context_tracking.h:47 kernel/context_tracking.c:140)
[ 5887.980748] ? context_tracking_user_exit (include/linux/vtime.h:89 include/linux/jump_label.h:114 include/trace/events/context_tracking.h:47 kernel/context_tracking.c:140)
[ 5887.980757] ? trace_hardirqs_on_caller (kernel/locking/lockdep.c:2566)
[ 5887.980764] ? trace_hardirqs_on_caller (kernel/locking/lockdep.c:2566)
[ 5887.980772] ? trace_hardirqs_on (kernel/locking/lockdep.c:2609)
[ 5887.980778] ? trace_hardirqs_on (kernel/locking/lockdep.c:2609)
[ 5887.980787] ? do_notify_resume (arch/x86/kernel/signal.c:756)
[ 5887.980793] ? do_notify_resume (arch/x86/kernel/signal.c:756)
[ 5887.980802] ? int_signal (arch/x86/kernel/entry_64.S:587)
[ 5887.980809] ? int_signal (arch/x86/kernel/entry_64.S:587)


Thanks,
Sasha
