Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933615AbaFLL43 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 07:56:29 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:58203 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933473AbaFLL4V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 07:56:21 -0400
From: Sricharan R <r.sricharan@ti.com>
To: <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <tony@atomide.com>, <santosh.shilimkar@ti.com>, <nm@ti.com>,
        <rnayak@ti.com>, <linux@arm.linux.org.uk>, <r.sricharan@ti.com>,
        <tglx@linutronix.de>, <jason@lakedaemon.net>
Subject: [PATCH V2 06/19] irqchip: crossbar: remove IS_ERR_VALUE check
Date: Thu, 12 Jun 2014 17:23:14 +0530
Message-ID: <1402574007-13987-7-git-send-email-r.sricharan@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1402574007-13987-1-git-send-email-r.sricharan@ti.com>
References: <1402574007-13987-1-git-send-email-r.sricharan@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nishanth Menon <nm@ti.com>

IS_ERR_VALUE makes sense only *if* there could be valid values in
negative error range. But in the cases that we do use it, there is no
such case. Just remove the same.

Signed-off-by: Nishanth Menon <nm@ti.com>
---
 drivers/irqchip/irq-crossbar.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/irqchip/irq-crossbar.c b/drivers/irqchip/irq-crossbar.c
index de021638..c5415ae 100644
--- a/drivers/irqchip/irq-crossbar.c
+++ b/drivers/irqchip/irq-crossbar.c
@@ -110,15 +110,15 @@ static int crossbar_domain_xlate(struct irq_domain *d,
 				 unsigned long *out_hwirq,
 				 unsigned int *out_type)
 {
-	unsigned long ret;
+	int ret;
 
 	ret = get_prev_map_irq(intspec[1]);
-	if (!IS_ERR_VALUE(ret))
+	if (ret >= 0)
 		goto found;
 
 	ret = allocate_free_irq(intspec[1]);
 
-	if (IS_ERR_VALUE(ret))
+	if (ret < 0)
 		return ret;
 
 found:
-- 
1.7.9.5

