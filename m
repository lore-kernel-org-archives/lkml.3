Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753504AbaIVJLM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 05:11:12 -0400
Received: from top.free-electrons.com ([176.31.233.9]:46932 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753046AbaIVJLG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 05:11:06 -0400
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Andrew Victor <linux@maxim.org.za>,
        Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Boris BREZILLON <boris.brezillon@free-electrons.com>
Subject: [PATCH v5 4/9] rtc: at91sam9: add DT support
Date: Mon, 22 Sep 2014 11:10:53 +0200
Message-Id: <1411377058-26155-5-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1411377058-26155-1-git-send-email-boris.brezillon@free-electrons.com>
References: <1411377058-26155-1-git-send-email-boris.brezillon@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add of_match_table to the existing driver so that rtc nodes defined in at91
DTs can be attached to this driver.

Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
Acked-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 drivers/rtc/rtc-at91sam9.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/rtc/rtc-at91sam9.c b/drivers/rtc/rtc-at91sam9.c
index 38a2693..d72c34d 100644
--- a/drivers/rtc/rtc-at91sam9.c
+++ b/drivers/rtc/rtc-at91sam9.c
@@ -445,6 +445,14 @@ static int at91_rtc_resume(struct device *dev)
 
 static SIMPLE_DEV_PM_OPS(at91_rtc_pm_ops, at91_rtc_suspend, at91_rtc_resume);
 
+#ifdef CONFIG_OF
+static const struct of_device_id at91_rtc_dt_ids[] = {
+	{ .compatible = "atmel,at91sam9260-rtt" },
+	{ /* sentinel */ }
+};
+MODULE_DEVICE_TABLE(of, at91_rtc_dt_ids);
+#endif
+
 static struct platform_driver at91_rtc_driver = {
 	.probe		= at91_rtc_probe,
 	.remove		= at91_rtc_remove,
@@ -453,6 +461,7 @@ static struct platform_driver at91_rtc_driver = {
 		.name	= "rtc-at91sam9",
 		.owner	= THIS_MODULE,
 		.pm	= &at91_rtc_pm_ops,
+		.of_match_table = of_match_ptr(at91_rtc_dt_ids),
 	},
 };
 
-- 
1.9.1

