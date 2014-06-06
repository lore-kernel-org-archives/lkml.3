Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752018AbaFFOMK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 10:12:10 -0400
Received: from mail.kernel.org ([198.145.19.201]:54526 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751919AbaFFOMF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 10:12:05 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>, Don Zickus <dzickus@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Mike Galbraith <efault@gmx.de>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 1/2] perf tools: Emit more precise message for missing glibc static library
Date: Fri,  6 Jun 2014 11:11:48 -0300
Message-Id: <1402063909-13859-2-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1402063909-13859-1-git-send-email-acme@kernel.org>
References: <1402063909-13859-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

When the user does:

  make -C tools/perf LDFLAGS=-static

asking for a static build, and the glibc-static (or equivalent) is not
found, the message wasn't clear, stating that one of glibc-devel or
glibc-static wasn't installed, clarify it checking if -static is
present in LDFLAGS.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-7e0sfobbzgeydzi9gsz8ss3m@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/config/Makefile | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index 4f100b54ba8b..f30ac5e5d271 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -299,7 +299,11 @@ else
       NO_LIBUNWIND := 1
       NO_LIBDW_DWARF_UNWIND := 1
     else
-      msg := $(error No gnu/libc-version.h found, please install glibc-dev[el]/glibc-static);
+      ifneq ($(filter s% -static%,$(LDFLAGS),),)
+        msg := $(error No static glibc found, please install glibc-static);
+      else
+        msg := $(error No gnu/libc-version.h found, please install glibc-dev[el]);
+      endif
     endif
   else
     ifndef NO_LIBDW_DWARF_UNWIND
-- 
1.9.3

