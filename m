Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755437Ab3LBUZw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 15:25:52 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39018 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753454Ab3LBTQ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:16:58 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Nariman Poushin <nariman@opensource.wolfsonmicro.com>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Mark Brown <broonie@linaro.org>
Subject: [PATCH 3.12 018/212] ASoC: wm_adsp: Interpret ADSP memory region lengths as 32 bit words
Date: Mon,  2 Dec 2013 11:13:29 -0800
Message-Id: <20131202191250.705483362@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131202191248.517975703@linuxfoundation.org>
References: <20131202191248.517975703@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nariman Poushin <nariman@opensource.wolfsonmicro.com>

commit c01422a4a184a183b03fb3046af88d61828f6d56 upstream.

Pad the ADSP word (3 bytes) to 4 bytes in the kernel and calculate
lengths based on padded ADSP words instead of treating them as bytes

Signed-off-by: Nariman Poushin <nariman@opensource.wolfsonmicro.com>
Signed-off-by: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
Signed-off-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/codecs/wm_adsp.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/sound/soc/codecs/wm_adsp.c
+++ b/sound/soc/codecs/wm_adsp.c
@@ -1062,6 +1062,7 @@ static int wm_adsp_setup_algs(struct wm_
 			if (i + 1 < algs) {
 				region->len = be32_to_cpu(adsp1_alg[i + 1].dm);
 				region->len -= be32_to_cpu(adsp1_alg[i].dm);
+				region->len *= 4;
 				wm_adsp_create_control(dsp, region);
 			} else {
 				adsp_warn(dsp, "Missing length info for region DM with ID %x\n",
@@ -1079,6 +1080,7 @@ static int wm_adsp_setup_algs(struct wm_
 			if (i + 1 < algs) {
 				region->len = be32_to_cpu(adsp1_alg[i + 1].zm);
 				region->len -= be32_to_cpu(adsp1_alg[i].zm);
+				region->len *= 4;
 				wm_adsp_create_control(dsp, region);
 			} else {
 				adsp_warn(dsp, "Missing length info for region ZM with ID %x\n",
@@ -1108,6 +1110,7 @@ static int wm_adsp_setup_algs(struct wm_
 			if (i + 1 < algs) {
 				region->len = be32_to_cpu(adsp2_alg[i + 1].xm);
 				region->len -= be32_to_cpu(adsp2_alg[i].xm);
+				region->len *= 4;
 				wm_adsp_create_control(dsp, region);
 			} else {
 				adsp_warn(dsp, "Missing length info for region XM with ID %x\n",
@@ -1125,6 +1128,7 @@ static int wm_adsp_setup_algs(struct wm_
 			if (i + 1 < algs) {
 				region->len = be32_to_cpu(adsp2_alg[i + 1].ym);
 				region->len -= be32_to_cpu(adsp2_alg[i].ym);
+				region->len *= 4;
 				wm_adsp_create_control(dsp, region);
 			} else {
 				adsp_warn(dsp, "Missing length info for region YM with ID %x\n",
@@ -1142,6 +1146,7 @@ static int wm_adsp_setup_algs(struct wm_
 			if (i + 1 < algs) {
 				region->len = be32_to_cpu(adsp2_alg[i + 1].zm);
 				region->len -= be32_to_cpu(adsp2_alg[i].zm);
+				region->len *= 4;
 				wm_adsp_create_control(dsp, region);
 			} else {
 				adsp_warn(dsp, "Missing length info for region ZM with ID %x\n",


