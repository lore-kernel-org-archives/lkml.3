Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754059AbaIWGhx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 02:37:53 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:17875 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753097AbaIWGhv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 02:37:51 -0400
From: Jisheng Zhang <jszhang@marvell.com>
To: <tglx@linutronix.de>, <jason@lakedaemon.net>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Jisheng Zhang <jszhang@marvell.com>
Subject: [PATCH 1/3] irqchip: dw-apb-ictl: always use use {readl|writel}_relaxed
Date: Tue, 23 Sep 2014 14:34:58 +0800
Message-ID: <1411454100-6814-2-git-send-email-jszhang@marvell.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1411454100-6814-1-git-send-email-jszhang@marvell.com>
References: <1411454100-6814-1-git-send-email-jszhang@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.28,0.0.0000
 definitions=2014-09-23_03:2014-09-23,2014-09-23,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1402240000 definitions=main-1409230074
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

relaxed version and non-relaxed version are mixed, this patch always
use the relaxed version to unify the memory access usage.

Signed-off-by: Jisheng Zhang <jszhang@marvell.com>
---
 drivers/irqchip/irq-dw-apb-ictl.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/irqchip/irq-dw-apb-ictl.c b/drivers/irqchip/irq-dw-apb-ictl.c
index 31e231e..fcc3385 100644
--- a/drivers/irqchip/irq-dw-apb-ictl.c
+++ b/drivers/irqchip/irq-dw-apb-ictl.c
@@ -94,16 +94,16 @@ static int __init dw_apb_ictl_init(struct device_node *np,
 	 */
 
 	/* mask and enable all interrupts */
-	writel(~0, iobase + APB_INT_MASK_L);
-	writel(~0, iobase + APB_INT_MASK_H);
-	writel(~0, iobase + APB_INT_ENABLE_L);
-	writel(~0, iobase + APB_INT_ENABLE_H);
+	writel_relaxed(~0, iobase + APB_INT_MASK_L);
+	writel_relaxed(~0, iobase + APB_INT_MASK_H);
+	writel_relaxed(~0, iobase + APB_INT_ENABLE_L);
+	writel_relaxed(~0, iobase + APB_INT_ENABLE_H);
 
-	reg = readl(iobase + APB_INT_ENABLE_H);
+	reg = readl_relaxed(iobase + APB_INT_ENABLE_H);
 	if (reg)
 		nrirqs = 32 + fls(reg);
 	else
-		nrirqs = fls(readl(iobase + APB_INT_ENABLE_L));
+		nrirqs = fls(readl_relaxed(iobase + APB_INT_ENABLE_L));
 
 	domain = irq_domain_add_linear(np, nrirqs,
 				       &irq_generic_chip_ops, NULL);
-- 
2.1.0

