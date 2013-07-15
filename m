Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932108Ab3GONLo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 09:11:44 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53926 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756835Ab3GONLk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 09:11:40 -0400
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Peng Tao <tao.peng@emc.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH-v2 15/17] staging/lustre/llite: fix for d_compare API change
Date: Mon, 15 Jul 2013 21:08:13 +0800
Message-Id: <1373893695-4094-16-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1373893695-4094-1-git-send-email-bergwolf@gmail.com>
References: <1373893695-4094-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peng Tao <tao.peng@emc.com>

Signed-off-by: Peng Tao <tao.peng@emc.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 drivers/staging/lustre/lustre/llite/dcache.c       |    3 +--
 .../staging/lustre/lustre/llite/llite_internal.h   |    3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/lustre/lustre/llite/dcache.c b/drivers/staging/lustre/lustre/llite/dcache.c
index 40b0f3b..a160a84 100644
--- a/drivers/staging/lustre/lustre/llite/dcache.c
+++ b/drivers/staging/lustre/lustre/llite/dcache.c
@@ -84,8 +84,7 @@ static void ll_release(struct dentry *de)
  * an AST before calling d_revalidate_it().  The dentry still exists (marked
  * INVALID) so d_lookup() matches it, but we have no lock on it (so
  * lock_match() fails) and we spin around real_lookup(). */
-int ll_dcompare(const struct dentry *parent, const struct inode *pinode,
-		const struct dentry *dentry, const struct inode *inode,
+int ll_dcompare(const struct dentry *parent, const struct dentry *dentry,
 		unsigned int len, const char *str, const struct qstr *name)
 {
 	ENTRY;
diff --git a/drivers/staging/lustre/lustre/llite/llite_internal.h b/drivers/staging/lustre/lustre/llite/llite_internal.h
index 1069b8d..cbcd118 100644
--- a/drivers/staging/lustre/lustre/llite/llite_internal.h
+++ b/drivers/staging/lustre/lustre/llite/llite_internal.h
@@ -784,8 +784,7 @@ void ll_intent_release(struct lookup_intent *);
 void ll_invalidate_aliases(struct inode *);
 void ll_frob_intent(struct lookup_intent **itp, struct lookup_intent *deft);
 void ll_lookup_finish_locks(struct lookup_intent *it, struct dentry *dentry);
-int ll_dcompare(const struct dentry *parent, const struct inode *pinode,
-		const struct dentry *dentry, const struct inode *inode,
+int ll_dcompare(const struct dentry *parent, const struct dentry *dentry,
 		unsigned int len, const char *str, const struct qstr *d_name);
 int ll_revalidate_it_finish(struct ptlrpc_request *request,
 			    struct lookup_intent *it, struct dentry *de);
-- 
1.7.9.5

