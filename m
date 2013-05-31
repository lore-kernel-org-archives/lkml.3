Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755423Ab3EaLs6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 07:48:58 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56943 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755206Ab3EaLst (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 07:48:49 -0400
Date: Fri, 31 May 2013 04:48:38 -0700
From: tip-bot for David Ahern <tipbot@zytor.com>
Message-ID: <tip-b69e63a45f2d96a0dfe930ed20385058d4574d2f@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, dsahern@gmail.com, tglx@linutronix.de,
        jolsa@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, dsahern@gmail.com, tglx@linutronix.de,
        jolsa@redhat.com
In-Reply-To: <1369526040-1368-1-git-send-email-dsahern@gmail.com>
References: <1369526040-1368-1-git-send-email-dsahern@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf evsel:
  Fix printing of perf_event_paranoid message
Git-Commit-ID: b69e63a45f2d96a0dfe930ed20385058d4574d2f
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

Commit-ID:  b69e63a45f2d96a0dfe930ed20385058d4574d2f
Gitweb:     http://git.kernel.org/tip/b69e63a45f2d96a0dfe930ed20385058d4574d2f
Author:     David Ahern <dsahern@gmail.com>
AuthorDate: Sat, 25 May 2013 17:54:00 -0600
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 28 May 2013 16:24:03 +0300

perf evsel: Fix printing of perf_event_paranoid message

message is currently shown as:

  Error:
  You may not have permission to collect %sstats.
  Consider tweaking /proc/sys/kernel/perf_event_paranoid:

Note the %sstats. With patch this becomes:

  Error:
  You may not have permission to collect stats.
  Consider tweaking /proc/sys/kernel/perf_event_paranoid:

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Link: http://lkml.kernel.org/r/1369526040-1368-1-git-send-email-dsahern@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/evsel.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 07b1a3a..63b6f8c 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -1514,7 +1514,7 @@ int perf_evsel__open_strerror(struct perf_evsel *evsel,
 	switch (err) {
 	case EPERM:
 	case EACCES:
-		return scnprintf(msg, size, "%s",
+		return scnprintf(msg, size,
 		 "You may not have permission to collect %sstats.\n"
 		 "Consider tweaking /proc/sys/kernel/perf_event_paranoid:\n"
 		 " -1 - Not paranoid at all\n"
