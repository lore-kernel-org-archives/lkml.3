Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933241AbaHYOsJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 10:48:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8469 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933138AbaHYOqa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 10:46:30 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@kernel.org>, Andi Kleen <andi@firstfloor.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>,
        "Jen-Cheng(Tommy) Huang" <tommy24@gatech.edu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 5/9] perf tools: Add pr_warning_once debug macro
Date: Mon, 25 Aug 2014 16:45:39 +0200
Message-Id: <1408977943-16594-6-git-send-email-jolsa@kernel.org>
In-Reply-To: <1408977943-16594-1-git-send-email-jolsa@kernel.org>
References: <1408977943-16594-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding pr_warning_once debug macro to display
pr_warning message just once. It will be used
in following patch.

Cc: Andi Kleen <andi@firstfloor.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jen-Cheng(Tommy) Huang <tommy24@gatech.edu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/util/debug.h | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/tools/perf/util/debug.h b/tools/perf/util/debug.h
index be264d6f3b30..be0399c2703d 100644
--- a/tools/perf/util/debug.h
+++ b/tools/perf/util/debug.h
@@ -31,6 +31,18 @@ extern int debug_ordered_events;
 #define pr_debug3(fmt, ...) pr_debugN(3, pr_fmt(fmt), ##__VA_ARGS__)
 #define pr_debug4(fmt, ...) pr_debugN(4, pr_fmt(fmt), ##__VA_ARGS__)
 
+#define pr_once(fmt, pr, ...)			\
+	do {					\
+		static int __warned;		\
+						\
+		if (!__warned) {		\
+			pr(fmt, ##__VA_ARGS__);	\
+			__warned = 1;		\
+		}				\
+	} while (0)
+
+#define pr_warning_once(fmt, ...) pr_once(fmt, pr_warning, ##__VA_ARGS__)
+
 #define pr_time_N(n, var, t, fmt, ...) \
 	eprintf_time(n, var, t, fmt, ##__VA_ARGS__)
 
-- 
1.8.3.1

