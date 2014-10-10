Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755246AbaJJUJA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 16:09:00 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:42105 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755121AbaJJUI4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 16:08:56 -0400
From: Sumit Semwal <sumit.semwal@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linaro-mm-sig@lists.linaro.org, linaro-kernel@lists.linaro.org,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [RFC 3/4] cenalloc: Build files for constraint-enabled allocation helpers
Date: Sat, 11 Oct 2014 01:37:57 +0530
Message-Id: <1412971678-4457-4-git-send-email-sumit.semwal@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412971678-4457-1-git-send-email-sumit.semwal@linaro.org>
References: <1412971678-4457-1-git-send-email-sumit.semwal@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the build files for cenalloc, the constraints-enabled allocation
helper framework for dma-buf.

Signed-off-by: Sumit Semwal <sumit.semwal@linaro.org>
Cc: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org
Cc: linaro-mm-sig@lists.linaro.org
---
 drivers/Kconfig           | 2 ++
 drivers/Makefile          | 1 +
 drivers/cenalloc/Kconfig  | 8 ++++++++
 drivers/cenalloc/Makefile | 3 +++
 4 files changed, 14 insertions(+)
 create mode 100644 drivers/cenalloc/Kconfig
 create mode 100644 drivers/cenalloc/Makefile

diff --git a/drivers/Kconfig b/drivers/Kconfig
index 1a693d3..f40d2ce 100644
--- a/drivers/Kconfig
+++ b/drivers/Kconfig
@@ -182,4 +182,6 @@ source "drivers/ras/Kconfig"
 
 source "drivers/thunderbolt/Kconfig"
 
+source "drivers/cenalloc/Kconfig"
+
 endmenu
diff --git a/drivers/Makefile b/drivers/Makefile
index ebee555..a04e516 100644
--- a/drivers/Makefile
+++ b/drivers/Makefile
@@ -161,3 +161,4 @@ obj-$(CONFIG_POWERCAP)		+= powercap/
 obj-$(CONFIG_MCB)		+= mcb/
 obj-$(CONFIG_RAS)		+= ras/
 obj-$(CONFIG_THUNDERBOLT)	+= thunderbolt/
+obj-$(CONFIG_CENALLOC)          += cenalloc/
diff --git a/drivers/cenalloc/Kconfig b/drivers/cenalloc/Kconfig
new file mode 100644
index 0000000..9472d5d
--- /dev/null
+++ b/drivers/cenalloc/Kconfig
@@ -0,0 +1,8 @@
+menuconfig CENALLOC
+	bool "cenalloc helper functions"
+	default n
+	select ANON_INODES
+	help
+	  This option enables the helper allocation framework for drivers using
+	  dma-buf buffer-sharing. It uses constraints of participating devices
+	  to help find out best suited allocator.
diff --git a/drivers/cenalloc/Makefile b/drivers/cenalloc/Makefile
new file mode 100644
index 0000000..d36b531
--- /dev/null
+++ b/drivers/cenalloc/Makefile
@@ -0,0 +1,3 @@
+# Makefile for the cenalloc helper
+
+obj-y				+= cenalloc.o
-- 
1.9.1

