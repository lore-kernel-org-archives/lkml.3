Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758812Ab3KMII1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 03:08:27 -0500
Received: from dmz-mailsec-scanner-4.mit.edu ([18.9.25.15]:63302 "EHLO
	dmz-mailsec-scanner-4.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758743Ab3KMIIT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 03:08:19 -0500
X-AuditID: 1209190f-b7fb86d000000c36-91-528333712a95
Date: Wed, 13 Nov 2013 03:08:14 -0500
From: Greg Price <price@MIT.EDU>
To: "Theodore Ts'o" <tytso@MIT.EDU>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 5/9] random: fix comment on "account"
Message-ID: <20131113080814.GS16018@ringworld.MIT.EDU>
References: <cover.1384329436.git.price@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1384329436.git.price@mit.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrDIsWRmVeSWpSXmKPExsUixCmqrVtk3BxkcPMak8XlXXPYHBg9Pm+S
	C2CM4rJJSc3JLEst0rdL4MrY+nYvc0GPSMX6iY9YGhgbBboYOTkkBEwkzp7czQhhi0lcuLee
	rYuRi0NIYDaTxNLXl6GcjYwS3w9uZoVwfjFKfDrWzwTSwiKgKvH1wX1WEJtNQEHix/x1zCC2
	iICyxKqZm8BqmIHiv+5tAqsRFjCVaGw7BhbnFTCTWPn7DxuILSRgILFx/wRmiLigxMmZT1gg
	erUkbvx7CVTPAWRLSyz/xwES5hQwlJi04SjYSFEBFYkpJ7exTWAUnIWkexaS7lkI3QsYmVcx
	yqbkVunmJmbmFKcm6xYnJ+blpRbpmujlZpbopaaUbmIEB6ok/w7GbweVDjEKcDAq8fA+iGwK
	EmJNLCuuzD3EKMnBpCTK66TTHCTEl5SfUpmRWJwRX1Sak1p8iFGCg1lJhPeAMFCONyWxsiq1
	KB8mJc3BoiTOe5PDPkhIID2xJDU7NbUgtQgmK8PBoSTB+9cQqFGwKDU9tSItM6cEIc3EwQky
	nAdo+EyQGt7igsTc4sx0iPwpRkUpcd5ckIQASCKjNA+uF5ZIXjGKA70izCtqBFTFA0xCcN2v
	gAYzAQ22KG4CGVySiJCSamB0+W4t1HfM7NBzz5N7/j9x4Wivf/V8E5+JSkHXbfPshaevfCmU
	irxuF/2aWSz9sM6HC4Ye0X4sX2PavwRv++u55m6Mi1hFh8gd7u+799/YzVaU+Kgn6eaCC6WT
	v9xb2JHNoXKY3/NskvXH8yJVDSa9h223ua/ZcPUDp1/j+sy9W1fO2M/SIPJfiaU4I9FQi7mo
	OBEAUXSaD/8CAAA=
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
index cf1357b..fe7ecdd 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -962,17 +962,9 @@ static void push_to_pool(struct work_struct *work)
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
@@ -1022,6 +1014,12 @@ retry:
 	return ibytes;
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
@@ -1083,6 +1081,15 @@ static void extract_buf(struct entropy_store *r, __u8 *out)
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
@@ -1133,6 +1140,10 @@ static ssize_t extract_entropy(struct entropy_store *r, void *buf,
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

