Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756493AbaCNVak (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 17:30:40 -0400
Received: from merlin.infradead.org ([205.233.59.134]:53983 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756197AbaCNVaV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 17:30:21 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Don Zickus <dzickus@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>, Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 11/16] perf session: Change header.misc dump from decimal to hex
Date: Fri, 14 Mar 2014 18:30:05 -0300
Message-Id: <1394832610-17818-12-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1394832610-17818-1-git-send-email-acme@infradead.org>
References: <1394832610-17818-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Don Zickus <dzickus@redhat.com>

When printing the raw dump of a data file, the header.misc is
printed as a decimal.  Unfortunately, that field is a bit mask, so
it is hard to interpret as a decimal.

Print in hex, so the user can easily see what bits are set and more
importantly what type of info it is conveying.

V2: add 0x in front per Jiri Olsa

Signed-off-by: Don Zickus <dzickus@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1393386227-149412-3-git-send-email-dzickus@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/session.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 1d555d652f58..55960f22233c 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -794,7 +794,7 @@ static void dump_sample(struct perf_evsel *evsel, union perf_event *event,
 	if (!dump_trace)
 		return;
 
-	printf("(IP, %d): %d/%d: %#" PRIx64 " period: %" PRIu64 " addr: %#" PRIx64 "\n",
+	printf("(IP, 0x%x): %d/%d: %#" PRIx64 " period: %" PRIu64 " addr: %#" PRIx64 "\n",
 	       event->header.misc, sample->pid, sample->tid, sample->ip,
 	       sample->period, sample->addr);
 
-- 
1.8.1.4

