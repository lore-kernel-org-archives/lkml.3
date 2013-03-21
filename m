Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754791Ab3CUKuA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 06:50:00 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55935 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753358Ab3CUKt7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 06:49:59 -0400
Date: Thu, 21 Mar 2013 03:48:18 -0700
From: tip-bot for Cody P Schafer <tipbot@zytor.com>
Message-ID: <tip-861e10be08c69808065d755d3e3cab5d520a2d32@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        mingo@redhat.com, hpa@zytor.com, mingo@kernel.org,
        cody@linux.vnet.ibm.com, a.p.zijlstra@chello.nl, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, mingo@redhat.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, cody@linux.vnet.ibm.com,
        a.p.zijlstra@chello.nl, tglx@linutronix.de
In-Reply-To: <1363300074-26288-1-git-send-email-cody@linux.vnet.ibm.com>
References: <1363300074-26288-1-git-send-email-cody@linux.vnet.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Fix build on non-glibc systems due to libio.h absence
Git-Commit-ID: 861e10be08c69808065d755d3e3cab5d520a2d32
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 21 Mar 2013 03:48:28 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  861e10be08c69808065d755d3e3cab5d520a2d32
Gitweb:     http://git.kernel.org/tip/861e10be08c69808065d755d3e3cab5d520a2d32
Author:     Cody P Schafer <cody@linux.vnet.ibm.com>
AuthorDate: Thu, 14 Mar 2013 15:27:51 -0700
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 15 Mar 2013 13:05:13 -0300

perf tools: Fix build on non-glibc systems due to libio.h absence

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
