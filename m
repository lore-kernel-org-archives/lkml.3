Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933612Ab3HGV0C (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 17:26:02 -0400
Received: from merlin.infradead.org ([205.233.59.134]:46936 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933263Ab3HGVLZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 17:11:25 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 09/47] perf tests: Add attr record group sampling test
Date: Wed,  7 Aug 2013 18:10:36 -0300
Message-Id: <1375909874-22073-10-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1375909874-22073-1-git-send-email-acme@infradead.org>
References: <1375909874-22073-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

Adding test to validate perf_event_attr data for command:

  'record -e '{cycles,cache-misses}:S'

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/n/tip-9eppxvhkly6gse5ximudckrp@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
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
1.8.1.4

