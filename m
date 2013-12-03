Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755978Ab3LCXm0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 18:42:26 -0500
Received: from qmta11.emeryville.ca.mail.comcast.net ([76.96.27.211]:50681
	"EHLO qmta11.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755177Ab3LCXjI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 18:39:08 -0500
Message-Id: <20131203233300.132399950@linux.com>
User-Agent: quilt/0.60-1
Date: Tue, 03 Dec 2013 17:33:01 -0600
From: Christoph Lameter <cl@linux.com>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linuxfoundation.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>
Subject: [PATCH 29/41] arm: Replace __this_cpu_ptr with raw_cpu_ptr
References: <20131203233232.928771708@linux.com>
Content-Disposition: inline; filename=this_arm
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__this_cpu_ptr is being phased out. So replace with raw_cpu_ptr.

Cc: Russell King <linux@arm.linux.org.uk>
Cc: Catalin Marinas <catalin.marinas@arm.com>
CC: Will Deacon <will.deacon@arm.com>
Signed-off-by: Christoph Lameter <cl@linux.com>

Index: linux/arch/arm/kernel/smp_twd.c
===================================================================
--- linux.orig/arch/arm/kernel/smp_twd.c	2013-12-02 16:07:57.604416529 -0600
+++ linux/arch/arm/kernel/smp_twd.c	2013-12-02 16:07:57.604416529 -0600
@@ -92,7 +92,7 @@ static int twd_timer_ack(void)
 
 static void twd_timer_stop(void)
 {
-	struct clock_event_device *clk = __this_cpu_ptr(twd_evt);
+	struct clock_event_device *clk = raw_cpu_ptr(twd_evt);
 
 	twd_set_mode(CLOCK_EVT_MODE_UNUSED, clk);
 	disable_percpu_irq(clk->irq);
@@ -108,7 +108,7 @@ static void twd_update_frequency(void *n
 {
 	twd_timer_rate = *((unsigned long *) new_rate);
 
-	clockevents_update_freq(__this_cpu_ptr(twd_evt), twd_timer_rate);
+	clockevents_update_freq(raw_cpu_ptr(twd_evt), twd_timer_rate);
 }
 
 static int twd_rate_change(struct notifier_block *nb,
@@ -134,7 +134,7 @@ static struct notifier_block twd_clk_nb
 
 static int twd_clk_init(void)
 {
-	if (twd_evt && __this_cpu_ptr(twd_evt) && !IS_ERR(twd_clk))
+	if (twd_evt && raw_cpu_ptr(twd_evt) && !IS_ERR(twd_clk))
 		return clk_notifier_register(twd_clk, &twd_clk_nb);
 
 	return 0;
@@ -153,7 +153,7 @@ static void twd_update_frequency(void *d
 {
 	twd_timer_rate = clk_get_rate(twd_clk);
 
-	clockevents_update_freq(__this_cpu_ptr(twd_evt), twd_timer_rate);
+	clockevents_update_freq(raw_cpu_ptr(twd_evt), twd_timer_rate);
 }
 
 static int twd_cpufreq_transition(struct notifier_block *nb,
@@ -179,7 +179,7 @@ static struct notifier_block twd_cpufreq
 
 static int twd_cpufreq_init(void)
 {
-	if (twd_evt && __this_cpu_ptr(twd_evt) && !IS_ERR(twd_clk))
+	if (twd_evt && raw_cpu_ptr(twd_evt) && !IS_ERR(twd_clk))
 		return cpufreq_register_notifier(&twd_cpufreq_nb,
 			CPUFREQ_TRANSITION_NOTIFIER);
 
@@ -269,7 +269,7 @@ static void twd_get_clock(struct device_
  */
 static void twd_timer_setup(void)
 {
-	struct clock_event_device *clk = __this_cpu_ptr(twd_evt);
+	struct clock_event_device *clk = raw_cpu_ptr(twd_evt);
 	int cpu = smp_processor_id();
 
 	/*
Index: linux/arch/arm/mach-msm/timer.c
===================================================================
--- linux.orig/arch/arm/mach-msm/timer.c	2013-12-02 16:07:57.604416529 -0600
+++ linux/arch/arm/mach-msm/timer.c	2013-12-02 16:07:57.604416529 -0600
@@ -221,7 +221,7 @@ static void __init msm_timer_init(u32 dg
 		}
 
 		/* Immediately configure the timer on the boot CPU */
-		msm_local_timer_setup(__this_cpu_ptr(msm_evt));
+		msm_local_timer_setup(raw_cpu_ptr(msm_evt));
 	}
 
 err:

