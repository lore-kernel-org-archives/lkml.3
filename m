Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757904AbaDHSDe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 14:03:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63455 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757701AbaDHSCF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 14:02:05 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>, Don Zickus <dzickus@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 05/10] perf callchains: Disable unwind libraries when libelf isn't found
Date: Tue,  8 Apr 2014 20:01:03 +0200
Message-Id: <1396980068-27124-6-git-send-email-jolsa@redhat.com>
In-Reply-To: <1396980068-27124-1-git-send-email-jolsa@redhat.com>
References: <1396980068-27124-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

I.e. do the same as when NO_LIBELF is explicitely passed in the 'make'
command line, fixing this:

  Auto-detecting system features:
  ...                         dwarf: [ OFF ]
  ...                         glibc: [ on  ]
  ...                          gtk2: [ OFF ]
  ...                      libaudit: [ OFF ]
  ...                        libbfd: [ OFF ]
  ...                        libelf: [ OFF ]
  ...                     libunwind: [ OFF ]
  ...            libdw-dwarf-unwind: [ OFF ]
  ...     DWARF post unwind library: libdw
<SNIP>
    CC       /tmp/build/perf/util/symbol-minimal.o
    CC       /tmp/build/perf/util/unwind-libdw.o
  arch/x86/util/unwind-libdw.c:1:30: fatal error: elfutils/libdwfl.h: No such file or directory
  compilation terminated.
    CC       /tmp/build/perf/tests/keep-tracking.o
  util/unwind-libdw.c:2:28: fatal error: elfutils/libdw.h: No such file or directory
  compilation terminated.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-e39j1yxanltjx4t0msse63ax@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 tools/perf/config/Makefile | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index c234182..5a3c452 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -278,6 +278,8 @@ else
       NO_LIBELF := 1
       NO_DWARF := 1
       NO_DEMANGLE := 1
+      NO_LIBUNWIND := 1
+      NO_LIBDW_DWARF_UNWIND := 1
     else
       msg := $(error No gnu/libc-version.h found, please install glibc-dev[el]/glibc-static);
     endif
-- 
1.8.3.1

