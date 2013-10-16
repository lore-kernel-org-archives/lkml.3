Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760073Ab3JPCJo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 22:09:44 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:33965 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758995Ab3JPCHN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 22:07:13 -0400
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: <linux-kernel@vger.kernel.org>, linuxppc-dev@ozlabs.org,
        Stephane Eranian <eranian@google.com>,
        Michael Ellerman <michaele@au1.ibm.com>,
        Paul Mackerras <paulus@samba.org>,
        Anshuman Khandual <khandual@linux.vnet.ibm.com>
Subject: [PATCH 04/10][v6] tools/perf: Remove local byteorder.h.
Date: Tue, 15 Oct 2013 19:06:36 -0700
Message-Id: <1381889202-16826-5-git-send-email-sukadev@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1381889202-16826-1-git-send-email-sukadev@linux.vnet.ibm.com>
References: <1381889202-16826-1-git-send-email-sukadev@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13101602-5806-0000-0000-00002315907C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the local tools/perf/util/include/asm/byteorder.h and add
a few missing typedefs to tools/perf/util/include/linux/types.h.

The local byteorder.h complicates defining big/little endian versions
of data structures in include/uapi/linux/perf_event.h.

Fix proposed by Michael Ellerman.

Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
---
 tools/perf/Makefile                     |    1 -
 tools/perf/util/include/asm/byteorder.h |    2 --
 tools/perf/util/include/linux/types.h   |   20 ++++++++++++++++++++
 3 files changed, 20 insertions(+), 3 deletions(-)
 delete mode 100644 tools/perf/util/include/asm/byteorder.h

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index b62e12d..3c4a7d9 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -225,7 +225,6 @@ LIB_H += util/include/linux/types.h
 LIB_H += util/include/linux/linkage.h
 LIB_H += util/include/asm/asm-offsets.h
 LIB_H += util/include/asm/bug.h
-LIB_H += util/include/asm/byteorder.h
 LIB_H += util/include/asm/hweight.h
 LIB_H += util/include/asm/swab.h
 LIB_H += util/include/asm/system.h
diff --git a/tools/perf/util/include/asm/byteorder.h b/tools/perf/util/include/asm/byteorder.h
deleted file mode 100644
index 2a9bdc0..0000000
--- a/tools/perf/util/include/asm/byteorder.h
+++ /dev/null
@@ -1,2 +0,0 @@
-#include <asm/types.h>
-#include "../../../../include/uapi/linux/swab.h"
diff --git a/tools/perf/util/include/linux/types.h b/tools/perf/util/include/linux/types.h
index eb46478..775f68e 100644
--- a/tools/perf/util/include/linux/types.h
+++ b/tools/perf/util/include/linux/types.h
@@ -7,10 +7,30 @@
 #define __bitwise
 #endif
 
+#ifndef __le16
+typedef __u16 __bitwise __le16;
+#endif
+
 #ifndef __le32
 typedef __u32 __bitwise __le32;
 #endif
 
+#ifndef __be16
+typedef __u16 __bitwise __be16;
+#endif
+
+#ifndef __le64
+typedef __u64 __bitwise __le64;
+#endif
+
+#ifndef __be32
+typedef __u32 __bitwise __be32;
+#endif
+
+#ifndef __be64
+typedef __u64 __bitwise __be64;
+#endif
+
 #define DECLARE_BITMAP(name,bits) \
 	unsigned long name[BITS_TO_LONGS(bits)]
 
-- 
1.7.9.5

