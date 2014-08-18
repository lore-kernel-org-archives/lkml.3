Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754762AbaHRKI0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 06:08:26 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42438 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751933AbaHRJdl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 05:33:41 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Matthias Brugger <matthias.bgg@gmail.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 010/137] irqchip: gic: Add support for cortex a7 compatible string
Date: Mon, 18 Aug 2014 10:31:11 +0100
Message-Id: <1408354398-10226-11-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1408354398-10226-1-git-send-email-luis.henriques@canonical.com>
References: <1408354398-10226-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.15 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthias Brugger <matthias.bgg@gmail.com>

commit a97e8027b1d28eafe6bafe062556c1ec926a49c6 upstream.

Patch 0a68214b "ARM: DT: Add binding for GIC virtualization extentions (VGIC)" added
the "arm,cortex-a7-gic" compatible string, but the corresponding IRQCHIP_DECLARE
was never added to the gic driver.

To let real Cortex-A7 SoCs use it, add the necessary declaration to the device driver.

Signed-off-by: Matthias Brugger <matthias.bgg@gmail.com>
Link: https://lkml.kernel.org/r/1404388732-28890-1-git-send-email-matthias.bgg@gmail.com
Fixes: 0a68214b76ca ("ARM: DT: Add binding for GIC virtualization extentions (VGIC)")
Signed-off-by: Jason Cooper <jason@lakedaemon.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/irqchip/irq-gic.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/irqchip/irq-gic.c b/drivers/irqchip/irq-gic.c
index 0ebd24df0727..97fd4bf56f3e 100644
--- a/drivers/irqchip/irq-gic.c
+++ b/drivers/irqchip/irq-gic.c
@@ -858,6 +858,7 @@ int __init gic_of_init(struct device_node *node, struct device_node *parent)
 }
 IRQCHIP_DECLARE(cortex_a15_gic, "arm,cortex-a15-gic", gic_of_init);
 IRQCHIP_DECLARE(cortex_a9_gic, "arm,cortex-a9-gic", gic_of_init);
+IRQCHIP_DECLARE(cortex_a7_gic, "arm,cortex-a7-gic", gic_of_init);
 IRQCHIP_DECLARE(msm_8660_qgic, "qcom,msm-8660-qgic", gic_of_init);
 IRQCHIP_DECLARE(msm_qgic2, "qcom,msm-qgic2", gic_of_init);
 
-- 
1.9.1

