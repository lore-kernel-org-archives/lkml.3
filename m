Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753076AbaHSOVt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 10:21:49 -0400
Received: from mga11.intel.com ([192.55.52.93]:28680 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752158AbaHSOVs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 10:21:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,894,1400050800"; 
   d="scan'208";a="578773117"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Alan Cox <alan@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        linux-pwm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] pwm: lpss: Add ACPI and PCI IDs for Intel Braswell
Date: Tue, 19 Aug 2014 17:18:29 +0300
Message-Id: <1408457909-29611-1-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

This is pretty much the same as Baytrail PWM. Only difference is that the
input clock runs on different frequency.

Signed-off-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 drivers/pwm/pwm-lpss.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/pwm/pwm-lpss.c b/drivers/pwm/pwm-lpss.c
index 4df994f72d96..d04eee7aa967 100644
--- a/drivers/pwm/pwm-lpss.c
+++ b/drivers/pwm/pwm-lpss.c
@@ -48,6 +48,11 @@ static const struct pwm_lpss_boardinfo byt_info = {
 	25000000
 };
 
+/* Braswell */
+static const struct pwm_lpss_boardinfo bsw_info = {
+	19200000
+};
+
 static inline struct pwm_lpss_chip *to_lpwm(struct pwm_chip *chip)
 {
 	return container_of(chip, struct pwm_lpss_chip, chip);
@@ -189,6 +194,8 @@ static void pwm_lpss_remove_pci(struct pci_dev *pdev)
 static struct pci_device_id pwm_lpss_pci_ids[] = {
 	{ PCI_VDEVICE(INTEL, 0x0f08), (unsigned long)&byt_info},
 	{ PCI_VDEVICE(INTEL, 0x0f09), (unsigned long)&byt_info},
+	{ PCI_VDEVICE(INTEL, 0x2288), (unsigned long)&bsw_info},
+	{ PCI_VDEVICE(INTEL, 0x2289), (unsigned long)&bsw_info},
 	{ },
 };
 MODULE_DEVICE_TABLE(pci, pwm_lpss_pci_ids);
@@ -231,6 +238,7 @@ static int pwm_lpss_remove_platform(struct platform_device *pdev)
 
 static const struct acpi_device_id pwm_lpss_acpi_match[] = {
 	{ "80860F09", (unsigned long)&byt_info },
+	{ "80862288", (unsigned long)&bsw_info },
 	{ },
 };
 MODULE_DEVICE_TABLE(acpi, pwm_lpss_acpi_match);
-- 
2.1.0

