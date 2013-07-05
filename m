Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757345Ab3GEMP2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 08:15:28 -0400
Received: from mail-we0-f181.google.com ([74.125.82.181]:63292 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756596Ab3GEMP1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 08:15:27 -0400
From: Laurent Navet <laurent.navet@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andreas Dilger <andreas.dilger@intel.com>, Peng Tao <tao.peng@emc.com>,
        Niu Yawei <yawei.niu@intel.com>, Oleg Drokin <oleg.drokin@intel.com>,
        Alex Zhuravlev <alexey.zhuravlev@intel.com>,
        Fan Yong <fan.yong@intel.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Laurent Navet <laurent.navet@gmail.com>
Subject: [PATCH] staging: lustre: use ERR_CAST() function
Date: Fri,  5 Jul 2013 14:26:33 +0200
Message-Id: <1373027193-7565-1-git-send-email-laurent.navet@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

use ERR_CAST() function instead of ERR_PTR() and PTR_ERR()
found using coccinelle and err_cast.cocci

Signed-off-by: Laurent Navet <laurent.navet@gmail.com>
---
 drivers/staging/lustre/lustre/llite/llite_nfs.c        |    2 +-
 drivers/staging/lustre/lustre/llite/rw.c               |    2 +-
 drivers/staging/lustre/lustre/obdclass/local_storage.c |    4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/lustre/lustre/llite/llite_nfs.c b/drivers/staging/lustre/lustre/llite/llite_nfs.c
index 28cc41e..d2c459c 100644
--- a/drivers/staging/lustre/lustre/llite/llite_nfs.c
+++ b/drivers/staging/lustre/lustre/llite/llite_nfs.c
@@ -131,7 +131,7 @@ ll_iget_for_nfs(struct super_block *sb, struct lu_fid *fid, struct lu_fid *paren
 
 	inode = search_inode_for_lustre(sb, fid);
 	if (IS_ERR(inode))
-		RETURN(ERR_PTR(PTR_ERR(inode)));
+		RETURN(ERR_CAST(inode));
 
 	if (is_bad_inode(inode)) {
 		/* we didn't find the right inode.. */
diff --git a/drivers/staging/lustre/lustre/llite/rw.c b/drivers/staging/lustre/lustre/llite/rw.c
index fac1178..30e98ed 100644
--- a/drivers/staging/lustre/lustre/llite/rw.c
+++ b/drivers/staging/lustre/lustre/llite/rw.c
@@ -110,7 +110,7 @@ static struct ll_cl_context *ll_cl_init(struct file *file,
 
 	env = cl_env_get(&refcheck);
 	if (IS_ERR(env))
-		return ERR_PTR(PTR_ERR(env));
+		return ERR_CAST(env);
 
 	lcc = &vvp_env_info(env)->vti_io_ctx;
 	memset(lcc, 0, sizeof(*lcc));
diff --git a/drivers/staging/lustre/lustre/obdclass/local_storage.c b/drivers/staging/lustre/lustre/obdclass/local_storage.c
index 3be35a8..e1db7ab 100644
--- a/drivers/staging/lustre/lustre/obdclass/local_storage.c
+++ b/drivers/staging/lustre/lustre/obdclass/local_storage.c
@@ -443,7 +443,7 @@ struct dt_object *local_file_find_or_create_with_fid(const struct lu_env *env,
 
 		ls = ls_device_get(dt);
 		if (IS_ERR(ls)) {
-			dto = ERR_PTR(PTR_ERR(ls));
+			dto = ERR_CAST(ls);
 		} else {
 			/* create the object */
 			dti->dti_attr.la_valid	= LA_MODE;
@@ -537,7 +537,7 @@ local_index_find_or_create_with_fid(const struct lu_env *env,
 
 		ls = ls_device_get(dt);
 		if (IS_ERR(ls)) {
-			dto = ERR_PTR(PTR_ERR(ls));
+			dto = ERR_CAST(ls);
 		} else {
 			/* create the object */
 			dti->dti_attr.la_valid		= LA_MODE;
-- 
1.7.10.4

