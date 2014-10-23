Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755670AbaJWPy0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 11:54:26 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:49967 "EHLO
	mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751798AbaJWPyR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 11:54:17 -0400
X-Listener-Flag: 11101
From: Yingjoe Chen <yingjoe.chen@mediatek.com>
To: Rob Herring <robh+dt@kernel.org>, Jiang Liu <jiang.liu@linux.intel.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Matthias Brugger <matthias.bgg@gmail.com>, <arm@kernel.org>
CC: Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        Grant Likely <grant.likely@linaro.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <srv_heupstream@mediatek.com>, <yingjoe.chen@gmail.com>,
        <hc.yen@mediatek.com>, <eddie.huang@mediatek.com>,
        <nathan.chung@mediatek.com>, <yh.chen@mediatek.com>
Subject: [PATCH v4 1/7] irqdomain: Fix irq_domain_alloc_irqs return check.
Date: Thu, 23 Oct 2014 23:53:09 +0800
Message-ID: <1414079595-26129-2-git-send-email-yingjoe.chen@mediatek.com>
X-Mailer: git-send-email 1.8.1.1.dirty
In-Reply-To: <1414079595-26129-1-git-send-email-yingjoe.chen@mediatek.com>
References: <1414079595-26129-1-git-send-email-yingjoe.chen@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK: N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change virq type from unsigned int to int. Otherwise the return value
check for irq_domain_alloc_irqs will always pass.

Signed-off-by: Yingjoe Chen <yingjoe.chen@mediatek.com>
---
 kernel/irq/irqdomain.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
index 584be46..dd8d3ab 100644
--- a/kernel/irq/irqdomain.c
+++ b/kernel/irq/irqdomain.c
@@ -469,7 +469,7 @@ unsigned int irq_create_of_mapping(struct of_phandle_args *irq_data)
 	struct irq_domain *domain;
 	irq_hw_number_t hwirq;
 	unsigned int type = IRQ_TYPE_NONE;
-	unsigned int virq;
+	int virq;
 
 	domain = irq_data->np ? irq_find_host(irq_data->np) : irq_default_domain;
 	if (!domain) {
-- 
1.8.1.1.dirty

