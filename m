Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754012Ab3KDUUq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 15:20:46 -0500
Received: from terminus.zytor.com ([198.137.202.10]:49932 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751842Ab3KDUUl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 15:20:41 -0500
Date: Mon, 4 Nov 2013 12:20:15 -0800
From: tip-bot for Adrian Hunter <tipbot@zytor.com>
Message-ID: <tip-f852fd621ca19f557f2e3d05900366be7c7afb83@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        paulus@samba.org, mingo@redhat.com, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, efault@gmx.de, namhyung@gmail.com,
        jolsa@redhat.com, fweisbec@gmail.com, adrian.hunter@intel.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, mingo@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        a.p.zijlstra@chello.nl, efault@gmx.de, namhyung@gmail.com,
        jolsa@redhat.com, fweisbec@gmail.com, dsahern@gmail.com,
        adrian.hunter@intel.com, tglx@linutronix.de
In-Reply-To: <1383313899-15987-2-git-send-email-adrian.hunter@intel.com>
References: <1383313899-15987-2-git-send-email-adrian.hunter@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf evsel:
  Add a debug print if perf_event_open fails
Git-Commit-ID: f852fd621ca19f557f2e3d05900366be7c7afb83
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 04 Nov 2013 12:20:21 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f852fd621ca19f557f2e3d05900366be7c7afb83
Gitweb:     http://git.kernel.org/tip/f852fd621ca19f557f2e3d05900366be7c7afb83
Author:     Adrian Hunter <adrian.hunter@intel.com>
AuthorDate: Fri, 1 Nov 2013 15:51:29 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 4 Nov 2013 12:18:17 -0300

perf evsel: Add a debug print if perf_event_open fails

There is a debug print (at verbose level 2) for each call to
perf_event_open.  Add another debug print if the call fails, and print
the error number.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1383313899-15987-2-git-send-email-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/evsel.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 3a334f0..f0e65de 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -1051,6 +1051,8 @@ retry_open:
 								     group_fd, flags);
 			if (FD(evsel, cpu, thread) < 0) {
 				err = -errno;
+				pr_debug2("perf_event_open failed, error %d\n",
+					  err);
 				goto try_fallback;
 			}
 			set_rlimit = NO_CHANGE;
