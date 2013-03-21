Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933553Ab3CUOfT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 10:35:19 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:10550 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933448Ab3CUOfR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 10:35:17 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 21 Mar 2013 07:34:45 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <akpm@linux-foundation.org>
CC: <a.zummo@towertech.it>, <grant.likely@secretlab.ca>,
        <rtc-linux@googlegroups.com>, <linux-kernel@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>, <rob.herring@calxeda.com>,
        <linux-tegra@vger.kernel.org>, <swarren@nvidia.com>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH] rtc: palmas: add dt support
Date: Thu, 21 Mar 2013 20:02:10 +0530
Message-ID: <1363876330-26003-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add of_device_id table for Palma RTC to be enable the
driver from DT file.

The driver can be registered from DT file as:
	palmas: tps65913@58 {
		:::::::::::
		palmas_rtc {
			compatible = "ti,palmas-rtc";
			interrupt-parent = <&palmas>;
			interrupts = <8 0>;
		};
	};

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 drivers/rtc/rtc-palmas.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/drivers/rtc/rtc-palmas.c b/drivers/rtc/rtc-palmas.c
index bbc3b9e..50204d4 100644
--- a/drivers/rtc/rtc-palmas.c
+++ b/drivers/rtc/rtc-palmas.c
@@ -30,6 +30,7 @@
 #include <linux/kernel.h>
 #include <linux/mfd/palmas.h>
 #include <linux/module.h>
+#include <linux/of.h>
 #include <linux/rtc.h>
 #include <linux/types.h>
 #include <linux/platform_device.h>
@@ -316,6 +317,14 @@ static const struct dev_pm_ops palmas_rtc_pm_ops = {
 	SET_SYSTEM_SLEEP_PM_OPS(palmas_rtc_suspend, palmas_rtc_resume)
 };
 
+#ifdef CONFIG_OF
+static struct of_device_id of_palmas_rtc_match[] = {
+	{ .compatible = "ti,palmas-rtc"},
+	{ },
+};
+MODULE_DEVICE_TABLE(of, of_palmas_rtc_match);
+#endif
+
 static struct platform_driver palmas_rtc_driver = {
 	.probe		= palmas_rtc_probe,
 	.remove		= palmas_rtc_remove,
@@ -323,6 +332,7 @@ static struct platform_driver palmas_rtc_driver = {
 		.owner	= THIS_MODULE,
 		.name	= "palmas-rtc",
 		.pm	= &palmas_rtc_pm_ops,
+		.of_match_table = of_match_ptr(of_palmas_rtc_match),
 	},
 };
 
-- 
1.7.1.1

