Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934386Ab3E3QCH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 12:02:07 -0400
Received: from merlin.infradead.org ([205.233.59.134]:50605 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757618Ab3E3QB7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 12:01:59 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 29/66] perf evsel: Fix printing of perf_event_paranoid message
Date: Thu, 30 May 2013 19:01:02 +0300
Message-Id: <1369929699-8724-30-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1369929699-8724-1-git-send-email-acme@infradead.org>
References: <1369929699-8724-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

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
-- 
1.8.1.4

