Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754922AbaGZTXW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 15:23:22 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34631 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754456AbaGZTXN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 15:23:13 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Jason Cooper <jason@lakedaemon.net>
Subject: [PATCH 3.15 083/109] irqchip: gic: Add support for cortex a7 compatible string
Date: Sat, 26 Jul 2014 12:02:45 -0700
Message-Id: <20140726190226.365065411@linuxfoundation.org>
X-Mailer: git-send-email 2.0.2
In-Reply-To: <20140726190223.834037485@linuxfoundation.org>
References: <20140726190223.834037485@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/irqchip/irq-gic.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/irqchip/irq-gic.c
+++ b/drivers/irqchip/irq-gic.c
@@ -1073,6 +1073,7 @@ gic_of_init(struct device_node *node, st
 }
 IRQCHIP_DECLARE(cortex_a15_gic, "arm,cortex-a15-gic", gic_of_init);
 IRQCHIP_DECLARE(cortex_a9_gic, "arm,cortex-a9-gic", gic_of_init);
+IRQCHIP_DECLARE(cortex_a7_gic, "arm,cortex-a7-gic", gic_of_init);
 IRQCHIP_DECLARE(msm_8660_qgic, "qcom,msm-8660-qgic", gic_of_init);
 IRQCHIP_DECLARE(msm_qgic2, "qcom,msm-qgic2", gic_of_init);
 


