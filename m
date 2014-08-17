Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752399AbaHQRjd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2014 13:39:33 -0400
Received: from qmta10.emeryville.ca.mail.comcast.net ([76.96.30.17]:45652 "EHLO
	qmta10.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751741AbaHQRaz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2014 13:30:55 -0400
Message-Id: <20140817173034.330628593@linux.com>
Date: Sun, 17 Aug 2014 12:30:32 -0500
From: Christoph Lameter <cl@linux.com>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linuxfoundation.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        James Hogan <james.hogan@imgtec.com>
Subject: [PATCH 09/35] [PATCH 09/36] drivers/clocksource: Replace __get_cpu_var used for
 address calculation
References: <20140817173023.439660246@linux.com>
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0009-drivers-clocksource-Replace-__get_cpu_var-used-for-a.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace __get_cpu_var used for address calculation with this_cpu_ptr.

Acked-by: James Hogan <james.hogan@imgtec.com>
Signed-off-by: Christoph Lameter <cl@linux.com>
---
 drivers/clocksource/metag_generic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/drivers/clocksource/metag_generic.c
===================================================================
--- linux.orig/drivers/clocksource/metag_generic.c
+++ linux/drivers/clocksource/metag_generic.c
@@ -90,7 +90,7 @@ static struct clocksource clocksource_me
 
 static irqreturn_t metag_timer_interrupt(int irq, void *dummy)
 {
-	struct clock_event_device *evt = &__get_cpu_var(local_clockevent);
+	struct clock_event_device *evt = this_cpu_ptr(&local_clockevent);
 
 	evt->event_handler(evt);
 

