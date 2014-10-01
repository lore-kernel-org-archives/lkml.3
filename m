Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751870AbaJACHi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 22:07:38 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:56497 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750996AbaJACDN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 22:03:13 -0400
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
Subject: [PATCH v3 13/15] input: gpio_keys_polled - Add ACPI probing support
Date: Wed, 01 Oct 2014 04:20:43 +0200
Message-ID: <17237242.r7oKCjnQJM@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1852462.V1jlbi8OPt@vostro.rjw.lan>
References: <1410868367-11056-1-git-send-email-mika.westerberg@linux.intel.com> <1852462.V1jlbi8OPt@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mika Westerberg <mika.westerberg@linux.intel.com>

Allow the driver to probe from ACPI namespace.

Signed-off-by: Aaron Lu <aaron.lu@intel.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/input/keyboard/gpio_keys_polled.c |    7 +++++++
 1 file changed, 7 insertions(+)

Index: linux-pm/drivers/input/keyboard/gpio_keys_polled.c
===================================================================
--- linux-pm.orig/drivers/input/keyboard/gpio_keys_polled.c
+++ linux-pm/drivers/input/keyboard/gpio_keys_polled.c
@@ -181,6 +181,12 @@ static const struct of_device_id gpio_ke
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
@@ -309,6 +315,7 @@ static struct platform_driver gpio_keys_
 		.name	= DRV_NAME,
 		.owner	= THIS_MODULE,
 		.of_match_table = gpio_keys_polled_of_match,
+		.acpi_match_table = gpio_keys_polled_acpi_match,
 	},
 };
 module_platform_driver(gpio_keys_polled_driver);

