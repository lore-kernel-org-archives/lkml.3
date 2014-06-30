Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755882AbaF3MKt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 08:10:49 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:52003 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753514AbaF3LxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 07:53:25 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Mark Brown <broonie@linaro.org>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 068/181] ASoC: tlv320aci3x: Fix custom snd_soc_dapm_put_volsw_aic3x() function
Date: Mon, 30 Jun 2014 13:51:29 +0200
Message-Id: <0cb15869e8aa77842e42dc0c3b3723970751f104.1404128998.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
References: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
In-Reply-To: <cover.1404128997.git.jslaby@suse.cz>
References: <cover.1404128997.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Ujfalusi <peter.ujfalusi@ti.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit e6c111fac4464e3f4bf7b3802b517dafc80f8e0f upstream.

For some unknown reason the parameters for snd_soc_test_bits() were in wrong
order:
It was:
snd_soc_test_bits(codec, val, mask, reg); /* WRONG!!! */
while it should be:
snd_soc_test_bits(codec, reg, mask, val);

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
Signed-off-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 sound/soc/codecs/tlv320aic3x.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/tlv320aic3x.c b/sound/soc/codecs/tlv320aic3x.c
index 64ad84d8a306..11c8d1fe9222 100644
--- a/sound/soc/codecs/tlv320aic3x.c
+++ b/sound/soc/codecs/tlv320aic3x.c
@@ -164,7 +164,7 @@ static int snd_soc_dapm_put_volsw_aic3x(struct snd_kcontrol *kcontrol,
 	mask <<= shift;
 	val <<= shift;
 
-	change = snd_soc_test_bits(codec, val, mask, reg);
+	change = snd_soc_test_bits(codec, reg, mask, val);
 	if (change) {
 		update.kcontrol = kcontrol;
 		update.reg = reg;
-- 
2.0.0

