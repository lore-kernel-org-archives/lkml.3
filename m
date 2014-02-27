Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752976AbaB0N3X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 08:29:23 -0500
Received: from terminus.zytor.com ([198.137.202.10]:54735 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752936AbaB0N3S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 08:29:18 -0500
Date: Thu, 27 Feb 2014 05:28:34 -0800
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-huoxnou7sw85lm58k3pi1xhw@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, namhyung@kernel.org, jolsa@redhat.com,
        fweisbec@gmail.com, adrian.hunter@intel.com, dsahern@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, namhyung@kernel.org, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, adrian.hunter@intel.com,
        tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Warn the user about how to enable libunwind support
Git-Commit-ID: 7a0447d61d2d754988add992be2b46d4587ae86a
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

Commit-ID:  7a0447d61d2d754988add992be2b46d4587ae86a
Gitweb:     http://git.kernel.org/tip/7a0447d61d2d754988add992be2b46d4587ae86a
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Thu, 20 Feb 2014 16:08:18 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 24 Feb 2014 09:29:36 -0300

perf tools: Warn the user about how to enable libunwind support

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
index 97a64c4..9429805 100644
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
