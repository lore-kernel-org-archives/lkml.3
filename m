Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757168AbaFZAe7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 20:34:59 -0400
Received: from smtprelay0122.hostedemail.com ([216.40.44.122]:36302 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755212AbaFZAe6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 20:34:58 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:800:960:966:973:988:989:1260:1261:1277:1311:1313:1314:1345:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2196:2198:2199:2200:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3865:4321:4385:4605:5007:6117:7652:7903:9040:10004:10400:10848:11026:11658:11914:12296:12438:12517:12519:12555:13069:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: paint48_827ad4447080d
X-Filterd-Recvd-Size: 2500
Message-ID: <1403742895.28663.14.camel@joe-AO725>
Subject: [PATCH] adfs: Add __printf verification, fix format/argument
 mismatches
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Date: Wed, 25 Jun 2014 17:34:55 -0700
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Might as well do the right thing.

Signed-off-by: Joe Perches <joe@perches.com>
---
 fs/adfs/adfs.h      | 1 +
 fs/adfs/dir.c       | 2 +-
 fs/adfs/dir_fplus.c | 5 ++---
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/adfs/adfs.h b/fs/adfs/adfs.h
index c770337..24575d9 100644
--- a/fs/adfs/adfs.h
+++ b/fs/adfs/adfs.h
@@ -153,6 +153,7 @@ extern int adfs_map_lookup(struct super_block *sb, unsigned int frag_id, unsigne
 extern unsigned int adfs_map_free(struct super_block *sb);
 
 /* Misc */
+__printf(3, 4)
 void __adfs_error(struct super_block *sb, const char *function,
 		  const char *fmt, ...);
 #define adfs_error(sb, fmt...) __adfs_error(sb, __func__, fmt)
diff --git a/fs/adfs/dir.c b/fs/adfs/dir.c
index 0d138c0..51c279a 100644
--- a/fs/adfs/dir.c
+++ b/fs/adfs/dir.c
@@ -138,7 +138,7 @@ adfs_dir_lookup_byname(struct inode *inode, struct qstr *name, struct object_inf
 		goto out;
 
 	if (ADFS_I(inode)->parent_id != dir.parent_id) {
-		adfs_error(sb, "parent directory changed under me! (%lx but got %lx)\n",
+		adfs_error(sb, "parent directory changed under me! (%lx but got %x)\n",
 			   ADFS_I(inode)->parent_id, dir.parent_id);
 		ret = -EIO;
 		goto free_out;
diff --git a/fs/adfs/dir_fplus.c b/fs/adfs/dir_fplus.c
index 7673c1f..ee255c0 100644
--- a/fs/adfs/dir_fplus.c
+++ b/fs/adfs/dir_fplus.c
@@ -79,9 +79,8 @@ adfs_fplus_read(struct super_block *sb, unsigned int id, unsigned int sz, struct
 
 		dir->bh_fplus[blk] = sb_bread(sb, block);
 		if (!dir->bh_fplus[blk]) {
-			adfs_error(sb,	"dir object %X failed read for"
-					" offset %d, mapped block %X",
-					id, blk, block);
+			adfs_error(sb,	"dir object %x failed read for offset %d, mapped block %lX",
+				   id, blk, block);
 			goto out;
 		}
 


