Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754933Ab3GJP7y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 11:59:54 -0400
Received: from sauhun.de ([89.238.76.85]:44350 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754912Ab3GJP7v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 11:59:51 -0400
From: Wolfram Sang <wsa@the-dreams.de>
To: linux-kernel@vger.kernel.org
Cc: Wolfram Sang <wsa@the-dreams.de>,
        Alexander Smirnov <alex.bluesman.smirnov@gmail.com>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        linux-zigbee-devel@lists.sourceforge.net, netdev@vger.kernel.org
Subject: [PATCH 09/12] drivers/net/ieee802154: don't use devm_pinctrl_get_select_default() in probe
Date: Wed, 10 Jul 2013 16:57:44 +0100
Message-Id: <1373471889-18107-9-git-send-email-wsa@the-dreams.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1373471889-18107-1-git-send-email-wsa@the-dreams.de>
References: <1373471889-18107-1-git-send-email-wsa@the-dreams.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since commit ab78029 (drivers/pinctrl: grab default handles from device core),
we can rely on device core for setting the default pins. Compile tested only.

Acked-by: Linus Walleij <linus.walleij@linaro.org> (personally at LCE13)
Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
---
 drivers/net/ieee802154/mrf24j40.c |    7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/net/ieee802154/mrf24j40.c b/drivers/net/ieee802154/mrf24j40.c
index ede3ce4..42e6dee 100644
--- a/drivers/net/ieee802154/mrf24j40.c
+++ b/drivers/net/ieee802154/mrf24j40.c
@@ -22,7 +22,6 @@
 #include <linux/spi/spi.h>
 #include <linux/interrupt.h>
 #include <linux/module.h>
-#include <linux/pinctrl/consumer.h>
 #include <net/wpan-phy.h>
 #include <net/mac802154.h>
 #include <net/ieee802154.h>
@@ -627,7 +626,6 @@ static int mrf24j40_probe(struct spi_device *spi)
 	int ret = -ENOMEM;
 	u8 val;
 	struct mrf24j40 *devrec;
-	struct pinctrl *pinctrl;
 
 	printk(KERN_INFO "mrf24j40: probe(). IRQ: %d\n", spi->irq);
 
@@ -638,11 +636,6 @@ static int mrf24j40_probe(struct spi_device *spi)
 	if (!devrec->buf)
 		goto err_buf;
 
-	pinctrl = devm_pinctrl_get_select_default(&spi->dev);
-	if (IS_ERR(pinctrl))
-		dev_warn(&spi->dev,
-			"pinctrl pins are not configured from the driver");
-
 	spi->mode = SPI_MODE_0; /* TODO: Is this appropriate for right here? */
 	if (spi->max_speed_hz > MAX_SPI_SPEED_HZ)
 		spi->max_speed_hz = MAX_SPI_SPEED_HZ;
-- 
1.7.10.4

