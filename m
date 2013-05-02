Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759045Ab3EBPbg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 11:31:36 -0400
Received: from eva.fit.vutbr.cz ([147.229.176.14]:62640 "EHLO eva.fit.vutbr.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757110Ab3EBPbe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 11:31:34 -0400
Message-ID: <51828529.90900@stud.fit.vutbr.cz>
Date: Thu, 02 May 2013 17:24:25 +0200
From: =?ISO-8859-1?Q?Radmila_Kompov=E1?= <xkompo00@stud.fit.vutbr.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: iommu@lists.linux-foundation.org
CC: linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] drivers/iommu/amd_iommu.c: fix resource leak in iommu_init_device()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Detected by cppcheck.

Signed-off-by: Kamil Dudka <kdudka@redhat.com>
---
 drivers/iommu/amd_iommu.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c
index 8301837..5523ffb 100644
--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -448,8 +448,10 @@ static int iommu_init_device(struct device *dev)
 	}

 	ret = init_iommu_group(dev);
-	if (ret)
+	if (ret) {
+		free_dev_data(dev_data);
 		return ret;
+	}

 	if (pci_iommuv2_capable(pdev)) {
 		struct amd_iommu *iommu;
-- 
1.8.1.5
