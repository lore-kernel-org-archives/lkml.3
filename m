Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753551Ab3CNW2g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 18:28:36 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:40523 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753405Ab3CNW2e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 18:28:34 -0400
From: Cody P Schafer <cody@linux.vnet.ibm.com>
Cc: Cody P Schafer <cody@linux.vnet.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org
Subject: [RESEND PATCH] tools/perf: fix build on non-glibc systems due to libio.h absence
Date: Thu, 14 Mar 2013 15:27:51 -0700
Message-Id: <1363300074-26288-1-git-send-email-cody@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13031422-3620-0000-0000-000001A1D458
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Including libio.h causes build failures on uClibc systems (which lack
libio.h).

It appears that libio.h was only included to pull in a definition for
NULL, so it has been replaced by stddef.h.

On powerpc, libio.h was conditionally included, but could be removed
completely as it is unneeded. Also, the included of stdlib.h was changed
to stddef.h (as again, only NULL is needed).

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
---
 tools/perf/arch/arm/util/dwarf-regs.c     | 5 +----
 tools/perf/arch/powerpc/util/dwarf-regs.c | 5 +----
 tools/perf/arch/s390/util/dwarf-regs.c    | 2 +-
 tools/perf/arch/sh/util/dwarf-regs.c      | 2 +-
 tools/perf/arch/sparc/util/dwarf-regs.c   | 2 +-
 tools/perf/arch/x86/util/dwarf-regs.c     | 2 +-
 6 files changed, 6 insertions(+), 12 deletions(-)

diff --git a/tools/perf/arch/arm/util/dwarf-regs.c b/tools/perf/arch/arm/util/dwarf-regs.c
index e8d5c55..33ec5b3 100644
--- a/tools/perf/arch/arm/util/dwarf-regs.c
+++ b/tools/perf/arch/arm/util/dwarf-regs.c
@@ -8,10 +8,7 @@
  * published by the Free Software Foundation.
  */
 
-#include <stdlib.h>
-#ifndef __UCLIBC__
-#include <libio.h>
-#endif
+#include <stddef.h>
 #include <dwarf-regs.h>
 
 struct pt_regs_dwarfnum {
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
1.8.1.5

