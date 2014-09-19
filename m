Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757893AbaISFWa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 01:22:30 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53019 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757044AbaISFW0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 01:22:26 -0400
Date: Thu, 18 Sep 2014 22:21:20 -0700
From: tip-bot for Stephane Eranian <tipbot@zytor.com>
Message-ID: <tip-29a3ce31c38c8f73f4e076b7ffc0876b4f5dd6c3@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        namhyung@kernel.org, jolsa@redhat.com, dsahern@gmail.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, acme@redhat.com, peterz@infradead.org,
        namhyung@kernel.org, jolsa@redhat.com, dsahern@gmail.com,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20140905042103.GA3091@quad>
References: <20140905042103.GA3091@quad>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tool: fix compilation for ARM
Git-Commit-ID: 29a3ce31c38c8f73f4e076b7ffc0876b4f5dd6c3
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

Commit-ID:  29a3ce31c38c8f73f4e076b7ffc0876b4f5dd6c3
Gitweb:     http://git.kernel.org/tip/29a3ce31c38c8f73f4e076b7ffc0876b4f5dd6c3
Author:     Stephane Eranian <eranian@google.com>
AuthorDate: Fri, 5 Sep 2014 06:21:04 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 17 Sep 2014 17:08:09 -0300

perf tool: fix compilation for ARM

This patch fixes ARM compile of the perf tool.  The debug.h header file
was missing from a couple of unwind related modules.

Signed-off-by: Stephane Eranian <eranian@google.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/20140905042103.GA3091@quad
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/arch/arm/tests/dwarf-unwind.c    | 1 +
 tools/perf/arch/arm/util/unwind-libunwind.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/tools/perf/arch/arm/tests/dwarf-unwind.c b/tools/perf/arch/arm/tests/dwarf-unwind.c
index 9f870d2..62eff84 100644
--- a/tools/perf/arch/arm/tests/dwarf-unwind.c
+++ b/tools/perf/arch/arm/tests/dwarf-unwind.c
@@ -3,6 +3,7 @@
 #include "thread.h"
 #include "map.h"
 #include "event.h"
+#include "debug.h"
 #include "tests/tests.h"
 
 #define STACK_SIZE 8192
diff --git a/tools/perf/arch/arm/util/unwind-libunwind.c b/tools/perf/arch/arm/util/unwind-libunwind.c
index 729ed69..62c397e 100644
--- a/tools/perf/arch/arm/util/unwind-libunwind.c
+++ b/tools/perf/arch/arm/util/unwind-libunwind.c
@@ -3,6 +3,7 @@
 #include <libunwind.h>
 #include "perf_regs.h"
 #include "../../util/unwind.h"
+#include "../../util/debug.h"
 
 int libunwind__arch_reg_id(int regnum)
 {
