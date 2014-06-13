Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752548AbaFMObb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 10:31:31 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.232]:54136 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752382AbaFMOba (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 10:31:30 -0400
Date: Fri, 13 Jun 2014 10:31:27 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Jan Kiszka <jan.kiszka@siemens.com>
Subject: [PATCH 5/4] tools lib traceevent: Fix format in plugin_kvm
Message-ID: <20140613103127.1a9bdee7@gandalf.local.home>
In-Reply-To: <20140613021002.444608350@goodmis.org>
References: <20140613021002.444608350@goodmis.org>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The format field argument passed to the format
in pevent_print_num_field() will be of type long long. That means that
%ll must be used instead of %l.

Reported-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
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
