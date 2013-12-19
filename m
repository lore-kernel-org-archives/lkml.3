Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756785Ab3LSQLz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 11:11:55 -0500
Received: from qmta15.emeryville.ca.mail.comcast.net ([76.96.27.228]:59516
	"EHLO qmta15.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754050Ab3LSPuh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 10:50:37 -0500
Message-Id: <20131219155031.607349999@linux.com>
Date: Thu, 19 Dec 2013 09:50:23 -0600
From: Christoph Lameter <cl@linux.com>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linuxfoundation.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Bryan Wu <cooloney@gmail.com>
Subject: [PATCH 08/40] drivers/leds: Replace __get_cpu_var use through this_cpu_ptr
References: <20131219155015.443763038@linux.com>
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

