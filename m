Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756066Ab3GYNQC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 09:16:02 -0400
Received: from qmta02.emeryville.ca.mail.comcast.net ([76.96.30.24]:36455 "EHLO
	qmta02.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755910Ab3GYNP3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 09:15:29 -0400
From: Shuah Khan <shuah.kh@samsung.com>
To: joro@8bytes.org, alex.williamson@redhat.com, Varun.Sethi@freescale.com,
        aik@ozlabs.ru, joe@perches.com, rostedt@goodmis.org,
        fweisbec@gmail.com, mingo@redhat.com, tony@atomide.com,
        ohad@wizery.com, andreas.herrmann@calxeda.com, will.deacon@arm.com
Cc: Shuah Khan <shuah.kh@samsung.com>, linux-kernel@vger.kernel.org,
        iommu@lists.linux-foundation.org, shuahkhan@gmail.com
Subject: [PATCH 2/4] iommu: Add event tracing feature to iommu - export trace events
Date: Thu, 25 Jul 2013 07:15:03 -0600
Message-Id: <9c521d0f7b74339d3717273238c89640bdb04602.1374711464.git.shuah.kh@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <cover.1374711464.git.shuah.kh@samsung.com>
References: <cover.1374711464.git.shuah.kh@samsung.com>
In-Reply-To: <cover.1374711464.git.shuah.kh@samsung.com>
References: <cover.1374711464.git.shuah.kh@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add tracing feature to iommu driver to report various iommu events. Classes
iommu_group, iommu_device, iommu_map_unmap, and iommu_amd_event are defined.

iommu_group class events can be enabled to trigger when devices get added
to and removed from an iommu group. Trace information includes iommu group
id and device name.

iommu:add_device_to_group
iommu:remove_device_from_group

iommu_device class events can be enabled to trigger when devices are attached
to and detached from a domain. Trace information includes device name.

iommu:attach_device_to_domain
iommu:detach_device_from_domain

iommu_map_unmap class events can be enabled to trigger when iommu map and
unmap iommu ops complete. Trace information includes iova, physical address
(map event only), and size.

iommu:unmap
iommu:map

iommu_amd_event class can be enabled to trigger when AMD IOMMU driver finds
events when it polls the IOMMU Event Log. Trace information includes the
event string derived from the event type in human friendly form, event type,
id of the domain the device is placed in, device (bus number, slot number,
and function number), address associated with the event, and flags.

iommu:amd_event

Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
---
 drivers/iommu/Makefile       |    1 +
 drivers/iommu/iommu-traces.c |   27 +++++++++++++++++++++++++++
 2 files changed, 28 insertions(+)
 create mode 100644 drivers/iommu/iommu-traces.c

diff --git a/drivers/iommu/Makefile b/drivers/iommu/Makefile
index bbe7041..9015c45 100644
--- a/drivers/iommu/Makefile
+++ b/drivers/iommu/Makefile
@@ -1,4 +1,5 @@
 obj-$(CONFIG_IOMMU_API) += iommu.o
+obj-$(CONFIG_IOMMU_API) += iommu-traces.o
 obj-$(CONFIG_OF_IOMMU)	+= of_iommu.o
 obj-$(CONFIG_MSM_IOMMU) += msm_iommu.o msm_iommu_dev.o
 obj-$(CONFIG_AMD_IOMMU) += amd_iommu.o amd_iommu_init.o
diff --git a/drivers/iommu/iommu-traces.c b/drivers/iommu/iommu-traces.c
new file mode 100644
index 0000000..5b92e4c
--- /dev/null
+++ b/drivers/iommu/iommu-traces.c
@@ -0,0 +1,27 @@
+/*
+ * iommu trace points
+ *
+ * Copyright (C) 2013 Shuah Khan <shuah.kh@samsung.com>
+ *
+ */
+
+#include <linux/string.h>
+#include <linux/types.h>
+
+#define CREATE_TRACE_POINTS
+#include <trace/events/iommu.h>
+
+/* iommu_group_event */
+EXPORT_TRACEPOINT_SYMBOL_GPL(add_device_to_group);
+EXPORT_TRACEPOINT_SYMBOL_GPL(remove_device_from_group);
+
+/* iommu_device_event */
+EXPORT_TRACEPOINT_SYMBOL_GPL(attach_device_to_domain);
+EXPORT_TRACEPOINT_SYMBOL_GPL(detach_device_from_domain);
+
+/* iommu_map_unmap */
+EXPORT_TRACEPOINT_SYMBOL_GPL(map);
+EXPORT_TRACEPOINT_SYMBOL_GPL(unmap);
+
+/* iommu_amd_event */
+EXPORT_TRACEPOINT_SYMBOL_GPL(amd_event);
-- 
1.7.10.4

