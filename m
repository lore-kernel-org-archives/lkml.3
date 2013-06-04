Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754386Ab3FDNhy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 09:37:54 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:43770 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751733Ab3FDNhx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 09:37:53 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 2/2] xen-blkback/sysfs: Move the parameters for the persistent grant features
Date: Tue,  4 Jun 2013 09:37:43 -0400
Message-Id: <1370353063-13033-3-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1370353063-13033-1-git-send-email-konrad.wilk@oracle.com>
References: <1370353063-13033-1-git-send-email-konrad.wilk@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

to a testing subdirectory (as this value should not be baked
for the life-time) and also in an appropiate file.

Also modified the introduction Linux version from 3.10 to 3.11.
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 Documentation/ABI/stable/sysfs-bus-xen-backend     | 18 ------------------
 Documentation/ABI/testing/sysfs-driver-xen-blkback | 17 +++++++++++++++++
 2 files changed, 17 insertions(+), 18 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-driver-xen-blkback

diff --git a/Documentation/ABI/stable/sysfs-bus-xen-backend b/Documentation/ABI/stable/sysfs-bus-xen-backend
index 947db11..3d5951c 100644
--- a/Documentation/ABI/stable/sysfs-bus-xen-backend
+++ b/Documentation/ABI/stable/sysfs-bus-xen-backend
@@ -73,21 +73,3 @@ KernelVersion:	3.0
 Contact:	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
 Description:
                 Number of sectors written by the frontend.
-
-What:           /sys/module/xen_blkback/parameters/max_buffer_pages
-Date:           March 2013
-KernelVersion:  3.10
-Contact:        Roger Pau Monné <roger.pau@citrix.com>
-Description:
-                Maximum number of free pages to keep in each block
-                backend buffer.
-
-What:           /sys/module/xen_blkback/parameters/max_persistent_grants
-Date:           March 2013
-KernelVersion:  3.10
-Contact:        Roger Pau Monné <roger.pau@citrix.com>
-Description:
-                Maximum number of grants to map persistently in
-                blkback. If the frontend tries to use more than
-                max_persistent_grants, the LRU kicks in and starts
-                removing 5% of max_persistent_grants every 100ms.
diff --git a/Documentation/ABI/testing/sysfs-driver-xen-blkback b/Documentation/ABI/testing/sysfs-driver-xen-blkback
new file mode 100644
index 0000000..8bb43b6
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-driver-xen-blkback
@@ -0,0 +1,17 @@
+What:           /sys/module/xen_blkback/parameters/max_buffer_pages
+Date:           March 2013
+KernelVersion:  3.11
+Contact:        Roger Pau Monné <roger.pau@citrix.com>
+Description:
+                Maximum number of free pages to keep in each block
+                backend buffer.
+
+What:           /sys/module/xen_blkback/parameters/max_persistent_grants
+Date:           March 2013
+KernelVersion:  3.11
+Contact:        Roger Pau Monné <roger.pau@citrix.com>
+Description:
+                Maximum number of grants to map persistently in
+                blkback. If the frontend tries to use more than
+                max_persistent_grants, the LRU kicks in and starts
+                removing 5% of max_persistent_grants every 100ms.
-- 
1.8.1.4

