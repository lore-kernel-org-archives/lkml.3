Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753183AbaG2KHK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 06:07:10 -0400
Received: from mail-bl2lp0204.outbound.protection.outlook.com ([207.46.163.204]:52082
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753107AbaG2KHC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 06:07:02 -0400
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
Subject: [PATCH v6 1/2] ARM: imx: Add the secondary request into the structure for imx-sdma
Date: Tue, 29 Jul 2014 18:08:52 +0800
Message-ID: <ad546b065ea9368680fff2d11b13f5316ec50061.1406628283.git.nicoleotsuka@gmail.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <cover.1406628283.git.nicoleotsuka@gmail.com>
References: <cover.1406628283.git.nicoleotsuka@gmail.com>
X-EOPAttributedMessage: 0
X-Matching-Connectors: 130511020007483648;(91ab9b29-cfa4-454e-5278-08d120cd25b8);()
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(189002)(199002)(55446002)(88136002)(20776003)(64706001)(73972005)(4396001)(92726001)(62966002)(83072002)(48376002)(85852003)(61266001)(92566001)(86362001)(89996001)(47776003)(107046002)(102836001)(6806004)(46102001)(81442001)(19580395003)(81342001)(85306003)(95666004)(105596002)(229853001)(50466002)(26826002)(106466001)(19580405001)(50226001)(44976005)(81542001)(87936001)(79102001)(68736004)(104166001)(80022001)(21056001)(77982001)(76176999)(97736001)(50986999)(104016003)(110136001)(33646002)(82202001)(36756003)(74662001)(31966008)(74502001)(2351001)(87286001)(93916002)(73392001)(84676001)(99396002)(87572001)(77156001);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR03MB361;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 0287BBA78D
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
index bcbc6c3..d05542a 100644
--- a/include/linux/platform_data/dma-imx.h
+++ b/include/linux/platform_data/dma-imx.h
@@ -50,6 +50,7 @@ enum imx_dma_prio {
 
 struct imx_dma_data {
 	int dma_request; /* DMA request line */
+	int dma_request2; /* secondary DMA request line */
 	enum sdma_peripheral_type peripheral_type;
 	int priority;
 };
-- 
1.8.4

