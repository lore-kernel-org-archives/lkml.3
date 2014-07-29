Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752923AbaG2KGm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 06:06:42 -0400
Received: from mail-bn1blp0187.outbound.protection.outlook.com ([207.46.163.187]:29042
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752168AbaG2KGk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 06:06:40 -0400
From: Nicolin Chen <nicoleotsuka@gmail.com>
To: <broonie@kernel.org>
CC: <robh+dt@kernel.org>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <rdunlap@infradead.org>, <lgirdwood@gmail.com>, <perex@perex.cz>,
        <tiwai@suse.de>, <timur@tabi.org>, <grant.likely@linaro.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <alsa-devel@alsa-project.org>, <linuxppc-dev@lists.ozlabs.org>,
        <shawn.guo@linaro.org>, <b02247@freescale.com>, <b42378@freescale.com>,
        <tklauser@distanz.ch>, <varkabhadram@gmail.com>
Subject: [PATCH v6 0/2] Add Freescale ASRC driver
Date: Tue, 29 Jul 2014 18:08:51 +0800
Message-ID: <cover.1406628283.git.nicoleotsuka@gmail.com>
X-Mailer: git-send-email 1.8.4
X-EOPAttributedMessage: 0
X-Matching-Connectors: 130511019950370166;(91ab9b29-cfa4-454e-5278-08d120cd25b8);()
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(189002)(199002)(54534003)(62966002)(46102001)(81342001)(20776003)(95666004)(47776003)(77156001)(77982001)(80022001)(82202001)(105596002)(106466001)(19580395003)(6806004)(81442001)(85306003)(55446002)(61266001)(73972005)(68736004)(31966008)(79102001)(87936001)(4396001)(88136002)(50226001)(93916002)(74502001)(87286001)(97736001)(102836001)(104166001)(92566001)(107046002)(21056001)(89996001)(104016003)(87572001)(74662001)(73392001)(81542001)(36756003)(99396002)(64706001)(50986999)(44976005)(229853001)(92726001)(26826002)(48376002)(84676001)(2351001)(86362001)(33646002)(83072002)(110136001)(50466002)(85852003);DIR:OUT;SFP:;SCL:1;SRVR:BLUPR03MB357;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 0287BBA78D
Authentication-Results: spf=softfail (sender IP is 192.88.168.50)
 smtp.mailfrom=nicoleotsuka@gmail.com; 
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series of patches add Freescale ASRC module driver support along
with the extra request in imx-sdma structure required by SDMA Device
to Device script.

The previous version has been in the maillist for nearly six months
without any comment and reply. So I decide to drop the SDMA part's
change since this series focus on ASRC support (Later, we can send
SDMA part separately.) so that ASRC driver may get upstream first.

Changelog
v6: (Follows Mark Rutland's comments)
 * PATCH-2: Revised the big endian part in the binding document.
v5: (All follow Varka's suggestions)
 * PATCH-2: Added missing '\n' to pair_err() calls.
 * PATCH-2: Return the final regmap_write() for fsl_asrc_init().
 * PATCH-2: Dropped fsl_asrc_devtype and use simple ids behind fsl_asrc_pm.
 * PATCH-2: Use of_device_is_compatible() to differ compatible directly.
 * PATCH-2: Fixed indentation for devm_regmap_init_mmio_clk() call.
v4: (All follow Varka's suggestions)
 * PATCH-2: Added '\n' to dev_dbg() inside fsl_asrc_isr().
 * PATCH-2: Added indentations to DT binding document.
 * PATCH-2: Redefined fsl_asrc_set_watermarks() as void type.
 * PATCH-2: Put fsl_asrc_isr() and fsl_asrc_ids before probe()
v3:
 * PATCH-1: Added an Acked-by from Shawn Guo
 * PATCH-2: Dropped THIS_MODULE as Tobias suggests
 * PATCH-2: Use dma_coerce_mask_and_coherent() in fsl_asrc_dma_pcm_new()
 * PATCH-2: Added substream check in fsl_asrc_dma_pcm_new()
v2:
 * PATCH-1: Dropped the change to SDMA driver.
 * PATCH-2: Dropped useless member in private data structures.
 * PATCH-2: Refined some comments in fsl_asrc_dma.c driver.
 * PATCH-2: Refined commit comments.

Nicolin Chen (2):
  ARM: imx: Add the secondary request into the structure for imx-sdma
  ASoC: fsl_asrc: Add ASRC ASoC CPU DAI and platform drivers

 .../devicetree/bindings/sound/fsl,asrc.txt         |  60 ++
 include/linux/platform_data/dma-imx.h              |   1 +
 sound/soc/fsl/Kconfig                              |   9 +
 sound/soc/fsl/Makefile                             |   2 +
 sound/soc/fsl/fsl_asrc.c                           | 992 +++++++++++++++++++++
 sound/soc/fsl/fsl_asrc.h                           | 461 ++++++++++
 sound/soc/fsl/fsl_asrc_dma.c                       | 386 ++++++++
 7 files changed, 1911 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/sound/fsl,asrc.txt
 create mode 100644 sound/soc/fsl/fsl_asrc.c
 create mode 100644 sound/soc/fsl/fsl_asrc.h
 create mode 100644 sound/soc/fsl/fsl_asrc_dma.c

-- 
1.8.4

