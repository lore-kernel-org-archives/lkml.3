Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932227AbaGKTIf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 15:08:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25135 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755194AbaGKTIX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 15:08:23 -0400
Date: Fri, 11 Jul 2014 21:06:47 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/7] tracing: kill call_filter_disable()
Message-ID: <20140711190647.GA19530@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140711190622.GA19499@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It seems that the only purpose of call_filter_disable() is to
make filter_disable() less clear and symmetrical, remove it.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/trace/trace_events_filter.c |    7 +------
 1 files changed, 1 insertions(+), 6 deletions(-)

diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index 1edec32..54a125c 100644
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
1.5.5.1

