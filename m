Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751766AbaJTP6X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 11:58:23 -0400
Received: from mail-yh0-f50.google.com ([209.85.213.50]:35420 "EHLO
	mail-yh0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751177AbaJTP6U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 11:58:20 -0400
From: Greg Donald <gdonald@gmail.com>
To: Greg Kroah-Hartman <greg@kroah.com>,
        Andreas Dilger <andreas.dilger@intel.com>,
        Oleg Drokin <oleg.drokin@intel.com>, linux-kernel@vger.kernel.org
Cc: Greg Donald <gdonald@gmail.com>
Subject: [PATCH] drivers: staging: lustre: Fix 'that open brace { should be on the previous line' errors
Date: Mon, 20 Oct 2014 10:58:13 -0500
Message-Id: <1413820693-28204-1-git-send-email-gdonald@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix checkpatch.pl 'that open brace { should be on the previous line' errors

Signed-off-by: Greg Donald <gdonald@gmail.com>
---
 drivers/staging/lustre/lustre/ldlm/ldlm_pool.c |  3 +--
 drivers/staging/lustre/lustre/libcfs/hash.c    | 25 +++++++++----------------
 2 files changed, 10 insertions(+), 18 deletions(-)

diff --git a/drivers/staging/lustre/lustre/ldlm/ldlm_pool.c b/drivers/staging/lustre/lustre/ldlm/ldlm_pool.c
index 6054eee..c50491d8 100644
--- a/drivers/staging/lustre/lustre/ldlm/ldlm_pool.c
+++ b/drivers/staging/lustre/lustre/ldlm/ldlm_pool.c
@@ -1205,8 +1205,7 @@ int ldlm_pools_recalc(ldlm_side_t client)
 		 * The rest is given to greedy namespaces.
 		 */
 		list_for_each_entry(ns, ldlm_namespace_list(client),
-					ns_list_chain)
-		{
+				    ns_list_chain) {
 			if (!equal && ns->ns_appetite != LDLM_NAMESPACE_GREEDY)
 				continue;
 
diff --git a/drivers/staging/lustre/lustre/libcfs/hash.c b/drivers/staging/lustre/lustre/libcfs/hash.c
index 3b67b7b..32da783 100644
--- a/drivers/staging/lustre/lustre/libcfs/hash.c
+++ b/drivers/staging/lustre/lustre/libcfs/hash.c
@@ -1371,8 +1371,7 @@ cfs_hash_lookup(struct cfs_hash *hs, const void *key)
 EXPORT_SYMBOL(cfs_hash_lookup);
 
 static void
-cfs_hash_for_each_enter(struct cfs_hash *hs)
-{
+cfs_hash_for_each_enter(struct cfs_hash *hs) {
 	LASSERT(!cfs_hash_is_exiting(hs));
 
 	if (!cfs_hash_with_rehash(hs))
@@ -1397,8 +1396,7 @@ cfs_hash_for_each_enter(struct cfs_hash *hs)
 }
 
 static void
-cfs_hash_for_each_exit(struct cfs_hash *hs)
-{
+cfs_hash_for_each_exit(struct cfs_hash *hs) {
 	int remained;
 	int bits;
 
@@ -1429,8 +1427,7 @@ cfs_hash_for_each_exit(struct cfs_hash *hs)
  */
 static __u64
 cfs_hash_for_each_tight(struct cfs_hash *hs, cfs_hash_for_each_cb_t func,
-			void *data, int remove_safe)
-{
+			void *data, int remove_safe) {
 	struct hlist_node     *hnode;
 	struct hlist_node     *pos;
 	struct cfs_hash_bd	 bd;
@@ -1523,8 +1520,7 @@ EXPORT_SYMBOL(cfs_hash_for_each);
 
 void
 cfs_hash_for_each_safe(struct cfs_hash *hs,
-		       cfs_hash_for_each_cb_t func, void *data)
-{
+		       cfs_hash_for_each_cb_t func, void *data) {
 	cfs_hash_for_each_tight(hs, func, data, 1);
 }
 EXPORT_SYMBOL(cfs_hash_for_each_safe);
@@ -1572,8 +1568,8 @@ EXPORT_SYMBOL(cfs_hash_size_get);
  * two cases, so iteration has to be stopped on change.
  */
 static int
-cfs_hash_for_each_relax(struct cfs_hash *hs, cfs_hash_for_each_cb_t func, void *data)
-{
+cfs_hash_for_each_relax(struct cfs_hash *hs, cfs_hash_for_each_cb_t func,
+			void *data) {
 	struct hlist_node *hnode;
 	struct hlist_node *tmp;
 	struct cfs_hash_bd     bd;
@@ -1634,8 +1630,7 @@ cfs_hash_for_each_relax(struct cfs_hash *hs, cfs_hash_for_each_cb_t func, void *
 
 int
 cfs_hash_for_each_nolock(struct cfs_hash *hs,
-			 cfs_hash_for_each_cb_t func, void *data)
-{
+			 cfs_hash_for_each_cb_t func, void *data) {
 	if (cfs_hash_with_no_lock(hs) ||
 	    cfs_hash_with_rehash_key(hs) ||
 	    !cfs_hash_with_no_itemref(hs))
@@ -1667,8 +1662,7 @@ EXPORT_SYMBOL(cfs_hash_for_each_nolock);
  */
 int
 cfs_hash_for_each_empty(struct cfs_hash *hs,
-			cfs_hash_for_each_cb_t func, void *data)
-{
+			cfs_hash_for_each_cb_t func, void *data) {
 	unsigned  i = 0;
 
 	if (cfs_hash_with_no_lock(hs))
@@ -1726,8 +1720,7 @@ EXPORT_SYMBOL(cfs_hash_hlist_for_each);
    */
 void
 cfs_hash_for_each_key(struct cfs_hash *hs, const void *key,
-		      cfs_hash_for_each_cb_t func, void *data)
-{
+		      cfs_hash_for_each_cb_t func, void *data) {
 	struct hlist_node   *hnode;
 	struct cfs_hash_bd       bds[2];
 	unsigned	    i;
-- 
1.9.1

