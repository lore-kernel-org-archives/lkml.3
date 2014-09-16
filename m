Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754212AbaIPLyH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 07:54:07 -0400
Received: from mga02.intel.com ([134.134.136.20]:5614 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754125AbaIPLxN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 07:53:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,534,1406617200"; 
   d="scan'208";a="477850332"
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
Subject: [RFC PATCH v2 16/16] misc: at25: Add ACPI probing support
Date: Tue, 16 Sep 2014 14:52:47 +0300
Message-Id: <1410868367-11056-17-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1410868367-11056-1-git-send-email-mika.westerberg@linux.intel.com>
References: <1410868367-11056-1-git-send-email-mika.westerberg@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for matching using DT compatible string from ACPI _DSD.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 drivers/misc/eeprom/at25.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/misc/eeprom/at25.c b/drivers/misc/eeprom/at25.c
index 58f6cdd2551c..1a760cd966bd 100644
--- a/drivers/misc/eeprom/at25.c
+++ b/drivers/misc/eeprom/at25.c
@@ -459,11 +459,18 @@ static const struct of_device_id at25_of_match[] = {
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
-- 
2.1.0

