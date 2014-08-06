Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755681AbaHFKXZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 06:23:25 -0400
Received: from mail-by2lp0236.outbound.protection.outlook.com ([207.46.163.236]:6366
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755862AbaHFKXV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 06:23:21 -0400
From: Shengjiu Wang <shengjiu.wang@freescale.com>
To: <broonie@kernel.org>, <lgirdwood@gmail.com>, <timur@tabi.org>,
        <perex@perex.cz>, <tiwai@suse.de>, <nicoleotsuka@gmail.com>,
        <Li.Xiubo@freescale.com>, <shc_work@mail.ru>,
        <fabio.estevam@freescale.com>, <arnd@arndb.de>
CC: <alsa-devel@alsa-project.org>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH V1 2/2] Revert "ASoC: fsl-esai: Add .xlate_tdm_slot_mask() support."
Date: Wed, 6 Aug 2014 18:23:04 +0800
Message-ID: <c4337ee35f7e513b8eb50910cbe2ccd6d39bc9d8.1407320232.git.shengjiu.wang@freescale.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <cover.1407320232.git.shengjiu.wang@freescale.com>
References: <cover.1407320232.git.shengjiu.wang@freescale.com>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(199002)(189002)(6806004)(97736001)(92566001)(104166001)(26826002)(102836001)(107046002)(229853001)(4396001)(50226001)(87936001)(83072002)(62966002)(19580405001)(87286001)(19580395003)(77156001)(85852003)(88136002)(2201001)(92726001)(36756003)(89996001)(81542001)(81342001)(50986999)(79102001)(76482001)(80022001)(93916002)(74502001)(86362001)(95666004)(46102001)(21056001)(20776003)(105606002)(64706001)(74662001)(47776003)(77982001)(68736004)(83322001)(84676001)(76176999)(99396002)(31966008)(44976005)(48376002)(104016003)(33646002)(50466002)(106466001)(85306004)(142923001)(1121002)(921003);DIR:OUT;SFP:;SCL:1;SRVR:BL2PR03MB244;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 02951C14DC
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=shengjiu.wang@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reverts commit a603c8ee526f5ea9ad9b40710308766299ad8a69.

fsl_asoc_xlate_tdm_slot_mask() will invert the mask, which isn't fit for
esai. The default function snd_soc_xlate_tdm_slot_mask() is ok for esai.

Signed-off-by: Shengjiu Wang <shengjiu.wang@freescale.com>
---
 sound/soc/fsl/Kconfig    |    1 -
 sound/soc/fsl/fsl_esai.c |    2 --
 2 files changed, 3 deletions(-)

diff --git a/sound/soc/fsl/Kconfig b/sound/soc/fsl/Kconfig
index f54a8fc..f3012b6 100644
--- a/sound/soc/fsl/Kconfig
+++ b/sound/soc/fsl/Kconfig
@@ -49,7 +49,6 @@ config SND_SOC_FSL_ESAI
 	tristate "Enhanced Serial Audio Interface (ESAI) module support"
 	select REGMAP_MMIO
 	select SND_SOC_IMX_PCM_DMA if SND_IMX_SOC != n
-	select SND_SOC_FSL_UTILS
 	help
 	  Say Y if you want to add Enhanced Synchronous Audio Interface
 	  (ESAI) support for the Freescale CPUs.
diff --git a/sound/soc/fsl/fsl_esai.c b/sound/soc/fsl/fsl_esai.c
index 89aa531..d05b920 100644
--- a/sound/soc/fsl/fsl_esai.c
+++ b/sound/soc/fsl/fsl_esai.c
@@ -18,7 +18,6 @@
 
 #include "fsl_esai.h"
 #include "imx-pcm.h"
-#include "fsl_utils.h"
 
 #define FSL_ESAI_RATES		SNDRV_PCM_RATE_8000_192000
 #define FSL_ESAI_FORMATS	(SNDRV_PCM_FMTBIT_S8 | \
@@ -611,7 +610,6 @@ static struct snd_soc_dai_ops fsl_esai_dai_ops = {
 	.hw_params = fsl_esai_hw_params,
 	.set_sysclk = fsl_esai_set_dai_sysclk,
 	.set_fmt = fsl_esai_set_dai_fmt,
-	.xlate_tdm_slot_mask = fsl_asoc_xlate_tdm_slot_mask,
 	.set_tdm_slot = fsl_esai_set_dai_tdm_slot,
 };
 
-- 
1.7.9.5

