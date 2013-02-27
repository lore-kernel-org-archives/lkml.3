Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934053Ab3B0Atb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 19:49:31 -0500
Received: from nasmtp01.atmel.com ([192.199.1.245]:62735 "EHLO
	DVREDG01.corp.atmel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932924Ab3B0At3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 19:49:29 -0500
From: Wenyou Yang <wenyou.yang@atmel.com>
To: <linux-arm-kernel@lists.infradead.org>
CC: <grant.likely@secretlab.ca>, <nicolas.ferre@atmel.com>,
        <plagnioj@jcrosoft.com>, <richard.genoud@gmail.com>,
        <JM.Lin@atmel.com>, <wenyou.yang@atmel.com>,
        <spi-devel-general@lists.sourceforge.net>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH Resend v5 12/16] spi/spi-atmel: add pinctrl support for atmel spi
Date: Wed, 27 Feb 2013 08:47:09 +0800
Message-ID: <1361926029-12518-1-git-send-email-wenyou.yang@atmel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1361925297-11854-1-git-send-email-wenyou.yang@atmel.com>
References: <1361925297-11854-1-git-send-email-wenyou.yang@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Wenyou Yang <wenyou.yang@atmel.com>
Cc: spi-devel-general@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org
---
 drivers/spi/spi-atmel.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/spi/spi-atmel.c b/drivers/spi/spi-atmel.c
index 00ca85f..0ed3e1a 100644
--- a/drivers/spi/spi-atmel.c
+++ b/drivers/spi/spi-atmel.c
@@ -23,6 +23,7 @@
 #include <linux/platform_data/atmel.h>
 #include <linux/platform_data/dma-atmel.h>
 #include <linux/of.h>
+#include <linux/pinctrl/consumer.h>
 
 #include <asm/io.h>
 #include <asm/gpio.h>
@@ -1503,11 +1504,18 @@ static int atmel_spi_probe(struct platform_device *pdev)
 	int			ret;
 	struct spi_master	*master;
 	struct atmel_spi	*as;
+	struct pinctrl		*pinctrl;
 
 	regs = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!regs)
 		return -ENXIO;
 
+	pinctrl = devm_pinctrl_get_select_default(&pdev->dev);
+	if (IS_ERR(pinctrl)) {
+		dev_err(&pdev->dev, "Failed to request pinctrl\n");
+		return PTR_ERR(pinctrl);
+	}
+
 	irq = platform_get_irq(pdev, 0);
 	if (irq < 0)
 		return irq;
-- 
1.7.9.5

