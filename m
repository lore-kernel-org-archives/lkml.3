Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755393AbaDWNOX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 09:14:23 -0400
Received: from terminus.zytor.com ([198.137.202.10]:37414 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755140AbaDWNOM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 09:14:12 -0400
Date: Wed, 23 Apr 2014 06:13:49 -0700
From: tip-bot for Steven Rostedt <tipbot@zytor.com>
Message-ID: <tip-4508793541140723ab862d83095f6b5141d24e49@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        rostedt@goodmis.org, tglx@linutronix.de, jolsa@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org, tglx@linutronix.de, jolsa@redhat.com
In-Reply-To: <20140421222346.0351ced4@gandalf.local.home>
References: <20140421222346.0351ced4@gandalf.local.home>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] tools lib traceevent:
  Fix backward compatibility macros for pevent filter enums
Git-Commit-ID: 4508793541140723ab862d83095f6b5141d24e49
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

Commit-ID:  4508793541140723ab862d83095f6b5141d24e49
Gitweb:     http://git.kernel.org/tip/4508793541140723ab862d83095f6b5141d24e49
Author:     Steven Rostedt <rostedt@goodmis.org>
AuthorDate: Mon, 21 Apr 2014 22:23:46 -0400
Committer:  Jiri Olsa <jolsa@redhat.com>
CommitDate: Wed, 23 Apr 2014 13:19:23 +0200

tools lib traceevent: Fix backward compatibility macros for pevent filter enums

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
 
