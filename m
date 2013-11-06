Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756157Ab3KFH4l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 02:56:41 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:7031 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750803Ab3KFH4j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 02:56:39 -0500
X-IronPort-AV: E=Sophos;i="4.93,644,1378828800"; 
   d="scan'208";a="8960230"
From: Duan Jiong <duanj.fnst@cn.fujitsu.com>
To: kernel@pengutronix.de, linux@arm.linux.org.uk, a.zummo@towertech.it,
        airlied@linux.ie, dmitry.torokhov@gmail.com
Cc: linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com,
        dri-devel@lists.freedesktop.org, linux-tegra@vger.kernel.org,
        linux-input@vger.kernel.org, Duan Jiong <duanj.fnst@cn.fujitsu.com>
Subject: [PATCH] Input: replace IS_ERR and PTR_ERR with PTR_ERR_OR_ZERO
Date: Wed, 6 Nov 2013 15:54:32 +0800
Message-Id: <1383724472-15475-1-git-send-email-duanj.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.3.1
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/11/06 15:54:44,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/11/06 15:54:45,
	Serialize complete at 2013/11/06 15:54:45
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes coccinelle error regarding usage of IS_ERR and
PTR_ERR instead of PTR_ERR_OR_ZERO.

Signed-off-by: Duan Jiong <duanj.fnst@cn.fujitsu.com>
---
 drivers/input/touchscreen/cyttsp4_spi.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/input/touchscreen/cyttsp4_spi.c b/drivers/input/touchscreen/cyttsp4_spi.c
index a71e114..b19434c 100644
--- a/drivers/input/touchscreen/cyttsp4_spi.c
+++ b/drivers/input/touchscreen/cyttsp4_spi.c
@@ -171,10 +171,7 @@ static int cyttsp4_spi_probe(struct spi_device *spi)
 	ts = cyttsp4_probe(&cyttsp_spi_bus_ops, &spi->dev, spi->irq,
 			  CY_SPI_DATA_BUF_SIZE);
 
-	if (IS_ERR(ts))
-		return PTR_ERR(ts);
-
-	return 0;
+	return PTR_ERR_OR_ZERO(ts);
 }
 
 static int cyttsp4_spi_remove(struct spi_device *spi)
-- 
1.8.3.1

