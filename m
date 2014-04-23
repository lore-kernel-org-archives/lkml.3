Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752518AbaDWLbk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 07:31:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16574 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751210AbaDWLbj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 07:31:39 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 3/4] tools lib traceevent: Fix backward compatibility macros for pevent filter enums
Date: Wed, 23 Apr 2014 13:31:21 +0200
Message-Id: <1398252682-17185-4-git-send-email-jolsa@redhat.com>
In-Reply-To: <1398252682-17185-1-git-send-email-jolsa@redhat.com>
References: <1398252682-17185-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <rostedt@goodmis.org>

The return value for pevent_filter_match() is suppose to return FILTER_NONE
if the event doesn't have a filter, and FILTER_NOEXIST if there is no filter
at all. But the change 41e12e580a7 "tools lib traceevent: Refactor
pevent_filter_match() to get rid of die()" replaced the return value
with PEVENT_ERRNO__* values and added "backward compatibility" macros
that used the old names. Unfortunately, the NOEXIST and NONE macros were
swapped, and this broke users that use the old return names.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/20140421222346.0351ced4@gandalf.local.home
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 tools/lib/traceevent/event-parse.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/lib/traceevent/event-parse.h b/tools/lib/traceevent/event-parse.h
index 791c539..feab942 100644
--- a/tools/lib/traceevent/event-parse.h
+++ b/tools/lib/traceevent/event-parse.h
@@ -876,8 +876,8 @@ struct event_filter {
 struct event_filter *pevent_filter_alloc(struct pevent *pevent);
 
 /* for backward compatibility */
-#define FILTER_NONE		PEVENT_ERRNO__FILTER_NOT_FOUND
-#define FILTER_NOEXIST		PEVENT_ERRNO__NO_FILTER
+#define FILTER_NONE		PEVENT_ERRNO__NO_FILTER
+#define FILTER_NOEXIST		PEVENT_ERRNO__FILTER_NOT_FOUND
 #define FILTER_MISS		PEVENT_ERRNO__FILTER_MISS
 #define FILTER_MATCH		PEVENT_ERRNO__FILTER_MATCH
 
-- 
1.8.3.1

