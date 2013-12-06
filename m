Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161516Ab3LFXMu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 18:12:50 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:48458 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161413Ab3LFXMj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 18:12:39 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Phil Edworthy <phil.edworthy@renesas.com>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Mark Brown <broonie@linaro.org>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 042/152] ASoC: ak4642: prevent un-necessary changes to SG_SL1
Date: Fri,  6 Dec 2013 15:09:26 -0800
Message-Id: <1386371476-2477-43-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386371476-2477-1-git-send-email-kamal@canonical.com>
References: <1386371476-2477-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.14 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Phil Edworthy <phil.edworthy@renesas.com>

commit 7b5bfb82882b9b1c8423ce0ed6852ca3762d967a upstream.

If you record the sound during playback,
the playback sound becomes silent.
Modify so that the codec driver does not clear
SG_SL1::DACL bit which is controlled under widget

Signed-off-by: Phil Edworthy <phil.edworthy@renesas.com>
Signed-off-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Signed-off-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 sound/soc/codecs/ak4642.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/ak4642.c b/sound/soc/codecs/ak4642.c
index 1f0cdab..1e09512 100644
--- a/sound/soc/codecs/ak4642.c
+++ b/sound/soc/codecs/ak4642.c
@@ -256,7 +256,7 @@ static int ak4642_dai_startup(struct snd_pcm_substream *substream,
 		 * This operation came from example code of
 		 * "ASAHI KASEI AK4642" (japanese) manual p94.
 		 */
-		snd_soc_write(codec, SG_SL1, PMMP | MGAIN0);
+		snd_soc_update_bits(codec, SG_SL1, PMMP | MGAIN0, PMMP | MGAIN0);
 		snd_soc_write(codec, TIMER, ZTM(0x3) | WTM(0x3));
 		snd_soc_write(codec, ALC_CTL1, ALC | LMTH0);
 		snd_soc_update_bits(codec, PW_MGMT1, PMADL, PMADL);
-- 
1.8.3.2

