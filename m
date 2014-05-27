Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752548AbaE0NgK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 09:36:10 -0400
Received: from smtp7.sms.unimo.it ([155.185.44.150]:56585 "EHLO
	smtp7.sms.unimo.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752413AbaE0NgE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 09:36:04 -0400
From: paolo <paolo.valente@unimore.it>
To: Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>,
        Li Zefan <lizefan@huawei.com>
Cc: Fabio Checconi <fchecconi@gmail.com>,
        Arianna Avanzini <avanzini.arianna@gmail.com>,
        Paolo Valente <posta_paolo@yahoo.it>, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        Paolo Valente <paolo.valente@unimore.it>
Subject: [PATCH RFC RESEND 01/14] block: kconfig update and build bits for BFQ
Date: Tue, 27 May 2014 14:42:25 +0200
Message-Id: <1401194558-5283-2-git-send-email-paolo.valente@unimore.it>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1401194558-5283-1-git-send-email-paolo.valente@unimore.it>
References: <1401194558-5283-1-git-send-email-paolo.valente@unimore.it>
UNIMORE-X-SA-Score: -2.9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fabio Checconi <fchecconi@gmail.com>

Update Kconfig.iosched and make the related Makefile changes to include
kernel-configuration options for BFQ.

Signed-off-by: Fabio Checconi <fchecconi@gmail.com>
Signed-off-by: Paolo Valente <paolo.valente@unimore.it>
Signed-off-by: Arianna Avanzini <avanzini.arianna@gmail.com>
---
 block/Kconfig.iosched | 19 +++++++++++++++++++
 block/Makefile        |  1 +
 2 files changed, 20 insertions(+)

diff --git a/block/Kconfig.iosched b/block/Kconfig.iosched
index 421bef9..8f98cc7 100644
--- a/block/Kconfig.iosched
+++ b/block/Kconfig.iosched
@@ -39,6 +39,15 @@ config CFQ_GROUP_IOSCHED
 	---help---
 	  Enable group IO scheduling in CFQ.
 
+config IOSCHED_BFQ
+	tristate "BFQ I/O scheduler"
+	default n
+	---help---
+	  The BFQ I/O scheduler tries to distribute bandwidth among all
+	  processes according to their weights.
+	  It aims at distributing the bandwidth as desired, regardless
+	  of the disk parameters and with any workload.
+
 choice
 	prompt "Default I/O scheduler"
 	default DEFAULT_CFQ
@@ -52,6 +61,15 @@ choice
 	config DEFAULT_CFQ
 		bool "CFQ" if IOSCHED_CFQ=y
 
+	config DEFAULT_BFQ
+		bool "BFQ" if IOSCHED_BFQ=y
+		help
+		  Selects BFQ as the default I/O scheduler which will be
+		  used by default for all block devices.
+		  The BFQ I/O scheduler aims at distributing the bandwidth
+		  as desired, regardless of the disk parameters and with
+		  any workload.
+
 	config DEFAULT_NOOP
 		bool "No-op"
 
@@ -61,6 +79,7 @@ config DEFAULT_IOSCHED
 	string
 	default "deadline" if DEFAULT_DEADLINE
 	default "cfq" if DEFAULT_CFQ
+	default "bfq" if DEFAULT_BFQ
 	default "noop" if DEFAULT_NOOP
 
 endmenu
diff --git a/block/Makefile b/block/Makefile
index 20645e8..cbd83fb 100644
--- a/block/Makefile
+++ b/block/Makefile
@@ -16,6 +16,7 @@ obj-$(CONFIG_BLK_DEV_THROTTLING)	+= blk-throttle.o
 obj-$(CONFIG_IOSCHED_NOOP)	+= noop-iosched.o
 obj-$(CONFIG_IOSCHED_DEADLINE)	+= deadline-iosched.o
 obj-$(CONFIG_IOSCHED_CFQ)	+= cfq-iosched.o
+obj-$(CONFIG_IOSCHED_BFQ)	+= bfq-iosched.o
 
 obj-$(CONFIG_BLOCK_COMPAT)	+= compat_ioctl.o
 obj-$(CONFIG_BLK_DEV_INTEGRITY)	+= blk-integrity.o
-- 
1.9.2

