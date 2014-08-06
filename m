Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754740AbaHFNs7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 09:48:59 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:42941 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753451AbaHFNrm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 09:47:42 -0400
From: Jyri Sarha <jsarha@ti.com>
To: <linux-kernel@vger.kernel.org>, <mturquette@linaro.org>,
        <dri-devel@lists.freedesktop.org>, <airlied@linux.ie>,
        <linux-omap@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <bcousson@baylibre.com>
CC: <tony@atomide.com>, <broonie@kernel.org>,
        <liam.r.girdwood@linux.intel.com>, <peter.ujfalusi@ti.com>,
        <detheridge@ti.com>, <zonque@gmail.com>, <t-kristo@ti.com>,
        Jyri Sarha <jsarha@ti.com>
Subject: [PATCH 5/9] ASoC: davinci: HDMI audio build for AM33XX and TDA998x
Date: Wed, 6 Aug 2014 16:47:20 +0300
Message-ID: <fe4c93a553cf1f6476dc80fd016a94cec4a24715.1407332062.git.jsarha@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <cover.1407332062.git.jsarha@ti.com>
References: <cover.1407332062.git.jsarha@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds configuration option for HDMI audio support for AM33XX based
boards with NXP TDA998x HDMI transmitter. The audio is connected to
NXP TDA998x trough McASP running in i2s mode.

Signed-off-by: Jyri Sarha <jsarha@ti.com>
---
 sound/soc/davinci/Kconfig |   12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/sound/soc/davinci/Kconfig b/sound/soc/davinci/Kconfig
index b310dd3..59c61a0 100644
--- a/sound/soc/davinci/Kconfig
+++ b/sound/soc/davinci/Kconfig
@@ -37,6 +37,18 @@ config SND_AM33XX_SOC_EVM
 	  AM335X-EVMSK, and BeagelBone with AudioCape boards have this
 	  setup.
 
+config SND_AM335X_SOC_NXPTDA_EVM
+	tristate "HDMI Audio for the AM33XX chip based boards with TDA998x"
+	depends on SND_EDMA_SOC && SOC_AM33XX && DRM_I2C_NXP_TDA998X
+	select SND_SOC_HDMI_CODEC
+	select SND_DAVINCI_SOC_MCASP
+	select SND_DAVINCI_SOC_GENERIC_EVM
+	help
+	  Say Y or M if you want to add support for HDMI SoC audio on
+	  AM33XX boards with NXP TDA998x HDMI transmitter. For example
+	  BeagleBoneBack. The audio is connected to NXP TDA998x trough
+	  McASP running in i2s mode.
+
 config SND_DAVINCI_SOC_EVM
 	tristate "SoC Audio support for DaVinci DM6446, DM355 or DM365 EVM"
 	depends on SND_DAVINCI_SOC && I2C
-- 
1.7.9.5

