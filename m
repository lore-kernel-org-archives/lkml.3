Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932979Ab3EGD6r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 23:58:47 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:22102 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932515Ab3EGD6n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 23:58:43 -0400
X-Authority-Analysis: v=2.0 cv=DKcNElxb c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=d0mmdRbi76QA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=whEldvPL0mQA:10 a=wggVRkVUAAAA:8 a=VwQbUJbxAAAA:8 a=fC4T7qsy4_4xvlMS5R0A:9 a=XNN-oNMjSfgA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130507035841.074675429@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 06 May 2013 23:57:13 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Sascha Hauer <s.hauer@pengutronix.de>,
        Markus Pargmann <mpa@pengutronix.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [001/126] ASoC: imx-ssi: Fix occasional AC97 reset failure
References: <20130507035712.909872333@goodmis.org>
Content-Disposition: inline; filename=0001-ASoC-imx-ssi-Fix-occasional-AC97-reset-failure.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.3 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Sascha Hauer <s.hauer@pengutronix.de>

[ Upstream commit b6e51600f4e983e757b1b6942becaa1ae7d82e67 ]

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
Signed-off-by: Markus Pargmann <mpa@pengutronix.de>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: stable@vger.kernel.org
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 sound/soc/fsl/imx-ssi.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/sound/soc/fsl/imx-ssi.c b/sound/soc/fsl/imx-ssi.c
index 81d7728..5b8140b 100644
--- a/sound/soc/fsl/imx-ssi.c
+++ b/sound/soc/fsl/imx-ssi.c
@@ -498,6 +498,8 @@ static void imx_ssi_ac97_reset(struct snd_ac97 *ac97)
 
 	if (imx_ssi->ac97_reset)
 		imx_ssi->ac97_reset(ac97);
+	/* First read sometimes fails, do a dummy read */
+	imx_ssi_ac97_read(ac97, 0);
 }
 
 static void imx_ssi_ac97_warm_reset(struct snd_ac97 *ac97)
@@ -506,6 +508,9 @@ static void imx_ssi_ac97_warm_reset(struct snd_ac97 *ac97)
 
 	if (imx_ssi->ac97_warm_reset)
 		imx_ssi->ac97_warm_reset(ac97);
+
+	/* First read sometimes fails, do a dummy read */
+	imx_ssi_ac97_read(ac97, 0);
 }
 
 struct snd_ac97_bus_ops soc_ac97_ops = {
-- 
1.7.10.4


