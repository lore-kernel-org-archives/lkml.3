Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965965AbaFTTbr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 15:31:47 -0400
Received: from qmta01.emeryville.ca.mail.comcast.net ([76.96.30.16]:32835 "EHLO
	qmta01.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965334AbaFTTbo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 15:31:44 -0400
Message-Id: <20140620193125.688151423@linux.com>
Date: Fri, 20 Jun 2014 14:31:22 -0500
From: Christoph Lameter <cl@linux.com>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linuxfoundation.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Robert Richter <rric@kernel.org>,
        oprofile-list@lists.sf.net
Subject: [PATCH 07/31] drivers/oprofile: Replace __get_cpu_var uses for address calculation
References: <20140620193115.547427118@linux.com>
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=this_drivers_oprofile
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace the uses of __get_cpu_var for address calculation with this_cpu_ptr.

Cc: Robert Richter <rric@kernel.org>
Cc: oprofile-list@lists.sf.net
Signed-off-by: Christoph Lameter <cl@linux.com>

Index: linux/drivers/oprofile/cpu_buffer.c
===================================================================
--- linux.orig/drivers/oprofile/cpu_buffer.c	2014-04-14 13:24:54.801361443 -0500
+++ linux/drivers/oprofile/cpu_buffer.c	2014-04-14 13:24:54.793361597 -0500
@@ -45,7 +45,7 @@
 
 void oprofile_cpu_buffer_inc_smpl_lost(void)
 {
-	struct oprofile_cpu_buffer *cpu_buf = &__get_cpu_var(op_cpu_buffer);
+	struct oprofile_cpu_buffer *cpu_buf = this_cpu_ptr(&op_cpu_buffer);
 
 	cpu_buf->sample_lost_overflow++;
 }
@@ -297,7 +297,7 @@
 			  unsigned long event, int is_kernel,
 			  struct task_struct *task)
 {
-	struct oprofile_cpu_buffer *cpu_buf = &__get_cpu_var(op_cpu_buffer);
+	struct oprofile_cpu_buffer *cpu_buf = this_cpu_ptr(&op_cpu_buffer);
 	unsigned long backtrace = oprofile_backtrace_depth;
 
 	/*
@@ -357,7 +357,7 @@
 {
 	struct op_sample *sample;
 	int is_kernel = !user_mode(regs);
-	struct oprofile_cpu_buffer *cpu_buf = &__get_cpu_var(op_cpu_buffer);
+	struct oprofile_cpu_buffer *cpu_buf = this_cpu_ptr(&op_cpu_buffer);
 
 	cpu_buf->sample_received++;
 
@@ -412,13 +412,13 @@
 
 void oprofile_add_pc(unsigned long pc, int is_kernel, unsigned long event)
 {
-	struct oprofile_cpu_buffer *cpu_buf = &__get_cpu_var(op_cpu_buffer);
+	struct oprofile_cpu_buffer *cpu_buf = this_cpu_ptr(&op_cpu_buffer);
 	log_sample(cpu_buf, pc, 0, is_kernel, event, NULL);
 }
 
 void oprofile_add_trace(unsigned long pc)
 {
-	struct oprofile_cpu_buffer *cpu_buf = &__get_cpu_var(op_cpu_buffer);
+	struct oprofile_cpu_buffer *cpu_buf = this_cpu_ptr(&op_cpu_buffer);
 
 	if (!cpu_buf->tracing)
 		return;
Index: linux/drivers/oprofile/timer_int.c
===================================================================
--- linux.orig/drivers/oprofile/timer_int.c	2014-04-14 13:24:54.801361443 -0500
+++ linux/drivers/oprofile/timer_int.c	2014-04-14 13:24:54.797361519 -0500
@@ -32,7 +32,7 @@
 
 static void __oprofile_hrtimer_start(void *unused)
 {
-	struct hrtimer *hrtimer = &__get_cpu_var(oprofile_hrtimer);
+	struct hrtimer *hrtimer = this_cpu_ptr(&oprofile_hrtimer);
 
 	if (!ctr_running)
 		return;

