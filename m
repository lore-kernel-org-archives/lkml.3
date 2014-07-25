Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751355AbaGYEBp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 00:01:45 -0400
Received: from mail-bn1lp0139.outbound.protection.outlook.com ([207.46.163.139]:53080
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750862AbaGYEBn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 00:01:43 -0400
From: Nicolin Chen <nicoleotsuka@gmail.com>
To: <broonie@kernel.org>
CC: <robh+dt@kernel.org>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <rdunlap@infradead.org>, <lgirdwood@gmail.com>, <perex@perex.cz>,
        <tiwai@suse.de>, <timur@tabi.org>, <grant.likely@linaro.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <alsa-devel@alsa-project.org>, <linuxppc-dev@lists.ozlabs.org>,
        <shawn.guo@linaro.org>, <b02247@freescale.com>, <b42378@freescale.com>,
        <tklauser@distanz.ch>
Subject: [PATCH v3 0/2] Add Freescale ASRC driver
Date: Fri, 25 Jul 2014 12:03:57 +0800
Message-ID: <cover.1406259578.git.nicoleotsuka@gmail.com>
X-Mailer: git-send-email 1.8.4
X-EOPAttributedMessage: 0
X-Matching-Connectors: 130507344991452588;(91ab9b29-cfa4-454e-5278-08d120cd25b8);()
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(189002)(199002)(54534003)(107046002)(50226001)(62966002)(110136001)(85306003)(26826002)(36756003)(19580395003)(33646002)(6806004)(77982001)(89996001)(2351001)(106466001)(77156001)(61266001)(20776003)(50986999)(80022001)(105596002)(81442001)(79102001)(55446002)(229853001)(97736001)(4396001)(84676001)(87572001)(73392001)(85852003)(50466002)(74502001)(87936001)(102836001)(47776003)(81342001)(81542001)(21056001)(74662001)(95666004)(88136002)(46102001)(68736004)(93916002)(44976005)(48376002)(104016003)(64706001)(104166001)(99396002)(31966008)(87286001)(82202001)(92566001)(86362001)(92726001)(73972005)(83072002);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR03MB361;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;LANG:en;
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

 .../devicetree/bindings/sound/fsl,asrc.txt         |   62 ++
 include/linux/platform_data/dma-imx.h              |    1 +
 sound/soc/fsl/Kconfig                              |    9 +
 sound/soc/fsl/Makefile                             |    2 +
 sound/soc/fsl/fsl_asrc.c                           | 1030 ++++++++++++++++++++
 sound/soc/fsl/fsl_asrc.h                           |  461 +++++++++
 sound/soc/fsl/fsl_asrc_dma.c                       |  386 ++++++++
 7 files changed, 1951 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/sound/fsl,asrc.txt
 create mode 100644 sound/soc/fsl/fsl_asrc.c
 create mode 100644 sound/soc/fsl/fsl_asrc.h
 create mode 100644 sound/soc/fsl/fsl_asrc_dma.c

-- 
1.8.4

