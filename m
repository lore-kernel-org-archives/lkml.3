Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755873AbaAMQ1Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 11:27:16 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:53486 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754258AbaAMQEI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 11:04:08 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Paul Drews <paul.drews@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 140/208] ACPI: Add BayTrail SoC GPIO and LPSS ACPI IDs
Date: Mon, 13 Jan 2014 15:59:41 +0000
Message-Id: <1389628849-1614-141-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
References: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paul Drews <paul.drews@intel.com>

commit f6308b36c411dc5afd6a6f73e6454722bfde57b7 upstream.

This adds the new ACPI ID (INT33FC) for the BayTrail GPIO
banks as seen on a BayTrail M System-On-Chip platform.  This
ACPI ID is used by the BayTrail GPIO (pinctrl) driver to
manage the Low Power Subsystem (LPSS).

Signed-off-by: Paul Drews <paul.drews@intel.com>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/acpi/acpi_lpss.c           | 1 +
 drivers/pinctrl/pinctrl-baytrail.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/acpi/acpi_lpss.c b/drivers/acpi/acpi_lpss.c
index fb78bb9..ab19263 100644
--- a/drivers/acpi/acpi_lpss.c
+++ b/drivers/acpi/acpi_lpss.c
@@ -156,6 +156,7 @@ static const struct acpi_device_id acpi_lpss_device_ids[] = {
 	{ "80860F14", (unsigned long)&byt_sdio_dev_desc },
 	{ "80860F41", (unsigned long)&byt_i2c_dev_desc },
 	{ "INT33B2", },
+	{ "INT33FC", },
 
 	{ }
 };
diff --git a/drivers/pinctrl/pinctrl-baytrail.c b/drivers/pinctrl/pinctrl-baytrail.c
index e9d735d..9041a6e 100644
--- a/drivers/pinctrl/pinctrl-baytrail.c
+++ b/drivers/pinctrl/pinctrl-baytrail.c
@@ -508,6 +508,7 @@ static const struct dev_pm_ops byt_gpio_pm_ops = {
 
 static const struct acpi_device_id byt_gpio_acpi_match[] = {
 	{ "INT33B2", 0 },
+	{ "INT33FC", 0 },
 	{ }
 };
 MODULE_DEVICE_TABLE(acpi, byt_gpio_acpi_match);
-- 
1.8.3.2

