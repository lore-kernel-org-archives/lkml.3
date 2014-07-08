Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754220AbaGHObl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 10:31:41 -0400
Received: from mail-bn1lp0145.outbound.protection.outlook.com ([207.46.163.145]:47964
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754059AbaGHObZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 10:31:25 -0400
X-WSS-ID: 0N8EDO6-07-JWD-02
X-M-MSG: 
From: Oded Gabbay <oded.gabbay@amd.com>
To: Joerg Roedel <joro@8bytes.org>
CC: <iommu@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        "Alexey Skidanov" <Alexey.Skidanov@amd.com>,
        Oded Gabbay <oded.gabbay@amd.com>
Subject: [PATCH 2/2] iommu/amd: Moving PPR fault flags macros definitions
Date: Tue, 8 Jul 2014 17:30:17 +0300
Message-ID: <1404829817-19584-2-git-send-email-oded.gabbay@amd.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404829817-19584-1-git-send-email-oded.gabbay@amd.com>
References: <1404829817-19584-1-git-send-email-oded.gabbay@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.20.0.84]
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(428002)(189002)(199002)(110136001)(33646001)(77156001)(106466001)(99396002)(76482001)(104166001)(50226001)(76176999)(97736001)(229853001)(50986999)(48376002)(50466002)(81542001)(74662001)(68736004)(105586002)(107046002)(101416001)(102836001)(92726001)(81342001)(92566001)(93916002)(77982001)(86362001)(36756003)(62966002)(89996001)(79102001)(31966008)(77096002)(20776003)(88136002)(85852003)(85306003)(80022001)(47776003)(87936001)(46102001)(4396001)(95666004)(21056001)(83322001)(44976005)(64706001)(83072002)(19580395003)(74502001)(87286001)(19580405001);DIR:OUT;SFP:;SCL:1;SRVR:DM2PR0201MB0925;H:atltwp01.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 0266491E90
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Oded.Gabbay@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexey Skidanov <Alexey.Skidanov@amd.com>

Any kernel source registering the invalid PPR calback may include the header file with PPR fault flags macros definitions.
Thus we move them to include/linux/amd-iommu.h

Signed-off-by: Alexey Skidanov <Alexey.Skidanov@amd.com>
Signed-off-by: Oded Gabbay <oded.gabbay@amd.com>
---
 drivers/iommu/amd_iommu_types.h | 6 ------
 include/linux/amd-iommu.h       | 7 +++++++
 2 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/iommu/amd_iommu_types.h b/drivers/iommu/amd_iommu_types.h
index 557a20e..8e43b7c 100644
--- a/drivers/iommu/amd_iommu_types.h
+++ b/drivers/iommu/amd_iommu_types.h
@@ -390,12 +390,6 @@ struct amd_iommu_fault {
 
 };
 
-#define PPR_FAULT_EXEC	(1 << 1)
-#define PPR_FAULT_READ  (1 << 2)
-#define PPR_FAULT_WRITE (1 << 5)
-#define PPR_FAULT_USER  (1 << 6)
-#define PPR_FAULT_RSVD  (1 << 7)
-#define PPR_FAULT_GN    (1 << 8)
 
 struct iommu_domain;
 
diff --git a/include/linux/amd-iommu.h b/include/linux/amd-iommu.h
index 15f6b9e..2b08e79 100644
--- a/include/linux/amd-iommu.h
+++ b/include/linux/amd-iommu.h
@@ -119,6 +119,13 @@ typedef int (*amd_iommu_invalid_ppr_cb)(struct pci_dev *pdev,
 extern int amd_iommu_set_invalid_ppr_cb(struct pci_dev *pdev,
 					amd_iommu_invalid_ppr_cb cb);
 
+#define PPR_FAULT_EXEC	(1 << 1)
+#define PPR_FAULT_READ  (1 << 2)
+#define PPR_FAULT_WRITE (1 << 5)
+#define PPR_FAULT_USER  (1 << 6)
+#define PPR_FAULT_RSVD  (1 << 7)
+#define PPR_FAULT_GN    (1 << 8)
+
 /**
  * amd_iommu_device_info() - Get information about IOMMUv2 support of a
  *			     PCI device
-- 
1.9.1

