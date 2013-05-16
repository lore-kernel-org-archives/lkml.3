Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753118Ab3EPLPr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 07:15:47 -0400
Received: from sauhun.de ([89.238.76.85]:56288 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752720Ab3EPLPl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 07:15:41 -0400
From: Wolfram Sang <wsa@the-dreams.de>
To: linux-kernel@vger.kernel.org
Cc: Wolfram Sang <wsa@the-dreams.de>, Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org
Subject: [PATCH 32/33] sound/soc/fsl: don't check resource with devm_ioremap_resource
Date: Thu, 16 May 2013 13:16:00 +0200
Message-Id: <1368702961-4325-33-git-send-email-wsa@the-dreams.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1368702961-4325-1-git-send-email-wsa@the-dreams.de>
References: <1368702961-4325-1-git-send-email-wsa@the-dreams.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

devm_ioremap_resource does sanity checks on the given resource. No need to
duplicate this in the driver.

Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
---
 sound/soc/fsl/imx-ssi.c |    6 ------
 1 file changed, 6 deletions(-)

diff --git a/sound/soc/fsl/imx-ssi.c b/sound/soc/fsl/imx-ssi.c
index 902fab0..c6fa03e 100644
--- a/sound/soc/fsl/imx-ssi.c
+++ b/sound/soc/fsl/imx-ssi.c
@@ -540,11 +540,6 @@ static int imx_ssi_probe(struct platform_device *pdev)
 	clk_prepare_enable(ssi->clk);
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res) {
-		ret = -ENODEV;
-		goto failed_get_resource;
-	}
-
 	ssi->base = devm_ioremap_resource(&pdev->dev, res);
 	if (IS_ERR(ssi->base)) {
 		ret = PTR_ERR(ssi->base);
@@ -633,7 +628,6 @@ failed_pdev_fiq_alloc:
 	snd_soc_unregister_component(&pdev->dev);
 failed_register:
 	release_mem_region(res->start, resource_size(res));
-failed_get_resource:
 	clk_disable_unprepare(ssi->clk);
 failed_clk:
 
-- 
1.7.10.4

