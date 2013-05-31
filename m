Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755821Ab3EaLa7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 07:30:59 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56654 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755777Ab3EaLay (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 07:30:54 -0400
Date: Fri, 31 May 2013 04:30:37 -0700
From: tip-bot for Sukadev Bhattiprolu <tipbot@zytor.com>
Message-ID: <tip-b3539d214f6000217aae97b5ae32df5b03faf850@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, sukadev@linux.vnet.ibm.com, tglx@linutronix.de,
        jolsa@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, tglx@linutronix.de, sukadev@linux.vnet.ibm.com,
        jolsa@redhat.com
In-Reply-To: <20130426173320.GA7029@us.ibm.com>
References: <20130426173320.GA7029@us.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tests: Fix compile errors in bp_signal files
Git-Commit-ID: b3539d214f6000217aae97b5ae32df5b03faf850
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

Commit-ID:  b3539d214f6000217aae97b5ae32df5b03faf850
Gitweb:     http://git.kernel.org/tip/b3539d214f6000217aae97b5ae32df5b03faf850
Author:     Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
AuthorDate: Fri, 26 Apr 2013 10:17:56 -0700
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 28 May 2013 16:23:57 +0300

perf tests: Fix compile errors in bp_signal files

When building on powerpc,  we get compile errors in bp_signal.c and
bp_signal_overflow.c due to __u64 and '%llx'.

Powerpc, needs __SANE_USERSPACE_TYPES__ to be defined so we pick up
<asm-generic/int-ll64.h> and define __u64 as unsigned long long.

Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Link: http://lkml.kernel.org/r/20130426173320.GA7029@us.ibm.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/tests/bp_signal.c          | 6 ++++++
 tools/perf/tests/bp_signal_overflow.c | 6 ++++++
 2 files changed, 12 insertions(+)

diff --git a/tools/perf/tests/bp_signal.c b/tools/perf/tests/bp_signal.c
index 68daa28..aba0954 100644
--- a/tools/perf/tests/bp_signal.c
+++ b/tools/perf/tests/bp_signal.c
@@ -4,6 +4,12 @@
  * (git://github.com/deater/perf_event_tests)
  */
 
+/*
+ * Powerpc needs __SANE_USERSPACE_TYPES__ before <linux/types.h> to select
+ * 'int-ll64.h' and avoid compile warnings when printing __u64 with %llu.
+ */
+#define __SANE_USERSPACE_TYPES__
+
 #include <stdlib.h>
 #include <stdio.h>
 #include <unistd.h>
diff --git a/tools/perf/tests/bp_signal_overflow.c b/tools/perf/tests/bp_signal_overflow.c
index fe7ed28..44ac821 100644
--- a/tools/perf/tests/bp_signal_overflow.c
+++ b/tools/perf/tests/bp_signal_overflow.c
@@ -3,6 +3,12 @@
  * perf_event_tests (git://github.com/deater/perf_event_tests)
  */
 
+/*
+ * Powerpc needs __SANE_USERSPACE_TYPES__ before <linux/types.h> to select
+ * 'int-ll64.h' and avoid compile warnings when printing __u64 with %llu.
+ */
+#define __SANE_USERSPACE_TYPES__
+
 #include <stdlib.h>
 #include <stdio.h>
 #include <unistd.h>
