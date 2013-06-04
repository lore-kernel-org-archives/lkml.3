Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754899Ab3FDNh6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 09:37:58 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:43775 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753337Ab3FDNhx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 09:37:53 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 1/2] xen-blkfront: Introduce a 'max' module parameter to alter the amount of indirect segments.
Date: Tue,  4 Jun 2013 09:37:42 -0400
Message-Id: <1370353063-13033-2-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1370353063-13033-1-git-send-email-konrad.wilk@oracle.com>
References: <1370353063-13033-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The max module parameter (by default 32) is the maximum number of
segments that the frontend will negotiate with the backend for indirect
descriptors.  Higher value means more potential throughput but more
memory usage. The backend picks the minimum of the frontend and its
default backend value.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 Documentation/ABI/testing/sysfs-driver-xen-blkfront | 10 ++++++++++
 drivers/block/xen-blkfront.c                        |  2 ++
 2 files changed, 12 insertions(+)
 create mode 100644 Documentation/ABI/testing/sysfs-driver-xen-blkfront

diff --git a/Documentation/ABI/testing/sysfs-driver-xen-blkfront b/Documentation/ABI/testing/sysfs-driver-xen-blkfront
new file mode 100644
index 0000000..c0a6cb7
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-driver-xen-blkfront
@@ -0,0 +1,10 @@
+What:           /sys/module/xen_blkfront/parameters/max
+Date:           June 2013
+KernelVersion:  3.11
+Contact:        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
+Description:
+                Maximum number of segments that the frontend will negotiate
+                with the backend for indirect descriptors. The default value
+                is 32 - higher value means more potential throughput but more
+                memory usage. The backend picks the minimum of the frontend
+                and its default backend value.
diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
index cc1e254..618f06c 100644
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -95,6 +95,8 @@ static const struct block_device_operations xlvbd_block_fops;
  */
 
 static unsigned int xen_blkif_max_segments = 32;
+module_param_named(max, xen_blkif_max_segments, int, S_IRUGO);
+MODULE_PARM_DESC(max, "Maximum amount of segments in indirect requests (default is 32)");
 
 #define BLK_RING_SIZE __CONST_RING_SIZE(blkif, PAGE_SIZE)
 
-- 
1.8.1.4

