Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754755Ab3CMFHm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 01:07:42 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:33631 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754416Ab3CMFHj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 01:07:39 -0400
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: David Ahern <dsahern@gmail.com>
Subject: [PATCH 2/4] perf: remove unused print_trace_event function
Date: Tue, 12 Mar 2013 23:07:26 -0600
Message-Id: <1363151248-16674-3-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1363151248-16674-1-git-send-email-dsahern@gmail.com>
References: <1363151248-16674-1-git-send-email-dsahern@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: David Ahern <dsahern@gmail.com>
---
 tools/perf/util/trace-event-parse.c |   13 -------------
 tools/perf/util/trace-event.h       |    1 -
 2 files changed, 14 deletions(-)

diff --git a/tools/perf/util/trace-event-parse.c b/tools/perf/util/trace-event-parse.c
index 8450bec..4454835 100644
--- a/tools/perf/util/trace-event-parse.c
+++ b/tools/perf/util/trace-event-parse.c
@@ -183,19 +183,6 @@ void event_format__print(struct event_format *event,
 	trace_seq_do_printf(&s);
 }
 
-void print_trace_event(struct pevent *pevent, int cpu, void *data, int size)
-{
-	int type = trace_parse_common_type(pevent, data);
-	struct event_format *event = pevent_find_event(pevent, type);
-
-	if (!event) {
-		warning("ug! no event found for type %d", type);
-		return;
-	}
-
-	event_format__print(event, cpu, data, size);
-}
-
 void parse_proc_kallsyms(struct pevent *pevent,
 			 char *file, unsigned int size __maybe_unused)
 {
diff --git a/tools/perf/util/trace-event.h b/tools/perf/util/trace-event.h
index 99f621f..28ccde8 100644
--- a/tools/perf/util/trace-event.h
+++ b/tools/perf/util/trace-event.h
@@ -30,7 +30,6 @@ enum {
 int bigendian(void);
 
 struct pevent *read_trace_init(int file_bigendian, int host_bigendian);
-void print_trace_event(struct pevent *pevent, int cpu, void *data, int size);
 void event_format__print(struct event_format *event,
 			 int cpu, void *data, int size);
 
-- 
1.7.10.1

