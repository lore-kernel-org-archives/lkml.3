Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934187Ab3GWSEP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 14:04:15 -0400
Received: from sauhun.de ([89.238.76.85]:51144 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934158Ab3GWSEN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 14:04:13 -0400
From: Wolfram Sang <wsa@the-dreams.de>
To: linux-kernel@vger.kernel.org
Cc: Wolfram Sang <wsa@the-dreams.de>, Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org
Subject: [PATCH 23/27] sound/soc/nuc900: don't check resource with devm_ioremap_resource
Date: Tue, 23 Jul 2013 20:01:56 +0200
Message-Id: <1374602524-3398-24-git-send-email-wsa@the-dreams.de>
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

 sound/soc/nuc900/nuc900-ac97.c |    3 ---
 1 file changed, 3 deletions(-)

diff --git a/sound/soc/nuc900/nuc900-ac97.c b/sound/soc/nuc900/nuc900-ac97.c
index f4c2417..8987bf9 100644
--- a/sound/soc/nuc900/nuc900-ac97.c
+++ b/sound/soc/nuc900/nuc900-ac97.c
@@ -333,9 +333,6 @@ static int nuc900_ac97_drvprobe(struct platform_device *pdev)
 	spin_lock_init(&nuc900_audio->lock);
 
 	nuc900_audio->res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!nuc900_audio->res)
-		return ret;
-
 	nuc900_audio->mmio = devm_ioremap_resource(&pdev->dev,
 						   nuc900_audio->res);
 	if (IS_ERR(nuc900_audio->mmio))
-- 
1.7.10.4

