Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932214AbaGHTEQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 15:04:16 -0400
Received: from mail.kernel.org ([198.145.19.201]:58197 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754949AbaGHTEL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 15:04:11 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Alexander Yarygin <yarygin@linux.vnet.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Cornelia Huck <cornelia.huck@de.ibm.com>,
        David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 12/16] perf tools: Allow to use cpuinfo on s390
Date: Tue,  8 Jul 2014 16:03:00 -0300
Message-Id: <1404846184-20075-13-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1404846184-20075-1-git-send-email-acme@kernel.org>
References: <1404846184-20075-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Yarygin <yarygin@linux.vnet.ibm.com>

This patch defines CPUINFO_PROC for s390 and implements get_cpuid().

Reviewed-by: Cornelia Huck <cornelia.huck@de.ibm.com>
Reviewed-by: David Ahern <dsahern@gmail.com>
Signed-off-by: Alexander Yarygin <yarygin@linux.vnet.ibm.com>
Acked-by: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/87ioneo7qh.wl%yarygin@linux.vnet.ibm.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/arch/s390/Makefile      |  1 +
 tools/perf/arch/s390/util/header.c | 28 ++++++++++++++++++++++++++++
 tools/perf/perf-sys.h              |  1 +
 3 files changed, 30 insertions(+)
 create mode 100644 tools/perf/arch/s390/util/header.c

diff --git a/tools/perf/arch/s390/Makefile b/tools/perf/arch/s390/Makefile
index 15130b50dfe3..744e629797be 100644
--- a/tools/perf/arch/s390/Makefile
+++ b/tools/perf/arch/s390/Makefile
@@ -2,3 +2,4 @@ ifndef NO_DWARF
 PERF_HAVE_DWARF_REGS := 1
 LIB_OBJS += $(OUTPUT)arch/$(ARCH)/util/dwarf-regs.o
 endif
+LIB_OBJS += $(OUTPUT)arch/$(ARCH)/util/header.o
diff --git a/tools/perf/arch/s390/util/header.c b/tools/perf/arch/s390/util/header.c
new file mode 100644
index 000000000000..9fa6c3e5782c
--- /dev/null
+++ b/tools/perf/arch/s390/util/header.c
@@ -0,0 +1,28 @@
+/*
+ * Implementation of get_cpuid().
+ *
+ * Copyright 2014 IBM Corp.
+ * Author(s): Alexander Yarygin <yarygin@linux.vnet.ibm.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License (version 2 only)
+ * as published by the Free Software Foundation.
+ */
+
+#include <sys/types.h>
+#include <unistd.h>
+#include <stdio.h>
+#include <string.h>
+
+#include "../../util/header.h"
+
+int get_cpuid(char *buffer, size_t sz)
+{
+	const char *cpuid = "IBM/S390";
+
+	if (strlen(cpuid) + 1 > sz)
+		return -1;
+
+	strcpy(buffer, cpuid);
+	return 0;
+}
diff --git a/tools/perf/perf-sys.h b/tools/perf/perf-sys.h
index 5268a1481d23..937e4324ad94 100644
--- a/tools/perf/perf-sys.h
+++ b/tools/perf/perf-sys.h
@@ -54,6 +54,7 @@
 #define mb()		asm volatile("bcr 15,0" ::: "memory")
 #define wmb()		asm volatile("bcr 15,0" ::: "memory")
 #define rmb()		asm volatile("bcr 15,0" ::: "memory")
+#define CPUINFO_PROC	"vendor_id"
 #endif
 
 #ifdef __sh__
-- 
1.9.3

