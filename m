Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752201AbaFERET (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 13:04:19 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:52199 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752038AbaFERER (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 13:04:17 -0400
From: Antonios Motakis <a.motakis@virtualopensystems.com>
To: alex.williamson@redhat.com, kvmarm@lists.cs.columbia.edu,
        iommu@lists.linux-foundation.org
Cc: tech@virtualopensystems.com, a.rigo@virtualopensystems.com,
        kvm@vger.kernel.org, christoffer.dall@linaro.org, will.deacon@arm.com,
        kim.phillips@freescale.com, stuart.yoder@freescale.com,
        eric.auger@linaro.org,
        Antonios Motakis <a.motakis@virtualopensystems.com>,
        Joerg Roedel <joro@8bytes.org>,
        Varun Sethi <Varun.Sethi@freescale.com>,
        Alexey Kardashevskiy <aik@ozlabs.ru>,
        Shuah Khan <shuah.kh@samsung.com>,
        "Upinder Malhi (umalhi)" <umalhi@cisco.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [RFC PATCH v6 02/20] iommu: add capability IOMMU_CAP_NOEXEC
Date: Thu,  5 Jun 2014 19:03:10 +0200
Message-Id: <1401987808-23596-3-git-send-email-a.motakis@virtualopensystems.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1401987808-23596-1-git-send-email-a.motakis@virtualopensystems.com>
References: <1401987808-23596-1-git-send-email-a.motakis@virtualopensystems.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some IOMMUs accept an IOMMU_NOEXEC protection flag in addition to
IOMMU_READ and IOMMU_WRITE. Expose this as an IOMMU capability.

Signed-off-by: Antonios Motakis <a.motakis@virtualopensystems.com>
---
 include/linux/iommu.h | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index fc464d2..7e152fb 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -57,8 +57,9 @@ struct iommu_domain {
 	struct iommu_domain_geometry geometry;
 };
 
-#define IOMMU_CAP_CACHE_COHERENCY	0x1
-#define IOMMU_CAP_INTR_REMAP		0x2	/* isolates device intrs */
+#define IOMMU_CAP_CACHE_COHERENCY	(1 << 0)
+#define IOMMU_CAP_INTR_REMAP		(1 << 1) /* isolates device intrs */
+#define IOMMU_CAP_NOEXEC		(1 << 2) /* IOMMU_NOEXEC flag */
 
 /*
  * Following constraints are specifc to FSL_PAMUV1:
-- 
1.8.3.2

