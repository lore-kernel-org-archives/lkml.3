Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760628AbaGYOG5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 10:06:57 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:2696 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1760519AbaGYOGP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 10:06:15 -0400
Message-Id: <20140725140612.935514580@goodmis.org>
User-Agent: quilt/0.63-1
Date: Fri, 25 Jul 2014 10:05:18 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>
Subject: [for-next][PATCH 4/4] ftrace: Add warning if tramp hash does not match nr_trampolines
References: <20140725140514.377803118@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0004-ftrace-Add-warning-if-tramp-hash-does-not-match-nr_t.patch
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

After adding all the records to the tramp_hash, add a check that makes
sure that the number of records added matches the number of records
expected to match and do a WARN_ON and disable ftrace if they do
not match.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ftrace.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 6ef1989c2b2e..979bd8cb4349 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -2226,6 +2226,9 @@ static int ftrace_save_ops_tramp_hash(struct ftrace_ops *ops)
 		}
 	} while_for_each_ftrace_rec();
 
+	/* The number of recs in the hash must match nr_trampolines */
+	FTRACE_WARN_ON(ops->tramp_hash->count != ops->nr_trampolines);
+
 	return 0;
 }
 
-- 
2.0.1


