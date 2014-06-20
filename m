Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755138AbaFTTcN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 15:32:13 -0400
Received: from qmta02.emeryville.ca.mail.comcast.net ([76.96.30.24]:51977 "EHLO
	qmta02.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754662AbaFTTcJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 15:32:09 -0400
Message-Id: <20140620193127.002883469@linux.com>
Date: Fri, 20 Jun 2014 14:31:33 -0500
From: Christoph Lameter <cl@linux.com>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linuxfoundation.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>
Subject: [PATCH 18/31] arm: Replace __this_cpu_ptr with raw_cpu_ptr
References: <20140620193115.547427118@linux.com>
Content-Type: text/plain; charset=UTF-8
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
--- linux.orig/arch/arm/kernel/smp_twd.c	2014-04-14 13:33:53.858921317 -0500
+++ linux/arch/arm/kernel/smp_twd.c	2014-04-14 13:33:53.854921395 -0500
@@ -92,7 +92,7 @@
 
 static void twd_timer_stop(void)
 {
-	struct clock_event_device *clk = __this_cpu_ptr(twd_evt);
+	struct clock_event_device *clk = raw_cpu_ptr(twd_evt);
 
 	twd_set_mode(CLOCK_EVT_MODE_UNUSED, clk);
 	disable_percpu_irq(clk->irq);
@@ -108,7 +108,7 @@
 {
 	twd_timer_rate = *((unsigned long *) new_rate);
 
-	clockevents_update_freq(__this_cpu_ptr(twd_evt), twd_timer_rate);
+	clockevents_update_freq(raw_cpu_ptr(twd_evt), twd_timer_rate);
 }
 
 static int twd_rate_change(struct notifier_block *nb,
@@ -134,7 +134,7 @@
 
 static int twd_clk_init(void)
 {
-	if (twd_evt && __this_cpu_ptr(twd_evt) && !IS_ERR(twd_clk))
+	if (twd_evt && raw_cpu_ptr(twd_evt) && !IS_ERR(twd_clk))
 		return clk_notifier_register(twd_clk, &twd_clk_nb);
 
 	return 0;
@@ -153,7 +153,7 @@
 {
 	twd_timer_rate = clk_get_rate(twd_clk);
 
-	clockevents_update_freq(__this_cpu_ptr(twd_evt), twd_timer_rate);
+	clockevents_update_freq(raw_cpu_ptr(twd_evt), twd_timer_rate);
 }
 
 static int twd_cpufreq_transition(struct notifier_block *nb,
@@ -179,7 +179,7 @@
 
 static int twd_cpufreq_init(void)
 {
-	if (twd_evt && __this_cpu_ptr(twd_evt) && !IS_ERR(twd_clk))
+	if (twd_evt && raw_cpu_ptr(twd_evt) && !IS_ERR(twd_clk))
 		return cpufreq_register_notifier(&twd_cpufreq_nb,
 			CPUFREQ_TRANSITION_NOTIFIER);
 
@@ -269,7 +269,7 @@
  */
 static void twd_timer_setup(void)
 {
-	struct clock_event_device *clk = __this_cpu_ptr(twd_evt);
+	struct clock_event_device *clk = raw_cpu_ptr(twd_evt);
 	int cpu = smp_processor_id();
 
 	/*

