Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755394Ab3KAVzL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 17:55:11 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:56344 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754873Ab3KAVzF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 17:55:05 -0400
Message-Id: <20131101215501.655258742@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 01 Nov 2013 17:53:59 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: [PATCH 7/8] tools lib traceevent: Add flags NOHANDLE and PRINTRAW to individual
 events
References: <20131101215352.875376844@goodmis.org>
Content-Disposition: inline; filename=0007-tools-lib-traceevent-Add-flags-NOHANDLE-and-PRINTRAW.patch
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Add the flags EVENT_FL_NOHANDLE and EVENT_FL_PRINTRAW to the event
flags to have the event either ignore the register handler or to
ignore the handler and also print the raw format respectively.

This allows a tool to force a raw format or non handle for an event.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 tools/lib/traceevent/event-parse.c | 4 ++--
 tools/lib/traceevent/event-parse.h | 2 ++
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index 85cbbdd..fc6f35f 100644
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
index 9ab6367..dc8539e 100644
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
1.8.4.rc3


