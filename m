Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752600Ab3FYPgG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 11:36:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21713 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750971Ab3FYPgD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 11:36:03 -0400
Date: Tue, 25 Jun 2013 11:35:20 -0400
From: Dave Jones <davej@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrey Vagin <avagin@openvz.org>, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: frequent softlockups with 3.10rc6.
Message-ID: <20130625153520.GA7784@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Oleg Nesterov <oleg@redhat.com>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Andrey Vagin <avagin@openvz.org>,
	Steven Rostedt <rostedt@goodmis.org>
References: <20130621151119.GA1596@redhat.com>
 <20130621195949.GA15519@redhat.com>
 <20130622013731.GA22918@redhat.com>
 <20130622173129.GA29375@redhat.com>
 <20130622215905.GA28238@redhat.com>
 <20130623143634.GA2000@redhat.com>
 <20130623150603.GA32313@redhat.com>
 <20130623160452.GA11740@redhat.com>
 <20130624155758.GA5993@redhat.com>
 <20130624173510.GA1321@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130624173510.GA1321@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Took a lot longer to trigger this time. (13 hours of runtime).

This trace may still not be from the first lockup, as a flood of
them happened at the same time. 


# tracer: preemptirqsoff
#
# preemptirqsoff latency trace v1.1.5 on 3.10.0-rc7+
# --------------------------------------------------------------------
# latency: 389877255 us, #4/4, CPU#1 | (M:preempt VP:0, KP:0, SP:0 HP:0 #P:4)
#    -----------------
#    | task: trinity-main-9252 (uid:1000 nice:19 policy:0 rt_prio:0)
#    -----------------
#  => started at: vprintk_emit
#  => ended at:   vprintk_emit
#
#
#                  _------=> CPU#            
#                 / _-----=> irqs-off        
#                | / _----=> need-resched    
#                || / _---=> hardirq/softirq 
#                ||| / _--=> preempt-depth   
#                |||| /     delay             
#  cmd     pid   ||||| time  |   caller      
#     \   /      |||||  \    |   /           
trinity--9252    1dNh1    0us!: console_unlock <-vprintk_emit
trinity--9252    1dNh1 389877255us : console_unlock <-vprintk_emit
trinity--9252    1dNh1 389877255us+: stop_critical_timings <-vprintk_emit
trinity--9252    1dNh1 389877261us : <stack trace>
 => console_unlock
 => vprintk_emit
 => printk
 => rcu_check_callbacks
 => update_process_times
 => tick_sched_handle.isra.16
 => tick_sched_timer
 => __run_hrtimer
 => hrtimer_interrupt
 => smp_apic_timer_interrupt
 => apic_timer_interrupt
 => _raw_spin_lock
 => evict
 => iput
 => dput
 => proc_flush_task
 => release_task
 => wait_consider_task
 => do_wait
 => SyS_wait4
 => tracesys


