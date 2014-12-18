Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752233AbaLRG3l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 01:29:41 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58580 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752183AbaLRG3i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 01:29:38 -0500
Date: Wed, 17 Dec 2014 22:28:58 -0800
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-3banj3yh0sjz41obxtgiel3a@git.kernel.org>
Cc: hpa@zytor.com, tglx@linutronix.de, paulus@samba.org, peterz@infradead.org,
        bp@suse.de, mingo@kernel.org, fweisbec@gmail.com, jolsa@redhat.com,
        efault@gmx.de, dzickus@redhat.com, dsahern@gmail.com,
        eranian@google.com, namhyung@kernel.org, acme@redhat.com,
        linux-kernel@vger.kernel.org, adrian.hunter@intel.com
Reply-To: hpa@zytor.com, tglx@linutronix.de, paulus@samba.org,
        peterz@infradead.org, bp@suse.de, mingo@kernel.org, fweisbec@gmail.com,
        efault@gmx.de, jolsa@redhat.com, dzickus@redhat.com, dsahern@gmail.com,
        eranian@google.com, namhyung@kernel.org, acme@redhat.com,
        adrian.hunter@intel.com, linux-kernel@vger.kernel.org
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf trace:
  Let the perf_evlist__mmap autosize the number of pages to use
Git-Commit-ID: 38d5447d64f367d1f4804ed5c7048d39de4d3311
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

Commit-ID:  38d5447d64f367d1f4804ed5c7048d39de4d3311
Gitweb:     http://git.kernel.org/tip/38d5447d64f367d1f4804ed5c7048d39de4d3311
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Fri, 12 Dec 2014 17:28:32 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 16 Dec 2014 13:38:26 -0300

perf trace: Let the perf_evlist__mmap autosize the number of pages to use

So that normal users can run 'trace', we were using a hardcoded 1024
pages value that was more than the default /proc/sys/kernel/perf_event_mlock_kb
setting.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Borislav Petkov <bp@suse.de>
Cc: David Ahern <dsahern@gmail.com>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-3banj3yh0sjz41obxtgiel3a@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-trace.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 327541e..badfabc 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -2485,7 +2485,7 @@ int cmd_trace(int argc, const char **argv, const char *prefix __maybe_unused)
 			.user_freq     = UINT_MAX,
 			.user_interval = ULLONG_MAX,
 			.no_buffering  = true,
-			.mmap_pages    = 1024,
+			.mmap_pages    = UINT_MAX,
 		},
 		.output = stdout,
 		.show_comm = true,
