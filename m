Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934284AbaGQOvf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 10:51:35 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.228]:59210 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933346AbaGQOry (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 10:47:54 -0400
Message-Id: <20140717144753.154310032@goodmis.org>
User-Agent: quilt/0.63-1
Date: Thu, 17 Jul 2014 10:47:14 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>
Subject: [for-next][PATCH 7/7] tracing: Kill "filter_string" arg of replace_preds()
References: <20140717144707.625978566@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0007-tracing-Kill-filter_string-arg-of-replace_preds.patch
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Oleg Nesterov <oleg@redhat.com>

Cosmetic, but replace_preds() doesn't need/use "char *filter_string".
Remove it to microsimplify the code.

Link: http://lkml.kernel.org/p/20140715184832.GA20519@redhat.com

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_events_filter.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index c2ef5a5f21da..7a8c1528e141 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -1546,7 +1546,6 @@ static int fold_pred_tree(struct event_filter *filter,
 static int replace_preds(struct ftrace_event_call *call,
 			 struct event_filter *filter,
 			 struct filter_parse_state *ps,
-			 char *filter_string,
 			 bool dry_run)
 {
 	char *operand1 = NULL, *operand2 = NULL;
@@ -1739,8 +1738,7 @@ static int replace_system_preds(struct ftrace_subsystem_dir *dir,
 		 * Try to see if the filter can be applied
 		 *  (filter arg is ignored on dry_run)
 		 */
-		err = replace_preds(file->event_call, NULL, ps,
-					filter_string, true);
+		err = replace_preds(file->event_call, NULL, ps, true);
 		if (err)
 			event_set_no_set_filter_flag(file);
 		else
@@ -1772,8 +1770,7 @@ static int replace_system_preds(struct ftrace_subsystem_dir *dir,
 		if (err)
 			goto fail_mem;
 
-		err = replace_preds(file->event_call, filter, ps,
-					filter_string, false);
+		err = replace_preds(file->event_call, filter, ps, false);
 		if (err) {
 			filter_disable(file);
 			parse_error(ps, FILT_ERR_BAD_SUBSYS_FILTER, 0);
@@ -1895,7 +1892,7 @@ static int create_filter(struct ftrace_event_call *call,
 
 	err = create_filter_start(filter_str, set_str, &ps, &filter);
 	if (!err) {
-		err = replace_preds(call, filter, ps, filter_str, false);
+		err = replace_preds(call, filter, ps, false);
 		if (err && set_str)
 			append_filter_err(ps, filter);
 	}
-- 
2.0.1


