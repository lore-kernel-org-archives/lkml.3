Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934370AbaGXIdU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 04:33:20 -0400
Received: from mail-bl2lp0204.outbound.protection.outlook.com ([207.46.163.204]:26354
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S934314AbaGXIdP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 04:33:15 -0400
From: Nicolin Chen <nicoleotsuka@gmail.com>
To: <broonie@kernel.org>, <shawn.guo@linaro.org>
CC: <robh+dt@kernel.org>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <rdunlap@infradead.org>, <lgirdwood@gmail.com>, <perex@perex.cz>,
        <tiwai@suse.de>, <timur@tabi.org>, <grant.likely@linaro.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <alsa-devel@alsa-project.org>, <linuxppc-dev@lists.ozlabs.org>,
        <b02247@freescale.com>, <b42378@freescale.com>
Subject: [PATCH v2 1/2] ARM: imx: Add the secondary request into the structure for imx-sdma
Date: Thu, 24 Jul 2014 16:35:28 +0800
Message-ID: <e47c36814695fd8c88ef063a9771cf097a128ec0.1406189745.git.nicoleotsuka@gmail.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <cover.1406189745.git.nicoleotsuka@gmail.com>
References: <cover.1406189745.git.nicoleotsuka@gmail.com>
X-EOPAttributedMessage: 0
X-Matching-Connectors: 130506643935548780;(91ab9b29-cfa4-454e-5278-08d120cd25b8);()
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(199002)(189002)(102836001)(47776003)(104166001)(107046002)(105596002)(36756003)(80022001)(20776003)(61266001)(97736001)(81442001)(81542001)(50466002)(229853001)(79102001)(92566001)(26826002)(73392001)(46102001)(48376002)(88136002)(106466001)(92726001)(89996001)(64706001)(55446002)(87286001)(77156001)(19580405001)(104016003)(87936001)(21056001)(76176999)(50986999)(31966008)(68736004)(81156004)(83072002)(85852003)(62966002)(99396002)(69596002)(73972005)(95666004)(33646002)(74662001)(87572001)(84676001)(50226001)(44976005)(74502001)(77982001)(6806004)(93916002)(4396001)(85306003)(575784001)(82202001)(81342001)(19580395003)(86362001);DIR:OUT;SFP:;SCL:1;SRVR:BLUPR03MB358;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 028256169F
Authentication-Results: spf=softfail (sender IP is 192.88.158.2)
 smtp.mailfrom=nicoleotsuka@gmail.com; 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SDMA supports device to device (per_2_per) scripts to handle DMA transfering
between two peripheral devices. The per_2_per script, however, needs two dma
requests from two sides while the current structure only defined one request.

So this patch just simply adds the secondary request so as to let SDMA and
its user to add its implementation later.

[ Both change in the SDMA driver and its users like Freescale ASRC ASoC driver
  should be taken along with this change in order to truly support per_2_per
  sciprts. However, we here make an expediency by adding this first so that
  we can add either side later since this patch won't break any function and
  meanwhile it can make merge window more smoothly: we don't need to apply the
  change inside dmaengine branch via ASoC tree any more. -- Nicolin ]

Signed-off-by: Nicolin Chen <nicoleotsuka@gmail.com>
---
 include/linux/platform_data/dma-imx.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/platform_data/dma-imx.h b/include/linux/platform_data/dma-imx.h
index 7aa0e89..6a1357d 100644
--- a/include/linux/platform_data/dma-imx.h
+++ b/include/linux/platform_data/dma-imx.h
@@ -51,6 +51,7 @@ enum imx_dma_prio {
 
 struct imx_dma_data {
 	int dma_request; /* DMA request line */
+	int dma_request2; /* secondary DMA request line */
 	enum sdma_peripheral_type peripheral_type;
 	int priority;
 };
-- 
1.8.4

