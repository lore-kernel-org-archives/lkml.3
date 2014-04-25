Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753286AbaDYJPV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 05:15:21 -0400
Received: from e06smtp16.uk.ibm.com ([195.75.94.112]:56949 "EHLO
	e06smtp16.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753098AbaDYJMV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 05:12:21 -0400
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Jiri Olsa <jolsa@redhat.com>
Cc: KVM <kvm@vger.kernel.org>, linux-s390 <linux-s390@vger.kernel.org>,
        Cornelia Huck <cornelia.huck@de.ibm.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Alexander Yarygin <yarygin@linux.vnet.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Subject: [PATCH 10/11] perf: allow to use cpuinfo on s390
Date: Fri, 25 Apr 2014 11:12:32 +0200
Message-Id: <1398417153-57347-11-git-send-email-borntraeger@de.ibm.com>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1398417153-57347-1-git-send-email-borntraeger@de.ibm.com>
References: <1398417153-57347-1-git-send-email-borntraeger@de.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14042509-3548-0000-0000-000008D9FB7B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Yarygin <yarygin@linux.vnet.ibm.com>

This patch defines CPUINFO_PROC for s390 and implements get_cpuid().

Signed-off-by: Alexander Yarygin <yarygin@linux.vnet.ibm.com>
Reviewed-by: Cornelia Huck <cornelia.huck@de.ibm.com>
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
---
 tools/perf/arch/s390/Makefile      |  1 +
 tools/perf/arch/s390/util/header.c | 17 +++++++++++++++++
 tools/perf/perf.h                  |  1 +
 3 files changed, 19 insertions(+)
 create mode 100644 tools/perf/arch/s390/util/header.c

diff --git a/tools/perf/arch/s390/Makefile b/tools/perf/arch/s390/Makefile
index 15130b5..744e629 100644
--- a/tools/perf/arch/s390/Makefile
+++ b/tools/perf/arch/s390/Makefile
@@ -2,3 +2,4 @@ ifndef NO_DWARF
 PERF_HAVE_DWARF_REGS := 1
 LIB_OBJS += $(OUTPUT)arch/$(ARCH)/util/dwarf-regs.o
 endif
+LIB_OBJS += $(OUTPUT)arch/$(ARCH)/util/header.o
diff --git a/tools/perf/arch/s390/util/header.c b/tools/perf/arch/s390/util/header.c
new file mode 100644
index 0000000..8b2ed46
--- /dev/null
+++ b/tools/perf/arch/s390/util/header.c
@@ -0,0 +1,17 @@
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
diff --git a/tools/perf/perf.h b/tools/perf/perf.h
index 5c11eca..6f6772d 100644
--- a/tools/perf/perf.h
+++ b/tools/perf/perf.h
@@ -43,6 +43,7 @@
 #define mb()		asm volatile("bcr 15,0" ::: "memory")
 #define wmb()		asm volatile("bcr 15,0" ::: "memory")
 #define rmb()		asm volatile("bcr 15,0" ::: "memory")
+#define CPUINFO_PROC	"vendor_id"
 #endif
 
 #ifdef __sh__
-- 
1.8.4.2

