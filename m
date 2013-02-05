Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756201Ab3BEAqI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 19:46:08 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:54965 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754431Ab3BEAqF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 19:46:05 -0500
From: Cody P Schafer <cody@linux.vnet.ibm.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Cody P Schafer <cody@linux.vnet.ibm.com>
Subject: [PATCH] tools/perf: don't include libio.h in arch's dwarf-regs.c
Date: Mon,  4 Feb 2013 16:42:05 -0800
Message-Id: <1360024925-13413-1-git-send-email-cody@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.1
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13020500-5406-0000-0000-000004EB07A7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Including libio.h causes build failures on uClibc systems (which lack
libio.h).

It appears that libio.h was only included to pull in a
definition for null, so it has been replaced by stddef.h

On powerpc, libio.h was conditionally included, but could be removed
completely as it is unneeded. Also, the included of stdlib.h was changed
to stddef.h (as again, only NULL is needed).

Build tested on powerpc and x86.

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
---
 tools/perf/arch/powerpc/util/dwarf-regs.c | 5 +----
 tools/perf/arch/s390/util/dwarf-regs.c    | 2 +-
 tools/perf/arch/sh/util/dwarf-regs.c      | 2 +-
 tools/perf/arch/sparc/util/dwarf-regs.c   | 2 +-
 tools/perf/arch/x86/util/dwarf-regs.c     | 2 +-
 5 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/tools/perf/arch/powerpc/util/dwarf-regs.c b/tools/perf/arch/powerpc/util/dwarf-regs.c
index 7cdd61d..733151c 100644
--- a/tools/perf/arch/powerpc/util/dwarf-regs.c
+++ b/tools/perf/arch/powerpc/util/dwarf-regs.c
@@ -9,10 +9,7 @@
  * 2 of the License, or (at your option) any later version.
  */
 
-#include <stdlib.h>
-#ifndef __UCLIBC__
-#include <libio.h>
-#endif
+#include <stddef.h>
 #include <dwarf-regs.h>
 
 
diff --git a/tools/perf/arch/s390/util/dwarf-regs.c b/tools/perf/arch/s390/util/dwarf-regs.c
index e19653e..0469df0 100644
--- a/tools/perf/arch/s390/util/dwarf-regs.c
+++ b/tools/perf/arch/s390/util/dwarf-regs.c
@@ -6,7 +6,7 @@
  *
  */
 
-#include <libio.h>
+#include <stddef.h>
 #include <dwarf-regs.h>
 
 #define NUM_GPRS 16
diff --git a/tools/perf/arch/sh/util/dwarf-regs.c b/tools/perf/arch/sh/util/dwarf-regs.c
index a11edb0..0d0897f 100644
--- a/tools/perf/arch/sh/util/dwarf-regs.c
+++ b/tools/perf/arch/sh/util/dwarf-regs.c
@@ -19,7 +19,7 @@
  *
  */
 
-#include <libio.h>
+#include <stddef.h>
 #include <dwarf-regs.h>
 
 /*
diff --git a/tools/perf/arch/sparc/util/dwarf-regs.c b/tools/perf/arch/sparc/util/dwarf-regs.c
index 0ab8848..92eda41 100644
--- a/tools/perf/arch/sparc/util/dwarf-regs.c
+++ b/tools/perf/arch/sparc/util/dwarf-regs.c
@@ -9,7 +9,7 @@
  * 2 of the License, or (at your option) any later version.
  */
 
-#include <libio.h>
+#include <stddef.h>
 #include <dwarf-regs.h>
 
 #define SPARC_MAX_REGS	96
diff --git a/tools/perf/arch/x86/util/dwarf-regs.c b/tools/perf/arch/x86/util/dwarf-regs.c
index a794d30..be22dd4 100644
--- a/tools/perf/arch/x86/util/dwarf-regs.c
+++ b/tools/perf/arch/x86/util/dwarf-regs.c
@@ -20,7 +20,7 @@
  *
  */
 
-#include <libio.h>
+#include <stddef.h>
 #include <dwarf-regs.h>
 
 /*
-- 
1.8.1.1

