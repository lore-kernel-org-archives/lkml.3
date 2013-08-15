Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759827Ab3HOSA2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 14:00:28 -0400
Received: from qmta14.emeryville.ca.mail.comcast.net ([76.96.27.212]:55339
	"EHLO qmta14.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759718Ab3HOSAY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 14:00:24 -0400
From: Shuah Khan <shuah.kh@samsung.com>
To: joro@8bytes.org, alex.williamson@redhat.com, Varun.Sethi@freescale.com,
        aik@ozlabs.ru, joe@perches.com, rostedt@goodmis.org,
        fweisbec@gmail.com, mingo@redhat.com, tony@atomide.com,
        ohad@wizery.com, andreas.herrmann@calxeda.com, will.deacon@arm.com
Cc: Shuah Khan <shuah.kh@samsung.com>, linux-kernel@vger.kernel.org,
        iommu@lists.linux-foundation.org, shuahkhan@gmail.com
Subject: [PATCH 6/7] iommu: Change iommu driver to call map trace event
Date: Thu, 15 Aug 2013 11:59:28 -0600
Message-Id: <51ddfdfb1f2e624fdf7fc1f3fa610eb5a932c17e.1376587771.git.shuah.kh@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <cover.1376587770.git.shuah.kh@samsung.com>
References: <cover.1376587770.git.shuah.kh@samsung.com>
In-Reply-To: <cover.1376587770.git.shuah.kh@samsung.com>
References: <cover.1376587770.git.shuah.kh@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change iommu driver to call map trace event. This iommu_map_unmap class event
can be enabled to trigger when iommu map iommu ops is called. Trace information
includes iova, physical address (map event only), and size.

Testing:
Added trace calls to iommu_prepare_identity_map() for testing some of the
conditions that are hard to trigger. Here is the trace from the testing:

       swapper/0-1     [003] ....     1.854102: map: IOMMU: iova=0x00000000cb800000 paddr=0x00000000cf9fffff size=0x400

Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
---
 drivers/iommu/iommu.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index b630754..ea49fe8 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -842,6 +842,8 @@ int iommu_map(struct iommu_domain *domain, unsigned long iova,
 	/* unroll mapping in case something went wrong */
 	if (ret)
 		iommu_unmap(domain, orig_iova, orig_size - size);
+	else
+		trace_map(iova, paddr, size);
 
 	return ret;
 }
-- 
1.7.10.4

