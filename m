Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755712AbaCYRu7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 13:50:59 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55755 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754603AbaCYRU1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 13:20:27 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Takashi Iwai <tiwai@suse.de>, Mark Brown <broonie@linaro.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 72/81] ASoC: sta32x: Fix wrong enum for limiter2 release rate
Date: Tue, 25 Mar 2014 10:16:25 -0700
Message-Id: <1395767794-5012-73-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1395767794-5012-1-git-send-email-kamal@canonical.com>
References: <1395767794-5012-1-git-send-email-kamal@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.20 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit b3619b288b621e63f66908045f48495869a996a6 upstream.

There is a typo in the Limiter2 Release Rate control, a wrong enum for
Limiter1 is assigned.  It must point to Limiter2.
Spotted by a compile warning:

In file included from sound/soc/codecs/sta32x.c:34:0:
sound/soc/codecs/sta32x.c:223:29: warning: ‘sta32x_limiter2_release_rate_enum’ defined but not used [-Wunused-variable]
 static SOC_ENUM_SINGLE_DECL(sta32x_limiter2_release_rate_enum,
                             ^
include/sound/soc.h:275:18: note: in definition of macro ‘SOC_ENUM_DOUBLE_DECL’
  struct soc_enum name = SOC_ENUM_DOUBLE(xreg, xshift_l, xshift_r, \
                  ^
sound/soc/codecs/sta32x.c:223:8: note: in expansion of macro ‘SOC_ENUM_SINGLE_DECL’
 static SOC_ENUM_SINGLE_DECL(sta32x_limiter2_release_rate_enum,
        ^

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 sound/soc/codecs/sta32x.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/sta32x.c b/sound/soc/codecs/sta32x.c
index 4d8a3ae..8517e70 100644
--- a/sound/soc/codecs/sta32x.c
+++ b/sound/soc/codecs/sta32x.c
@@ -432,7 +432,7 @@ SOC_SINGLE_TLV("Treble Tone Control", STA32X_TONE, STA32X_TONE_TTC_SHIFT, 15, 0,
 SOC_ENUM("Limiter1 Attack Rate (dB/ms)", sta32x_limiter1_attack_rate_enum),
 SOC_ENUM("Limiter2 Attack Rate (dB/ms)", sta32x_limiter2_attack_rate_enum),
 SOC_ENUM("Limiter1 Release Rate (dB/ms)", sta32x_limiter1_release_rate_enum),
-SOC_ENUM("Limiter2 Release Rate (dB/ms)", sta32x_limiter1_release_rate_enum),
+SOC_ENUM("Limiter2 Release Rate (dB/ms)", sta32x_limiter2_release_rate_enum),
 
 /* depending on mode, the attack/release thresholds have
  * two different enum definitions; provide both
-- 
1.8.3.2

