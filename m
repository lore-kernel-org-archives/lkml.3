Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755419AbaBGNSH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 08:18:07 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41541 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754382AbaBGLsY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 06:48:24 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 035/233] Revert "ACPI: Add BayTrail SoC GPIO and LPSS ACPI IDs"
Date: Fri,  7 Feb 2014 11:44:14 +0000
Message-Id: <1391773652-25214-36-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
References: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>

commit 2b844ba79f4a114bd228ad6fee040ffd99a0963d upstream.

This reverts commit f6308b36c411 (ACPI: Add BayTrail SoC GPIO and LPSS
ACPI IDs), because it causes the Alan Cox' ASUS T100TA to "crash and
burn" during boot if the Baytrail pinctrl driver is compiled in.

Fixes: f6308b36c411 (ACPI: Add BayTrail SoC GPIO and LPSS ACPI IDs)
Reported-by: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Requested-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/acpi/acpi_lpss.c           | 1 -
 drivers/pinctrl/pinctrl-baytrail.c | 1 -
 2 files changed, 2 deletions(-)

diff --git a/drivers/acpi/acpi_lpss.c b/drivers/acpi/acpi_lpss.c
index ab19263..fb78bb9 100644
--- a/drivers/acpi/acpi_lpss.c
+++ b/drivers/acpi/acpi_lpss.c
@@ -156,7 +156,6 @@ static const struct acpi_device_id acpi_lpss_device_ids[] = {
 	{ "80860F14", (unsigned long)&byt_sdio_dev_desc },
 	{ "80860F41", (unsigned long)&byt_i2c_dev_desc },
 	{ "INT33B2", },
-	{ "INT33FC", },
 
 	{ }
 };
diff --git a/drivers/pinctrl/pinctrl-baytrail.c b/drivers/pinctrl/pinctrl-baytrail.c
index 9041a6e..e9d735d 100644
--- a/drivers/pinctrl/pinctrl-baytrail.c
+++ b/drivers/pinctrl/pinctrl-baytrail.c
@@ -508,7 +508,6 @@ static const struct dev_pm_ops byt_gpio_pm_ops = {
 
 static const struct acpi_device_id byt_gpio_acpi_match[] = {
 	{ "INT33B2", 0 },
-	{ "INT33FC", 0 },
 	{ }
 };
 MODULE_DEVICE_TABLE(acpi, byt_gpio_acpi_match);
-- 
1.8.3.2

