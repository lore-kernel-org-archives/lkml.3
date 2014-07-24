Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934333AbaGXIdP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 04:33:15 -0400
Received: from mail-bl2lp0203.outbound.protection.outlook.com ([207.46.163.203]:42280
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S934204AbaGXIdL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 04:33:11 -0400
From: Nicolin Chen <nicoleotsuka@gmail.com>
To: <broonie@kernel.org>, <shawn.guo@linaro.org>
CC: <robh+dt@kernel.org>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <rdunlap@infradead.org>, <lgirdwood@gmail.com>, <perex@perex.cz>,
        <tiwai@suse.de>, <timur@tabi.org>, <grant.likely@linaro.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <alsa-devel@alsa-project.org>, <linuxppc-dev@lists.ozlabs.org>,
        <b02247@freescale.com>, <b42378@freescale.com>
Subject: [PATCH v2 0/2] Add Freescale ASRC driver
Date: Thu, 24 Jul 2014 16:35:27 +0800
Message-ID: <cover.1406189745.git.nicoleotsuka@gmail.com>
X-Mailer: git-send-email 1.8.4
X-EOPAttributedMessage: 0
X-Matching-Connectors: 130506643884406182;(91ab9b29-cfa4-454e-5278-08d120cd25b8);()
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(189002)(199002)(54534003)(74502001)(74662001)(83072002)(77982001)(48376002)(99396002)(44976005)(87572001)(62966002)(81542001)(6806004)(229853001)(19580395003)(69596002)(89996001)(4396001)(77156001)(85306003)(33646002)(73392001)(21056001)(88136002)(50986999)(26826002)(84676001)(87936001)(55446002)(82202001)(104016003)(47776003)(36756003)(92566001)(81442001)(81156004)(87286001)(64706001)(85852003)(31966008)(92726001)(93916002)(106466001)(102836001)(20776003)(104166001)(79102001)(107046002)(68736004)(50466002)(95666004)(81342001)(50226001)(80022001)(73972005)(86362001)(46102001)(97736001)(105596002)(61266001);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR03MB362;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 028256169F
Authentication-Results: spf=softfail (sender IP is 192.88.158.2)
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
 sound/soc/fsl/fsl_asrc.c                           | 1031 ++++++++++++++++++++
 sound/soc/fsl/fsl_asrc.h                           |  461 +++++++++
 sound/soc/fsl/fsl_asrc_dma.c                       |  384 ++++++++
 7 files changed, 1950 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/sound/fsl,asrc.txt
 create mode 100644 sound/soc/fsl/fsl_asrc.c
 create mode 100644 sound/soc/fsl/fsl_asrc.h
 create mode 100644 sound/soc/fsl/fsl_asrc_dma.c

-- 
1.8.4

