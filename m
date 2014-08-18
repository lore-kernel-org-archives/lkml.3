Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752379AbaHRIja (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 04:39:30 -0400
Received: from mail-bn1lp0140.outbound.protection.outlook.com ([207.46.163.140]:17361
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752291AbaHRIj1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 04:39:27 -0400
From: Shengjiu Wang <shengjiu.wang@freescale.com>
To: <lgirdwood@gmail.com>, <broonie@kernel.org>, <perex@perex.cz>,
        <tiwai@suse.de>, <nicoleotsuka@gmail.com>, <Li.Xiubo@freescale.com>,
        <shc_work@mail.ru>, <fabio.estevam@freescale.com>,
        <shengjiu.wang@freescale.com>, <xobs@kosagi.com>, <arnd@arndb.de>,
        <sfr@canb.auug.org.au>, <timur@tabi.org>
CC: <alsa-devel@alsa-project.org>, <linux-kernel@vger.kernel.org>,
        <linuxppc-dev@lists.ozlabs.org>
Subject: [PATCH V1 3/3] ASoC: fsl: fsl-asoc-card: Select SND_SOC_IMX_AUDMUX
Date: Mon, 18 Aug 2014 16:38:40 +0800
Message-ID: <ee71a6cacc1d0bc1459bf9c21efc755c16e955b1.1408350626.git.shengjiu.wang@freescale.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <cover.1408350626.git.shengjiu.wang@freescale.com>
References: <cover.1408350626.git.shengjiu.wang@freescale.com>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019005)(6009001)(189002)(199003)(99396002)(48376002)(31966008)(81542001)(81342001)(104166001)(97736001)(19580405001)(83322001)(19580395003)(85852003)(62966002)(83072002)(50986999)(50466002)(76176999)(107046002)(77156001)(105606002)(74662001)(74502001)(95666004)(229853001)(106466001)(4396001)(89996001)(64706001)(76482001)(87936001)(33646002)(104016003)(88136002)(79102001)(47776003)(46102001)(21056001)(20776003)(86362001)(50226001)(87286001)(6806004)(93916002)(44976005)(26826002)(102836001)(575784001)(77982001)(36756003)(68736004)(92566001)(80022001)(85306004)(92726001)(84676001)(2201001)(230783001)(921003)(1121002);DIR:OUT;SFP:1102;SCL:1;SRVR:DM2PR03MB334;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 03077579FF
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=shengjiu.wang@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Building kernel with SND_SOC_IMX_AUDMUX=n leads to the following error:

   sound/built-in.o: In function `fsl_asoc_card_probe':
>> fsl-asoc-card.c:(.text+0x1467b5): undefined reference to `imx_audmux_v2_configure_port'
>> fsl-asoc-card.c:(.text+0x1467d0): undefined reference to `imx_audmux_v2_configure_port'
>> fsl-asoc-card.c:(.text+0x1467ed): undefined reference to `imx_audmux_v2_configure_port'
>> fsl-asoc-card.c:(.text+0x146807): undefined reference to `imx_audmux_v2_configure_port'

Update Kconfig to select SND_SOC_IMX_AUDMUX when SND_SOC_FSL_ASOC_CARD=y.

Reported-by: kbuild test robot <fengguang.wu@intel.com>
Signed-off-by: Shengjiu Wang <shengjiu.wang@freescale.com>
---
 sound/soc/fsl/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/fsl/Kconfig b/sound/soc/fsl/Kconfig
index 3a3732c..dc0d08b 100644
--- a/sound/soc/fsl/Kconfig
+++ b/sound/soc/fsl/Kconfig
@@ -61,6 +61,7 @@ config SND_SOC_FSL_UTILS
 config SND_SOC_FSL_ASOC_CARD
 	tristate "Generic ASoC Sound Card with ASRC support"
 	depends on OF && I2C
+	select SND_SOC_IMX_AUDMUX
 	select SND_SOC_IMX_PCM_DMA
 	select SND_SOC_FSL_ESAI
 	select SND_SOC_FSL_SAI
-- 
1.7.9.5

