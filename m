Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754276AbaACAIQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 19:08:16 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:22087 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754198AbaACAIL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 19:08:11 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>, Tony Luck <tony.luck@intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        x86 <x86@kernel.org>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>,
        David Woodhouse <dwmw2@infradead.org>, Joerg Roedel <joro@8bytes.org>,
        Donald Dutile <ddutile@redhat.com>
Subject: [PATCH v2 06/10] IOMMU: Separate free_dmar_iommu from free_iommu
Date: Thu,  2 Jan 2014 16:08:13 -0800
Message-Id: <1388707697-16800-7-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1388707697-16800-1-git-send-email-yinghai@kernel.org>
References: <1388707697-16800-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We will need separate two calling later for iommu_remove.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Donald Dutile <ddutile@redhat.com>
---
 drivers/iommu/dmar.c        | 2 --
 drivers/iommu/intel-iommu.c | 1 +
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/iommu/dmar.c b/drivers/iommu/dmar.c
index f5e0718..20e5727 100644
--- a/drivers/iommu/dmar.c
+++ b/drivers/iommu/dmar.c
@@ -876,8 +876,6 @@ void free_iommu(struct intel_iommu *iommu)
 	if (!iommu)
 		return;
 
-	free_dmar_iommu(iommu);
-
 	if (iommu->reg)
 		unmap_iommu(iommu);
 
diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index 9751ee7..c60d4ed 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -2668,6 +2668,7 @@ error:
 		if (drhd->ignored)
 			continue;
 		iommu = drhd->iommu;
+		free_dmar_iommu(iommu);
 		free_iommu(iommu);
 	}
 	kfree(g_iommus);
-- 
1.8.4

