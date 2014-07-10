Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752271AbaGJV7U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 17:59:20 -0400
Received: from mail-wg0-f41.google.com ([74.125.82.41]:59483 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753424AbaGJV5d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 17:57:33 -0400
From: Oded Gabbay <oded.gabbay@gmail.com>
X-Google-Original-From: Oded Gabbay <oded.gabbay@amd.com>
To: David Airlie <airlied@linux.ie>, Alex Deucher <alexander.deucher@amd.com>,
        Jerome Glisse <j.glisse@gmail.com>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        John Bridgman <John.Bridgman@amd.com>,
        Andrew Lewycky <Andrew.Lewycky@amd.com>,
        Joerg Roedel <joro@8bytes.org>,
        Alexey Skidanov <Alexey.Skidanov@amd.com>,
        Oded Gabbay <oded.gabbay@amd.com>
Subject: [PATCH 77/83] hsa/radeon: Add local memory to topology
Date: Fri, 11 Jul 2014 00:54:33 +0300
Message-Id: <1405029279-6894-49-git-send-email-oded.gabbay@amd.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405029279-6894-1-git-send-email-oded.gabbay@amd.com>
References: <1405029279-6894-1-git-send-email-oded.gabbay@amd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexey Skidanov <Alexey.Skidanov@amd.com>

Signed-off-by: Alexey Skidanov <Alexey.Skidanov@amd.com>
Signed-off-by: Oded Gabbay <oded.gabbay@amd.com>
---
 drivers/gpu/hsa/radeon/kfd_topology.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/hsa/radeon/kfd_topology.c b/drivers/gpu/hsa/radeon/kfd_topology.c
index 059b7db..d3aaad1 100644
--- a/drivers/gpu/hsa/radeon/kfd_topology.c
+++ b/drivers/gpu/hsa/radeon/kfd_topology.c
@@ -715,6 +715,8 @@ static ssize_t node_show(struct kobject *kobj, struct attribute *attr,
 		sysfs_show_32bit_prop(buffer, "max_engine_clk_fcompute",
 				kfd2kgd->get_max_engine_clock_in_mhz(
 					dev->gpu->kgd));
+		sysfs_show_64bit_prop(buffer, "local_mem_size",
+				kfd2kgd->get_vmem_size(dev->gpu->kgd));
 		ret = sysfs_show_32bit_prop(buffer, "max_engine_clk_ccompute",
 				cpufreq_quick_get_max(0)/1000);
 	}
-- 
1.9.1

