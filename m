Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755231Ab3BDMeM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 07:34:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:24021 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755034Ab3BDMdn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 07:33:43 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: [PATCH 10/11] perf tests: Add attr record group sampling test
Date: Mon,  4 Feb 2013 13:33:04 +0100
Message-Id: <1359981185-16819-11-git-send-email-jolsa@redhat.com>
In-Reply-To: <1359981185-16819-1-git-send-email-jolsa@redhat.com>
References: <1359981185-16819-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding test to validate perf_event_attr data for command:
  'record -e '{cycles,cache-misses}:S'

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/tests/attr/test-record-group-sampling | 36 ++++++++++++++++++++++++
 1 file changed, 36 insertions(+)
 create mode 100644 tools/perf/tests/attr/test-record-group-sampling

diff --git a/tools/perf/tests/attr/test-record-group-sampling b/tools/perf/tests/attr/test-record-group-sampling
new file mode 100644
index 0000000..658f5d6
--- /dev/null
+++ b/tools/perf/tests/attr/test-record-group-sampling
@@ -0,0 +1,36 @@
+[config]
+command = record
+args    = -e '{cycles,cache-misses}:S' kill >/dev/null 2>&1
+
+[event-1:base-record]
+fd=1
+group_fd=-1
+sample_type=343
+read_format=12
+inherit=0
+
+[event-2:base-record]
+fd=2
+group_fd=1
+
+# cache-misses
+type=0
+config=3
+
+# default | PERF_SAMPLE_READ
+sample_type=343
+
+# PERF_FORMAT_ID | PERF_FORMAT_GROUP
+read_format=12
+
+mmap=0
+comm=0
+enable_on_exec=0
+disabled=0
+
+# inherit is disabled for group sampling
+inherit=0
+
+# sampling disabled
+sample_freq=0
+sample_period=0
-- 
1.7.11.7

