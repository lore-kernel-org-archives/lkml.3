Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933704AbaGQOr5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 10:47:57 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.232]:17425 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933067AbaGQOry (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 10:47:54 -0400
Message-Id: <20140717144752.548414916@goodmis.org>
User-Agent: quilt/0.63-1
Date: Thu, 17 Jul 2014 10:47:10 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>
Subject: [for-next][PATCH 3/7] tracing: Kill call_filter_disable()
References: <20140717144707.625978566@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0003-tracing-Kill-call_filter_disable.patch
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Oleg Nesterov <oleg@redhat.com>

It seems that the only purpose of call_filter_disable() is to
make filter_disable() less clear and symmetrical, remove it.

Link: http://lkml.kernel.org/p/20140715184821.GA20498@redhat.com

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_events_filter.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index 1edec329be29..54a125c8467a 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -774,17 +774,12 @@ static void __free_preds(struct event_filter *filter)
 	filter->n_preds = 0;
 }
 
-static void call_filter_disable(struct ftrace_event_call *call)
-{
-	call->flags &= ~TRACE_EVENT_FL_FILTERED;
-}
-
 static void filter_disable(struct ftrace_event_file *file)
 {
 	struct ftrace_event_call *call = file->event_call;
 
 	if (call->flags & TRACE_EVENT_FL_USE_CALL_FILTER)
-		call_filter_disable(call);
+		call->flags &= ~TRACE_EVENT_FL_FILTERED;
 	else
 		file->flags &= ~FTRACE_EVENT_FL_FILTERED;
 }
-- 
2.0.1


