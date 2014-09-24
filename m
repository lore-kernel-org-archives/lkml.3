Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753076AbaIXLUg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 07:20:36 -0400
Received: from smtp105.ord1c.emailsrvr.com ([108.166.43.105]:49503 "EHLO
	smtp105.ord1c.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750802AbaIXLUe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 07:20:34 -0400
X-Sender-Id: kiran.padwal@smartplayin.com
From: Kiran Padwal <kiran.padwal@smartplayin.com>
To: balbi@ti.com, gregkh@linuxfoundation.org
Cc: linux-usb@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        Kiran Padwal <kiran.padwal@smartplayin.com>
Subject: [PATCH] USB: Remove .owner field for driver
Date: Wed, 24 Sep 2014 16:48:14 +0530
Message-Id: <1411557494-32535-1-git-send-email-kiran.padwal@smartplayin.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no need to init .owner field.

Based on the patch from Peter Griffin <peter.griffin@linaro.org>
"mmc: remove .owner field for drivers using module_platform_driver"

This patch removes the superflous .owner field for drivers which
use the module_platform_driver API, as this is overriden in
platform_driver_register anyway."

Signed-off-by: Kiran Padwal <kiran.padwal@smartplayin.com>
---
 drivers/usb/dwc3/dwc3-keystone.c |    1 -
 drivers/usb/dwc3/dwc3-qcom.c     |    1 -
 drivers/usb/phy/phy-msm-usb.c    |    1 -
 3 files changed, 3 deletions(-)

diff --git a/drivers/usb/dwc3/dwc3-keystone.c b/drivers/usb/dwc3/dwc3-keystone.c
index 1fad161..7ec8495 100644
--- a/drivers/usb/dwc3/dwc3-keystone.c
+++ b/drivers/usb/dwc3/dwc3-keystone.c
@@ -189,7 +189,6 @@ static struct platform_driver kdwc3_driver = {
 	.remove		= kdwc3_remove,
 	.driver		= {
 		.name	= "keystone-dwc3",
-		.owner	        = THIS_MODULE,
 		.of_match_table	= kdwc3_of_match,
 	},
 };
diff --git a/drivers/usb/dwc3/dwc3-qcom.c b/drivers/usb/dwc3/dwc3-qcom.c
index 611f8e7..8c2e8ee 100644
--- a/drivers/usb/dwc3/dwc3-qcom.c
+++ b/drivers/usb/dwc3/dwc3-qcom.c
@@ -118,7 +118,6 @@ static struct platform_driver dwc3_qcom_driver = {
 	.remove		= dwc3_qcom_remove,
 	.driver		= {
 		.name	= "qcom-dwc3",
-		.owner	= THIS_MODULE,
 		.of_match_table	= of_dwc3_match,
 	},
 };
diff --git a/drivers/usb/phy/phy-msm-usb.c b/drivers/usb/phy/phy-msm-usb.c
index 7bb48af..7843ef7 100644
--- a/drivers/usb/phy/phy-msm-usb.c
+++ b/drivers/usb/phy/phy-msm-usb.c
@@ -1841,7 +1841,6 @@ static struct platform_driver msm_otg_driver = {
 	.remove = msm_otg_remove,
 	.driver = {
 		.name = DRIVER_NAME,
-		.owner = THIS_MODULE,
 		.pm = &msm_otg_dev_pm_ops,
 		.of_match_table = msm_otg_dt_match,
 	},
-- 
1.7.9.5

