Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755728AbaCYRgk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 13:36:40 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55938 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755126AbaCYRV7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 13:21:59 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Lars-Peter Clausen <lars@metafoo.de>, Mark Brown <broonie@linaro.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 58/81] ASoC: sta32x: Fix cache sync
Date: Tue, 25 Mar 2014 10:16:11 -0700
Message-Id: <1395767794-5012-59-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1395767794-5012-1-git-send-email-kamal@canonical.com>
References: <1395767794-5012-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.20 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lars-Peter Clausen <lars@metafoo.de>

commit 70ff00f82a6af0ff68f8f7b411738634ce2f20d0 upstream.

codec->control_data contains a pointer to the regmap struct of the device, not
to the device private data. Use snd_soc_codec_get_drvdata() instead.

The issue was introduced in commit 29fdf4fbbe ("ASoC: sta32x: Convert to
regmap").

Fixes: 29fdf4fbbe (ASoC: sta32x: Convert to regmap)
Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Signed-off-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 sound/soc/codecs/sta32x.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/sta32x.c b/sound/soc/codecs/sta32x.c
index dc5e7f5..4d8a3ae 100644
--- a/sound/soc/codecs/sta32x.c
+++ b/sound/soc/codecs/sta32x.c
@@ -331,7 +331,7 @@ static int sta32x_sync_coef_shadow(struct snd_soc_codec *codec)
 
 static int sta32x_cache_sync(struct snd_soc_codec *codec)
 {
-	struct sta32x_priv *sta32x = codec->control_data;
+	struct sta32x_priv *sta32x = snd_soc_codec_get_drvdata(codec);
 	unsigned int mute;
 	int rc;
 
-- 
1.8.3.2

