Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756137Ab3CULAi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 07:00:38 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56115 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753846Ab3CULAh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 07:00:37 -0400
Date: Thu, 21 Mar 2013 03:58:49 -0700
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-9687b89d21999301ed386855c04b60d00ed1ec02@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        dsahern@gmail.com, oleg@redhat.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        dsahern@gmail.com, oleg@redhat.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <1361785972-7431-6-git-send-email-jolsa@redhat.com>
References: <1361785972-7431-6-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tests: Add attr stat -C cpu test
Git-Commit-ID: 9687b89d21999301ed386855c04b60d00ed1ec02
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 21 Mar 2013 03:59:00 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9687b89d21999301ed386855c04b60d00ed1ec02
Gitweb:     http://git.kernel.org/tip/9687b89d21999301ed386855c04b60d00ed1ec02
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Mon, 25 Feb 2013 10:52:52 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 15 Mar 2013 13:06:00 -0300

perf tests: Add attr stat -C cpu test

Adding test to validate perf_event_attr data for command:
  'stat -C 0'

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1361785972-7431-6-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/tests/attr/test-stat-C0 | 9 +++++++++
 1 file changed, 9 insertions(+)

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
