Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751594AbaJACDO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 22:03:14 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:61862 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750954AbaJACDL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 22:03:11 -0400
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
Subject: [PATCH v3 15/15] misc: at25: Add ACPI probing support
Date: Wed, 01 Oct 2014 04:22:27 +0200
Message-ID: <2551386.HUYYQnE3a6@vostro.rjw.lan>
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

Add support for matching using DT compatible string from ACPI _DSD.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
drivers/misc/eeprom/at25.c | 7 +++++++
 drivers/misc/eeprom/at25.c |    7 +++++++
 1 file changed, 7 insertions(+)

Index: linux-pm/drivers/misc/eeprom/at25.c
===================================================================
--- linux-pm.orig/drivers/misc/eeprom/at25.c
+++ linux-pm/drivers/misc/eeprom/at25.c
@@ -459,11 +459,18 @@ static const struct of_device_id at25_of
 };
 MODULE_DEVICE_TABLE(of, at25_of_match);
 
+static const struct acpi_device_id at25_acpi_match[] = {
+	{ "PRP0001" },
+	{ }
+};
+MODULE_DEVICE_TABLE(acpi, at25_acpi_match);
+
 static struct spi_driver at25_driver = {
 	.driver = {
 		.name		= "at25",
 		.owner		= THIS_MODULE,
 		.of_match_table = at25_of_match,
+		.acpi_match_table = at25_acpi_match,
 	},
 	.probe		= at25_probe,
 	.remove		= at25_remove,

