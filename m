Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753468AbaBXT5T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 14:57:19 -0500
Received: from merlin.infradead.org ([205.233.59.134]:49166 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753411AbaBXT45 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 14:56:57 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 06/12] perf tools: Warn the user about how to enable libunwind support
Date: Mon, 24 Feb 2014 16:56:34 -0300
Message-Id: <1393271800-17505-7-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1393271800-17505-1-git-send-email-acme@infradead.org>
References: <1393271800-17505-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

When one has libunwind installed somewhere the perf tools build process
doesn't expects it to be, this happens:

  [acme@ssdandy linux]$ make O=/tmp/build/perf -C tools/perf/ install-bin
  make: Entering directory `/home/acme/git/linux/tools/perf'
    BUILD:   Doing 'make -j8' parallel build
  config/Makefile:312: No libunwind found, disabling post unwind support.  Please install libunwind-dev[el] >= 1.1

  Auto-detecting system features:
  <SNIP>
  ...                     libunwind: [ OFF ]

Change the message so that it tells how to use a non-standard libunwind
install directory:

  config/Makefile:312: No libunwind found, disabling post unwind support.  Please install libunwind-dev[el] >= 1.1 and/or set LIBUNWIND_DIR

  [acme@ssdandy linux]$ make LIBUNWIND_DIR=/opt/libunwind-git/ O=/tmp/build/perf -C tools/perf/ install-bin
  make: Entering directory `/home/acme/git/linux/tools/perf'
    BUILD:   Doing 'make -j8' parallel build

  Auto-detecting system features:
  <SNIP>
  ...                     libunwind: [ on  ]

Acked-by: Jiri Olsa <jolsa@redhat.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-huoxnou7sw85lm58k3pi1xhw@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/config/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index 97a64c4631d3..9429805f395c 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -309,7 +309,7 @@ endif # NO_LIBELF
 
 ifndef NO_LIBUNWIND
   ifneq ($(feature-libunwind), 1)
-    msg := $(warning No libunwind found, disabling post unwind support. Please install libunwind-dev[el] >= 1.1);
+    msg := $(warning No libunwind found, disabling post unwind support. Please install libunwind-dev[el] >= 1.1 and/or set LIBUNWIND_DIR);
     NO_LIBUNWIND := 1
   else
     ifeq ($(ARCH),arm)
-- 
1.8.1.4

