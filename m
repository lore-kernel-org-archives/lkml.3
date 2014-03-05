Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757675AbaCEO1E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 09:27:04 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41249 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757653AbaCEO1B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 09:27:01 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Lars-Peter Clausen <lars@metafoo.de>, Mark Brown <broonie@linaro.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 109/131] ASoC: wm8958-dsp: Fix firmware block loading
Date: Wed,  5 Mar 2014 14:23:53 +0000
Message-Id: <1394029455-23128-110-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1394029455-23128-1-git-send-email-luis.henriques@canonical.com>
References: <1394029455-23128-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.6 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
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
1.9.0

