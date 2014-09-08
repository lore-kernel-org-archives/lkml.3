Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755337AbaIHWck (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 18:32:40 -0400
Received: from mail-yh0-f47.google.com ([209.85.213.47]:61237 "EHLO
	mail-yh0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755186AbaIHWci (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 18:32:38 -0400
From: Greg Donald <gdonald@gmail.com>
To: Greg Kroah-Hartman <greg@kroah.com>,
        Andreas Dilger <andreas.dilger@intel.com>,
        Oleg Drokin <oleg.drokin@intel.com>, linux-kernel@vger.kernel.org
Cc: Greg Donald <gdonald@gmail.com>
Subject: [PATCH] drivers: staging: lustre: Fix "space prohibited after that open parenthesis '('" errors
Date: Mon,  8 Sep 2014 17:32:08 -0500
Message-Id: <1410215528-22856-1-git-send-email-gdonald@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix checkpatch.pl "space prohibited after that open parenthesis '('" errors

Signed-off-by: Greg Donald <gdonald@gmail.com>
---
 .../lustre/lustre/obdclass/linux/linux-module.c    |  4 ++--
 drivers/staging/lustre/lustre/obdclass/obdo.c      | 28 +++++++++++-----------
 2 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/staging/lustre/lustre/obdclass/linux/linux-module.c b/drivers/staging/lustre/lustre/obdclass/linux/linux-module.c
index 9ce3d36..50256a9 100644
--- a/drivers/staging/lustre/lustre/obdclass/linux/linux-module.c
+++ b/drivers/staging/lustre/lustre/obdclass/linux/linux-module.c
@@ -84,7 +84,7 @@ int obd_ioctl_getdata(char **buf, int *len, void *arg)
 	int offset = 0;
 
 	err = copy_from_user(&hdr, (void *)arg, sizeof(hdr));
-	if ( err )
+	if (err)
 		return err;
 
 	if (hdr.ioc_version != OBD_IOCTL_VERSION) {
@@ -118,7 +118,7 @@ int obd_ioctl_getdata(char **buf, int *len, void *arg)
 	data = (struct obd_ioctl_data *)*buf;
 
 	err = copy_from_user(*buf, (void *)arg, hdr.ioc_len);
-	if ( err ) {
+	if (err) {
 		OBD_FREE_LARGE(*buf, hdr.ioc_len);
 		return err;
 	}
diff --git a/drivers/staging/lustre/lustre/obdclass/obdo.c b/drivers/staging/lustre/lustre/obdclass/obdo.c
index bdc00ea..d170b14 100644
--- a/drivers/staging/lustre/lustre/obdclass/obdo.c
+++ b/drivers/staging/lustre/lustre/obdclass/obdo.c
@@ -161,35 +161,35 @@ int obdo_cmp_md(struct obdo *dst, struct obdo *src, u32 compare)
 {
 	int res = 0;
 
-	if ( compare & OBD_MD_FLATIME )
+	if (compare & OBD_MD_FLATIME)
 		res = (res || (dst->o_atime != src->o_atime));
-	if ( compare & OBD_MD_FLMTIME )
+	if (compare & OBD_MD_FLMTIME)
 		res = (res || (dst->o_mtime != src->o_mtime));
-	if ( compare & OBD_MD_FLCTIME )
+	if (compare & OBD_MD_FLCTIME)
 		res = (res || (dst->o_ctime != src->o_ctime));
-	if ( compare & OBD_MD_FLSIZE )
+	if (compare & OBD_MD_FLSIZE)
 		res = (res || (dst->o_size != src->o_size));
-	if ( compare & OBD_MD_FLBLOCKS ) /* allocation of space */
+	if (compare & OBD_MD_FLBLOCKS) /* allocation of space */
 		res = (res || (dst->o_blocks != src->o_blocks));
-	if ( compare & OBD_MD_FLBLKSZ )
+	if (compare & OBD_MD_FLBLKSZ)
 		res = (res || (dst->o_blksize != src->o_blksize));
-	if ( compare & OBD_MD_FLTYPE )
+	if (compare & OBD_MD_FLTYPE)
 		res = (res || (((dst->o_mode ^ src->o_mode) & S_IFMT) != 0));
-	if ( compare & OBD_MD_FLMODE )
+	if (compare & OBD_MD_FLMODE)
 		res = (res || (((dst->o_mode ^ src->o_mode) & ~S_IFMT) != 0));
-	if ( compare & OBD_MD_FLUID )
+	if (compare & OBD_MD_FLUID)
 		res = (res || (dst->o_uid != src->o_uid));
-	if ( compare & OBD_MD_FLGID )
+	if (compare & OBD_MD_FLGID)
 		res = (res || (dst->o_gid != src->o_gid));
-	if ( compare & OBD_MD_FLFLAGS )
+	if (compare & OBD_MD_FLFLAGS)
 		res = (res || (dst->o_flags != src->o_flags));
-	if ( compare & OBD_MD_FLNLINK )
+	if (compare & OBD_MD_FLNLINK)
 		res = (res || (dst->o_nlink != src->o_nlink));
-	if ( compare & OBD_MD_FLFID ) {
+	if (compare & OBD_MD_FLFID) {
 		res = (res || (dst->o_parent_seq != src->o_parent_seq));
 		res = (res || (dst->o_parent_ver != src->o_parent_ver));
 	}
-	if ( compare & OBD_MD_FLGENER )
+	if (compare & OBD_MD_FLGENER)
 		res = (res || (dst->o_parent_oid != src->o_parent_oid));
 	/* XXX Don't know if these should be included here - wasn't previously
 	if ( compare & OBD_MD_FLINLINE )
-- 
1.9.1

