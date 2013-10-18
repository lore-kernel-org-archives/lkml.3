Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754239Ab3JRMaw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 08:30:52 -0400
Received: from mga09.intel.com ([134.134.136.24]:2346 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753925Ab3JRMau (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 08:30:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,522,1378882800"; 
   d="scan'208";a="394936483"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 11/19] perf tools: Fix test_on_exit for 32-bit build
Date: Fri, 18 Oct 2013 15:29:08 +0300
Message-Id: <1382099356-4918-12-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1382099356-4918-1-git-send-email-adrian.hunter@intel.com>
References: <1382099356-4918-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

builtin-record.c:42:12: error: static declaration of 'on_exit' follows non-static declaration
In file included from util/util.h:51:0,
                 from builtin.h:4,
                 from builtin-record.c:8:
/usr/include/stdlib.h:536:12: note: previous declaration of 'on_exit' was here

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/config/feature-checks/test-on-exit.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/perf/config/feature-checks/test-on-exit.c b/tools/perf/config/feature-checks/test-on-exit.c
index 8f64ed3..8e88b16 100644
--- a/tools/perf/config/feature-checks/test-on-exit.c
+++ b/tools/perf/config/feature-checks/test-on-exit.c
@@ -1,4 +1,5 @@
 #include <stdio.h>
+#include <stdlib.h>
 
 static void exit_fn(int status, void *__data)
 {
-- 
1.7.11.7

