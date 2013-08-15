Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759649Ab3HOSAQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 14:00:16 -0400
Received: from qmta10.emeryville.ca.mail.comcast.net ([76.96.30.17]:45816 "EHLO
	qmta10.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756045Ab3HOSAM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 14:00:12 -0400
From: Shuah Khan <shuah.kh@samsung.com>
To: joro@8bytes.org, alex.williamson@redhat.com, Varun.Sethi@freescale.com,
        aik@ozlabs.ru, joe@perches.com, rostedt@goodmis.org,
        fweisbec@gmail.com, mingo@redhat.com, tony@atomide.com,
        ohad@wizery.com, andreas.herrmann@calxeda.com, will.deacon@arm.com
Cc: Shuah Khan <shuah.kh@samsung.com>, linux-kernel@vger.kernel.org,
        iommu@lists.linux-foundation.org, shuahkhan@gmail.com
Subject: [PATCH 2/7] iommu: Change iommu driver to call add_device_to_group trace event
Date: Thu, 15 Aug 2013 11:59:24 -0600
Message-Id: <bffbc7422399e0c37141c084ca19a93609bacbc0.1376587770.git.shuah.kh@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <cover.1376587770.git.shuah.kh@samsung.com>
References: <cover.1376587770.git.shuah.kh@samsung.com>
In-Reply-To: <cover.1376587770.git.shuah.kh@samsung.com>
References: <cover.1376587770.git.shuah.kh@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change iommu driver to call add_device_to_group trace event. This iommu_group
class event can be enabled to trigger when devices get added to an iommu group.
Trace information includes iommu group id and device name.

Testing:
The following is trace is generated when intel-iommu driver adds devices to
to iommu groups during boot-time during its initialization:

       swapper/0-1     [003] ....     1.854793: add_device_to_group: IOMMU: groupID=0 device=0000:00:00.0
       swapper/0-1     [003] ....     1.854797: add_device_to_group: IOMMU: groupID=1 device=0000:00:02.0

Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
---
 drivers/iommu/iommu.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index 58f6a16..349c92d 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -364,6 +364,8 @@ rename:
 	/* Notify any listeners about change to group. */
 	blocking_notifier_call_chain(&group->notifier,
 				     IOMMU_GROUP_NOTIFY_ADD_DEVICE, dev);
+
+	trace_add_device_to_group(group->id, dev);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(iommu_group_add_device);
-- 
1.7.10.4

