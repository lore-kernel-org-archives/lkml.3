Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932261Ab3K1E24 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 23:28:56 -0500
Received: from mail-ie0-f176.google.com ([209.85.223.176]:48225 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757791Ab3K1E2k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 23:28:40 -0500
From: Thomas Behan <thomas.behan@gmail.com>
To: linux-spi@vger.kernel.org
Cc: broonie@linaro.org, linux-kernel@vger.kernel.org,
        Thomas Behan <thomas.behan@gmail.com>
Subject: [PATCH 4/4] spi: omap-100k: Fixed style of sizeof operators
Date: Wed, 27 Nov 2013 23:27:24 -0500
Message-Id: <1385612844-22482-5-git-send-email-thomas.behan@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1385612844-22482-1-git-send-email-thomas.behan@gmail.com>
References: <1385612844-22482-1-git-send-email-thomas.behan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

checkpatch.pl generated 2 warning due to "sizeof x" being used instead of
"sizeof(x)". These warnings have been fixed.

Signed-off-by: Thomas Behan <thomas.behan@gmail.com>
---
 drivers/spi/spi-omap-100k.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/spi/spi-omap-100k.c b/drivers/spi/spi-omap-100k.c
index fcd783c..2516379 100644
--- a/drivers/spi/spi-omap-100k.c
+++ b/drivers/spi/spi-omap-100k.c
@@ -294,7 +294,7 @@ static int omap1_spi100k_setup(struct spi_device *spi)
 	spi100k = spi_master_get_devdata(spi->master);
 
 	if (!cs) {
-		cs = kzalloc(sizeof *cs, GFP_KERNEL);
+		cs = kzalloc(sizeof(*cs), GFP_KERNEL);
 		if (!cs)
 			return -ENOMEM;
 		cs->base = spi100k->base + spi->chip_select * 0x14;
@@ -411,7 +411,7 @@ static int omap1_spi100k_probe(struct platform_device *pdev)
 	if (!pdev->id)
 		return -EINVAL;
 
-	master = spi_alloc_master(&pdev->dev, sizeof *spi100k);
+	master = spi_alloc_master(&pdev->dev, sizeof(*spi100k));
 	if (master == NULL) {
 		dev_dbg(&pdev->dev, "master allocation failed\n");
 		return -ENOMEM;
-- 
1.8.1.2

