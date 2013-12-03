Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754405Ab3LCXiK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 18:38:10 -0500
Received: from qmta02.emeryville.ca.mail.comcast.net ([76.96.30.24]:42653 "EHLO
	qmta02.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754067Ab3LCXiE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 18:38:04 -0500
Message-Id: <20131203233249.617496852@linux.com>
User-Agent: quilt/0.60-1
Date: Tue, 03 Dec 2013 17:32:41 -0600
From: Christoph Lameter <cl@linux.com>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linuxfoundation.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        James Hogan <james.hogan@imgtec.com>
Subject: [PATCH 09/41] drivers/clocksource: Replace __get_cpu_var used for address calculation
References: <20131203233232.928771708@linux.com>
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
 

