Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933651AbaLCAMa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 19:12:30 -0500
Received: from mail.kmu-office.ch ([178.209.48.109]:33419 "EHLO
	mail.kmu-office.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933398AbaLCAMY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 19:12:24 -0500
From: Stefan Agner <stefan@agner.ch>
To: shawn.guo@linaro.org, kernel@pengutronix.de, linux@arm.linux.org.uk,
        u.kleine-koenig@pengutronix.de, jason@lakedaemon.net, olof@lixom.net,
        arnd@arndb.de, daniel.lezcano@linaro.org, tglx@linutronix.de,
        mark.rutland@arm.com, pawel.moll@arm.com, robh+dt@kernel.org,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org
Cc: devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Stefan Agner <stefan@agner.ch>
Subject: [PATCH 03/12] irqchip: gic: define register_routable_domain_ops conditional
Date: Wed,  3 Dec 2014 01:12:02 +0100
Message-Id: <1417565531-4507-4-git-send-email-stefan@agner.ch>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1417565531-4507-1-git-send-email-stefan@agner.ch>
References: <1417565531-4507-1-git-send-email-stefan@agner.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The inline function register_routable_domain_ops is only usable if
CONFIG_ARM_GIC is set. Make it depend on this configuration. This
also allows other SoC interrupt controller to provide such a
function.

Signed-off-by: Stefan Agner <stefan@agner.ch>
---
 include/linux/irqchip/arm-gic.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/linux/irqchip/arm-gic.h b/include/linux/irqchip/arm-gic.h
index 13eed92..3b1baf1 100644
--- a/include/linux/irqchip/arm-gic.h
+++ b/include/linux/irqchip/arm-gic.h
@@ -111,11 +111,14 @@ int gic_get_cpu_id(unsigned int cpu);
 void gic_migrate_target(unsigned int new_cpu_id);
 unsigned long gic_get_sgir_physaddr(void);
 
+#ifdef CONFIG_ARM_GIC
 extern const struct irq_domain_ops *gic_routable_irq_domain_ops;
 static inline void __init register_routable_domain_ops
 					(const struct irq_domain_ops *ops)
 {
 	gic_routable_irq_domain_ops = ops;
 }
+#endif /* CONFIG_ARM_GIC */
+
 #endif /* __ASSEMBLY */
 #endif
-- 
2.1.3

