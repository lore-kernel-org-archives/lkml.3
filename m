Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754872AbaFYFtw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 01:49:52 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36189 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754829AbaFYFtu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 01:49:50 -0400
Date: Tue, 24 Jun 2014 22:49:32 -0700
From: tip-bot for Steven Rostedt <tipbot@zytor.com>
Message-ID: <tip-a21e3a34bef9e9c177be61111ced23e71e25fd8a@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        jolsa@kernel.org, rostedt@goodmis.org, tglx@linutronix.de,
        namhyung@kernel.org
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        jolsa@kernel.org, rostedt@goodmis.org, tglx@linutronix.de,
        namhyung@kernel.org
In-Reply-To: <20140613103127.1a9bdee7@gandalf.local.home>
References: <20140613103127.1a9bdee7@gandalf.local.home>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tools lib traceevent: Fix format in plugin_kvm
Git-Commit-ID: a21e3a34bef9e9c177be61111ced23e71e25fd8a
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

Commit-ID:  a21e3a34bef9e9c177be61111ced23e71e25fd8a
Gitweb:     http://git.kernel.org/tip/a21e3a34bef9e9c177be61111ced23e71e25fd8a
Author:     Steven Rostedt <rostedt@goodmis.org>
AuthorDate: Fri, 13 Jun 2014 10:31:27 -0400
Committer:  Jiri Olsa <jolsa@kernel.org>
CommitDate: Thu, 19 Jun 2014 18:18:33 +0200

tools lib traceevent: Fix format in plugin_kvm

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
