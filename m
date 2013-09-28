Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754965Ab3I1MPb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Sep 2013 08:15:31 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:47465 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754896Ab3I1MPJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Sep 2013 08:15:09 -0400
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: lee.jones@linaro.org, sameo@linux.intel.com, sachin.kamat@linaro.org
Subject: [PATCH 5/5] mfd: omap-usb: Remove redundant of_match_ptr
Date: Sat, 28 Sep 2013 17:44:49 +0530
Message-Id: <1380370489-5488-5-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1380370489-5488-1-git-send-email-sachin.kamat@linaro.org>
References: <1380370489-5488-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The data structure of_match_ptr() protects is always compiled in.
Hence of_match_ptr() is not needed.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/mfd/omap-usb-host.c |    2 +-
 drivers/mfd/omap-usb-tll.c  |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/mfd/omap-usb-host.c b/drivers/mfd/omap-usb-host.c
index 29ee54d..1b65ffe 100644
--- a/drivers/mfd/omap-usb-host.c
+++ b/drivers/mfd/omap-usb-host.c
@@ -893,7 +893,7 @@ static struct platform_driver usbhs_omap_driver = {
 		.name		= (char *)usbhs_driver_name,
 		.owner		= THIS_MODULE,
 		.pm		= &usbhsomap_dev_pm_ops,
-		.of_match_table = of_match_ptr(usbhs_omap_dt_ids),
+		.of_match_table = usbhs_omap_dt_ids,
 	},
 	.remove		= usbhs_omap_remove,
 };
diff --git a/drivers/mfd/omap-usb-tll.c b/drivers/mfd/omap-usb-tll.c
index e59ac4c..b8f6401 100644
--- a/drivers/mfd/omap-usb-tll.c
+++ b/drivers/mfd/omap-usb-tll.c
@@ -320,7 +320,7 @@ static struct platform_driver usbtll_omap_driver = {
 	.driver = {
 		.name		= (char *)usbtll_driver_name,
 		.owner		= THIS_MODULE,
-		.of_match_table = of_match_ptr(usbtll_omap_dt_ids),
+		.of_match_table = usbtll_omap_dt_ids,
 	},
 	.probe		= usbtll_omap_probe,
 	.remove		= usbtll_omap_remove,
-- 
1.7.9.5

