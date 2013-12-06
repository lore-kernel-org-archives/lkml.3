Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162207Ab3LFN0Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 08:26:16 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44483 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758284Ab3LFNDz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 08:03:55 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Nariman Poushin <nariman@opensource.wolfsonmicro.com>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Mark Brown <broonie@linaro.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 196/272] ASoC: wm_adsp: Interpret ADSP memory region lengths as 32 bit words
Date: Fri,  6 Dec 2013 12:58:05 +0000
Message-Id: <1386334761-25517-197-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
References: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nariman Poushin <nariman@opensource.wolfsonmicro.com>

commit c01422a4a184a183b03fb3046af88d61828f6d56 upstream.

Pad the ADSP word (3 bytes) to 4 bytes in the kernel and calculate
lengths based on padded ADSP words instead of treating them as bytes

Signed-off-by: Nariman Poushin <nariman@opensource.wolfsonmicro.com>
Signed-off-by: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
Signed-off-by: Mark Brown <broonie@linaro.org>
[ luis: backported to 3.11: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 sound/soc/codecs/wm_adsp.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/sound/soc/codecs/wm_adsp.c b/sound/soc/codecs/wm_adsp.c
index 05252ac..d1c59b6 100644
--- a/sound/soc/codecs/wm_adsp.c
+++ b/sound/soc/codecs/wm_adsp.c
@@ -1091,6 +1091,7 @@ static int wm_adsp_setup_algs(struct wm_adsp *dsp, struct snd_soc_codec *codec)
 			if (i + 1 < algs) {
 				region->len = be32_to_cpu(adsp1_alg[i + 1].dm);
 				region->len -= be32_to_cpu(adsp1_alg[i].dm);
+				region->len *= 4;
 				wm_adsp_create_control(codec, region);
 			} else {
 				adsp_warn(dsp, "Missing length info for region DM with ID %x\n",
@@ -1108,6 +1109,7 @@ static int wm_adsp_setup_algs(struct wm_adsp *dsp, struct snd_soc_codec *codec)
 			if (i + 1 < algs) {
 				region->len = be32_to_cpu(adsp1_alg[i + 1].zm);
 				region->len -= be32_to_cpu(adsp1_alg[i].zm);
+				region->len *= 4;
 				wm_adsp_create_control(codec, region);
 			} else {
 				adsp_warn(dsp, "Missing length info for region ZM with ID %x\n",
@@ -1137,6 +1139,7 @@ static int wm_adsp_setup_algs(struct wm_adsp *dsp, struct snd_soc_codec *codec)
 			if (i + 1 < algs) {
 				region->len = be32_to_cpu(adsp2_alg[i + 1].xm);
 				region->len -= be32_to_cpu(adsp2_alg[i].xm);
+				region->len *= 4;
 				wm_adsp_create_control(codec, region);
 			} else {
 				adsp_warn(dsp, "Missing length info for region XM with ID %x\n",
@@ -1154,6 +1157,7 @@ static int wm_adsp_setup_algs(struct wm_adsp *dsp, struct snd_soc_codec *codec)
 			if (i + 1 < algs) {
 				region->len = be32_to_cpu(adsp2_alg[i + 1].ym);
 				region->len -= be32_to_cpu(adsp2_alg[i].ym);
+				region->len *= 4;
 				wm_adsp_create_control(codec, region);
 			} else {
 				adsp_warn(dsp, "Missing length info for region YM with ID %x\n",
@@ -1171,6 +1175,7 @@ static int wm_adsp_setup_algs(struct wm_adsp *dsp, struct snd_soc_codec *codec)
 			if (i + 1 < algs) {
 				region->len = be32_to_cpu(adsp2_alg[i + 1].zm);
 				region->len -= be32_to_cpu(adsp2_alg[i].zm);
+				region->len *= 4;
 				wm_adsp_create_control(codec, region);
 			} else {
 				adsp_warn(dsp, "Missing length info for region ZM with ID %x\n",
-- 
1.8.3.2

