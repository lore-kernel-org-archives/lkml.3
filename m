Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760065Ab3HOSBJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 14:01:09 -0400
Received: from qmta15.emeryville.ca.mail.comcast.net ([76.96.27.228]:37792
	"EHLO qmta15.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759676Ab3HOSAV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 14:00:21 -0400
From: Shuah Khan <shuah.kh@samsung.com>
To: joro@8bytes.org, alex.williamson@redhat.com, Varun.Sethi@freescale.com,
        aik@ozlabs.ru, joe@perches.com, rostedt@goodmis.org,
        fweisbec@gmail.com, mingo@redhat.com, tony@atomide.com,
        ohad@wizery.com, andreas.herrmann@calxeda.com, will.deacon@arm.com
Cc: Shuah Khan <shuah.kh@samsung.com>, linux-kernel@vger.kernel.org,
        iommu@lists.linux-foundation.org, shuahkhan@gmail.com
Subject: [PATCH 5/7] iommu: Change iommu driver to call detach_device_to_domain trace event
Date: Thu, 15 Aug 2013 11:59:27 -0600
Message-Id: <5dbfc0b2e5507a01692db76cc0352d4d7aee6c8b.1376587771.git.shuah.kh@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <cover.1376587770.git.shuah.kh@samsung.com>
References: <cover.1376587770.git.shuah.kh@samsung.com>
In-Reply-To: <cover.1376587770.git.shuah.kh@samsung.com>
References: <cover.1376587770.git.shuah.kh@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change iommu driver to call detach_device_to_domain trace event. This
iommu_device class event can be enabled to trigger when devices are detached
from a domain. Trace information includes device name.

Testing:
Added trace calls to iommu_prepare_identity_map() for testing some of the
conditions that are hard to trigger. Here is the trace from the testing:

       swapper/0-1     [003] ....     1.854102: detach_device_from_domain: IOMMU: device=0000:00:02.0

Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
---
 drivers/iommu/iommu.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index 74c371c..b630754 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -702,6 +702,7 @@ void iommu_detach_device(struct iommu_domain *domain, struct device *dev)
 		return;
 
 	domain->ops->detach_dev(domain, dev);
+	trace_detach_device_from_domain(dev);
 }
 EXPORT_SYMBOL_GPL(iommu_detach_device);
 
-- 
1.7.10.4

