Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753215AbaEOP3h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 11:29:37 -0400
Received: from mga09.intel.com ([134.134.136.24]:60884 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752976AbaEOP3f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 11:29:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,1059,1389772800"; 
   d="scan'208";a="512229363"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linus Walleij <linus.walleij@linaro.org>
Cc: Jin Yao <yao.jin@intel.com>, Aubrey Li <aubrey.li@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] pinctrl: baytrail: Add back Baytrail-T ACPI ID
Date: Thu, 15 May 2014 18:28:46 +0300
Message-Id: <1400167727-20233-1-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 2.0.0.rc2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jin Yao <yao.jin@intel.com>

Now that the x86 dynamic IRQ allocation problem has been resolved with
commmit 62a08ae2a576 (genirq: x86: Ensure that dynamic irq allocation does
not conflict), we can add back Baytrail-T ACPI ID to the pinctrl driver.

This makes the driver to work on Asus T100 where it is needed for several
things like ACPI GPIO events and SD card detection.

References: https://bugzilla.kernel.org/show_bug.cgi?id=68291
Signed-off-by: Jin Yao <yao.jin@intel.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 drivers/acpi/acpi_lpss.c           | 1 +
 drivers/pinctrl/pinctrl-baytrail.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/acpi/acpi_lpss.c b/drivers/acpi/acpi_lpss.c
index 24e49a52cefb..c314d709e5a6 100644
--- a/drivers/acpi/acpi_lpss.c
+++ b/drivers/acpi/acpi_lpss.c
@@ -189,6 +189,7 @@ static const struct acpi_device_id acpi_lpss_device_ids[] = {
 	{ "80860F14", (unsigned long)&byt_sdio_dev_desc },
 	{ "80860F41", (unsigned long)&byt_i2c_dev_desc },
 	{ "INT33B2", },
+	{ "INT33FC", },
 
 	{ "INT3430", (unsigned long)&lpt_dev_desc },
 	{ "INT3431", (unsigned long)&lpt_dev_desc },
diff --git a/drivers/pinctrl/pinctrl-baytrail.c b/drivers/pinctrl/pinctrl-baytrail.c
index 6e8301f77187..447f1dc25ea6 100644
--- a/drivers/pinctrl/pinctrl-baytrail.c
+++ b/drivers/pinctrl/pinctrl-baytrail.c
@@ -572,6 +572,7 @@ static const struct dev_pm_ops byt_gpio_pm_ops = {
 
 static const struct acpi_device_id byt_gpio_acpi_match[] = {
 	{ "INT33B2", 0 },
+	{ "INT33FC", 0 },
 	{ }
 };
 MODULE_DEVICE_TABLE(acpi, byt_gpio_acpi_match);
-- 
2.0.0.rc2

