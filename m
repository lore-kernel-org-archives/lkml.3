Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752929AbaAWTGb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 14:06:31 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:34929 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752234AbaAWTGQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 14:06:16 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 3.12 01/27] Revert "ACPI: Add BayTrail SoC GPIO and LPSS ACPI IDs"
Date: Thu, 23 Jan 2014 11:06:38 -0800
Message-Id: <20140123190648.853998703@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140123190648.720195687@linuxfoundation.org>
References: <20140123190648.720195687@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/acpi/acpi_lpss.c           |    1 -
 drivers/pinctrl/pinctrl-baytrail.c |    1 -
 2 files changed, 2 deletions(-)

--- a/drivers/acpi/acpi_lpss.c
+++ b/drivers/acpi/acpi_lpss.c
@@ -156,7 +156,6 @@ static const struct acpi_device_id acpi_
 	{ "80860F14", (unsigned long)&byt_sdio_dev_desc },
 	{ "80860F41", (unsigned long)&byt_i2c_dev_desc },
 	{ "INT33B2", },
-	{ "INT33FC", },
 
 	{ }
 };
--- a/drivers/pinctrl/pinctrl-baytrail.c
+++ b/drivers/pinctrl/pinctrl-baytrail.c
@@ -512,7 +512,6 @@ static const struct dev_pm_ops byt_gpio_
 
 static const struct acpi_device_id byt_gpio_acpi_match[] = {
 	{ "INT33B2", 0 },
-	{ "INT33FC", 0 },
 	{ }
 };
 MODULE_DEVICE_TABLE(acpi, byt_gpio_acpi_match);


