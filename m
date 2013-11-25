Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753372Ab3KYWQ0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 17:16:26 -0500
Received: from mga09.intel.com ([134.134.136.24]:41107 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751005Ab3KYWQX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 17:16:23 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,770,1378882800"; 
   d="scan'208";a="441646064"
From: Paul Drews <paul.drews@intel.com>
To: lenb@kernel.org, rjw@rjwysocki.net, linus.walleij@linaro.org,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Paul Drews <paul.drews@intel.com>
Subject: [PATCH] acpi: Add BayTrail SoC GPIO and LPSS ACPI IDs
Date: Mon, 25 Nov 2013 14:15:55 -0800
Message-Id: <1385417755-21776-1-git-send-email-paul.drews@intel.com>
X-Mailer: git-send-email 1.7.11.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds the new ACPI ID (INT33FC) for the BayTrail GPIO
banks as seen on a BayTrail M System-On-Chip platform.  This
ACPI ID is used by the BayTrail GPIO (pinctrl) driver to
manage the Low Power Subsystem (LPSS).

Signed-off-by: Paul Drews <paul.drews@intel.com>
---
 drivers/acpi/acpi_lpss.c           | 1 +
 drivers/pinctrl/pinctrl-baytrail.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/acpi/acpi_lpss.c b/drivers/acpi/acpi_lpss.c
index 6745fe1..e603905 100644
--- a/drivers/acpi/acpi_lpss.c
+++ b/drivers/acpi/acpi_lpss.c
@@ -162,6 +162,7 @@ static const struct acpi_device_id acpi_lpss_device_ids[] = {
 	{ "80860F14", (unsigned long)&byt_sdio_dev_desc },
 	{ "80860F41", (unsigned long)&byt_i2c_dev_desc },
 	{ "INT33B2", },
+	{ "INT33FC", },
 
 	{ "INT3430", (unsigned long)&lpt_dev_desc },
 	{ "INT3431", (unsigned long)&lpt_dev_desc },
diff --git a/drivers/pinctrl/pinctrl-baytrail.c b/drivers/pinctrl/pinctrl-baytrail.c
index 2832576..114f5ef 100644
--- a/drivers/pinctrl/pinctrl-baytrail.c
+++ b/drivers/pinctrl/pinctrl-baytrail.c
@@ -512,6 +512,7 @@ static const struct dev_pm_ops byt_gpio_pm_ops = {
 
 static const struct acpi_device_id byt_gpio_acpi_match[] = {
 	{ "INT33B2", 0 },
+	{ "INT33FC", 0 },
 	{ }
 };
 MODULE_DEVICE_TABLE(acpi, byt_gpio_acpi_match);
-- 
1.7.11.7

