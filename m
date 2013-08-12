Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756285Ab3HLKST (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 06:18:19 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47737 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756061Ab3HLKSP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 06:18:15 -0400
Date: Mon, 12 Aug 2013 03:17:56 -0700
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-9eppxvhkly6gse5ximudckrp@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        tglx@linutronix.de, cjashfor@linux.vnet.ibm.com
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        tglx@linutronix.de, cjashfor@linux.vnet.ibm.com
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tests: Add attr record group sampling test
Git-Commit-ID: 8404db63461af62025f32f8368861fb33604e62f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Mon, 12 Aug 2013 03:18:03 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8404db63461af62025f32f8368861fb33604e62f
Gitweb:     http://git.kernel.org/tip/8404db63461af62025f32f8368861fb33604e62f
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Fri, 1 Feb 2013 19:33:31 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 7 Aug 2013 17:35:23 -0300

perf tests: Add attr record group sampling test

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
