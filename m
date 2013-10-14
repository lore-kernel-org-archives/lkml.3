Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932216Ab3JNPP3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 11:15:29 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:53280 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756152Ab3JNPP1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 11:15:27 -0400
From: Markus Pargmann <mpa@pengutronix.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Wolfram Sang <wsa@the-dreams.de>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kernel@pengutronix.de,
        Jan Luebbe <jlu@pengutronix.de>, Markus Pargmann <mpa@pengutronix.de>
Subject: [PATCH] misc/at25, dt: support probing at25 SPI EEPROM from DT
Date: Mon, 14 Oct 2013 17:14:59 +0200
Message-Id: <1381763699-13440-1-git-send-email-mpa@pengutronix.de>
X-Mailer: git-send-email 1.8.4.rc3
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: mpa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Luebbe <jlu@pengutronix.de>

The commit d6ae0d578d24303941c1424b049d2cae28277666 introduced devicetree
binding documentation for this driver, but the driver itself does not yet
support the documented compatible entry. Fix this by adding the documented
entry to the driver.

Signed-off-by: Jan Luebbe <jlu@pengutronix.de>
Signed-off-by: Markus Pargmann <mpa@pengutronix.de>
---
 drivers/misc/eeprom/at25.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/misc/eeprom/at25.c b/drivers/misc/eeprom/at25.c
index 840b359..4f3bca1 100644
--- a/drivers/misc/eeprom/at25.c
+++ b/drivers/misc/eeprom/at25.c
@@ -462,10 +462,17 @@ static int at25_remove(struct spi_device *spi)
 
 /*-------------------------------------------------------------------------*/
 
+static const struct of_device_id at25_of_match[] = {
+	{ .compatible = "atmel,at25", },
+	{ }
+};
+MODULE_DEVICE_TABLE(of, at25_of_match);
+
 static struct spi_driver at25_driver = {
 	.driver = {
 		.name		= "at25",
 		.owner		= THIS_MODULE,
+		.of_match_table = at25_of_match,
 	},
 	.probe		= at25_probe,
 	.remove		= at25_remove,
-- 
1.8.4.rc3

