Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932647AbaFQJUc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 05:20:32 -0400
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:43051 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755842AbaFQJU3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 05:20:29 -0400
Message-ID: <53A007F7.6020103@linux.vnet.ibm.com>
Date: Tue, 17 Jun 2014 14:48:47 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Sachin Kamat <sachin.kamat@samsung.com>, linux-kernel@vger.kernel.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-samsung-soc@vger.kernel.org, akpm@linux-foundation.org
CC: Sachin Kamat <spk.linux@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
        nicolas.pitre@linaro.org, fweisbec@gmail.com
Subject: Re: Boot warnings on exynos5420 based boards
References: <CAK5sBcEJOJDtt_7ow=q=hiN8-JRHzOUg6t=T3hTNOwzKq5dodw@mail.gmail.com>
In-Reply-To: <CAK5sBcEJOJDtt_7ow=q=hiN8-JRHzOUg6t=T3hTNOwzKq5dodw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14061709-9574-0000-0000-00000E596966
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sachin,

On 06/17/2014 01:39 PM, Sachin Kamat wrote:
> Hi,
> 
> I observe the below warnings while trying to boot Exynos5420 based boards
> since yesterday's linux-next (next-20140616) using multi_v7_defconfig. Looks

I guess you meant next-20140617.

> like it is triggered by the commit 56e6921829 ("CPU hotplug, smp:
> flush any pending IPI callbacks before CPU offline"). Any ideas?
> 
> 
> *************************************************************
> [    0.046521] Exynos MCPM support installed
> [    0.048939] CPU1: Booted secondary processor
> [    0.065005] CPU1: update cpu_capacity 1535
> [    0.065011] CPU1: thread -1, cpu 1, socket 0, mpidr 80000001
> [    0.065660] CPU2: Booted secondary processor
> [    0.085005] CPU2: update cpu_capacity 1535
> [    0.085012] CPU2: thread -1, cpu 2, socket 0, mpidr 80000002
> [    0.085662] CPU3: Booted secondary processor
> [    0.105005] CPU3: update cpu_capacity 1535
> [    0.105011] CPU3: thread -1, cpu 3, socket 0, mpidr 80000003
> [    1.105031] CPU4: failed to come online
> [    1.105081] ------------[ cut here ]------------
> [    1.105104] WARNING: CPU: 0 PID: 1 at kernel/smp.c:228
> flush_smp_call_function_queue+0xc0/0x178()
> [    1.105112] Modules linked in:
> [    1.105129] CPU: 0 PID: 1 Comm: swapper/0 Not tainted
> 3.15.0-next-20140616-00002-g38f9385a061b #2035
> [    1.105157] [<c02160f0>] (unwind_backtrace) from [<c0211c8c>]
> (show_stack+0x10/0x14)
> [    1.105179] [<c0211c8c>] (show_stack) from [<c0853794>]
> (dump_stack+0x8c/0x9c)
> [    1.105198] [<c0853794>] (dump_stack) from [<c024bdf4>]
> (warn_slowpath_common+0x70/0x8c)
> [    1.105216] [<c024bdf4>] (warn_slowpath_common) from [<c024beac>]
> (warn_slowpath_null+0x1c/0x24)
> [    1.105235] [<c024beac>] (warn_slowpath_null) from [<c02a3944>]
> (flush_smp_call_function_queue+0xc0/0x178)
> [    1.105253] [<c02a3944>] (flush_smp_call_function_queue) from
> [<c02a3a94>] (hotplug_cfd+0x98/0xd8)
> [    1.105269] [<c02a3a94>] (hotplug_cfd) from [<c026b064>]
> (notifier_call_chain+0x44/0x84)
> [    1.105285] [<c026b064>] (notifier_call_chain) from [<c024c1a4>]
> (_cpu_up+0x120/0x170)
> [    1.105302] [<c024c1a4>] (_cpu_up) from [<c024c264>] (cpu_up+0x70/0x94)
> [    1.105319] [<c024c264>] (cpu_up) from [<c0b5839c>] (smp_init+0xac/0xb0)
> [    1.105337] [<c0b5839c>] (smp_init) from [<c0b2fc54>]
> (kernel_init_freeable+0x90/0x1dc)
> [    1.105353] [<c0b2fc54>] (kernel_init_freeable) from [<c0851248>]
> (kernel_init+0xc/0xe8)
> [    1.105368] [<c0851248>] (kernel_init) from [<c020e7f8>]
> (ret_from_fork+0x14/0x3c)
> [    1.105389] ---[ end trace bc66942e4ab63168 ]---

Argh! I had put the switch-case handling for CPU_DYING at the 'wrong' place,
since I hadn't noticed that CPU_UP_CANCELED silently falls-through to CPU_DEAD.
This is what happens when people don't explicitly write "fall-through" in the
comments in a switch-case statement :-(

Below is an updated patch, please let me know how it goes. (You'll have to
revert c47a9d7cca first, and then 56e692182, before trying this patch).

[c47a9d7cca - CPU hotplug, smp: Execute any pending IPI callbacks before CPU
              offline]
[56e692182  - CPU hotplug, smp: flush any pending IPI callbacks before CPU
              offline]

Andrew, can you please use this patch instead?

Thanks a lot!

------------------------------------------------------------------------------

From: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
[PATCH] CPU hotplug, smp: Execute any pending IPI callbacks before CPU offline

There is a race between the CPU offline code (within stop-machine) and the
smp-call-function code, which can lead to getting IPIs on the outgoing CPU,
*after* it has gone offline.

Specifically, this can happen when using smp_call_function_single_async() to
send the IPI, since this API allows sending asynchronous IPIs from IRQ
disabled contexts. The exact race condition is described below.

During CPU offline, in stop-machine, we don't enforce any rule in the
_DISABLE_IRQ stage, regarding the order in which the outgoing CPU and the
other CPUs disable their local interrupts. Due to this, we can encounter a
situation in which an IPI is sent by one of the other CPUs to the outgoing CPU
(while it is *still* online), but the outgoing CPU ends up noticing it only
*after* it has gone offline.

              CPU 1                                         CPU 2
          (Online CPU)                               (CPU going offline)

       Enter _PREPARE stage                          Enter _PREPARE stage

                                                     Enter _DISABLE_IRQ stage

                                                   =
       Got a device interrupt, and                 | Didn't notice the IPI
       the interrupt handler sent an               | since interrupts were
       IPI to CPU 2 using                          | disabled on this CPU.
       smp_call_function_single_async()            |
                                                   =

       Enter _DISABLE_IRQ stage

       Enter _RUN stage                              Enter _RUN stage

                                  =
       Busy loop with interrupts  |                  Invoke take_cpu_down()
       disabled.                  |                  and take CPU 2 offline
                                  =

       Enter _EXIT stage                             Enter _EXIT stage

       Re-enable interrupts                          Re-enable interrupts

                                                     The pending IPI is noted
                                                     immediately, but alas,
                                                     the CPU is offline at
                                                     this point.

This of course, makes the smp-call-function IPI handler code running on CPU 2
unhappy and it complains about "receiving an IPI on an offline CPU".
One real example of the scenario on CPU 1 is the block layer's
complete-request call-path:
	__blk_complete_request() [interrupt-handler]
	    raise_blk_irq()
	        smp_call_function_single_async()


However, if we look closely, the block layer does check that the target CPU is
online before firing the IPI. So in this case, it is actually the unfortunate
ordering/timing of events in the stop-machine phase that leads to receiving
IPIs after the target CPU has gone offline.

In reality, getting a late IPI on an offline CPU is not too bad by itself
(this can happen even due to hardware latencies in IPI send-receive). It is
a bug only if the target CPU really went offline without executing all the
callbacks queued on its list. (Note that a CPU is free to execute its pending
smp-call-function callbacks in a batch, without waiting for the corresponding
IPIs to arrive for each one of those callbacks).

So, fixing this issue can be broken up into two parts:
1. Ensure that a CPU goes offline only after executing all the callbacks
   queued on it.
2. Modify the warning condition in the smp-call-function IPI handler code
   such that it warns only if an offline CPU got an IPI *and* that CPU had
   gone offline with callbacks still pending in its queue.

Achieving part 1 is straight-forward - just flush (execute) all the queued
callbacks on the outgoing CPU in the CPU_DYING stage[1], including those
callbacks for which the source CPU's IPIs might not have been received on
the outgoing CPU yet. Once we do this, an IPI that arrives late on the CPU
going offline (either due to the race mentioned above, or due to hardware
latencies) will be completely harmless, since the outgoing CPU would have
executed all the queued callbacks before going offline.

Overall, this fix (parts 1 and 2 put together) additionally guarantees that
we will see a warning only when the *IPI-sender code* is buggy - that is, if
it queues the callback _after_ the target CPU has gone offline.


[1]. The CPU_DYING part needs a little more explanation: by the time we
execute the CPU_DYING notifier callbacks, the CPU would have already been
marked offline. But we want to flush out the pending callbacks at this stage,
ignoring the fact that the CPU is offline. So restructure the IPI handler
code so that we can by-pass the "is-cpu-offline?" check in this particular
case. (Of course, the right solution here is to fix CPU hotplug to mark the
CPU offline _after_ invoking the CPU_DYING notifiers, but this requires a
lot of audit to ensure that this change doesn't break any existing code;
hence lets go with the solution proposed above until that is done).

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Suggested-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Borislav Petkov <bp@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Gautham R Shenoy <ego@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Mike Galbraith <mgalbraith@suse.de>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rafael J. Wysocki <rjw@rjwysocki.net>
Cc: Rik van Riel <riel@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

Update: Move the switch-case handling for CPU_DYING such that CPU_UP_CANCELED
falls-through to CPU_DEAD (instead of CPU_DYING). Also, add an explicit comment
mentioning this.

 kernel/smp.c |   57 +++++++++++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 49 insertions(+), 8 deletions(-)

diff --git a/kernel/smp.c b/kernel/smp.c
index 306f818..80c33f8 100644
--- a/kernel/smp.c
+++ b/kernel/smp.c
@@ -29,6 +29,8 @@ static DEFINE_PER_CPU_SHARED_ALIGNED(struct call_function_data, cfd_data);
 
 static DEFINE_PER_CPU_SHARED_ALIGNED(struct llist_head, call_single_queue);
 
+static void flush_smp_call_function_queue(bool warn_cpu_offline);
+
 static int
 hotplug_cfd(struct notifier_block *nfb, unsigned long action, void *hcpu)
 {
@@ -51,12 +53,27 @@ hotplug_cfd(struct notifier_block *nfb, unsigned long action, void *hcpu)
 #ifdef CONFIG_HOTPLUG_CPU
 	case CPU_UP_CANCELED:
 	case CPU_UP_CANCELED_FROZEN:
+		/* Fall-through to the CPU_DEAD[_FROZEN] case. */
 
 	case CPU_DEAD:
 	case CPU_DEAD_FROZEN:
 		free_cpumask_var(cfd->cpumask);
 		free_percpu(cfd->csd);
 		break;
+
+	case CPU_DYING:
+	case CPU_DYING_FROZEN:
+		/*
+		 * The IPIs for the smp-call-function callbacks queued by other
+		 * CPUs might arrive late, either due to hardware latencies or
+		 * because this CPU disabled interrupts (inside stop-machine)
+		 * before the IPIs were sent. So flush out any pending callbacks
+		 * explicitly (without waiting for the IPIs to arrive), to
+		 * ensure that the outgoing CPU doesn't go offline with work
+		 * still pending.
+		 */
+		flush_smp_call_function_queue(false);
+		break;
 #endif
 	};
 
@@ -177,23 +194,47 @@ static int generic_exec_single(int cpu, struct call_single_data *csd,
 	return 0;
 }
 
-/*
- * Invoked by arch to handle an IPI for call function single. Must be
- * called from the arch with interrupts disabled.
+/**
+ * generic_smp_call_function_single_interrupt - Execute SMP IPI callbacks
+ *
+ * Invoked by arch to handle an IPI for call function single.
+ * Must be called with interrupts disabled.
  */
 void generic_smp_call_function_single_interrupt(void)
 {
+	flush_smp_call_function_queue(true);
+}
+
+/**
+ * flush_smp_call_function_queue - Flush pending smp-call-function callbacks
+ *
+ * @warn_cpu_offline: If set to 'true', warn if callbacks were queued on an
+ *		      offline CPU. Skip this check if set to 'false'.
+ *
+ * Flush any pending smp-call-function callbacks queued on this CPU. This is
+ * invoked by the generic IPI handler, as well as by a CPU about to go offline,
+ * to ensure that all pending IPI callbacks are run before it goes completely
+ * offline.
+ *
+ * Loop through the call_single_queue and run all the queued callbacks.
+ * Must be called with interrupts disabled.
+ */
+static void flush_smp_call_function_queue(bool warn_cpu_offline)
+{
+	struct llist_head *head;
 	struct llist_node *entry;
 	struct call_single_data *csd, *csd_next;
 	static bool warned;
 
-	entry = llist_del_all(&__get_cpu_var(call_single_queue));
+	WARN_ON(!irqs_disabled());
+
+	head = &__get_cpu_var(call_single_queue);
+	entry = llist_del_all(head);
 	entry = llist_reverse_order(entry);
 
-	/*
-	 * Shouldn't receive this interrupt on a cpu that is not yet online.
-	 */
-	if (unlikely(!cpu_online(smp_processor_id()) && !warned)) {
+	/* There shouldn't be any pending callbacks on an offline CPU. */
+	if (unlikely(warn_cpu_offline && !cpu_online(smp_processor_id()) &&
+		     !warned && !llist_empty(head))) {
 		warned = true;
 		WARN(1, "IPI on offline CPU %d\n", smp_processor_id());
 


