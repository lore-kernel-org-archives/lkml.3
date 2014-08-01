Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755346AbaHAMp1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 08:45:27 -0400
Received: from mail-we0-f180.google.com ([74.125.82.180]:56744 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755075AbaHAMpX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 08:45:23 -0400
From: Thierry Reding <thierry.reding@gmail.com>
To: Joerg Roedel <joro@8bytes.org>
Cc: iommu@lists.linux-foundation.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] iommu: Implement a dummy bus_set_iommu()
Date: Fri,  1 Aug 2014 14:45:13 +0200
Message-Id: <1406897113-20099-2-git-send-email-thierry.reding@gmail.com>
X-Mailer: git-send-email 2.0.3
In-Reply-To: <1406897113-20099-1-git-send-email-thierry.reding@gmail.com>
References: <1406897113-20099-1-git-send-email-thierry.reding@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

This allows IOMMU drivers to compile even if IOMMU_API is not selected
and helps improve compile coverage.

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 include/linux/iommu.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index 0b5222c7ff97..415608ea2999 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -242,6 +242,12 @@ static inline int report_iommu_fault(struct iommu_domain *domain,
 
 #else /* CONFIG_IOMMU_API */
 
+static inline int bus_set_iommu(struct bus_type *bus,
+				const struct iommu_ops *ops)
+{
+	return -ENOSYS;
+}
+
 static inline bool iommu_present(struct bus_type *bus)
 {
 	return false;
-- 
2.0.3

