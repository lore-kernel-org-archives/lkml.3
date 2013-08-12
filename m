Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756675Ab3HLKWx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 06:22:53 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:49217 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756333Ab3HLKWq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 06:22:46 -0400
From: Sascha Hauer <s.hauer@pengutronix.de>
To: linux-mtd@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Marek Vasut <marex@denx.de>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        kernel@pengutronix.de, Sascha Hauer <s.hauer@pengutronix.de>
Subject: [PATCH 4/4] mtd: m25p80: remove unnecessary ifdef
Date: Mon, 12 Aug 2013 12:22:26 +0200
Message-Id: <1376302946-11534-5-git-send-email-s.hauer@pengutronix.de>
X-Mailer: git-send-email 1.8.4.rc1
In-Reply-To: <1376302946-11534-1-git-send-email-s.hauer@pengutronix.de>
References: <1376302946-11534-1-git-send-email-s.hauer@pengutronix.de>
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

of_property_read_bool properly compiles away, no need to ifdef this
for non DT builds.

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
---
 drivers/mtd/devices/m25p80.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/mtd/devices/m25p80.c b/drivers/mtd/devices/m25p80.c
index d179188..f21af0e 100644
--- a/drivers/mtd/devices/m25p80.c
+++ b/drivers/mtd/devices/m25p80.c
@@ -1030,10 +1030,8 @@ static int m25p_probe(struct spi_device *spi)
 	flash->mtd.writebufsize = flash->page_size;
 
 	flash->fast_read = false;
-#ifdef CONFIG_OF
 	if (np && of_property_read_bool(np, "m25p,fast-read"))
 		flash->fast_read = true;
-#endif
 
 #ifdef CONFIG_M25PXX_USE_FAST_READ
 	flash->fast_read = true;
-- 
1.8.4.rc1

