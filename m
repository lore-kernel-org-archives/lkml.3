Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967012Ab3DRJle (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 05:41:34 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:39976 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756076Ab3DRJRQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 05:17:16 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Sascha Hauer <s.hauer@pengutronix.de>,
        Markus Pargmann <mpa@pengutronix.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 01/72] ASoC: imx-ssi: Fix occasional AC97 reset failure
Date: Thu, 18 Apr 2013 10:15:46 +0100
Message-Id: <1366276617-3553-2-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1366276617-3553-1-git-send-email-luis.henriques@canonical.com>
References: <1366276617-3553-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sascha Hauer <s.hauer@pengutronix.de>

commit b6e51600f4e983e757b1b6942becaa1ae7d82e67 upstream.

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
Signed-off-by: Markus Pargmann <mpa@pengutronix.de>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 sound/soc/fsl/imx-ssi.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/sound/soc/fsl/imx-ssi.c b/sound/soc/fsl/imx-ssi.c
index 28dd76c..83300fb 100644
--- a/sound/soc/fsl/imx-ssi.c
+++ b/sound/soc/fsl/imx-ssi.c
@@ -497,6 +497,8 @@ static void imx_ssi_ac97_reset(struct snd_ac97 *ac97)
 
 	if (imx_ssi->ac97_reset)
 		imx_ssi->ac97_reset(ac97);
+	/* First read sometimes fails, do a dummy read */
+	imx_ssi_ac97_read(ac97, 0);
 }
 
 static void imx_ssi_ac97_warm_reset(struct snd_ac97 *ac97)
@@ -505,6 +507,9 @@ static void imx_ssi_ac97_warm_reset(struct snd_ac97 *ac97)
 
 	if (imx_ssi->ac97_warm_reset)
 		imx_ssi->ac97_warm_reset(ac97);
+
+	/* First read sometimes fails, do a dummy read */
+	imx_ssi_ac97_read(ac97, 0);
 }
 
 struct snd_ac97_bus_ops soc_ac97_ops = {
-- 
1.8.1.2

