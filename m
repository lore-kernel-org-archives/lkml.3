Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752096AbaFMTSs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 15:18:48 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:39291 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751074AbaFMTSr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 15:18:47 -0400
Message-ID: <539B4E92.60908@gmail.com>
Date: Fri, 13 Jun 2014 22:18:42 +0300
From: Marian Posteuca <posteuca@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Ftrace irqsoff tracer generates strange output
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I was analyzing the interrupt latency in my system( Freescale ARM MX6Q 
with linux kernel version 3.0.35), I am using the irqsoff tracer, and 
this is the output I'm getting for the biggest irq off latency:

     # tracer: irqsoff
     #
     # irqsoff latency trace v1.1.5
     # --------------------------------------------------------------------
     # latency: 2770 us, #89/89, CPU#0 | (M:preempt VP:0, KP:0, SP:0 
HP:0 #P:4)
     #    -----------------
     #    | task: swapper-0 (uid:0 nice:0 policy:0 rt_prio:0)
     #    -----------------
     #  => started at: tick_oneshot_mode_active
     #  => ended at:   default_idle
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
       <idle>-0       0d..1    1us : tick_oneshot_mode_active
       <idle>-0       0d..1    2us : clockevents_notify <-arch_idle
       <idle>-0       0d..1    3us : _raw_spin_lock_irqsave 
<-clockevents_notify
       <idle>-0       0d..1    5us : __raw_spin_lock_irqsave 
<-_raw_spin_lock_irqsave
       <idle>-0       0d..1    6us : add_preempt_count 
<-__raw_spin_lock_irqsave
       <idle>-0       0d..2    7us : clockevents_do_notify 
<-clockevents_notify
       <idle>-0       0d..2    8us : raw_notifier_call_chain 
<-clockevents_do_notify
       <idle>-0       0d..2   10us : __raw_notifier_call_chain 
<-raw_notifier_call_chain
       <idle>-0       0d..2   11us : notifier_call_chain 
<-__raw_notifier_call_chain
       <idle>-0       0d..2   12us : tick_notify <-notifier_call_chain
       <idle>-0       0d..2   13us : tick_broadcast_oneshot_control 
<-tick_notify
       <idle>-0       0d..2   15us : _raw_spin_lock_irqsave 
<-tick_broadcast_oneshot_control
       <idle>-0       0d..2   16us : __raw_spin_lock_irqsave 
<-_raw_spin_lock_irqsave
       <idle>-0       0d..2   17us+: add_preempt_count 
<-__raw_spin_lock_irqsave
       <idle>-0       0d..3   19us : clockevents_set_mode 
<-tick_broadcast_oneshot_control
       <idle>-0       0d..3   20us : twd_set_mode <-clockevents_set_mode
       <idle>-0       0d..3   21us : irq_modify_status <-gic_disable_ppi
       <idle>-0       0d..3   22us : __irq_get_desc_lock <-irq_modify_status
       <idle>-0       0d..3   24us : irq_to_desc <-__irq_get_desc_lock
       <idle>-0       0d..3   25us : _raw_spin_lock_irqsave 
<-__irq_get_desc_lock
       <idle>-0       0d..3   26us : __raw_spin_lock_irqsave 
<-_raw_spin_lock_irqsave
       <idle>-0       0d..3   27us : add_preempt_count 
<-__raw_spin_lock_irqsave
       <idle>-0       0d..4   29us : __irq_put_desc_unlock 
<-irq_modify_status
       <idle>-0       0d..4   30us : _raw_spin_unlock_irqrestore 
<-__irq_put_desc_unlock
       <idle>-0       0d..4   31us : sub_preempt_count 
<-_raw_spin_unlock_irqrestore
       <idle>-0       0d..3   32us : irq_get_irq_data <-gic_disable_ppi
       <idle>-0       0d..3   34us : irq_to_desc <-irq_get_irq_data
       <idle>-0       0d..3   35us : gic_mask_irq <-gic_disable_ppi
       <idle>-0       0d..3   36us : _raw_spin_lock <-gic_mask_irq
       <idle>-0       0d..3   37us : __raw_spin_lock <-_raw_spin_lock
       <idle>-0       0d..3   39us : add_preempt_count <-__raw_spin_lock
       <idle>-0       0d..4   40us : _raw_spin_unlock <-gic_mask_irq
       <idle>-0       0d..4   41us+: sub_preempt_count <-_raw_spin_unlock
       <idle>-0       0d..3   43us : _raw_spin_unlock_irqrestore 
<-tick_broadcast_oneshot_control
       <idle>-0       0d..3   44us : sub_preempt_count 
<-_raw_spin_unlock_irqrestore
       <idle>-0       0d..2   45us+: _raw_spin_unlock_irqrestore 
<-clockevents_notify
       <idle>-0       0d..2   47us : sub_preempt_count 
<-_raw_spin_unlock_irqrestore
       <idle>-0       0d..1   48us+: mxc_cpu_lp_set <-arch_idle
       <idle>-0       0d..1   50us+: gpc_mask_single_irq <-mxc_cpu_lp_set
       <idle>-0       0d..1   51us+: gpc_mask_single_irq <-mxc_cpu_lp_set
       <idle>-0       0d..1   53us+: arch_idle_multi_core <-arch_idle
       <idle>-0       0d..1   55us!: ca9_do_idle <-arch_idle_multi_core
       <idle>-0       0d..1 2709us : clockevents_notify <-arch_idle
       <idle>-0       0d..1 2710us : _raw_spin_lock_irqsave 
<-clockevents_notify
       <idle>-0       0d..1 2711us : __raw_spin_lock_irqsave 
<-_raw_spin_lock_irqsave
       <idle>-0       0d..1 2712us+: add_preempt_count 
<-__raw_spin_lock_irqsave
       <idle>-0       0d..2 2714us : clockevents_do_notify 
<-clockevents_notify
       <idle>-0       0d..2 2715us : raw_notifier_call_chain 
<-clockevents_do_notify
       <idle>-0       0d..2 2716us : __raw_notifier_call_chain 
<-raw_notifier_call_chain
       <idle>-0       0d..2 2717us : notifier_call_chain 
<-__raw_notifier_call_chain
       <idle>-0       0d..2 2718us : tick_notify <-notifier_call_chain
       <idle>-0       0d..2 2720us : tick_broadcast_oneshot_control 
<-tick_notify
       <idle>-0       0d..2 2721us : _raw_spin_lock_irqsave 
<-tick_broadcast_oneshot_control
       <idle>-0       0d..2 2722us : __raw_spin_lock_irqsave 
<-_raw_spin_lock_irqsave
       <idle>-0       0d..2 2723us : add_preempt_count 
<-__raw_spin_lock_irqsave
       <idle>-0       0d..3 2725us : clockevents_set_mode 
<-tick_broadcast_oneshot_control
       <idle>-0       0d..3 2726us : twd_set_mode <-clockevents_set_mode
       <idle>-0       0d..3 2727us : irq_modify_status <-gic_enable_ppi
       <idle>-0       0d..3 2729us : __irq_get_desc_lock <-irq_modify_status
       <idle>-0       0d..3 2730us : irq_to_desc <-__irq_get_desc_lock
       <idle>-0       0d..3 2731us : _raw_spin_lock_irqsave 
<-__irq_get_desc_lock
       <idle>-0       0d..3 2732us : __raw_spin_lock_irqsave 
<-_raw_spin_lock_irqsave
       <idle>-0       0d..3 2733us+: add_preempt_count 
<-__raw_spin_lock_irqsave
       <idle>-0       0d..4 2738us+: __irq_put_desc_unlock 
<-irq_modify_status
       <idle>-0       0d..4 2739us : _raw_spin_unlock_irqrestore 
<-__irq_put_desc_unlock
       <idle>-0       0d..4 2741us : sub_preempt_count 
<-_raw_spin_unlock_irqrestore
       <idle>-0       0d..3 2742us : irq_get_irq_data <-gic_enable_ppi
       <idle>-0       0d..3 2743us : irq_to_desc <-irq_get_irq_data
       <idle>-0       0d..3 2745us : gic_unmask_irq <-gic_enable_ppi
       <idle>-0       0d..3 2746us : _raw_spin_lock <-gic_unmask_irq
       <idle>-0       0d..3 2747us : __raw_spin_lock <-_raw_spin_lock
       <idle>-0       0d..3 2748us+: add_preempt_count <-__raw_spin_lock
       <idle>-0       0d..4 2750us : _raw_spin_unlock <-gic_unmask_irq
       <idle>-0       0d..4 2751us+: sub_preempt_count <-_raw_spin_unlock
       <idle>-0       0d..3 2753us : ktime_get 
<-tick_broadcast_oneshot_control
       <idle>-0       0d..3 2754us+: clocksource_mmio_readl_up <-ktime_get
       <idle>-0       0d..3 2756us : tick_program_event 
<-tick_broadcast_oneshot_control
       <idle>-0       0d..3 2757us : tick_dev_program_event 
<-tick_program_event
       <idle>-0       0d..3 2758us : ktime_get <-tick_dev_program_event
       <idle>-0       0d..3 2759us+: clocksource_mmio_readl_up <-ktime_get
       <idle>-0       0d..3 2761us : clockevents_program_event 
<-tick_dev_program_event
       <idle>-0       0d..3 2762us : twd_set_next_event 
<-clockevents_program_event
       <idle>-0       0d..3 2764us : _raw_spin_unlock_irqrestore 
<-tick_broadcast_oneshot_control
       <idle>-0       0d..3 2765us+: sub_preempt_count 
<-_raw_spin_unlock_irqrestore
       <idle>-0       0d..2 2767us : _raw_spin_unlock_irqrestore 
<-clockevents_notify
       <idle>-0       0d..2 2768us : sub_preempt_count 
<-_raw_spin_unlock_irqrestore
       <idle>-0       0d..1 2769us+: default_idle
       <idle>-0       0d..1 2772us+: trace_hardirqs_on <-default_idle
       <idle>-0       0d..1 2773us : <stack trace>
      => trace_hardirqs_on
      => default_idle
      => cpu_idle
      => rest_init
      => start_kernel
      =>

So according to ftrace I have a pretty big latency, I don't know how to 
interpret this correctly, the cpu is idling with interrupts disabled?

So I thought surely this cannot be true, so I looked more closely at 
function tick_oneshot_mode_active:

     int tick_oneshot_mode_active(void)
     {
         unsigned long flags;
         int ret;

         local_irq_save(flags);
         ret = __this_cpu_read(tick_cpu_device.mode) == 
TICKDEV_MODE_ONESHOT;
         local_irq_restore(flags);

         return ret;
     }
So in the macro local_irq_save, the interrupts are disabled and the 
function trace_hardirqs_off() is called which registers that the 
interrupts were disabled:

     #define local_irq_save(flags)                \
         do {                        \
             raw_local_irq_save(flags);        \
             trace_hardirqs_off();            \
         } while (0)

After checking the device mode the interrupts are enabled, now here I 
don't understand what is happening:

     #define local_irq_restore(flags)            \
         do {                        \
             if (raw_irqs_disabled_flags(flags)) {    \
                 raw_local_irq_restore(flags);    \
                 trace_hardirqs_off();        \
             } else {                \
                 trace_hardirqs_on();        \
                 raw_local_irq_restore(flags);    \
             }                    \
         } while (0)

In my case the code goes over the first branch:

     if (raw_irqs_disabled_flags(flags)) {    \
                     raw_local_irq_restore(flags);    \
                     trace_hardirqs_off();        \

It looks as if even though the interrupts are enabled back, function 
trace_hardirqs_on() is not called but trace_hardirqs_off(). Why is this 
happening, do I really have this big latency?
