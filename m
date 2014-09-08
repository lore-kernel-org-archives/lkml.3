Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755082AbaIHWG6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 18:06:58 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:39845 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753724AbaIHWG5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 18:06:57 -0400
Message-ID: <540E287D.5090101@gmail.com>
Date: Tue, 09 Sep 2014 00:06:53 +0200
From: Hugues <morisset.hugues@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: gregkh@linuxfoundation.org
CC: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] staging: lustre: fix coding style issues
References: <540E27FB.2070206@gmail.com>
In-Reply-To: <540E27FB.2070206@gmail.com>
Content-Type: multipart/mixed;
 boundary="------------010607080900090808090707"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010607080900090808090707
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit

Fix coding style issues:
* Remove inappropriate typedefs

--------------010607080900090808090707
Content-Type: text/x-patch;
 name="0002-staging-lustre-fix-coding-style-issues.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="0002-staging-lustre-fix-coding-style-issues.patch"

>From a2c6d82141849cd102b5805941351a6b20df0e8a Mon Sep 17 00:00:00 2001
From: Hugues Morisset <morisset.hugues@gmail.com>
Date: Mon, 8 Sep 2014 21:36:10 +0200
Subject: [PATCH 2/4] staging: lustre: fix coding style issues

Signed-off-by: Hugues Morisset <morisset.hugues@gmail.com>
---
 drivers/staging/lustre/lustre/include/obd.h   | 10 +++-------
 drivers/staging/lustre/lustre/lmv/lmv_obd.c   |  2 +-
 drivers/staging/lustre/lustre/lmv/lproc_lmv.c |  6 +++---
 3 files changed, 7 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/lustre/lustre/include/obd.h b/drivers/staging/lustre/lustre/include/obd.h
index b0afbb2..5f1d8c7 100644
--- a/drivers/staging/lustre/lustre/include/obd.h
+++ b/drivers/staging/lustre/lustre/include/obd.h
@@ -590,13 +590,11 @@ enum placement_policy {
 	PLACEMENT_MAX_POLICY
 };
 
-typedef enum placement_policy placement_policy_t;
-
 struct lmv_obd {
 	int			refcount;
 	struct lu_client_fld	lmv_fld;
 	spinlock_t		lmv_lock;
-	placement_policy_t	lmv_placement;
+	enum placement_policy	lmv_placement;
 	struct lmv_desc		desc;
 	struct obd_uuid		cluuid;
 	struct obd_export	*exp;
@@ -1118,16 +1116,14 @@ enum op_cli_flags {
 
 struct md_enqueue_info;
 /* metadata stat-ahead */
-typedef int (* md_enqueue_cb_t)(struct ptlrpc_request *req,
-				struct md_enqueue_info *minfo,
-				int rc);
 
 struct md_enqueue_info {
 	struct md_op_data       mi_data;
 	struct lookup_intent    mi_it;
 	struct lustre_handle    mi_lockh;
 	struct inode	   *mi_dir;
-	md_enqueue_cb_t	 mi_cb;
+	int (*mi_cb)(struct ptlrpc_request *req,
+		struct md_enqueue_info *minfo, int rc);
 	__u64		   mi_cbdata;
 	unsigned int	    mi_generation;
 };
diff --git a/drivers/staging/lustre/lustre/lmv/lmv_obd.c b/drivers/staging/lustre/lustre/lmv/lmv_obd.c
index dfb10d6..1a58212 100644
--- a/drivers/staging/lustre/lustre/lmv/lmv_obd.c
+++ b/drivers/staging/lustre/lustre/lmv/lmv_obd.c
@@ -1189,7 +1189,7 @@ static int lmv_nid_policy(struct lmv_obd *lmv)
 }
 
 static int lmv_choose_mds(struct lmv_obd *lmv, struct md_op_data *op_data,
-			  placement_policy_t placement)
+			  enum placement_policy placement)
 {
 	switch (placement) {
 	case PLACEMENT_CHAR_POLICY:
diff --git a/drivers/staging/lustre/lustre/lmv/lproc_lmv.c b/drivers/staging/lustre/lustre/lmv/lproc_lmv.c
index a7814f1..1170020 100644
--- a/drivers/staging/lustre/lustre/lmv/lproc_lmv.c
+++ b/drivers/staging/lustre/lustre/lmv/lproc_lmv.c
@@ -58,7 +58,7 @@ static const char *placement_name[] = {
 	[PLACEMENT_INVAL_POLICY]  = "INVAL"
 };
 
-static placement_policy_t placement_name2policy(char *name, int len)
+static enum placement_policy placement_name2policy(char *name, int len)
 {
 	int		     i;
 
@@ -69,7 +69,7 @@ static placement_policy_t placement_name2policy(char *name, int len)
 	return PLACEMENT_INVAL_POLICY;
 }
 
-static const char *placement_policy2name(placement_policy_t placement)
+static const char *placement_policy2name(enum placement_policy placement)
 {
 	LASSERT(placement < PLACEMENT_MAX_POLICY);
 	return placement_name[placement];
@@ -94,7 +94,7 @@ static ssize_t lmv_placement_seq_write(struct file *file,
 	struct obd_device *dev = ((struct seq_file *)file->private_data)->private;
 	char		     dummy[MAX_POLICY_STRING_SIZE + 1];
 	int		      len = count;
-	placement_policy_t       policy;
+	enum placement_policy       policy;
 	struct lmv_obd	  *lmv;
 
 	if (copy_from_user(dummy, buffer, MAX_POLICY_STRING_SIZE))
-- 
2.1.0


--------------010607080900090808090707--
