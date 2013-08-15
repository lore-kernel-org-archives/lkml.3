Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759979Ab3HOSAu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 14:00:50 -0400
Received: from qmta03.emeryville.ca.mail.comcast.net ([76.96.30.32]:53887 "EHLO
	qmta03.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759744Ab3HOSA0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 14:00:26 -0400
From: Shuah Khan <shuah.kh@samsung.com>
To: joro@8bytes.org, alex.williamson@redhat.com, Varun.Sethi@freescale.com,
        aik@ozlabs.ru, joe@perches.com, rostedt@goodmis.org,
        fweisbec@gmail.com, mingo@redhat.com, tony@atomide.com,
        ohad@wizery.com, andreas.herrmann@calxeda.com, will.deacon@arm.com
Cc: Shuah Khan <shuah.kh@samsung.com>, linux-kernel@vger.kernel.org,
        iommu@lists.linux-foundation.org, shuahkhan@gmail.com
Subject: [PATCH 7/7] iommu: Change iommu driver to call unmap trace event
Date: Thu, 15 Aug 2013 11:59:29 -0600
Message-Id: <ce1724941d6bf36a82f7299159b5d64d86ac6458.1376587771.git.shuah.kh@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <cover.1376587770.git.shuah.kh@samsung.com>
References: <cover.1376587770.git.shuah.kh@samsung.com>
In-Reply-To: <cover.1376587770.git.shuah.kh@samsung.com>
References: <cover.1376587770.git.shuah.kh@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change iommu driver to call unmap trace event. This iommu_map_unmap class
event can be enabled to trigger when iommu unmap iommu ops is called. Trace
information includes iova, physical address (map event only), and size.

Testing:
Added trace calls to iommu_prepare_identity_map() for testing some of the
conditions that are hard to trigger. Here is the trace from the testing:

       swapper/0-1     [003] ....     1.854102: unmap: IOMMU: iova=0x00000000cb800000 size=0x400

Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
---
 drivers/iommu/iommu.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index ea49fe8..d8c53c7 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -892,6 +892,7 @@ size_t iommu_unmap(struct iommu_domain *domain, unsigned long iova, size_t size)
 		unmapped += unmapped_page;
 	}
 
+	trace_unmap(iova, 0, size);
 	return unmapped;
 }
 EXPORT_SYMBOL_GPL(iommu_unmap);
-- 
1.7.10.4

