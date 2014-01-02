Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752956AbaABRHk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 12:07:40 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:40306 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752798AbaABRHh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 12:07:37 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mark Brown <broonie@linaro.org>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 62/91] ASoC: wm8990: Mark the register map as dirty when powering down
Date: Thu,  2 Jan 2014 09:04:37 -0800
Message-Id: <1388682306-30859-63-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1388682306-30859-1-git-send-email-kamal@canonical.com>
References: <1388682306-30859-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.15 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Brown <broonie@linaro.org>

commit 2ab2b74277a86afe0dd92976db695a2bb8b93366 upstream.

Otherwise we'll skip sync on resume.

Signed-off-by: Mark Brown <broonie@linaro.org>
Acked-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 sound/soc/codecs/wm8990.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/soc/codecs/wm8990.c b/sound/soc/codecs/wm8990.c
index 837978e..ded9ed8 100644
--- a/sound/soc/codecs/wm8990.c
+++ b/sound/soc/codecs/wm8990.c
@@ -1264,6 +1264,8 @@ static int wm8990_set_bias_level(struct snd_soc_codec *codec,
 
 		/* disable POBCTRL, SOFT_ST and BUFDCOPEN */
 		snd_soc_write(codec, WM8990_ANTIPOP2, 0x0);
+
+		codec->cache_sync = 1;
 		break;
 	}
 
-- 
1.8.3.2

