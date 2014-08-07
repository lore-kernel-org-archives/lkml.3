Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757454AbaHGJdl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 05:33:41 -0400
Received: from dns-bn1lp0143.outbound.protection.outlook.com ([207.46.163.143]:59985
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757382AbaHGJdi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 05:33:38 -0400
From: Shengjiu Wang <shengjiu.wang@freescale.com>
To: <broonie@kernel.org>, <lgirdwood@gmail.com>, <timur@tabi.org>,
        <perex@perex.cz>, <tiwai@suse.de>, <nicoleotsuka@gmail.com>,
        <Li.Xiubo@freescale.com>, <shc_work@mail.ru>,
        <fabio.estevam@freescale.com>, <arnd@arndb.de>
CC: <alsa-devel@alsa-project.org>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH V2 2/2] Revert "ASoC: fsl-esai: Add .xlate_tdm_slot_mask() support."
Date: Thu, 7 Aug 2014 17:33:25 +0800
Message-ID: <5627d0f839900c33b1c15de4c21f745015d3e19d.1407403727.git.shengjiu.wang@freescale.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <cover.1407403727.git.shengjiu.wang@freescale.com>
References: <cover.1407403727.git.shengjiu.wang@freescale.com>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(199002)(189002)(50986999)(102836001)(89996001)(64706001)(106466001)(74662001)(79102001)(86362001)(21056001)(88136002)(6806004)(83072002)(76176999)(84676001)(19580395003)(93916002)(85852003)(20776003)(47776003)(74502001)(99396002)(62966002)(95666004)(36756003)(104016003)(2201001)(97736001)(92566001)(4396001)(83322001)(80022001)(87286001)(85306004)(77982001)(92726001)(44976005)(19580405001)(81542001)(76482001)(31966008)(68736004)(50226001)(26826002)(46102001)(87936001)(48376002)(33646002)(104166001)(105606002)(77156001)(50466002)(107046002)(229853001)(81342001)(142923001)(1121002)(921003);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR03MB255;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 029651C7A1
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
index f252370..b2f6b3e 100644
--- a/sound/soc/fsl/fsl_esai.c
+++ b/sound/soc/fsl/fsl_esai.c
@@ -18,7 +18,6 @@
 
 #include "fsl_esai.h"
 #include "imx-pcm.h"
-#include "fsl_utils.h"
 
 #define FSL_ESAI_RATES		SNDRV_PCM_RATE_8000_192000
 #define FSL_ESAI_FORMATS	(SNDRV_PCM_FMTBIT_S8 | \
@@ -612,7 +611,6 @@ static struct snd_soc_dai_ops fsl_esai_dai_ops = {
 	.hw_params = fsl_esai_hw_params,
 	.set_sysclk = fsl_esai_set_dai_sysclk,
 	.set_fmt = fsl_esai_set_dai_fmt,
-	.xlate_tdm_slot_mask = fsl_asoc_xlate_tdm_slot_mask,
 	.set_tdm_slot = fsl_esai_set_dai_tdm_slot,
 };
 
-- 
1.7.9.5

