Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932665AbaFCLle (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 07:41:34 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43518 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932629AbaFCLl1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 07:41:27 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Gary Servin <garyservin@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 063/138] gpio: mcp23s08: trivial: fixed coding style issues
Date: Tue,  3 Jun 2014 12:38:29 +0100
Message-Id: <1401795584-22664-64-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1401795584-22664-1-git-send-email-luis.henriques@canonical.com>
References: <1401795584-22664-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gary Servin <garyservin@gmail.com>

commit 33bc8411eec33f92ba59e8ef7394b82245ec556e upstream.

This coding style issue was detected using the checkpatch.pl script

Signed-off-by: Gary Servin <garyservin@gmail.com>
Reviewed-by: Alexandre Courbot <acourbot@nvidia.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpio/gpio-mcp23s08.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/gpio/gpio-mcp23s08.c b/drivers/gpio/gpio-mcp23s08.c
index 6a4470b84488..65d2590b0ecd 100644
--- a/drivers/gpio/gpio-mcp23s08.c
+++ b/drivers/gpio/gpio-mcp23s08.c
@@ -152,7 +152,7 @@ static int mcp23s08_read(struct mcp23s08 *mcp, unsigned reg)
 
 	tx[0] = mcp->addr | 0x01;
 	tx[1] = reg;
-	status = spi_write_then_read(mcp->data, tx, sizeof tx, rx, sizeof rx);
+	status = spi_write_then_read(mcp->data, tx, sizeof(tx), rx, sizeof(rx));
 	return (status < 0) ? status : rx[0];
 }
 
@@ -163,7 +163,7 @@ static int mcp23s08_write(struct mcp23s08 *mcp, unsigned reg, unsigned val)
 	tx[0] = mcp->addr;
 	tx[1] = reg;
 	tx[2] = val;
-	return spi_write_then_read(mcp->data, tx, sizeof tx, NULL, 0);
+	return spi_write_then_read(mcp->data, tx, sizeof(tx), NULL, 0);
 }
 
 static int
@@ -172,13 +172,13 @@ mcp23s08_read_regs(struct mcp23s08 *mcp, unsigned reg, u16 *vals, unsigned n)
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
@@ -193,7 +193,7 @@ static int mcp23s17_read(struct mcp23s08 *mcp, unsigned reg)
 
 	tx[0] = mcp->addr | 0x01;
 	tx[1] = reg << 1;
-	status = spi_write_then_read(mcp->data, tx, sizeof tx, rx, sizeof rx);
+	status = spi_write_then_read(mcp->data, tx, sizeof(tx), rx, sizeof(rx));
 	return (status < 0) ? status : (rx[0] | (rx[1] << 8));
 }
 
@@ -205,7 +205,7 @@ static int mcp23s17_write(struct mcp23s08 *mcp, unsigned reg, unsigned val)
 	tx[1] = reg << 1;
 	tx[2] = val;
 	tx[3] = val >> 8;
-	return spi_write_then_read(mcp->data, tx, sizeof tx, NULL, 0);
+	return spi_write_then_read(mcp->data, tx, sizeof(tx), NULL, 0);
 }
 
 static int
@@ -214,12 +214,12 @@ mcp23s17_read_regs(struct mcp23s08 *mcp, unsigned reg, u16 *vals, unsigned n)
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
@@ -357,7 +357,7 @@ static void mcp23s08_dbg_show(struct seq_file *s, struct gpio_chip *chip)
 			(mcp->cache[MCP_GPIO] & mask) ? "hi" : "lo",
 			(mcp->cache[MCP_GPPU] & mask) ? "up" : "  ");
 		/* NOTE:  ignoring the irq-related registers */
-		seq_printf(s, "\n");
+		seq_puts(s, "\n");
 	}
 done:
 	mutex_unlock(&mcp->lock);
@@ -534,7 +534,7 @@ static int mcp230xx_probe(struct i2c_client *client,
 		pullups = pdata->chip[0].pullups;
 	}
 
-	mcp = kzalloc(sizeof *mcp, GFP_KERNEL);
+	mcp = kzalloc(sizeof(*mcp), GFP_KERNEL);
 	if (!mcp)
 		return -ENOMEM;
 
@@ -661,7 +661,7 @@ static int mcp23s08_probe(struct spi_device *spi)
 		base = pdata->base;
 	}
 
-	data = kzalloc(sizeof *data + chips * sizeof(struct mcp23s08),
+	data = kzalloc(sizeof(*data) + chips * sizeof(struct mcp23s08),
 			GFP_KERNEL);
 	if (!data)
 		return -ENOMEM;
-- 
1.9.1

