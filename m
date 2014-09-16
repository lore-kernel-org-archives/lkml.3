Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754189AbaIPLxt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 07:53:49 -0400
Received: from mga02.intel.com ([134.134.136.20]:59207 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754150AbaIPLxa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 07:53:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,534,1406617200"; 
   d="scan'208";a="603534626"
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
Subject: [RFC PATCH v2 11/16] leds: leds-gpio: Add ACPI probing support
Date: Tue, 16 Sep 2014 14:52:42 +0300
Message-Id: <1410868367-11056-12-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1410868367-11056-1-git-send-email-mika.westerberg@linux.intel.com>
References: <1410868367-11056-1-git-send-email-mika.westerberg@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Max Eliaser <max.eliaser@intel.com>

This allows the driver to probe from ACPI namespace.

Signed-off-by: Max Eliaser <max.eliaser@intel.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 drivers/leds/leds-gpio.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/leds/leds-gpio.c b/drivers/leds/leds-gpio.c
index 5dbf7485da66..24e05adbbaf8 100644
--- a/drivers/leds/leds-gpio.c
+++ b/drivers/leds/leds-gpio.c
@@ -234,6 +234,13 @@ static const struct of_device_id of_gpio_leds_match[] = {
 
 MODULE_DEVICE_TABLE(of, of_gpio_leds_match);
 
+static const struct acpi_device_id acpi_gpio_leds_match[] = {
+	{ "PRP0001" }, /* Device Tree shoehorned into ACPI */
+	{},
+};
+
+MODULE_DEVICE_TABLE(acpi, acpi_gpio_leds_match);
+
 static int gpio_led_probe(struct platform_device *pdev)
 {
 	struct gpio_led_platform_data *pdata = dev_get_platdata(&pdev->dev);
@@ -289,6 +296,7 @@ static struct platform_driver gpio_led_driver = {
 		.name	= "leds-gpio",
 		.owner	= THIS_MODULE,
 		.of_match_table = of_gpio_leds_match,
+		.acpi_match_table = acpi_gpio_leds_match,
 	},
 };
 
-- 
2.1.0

