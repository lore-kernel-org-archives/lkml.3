Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753257AbaFMKHS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 06:07:18 -0400
Received: from mail-bn1blp0189.outbound.protection.outlook.com ([207.46.163.189]:35445
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751468AbaFMKFx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 06:05:53 -0400
From: Nicolin Chen <nicoleotsuka@gmail.com>
To: <broonie@kernel.org>, <vinod.koul@intel.com>, <s.hauer@pengutronix.de>
CC: <robh+dt@kernel.org>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <rdunlap@infradead.org>, <lgirdwood@gmail.com>, <perex@perex.cz>,
        <tiwai@suse.de>, <timur@tabi.org>, <grant.likely@linaro.org>,
        <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <alsa-devel@alsa-project.org>,
        <linuxppc-dev@lists.ozlabs.org>, <dan.j.williams@intel.com>,
        <dmaengine@vger.kernel.org>, <b38343@freescale.com>,
        <b02247@freescale.com>, <b42378@freescale.com>
Subject: [RFC][PATCH 0/2] Add ASRC Peripheral to Peripheral driver
Date: Fri, 13 Jun 2014 18:07:03 +0800
Message-ID: <cover.1402653667.git.nicoleotsuka@gmail.com>
X-Mailer: git-send-email 1.8.4
X-EOPAttributedMessage: 0
X-Matching-Connectors: 130471275506943002;(91ab9b29-cfa4-454e-5278-08d120cd25b8);()
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(189002)(199002)(87572001)(33646001)(62966002)(19580395003)(50466002)(79102001)(80022001)(104016001)(46102001)(97736001)(87286001)(50226001)(86362001)(36756003)(104166001)(61266001)(2201001)(83072002)(21056001)(68736004)(73392001)(93916002)(99396002)(26826002)(4396001)(74662001)(20776003)(81442001)(84676001)(64706001)(81342001)(82202001)(81542001)(77982001)(88136002)(55446002)(6806004)(77096999)(31966008)(50986999)(73972005)(44976005)(92726001)(48376002)(77156001)(92566001)(102836001)(74502001)(87936001)(47776003)(89996001)(85852003);DIR:OUT;SFP:;SCL:1;SRVR:DM2PR03MB400;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: BL:0;ACTION:Default;RISK:Low;SCL:0;SPMLVL:NotSpam;PCL:0;RULEID:
X-Forefront-PRVS: 0241D5F98C
Authentication-Results: spf=softfail (sender IP is 192.88.168.50)
 smtp.mailfrom=nicoleotsuka@gmail.com; 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series of patches have a direct dependency between them. So we might
need to push them into one branch. And sorry for this :(

Patch-1 adds device to device support in SDMA driver along with a secondary
request in struct imx_dma_data which's requred in the Patch-2 ASRC driver.

Nicolin Chen (2):
  dma: imx-sdma: Add device to device support
  ASoC: fsl_asrc: Add ASRC ASoC CPU DAI and platform drivers

 .../devicetree/bindings/sound/fsl,asrc.txt         |   62 ++
 drivers/dma/imx-sdma.c                             |   40 +-
 include/linux/platform_data/dma-imx.h              |    1 +
 sound/soc/fsl/Kconfig                              |    9 +
 sound/soc/fsl/Makefile                             |    2 +
 sound/soc/fsl/fsl_asrc.c                           | 1031 ++++++++++++++++++++
 sound/soc/fsl/fsl_asrc.h                           |  431 ++++++++
 sound/soc/fsl/fsl_asrc_dma.c                       |  385 ++++++++
 8 files changed, 1956 insertions(+), 5 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/sound/fsl,asrc.txt
 create mode 100644 sound/soc/fsl/fsl_asrc.c
 create mode 100644 sound/soc/fsl/fsl_asrc.h
 create mode 100644 sound/soc/fsl/fsl_asrc_dma.c

-- 
1.8.4

