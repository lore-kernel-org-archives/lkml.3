Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755795AbbAZKpN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 05:45:13 -0500
Received: from terminus.zytor.com ([198.137.202.10]:39857 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755748AbbAZKpG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 05:45:06 -0500
Date: Mon, 26 Jan 2015 02:43:47 -0800
From: tip-bot for Yingjoe Chen <tipbot@zytor.com>
Message-ID: <tip-cdb647a772e9def47594ff8ce7acf47f4d257b2e@git.kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, tglx@linutronix.de,
        ijc+devicetree@hellion.org.uk, jason@lakedaemon.net,
        pawel.moll@arm.com, peter.maydell@linaro.org, robh+dt@kernel.org,
        eddie.huang@mediatek.com, matthias.bgg@gmail.com, marc.zyngier@arm.com,
        broonie@linaro.org, olof@lixom.net, srv_heupstream@mediatek.com,
        rrichter@cavium.com, galak@codeaurora.org, mingo@kernel.org,
        kernel@pengutronix.de, mark.rutland@arm.com, yingjoe.chen@mediatek.com,
        hpa@zytor.com, will.deacon@arm.com, linux-kernel@vger.kernel.org,
        catalin.marinas@arm.com
Reply-To: linux-kernel@vger.kernel.org, catalin.marinas@arm.com,
        will.deacon@arm.com, mark.rutland@arm.com, yingjoe.chen@mediatek.com,
        hpa@zytor.com, kernel@pengutronix.de, mingo@kernel.org,
        srv_heupstream@mediatek.com, olof@lixom.net, broonie@linaro.org,
        galak@codeaurora.org, rrichter@cavium.com, robh+dt@kernel.org,
        peter.maydell@linaro.org, matthias.bgg@gmail.com, marc.zyngier@arm.com,
        eddie.huang@mediatek.com, ijc+devicetree@hellion.org.uk,
        jason@lakedaemon.net, pawel.moll@arm.com,
        linux-arm-kernel@lists.infradead.org, tglx@linutronix.de
In-Reply-To: <1421054073-43468-3-git-send-email-eddie.huang@mediatek.com>
References: <1421054073-43468-3-git-send-email-eddie.huang@mediatek.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/core] irqchip: mtk-sysirq:
  Get irq number from register resource size
Git-Commit-ID: cdb647a772e9def47594ff8ce7acf47f4d257b2e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  cdb647a772e9def47594ff8ce7acf47f4d257b2e
Gitweb:     http://git.kernel.org/tip/cdb647a772e9def47594ff8ce7acf47f4d257b2e
Author:     Yingjoe Chen <yingjoe.chen@mediatek.com>
AuthorDate: Mon, 12 Jan 2015 17:14:31 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 26 Jan 2015 11:38:22 +0100

irqchip: mtk-sysirq: Get irq number from register resource size

Originally mtk-sysirq hardcoded supported irq number to 224. This
was fine since all SoCs before support the same number of irqs for
intpol.

However MT8173 intpol support 32 more irq pins, changes to get
irq number from register resource size to suppor MT8173 properly.

Signed-off-by: Yingjoe Chen <yingjoe.chen@mediatek.com>
Signed-off-by: Eddie Huang <eddie.huang@mediatek.com>
Cc: <srv_heupstream@mediatek.com>
Cc: Pawel Moll <pawel.moll@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Ian Campbell <ijc+devicetree@hellion.org.uk>
Cc: Kumar Gala <galak@codeaurora.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Olof  Johansson <olof@lixom.net>
Cc: Robert Richter <rrichter@cavium.com>
Cc: Mark Brown <broonie@linaro.org>
Cc: <linux-arm-kernel@lists.infradead.org>
Cc: Sascha Hauer <kernel@pengutronix.de>
Cc: <marc.zyngier@arm.com>
Cc: <peter.maydell@linaro.org>
Cc: Matthias Brugger <matthias.bgg@gmail.com>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: Jason Cooper <jason@lakedaemon.net>
Link: http://lkml.kernel.org/r/1421054073-43468-3-git-send-email-eddie.huang@mediatek.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 drivers/irqchip/irq-mtk-sysirq.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/irqchip/irq-mtk-sysirq.c b/drivers/irqchip/irq-mtk-sysirq.c
index 0b0d2c0..eaf0a71 100644
--- a/drivers/irqchip/irq-mtk-sysirq.c
+++ b/drivers/irqchip/irq-mtk-sysirq.c
@@ -23,8 +23,6 @@
 
 #include "irqchip.h"
 
-#define MT6577_SYS_INTPOL_NUM	(224)
-
 struct mtk_sysirq_chip_data {
 	spinlock_t lock;
 	void __iomem *intpol_base;
@@ -124,7 +122,8 @@ static int __init mtk_sysirq_of_init(struct device_node *node,
 {
 	struct irq_domain *domain, *domain_parent;
 	struct mtk_sysirq_chip_data *chip_data;
-	int ret = 0;
+	int ret, size, intpol_num;
+	struct resource res;
 
 	domain_parent = irq_find_host(parent);
 	if (!domain_parent) {
@@ -132,19 +131,24 @@ static int __init mtk_sysirq_of_init(struct device_node *node,
 		return -EINVAL;
 	}
 
+	ret = of_address_to_resource(node, 0, &res);
+	if (ret)
+		return ret;
+
 	chip_data = kzalloc(sizeof(*chip_data), GFP_KERNEL);
 	if (!chip_data)
 		return -ENOMEM;
 
-	chip_data->intpol_base = of_io_request_and_map(node, 0, "intpol");
-	if (IS_ERR(chip_data->intpol_base)) {
+	size = resource_size(&res);
+	intpol_num = size * 8;
+	chip_data->intpol_base = ioremap(res.start, size);
+	if (!chip_data->intpol_base) {
 		pr_err("mtk_sysirq: unable to map sysirq register\n");
 		ret = PTR_ERR(chip_data->intpol_base);
 		goto out_free;
 	}
 
-	domain = irq_domain_add_hierarchy(domain_parent, 0,
-					  MT6577_SYS_INTPOL_NUM, node,
+	domain = irq_domain_add_hierarchy(domain_parent, 0, intpol_num, node,
 					  &sysirq_domain_ops, chip_data);
 	if (!domain) {
 		ret = -ENOMEM;
