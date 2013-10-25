Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753529Ab3JYKdY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 06:33:24 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52466 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753431Ab3JYKdW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 06:33:22 -0400
Date: Fri, 25 Oct 2013 03:32:59 -0700
From: tip-bot for Adrian Hunter <tipbot@zytor.com>
Message-ID: <tip-74af377bc25dd9ebcb0be12836abb6b401b5dd08@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        paulus@samba.org, mingo@redhat.com, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, efault@gmx.de, namhyung@gmail.com,
        jolsa@redhat.com, fweisbec@gmail.com, adrian.hunter@intel.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, mingo@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        a.p.zijlstra@chello.nl, efault@gmx.de, namhyung@gmail.com,
        jolsa@redhat.com, fweisbec@gmail.com, dsahern@gmail.com,
        adrian.hunter@intel.com, tglx@linutronix.de
In-Reply-To: <1382427258-17495-2-git-send-email-adrian.hunter@intel.com>
References: <1382427258-17495-2-git-send-email-adrian.hunter@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Fix non-debug build
Git-Commit-ID: 74af377bc25dd9ebcb0be12836abb6b401b5dd08
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Fri, 25 Oct 2013 03:33:05 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  74af377bc25dd9ebcb0be12836abb6b401b5dd08
Gitweb:     http://git.kernel.org/tip/74af377bc25dd9ebcb0be12836abb6b401b5dd08
Author:     Adrian Hunter <adrian.hunter@intel.com>
AuthorDate: Tue, 22 Oct 2013 10:34:05 +0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 23 Oct 2013 11:07:14 -0300

perf tools: Fix non-debug build

In the absence of s DEBUG variable definition on the command line perf
tools was building without optimization.  Fix by assigning DEBUG if it
is not defined.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1382427258-17495-2-git-send-email-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/config/Makefile | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index c516d6b..543aa95 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -66,6 +66,10 @@ ifneq ($(WERROR),0)
   CFLAGS += -Werror
 endif
 
+ifndef DEBUG
+  DEBUG := 0
+endif
+
 ifeq ($(DEBUG),0)
   CFLAGS += -O6
 endif
