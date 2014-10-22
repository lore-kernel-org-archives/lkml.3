Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933438AbaJVM6T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 08:58:19 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:23967 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933049AbaJVM6S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 08:58:18 -0400
From: Jisheng Zhang <jszhang@marvell.com>
To: <tglx@linutronix.de>, <jason@lakedaemon.net>
CC: <sebastian.hesselbarth@gmail.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Jisheng Zhang <jszhang@marvell.com>
Subject: [PATCH] irqchip: dw-apb-ictl: select GENERIC_IRQ_CHIP
Date: Wed, 22 Oct 2014 20:55:24 +0800
Message-ID: <1413982524-470-1-git-send-email-jszhang@marvell.com>
X-Mailer: git-send-email 2.1.1
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.28,0.0.0000
 definitions=2014-10-22_04:2014-10-22,2014-10-22,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1402240000 definitions=main-1410220117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The dw-apb-ictl driver uses the clocksource MMIO functions.
Thus it needs to select GENERIC_IRQ_CHIP in Kconfig.

Signed-off-by: Jisheng Zhang <jszhang@marvell.com>
---
 drivers/irqchip/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/irqchip/Kconfig b/drivers/irqchip/Kconfig
index b21f12f..a925da0 100644
--- a/drivers/irqchip/Kconfig
+++ b/drivers/irqchip/Kconfig
@@ -56,6 +56,7 @@ config BRCMSTB_L2_IRQ
 
 config DW_APB_ICTL
 	bool
+	select GENERIC_IRQ_CHIP
 	select IRQ_DOMAIN
 
 config IMGPDC_IRQ
-- 
2.1.1

