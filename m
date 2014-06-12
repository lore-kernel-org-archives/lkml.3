Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751303AbaFLRlQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 13:41:16 -0400
Received: from mail-bl2lp0210.outbound.protection.outlook.com ([207.46.163.210]:26904
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751160AbaFLRkz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 13:40:55 -0400
X-WSS-ID: 0N72H3R-08-N2F-02
X-M-MSG: 
From: <suravee.suthikulpanit@amd.com>
To: <tj@kernel.org>, <b.zolnierkie@samsung.com>
CC: <hdegoede@redhat.com>, <lho@apm.com>, <tphan@apm.com>, <stripathi@apm.com>,
        <linux-ide@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
Subject: [PATCH 2/2] ahci/xgene: Remove logic to set 64-bit DMA mask
Date: Thu, 12 Jun 2014 12:40:24 -0500
Message-ID: <1402594824-4151-3-git-send-email-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1402594824-4151-1-git-send-email-suravee.suthikulpanit@amd.com>
References: <1402594824-4151-1-git-send-email-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(428001)(189002)(199002)(99396002)(88136002)(80022001)(81542001)(104166001)(87936001)(81342001)(86362001)(33646001)(77982001)(47776003)(44976005)(77156001)(83322001)(79102001)(101416001)(20776003)(92726001)(50226001)(102836001)(84676001)(50986999)(19580405001)(50466002)(74662001)(62966002)(97736001)(89996001)(64706001)(93916002)(48376002)(74502001)(76176999)(85852003)(87286001)(68736004)(76482001)(53416003)(4396001)(46102001)(19580395003)(86152002)(83072002)(36756003);DIR:OUT;SFP:;SCL:1;SRVR:DM2PR0201MB0831;H:atltwp02.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 02408926C4
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Suravee.Suthikulpanit@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>

Instead of doing the check here, this should be handled
in the common AHCI platform code.

Signed-off-by: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
Suggested-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: Loc Ho <lho@apm.com>
Cc: Tuan Phan <tphan@apm.com>
Cc: Suman Triphati <stripathi@apm.com>
---
 drivers/ata/ahci_xgene.c | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/drivers/ata/ahci_xgene.c b/drivers/ata/ahci_xgene.c
index 042a9bb..a9fc2ae 100644
--- a/drivers/ata/ahci_xgene.c
+++ b/drivers/ata/ahci_xgene.c
@@ -440,16 +440,6 @@ static int xgene_ahci_probe(struct platform_device *pdev)
 	/* Configure the host controller */
 	xgene_ahci_hw_init(hpriv);
 
-	/*
-	 * Setup DMA mask. This is preliminary until the DMA range is sorted
-	 * out.
-	 */
-	rc = dma_set_mask_and_coherent(dev, DMA_BIT_MASK(64));
-	if (rc) {
-		dev_err(dev, "Unable to set dma mask\n");
-		goto disable_resources;
-	}
-
 	hflags = AHCI_HFLAG_NO_PMP | AHCI_HFLAG_YES_NCQ;
 
 	rc = ahci_platform_init_host(pdev, hpriv, &xgene_ahci_port_info,
-- 
1.9.0

