Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756239Ab3KHAE1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 19:04:27 -0500
Received: from dmz-mailsec-scanner-8.mit.edu ([18.7.68.37]:46265 "EHLO
	dmz-mailsec-scanner-8.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756105Ab3KHAEB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 19:04:01 -0500
X-AuditID: 12074425-b7fc88e000004601-30-527c294034d8
Date: Thu, 7 Nov 2013 18:58:54 -0500
From: Greg Price <price@MIT.EDU>
To: "Theodore Ts'o" <tytso@MIT.EDU>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 06/11] random: fix comment on "account"
Message-ID: <20131107235853.GI16018@ringworld.MIT.EDU>
References: <cover.1383868558.git.price@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1383868558.git.price@mit.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrNIsWRmVeSWpSXmKPExsUixG6nruugWRNkcGA3h8XlXXPYHBg9Pm+S
	C2CM4rJJSc3JLEst0rdL4Mr43N/OXjBXpGLuh2a2BsYJAl2MnBwSAiYSPTN+s0HYYhIX7q0H
	srk4hARmM0lsatrHCOFsYJRofPKZCcL5ySixff0RRpAWFgEViR0Tr7GD2GwCChI/5q9jBrFF
	BJQlVs3cxARiMwPFf93bxNrFyMEhLGAu8WO1BkiYV8BM4tiTzywgtpCAgcTP6W9ZIOKCEidn
	PmGBaNWSuPHvJRNIK7OAtMTyfxwgYU4BQ4n25iusILYo0AVTTm5jm8AoOAtJ9ywk3bMQuhcw
	Mq9ilE3JrdLNTczMKU5N1i1OTszLSy3StdDLzSzRS00p3cQIDlMX1R2MEw4pHWIU4GBU4uEt
	uFAdJMSaWFZcmXuIUZKDSUmUd6J6TZAQX1J+SmVGYnFGfFFpTmrxIUYJDmYlEd5nikA53pTE
	yqrUonyYlDQHi5I47y0O+yAhgfTEktTs1NSC1CKYrAwHh5IE7weQoYJFqempFWmZOSUIaSYO
	TpDhPEDDZTVAhhcXJOYWZ6ZD5E8xKkqJ834HaRYASWSU5sH1wtLIK0ZxoFeEeVVA2nmAKQiu
	+xXQYCagwSG/KkEGlyQipKQaGCOj9+Slzb0XFf+VwyBg0a99ZzUeph166F6SaNaU2rbUKrTo
	1+fkt2V9zvHdzfuPHpf0+tP2dn6lY8djyesc06KbFctD/ufIhx08LRcoGao7IzyCjf1E35sZ
	JQo/t0ufe829Z1Oy4tQ83axsCVfjO3p1VlOPSJ/5FfR2i/iyJzHi205/muK/XYmlOCPRUIu5
	qDgRAMDpjm7+AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This comment didn't quite keep up as extract_entropy() was split into
four functions.  Put each bit by the function it describes.

Cc: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Price <price@mit.edu>
---
 drivers/char/random.c | 31 +++++++++++++++++++++----------
 1 file changed, 21 insertions(+), 10 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 04a117a..8ec4a9a 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -834,17 +834,9 @@ static void xfer_secondary_pool(struct entropy_store *r, size_t nbytes)
 }
 
 /*
- * These functions extracts randomness from the "entropy pool", and
- * returns it in a buffer.
- *
- * The min parameter specifies the minimum amount we can pull before
- * failing to avoid races that defeat catastrophic reseeding while the
- * reserved parameter indicates how much entropy we must leave in the
- * pool after each pull to avoid starving other readers.
- *
- * Note: extract_entropy() assumes that .poolwords is a multiple of 16 words.
+ * This function decides how many bytes to actually take from the
+ * given pool, and also debits the entropy count accordingly.
  */
-
 static size_t account(struct entropy_store *r, size_t nbytes, int min,
 		      int reserved)
 {
@@ -896,6 +888,12 @@ retry:
 	return nbytes;
 }
 
+/*
+ * This function does the actual extraction for extract_entropy and
+ * extract_entropy_user.
+ *
+ * Note: we assume that .poolwords is a multiple of 16 words.
+ */
 static void extract_buf(struct entropy_store *r, __u8 *out)
 {
 	int i;
@@ -957,6 +955,15 @@ static void extract_buf(struct entropy_store *r, __u8 *out)
 	memset(&hash, 0, sizeof(hash));
 }
 
+/*
+ * This function extracts randomness from the "entropy pool", and
+ * returns it in a buffer.
+ *
+ * The min parameter specifies the minimum amount we can pull before
+ * failing to avoid races that defeat catastrophic reseeding while the
+ * reserved parameter indicates how much entropy we must leave in the
+ * pool after each pull to avoid starving other readers.
+ */
 static ssize_t extract_entropy(struct entropy_store *r, void *buf,
 				 size_t nbytes, int min, int reserved)
 {
@@ -1007,6 +1014,10 @@ static ssize_t extract_entropy(struct entropy_store *r, void *buf,
 	return ret;
 }
 
+/*
+ * This function extracts randomness from the "entropy pool", and
+ * returns it in a userspace buffer.
+ */
 static ssize_t extract_entropy_user(struct entropy_store *r, void __user *buf,
 				    size_t nbytes)
 {
-- 
1.8.3.2

