Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754851AbaG3M3P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 08:29:15 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:36734 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752937AbaG3MPd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 08:15:33 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Matthias Brugger <matthias.bgg@gmail.com>,
        Jason Cooper <jason@lakedaemon.net>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 61/94] irqchip: gic: Add support for cortex a7 compatible string
Date: Wed, 30 Jul 2014 14:14:50 +0200
Message-Id: <26edd8ddfd1a9fa39fcfe329e39d9675dfe69551.1406722270.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <e43bbc2c2b44d8f0bd0b7f65d6fd50ef738c57aa.1406722270.git.jslaby@suse.cz>
References: <e43bbc2c2b44d8f0bd0b7f65d6fd50ef738c57aa.1406722270.git.jslaby@suse.cz>
In-Reply-To: <cover.1406722269.git.jslaby@suse.cz>
References: <cover.1406722269.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matthias Brugger <matthias.bgg@gmail.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit a97e8027b1d28eafe6bafe062556c1ec926a49c6 upstream.

Patch 0a68214b "ARM: DT: Add binding for GIC virtualization extentions (VGIC)" added
the "arm,cortex-a7-gic" compatible string, but the corresponding IRQCHIP_DECLARE
was never added to the gic driver.

To let real Cortex-A7 SoCs use it, add the necessary declaration to the device driver.

Signed-off-by: Matthias Brugger <matthias.bgg@gmail.com>
Link: https://lkml.kernel.org/r/1404388732-28890-1-git-send-email-matthias.bgg@gmail.com
Fixes: 0a68214b76ca ("ARM: DT: Add binding for GIC virtualization extentions (VGIC)")
Signed-off-by: Jason Cooper <jason@lakedaemon.net>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/irqchip/irq-gic.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/irqchip/irq-gic.c b/drivers/irqchip/irq-gic.c
index 86df97f6fd27..36fcc1b6264e 100644
--- a/drivers/irqchip/irq-gic.c
+++ b/drivers/irqchip/irq-gic.c
@@ -864,6 +864,7 @@ int __init gic_of_init(struct device_node *node, struct device_node *parent)
 }
 IRQCHIP_DECLARE(cortex_a15_gic, "arm,cortex-a15-gic", gic_of_init);
 IRQCHIP_DECLARE(cortex_a9_gic, "arm,cortex-a9-gic", gic_of_init);
+IRQCHIP_DECLARE(cortex_a7_gic, "arm,cortex-a7-gic", gic_of_init);
 IRQCHIP_DECLARE(msm_8660_qgic, "qcom,msm-8660-qgic", gic_of_init);
 IRQCHIP_DECLARE(msm_qgic2, "qcom,msm-qgic2", gic_of_init);
 
-- 
2.0.1

