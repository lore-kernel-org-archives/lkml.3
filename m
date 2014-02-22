Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752874AbaBVR5Y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Feb 2014 12:57:24 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40850 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752814AbaBVR5T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Feb 2014 12:57:19 -0500
Date: Sat, 22 Feb 2014 09:56:52 -0800
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-a601fdff1af20ea0208e918f5e97a247a3c37a40@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, andi@firstfloor.org,
        a.p.zijlstra@chello.nl, namhyung@kernel.org, jolsa@redhat.com,
        adrian.hunter@intel.com, dsahern@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, andi@firstfloor.org,
        a.p.zijlstra@chello.nl, namhyung@kernel.org, jolsa@redhat.com,
        dsahern@gmail.com, adrian.hunter@intel.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <1391427883-13443-3-git-send-email-jolsa@redhat.com>
References: <1391427883-13443-3-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf record:
  Add readable output for callchain debug
Git-Commit-ID: a601fdff1af20ea0208e918f5e97a247a3c37a40
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

Commit-ID:  a601fdff1af20ea0208e918f5e97a247a3c37a40
Gitweb:     http://git.kernel.org/tip/a601fdff1af20ea0208e918f5e97a247a3c37a40
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Mon, 3 Feb 2014 12:44:43 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 18 Feb 2014 09:34:47 -0300

perf record: Add readable output for callchain debug

Adding people readable output for callchain debug, to get following '-v'
output:

  $ perf record -v -g ls
  callchain: type DWARF
  callchain: stack dump size 4096
  ...

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1391427883-13443-3-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-record.c | 4 +++-
 tools/perf/perf.h           | 3 ++-
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index be9e8bc..7b8f0e6 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -735,7 +735,9 @@ int record_parse_callchain(const char *arg, struct record_opts *opts)
 
 static void callchain_debug(struct record_opts *opts)
 {
-	pr_debug("callchain: type %d\n", opts->call_graph);
+	static const char *str[CALLCHAIN_MAX] = { "NONE", "FP", "DWARF" };
+
+	pr_debug("callchain: type %s\n", str[opts->call_graph]);
 
 	if (opts->call_graph == CALLCHAIN_DWARF)
 		pr_debug("callchain: stack dump size %d\n",
diff --git a/tools/perf/perf.h b/tools/perf/perf.h
index 2078f33..6898ad0 100644
--- a/tools/perf/perf.h
+++ b/tools/perf/perf.h
@@ -251,7 +251,8 @@ void pthread__unblock_sigwinch(void);
 enum perf_call_graph_mode {
 	CALLCHAIN_NONE,
 	CALLCHAIN_FP,
-	CALLCHAIN_DWARF
+	CALLCHAIN_DWARF,
+	CALLCHAIN_MAX
 };
 
 struct record_opts {
