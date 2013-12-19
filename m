Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753381Ab3LSJSM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 04:18:12 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:55177 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751832Ab3LSJSI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 04:18:08 -0500
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: lee.jones@linaro.org
Cc: broonie@kernel.org, sameo@linux.intel.com, lgirdwood@gmail.com,
        patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org
Subject: [PATCH 2/2] ASoC: wm5110: Expose switch controls for DRE
Date: Thu, 19 Dec 2013 09:11:02 +0000
Message-Id: <1387444262-26456-2-git-send-email-ckeepax@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1387444262-26456-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
References: <1387444262-26456-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Certain use-cases require the DRE to be disabled so expose controls for
the enables.

Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
---
 sound/soc/codecs/wm5110.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/sound/soc/codecs/wm5110.c b/sound/soc/codecs/wm5110.c
index 7fb8599..3fb9abb 100644
--- a/sound/soc/codecs/wm5110.c
+++ b/sound/soc/codecs/wm5110.c
@@ -346,6 +346,13 @@ SOC_DOUBLE("SPKDAT1 Switch", ARIZONA_PDM_SPK1_CTRL_1, ARIZONA_SPK1L_MUTE_SHIFT,
 SOC_DOUBLE("SPKDAT2 Switch", ARIZONA_PDM_SPK2_CTRL_1, ARIZONA_SPK2L_MUTE_SHIFT,
 	   ARIZONA_SPK2R_MUTE_SHIFT, 1, 1),
 
+SOC_DOUBLE("HPOUT1 DRE Switch", ARIZONA_DRE_ENABLE,
+	   ARIZONA_DRE1L_ENA_SHIFT, ARIZONA_DRE1R_ENA_SHIFT, 1, 0),
+SOC_DOUBLE("HPOUT2 DRE Switch", ARIZONA_DRE_ENABLE,
+	   ARIZONA_DRE2L_ENA_SHIFT, ARIZONA_DRE2R_ENA_SHIFT, 1, 0),
+SOC_DOUBLE("HPOUT3 DRE Switch", ARIZONA_DRE_ENABLE,
+	   ARIZONA_DRE3L_ENA_SHIFT, ARIZONA_DRE3R_ENA_SHIFT, 1, 0),
+
 SOC_ENUM("Output Ramp Up", arizona_out_vi_ramp),
 SOC_ENUM("Output Ramp Down", arizona_out_vd_ramp),
 
-- 
1.7.2.5

