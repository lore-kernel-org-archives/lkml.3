Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934214Ab3GWSEZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 14:04:25 -0400
Received: from sauhun.de ([89.238.76.85]:51159 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934142Ab3GWSEV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 14:04:21 -0400
From: Wolfram Sang <wsa@the-dreams.de>
To: linux-kernel@vger.kernel.org
Cc: Wolfram Sang <wsa@the-dreams.de>, Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, Stephen Warren <swarren@wwwdotorg.org>,
        alsa-devel@alsa-project.org, linux-tegra@vger.kernel.org
Subject: [PATCH 25/27] sound/soc/tegra: don't check resource with devm_ioremap_resource
Date: Tue, 23 Jul 2013 20:01:58 +0200
Message-Id: <1374602524-3398-26-git-send-email-wsa@the-dreams.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1374602524-3398-1-git-send-email-wsa@the-dreams.de>
References: <1374602524-3398-1-git-send-email-wsa@the-dreams.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

devm_ioremap_resource does sanity checks on the given resource. No need to
duplicate this in the driver.

Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
---
Please apply via the subsystem-tree.

 sound/soc/tegra/tegra20_ac97.c |    7 -------
 1 file changed, 7 deletions(-)

diff --git a/sound/soc/tegra/tegra20_ac97.c b/sound/soc/tegra/tegra20_ac97.c
index e58233f..ef3d0e0 100644
--- a/sound/soc/tegra/tegra20_ac97.c
+++ b/sound/soc/tegra/tegra20_ac97.c
@@ -334,12 +334,6 @@ static int tegra20_ac97_platform_probe(struct platform_device *pdev)
 	}
 
 	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!mem) {
-		dev_err(&pdev->dev, "No memory resource\n");
-		ret = -ENODEV;
-		goto err_clk_put;
-	}
-
 	regs = devm_ioremap_resource(&pdev->dev, mem);
 	if (IS_ERR(regs)) {
 		ret = PTR_ERR(regs);
@@ -432,7 +426,6 @@ static int tegra20_ac97_platform_probe(struct platform_device *pdev)
 
 	return 0;
 
-err_unregister_pcm:
 	tegra_pcm_platform_unregister(&pdev->dev);
 err_unregister_component:
 	snd_soc_unregister_component(&pdev->dev);
-- 
1.7.10.4

