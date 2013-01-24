Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754717Ab3AXLL0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 06:11:26 -0500
Received: from us01smtp2.synopsys.com ([198.182.44.80]:51405 "EHLO
	kiruna.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753602Ab3AXLLO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 06:11:14 -0500
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <arnd@arndb.de>, Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        Robert Richter <rric@kernel.org>, <oprofile-list@lists.sf.net>
Subject: [PATCH v3 40/71] ARC: OProfile support
Date: Thu, 24 Jan 2013 16:36:08 +0530
Message-ID: <1359025589-22277-25-git-send-email-vgupta@synopsys.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1359025589-22277-1-git-send-email-vgupta@synopsys.com>
References: <1359025589-22277-1-git-send-email-vgupta@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.12.197.205]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
Cc: Robert Richter <rric@kernel.org>
Cc: oprofile-list@lists.sf.net
---
 arch/arc/Kconfig           |    1 +
 arch/arc/Makefile          |    2 ++
 arch/arc/oprofile/Makefile |    9 +++++++++
 arch/arc/oprofile/common.c |   22 ++++++++++++++++++++++
 4 files changed, 34 insertions(+), 0 deletions(-)
 create mode 100644 arch/arc/oprofile/Makefile
 create mode 100644 arch/arc/oprofile/common.c

diff --git a/arch/arc/Kconfig b/arch/arc/Kconfig
index 409b937..405ea7a 100644
--- a/arch/arc/Kconfig
+++ b/arch/arc/Kconfig
@@ -25,6 +25,7 @@ config ARC
 	select HAVE_ARCH_TRACEHOOK
 	select HAVE_GENERIC_HARDIRQS
 	select HAVE_MEMBLOCK
+	select HAVE_OPROFILE
 	select IRQ_DOMAIN
 	select MODULES_USE_ELF_RELA
 	select NO_BOOTMEM
diff --git a/arch/arc/Makefile b/arch/arc/Makefile
index 4247f48..4f28f5b 100644
--- a/arch/arc/Makefile
+++ b/arch/arc/Makefile
@@ -100,6 +100,8 @@ ifneq ($(platform-y),)
 core-y		+= arch/arc/plat-$(PLATFORM)/
 endif
 
+drivers-$(CONFIG_OPROFILE)	+= arch/arc/oprofile/
+
 libs-y		+= arch/arc/lib/ $(LIBGCC)
 
 #default target for make without any arguements.
diff --git a/arch/arc/oprofile/Makefile b/arch/arc/oprofile/Makefile
new file mode 100644
index 0000000..ce417a6
--- /dev/null
+++ b/arch/arc/oprofile/Makefile
@@ -0,0 +1,9 @@
+obj-$(CONFIG_OPROFILE) += oprofile.o
+
+DRIVER_OBJS = $(addprefix ../../../drivers/oprofile/, \
+		oprof.o cpu_buffer.o buffer_sync.o \
+		event_buffer.o oprofile_files.o \
+		oprofilefs.o oprofile_stats.o \
+		timer_int.o )
+
+oprofile-y	:= $(DRIVER_OBJS) common.o
diff --git a/arch/arc/oprofile/common.c b/arch/arc/oprofile/common.c
new file mode 100644
index 0000000..917ae16
--- /dev/null
+++ b/arch/arc/oprofile/common.c
@@ -0,0 +1,22 @@
+/*
+ * Copyright (C) 2004, 2007-2010, 2011-2012 Synopsys, Inc. (www.synopsys.com)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * Based on orig code from @author John Levon <levon@movementarian.org>
+ */
+
+#include <linux/oprofile.h>
+#include <linux/perf_event.h>
+
+int __init oprofile_arch_init(struct oprofile_operations *ops)
+{
+	return oprofile_perf_init(ops);
+}
+
+void oprofile_arch_exit(void)
+{
+	oprofile_perf_exit();
+}
-- 
1.7.4.1

