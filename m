Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753955AbaGJVz0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 17:55:26 -0400
Received: from mail-we0-f181.google.com ([74.125.82.181]:49175 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753277AbaGJVzX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 17:55:23 -0400
From: Oded Gabbay <oded.gabbay@gmail.com>
X-Google-Original-From: Oded Gabbay <oded.gabbay@amd.com>
To: David Airlie <airlied@linux.ie>, Alex Deucher <alexander.deucher@amd.com>,
        Jerome Glisse <j.glisse@gmail.com>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        John Bridgman <John.Bridgman@amd.com>,
        Andrew Lewycky <Andrew.Lewycky@amd.com>,
        Joerg Roedel <joro@8bytes.org>,
        Evgeny Pinchuk <evgeny.pinchuk@amd.com>,
        Oded Gabbay <oded.gabbay@amd.com>
Subject: [PATCH 40/83] hsa/radeon: Adding max clock speeds to topology
Date: Fri, 11 Jul 2014 00:53:56 +0300
Message-Id: <1405029279-6894-12-git-send-email-oded.gabbay@amd.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405029279-6894-1-git-send-email-oded.gabbay@amd.com>
References: <1405029279-6894-1-git-send-email-oded.gabbay@amd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Evgeny Pinchuk <evgeny.pinchuk@amd.com>

Adding support for CPU and GPU max clock speeds in node properties.

Signed-off-by: Evgeny Pinchuk <evgeny.pinchuk@amd.com>
Signed-off-by: Oded Gabbay <oded.gabbay@amd.com>
---
 drivers/gpu/hsa/radeon/kfd_topology.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/hsa/radeon/kfd_topology.c b/drivers/gpu/hsa/radeon/kfd_topology.c
index 2ee5444..21bb66e 100644
--- a/drivers/gpu/hsa/radeon/kfd_topology.c
+++ b/drivers/gpu/hsa/radeon/kfd_topology.c
@@ -26,6 +26,7 @@
 #include <linux/errno.h>
 #include <linux/acpi.h>
 #include <linux/hash.h>
+#include <linux/cpufreq.h>
 
 #include "kfd_priv.h"
 #include "kfd_crat.h"
@@ -712,9 +713,10 @@ static ssize_t node_show(struct kobject *kobj, struct attribute *attr,
 		sysfs_show_32bit_prop(buffer, "location_id",
 				dev->node_props.location_id);
 		sysfs_show_32bit_prop(buffer, "max_engine_clk_fcompute",
-				dev->node_props.max_engine_clk_fcompute);
+				kfd2kgd->get_max_engine_clock_in_mhz(
+					dev->gpu->kgd));
 		ret = sysfs_show_32bit_prop(buffer, "max_engine_clk_ccompute",
-				dev->node_props.max_engine_clk_ccompute);
+				cpufreq_quick_get_max(0)/1000);
 	}
 
 	return ret;
-- 
1.9.1

