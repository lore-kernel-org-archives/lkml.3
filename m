Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932376AbaGYHQv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 03:16:51 -0400
Received: from mail-bn1blp0190.outbound.protection.outlook.com ([207.46.163.190]:58838
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757917AbaGYHQu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 03:16:50 -0400
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
Subject: [PATCH v4 0/2] Add Freescale ASRC driver
Date: Fri, 25 Jul 2014 15:19:05 +0800
Message-ID: <cover.1406271541.git.nicoleotsuka@gmail.com>
X-Mailer: git-send-email 1.8.4
X-EOPAttributedMessage: 0
X-Matching-Connectors: 130507462050063906;(91ab9b29-cfa4-454e-5278-08d120cd25b8);()
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(189002)(54534003)(199002)(104016003)(77156001)(68736004)(19580395003)(84676001)(82202001)(79102001)(55446002)(36756003)(46102001)(50466002)(92566001)(92726001)(64706001)(50986999)(47776003)(20776003)(99396002)(50226001)(87572001)(4396001)(48376002)(26826002)(102836001)(86362001)(77982001)(93916002)(61266001)(85852003)(2351001)(107046002)(110136001)(229853001)(88136002)(81542001)(81342001)(87936001)(81442001)(83072002)(80022001)(89996001)(87286001)(97736001)(33646002)(44976005)(6806004)(74662001)(74502001)(62966002)(31966008)(73392001)(105596002)(106466001)(73972005)(95666004)(21056001)(104166001)(85306003);DIR:OUT;SFP:;SCL:1;SRVR:BL2PR03MB355;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:ErrorRetry;MX:1;A:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 02830F0362
Authentication-Results: spf=softfail (sender IP is 192.88.168.50)
 smtp.mailfrom=nicoleotsuka@gmail.com; 
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

 .../devicetree/bindings/sound/fsl,asrc.txt         |   60 ++
 include/linux/platform_data/dma-imx.h              |    1 +
 sound/soc/fsl/Kconfig                              |    9 +
 sound/soc/fsl/Makefile                             |    2 +
 sound/soc/fsl/fsl_asrc.c                           | 1032 ++++++++++++++++++++
 sound/soc/fsl/fsl_asrc.h                           |  461 +++++++++
 sound/soc/fsl/fsl_asrc_dma.c                       |  386 ++++++++
 7 files changed, 1951 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/sound/fsl,asrc.txt
 create mode 100644 sound/soc/fsl/fsl_asrc.c
 create mode 100644 sound/soc/fsl/fsl_asrc.h
 create mode 100644 sound/soc/fsl/fsl_asrc_dma.c

-- 
1.8.4

