Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932288Ab3GOO1u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 10:27:50 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:56529 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932229Ab3GOO1p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 10:27:45 -0400
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Peng Tao <bergwolf@gmail.com>,
        Peng Tao <tao.peng@emc.com>, Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH-v3 03/17] staging/lustre: don't assert module owner
Date: Mon, 15 Jul 2013 22:27:06 +0800
Message-Id: <1373898440-14208-4-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1373898440-14208-1-git-send-email-bergwolf@gmail.com>
References: <1373898440-14208-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It can well be NULL if Lustre is builtin.

Signed-off-by: Peng Tao <tao.peng@emc.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 drivers/staging/lustre/lustre/obdclass/lu_object.c |    3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/staging/lustre/lustre/obdclass/lu_object.c b/drivers/staging/lustre/lustre/obdclass/lu_object.c
index fdaf4f8..5559732 100644
--- a/drivers/staging/lustre/lustre/obdclass/lu_object.c
+++ b/drivers/staging/lustre/lustre/obdclass/lu_object.c
@@ -1315,7 +1315,6 @@ int lu_context_key_register(struct lu_context_key *key)
 	LASSERT(key->lct_init != NULL);
 	LASSERT(key->lct_fini != NULL);
 	LASSERT(key->lct_tags != 0);
-	LASSERT(key->lct_owner != NULL);
 
 	result = -ENFILE;
 	spin_lock(&lu_keys_guard);
@@ -1349,7 +1348,6 @@ static void key_fini(struct lu_context *ctx, int index)
 		lu_ref_del(&key->lct_reference, "ctx", ctx);
 		atomic_dec(&key->lct_used);
 
-		LASSERT(key->lct_owner != NULL);
 		if ((ctx->lc_tags & LCT_NOREF) == 0) {
 #ifdef CONFIG_MODULE_UNLOAD
 			LINVRNT(module_refcount(key->lct_owner) > 0);
@@ -1557,7 +1555,6 @@ static int keys_fill(struct lu_context *ctx)
 			if (unlikely(IS_ERR(value)))
 				return PTR_ERR(value);
 
-			LASSERT(key->lct_owner != NULL);
 			if (!(ctx->lc_tags & LCT_NOREF))
 				try_module_get(key->lct_owner);
 			lu_ref_add_atomic(&key->lct_reference, "ctx", ctx);
-- 
1.7.9.5

