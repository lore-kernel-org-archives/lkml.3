Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753066AbaBNUTk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 15:19:40 -0500
Received: from qmta05.emeryville.ca.mail.comcast.net ([76.96.30.48]:40276 "EHLO
	qmta05.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752984AbaBNUTj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 15:19:39 -0500
Message-Id: <20140214201905.383951878@linux.com>
Date: Fri, 14 Feb 2014 14:18:55 -0600
From: Christoph Lameter <cl@linux.com>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linuxfoundation.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        James Hogan <james.hogan@imgtec.com>
Subject: [PATCH 14/48] drivers/clocksource: Replace __get_cpu_var used for address calculation
References: <20140214201841.826179349@linux.com>
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
--- linux.orig/drivers/clocksource/metag_generic.c	2013-12-02 16:07:49.294647442 -0600
+++ linux/drivers/clocksource/metag_generic.c	2013-12-02 16:07:49.284647718 -0600
@@ -90,7 +90,7 @@ static struct clocksource clocksource_me
 
 static irqreturn_t metag_timer_interrupt(int irq, void *dummy)
 {
-	struct clock_event_device *evt = &__get_cpu_var(local_clockevent);
+	struct clock_event_device *evt = this_cpu_ptr(&local_clockevent);
 
 	evt->event_handler(evt);
 

