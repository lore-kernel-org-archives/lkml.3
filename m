Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759647AbbA2LWS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 06:22:18 -0500
Received: from mail.lysator.liu.se ([130.236.254.3]:51386 "EHLO
	mail.lysator.liu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759025AbbA2LWO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 06:22:14 -0500
From: Peter Rosin <peda@lysator.liu.se>
To: alsa-devel@alsa-project.org
Cc: Peter Rosin <peda@axentia.se>, Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, Lars-Peter Clausen <lars@metafoo.de>,
        kbuild test robot <fengguang.wu@intel.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] ASoC: pcm512x: Fixup warning splat
Date: Thu, 29 Jan 2015 12:21:55 +0100
Message-Id: <1422530516-21779-2-git-send-email-peda@lysator.liu.se>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1422530516-21779-1-git-send-email-peda@lysator.liu.se>
References: <1422530516-21779-1-git-send-email-peda@lysator.liu.se>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Rosin <peda@axentia.se>

Reported-by: kbuild test robot <fengguang.wu@intel.com>
Signed-off-by: Peter Rosin <peda@axentia.se>
---
 sound/soc/codecs/pcm512x.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/pcm512x.c b/sound/soc/codecs/pcm512x.c
index 51b279e3f465..067d11743c31 100644
--- a/sound/soc/codecs/pcm512x.c
+++ b/sound/soc/codecs/pcm512x.c
@@ -1266,7 +1266,6 @@ int pcm512x_probe(struct device *dev, struct regmap *regmap)
 {
 	struct pcm512x_priv *pcm512x;
 	int i, ret;
-	u32 val;
 
 	pcm512x = devm_kzalloc(dev, sizeof(struct pcm512x_priv), GFP_KERNEL);
 	if (!pcm512x)
@@ -1347,6 +1346,7 @@ int pcm512x_probe(struct device *dev, struct regmap *regmap)
 #ifdef CONFIG_OF
 	if (dev->of_node) {
 		const struct device_node *np = dev->of_node;
+		u32 val;
 
 		if (of_property_read_u32(np, "pll-in", &val) >= 0) {
 			if (val > 6) {
-- 
1.7.10.4

