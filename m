Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758189Ab3J2PrB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 11:47:01 -0400
Received: from mail-qe0-f44.google.com ([209.85.128.44]:39101 "EHLO
	mail-qe0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758130Ab3J2PrA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 11:47:00 -0400
From: Vincent Donnefort <vdonnefort@gmail.com>
To: tglx@linutronix.de, linux-kernel@vger.kernel.org,
        gregory.clement@free-electrons.com
Cc: Vincent Donnefort <vdonnefort@gmail.com>
Subject: [PATCH V2] irqchip: aramda370-xp: move spinlock declaration into CONFIG_SMP section
Date: Tue, 29 Oct 2013 16:46:46 +0100
Message-Id: <1383061606-21166-1-git-send-email-vdonnefort@lacie.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <alpine.DEB.2.02.1310291601230.8257@ionos.tec.linutronix.de>
References: <alpine.DEB.2.02.1310291601230.8257@ionos.tec.linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vincent Donnefort <vdonnefort@gmail.com>

Fix the following compilation warning:
  drivers/irqchip/irq-armada-370-xp.c:55:23: warning: 'irq_controller_lock' defined but not used [-Wunused-variable]

Signed-off-by: Vincent Donnefort <vdonnefort@gmail.com>

diff --git a/drivers/irqchip/irq-armada-370-xp.c b/drivers/irqchip/irq-armada-370-xp.c
index bb328a3..63aa29b 100644
--- a/drivers/irqchip/irq-armada-370-xp.c
+++ b/drivers/irqchip/irq-armada-370-xp.c
@@ -52,8 +52,6 @@
 #define IPI_DOORBELL_END                        (8)
 #define IPI_DOORBELL_MASK                       0xFF
 
-static DEFINE_RAW_SPINLOCK(irq_controller_lock);
-
 static void __iomem *per_cpu_int_base;
 static void __iomem *main_int_base;
 static struct irq_domain *armada_370_xp_mpic_domain;
@@ -88,6 +86,8 @@ static void armada_370_xp_irq_unmask(struct irq_data *d)
 }
 
 #ifdef CONFIG_SMP
+static DEFINE_RAW_SPINLOCK(irq_controller_lock);
+
 static int armada_xp_set_affinity(struct irq_data *d,
 				  const struct cpumask *mask_val, bool force)
 {
-- 
1.8.3.2

