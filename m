Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756271Ab3J2Op3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 10:45:29 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:44634 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752292Ab3J2Op2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 10:45:28 -0400
From: Vincent Donnefort <vdonnefort@gmail.com>
To: tglx@linutronix.de, linux-kernel@vger.kernel.org,
        gregory.clement@free-electrons.com
Cc: Vincent Donnefort <vdonnefort@gmail.com>
Subject: [PATCH] irqchip: aramda370-xp: fix compilation warning
Date: Tue, 29 Oct 2013 15:44:45 +0100
Message-Id: <1383057885-10101-1-git-send-email-vdonnefort@lacie.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vincent Donnefort <vdonnefort@gmail.com>

Fix the following compilation warning:
  drivers/irqchip/irq-armada-370-xp.c:55:23: warning: 'irq_controller_lock' defined but not used [-Wunused-variable]

Signed-off-by: Vincent Donnefort <vdonnefort@gmail.com>

diff --git a/drivers/irqchip/irq-armada-370-xp.c b/drivers/irqchip/irq-armada-370-xp.c
index bb328a3..75c3141 100644
--- a/drivers/irqchip/irq-armada-370-xp.c
+++ b/drivers/irqchip/irq-armada-370-xp.c
@@ -52,7 +52,9 @@
 #define IPI_DOORBELL_END                        (8)
 #define IPI_DOORBELL_MASK                       0xFF
 
+#ifdef CONFIG_SMP
 static DEFINE_RAW_SPINLOCK(irq_controller_lock);
+#endif
 
 static void __iomem *per_cpu_int_base;
 static void __iomem *main_int_base;
-- 
1.8.3.2

