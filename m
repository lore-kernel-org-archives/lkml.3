Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754126AbaLMQ3d (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2014 11:29:33 -0500
Received: from syn.loicp.eu ([176.31.96.212]:52307 "EHLO mx0.loicp.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754075AbaLMQ3c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2014 11:29:32 -0500
Date: Sat, 13 Dec 2014 17:29:26 +0100
From: Loic Pefferkorn <loic@loicp.eu>
To: gregkh@linuxfoundation.org, alan@linux.intel.com, jun.j.tian@intel.com,
        octavian.purdila@intel.com, nnk@google.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: goldfish: Fix minor coding style
Message-ID: <e2a3b3ccf85790c865683832698908458931be6a.1418487651.git.loic@loicp.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

The convention for checking for NULL pointers is !ptr and not ptr == NULL.
This patch fixes such occurences in goldfish driver, it applies against next-20141212


Signed-off-by: Loic Pefferkorn <loic@loicp.eu>
---
 drivers/staging/goldfish/goldfish_audio.c |  8 ++++----
 drivers/staging/goldfish/goldfish_nand.c  | 10 +++++-----
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/goldfish/goldfish_audio.c b/drivers/staging/goldfish/goldfish_audio.c
index f200359..7ab034b 100644
--- a/drivers/staging/goldfish/goldfish_audio.c
+++ b/drivers/staging/goldfish/goldfish_audio.c
@@ -273,19 +273,19 @@ static int goldfish_audio_probe(struct platform_device *pdev)
 	dma_addr_t buf_addr;
 
 	data = devm_kzalloc(&pdev->dev, sizeof(*data), GFP_KERNEL);
-	if (data == NULL)
+	if (!data)
 		return -ENOMEM;
 	spin_lock_init(&data->lock);
 	init_waitqueue_head(&data->wait);
 	platform_set_drvdata(pdev, data);
 
 	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (r == NULL) {
+	if (!r) {
 		dev_err(&pdev->dev, "platform_get_resource failed\n");
 		return -ENODEV;
 	}
 	data->reg_base = devm_ioremap(&pdev->dev, r->start, PAGE_SIZE);
-	if (data->reg_base == NULL)
+	if (!data->reg_base)
 		return -ENOMEM;
 
 	data->irq = platform_get_irq(pdev, 0);
@@ -295,7 +295,7 @@ static int goldfish_audio_probe(struct platform_device *pdev)
 	}
 	data->buffer_virt = dmam_alloc_coherent(&pdev->dev,
 				COMBINED_BUFFER_SIZE, &buf_addr, GFP_KERNEL);
-	if (data->buffer_virt == NULL) {
+	if (!data->buffer_virt) {
 		dev_err(&pdev->dev, "allocate buffer failed\n");
 		return -ENOMEM;
 	}
diff --git a/drivers/staging/goldfish/goldfish_nand.c b/drivers/staging/goldfish/goldfish_nand.c
index d68f216..8e8e594 100644
--- a/drivers/staging/goldfish/goldfish_nand.c
+++ b/drivers/staging/goldfish/goldfish_nand.c
@@ -48,7 +48,7 @@ static u32 goldfish_nand_cmd_with_params(struct mtd_info *mtd,
 	struct cmd_params *cps = nand->cmd_params;
 	unsigned char __iomem  *base = nand->base;
 
-	if (cps == NULL)
+	if (!cps)
 		return -1;
 
 	switch (cmd) {
@@ -330,7 +330,7 @@ static int goldfish_nand_init_device(struct platform_device *pdev,
 	mtd->priv = nand;
 
 	name = devm_kzalloc(&pdev->dev, name_len + 1, GFP_KERNEL);
-	if (name == NULL)
+	if (!name)
 		return -ENOMEM;
 	mtd->name = name;
 
@@ -379,11 +379,11 @@ static int goldfish_nand_probe(struct platform_device *pdev)
 	unsigned char __iomem  *base;
 
 	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (r == NULL)
+	if (!r)
 		return -ENODEV;
 
 	base = devm_ioremap(&pdev->dev, r->start, PAGE_SIZE);
-	if (base == NULL)
+	if (!base)
 		return -ENOMEM;
 
 	version = readl(base + NAND_VERSION);
@@ -399,7 +399,7 @@ static int goldfish_nand_probe(struct platform_device *pdev)
 
 	nand = devm_kzalloc(&pdev->dev, sizeof(*nand) +
 				sizeof(struct mtd_info) * num_dev, GFP_KERNEL);
-	if (nand == NULL)
+	if (!nand)
 		return -ENOMEM;
 
 	mutex_init(&nand->lock);
-- 
2.1.3

