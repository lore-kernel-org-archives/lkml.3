Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751574AbaCFXZy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 18:25:54 -0500
Received: from mail-yk0-f170.google.com ([209.85.160.170]:35301 "EHLO
	mail-yk0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750829AbaCFXZw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 18:25:52 -0500
From: Gary Servin <garyservin@gmail.com>
To: linus.walleij@linaro.org, gnurou@gmail.com
Cc: trivial@kernel.org, linux-gpio@vger.kernel.org,
        linux-kernel@vger.kernel.org, Gary Servin <garyservin@gmail.com>
Subject: [PATCH] gpio: mcp23s08: Trivial: Fixed coding style issues
Date: Thu,  6 Mar 2014 20:25:26 -0300
Message-Id: <1394148326-21556-1-git-send-email-garyservin@gmail.com>
X-Mailer: git-send-email 1.9.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This coding style issue was detected using the checkpatch.pl script

Signed-off-by: Gary Servin <garyservin@gmail.com>
---
 drivers/gpio/gpio-mcp23s08.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/gpio/gpio-mcp23s08.c b/drivers/gpio/gpio-mcp23s08.c
index 1ac288e..e1734c1 100644
--- a/drivers/gpio/gpio-mcp23s08.c
+++ b/drivers/gpio/gpio-mcp23s08.c
@@ -173,7 +173,7 @@ static int mcp23s08_read(struct mcp23s08 *mcp, unsigned reg)
 
 	tx[0] = mcp->addr | 0x01;
 	tx[1] = reg;
-	status = spi_write_then_read(mcp->data, tx, sizeof tx, rx, sizeof rx);
+	status = spi_write_then_read(mcp->data, tx, sizeof(tx), rx, sizeof(rx));
 	return (status < 0) ? status : rx[0];
 }
 
@@ -184,7 +184,7 @@ static int mcp23s08_write(struct mcp23s08 *mcp, unsigned reg, unsigned val)
 	tx[0] = mcp->addr;
 	tx[1] = reg;
 	tx[2] = val;
-	return spi_write_then_read(mcp->data, tx, sizeof tx, NULL, 0);
+	return spi_write_then_read(mcp->data, tx, sizeof(tx), NULL, 0);
 }
 
 static int
@@ -193,13 +193,13 @@ mcp23s08_read_regs(struct mcp23s08 *mcp, unsigned reg, u16 *vals, unsigned n)
 	u8	tx[2], *tmp;
 	int	status;
 
-	if ((n + reg) > sizeof mcp->cache)
+	if ((n + reg) > sizeof(mcp->cache))
 		return -EINVAL;
 	tx[0] = mcp->addr | 0x01;
 	tx[1] = reg;
 
 	tmp = (u8 *)vals;
-	status = spi_write_then_read(mcp->data, tx, sizeof tx, tmp, n);
+	status = spi_write_then_read(mcp->data, tx, sizeof(tx), tmp, n);
 	if (status >= 0) {
 		while (n--)
 			vals[n] = tmp[n]; /* expand to 16bit */
@@ -214,7 +214,7 @@ static int mcp23s17_read(struct mcp23s08 *mcp, unsigned reg)
 
 	tx[0] = mcp->addr | 0x01;
 	tx[1] = reg << 1;
-	status = spi_write_then_read(mcp->data, tx, sizeof tx, rx, sizeof rx);
+	status = spi_write_then_read(mcp->data, tx, sizeof(tx), rx, sizeof(rx));
 	return (status < 0) ? status : (rx[0] | (rx[1] << 8));
 }
 
@@ -226,7 +226,7 @@ static int mcp23s17_write(struct mcp23s08 *mcp, unsigned reg, unsigned val)
 	tx[1] = reg << 1;
 	tx[2] = val;
 	tx[3] = val >> 8;
-	return spi_write_then_read(mcp->data, tx, sizeof tx, NULL, 0);
+	return spi_write_then_read(mcp->data, tx, sizeof(tx), NULL, 0);
 }
 
 static int
@@ -235,12 +235,12 @@ mcp23s17_read_regs(struct mcp23s08 *mcp, unsigned reg, u16 *vals, unsigned n)
 	u8	tx[2];
 	int	status;
 
-	if ((n + reg) > sizeof mcp->cache)
+	if ((n + reg) > sizeof(mcp->cache))
 		return -EINVAL;
 	tx[0] = mcp->addr | 0x01;
 	tx[1] = reg << 1;
 
-	status = spi_write_then_read(mcp->data, tx, sizeof tx,
+	status = spi_write_then_read(mcp->data, tx, sizeof(tx),
 				     (u8 *)vals, n * 2);
 	if (status >= 0) {
 		while (n--)
@@ -567,7 +567,7 @@ static void mcp23s08_dbg_show(struct seq_file *s, struct gpio_chip *chip)
 			(mcp->cache[MCP_GPIO] & mask) ? "hi" : "lo",
 			(mcp->cache[MCP_GPPU] & mask) ? "up" : "  ");
 		/* NOTE:  ignoring the irq-related registers */
-		seq_printf(s, "\n");
+		seq_puts(s, "\n");
 	}
 done:
 	mutex_unlock(&mcp->lock);
@@ -789,7 +789,7 @@ static int mcp230xx_probe(struct i2c_client *client,
 		pullups = pdata->chip[0].pullups;
 	}
 
-	mcp = kzalloc(sizeof *mcp, GFP_KERNEL);
+	mcp = kzalloc(sizeof(*mcp), GFP_KERNEL);
 	if (!mcp)
 		return -ENOMEM;
 
@@ -925,7 +925,7 @@ static int mcp23s08_probe(struct spi_device *spi)
 		base = pdata->base;
 	}
 
-	data = kzalloc(sizeof *data + chips * sizeof(struct mcp23s08),
+	data = kzalloc(sizeof(*data) + chips * sizeof(struct mcp23s08),
 			GFP_KERNEL);
 	if (!data)
 		return -ENOMEM;
-- 
1.9.0

