Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756255AbaENQyY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 12:54:24 -0400
Received: from mailrelay004.isp.belgacom.be ([195.238.6.170]:43679 "EHLO
	mailrelay004.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754280AbaENQyX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 12:54:23 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AuUNAHafc1NXQ68k/2dsb2JhbABZgwasaQQBAQEBAQEFAZodgSMXdIJTExwjGIECJBOIRQHRPIVUiHqERwEDjyqKJgGLDYgHgzg7
Date: Wed, 14 May 2014 18:54:17 +0200
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>,
        Christine Caulfield <ccaulfie@redhat.com>
Subject: [PATCH 1/1] fs/dlm/debug_fs.c: replace seq_printf by seq_puts
Message-Id: <20140514185417.a79fd0b576b2bba988280c65@skynet.be>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace seq_printf where possible.
This patch also fixes the following checkpatch warning
"unnecessary whitespace before a quoted newline"

Cc: Christine Caulfield <ccaulfie@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/dlm/debug_fs.c | 34 +++++++++++++++++-----------------
 1 file changed, 17 insertions(+), 17 deletions(-)

diff --git a/fs/dlm/debug_fs.c b/fs/dlm/debug_fs.c
index b969dee..8d77ba7 100644
--- a/fs/dlm/debug_fs.c
+++ b/fs/dlm/debug_fs.c
@@ -68,7 +68,7 @@ static int print_format1_lock(struct seq_file *s, struct dlm_lkb *lkb,
 	if (lkb->lkb_wait_type)
 		seq_printf(s, " wait_type: %d", lkb->lkb_wait_type);
 
-	return seq_printf(s, "\n");
+	return seq_puts(s, "\n");
 }
 
 static int print_format1(struct dlm_rsb *res, struct seq_file *s)
@@ -92,31 +92,31 @@ static int print_format1(struct dlm_rsb *res, struct seq_file *s)
 	}
 
 	if (res->res_nodeid > 0)
-		rv = seq_printf(s, "\"  \nLocal Copy, Master is node %d\n",
+		rv = seq_printf(s, "\"\nLocal Copy, Master is node %d\n",
 				res->res_nodeid);
 	else if (res->res_nodeid == 0)
-		rv = seq_printf(s, "\"  \nMaster Copy\n");
+		rv = seq_puts(s, "\"\nMaster Copy\n");
 	else if (res->res_nodeid == -1)
-		rv = seq_printf(s, "\"  \nLooking up master (lkid %x)\n",
+		rv = seq_printf(s, "\"\nLooking up master (lkid %x)\n",
 			   	res->res_first_lkid);
 	else
-		rv = seq_printf(s, "\"  \nInvalid master %d\n",
+		rv = seq_printf(s, "\"\nInvalid master %d\n",
 				res->res_nodeid);
 	if (rv)
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
-		rv = seq_printf(s, "\n");
+			seq_puts(s, " (INVALID)");
+		rv = seq_puts(s, "\n");
 		if (rv)
 			goto out;
 	}
@@ -133,21 +133,21 @@ static int print_format1(struct dlm_rsb *res, struct seq_file *s)
 	}
 
 	/* Print the locks attached to this resource */
-	seq_printf(s, "Granted Queue\n");
+	seq_puts(s, "Granted Queue\n");
 	list_for_each_entry(lkb, &res->res_grantqueue, lkb_statequeue) {
 		rv = print_format1_lock(s, lkb, res);
 		if (rv)
 			goto out;
 	}
 
-	seq_printf(s, "Conversion Queue\n");
+	seq_puts(s, "Conversion Queue\n");
 	list_for_each_entry(lkb, &res->res_convertqueue, lkb_statequeue) {
 		rv = print_format1_lock(s, lkb, res);
 		if (rv)
 			goto out;
 	}
 
-	seq_printf(s, "Waiting Queue\n");
+	seq_puts(s, "Waiting Queue\n");
 	list_for_each_entry(lkb, &res->res_waitqueue, lkb_statequeue) {
 		rv = print_format1_lock(s, lkb, res);
 		if (rv)
@@ -157,13 +157,13 @@ static int print_format1(struct dlm_rsb *res, struct seq_file *s)
 	if (list_empty(&res->res_lookup))
 		goto out;
 
-	seq_printf(s, "Lookup Queue\n");
+	seq_puts(s, "Lookup Queue\n");
 	list_for_each_entry(lkb, &res->res_lookup, lkb_rsb_lookup) {
 		rv = seq_printf(s, "%08x %s", lkb->lkb_id,
 				print_lockmode(lkb->lkb_rqmode));
 		if (lkb->lkb_wait_type)
 			seq_printf(s, " wait_type: %d", lkb->lkb_wait_type);
-		rv = seq_printf(s, "\n");
+		rv = seq_puts(s, "\n");
 	}
  out:
 	unlock_rsb(res);
@@ -300,7 +300,7 @@ static int print_format3(struct dlm_rsb *r, struct seq_file *s)
 		else
 			seq_printf(s, " %02x", (unsigned char)r->res_name[i]);
 	}
-	rv = seq_printf(s, "\n");
+	rv = seq_puts(s, "\n");
 	if (rv)
 		goto out;
 
@@ -311,7 +311,7 @@ static int print_format3(struct dlm_rsb *r, struct seq_file *s)
 
 	for (i = 0; i < lvblen; i++)
 		seq_printf(s, " %02x", (unsigned char)r->res_lvbptr[i]);
-	rv = seq_printf(s, "\n");
+	rv = seq_puts(s, "\n");
 	if (rv)
 		goto out;
 
@@ -377,7 +377,7 @@ static int print_format4(struct dlm_rsb *r, struct seq_file *s)
 		else
 			seq_printf(s, " %02x", (unsigned char)r->res_name[i]);
 	}
-	rv = seq_printf(s, "\n");
+	rv = seq_puts(s, "\n");
  out:
 	unlock_rsb(r);
 	return rv;
-- 
1.9.1

