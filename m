Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933975AbaFLL7t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 07:59:49 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:60479 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933675AbaFLL4i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 07:56:38 -0400
From: Sricharan R <r.sricharan@ti.com>
To: <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <tony@atomide.com>, <santosh.shilimkar@ti.com>, <nm@ti.com>,
        <rnayak@ti.com>, <linux@arm.linux.org.uk>, <r.sricharan@ti.com>,
        <tglx@linutronix.de>, <jason@lakedaemon.net>
Subject: [PATCH V2 10/19] irqchip: crossbar: DRA7: Fix unused crossbar list
Date: Thu, 12 Jun 2014 17:23:18 +0530
Message-ID: <1402574007-13987-11-git-send-email-r.sricharan@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1402574007-13987-1-git-send-email-r.sricharan@ti.com>
References: <1402574007-13987-1-git-send-email-r.sricharan@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rajendra Nayak <rnayak@ti.com>

On DRA7 compatible IRQ crossbar, IRQ 10 default mapped to L3_APP_IRQ,
IRQ133 is default mapped to NMI pin, 139 and 140 crossbars are
unused(not routed). Mark these as unused crossbar IRQs.

Technical Reference Manual documentation update expected
DRA72x-TRMINC00067 is being used to track the update.

Reported-by: Nishanth Menon <nm@ti.com>
Reported-by: Sricharan R <r.sricharan@ti.com>
Reported-by: Suman Anna <s-anna@ti.com>
Signed-off-by: Rajendra Nayak <rnayak@ti.com>
---
 drivers/irqchip/irq-crossbar.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/irqchip/irq-crossbar.c b/drivers/irqchip/irq-crossbar.c
index 7d4db07..42a2e62 100644
--- a/drivers/irqchip/irq-crossbar.c
+++ b/drivers/irqchip/irq-crossbar.c
@@ -253,8 +253,8 @@ err1:
 	return -ENOMEM;
 }
 
-/* irq number 10 cannot be used because of hw bug */
-static int dra_irqs_unused[] = { 10 };
+/* irq number 10,133,139 and 140 cannot be used because of hw bug */
+static int dra_irqs_unused[] = { 10 , 133, 139, 140 };
 static struct crossbar_data cb_dra_data = { dra_irqs_unused,
 				     ARRAY_SIZE(dra_irqs_unused), 0 };
 
-- 
1.7.9.5

