Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752941AbaGCL7I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 07:59:08 -0400
Received: from mail-wg0-f46.google.com ([74.125.82.46]:45817 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750884AbaGCL7H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 07:59:07 -0400
From: Matthias Brugger <matthias.bgg@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, jason@lakedaemon.net, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+uevicetree@hellion.org.uk, galak@codeaurora.org,
        devicetree@vger.kernel.org, marc.zyngier@arm.com,
        david.vrabel@citrix.com, grant.likely@secretlab.ca,
        linux-arm-kernel@lists.infradead.org,
        Matthias Brugger <matthias.bgg@gmail.com>
Subject: [PATCH] irqchip: gic: Add support for cortex a7 compatible string
Date: Thu,  3 Jul 2014 13:58:52 +0200
Message-Id: <1404388732-28890-1-git-send-email-matthias.bgg@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch 0a68214b "ARM: DT: Add binding for GIC virtualization extentions (VGIC)" added
the "arm,cortex-a7-gic" compatible string, but the corresponding IRQCHIP_DECLARE
was never added to the gic driver.

To let real Cortex-A7 SoCs use it, add the necessary declaration to the device driver.

Signed-off-by: Matthias Brugger <matthias.bgg@gmail.com>
---
 drivers/irqchip/irq-gic.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/irqchip/irq-gic.c b/drivers/irqchip/irq-gic.c
index c305983..3b66369 100644
--- a/drivers/irqchip/irq-gic.c
+++ b/drivers/irqchip/irq-gic.c
@@ -1071,6 +1071,7 @@ gic_of_init(struct device_node *node, struct device_node *parent)
 }
 IRQCHIP_DECLARE(cortex_a15_gic, "arm,cortex-a15-gic", gic_of_init);
 IRQCHIP_DECLARE(cortex_a9_gic, "arm,cortex-a9-gic", gic_of_init);
+IRQCHIP_DECLARE(cortex_a7_gic, "arm,cortex-a7-gic", gic_of_init);
 IRQCHIP_DECLARE(msm_8660_qgic, "qcom,msm-8660-qgic", gic_of_init);
 IRQCHIP_DECLARE(msm_qgic2, "qcom,msm-qgic2", gic_of_init);
 
-- 
1.7.9.5

