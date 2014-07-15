Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933219AbaGOSu3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 14:50:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22344 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933176AbaGOSuZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 14:50:25 -0400
Date: Tue, 15 Jul 2014 20:48:32 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 7/7] tracing: kill "filter_string" arg of replace_preds()
Message-ID: <20140715184832.GA20519@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140715184753.GA20470@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cosmetic, but replace_preds() doesn't need/use "char *filter_string".
Remove it to microsimplify the code.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/trace/trace_events_filter.c |    9 +++------
 1 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index c2ef5a5..7a8c152 100644
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
1.5.5.1

