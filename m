Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934168AbaFSQme (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 12:42:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36404 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933816AbaFSQjE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 12:39:04 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        Jiri Olsa <jolsa@kernel.org>
Subject: [PATCH 5/9] tools lib traceevent: Fix format in plugin_kvm
Date: Thu, 19 Jun 2014 18:38:44 +0200
Message-Id: <1403195928-1331-6-git-send-email-jolsa@kernel.org>
In-Reply-To: <1403195928-1331-1-git-send-email-jolsa@kernel.org>
References: <1403195928-1331-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <rostedt@goodmis.org>

The format field argument passed to the format
in pevent_print_num_field() will be of type long long. That means that
%ll must be used instead of %l.

Acked-by: Namhyung Kim <namhyung@kernel.org>
Reported-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/20140613103127.1a9bdee7@gandalf.local.home
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/lib/traceevent/plugin_kvm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/lib/traceevent/plugin_kvm.c b/tools/lib/traceevent/plugin_kvm.c
index 0575e59..88fe83d 100644
--- a/tools/lib/traceevent/plugin_kvm.c
+++ b/tools/lib/traceevent/plugin_kvm.c
@@ -344,7 +344,7 @@ static int kvm_nested_vmexit_inject_handler(struct trace_seq *s, struct pevent_r
 static int kvm_nested_vmexit_handler(struct trace_seq *s, struct pevent_record *record,
 				     struct event_format *event, void *context)
 {
-	pevent_print_num_field(s, "rip %lx ", event, "rip", record, 1);
+	pevent_print_num_field(s, "rip %llx ", event, "rip", record, 1);
 
 	return kvm_nested_vmexit_inject_handler(s, record, event, context);
 }
-- 
1.8.3.1

