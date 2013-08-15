Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760197Ab3HOSBc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 14:01:32 -0400
Received: from qmta13.emeryville.ca.mail.comcast.net ([76.96.27.243]:46354
	"EHLO qmta13.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759209Ab3HOSAQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 14:00:16 -0400
From: Shuah Khan <shuah.kh@samsung.com>
To: joro@8bytes.org, alex.williamson@redhat.com, Varun.Sethi@freescale.com,
        aik@ozlabs.ru, joe@perches.com, rostedt@goodmis.org,
        fweisbec@gmail.com, mingo@redhat.com, tony@atomide.com,
        ohad@wizery.com, andreas.herrmann@calxeda.com, will.deacon@arm.com
Cc: Shuah Khan <shuah.kh@samsung.com>, linux-kernel@vger.kernel.org,
        iommu@lists.linux-foundation.org, shuahkhan@gmail.com
Subject: [PATCH 3/7] iommu: Change iommu driver to call remove_device_to_group trace event
Date: Thu, 15 Aug 2013 11:59:25 -0600
Message-Id: <53a8cce889b9620d26521d6a1170b98586b81577.1376587770.git.shuah.kh@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <cover.1376587770.git.shuah.kh@samsung.com>
References: <cover.1376587770.git.shuah.kh@samsung.com>
In-Reply-To: <cover.1376587770.git.shuah.kh@samsung.com>
References: <cover.1376587770.git.shuah.kh@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change iommu driver to call remove_device_to_group trace event. This
iommu_group class event can be enabled to trigger when devices get
removed from an iommu group. Trace information includes iommu group id and
device name.

Testing:
Added trace calls to iommu_prepare_identity_map() for testing some of the
conditions that are hard to trigger. Here is the trace from the testing:

       swapper/0-1     [003] ....     1.854101: remove_device_from_group: IOMMU: groupID=0 device=0000:00:02.0

Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
---
 drivers/iommu/iommu.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index 349c92d..278055b 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -402,6 +402,8 @@ void iommu_group_remove_device(struct device *dev)
 	sysfs_remove_link(group->devices_kobj, device->name);
 	sysfs_remove_link(&dev->kobj, "iommu_group");
 
+	trace_remove_device_from_group(group->id, dev);
+
 	kfree(device->name);
 	kfree(device);
 	dev->iommu_group = NULL;
-- 
1.7.10.4

