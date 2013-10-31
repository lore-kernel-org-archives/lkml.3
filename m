Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752003Ab3JaJaU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 05:30:20 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:33692 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750882Ab3JaJaS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 05:30:18 -0400
From: Yijing Wang <wangyijing@huawei.com>
To: Joerg Roedel <joro@8bytes.org>, David Woodhouse <dwmw2@infradead.org>
CC: <iommu@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        Yijing Wang <wangyijing@huawei.com>, Hanjun Guo <guohanjun@huawei.com>
Subject: [PATCH 1/2] IOMMU/trivial: Use for_each_drhd_unit() instead of list_for_each_entry()
Date: Thu, 31 Oct 2013 17:25:16 +0800
Message-ID: <1383211516-38776-1-git-send-email-wangyijing@huawei.com>
X-Mailer: git-send-email 1.7.11.msysgit.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.135.76.69]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use for_each_drhd_unit() instead of list_for_each_entry for
better readability.

Signed-off-by: Yijing Wang <wangyijing@huawei.com>
---
 drivers/iommu/dmar.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/iommu/dmar.c b/drivers/iommu/dmar.c
index 785675a..da2d0d9 100644
--- a/drivers/iommu/dmar.c
+++ b/drivers/iommu/dmar.c
@@ -403,7 +403,7 @@ dmar_find_matched_drhd_unit(struct pci_dev *dev)
 
 	dev = pci_physfn(dev);
 
-	list_for_each_entry(dmaru, &dmar_drhd_units, list) {
+	for_each_drhd_unit(dmaru) {
 		drhd = container_of(dmaru->hdr,
 				    struct acpi_dmar_hardware_unit,
 				    header);
-- 
1.7.1


