Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936111Ab3DJP5r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 11:57:47 -0400
Received: from co9ehsobe001.messaging.microsoft.com ([207.46.163.24]:57722
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755531Ab3DJP5p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 11:57:45 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1f42h1fc6h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ahzz8275bhz2dh668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1155h)
X-WSS-ID: 0ML1QZY-01-165-02
X-M-MSG: 
From: <suravee.suthikulpanit@amd.com>
To: <iommu@lists.linux-foundation.org>, <joro@8bytes.org>
CC: <linux-kernel@vger.kernel.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: [PATCH 1/2] iommu/amd: Adding new command line option "amd-iommu=verbose"
Date: Wed, 10 Apr 2013 10:57:31 -0500
Message-ID: <1365609451-3347-1-git-send-email-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>

Adding new command line option "amd-iommu=verbose" to allow verbose print out
in dmesg.

Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 drivers/iommu/amd_iommu_init.c  |    4 ++++
 drivers/iommu/amd_iommu_types.h |    2 ++
 2 files changed, 6 insertions(+)

diff --git a/drivers/iommu/amd_iommu_init.c b/drivers/iommu/amd_iommu_init.c
index e3c2d74..1c8770e 100644
--- a/drivers/iommu/amd_iommu_init.c
+++ b/drivers/iommu/amd_iommu_init.c
@@ -157,6 +157,8 @@ bool amd_iommu_v2_present __read_mostly;
 
 bool amd_iommu_force_isolation __read_mostly;
 
+bool amd_iommu_verbose __read_mostly;
+
 /*
  * List of protection domains - used during resume
  */
@@ -2092,6 +2094,8 @@ static int __init parse_amd_iommu_options(char *str)
 			amd_iommu_disabled = true;
 		if (strncmp(str, "force_isolation", 15) == 0)
 			amd_iommu_force_isolation = true;
+		if (strncmp(str, "verbose", 7) == 0)
+			amd_iommu_verbose = true;
 	}
 
 	return 1;
diff --git a/drivers/iommu/amd_iommu_types.h b/drivers/iommu/amd_iommu_types.h
index e38ab43..9ade4f9 100644
--- a/drivers/iommu/amd_iommu_types.h
+++ b/drivers/iommu/amd_iommu_types.h
@@ -694,6 +694,8 @@ extern bool amd_iommu_v2_present;
 
 extern bool amd_iommu_force_isolation;
 
+extern bool amd_iommu_verbose;
+
 /* Max levels of glxval supported */
 extern int amd_iommu_max_glx_val;
 
-- 
1.7.10.4


