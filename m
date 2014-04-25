Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752655AbaDYJrt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 05:47:49 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:60686 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752407AbaDYJmR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 05:42:17 -0400
From: Fabio Falzoi <fabio.falzoi84@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Fabio Falzoi <fabio.falzoi84@gmail.com>
Subject: [PATCH 3/3] Staging: lustre: gfp_mask should be of gfp_t type
Date: Fri, 25 Apr 2014 11:41:43 +0200
Message-Id: <1398418903-13315-4-git-send-email-fabio.falzoi84@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1398418903-13315-1-git-send-email-fabio.falzoi84@gmail.com>
References: <1398418903-13315-1-git-send-email-fabio.falzoi84@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed the following sparse complaints:

drivers/staging/lustre/lustre/ptlrpc/../../lustre/ldlm/ldlm_pool.c:1039:61:
	warning: restricted gfp_t degrades to integer
drivers/staging/lustre/lustre/ptlrpc/../../lustre/ldlm/ldlm_pool.c:1092:61:
	warning: restricted gfp_t degrades to integer
drivers/staging/lustre/lustre/ptlrpc/../../lustre/ldlm/ldlm_pool.c:1136:58:
	warning: incorrect type in argument 2 (different base types)
	expected unsigned int [unsigned] gfp_mask
	got restricted gfp_t [usertype] gfp_mask
drivers/staging/lustre/lustre/ptlrpc/../../lustre/ldlm/ldlm_pool.c:1142:34:
	warning: incorrect type in argument 3 (different base types)
	expected unsigned int [unsigned] gfp_mask
	got restricted gfp_t [usertype] gfp_mask
drivers/staging/lustre/lustre/ptlrpc/../../lustre/ldlm/ldlm_pool.c:1147:58:
	warning: incorrect type in argument 2 (different base types)
	expected unsigned int [unsigned] gfp_mask
	got restricted gfp_t [usertype] gfp_mask
drivers/staging/lustre/lustre/ptlrpc/../../lustre/ldlm/ldlm_pool.c:1153:34:
	warning: incorrect type in argument 3 (different base types)
	expected unsigned int [unsigned] gfp_mask
	got restricted gfp_t [usertype] gfp_mask

Signed-off-by: Fabio Falzoi <fabio.falzoi84@gmail.com>
---
 drivers/staging/lustre/lustre/include/lustre_dlm.h |  4 ++--
 drivers/staging/lustre/lustre/ldlm/ldlm_pool.c     | 10 +++++-----
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/lustre/lustre/include/lustre_dlm.h b/drivers/staging/lustre/lustre/include/lustre_dlm.h
index 154b1e1..e28e31a 100644
--- a/drivers/staging/lustre/lustre/include/lustre_dlm.h
+++ b/drivers/staging/lustre/lustre/include/lustre_dlm.h
@@ -212,7 +212,7 @@ struct ldlm_pool_ops {
 	int (*po_recalc)(struct ldlm_pool *pl);
 	/** Cancel at least \a nr locks from pool \a pl */
 	int (*po_shrink)(struct ldlm_pool *pl, int nr,
-			 unsigned int gfp_mask);
+			 gfp_t gfp_mask);
 	int (*po_setup)(struct ldlm_pool *pl, int limit);
 };
 
@@ -1463,7 +1463,7 @@ void ldlm_pools_fini(void);
 int ldlm_pool_init(struct ldlm_pool *pl, struct ldlm_namespace *ns,
 		   int idx, ldlm_side_t client);
 int ldlm_pool_shrink(struct ldlm_pool *pl, int nr,
-		     unsigned int gfp_mask);
+		     gfp_t gfp_mask);
 void ldlm_pool_fini(struct ldlm_pool *pl);
 int ldlm_pool_setup(struct ldlm_pool *pl, int limit);
 int ldlm_pool_recalc(struct ldlm_pool *pl);
diff --git a/drivers/staging/lustre/lustre/ldlm/ldlm_pool.c b/drivers/staging/lustre/lustre/ldlm/ldlm_pool.c
index ccb1e04..2cc6981 100644
--- a/drivers/staging/lustre/lustre/ldlm/ldlm_pool.c
+++ b/drivers/staging/lustre/lustre/ldlm/ldlm_pool.c
@@ -378,7 +378,7 @@ static int ldlm_srv_pool_recalc(struct ldlm_pool *pl)
  * locks smaller in next 10h.
  */
 static int ldlm_srv_pool_shrink(struct ldlm_pool *pl,
-				int nr, unsigned int gfp_mask)
+				int nr, gfp_t gfp_mask)
 {
 	__u32 limit;
 
@@ -518,7 +518,7 @@ static int ldlm_cli_pool_recalc(struct ldlm_pool *pl)
  * passed \a pl according to \a nr and \a gfp_mask.
  */
 static int ldlm_cli_pool_shrink(struct ldlm_pool *pl,
-				int nr, unsigned int gfp_mask)
+				int nr, gfp_t gfp_mask)
 {
 	struct ldlm_namespace *ns;
 	int unused;
@@ -603,7 +603,7 @@ int ldlm_pool_recalc(struct ldlm_pool *pl)
  * freeable locks. Otherwise, return the number of canceled locks.
  */
 int ldlm_pool_shrink(struct ldlm_pool *pl, int nr,
-		     unsigned int gfp_mask)
+		     gfp_t gfp_mask)
 {
 	int cancel = 0;
 
@@ -1029,7 +1029,7 @@ static struct completion ldlm_pools_comp;
  * count locks from all namespaces (if possible). Returns number of
  * cached locks.
  */
-static unsigned long ldlm_pools_count(ldlm_side_t client, unsigned int gfp_mask)
+static unsigned long ldlm_pools_count(ldlm_side_t client, gfp_t gfp_mask)
 {
 	int total = 0, nr_ns;
 	struct ldlm_namespace *ns;
@@ -1082,7 +1082,7 @@ static unsigned long ldlm_pools_count(ldlm_side_t client, unsigned int gfp_mask)
 	return total;
 }
 
-static unsigned long ldlm_pools_scan(ldlm_side_t client, int nr, unsigned int gfp_mask)
+static unsigned long ldlm_pools_scan(ldlm_side_t client, int nr, gfp_t gfp_mask)
 {
 	unsigned long freed = 0;
 	int tmp, nr_ns;
-- 
1.9.1

