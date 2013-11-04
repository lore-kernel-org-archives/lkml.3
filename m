Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754637Ab3KDSDx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 13:03:53 -0500
Received: from merlin.infradead.org ([205.233.59.134]:38134 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754602Ab3KDSDv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 13:03:51 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Steven Rostedt <srostedt@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 28/29] tools lib traceevent: Add flags NOHANDLE and PRINTRAW to individual events
Date: Mon,  4 Nov 2013 14:59:06 -0300
Message-Id: <1383587947-17419-29-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1383587947-17419-1-git-send-email-acme@infradead.org>
References: <1383587947-17419-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Add the flags EVENT_FL_NOHANDLE and EVENT_FL_PRINTRAW to the event flags
to have the event either ignore the register handler or to ignore the
handler and also print the raw format respectively.

This allows a tool to force a raw format or non handle for an event.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Link: http://lkml.kernel.org/r/20131101215501.655258742@goodmis.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/lib/traceevent/event-parse.c | 4 ++--
 tools/lib/traceevent/event-parse.h | 2 ++
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index 85cbbddb6880..fc6f35f591f6 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -4446,11 +4446,11 @@ void pevent_event_info(struct trace_seq *s, struct event_format *event,
 {
 	int print_pretty = 1;
 
-	if (event->pevent->print_raw)
+	if (event->pevent->print_raw || (event->flags & EVENT_FL_PRINTRAW))
 		print_event_fields(s, record->data, record->size, event);
 	else {
 
-		if (event->handler)
+		if (event->handler && !(event->flags & EVENT_FL_NOHANDLE))
 			print_pretty = event->handler(s, record, event,
 						      event->context);
 
diff --git a/tools/lib/traceevent/event-parse.h b/tools/lib/traceevent/event-parse.h
index 9ab6367f2fe9..dc8539ee9485 100644
--- a/tools/lib/traceevent/event-parse.h
+++ b/tools/lib/traceevent/event-parse.h
@@ -308,6 +308,8 @@ enum {
 	EVENT_FL_ISBPRINT	= 0x04,
 	EVENT_FL_ISFUNCENT	= 0x10,
 	EVENT_FL_ISFUNCRET	= 0x20,
+	EVENT_FL_NOHANDLE	= 0x40,
+	EVENT_FL_PRINTRAW	= 0x80,
 
 	EVENT_FL_FAILED		= 0x80000000
 };
-- 
1.8.1.4

