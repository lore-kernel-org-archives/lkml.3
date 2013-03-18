Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754253Ab3CRQla (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 12:41:30 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:49349
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751813Ab3CRQZ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 12:25:56 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Cody P Schafer <cody@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 01/54] perf tools: Fix build on non-glibc systems due to libio.h absence
Date: Mon, 18 Mar 2013 13:24:46 -0300
Message-Id: <1363623939-10748-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.1.361.gec3ae6e
In-Reply-To: <1363623939-10748-1-git-send-email-acme@infradead.org>
References: <1363623939-10748-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cody P Schafer <cody@linux.vnet.ibm.com>

Including libio.h causes build failures on uClibc systems (which lack
libio.h).

It appears that libio.h was only included to pull in a definition for
NULL, so it has been replaced by stddef.h.

On powerpc, libio.h was conditionally included, but could be removed
completely as it is unneeded. Also, the included of stdlib.h was changed
to stddef.h (as again, only NULL is needed).

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1363300074-26288-1-git-send-email-cody@linux.vnet.ibm.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/arch/arm/util/dwarf-regs.c     |    5 +----
 tools/perf/arch/powerpc/util/dwarf-regs.c |    5 +----
 tools/perf/arch/s390/util/dwarf-regs.c    |    2 +-
 tools/perf/arch/sh/util/dwarf-regs.c      |    2 +-
 tools/perf/arch/sparc/util/dwarf-regs.c   |    2 +-
 tools/perf/arch/x86/util/dwarf-regs.c     |    2 +-
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
1.7.1

