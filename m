Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934156Ab3GWSEB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 14:04:01 -0400
Received: from sauhun.de ([89.238.76.85]:51131 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933763Ab3GWSD6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 14:03:58 -0400
From: Wolfram Sang <wsa@the-dreams.de>
To: linux-kernel@vger.kernel.org
Cc: Wolfram Sang <wsa@the-dreams.de>, Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org
Subject: [PATCH 21/27] sound/soc/au1x: don't check resource with devm_ioremap_resource
Date: Tue, 23 Jul 2013 20:01:54 +0200
Message-Id: <1374602524-3398-22-git-send-email-wsa@the-dreams.de>
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

 sound/soc/au1x/psc-ac97.c |    3 ---
 1 file changed, 3 deletions(-)

diff --git a/sound/soc/au1x/psc-ac97.c b/sound/soc/au1x/psc-ac97.c
index a822ab8..986dcec 100644
--- a/sound/soc/au1x/psc-ac97.c
+++ b/sound/soc/au1x/psc-ac97.c
@@ -379,9 +379,6 @@ static int au1xpsc_ac97_drvprobe(struct platform_device *pdev)
 	mutex_init(&wd->lock);
 
 	iores = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!iores)
-		return -ENODEV;
-
 	wd->mmio = devm_ioremap_resource(&pdev->dev, iores);
 	if (IS_ERR(wd->mmio))
 		return PTR_ERR(wd->mmio);
-- 
1.7.10.4

