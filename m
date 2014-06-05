Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752213AbaFESiG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 14:38:06 -0400
Received: from mailrelay006.isp.belgacom.be ([195.238.6.172]:63407 "EHLO
	mailrelay006.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751495AbaFESiE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 14:38:04 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AsENAPW3kFNXQDfT/2dsb2JhbABZgwesCQUBmCeBDxd0glMvI4EaN4hGAdNPhVWIfR2EKgSPTopFiyCIGYM6Ow
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 1/1] kernel/locking/lockdep_proc.c: replace seq_printf and seq_puts
Date: Thu,  5 Jun 2014 20:36:48 +0200
Message-Id: <1401993408-12126-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

replace seq_printf by seq_puts and seq_puts by seq_putc where possible

Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 kernel/locking/lockdep_proc.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/kernel/locking/lockdep_proc.c b/kernel/locking/lockdep_proc.c
index ef43ac4..00c62ed 100644
--- a/kernel/locking/lockdep_proc.c
+++ b/kernel/locking/lockdep_proc.c
@@ -61,7 +61,7 @@ static int l_show(struct seq_file *m, void *v)
 	char usage[LOCK_USAGE_CHARS];
 
 	if (v == &all_lock_classes) {
-		seq_printf(m, "all lock classes:\n");
+		seq_puts(m, "all lock classes:\n");
 		return 0;
 	}
 
@@ -77,18 +77,18 @@ static int l_show(struct seq_file *m, void *v)
 	get_usage_chars(class, usage);
 	seq_printf(m, " %s", usage);
 
-	seq_printf(m, ": ");
+	seq_puts(m, ": ");
 	print_name(m, class);
-	seq_puts(m, "\n");
+	seq_putc(m, '\n');
 
 	list_for_each_entry(entry, &class->locks_after, entry) {
 		if (entry->distance == 1) {
 			seq_printf(m, " -> [%p] ", entry->class->key);
 			print_name(m, entry->class);
-			seq_puts(m, "\n");
+			seq_putc(m, '\n');
 		}
 	}
-	seq_puts(m, "\n");
+	seq_putc(m, '\n');
 
 	return 0;
 }
@@ -141,7 +141,7 @@ static int lc_show(struct seq_file *m, void *v)
 	int i;
 
 	if (v == SEQ_START_TOKEN) {
-		seq_printf(m, "all lock chains:\n");
+		seq_puts(m, "all lock chains:\n");
 		return 0;
 	}
 
@@ -154,9 +154,9 @@ static int lc_show(struct seq_file *m, void *v)
 
 		seq_printf(m, "[%p] ", class->key);
 		print_name(m, class);
-		seq_puts(m, "\n");
+		seq_putc(m, '\n');
 	}
-	seq_puts(m, "\n");
+	seq_putc(m, '\n');
 
 	return 0;
 }
@@ -529,7 +529,7 @@ static void seq_header(struct seq_file *m)
 	seq_puts(m, "lock_stat version 0.4\n");
 
 	if (unlikely(!debug_locks))
-		seq_printf(m, "*WARNING* lock debugging disabled!! - possibly due to a lockdep warning\n");
+		seq_puts(m, "*WARNING* lock debugging disabled!! - possibly due to a lockdep warning\n");
 
 	seq_line(m, '-', 0, 40 + 1 + 12 * (14 + 1));
 	seq_printf(m, "%40s %14s %14s %14s %14s %14s %14s %14s %14s %14s %14s "
@@ -548,7 +548,7 @@ static void seq_header(struct seq_file *m)
 			"holdtime-total",
 			"holdtime-avg");
 	seq_line(m, '-', 0, 40 + 1 + 12 * (14 + 1));
-	seq_printf(m, "\n");
+	seq_putc(m, '\n');
 }
 
 static void *ls_start(struct seq_file *m, loff_t *pos)
-- 
1.8.4.5

