Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751860AbaJACDS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 22:03:18 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:51678 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751738AbaJACDQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 22:03:16 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: linux-kernel@vger.kernel.org
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-acpi@vger.kernel.org, devicetree@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Bryan Wu <cooloney@gmail.com>, Lee Jones <lee.jones@linaro.org>,
        Grant Likely <grant.likely@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Aaron Lu <aaron.lu@intel.com>, Darren Hart <dvhart@linux.intel.com>
Subject: [PATCH v3 10/15] leds: leds-gpio: Add ACPI probing support
Date: Wed, 01 Oct 2014 04:17:02 +0200
Message-ID: <4835699.XutTNxriDg@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1852462.V1jlbi8OPt@vostro.rjw.lan>
References: <1410868367-11056-1-git-send-email-mika.westerberg@linux.intel.com> <1852462.V1jlbi8OPt@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Max Eliaser <max@meliaserlow.dyndns.tv>

This allows the driver to probe from ACPI namespace.

Signed-off-by: Max Eliaser <max.eliaser@intel.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Acked-by: Bryan Wu <cooloney@gmail.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/leds/leds-gpio.c |    8 ++++++++
 1 file changed, 8 insertions(+)

Index: linux-pm/drivers/leds/leds-gpio.c
===================================================================
--- linux-pm.orig/drivers/leds/leds-gpio.c
+++ linux-pm/drivers/leds/leds-gpio.c
@@ -231,6 +231,13 @@ static const struct of_device_id of_gpio
 
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
@@ -286,6 +293,7 @@ static struct platform_driver gpio_led_d
 		.name	= "leds-gpio",
 		.owner	= THIS_MODULE,
 		.of_match_table = of_gpio_leds_match,
+		.acpi_match_table = acpi_gpio_leds_match,
 	},
 };
 

