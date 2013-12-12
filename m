Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752066Ab3LLXrq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 18:47:46 -0500
Received: from smtprelay0034.hostedemail.com ([216.40.44.34]:35882 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751571Ab3LLXrn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 18:47:43 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:69:355:379:541:800:960:968:973:988:989:1260:1345:1359:1437:1535:1544:1711:1730:1747:1777:1792:2393:2559:2562:3138:3139:3140:3141:3142:3354:3865:3867:3871:4419:5007:6119:6261:7903:10004:10026:10394:10848:11026:11658:11914:12043:12296:12517:12519:12555:12683,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: girls08_8bd5eb1a6a1d
X-Filterd-Recvd-Size: 5184
From: Joe Perches <joe@perches.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Christine Caulfield <ccaulfie@redhat.com>,
        David Teigland <teigland@redhat.com>, cluster-devel@redhat.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH -next 2/4] dlm: Use seq_puts, remove unnecessary trailing spaces
Date: Thu, 12 Dec 2013 15:47:29 -0800
Message-Id: <570c4692afd4e9ac2452780591ce33c5b2aad10d.1386891757.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1386819513.git.joe@perches.com>
References: <cover.1386819513.git.joe@perches.com>
In-Reply-To: <cover.1386891757.git.joe@perches.com>
References: <cover.1386891757.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert the seq_printf output with constant strings to seq_puts.
Remove unnecessary trailing spaces from seq_(printf/puts) output.

Signed-off-by: Joe Perches <joe@perches.com>
---
 fs/dlm/debug_fs.c | 34 ++++++++++++++++------------------
 1 file changed, 16 insertions(+), 18 deletions(-)

diff --git a/fs/dlm/debug_fs.c b/fs/dlm/debug_fs.c
index eb26595..7157b4a 100644
--- a/fs/dlm/debug_fs.c
+++ b/fs/dlm/debug_fs.c
@@ -88,29 +88,29 @@ static void print_format1(struct dlm_rsb *res, struct seq_file *s)
 	}
 
 	if (res->res_nodeid > 0)
-		seq_printf(s, "\" \nLocal Copy, Master is node %d\n",
+		seq_printf(s, "\"\nLocal Copy, Master is node %d\n",
 			   res->res_nodeid);
 	else if (res->res_nodeid == 0)
-		seq_puts(s, "\" \nMaster Copy\n");
+		seq_puts(s, "\"\nMaster Copy\n");
 	else if (res->res_nodeid == -1)
-		seq_printf(s, "\" \nLooking up master (lkid %x)\n",
+		seq_printf(s, "\"\nLooking up master (lkid %x)\n",
 			   res->res_first_lkid);
 	else
-		seq_printf(s, "\" \nInvalid master %d\n", res->res_nodeid);
+		seq_printf(s, "\"\nInvalid master %d\n", res->res_nodeid);
 	if (seq_is_buf_full(s))
 		goto out;
 
 	/* Print the LVB: */
 	if (res->res_lvbptr) {
-		seq_printf(s, "LVB: ");
+		seq_puts(s, "LVB: ");
 		for (i = 0; i < lvblen; i++) {
 			if (i == lvblen / 2)
-				seq_printf(s, "\n     ");
+				seq_puts(s, "\n     ");
 			seq_printf(s, "%02x ",
 				   (unsigned char) res->res_lvbptr[i]);
 		}
 		if (rsb_flag(res, RSB_VALNOTVALID))
-			seq_printf(s, " (INVALID)");
+			seq_puts(s, " (INVALID)");
 		seq_puts(s, "\n");
 		if (seq_is_buf_full(s))
 			goto out;
@@ -126,21 +126,21 @@ static void print_format1(struct dlm_rsb *res, struct seq_file *s)
 	}
 
 	/* Print the locks attached to this resource */
-	seq_printf(s, "Granted Queue\n");
+	seq_puts(s, "Granted Queue\n");
 	list_for_each_entry(lkb, &res->res_grantqueue, lkb_statequeue) {
 		print_format1_lock(s, lkb, res);
 		if (seq_is_buf_full(s))
 			goto out;
 	}
 
-	seq_printf(s, "Conversion Queue\n");
+	seq_puts(s, "Conversion Queue\n");
 	list_for_each_entry(lkb, &res->res_convertqueue, lkb_statequeue) {
 		print_format1_lock(s, lkb, res);
 		if (seq_is_buf_full(s))
 			goto out;
 	}
 
-	seq_printf(s, "Waiting Queue\n");
+	seq_puts(s, "Waiting Queue\n");
 	list_for_each_entry(lkb, &res->res_waitqueue, lkb_statequeue) {
 		print_format1_lock(s, lkb, res);
 		if (seq_is_buf_full(s))
@@ -150,7 +150,7 @@ static void print_format1(struct dlm_rsb *res, struct seq_file *s)
 	if (list_empty(&res->res_lookup))
 		goto out;
 
-	seq_printf(s, "Lookup Queue\n");
+	seq_puts(s, "Lookup Queue\n");
 	list_for_each_entry(lkb, &res->res_lookup, lkb_rsb_lookup) {
 		seq_printf(s, "%08x %s",
 			   lkb->lkb_id, print_lockmode(lkb->lkb_rqmode));
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

