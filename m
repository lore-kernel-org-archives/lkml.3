Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758856AbaGAVuS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 17:50:18 -0400
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.217]:24062 "EHLO
	mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755347AbaGAVrw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 17:47:52 -0400
X-RZG-AUTH: :OH8QVVOrc/CP6za/qRmbF3BWedPGA1vjs2ejZCzW8NRdwTYefHi0JchBpEUIQvhemkXwbmc=
X-RZG-CLASS-ID: mo00
From: Thomas Schoebel-Theuer <tst@schoebel-theuer.de>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 47/50] mars: add new file drivers/block/mars/Makefile
Date: Tue,  1 Jul 2014 23:47:27 +0200
Message-Id: <1404251250-22992-48-git-send-email-tst@schoebel-theuer.de>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1404251250-22992-1-git-send-email-tst@schoebel-theuer.de>
References: <1404251250-22992-1-git-send-email-tst@schoebel-theuer.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thomas Schoebel-Theuer <tst@schoebel-theuer.de>
---
 drivers/block/mars/Makefile | 38 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)
 create mode 100644 drivers/block/mars/Makefile

diff --git a/drivers/block/mars/Makefile b/drivers/block/mars/Makefile
new file mode 100644
index 0000000..6764e8b
--- /dev/null
+++ b/drivers/block/mars/Makefile
@@ -0,0 +1,38 @@
+#
+# Makefile for MARS
+#
+
+obj-$(CONFIG_MARS)	+= mars.o
+
+KBUILD_CFLAGS += -fdelete-null-pointer-checks
+
+mars-objs :=				\
+	lamport.o			\
+	brick_say.o			\
+	brick_mem.o			\
+	brick.o				\
+	xio_bricks/xio.o			\
+	xio_bricks/lib_log.o			\
+	lib_rank.o			\
+	lib_limiter.o			\
+	lib_timing.o			\
+	xio_bricks/lib_mapfree.o			\
+	xio_bricks/xio_net.o			\
+	xio_bricks/xio_server.o			\
+	xio_bricks/xio_client.o			\
+	xio_bricks/xio_aio.o			\
+	xio_bricks/xio_bio.o			\
+	xio_bricks/xio_if.o			\
+	xio_bricks/xio_copy.o			\
+	xio_bricks/xio_trans_logger.o		\
+	mars_light/light_strategy.o		\
+	mars_light/light_net.o			\
+	mars_light/mars_proc.o		\
+	mars_light/mars_light.o
+
+ifdef CONFIG_DEBUG_KERNEL
+
+KBUILD_CFLAGS += -fno-inline-functions -fno-inline-small-functions -fno-inline-functions-called-once
+
+endif
+
-- 
2.0.0

