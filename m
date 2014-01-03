Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754403AbaACAIV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 19:08:21 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:22096 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754214AbaACAIM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 19:08:12 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>, Tony Luck <tony.luck@intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        x86 <x86@kernel.org>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>,
        David Woodhouse <dwmw2@infradead.org>,
        iommu@lists.linux-foundation.org
Subject: [PATCH v2 03/10] IOMMU: Don't clean handler data before free_irq()
Date: Thu,  2 Jan 2014 16:08:10 -0800
Message-Id: <1388707697-16800-4-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1388707697-16800-1-git-send-email-yinghai@kernel.org>
References: <1388707697-16800-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

need that in __free_irq.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: iommu@lists.linux-foundation.org
---
 drivers/iommu/intel-iommu.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index 865a65c..9751ee7 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -1315,7 +1315,6 @@ void free_dmar_iommu(struct intel_iommu *iommu)
 		iommu_disable_translation(iommu);
 
 	if (iommu->irq) {
-		irq_set_handler_data(iommu->irq, NULL);
 		/* This will mask the irq */
 		free_irq(iommu->irq, iommu);
 		destroy_irq(iommu->irq);
-- 
1.8.4

