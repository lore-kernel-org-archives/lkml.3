Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755254AbaCYRWa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 13:22:30 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55989 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754342AbaCYRWY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 13:22:24 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Lars-Peter Clausen <lars@metafoo.de>, Mark Brown <broonie@linaro.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 61/81] ASoC: wm8958-dsp: Fix firmware block loading
Date: Tue, 25 Mar 2014 10:16:14 -0700
Message-Id: <1395767794-5012-62-git-send-email-kamal@canonical.com>
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

commit 548da08fc1e245faf9b0d7c41ecd8e07984fc332 upstream.

The codec->control_data contains a pointer to the device's regmap struct. But
wm8994_bulk_write() expects a pointer to the parent wm8998 device.

The issue was introduced in commit d9a7666f ("ASoC: Remove ASoC-specific
WM8994 I/O code").

Fixes: d9a7666f ("ASoC: Remove ASoC-specific WM8994 I/O code")
Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Signed-off-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 sound/soc/codecs/wm8958-dsp2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/wm8958-dsp2.c b/sound/soc/codecs/wm8958-dsp2.c
index b0710d8..754f88e 100644
--- a/sound/soc/codecs/wm8958-dsp2.c
+++ b/sound/soc/codecs/wm8958-dsp2.c
@@ -153,7 +153,7 @@ static int wm8958_dsp2_fw(struct snd_soc_codec *codec, const char *name,
 
 			data32 &= 0xffffff;
 
-			wm8994_bulk_write(codec->control_data,
+			wm8994_bulk_write(wm8994->wm8994,
 					  data32 & 0xffffff,
 					  block_len / 2,
 					  (void *)(data + 8));
-- 
1.8.3.2

