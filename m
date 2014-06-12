Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964824AbaFLMEg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 08:04:36 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60646 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933754AbaFLMEb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 08:04:31 -0400
Date: Thu, 12 Jun 2014 05:03:43 -0700
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-7e0sfobbzgeydzi9gsz8ss3m@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, namhyung@kernel.org, fweisbec@gmail.com,
        adrian.hunter@intel.com, dsahern@gmail.com, tglx@linutronix.de,
        dzickus@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, namhyung@kernel.org, fweisbec@gmail.com,
        dsahern@gmail.com, adrian.hunter@intel.com, tglx@linutronix.de,
        dzickus@redhat.com
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Emit more precise message for missing glibc static library
Git-Commit-ID: f9ca2d8918979e8ef806a8b6b4635a79b4f40d1a
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

Commit-ID:  f9ca2d8918979e8ef806a8b6b4635a79b4f40d1a
Gitweb:     http://git.kernel.org/tip/f9ca2d8918979e8ef806a8b6b4635a79b4f40d1a
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Thu, 5 Jun 2014 12:46:04 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 9 Jun 2014 12:14:08 -0300

perf tools: Emit more precise message for missing glibc static library

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
index 4f100b5..f30ac5e 100644
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
