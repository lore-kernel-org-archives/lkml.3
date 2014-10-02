Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752064AbaJBH1I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 03:27:08 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:61397 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751017AbaJBH1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 03:27:07 -0400
From: Thierry Reding <thierry.reding@gmail.com>
To: Mark Brown <broonie@kernel.org>
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ASoC: rt286: Fix compilation warning for !PM
Date: Thu,  2 Oct 2014 09:27:03 +0200
Message-Id: <1412234823-31433-1-git-send-email-thierry.reding@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

The rt286_index_sync() function is only called in the resume path. If PM
is disabled it becomes unused and shouldn't be built either.

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 sound/soc/codecs/rt286.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/soc/codecs/rt286.c b/sound/soc/codecs/rt286.c
index b86b426f159d..4aa555cbcca8 100644
--- a/sound/soc/codecs/rt286.c
+++ b/sound/soc/codecs/rt286.c
@@ -269,6 +269,7 @@ static int rt286_hw_read(void *context, unsigned int reg, unsigned int *value)
 	return 0;
 }
 
+#ifdef CONFIG_PM
 static void rt286_index_sync(struct snd_soc_codec *codec)
 {
 	struct rt286_priv *rt286 = snd_soc_codec_get_drvdata(codec);
@@ -279,6 +280,7 @@ static void rt286_index_sync(struct snd_soc_codec *codec)
 				  rt286->index_cache[i].def);
 	}
 }
+#endif
 
 static int rt286_support_power_controls[] = {
 	RT286_DAC_OUT1,
-- 
2.1.0

