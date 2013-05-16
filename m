Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753084Ab3EPLPp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 07:15:45 -0400
Received: from sauhun.de ([89.238.76.85]:56296 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753056Ab3EPLPm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 07:15:42 -0400
From: Wolfram Sang <wsa@the-dreams.de>
To: linux-kernel@vger.kernel.org
Cc: Wolfram Sang <wsa@the-dreams.de>, Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org
Subject: [PATCH 33/33] sound/soc/kirkwood: don't check resource with devm_ioremap_resource
Date: Thu, 16 May 2013 13:16:01 +0200
Message-Id: <1368702961-4325-34-git-send-email-wsa@the-dreams.de>
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
 sound/soc/kirkwood/kirkwood-i2s.c |    5 -----
 1 file changed, 5 deletions(-)

diff --git a/sound/soc/kirkwood/kirkwood-i2s.c b/sound/soc/kirkwood/kirkwood-i2s.c
index befe68f..4c9dad3 100644
--- a/sound/soc/kirkwood/kirkwood-i2s.c
+++ b/sound/soc/kirkwood/kirkwood-i2s.c
@@ -471,11 +471,6 @@ static int kirkwood_i2s_dev_probe(struct platform_device *pdev)
 	dev_set_drvdata(&pdev->dev, priv);
 
 	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!mem) {
-		dev_err(&pdev->dev, "platform_get_resource failed\n");
-		return -ENXIO;
-	}
-
 	priv->io = devm_ioremap_resource(&pdev->dev, mem);
 	if (IS_ERR(priv->io))
 		return PTR_ERR(priv->io);
-- 
1.7.10.4

