Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932085Ab3CYOen (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 10:34:43 -0400
Received: from mail-ee0-f43.google.com ([74.125.83.43]:51373 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758386Ab3CYOem (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 10:34:42 -0400
From: Alexandru Gheorghiu <gheorghiuandru@gmail.com>
To: Liam Girdwood <lgirdwood@gmail.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        linux-kernel@vger.kernel.org,
        Alexandru Gheorghiu <gheorghiuandru@gmail.com>
Subject: [PATCH] sound: soc: Use PTR_RET function
Date: Mon, 25 Mar 2013 16:33:59 +0200
Message-Id: <1364222039-6829-1-git-send-email-gheorghiuandru@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Used PTR_RET function instead of IS_ERR and PTR_ERR.
Patch found using coccinelle.

Signed-off-by: Alexandru Gheorghiu <gheorghiuandru@gmail.com>
---
 sound/soc/soc-io.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/sound/soc/soc-io.c b/sound/soc/soc-io.c
index 29183ef..8ca9ecc 100644
--- a/sound/soc/soc-io.c
+++ b/sound/soc/soc-io.c
@@ -158,10 +158,7 @@ int snd_soc_codec_set_cache_io(struct snd_soc_codec *codec,
 		return -EINVAL;
 	}
 
-	if (IS_ERR(codec->control_data))
-		return PTR_ERR(codec->control_data);
-
-	return 0;
+	return PTR_RET(codec->control_data);
 }
 EXPORT_SYMBOL_GPL(snd_soc_codec_set_cache_io);
 #else
-- 
1.7.9.5

