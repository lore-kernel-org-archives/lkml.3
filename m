Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752915AbaCFKpM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 05:45:12 -0500
Received: from www.linutronix.de ([62.245.132.108]:51775 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751791AbaCFKpG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 05:45:06 -0500
Date: Thu, 6 Mar 2014 11:45:11 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>
Subject: [GIT Pull] irq updates for 3.14
Message-ID: <alpine.DEB.2.02.1403061142130.18573@ionos.tec.linutronix.de>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull the latest irq-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git irq-urgent-for-linus

This contains:
     * A bugfix for a long standing waitqueue race
     * A trivial fix for a missing include

Thanks,

	tglx

------------------>
Chuansheng Liu (1):
      genirq: Remove racy waitqueue_active check

Rashika Kheria (1):
      genirq: Include missing header file in irqdomain.c


 kernel/irq/irqdomain.c |    1 +
 kernel/irq/manage.c    |    3 +--
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
index cf68bb3..f140337 100644
--- a/kernel/irq/irqdomain.c
+++ b/kernel/irq/irqdomain.c
@@ -10,6 +10,7 @@
 #include <linux/mutex.h>
 #include <linux/of.h>
 #include <linux/of_address.h>
+#include <linux/of_irq.h>
 #include <linux/topology.h>
 #include <linux/seq_file.h>
 #include <linux/slab.h>
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 481a13c..d3bf660 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -802,8 +802,7 @@ static irqreturn_t irq_thread_fn(struct irq_desc *desc,
 
 static void wake_threads_waitq(struct irq_desc *desc)
 {
-	if (atomic_dec_and_test(&desc->threads_active) &&
-	    waitqueue_active(&desc->wait_for_threads))
+	if (atomic_dec_and_test(&desc->threads_active))
 		wake_up(&desc->wait_for_threads);
 }
 
