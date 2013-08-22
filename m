Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754045Ab3HVHzR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 03:55:17 -0400
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:45698 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753843Ab3HVHzP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 03:55:15 -0400
Message-ID: <5215C3DC.7060705@linux.vnet.ibm.com>
Date: Thu, 22 Aug 2013 15:55:08 +0800
From: Michael wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130804 Thunderbird/17.0.8
MIME-Version: 1.0
To: open list <linux-kernel@vger.kernel.org>
CC: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 06/11] sched/cleanup: refine __setup_irq()
References: <5215C233.9060907@linux.vnet.ibm.com>
In-Reply-To: <5215C233.9060907@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13082207-3864-0000-0000-000009B4C38C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Refine the __setup_irq() to save few lines.

CC: Thomas Gleixner <tglx@linutronix.de>
CC: Ingo Molnar <mingo@redhat.com>
CC: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Michael Wang <wangyun@linux.vnet.ibm.com>
---
 kernel/irq/manage.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 514bcfd..46941e7 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -933,10 +933,8 @@ __setup_irq(unsigned int irq, struct irq_desc *desc, struct irqaction *new)
 		 * dummy function which warns when called.
 		 */
 		new->handler = irq_nested_primary_handler;
-	} else {
-		if (irq_settings_can_thread(desc))
-			irq_setup_forced_threading(new);
-	}
+	} else if (irq_settings_can_thread(desc))
+		irq_setup_forced_threading(new);
 
 	/*
 	 * Create a handler thread when a thread function is supplied
-- 
1.7.9.5

