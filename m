Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752818AbaAQPTB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 10:19:01 -0500
Received: from qmta02.emeryville.ca.mail.comcast.net ([76.96.30.24]:39240 "EHLO
	qmta02.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752600AbaAQPSj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 10:18:39 -0500
Message-Id: <20140117151835.198195230@linux.com>
Date: Fri, 17 Jan 2014 09:18:20 -0600
From: Christoph Lameter <cl@linux.com>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linuxfoundation.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Bryan Wu <cooloney@gmail.com>
Subject: [PATCH 08/41] drivers/leds: Replace __get_cpu_var use through this_cpu_ptr
References: <20140117151812.770437629@linux.com>
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=this_drivers_leds
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use this_cpu_ptr for the address calculation instead of __get_cpu_var.

Acked-by: Bryan Wu <cooloney@gmail.com>
Signed-off-by: Christoph Lameter <cl@linux.com>

Index: linux/drivers/leds/trigger/ledtrig-cpu.c
===================================================================
--- linux.orig/drivers/leds/trigger/ledtrig-cpu.c	2013-12-02 16:07:48.974656330 -0600
+++ linux/drivers/leds/trigger/ledtrig-cpu.c	2013-12-02 16:07:48.964656610 -0600
@@ -46,7 +46,7 @@ static DEFINE_PER_CPU(struct led_trigger
  */
 void ledtrig_cpu(enum cpu_led_event ledevt)
 {
-	struct led_trigger_cpu *trig = &__get_cpu_var(cpu_trig);
+	struct led_trigger_cpu *trig = this_cpu_ptr(&cpu_trig);
 
 	/* Locate the correct CPU LED */
 	switch (ledevt) {

