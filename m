Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755377AbaI2XLJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 19:11:09 -0400
Received: from smtprelay0039.hostedemail.com ([216.40.44.39]:48938 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755207AbaI2XI6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 19:08:58 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::,RULES_HIT:41:355:379:541:800:960:968:973:988:989:1260:1345:1359:1437:1534:1541:1711:1730:1747:1777:1792:2393:2559:2562:3138:3139:3140:3141:3142:3352:3865:3867:4321:4419:5007:6119:6261:7903:10004:10026:10848:11026:11658:11914:12296:12517:12519:12555:13311:13357:14394:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: spy16_13c32f40ca735
X-Filterd-Recvd-Size: 2872
From: Joe Perches <joe@perches.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Petr Mladek <pmladek@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Christine Caulfield <ccaulfie@redhat.com>,
        David Teigland <teigland@redhat.com>, cluster-devel@redhat.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/7] dlm: Use seq_puts, remove unnecessary trailing spaces
Date: Mon, 29 Sep 2014 16:08:24 -0700
Message-Id: <b416b016f4a6e49115ba736cad6ea2709a8bc1c4.1412031505.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1412031505.git.joe@perches.com>
References: <20140929124246.3e39dac8@gandalf.local.home> <cover.1412031505.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert the seq_printf output with constant strings to seq_puts.
Remove unnecessary trailing spaces from seq_(printf/puts) output.

Signed-off-by: Joe Perches <joe@perches.com>
---
 fs/dlm/debug_fs.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/fs/dlm/debug_fs.c b/fs/dlm/debug_fs.c
index 27c8335..c69a766 100644
--- a/fs/dlm/debug_fs.c
+++ b/fs/dlm/debug_fs.c
@@ -279,7 +279,7 @@ static void print_format3(struct dlm_rsb *r, struct seq_file *s)
 			print_name = 0;
 	}
 
-	seq_printf(s, "%s", print_name ? "str " : "hex");
+	seq_puts(s, print_name ? "str " : "hex");
 
 	for (i = 0; i < r->res_length; i++) {
 		if (print_name)
@@ -353,7 +353,7 @@ static void print_format4(struct dlm_rsb *r, struct seq_file *s)
 			print_name = 0;
 	}
 
-	seq_printf(s, "%s", print_name ? "str " : "hex");
+	seq_puts(s, print_name ? "str " : "hex");
 
 	for (i = 0; i < r->res_length; i++) {
 		if (print_name)
@@ -391,23 +391,21 @@ static int table_seq_show(struct seq_file *seq, void *iter_ptr)
 		break;
 	case 2:
 		if (ri->header) {
-			seq_printf(seq, "id nodeid remid pid xid exflags "
-					"flags sts grmode rqmode time_ms "
-					"r_nodeid r_len r_name\n");
+			seq_puts(seq, "id nodeid remid pid xid exflags flags sts grmode rqmode time_ms r_nodeid r_len r_name\n");
 			ri->header = 0;
 		}
 		print_format2(ri->rsb, seq);
 		break;
 	case 3:
 		if (ri->header) {
-			seq_printf(seq, "version rsb 1.1 lvb 1.1 lkb 1.1\n");
+			seq_puts(seq, "version rsb 1.1 lvb 1.1 lkb 1.1\n");
 			ri->header = 0;
 		}
 		print_format3(ri->rsb, seq);
 		break;
 	case 4:
 		if (ri->header) {
-			seq_printf(seq, "version 4 rsb 2\n");
+			seq_puts(seq, "version 4 rsb 2\n");
 			ri->header = 0;
 		}
 		print_format4(ri->rsb, seq);
-- 
1.8.1.2.459.gbcd45b4.dirty

