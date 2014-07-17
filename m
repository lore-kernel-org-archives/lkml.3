Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932987AbaGQNTm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 09:19:42 -0400
Received: from mail-bl2lp0207.outbound.protection.outlook.com ([207.46.163.207]:50851
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932498AbaGQNTi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 09:19:38 -0400
From: Nicolin Chen <nicoleotsuka@gmail.com>
To: <broonie@kernel.org>
CC: <linux-kernel@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
        <alsa-devel@alsa-project.org>, <timur@tabi.org>,
        <Li.Xiubo@freescale.com>, <b02247@freescale.com>,
        <b42378@freescale.com>
Subject: [PATCH 2/2] ASoC: fsl_sai: Fix incorrect register writing in fsl_sai_isr()
Date: Thu, 17 Jul 2014 21:21:38 +0800
Message-ID: <25a59f4a687232e0dd90376d640fbfd0eae65e2a.1405603108.git.nicoleotsuka@gmail.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <cover.1405603108.git.nicoleotsuka@gmail.com>
References: <cover.1405603108.git.nicoleotsuka@gmail.com>
X-EOPAttributedMessage: 0
X-Matching-Connectors: 130500767648419044;(91ab9b29-cfa4-454e-5278-08d120cd25b8);()
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(189002)(199002)(82202001)(85306003)(76176999)(92566001)(87572001)(55446002)(99396002)(77156001)(79102001)(105596002)(74662001)(64706001)(87936001)(84676001)(83072002)(92726001)(95666004)(89996001)(81542001)(46102001)(88136002)(81342001)(36756003)(19580405001)(73972005)(19580395003)(2351001)(107046002)(229853001)(4396001)(110136001)(93916002)(26826002)(68736004)(74502001)(86362001)(48376002)(80022001)(87286001)(85852003)(6806004)(102836001)(50986999)(81156004)(77982001)(73392001)(106466001)(47776003)(44976005)(33646002)(50226001)(69596002)(81442001)(21056001)(104166001)(62966002)(50466002)(97736001)(31966008)(104016003)(61266001)(20776003);DIR:OUT;SFP:;SCL:1;SRVR:DM2PR03MB367;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 027578BB13
Authentication-Results: spf=softfail (sender IP is 192.88.158.2)
 smtp.mailfrom=nicoleotsuka@gmail.com; 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the rx irq handling part, we should clear the flags in RCSR not TCSR.

Signed-off-by: Nicolin Chen <nicoleotsuka@gmail.com>
---
 sound/soc/fsl/fsl_sai.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/fsl/fsl_sai.c b/sound/soc/fsl/fsl_sai.c
index b10dbd8..1b6ee2c 100644
--- a/sound/soc/fsl/fsl_sai.c
+++ b/sound/soc/fsl/fsl_sai.c
@@ -106,7 +106,7 @@ irq_rx:
 	xcsr &= ~FSL_SAI_CSR_xF_MASK;
 
 	if (flags)
-		regmap_write(sai->regmap, FSL_SAI_TCSR, flags | xcsr);
+		regmap_write(sai->regmap, FSL_SAI_RCSR, flags | xcsr);
 
 out:
 	if (irq_none)
-- 
1.8.4

