Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753954Ab3BKIWf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 03:22:35 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:38734 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753865Ab3BKIWc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 03:22:32 -0500
From: Luciano Coelho <coelho@ti.com>
To: <linville@tuxdriver.com>, <sfr@canb.auug.org.au>
CC: <joe@perches.com>, <linux-next@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>
Subject: [PATCH v2] wlcore: remove newly introduced alloc/OOM messages
Date: Mon, 11 Feb 2013 10:21:18 +0200
Message-ID: <1360570878-23107-1-git-send-email-coelho@ti.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1360569218.12803.50.camel@cumari.coelho.fi>
References: <1360569218.12803.50.camel@cumari.coelho.fi>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In commit 0d2e7a5c (wireless: Remove unnecessary alloc/OOM messages,
alloc cleanups) OOM messages after alloc were removed from the wlcore
modules.

Commit afb43e6d (wlcore: remove if_ops from platform_data)
reintroduced a couple of those.  This patch removes them.

Signed-off-by: Luciano Coelho <coelho@ti.com>
---

John,

Please ignore my previous patch.  Now this should be right. ;)

Can you apply this directly on wireless-next after you process my
latest pull-request?

Thanks!

Sorry for my monday-morning-with-too-little-caffeinne-in-the-blood
screw up. ;)

 drivers/net/wireless/ti/wlcore/sdio.c |    4 +---
 drivers/net/wireless/ti/wlcore/spi.c  |    4 +---
 2 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/sdio.c b/drivers/net/wireless/ti/wlcore/sdio.c
index 198028d..29ef249 100644
--- a/drivers/net/wireless/ti/wlcore/sdio.c
+++ b/drivers/net/wireless/ti/wlcore/sdio.c
@@ -229,10 +229,8 @@ static int wl1271_probe(struct sdio_func *func,
 		return -ENODEV;
 
 	pdev_data = kzalloc(sizeof(*pdev_data), GFP_KERNEL);
-	if (!pdev_data) {
-		dev_err(&func->dev, "can't allocate platdev_data\n");
+	if (!pdev_data)
 		goto out;
-	}
 
 	pdev_data->if_ops = &sdio_ops;
 
diff --git a/drivers/net/wireless/ti/wlcore/spi.c b/drivers/net/wireless/ti/wlcore/spi.c
index 5ad2e10..e264478 100644
--- a/drivers/net/wireless/ti/wlcore/spi.c
+++ b/drivers/net/wireless/ti/wlcore/spi.c
@@ -332,10 +332,8 @@ static int wl1271_probe(struct spi_device *spi)
 	int ret = -ENOMEM;
 
 	pdev_data = kzalloc(sizeof(*pdev_data), GFP_KERNEL);
-	if (!pdev_data) {
-		dev_err(&spi->dev, "can't allocate platdev_data\n");
+	if (!pdev_data)
 		goto out;
-	}
 
 	pdev_data->pdata = spi->dev.platform_data;
 	if (!pdev_data->pdata) {
-- 
1.7.10.4

