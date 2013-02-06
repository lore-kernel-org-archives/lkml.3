Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755017Ab3BFRBv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 12:01:51 -0500
Received: from atlantis.wh2.tu-dresden.de ([141.30.228.39]:34906 "EHLO
	atlantis.wh2.tu-dresden.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750716Ab3BFRBr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 12:01:47 -0500
From: Lars Poeschel <larsi@wh2.tu-dresden.de>
To: poeschel@lemonage.de, grant.likely@secretlab.ca, rob.herring@calxeda.com,
        rob@landley.net, linus.walleij@linaro.org,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, spi-devel-general@lists.sourceforge.net
Cc: w.sang@pengutronix.de, ben-linux@fluff.org, linux-i2c@vger.kernel.org
Subject: [PATCH 1/2] gpio: mcp23s08: Allow -1 as a legal value for global gpio base
Date: Wed,  6 Feb 2013 18:01:57 +0100
Message-Id: <1360170118-11937-2-git-send-email-larsi@wh2.tu-dresden.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1360170118-11937-1-git-send-email-larsi@wh2.tu-dresden.de>
References: <1360170118-11937-1-git-send-email-larsi@wh2.tu-dresden.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lars Poeschel <poeschel@lemonage.de>

Explicitly allow -1 as a legal value for the
mcp23s08_platform_data->base. This is the special value lets the
kernel choose a valid global gpio base number.

Signed-off-by: Lars Poeschel <poeschel@lemonage.de>
---
 drivers/gpio/gpio-mcp23s08.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpio/gpio-mcp23s08.c b/drivers/gpio/gpio-mcp23s08.c
index 3cea0ea..2afb828 100644
--- a/drivers/gpio/gpio-mcp23s08.c
+++ b/drivers/gpio/gpio-mcp23s08.c
@@ -483,7 +483,7 @@ static int mcp230xx_probe(struct i2c_client *client,
 	int status;
 
 	pdata = client->dev.platform_data;
-	if (!pdata || !gpio_is_valid(pdata->base)) {
+	if ((!pdata || !gpio_is_valid(pdata->base)) && pdata->base != -1) {
 		dev_dbg(&client->dev, "invalid or missing platform data\n");
 		return -EINVAL;
 	}
@@ -570,7 +570,7 @@ static int mcp23s08_probe(struct spi_device *spi)
 	type = spi_get_device_id(spi)->driver_data;
 
 	pdata = spi->dev.platform_data;
-	if (!pdata || !gpio_is_valid(pdata->base)) {
+	if ((!pdata || !gpio_is_valid(pdata->base)) && pdata->base != -1) {
 		dev_dbg(&spi->dev, "invalid or missing platform data\n");
 		return -EINVAL;
 	}
-- 
1.7.10.4

