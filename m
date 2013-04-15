Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753389Ab3DOKEl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 06:04:41 -0400
Received: from www.linutronix.de ([62.245.132.108]:55182 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751399Ab3DOKEk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 06:04:40 -0400
Date: Mon, 15 Apr 2013 12:04:37 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [GIT pull] irq fixes for 3.9
Message-ID: <alpine.LFD.2.02.1304151201340.21884@ionos>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
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

* Single bugfix for a wrong return value, which prevents the calling
  function to invoke the software fallback.

Thanks,

	tglx

------------------>
Abhijeet Dharmapurikar (1):
      irqchip: gic: fix irq_trigger return


 drivers/irqchip/irq-gic.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/irqchip/irq-gic.c b/drivers/irqchip/irq-gic.c
index a32e0d5..fc6aebf 100644
--- a/drivers/irqchip/irq-gic.c
+++ b/drivers/irqchip/irq-gic.c
@@ -236,7 +236,8 @@ static int gic_retrigger(struct irq_data *d)
 	if (gic_arch_extn.irq_retrigger)
 		return gic_arch_extn.irq_retrigger(d);
 
-	return -ENXIO;
+	/* the genirq layer expects 0 if we can't retrigger in hardware */
+	return 0;
 }
 
 #ifdef CONFIG_SMP
