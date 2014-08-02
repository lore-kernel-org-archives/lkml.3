Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755079AbaHBOwv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2014 10:52:51 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:61191 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752389AbaHBOwt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2014 10:52:49 -0400
Date: Sat, 2 Aug 2014 20:22:46 +0530
From: Himangi Saraogi <himangi774@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>,
        Solomon Peachy <pizza@shaftnet.org>, Jingoo Han <jg1.han@samsung.com>,
        David Mosberger <davidm@egauge.net>, linux-kernel@vger.kernel.org
Subject: [PATCH] cw1200: Introduce the use of devm_kzalloc
Message-ID: <20140802145246.GA12242@himangi-Dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces the use of devm_kzalloc and does away with the
kfrees in the probe and remove functions.

Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
Acked-by: Julia Lawall <julia.lawall@lip6.fr>
---
 drivers/net/wireless/cw1200/cw1200_spi.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/wireless/cw1200/cw1200_spi.c b/drivers/net/wireless/cw1200/cw1200_spi.c
index 40078f5..964b64a 100644
--- a/drivers/net/wireless/cw1200/cw1200_spi.c
+++ b/drivers/net/wireless/cw1200/cw1200_spi.c
@@ -398,7 +398,7 @@ static int cw1200_spi_probe(struct spi_device *func)
 		return -1;
 	}
 
-	self = kzalloc(sizeof(*self), GFP_KERNEL);
+	self = devm_kzalloc(&func->dev, sizeof(*self), GFP_KERNEL);
 	if (!self) {
 		pr_err("Can't allocate SPI hwbus_priv.");
 		return -ENOMEM;
@@ -424,7 +424,6 @@ static int cw1200_spi_probe(struct spi_device *func)
 	if (status) {
 		cw1200_spi_irq_unsubscribe(self);
 		cw1200_spi_off(plat_data);
-		kfree(self);
 	}
 
 	return status;
@@ -441,7 +440,6 @@ static int cw1200_spi_disconnect(struct spi_device *func)
 			cw1200_core_release(self->core);
 			self->core = NULL;
 		}
-		kfree(self);
 	}
 	cw1200_spi_off(dev_get_platdata(&func->dev));
 
-- 
1.9.1

