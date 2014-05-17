Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751476AbaEQUvn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2014 16:51:43 -0400
Received: from www.linutronix.de ([62.245.132.108]:39302 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751101AbaEQUvm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2014 16:51:42 -0400
Date: Sat, 17 May 2014 22:51:53 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [GIT pll] irq updates for 3.15
Message-ID: <alpine.DEB.2.02.1405172244130.4084@ionos.tec.linutronix.de>
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

Two small updates from the irq departement:

 * Provide missing inline stub for a SMP only function

 * Add sub-maintainer for the drivers/irqchip/ part of the irq
   subsystem. YAY!

Thanks,

	tglx

------------------>
Arnd Bergmann (1):
      genirq: Provide irq_force_affinity fallback for non-SMP

Jason Cooper (1):
      MAINTAINERS: Add co-maintainer for drivers/irqchip


 MAINTAINERS               |    8 ++++++++
 include/linux/interrupt.h |    5 +++++
 2 files changed, 13 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 6bef70b..4195801 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4818,6 +4818,14 @@ L:	linux-kernel@vger.kernel.org
 S:	Maintained
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git irq/core
 F:	kernel/irq/
+
+IRQCHIP DRIVERS
+M:	Thomas Gleixner <tglx@linutronix.de>
+M:	Jason Cooper <jason@lakedaemon.net>
+L:	linux-kernel@vger.kernel.org
+S:	Maintained
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git irq/core
+T:	git git://git.infradead.org/users/jcooper/linux.git irqchip/core
 F:	drivers/irqchip/
 
 IRQ DOMAINS (IRQ NUMBER MAPPING LIBRARY)
diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index 97ac926..051c850 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -272,6 +272,11 @@ static inline int irq_set_affinity(unsigned int irq, const struct cpumask *m)
 	return -EINVAL;
 }
 
+static inline int irq_force_affinity(unsigned int irq, const struct cpumask *cpumask)
+{
+	return 0;
+}
+
 static inline int irq_can_set_affinity(unsigned int irq)
 {
 	return 0;
