Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755443Ab3KYNQC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 08:16:02 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57254 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754722Ab3KYNIw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 08:08:52 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Phil Edworthy <phil.edworthy@renesas.com>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Mark Brown <broonie@linaro.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 57/78] ASoC: ak4642: prevent un-necessary changes to SG_SL1
Date: Mon, 25 Nov 2013 13:06:44 +0000
Message-Id: <1385384825-21681-58-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1385384825-21681-1-git-send-email-luis.henriques@canonical.com>
References: <1385384825-21681-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.26 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 sound/soc/codecs/ak4642.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/ak4642.c b/sound/soc/codecs/ak4642.c
index b3e24f2..7e4245f 100644
--- a/sound/soc/codecs/ak4642.c
+++ b/sound/soc/codecs/ak4642.c
@@ -262,7 +262,7 @@ static int ak4642_dai_startup(struct snd_pcm_substream *substream,
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

