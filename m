Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757119Ab3HQAfY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 20:35:24 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51294 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753278Ab3HPWfL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 18:35:11 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Chih-Chung Chang <chihchung@chromium.org>,
        Dylan Reid <dgreid@chromium.org>, Mark Brown <broonie@linaro.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 004/133] ASoC: max98088 - fix element type of the register cache.
Date: Fri, 16 Aug 2013 15:32:26 -0700
Message-Id: <1376692475-28413-5-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1376692475-28413-1-git-send-email-kamal@canonical.com>
References: <1376692475-28413-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chih-Chung Chang <chihchung@chromium.org>

commit cb6f66a2d278e57a6c9d8fb59bd9ebd8ab3965c2 upstream.

The registers of max98088 are 8 bits, not 16 bits. This bug causes the
contents of registers to be overwritten with bad values when the codec
is suspended and then resumed.

Signed-off-by: Chih-Chung Chang <chihchung@chromium.org>
Signed-off-by: Dylan Reid <dgreid@chromium.org>
Signed-off-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 sound/soc/codecs/max98088.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/max98088.c b/sound/soc/codecs/max98088.c
index 5d36319..6c9e662 100644
--- a/sound/soc/codecs/max98088.c
+++ b/sound/soc/codecs/max98088.c
@@ -1594,7 +1594,7 @@ static int max98088_dai2_digital_mute(struct snd_soc_dai *codec_dai, int mute)
 
 static void max98088_sync_cache(struct snd_soc_codec *codec)
 {
-       u16 *reg_cache = codec->reg_cache;
+       u8 *reg_cache = codec->reg_cache;
        int i;
 
        if (!codec->cache_sync)
-- 
1.8.1.2

