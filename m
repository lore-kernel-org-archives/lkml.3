Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760075AbaGYIoR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 04:44:17 -0400
Received: from mail-bl2lp0203.outbound.protection.outlook.com ([207.46.163.203]:45072
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758946AbaGYIoN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 04:44:13 -0400
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
Subject: [PATCH v5 1/2] ARM: imx: Add the secondary request into the structure for imx-sdma
Date: Fri, 25 Jul 2014 16:46:18 +0800
Message-ID: <a2ded5bde6f54756b5a6a6abf27baa46c4a9c038.1406276436.git.nicoleotsuka@gmail.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <cover.1406276436.git.nicoleotsuka@gmail.com>
References: <cover.1406276436.git.nicoleotsuka@gmail.com>
X-EOPAttributedMessage: 0
X-Matching-Connectors: 130507514507645398;(91ab9b29-cfa4-454e-5278-08d120cd25b8);()
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(199002)(189002)(48376002)(26826002)(50466002)(74662001)(104166001)(31966008)(46102001)(74502001)(19580405001)(88136002)(33646002)(77982001)(105596002)(81442001)(73392001)(19580395003)(106466001)(84676001)(104016003)(95666004)(102836001)(21056001)(85306003)(81342001)(81542001)(55446002)(76176999)(107046002)(82202001)(47776003)(77156001)(20776003)(229853001)(36756003)(85852003)(83072002)(6806004)(80022001)(110136001)(64706001)(2351001)(50986999)(92566001)(79102001)(44976005)(92726001)(97736001)(89996001)(99396002)(575784001)(61266001)(87572001)(68736004)(86362001)(93916002)(73972005)(62966002)(87286001)(50226001)(87936001)(4396001);DIR:OUT;SFP:;SCL:1;SRVR:BL2PR03MB356;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 02830F0362
Authentication-Results: spf=softfail (sender IP is 192.88.168.50)
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
Acked-by: Shawn Guo <shawn.guo@linaro.org>
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

