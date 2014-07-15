Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933163AbaGOSt5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 14:49:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8841 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932815AbaGOSty (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 14:49:54 -0400
Date: Tue, 15 Jul 2014 20:47:53 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/7] tracing: ->filter cleanups
Message-ID: <20140715184753.GA20470@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

To avoid the confusion, let me resend everything (except the 1st patch
you already applied) with v2 tag.

Changes:

	4/7 - fix the typo in changelog, add the ack from Srikar

	6/7 - by discussion with you and Namhyung: pass dir rather
	      then system, update replace_system_preds() as well.

	7/7 - new, cosmetic/trivial.

I tried to play with "filter" files, everything seems to work with the
additional debugging patch below.

Oleg.
---

diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index 7a8c152..4c16229 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -848,6 +848,7 @@ static void filter_free_subsystem_preds(struct ftrace_subsystem_dir *dir,
 	struct ftrace_event_file *file;
 
 	list_for_each_entry(file, &tr->events, list) {
+BUG_ON((file->system != dir) != !!strcmp(file->event_call->class->system, dir->subsystem->name));
 		if (file->system != dir)
 			continue;
 		__remove_filter(file);
@@ -873,6 +874,7 @@ static void filter_free_subsystem_filters(struct ftrace_subsystem_dir *dir,
 	struct ftrace_event_file *file;
 
 	list_for_each_entry(file, &tr->events, list) {
+BUG_ON((file->system != dir) != !!strcmp(file->event_call->class->system, dir->subsystem->name));
 		if (file->system != dir)
 			continue;
 		__free_subsystem_filter(file);
@@ -1731,6 +1733,7 @@ static int replace_system_preds(struct ftrace_subsystem_dir *dir,
 	int err;
 
 	list_for_each_entry(file, &tr->events, list) {
+BUG_ON((file->system != dir) != !!strcmp(file->event_call->class->system, dir->subsystem->name));
 		if (file->system != dir)
 			continue;
 
@@ -1748,6 +1751,7 @@ static int replace_system_preds(struct ftrace_subsystem_dir *dir,
 	list_for_each_entry(file, &tr->events, list) {
 		struct event_filter *filter;
 
+BUG_ON((file->system != dir) != !!strcmp(file->event_call->class->system, dir->subsystem->name));
 		if (file->system != dir)
 			continue;
 

