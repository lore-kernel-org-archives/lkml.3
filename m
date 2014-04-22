Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753258AbaDVCXw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 22:23:52 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.229]:25256 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751236AbaDVCXt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 22:23:49 -0400
Date: Mon, 21 Apr 2014 22:23:46 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Namhyung Kim <namhyung@kernel.org>
Subject: [PATCH] tools lib traceevent: Fix backward compatibility macros for
 pevent filter enums
Message-ID: <20140421222346.0351ced4@gandalf.local.home>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The return value for pevent_filter_match() is suppose to return FILTER_NONE
if the event doesn't have a filter, and FILTER_NOEXIST if there is no filter
at all. But the change 41e12e580a7 "tools lib traceevent: Refactor
pevent_filter_match() to get rid of die()" replaced the return value
with PEVENT_ERRNO__* values and added "backward compatibility" macros
that used the old names. Unfortunately, the NOEXIST and NONE macros were
swapped, and this broke users that use the old return names.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 tools/lib/traceevent/event-parse.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/lib/traceevent/event-parse.h b/tools/lib/traceevent/event-parse.h
index 9c38181..d6c610a 100644
--- a/tools/lib/traceevent/event-parse.h
+++ b/tools/lib/traceevent/event-parse.h
@@ -886,8 +886,8 @@ struct event_filter {
 struct event_filter *pevent_filter_alloc(struct pevent *pevent);
 
 /* for backward compatibility */
-#define FILTER_NONE		PEVENT_ERRNO__FILTER_NOT_FOUND
-#define FILTER_NOEXIST		PEVENT_ERRNO__NO_FILTER
+#define FILTER_NONE		PEVENT_ERRNO__NO_FILTER
+#define FILTER_NOEXIST		PEVENT_ERRNO__FILTER_NOT_FOUND
 #define FILTER_MISS		PEVENT_ERRNO__FILTER_MISS
 #define FILTER_MATCH		PEVENT_ERRNO__FILTER_MATCH
 
-- 
1.8.1.4

