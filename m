Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754099AbaGHObZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 10:31:25 -0400
Received: from mail-bn1blp0181.outbound.protection.outlook.com ([207.46.163.181]:2660
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753063AbaGHObT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 10:31:19 -0400
X-WSS-ID: 0N8EDNX-08-JKJ-02
X-M-MSG: 
From: Oded Gabbay <oded.gabbay@amd.com>
To: Joerg Roedel <joro@8bytes.org>
CC: <iommu@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        "Alexey Skidanov" <Alexey.Skidanov@amd.com>,
        Oded Gabbay <oded.gabbay@amd.com>
Subject: [PATCH 1/2] iommu/amd: Fix for pasid initialization
Date: Tue, 8 Jul 2014 17:30:16 +0300
Message-ID: <1404829817-19584-1-git-send-email-oded.gabbay@amd.com>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.20.0.84]
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(428002)(199002)(189002)(64706001)(77156001)(87286001)(87936001)(21056001)(4396001)(79102001)(88136002)(81542001)(104166001)(106466001)(83072002)(229853001)(36756003)(85852003)(89996001)(107046002)(77982001)(105586002)(81342001)(68736004)(97736001)(74502001)(31966008)(62966002)(99396002)(92566001)(95666004)(110136001)(92726001)(74662001)(47776003)(77096002)(33646001)(76482001)(19580395003)(50466002)(86362001)(102836001)(93916002)(80022001)(48376002)(44976005)(46102001)(85306003)(50986999)(20776003)(50226001)(101416001)(19580405001)(83322001);DIR:OUT;SFP:;SCL:1;SRVR:CY1PR0201MB0924;H:atltwp02.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 0266491E90
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Oded.Gabbay@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexey Skidanov <Alexey.Skidanov@amd.com>

The pasid wasn't properly initialized before caling to invalid PPR calback

Signed-off-by: Alexey Skidanov <Alexey.Skidanov@amd.com>
Signed-off-by: Oded Gabbay <oded.gabbay@amd.com>
---
 drivers/iommu/amd_iommu_v2.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/iommu/amd_iommu_v2.c b/drivers/iommu/amd_iommu_v2.c
index 499b436..92fb77c 100644
--- a/drivers/iommu/amd_iommu_v2.c
+++ b/drivers/iommu/amd_iommu_v2.c
@@ -612,6 +612,7 @@ static int ppr_notifier(struct notifier_block *nb, unsigned long e, void *data)
 	fault->state     = pasid_state;
 	fault->tag       = tag;
 	fault->finish    = finish;
+	fault->pasid     = iommu_fault->pasid;
 	fault->flags     = iommu_fault->flags;
 	INIT_WORK(&fault->work, do_fault);
 
-- 
1.9.1

