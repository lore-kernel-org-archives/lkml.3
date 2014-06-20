Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757669AbaFTTjA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 15:39:00 -0400
Received: from qmta02.emeryville.ca.mail.comcast.net ([76.96.30.24]:51977 "EHLO
	qmta02.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965850AbaFTTbq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 15:31:46 -0400
Message-Id: <20140620193125.796020467@linux.com>
Date: Fri, 20 Jun 2014 14:31:23 -0500
From: Christoph Lameter <cl@linux.com>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linuxfoundation.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        James Hogan <james.hogan@imgtec.com>
Subject: [PATCH 08/31] drivers/clocksource: Replace __get_cpu_var used for address calculation
References: <20140620193115.547427118@linux.com>
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=this_drivers_clocksource
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace __get_cpu_var used for address calculation with this_cpu_ptr.

Acked-by: James Hogan <james.hogan@imgtec.com>
Signed-off-by: Christoph Lameter <cl@linux.com>

Index: linux/drivers/clocksource/metag_generic.c
===================================================================
--- linux.orig/drivers/clocksource/metag_generic.c	2014-04-14 13:24:54.861360279 -0500
+++ linux/drivers/clocksource/metag_generic.c	2014-04-14 13:24:54.857360357 -0500
@@ -90,7 +90,7 @@
 
 static irqreturn_t metag_timer_interrupt(int irq, void *dummy)
 {
-	struct clock_event_device *evt = &__get_cpu_var(local_clockevent);
+	struct clock_event_device *evt = this_cpu_ptr(&local_clockevent);
 
 	evt->event_handler(evt);
 

