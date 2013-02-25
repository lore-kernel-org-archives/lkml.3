Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759499Ab3BYJxt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 04:53:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:4551 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759078Ab3BYJxX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 04:53:23 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Oleg Nesterov <oleg@redhat.com>
Subject: [PATCH 5/5] perf tests: Add attr stat -C cpu test
Date: Mon, 25 Feb 2013 10:52:52 +0100
Message-Id: <1361785972-7431-6-git-send-email-jolsa@redhat.com>
In-Reply-To: <1361785972-7431-1-git-send-email-jolsa@redhat.com>
References: <1361785972-7431-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding test to validate perf_event_attr data for command:
  'stat -C 0'

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>
---
 tools/perf/tests/attr/test-stat-C0 | 9 +++++++++
 1 file changed, 9 insertions(+)
 create mode 100644 tools/perf/tests/attr/test-stat-C0

diff --git a/tools/perf/tests/attr/test-stat-C0 b/tools/perf/tests/attr/test-stat-C0
new file mode 100644
index 0000000..aa83595
--- /dev/null
+++ b/tools/perf/tests/attr/test-stat-C0
@@ -0,0 +1,9 @@
+[config]
+command = stat
+args    = -e cycles -C 0 kill >/dev/null 2>&1
+ret     = 1
+
+[event:base-stat]
+# events are enabled by default when attached to cpu
+disabled=0
+enable_on_exec=0
-- 
1.7.11.7

