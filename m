Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755374AbaDNOx3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 10:53:29 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46587 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751030AbaDNOxR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 10:53:17 -0400
Date: Mon, 14 Apr 2014 07:52:22 -0700
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-e39j1yxanltjx4t0msse63ax@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, namhyung@kernel.org, jolsa@redhat.com,
        fweisbec@gmail.com, adrian.hunter@intel.com, dsahern@gmail.com,
        tglx@linutronix.de, dzickus@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, namhyung@kernel.org, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, adrian.hunter@intel.com,
        tglx@linutronix.de, dzickus@redhat.com
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf callchains:
  Disable unwind libraries when libelf isn't found
Git-Commit-ID: 945895574873101c72a2d90a8cf1e09922378968
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  945895574873101c72a2d90a8cf1e09922378968
Gitweb:     http://git.kernel.org/tip/945895574873101c72a2d90a8cf1e09922378968
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Tue, 25 Mar 2014 09:35:11 -0300
Committer:  Jiri Olsa <jolsa@redhat.com>
CommitDate: Mon, 14 Apr 2014 12:55:01 +0200

perf callchains: Disable unwind libraries when libelf isn't found

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
