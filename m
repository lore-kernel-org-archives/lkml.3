Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754069AbaIPLxE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 07:53:04 -0400
Received: from mga02.intel.com ([134.134.136.20]:4928 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754033AbaIPLxB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 07:53:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,534,1406617200"; 
   d="scan'208";a="573795148"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: linux-acpi@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Bryan Wu <cooloney@gmail.com>, Lee Jones <lee.jones@linaro.org>,
        Grant Likely <grant.likely@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Aaron Lu <aaron.lu@intel.com>, Darren Hart <dvhart@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [RFC PATCH v2 14/16] input: gpio_keys_polled - Add ACPI probing support
Date: Tue, 16 Sep 2014 14:52:45 +0300
Message-Id: <1410868367-11056-15-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1410868367-11056-1-git-send-email-mika.westerberg@linux.intel.com>
References: <1410868367-11056-1-git-send-email-mika.westerberg@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow the driver to probe from ACPI namespace.

Signed-off-by: Aaron Lu <aaron.lu@intel.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 drivers/input/keyboard/gpio_keys_polled.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/input/keyboard/gpio_keys_polled.c b/drivers/input/keyboard/gpio_keys_polled.c
index 9afd9a6c43f4..89bf5732d200 100644
--- a/drivers/input/keyboard/gpio_keys_polled.c
+++ b/drivers/input/keyboard/gpio_keys_polled.c
@@ -189,6 +189,12 @@ static const struct of_device_id gpio_keys_polled_of_match[] = {
 };
 MODULE_DEVICE_TABLE(of, gpio_keys_polled_of_match);
 
+static const struct acpi_device_id gpio_keys_polled_acpi_match[] = {
+	{ "PRP0001" }, /* Device Tree shoehorned into ACPI */
+	{ },
+};
+MODULE_DEVICE_TABLE(acpi, gpio_keys_polled_acpi_match);
+
 static int gpio_keys_polled_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
@@ -317,6 +323,7 @@ static struct platform_driver gpio_keys_polled_driver = {
 		.name	= DRV_NAME,
 		.owner	= THIS_MODULE,
 		.of_match_table = gpio_keys_polled_of_match,
+		.acpi_match_table = gpio_keys_polled_acpi_match,
 	},
 };
 module_platform_driver(gpio_keys_polled_driver);
-- 
2.1.0

