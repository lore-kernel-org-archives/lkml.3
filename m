Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754734AbaIKXkS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 19:40:18 -0400
Received: from mail-yh0-f46.google.com ([209.85.213.46]:49553 "EHLO
	mail-yh0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754594AbaIKXkN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 19:40:13 -0400
From: Greg Donald <gdonald@gmail.com>
To: Greg Kroah-Hartman <greg@kroah.com>,
        Andreas Dilger <andreas.dilger@intel.com>,
        Oleg Drokin <oleg.drokin@intel.com>, linux-kernel@vger.kernel.org,
        Joe Perches <joe@perches.com>
Cc: Greg Donald <gdonald@gmail.com>
Subject: [PATCH] drivers: staging: lustre: Cleanup src/dst comparisons in obdo_cmp_md()
Date: Thu, 11 Sep 2014 18:38:25 -0500
Message-Id: <1410478705-5052-1-git-send-email-gdonald@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cleanup obdo_cmp_md() src/dst comparisons using bitwise OR assignments

Suggested-by: Joe Perches <joe@perches.com>
Signed-off-by: Greg Donald <gdonald@gmail.com>
---
 drivers/staging/lustre/lustre/obdclass/obdo.c | 32 +++++++++++++--------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/staging/lustre/lustre/obdclass/obdo.c b/drivers/staging/lustre/lustre/obdclass/obdo.c
index b97433e..307ffe3 100644
--- a/drivers/staging/lustre/lustre/obdclass/obdo.c
+++ b/drivers/staging/lustre/lustre/obdclass/obdo.c
@@ -162,38 +162,38 @@ int obdo_cmp_md(struct obdo *dst, struct obdo *src, u32 compare)
 	int res = 0;
 
 	if (compare & OBD_MD_FLATIME)
-		res = (res || (dst->o_atime != src->o_atime));
+		res |= dst->o_atime != src->o_atime;
 	if (compare & OBD_MD_FLMTIME)
-		res = (res || (dst->o_mtime != src->o_mtime));
+		res |= dst->o_mtime != src->o_mtime;
 	if (compare & OBD_MD_FLCTIME)
-		res = (res || (dst->o_ctime != src->o_ctime));
+		res |= dst->o_ctime != src->o_ctime;
 	if (compare & OBD_MD_FLSIZE)
-		res = (res || (dst->o_size != src->o_size));
+		res |= dst->o_size != src->o_size;
 	if (compare & OBD_MD_FLBLOCKS) /* allocation of space */
-		res = (res || (dst->o_blocks != src->o_blocks));
+		res |= dst->o_blocks != src->o_blocks;
 	if (compare & OBD_MD_FLBLKSZ)
-		res = (res || (dst->o_blksize != src->o_blksize));
+		res |= dst->o_blksize != src->o_blksize;
 	if (compare & OBD_MD_FLTYPE)
-		res = (res || (((dst->o_mode ^ src->o_mode) & S_IFMT) != 0));
+		res |= ((dst->o_mode ^ src->o_mode) & S_IFMT) != 0;
 	if (compare & OBD_MD_FLMODE)
-		res = (res || (((dst->o_mode ^ src->o_mode) & ~S_IFMT) != 0));
+		res |= ((dst->o_mode ^ src->o_mode) & ~S_IFMT) != 0;
 	if (compare & OBD_MD_FLUID)
-		res = (res || (dst->o_uid != src->o_uid));
+		res |= dst->o_uid != src->o_uid;
 	if (compare & OBD_MD_FLGID)
-		res = (res || (dst->o_gid != src->o_gid));
+		res |= dst->o_gid != src->o_gid;
 	if (compare & OBD_MD_FLFLAGS)
-		res = (res || (dst->o_flags != src->o_flags));
+		res |= dst->o_flags != src->o_flags;
 	if (compare & OBD_MD_FLNLINK)
-		res = (res || (dst->o_nlink != src->o_nlink));
+		res |= dst->o_nlink != src->o_nlink;
 	if (compare & OBD_MD_FLFID) {
-		res = (res || (dst->o_parent_seq != src->o_parent_seq));
-		res = (res || (dst->o_parent_ver != src->o_parent_ver));
+		res |= dst->o_parent_seq != src->o_parent_seq;
+		res |= dst->o_parent_ver != src->o_parent_ver;
 	}
 	if (compare & OBD_MD_FLGENER)
-		res = (res || (dst->o_parent_oid != src->o_parent_oid));
+		res |= dst->o_parent_oid != src->o_parent_oid;
 	/* XXX Don't know if these should be included here - wasn't previously
 	if ( compare & OBD_MD_FLINLINE )
-		res = (res || memcmp(dst->o_inline, src->o_inline));
+		res |= memcmp(dst->o_inline, src->o_inline);
 	*/
 	return res;
 }
-- 
1.9.1

