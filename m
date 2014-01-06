Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758187AbaAGAEi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 19:04:38 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:47489 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932138AbaAFWil (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 17:38:41 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Paul Drews <paul.drews@intel.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 3.12 049/144] ACPI: Add BayTrail SoC GPIO and LPSS ACPI IDs
Date: Mon,  6 Jan 2014 14:36:50 -0800
Message-Id: <20140106223746.751352695@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140106223745.326293132@linuxfoundation.org>
References: <20140106223745.326293132@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/acpi/acpi_lpss.c           |    1 +
 drivers/pinctrl/pinctrl-baytrail.c |    1 +
 2 files changed, 2 insertions(+)

--- a/drivers/acpi/acpi_lpss.c
+++ b/drivers/acpi/acpi_lpss.c
@@ -156,6 +156,7 @@ static const struct acpi_device_id acpi_
 	{ "80860F14", (unsigned long)&byt_sdio_dev_desc },
 	{ "80860F41", (unsigned long)&byt_i2c_dev_desc },
 	{ "INT33B2", },
+	{ "INT33FC", },
 
 	{ }
 };
--- a/drivers/pinctrl/pinctrl-baytrail.c
+++ b/drivers/pinctrl/pinctrl-baytrail.c
@@ -512,6 +512,7 @@ static const struct dev_pm_ops byt_gpio_
 
 static const struct acpi_device_id byt_gpio_acpi_match[] = {
 	{ "INT33B2", 0 },
+	{ "INT33FC", 0 },
 	{ }
 };
 MODULE_DEVICE_TABLE(acpi, byt_gpio_acpi_match);


