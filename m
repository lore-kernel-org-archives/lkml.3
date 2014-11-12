Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753233AbaKLG0A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 01:26:00 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:58986 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753120AbaKLGZ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 01:25:56 -0500
From: Jisheng Zhang <jszhang@marvell.com>
To: <tglx@linutronix.de>, <jason@lakedaemon.net>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Jisheng Zhang <jszhang@marvell.com>
Subject: [PATCH v2 2/3] irqchip: dw-apb-ictl: enable IRQ_GC_MASK_CACHE_PER_TYPE
Date: Wed, 12 Nov 2014 14:22:53 +0800
Message-ID: <1415773374-4629-3-git-send-email-jszhang@marvell.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1415773374-4629-1-git-send-email-jszhang@marvell.com>
References: <1415773374-4629-1-git-send-email-jszhang@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.13.68,1.0.28,0.0.0000
 definitions=2014-11-12_04:2014-11-11,2014-11-12,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1402240000 definitions=main-1411120057
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The irq_chip_type instances have separate mask registers, so we need to
enable IRQ_GC_MASK_CACHE_PER_TYPE to actually handle separate mask registers.

Signed-off-by: Jisheng Zhang <jszhang@marvell.com>
Acked-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
---
 drivers/irqchip/irq-dw-apb-ictl.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/irqchip/irq-dw-apb-ictl.c b/drivers/irqchip/irq-dw-apb-ictl.c
index fcc3385..c136b67 100644
--- a/drivers/irqchip/irq-dw-apb-ictl.c
+++ b/drivers/irqchip/irq-dw-apb-ictl.c
@@ -115,6 +115,7 @@ static int __init dw_apb_ictl_init(struct device_node *np,
 
 	ret = irq_alloc_domain_generic_chips(domain, 32, (nrirqs > 32) ? 2 : 1,
 					     np->name, handle_level_irq, clr, 0,
+					     IRQ_GC_MASK_CACHE_PER_TYPE |
 					     IRQ_GC_INIT_MASK_CACHE);
 	if (ret) {
 		pr_err("%s: unable to alloc irq domain gc\n", np->full_name);
-- 
2.1.3

