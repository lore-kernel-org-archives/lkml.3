Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755468AbaEORZ4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 13:25:56 -0400
Received: from mailrelay007.isp.belgacom.be ([195.238.6.173]:33745 "EHLO
	mailrelay007.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755145AbaEORYN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 13:24:13 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AnRMAMT3dFNXQwiB/2dsb2JhbABZgwaBYYFdqFoEAQEBAQEBBQGaGQICgREXdIJTExwjGIECJBOIRQHRLoVUiHqERwEDjyqKJgGLDYgHgzg7MA
Date: Thu, 15 May 2014 19:24:09 +0200
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>,
        Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
Subject: [PATCH 3/3] FS/HPFS: use __func__ for logging
Message-Id: <20140515192409.c8990dd41f8d034832ee1c63@skynet.be>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Normalize function display fx() using __func__

Cc: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/hpfs/buffer.c | 12 ++++++------
 fs/hpfs/dnode.c  | 12 ++++++------
 2 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/fs/hpfs/buffer.c b/fs/hpfs/buffer.c
index e5f62d4..07e0b0f 100644
--- a/fs/hpfs/buffer.c
+++ b/fs/hpfs/buffer.c
@@ -55,7 +55,7 @@ void *hpfs_map_sector(struct super_block *s, unsigned secno, struct buffer_head
 	if (bh != NULL)
 		return bh->b_data;
 	else {
-		pr_warn("hpfs_map_sector: read error\n");
+		pr_warn("%s(): read error\n", __func__);
 		return NULL;
 	}
 }
@@ -76,7 +76,7 @@ void *hpfs_get_sector(struct super_block *s, unsigned secno, struct buffer_head
 		set_buffer_uptodate(bh);
 		return bh->b_data;
 	} else {
-		pr_warn("hpfs_get_sector: getblk failed\n");
+		pr_warn("%s(): getblk failed\n", __func__);
 		return NULL;
 	}
 }
@@ -93,7 +93,7 @@ void *hpfs_map_4sectors(struct super_block *s, unsigned secno, struct quad_buffe
 	cond_resched();
 
 	if (secno & 3) {
-		pr_warn("hpfs_map_4sectors: unaligned read\n");
+		pr_warn("%s(): unaligned read\n", __func__);
 		return NULL;
 	}
 
@@ -112,7 +112,7 @@ void *hpfs_map_4sectors(struct super_block *s, unsigned secno, struct quad_buffe
 
 	qbh->data = data = kmalloc(2048, GFP_NOFS);
 	if (!data) {
-		pr_warn("hpfs_map_4sectors: out of memory\n");
+		pr_warn("%s(): out of memory\n", __func__);
 		goto bail4;
 	}
 
@@ -145,7 +145,7 @@ void *hpfs_get_4sectors(struct super_block *s, unsigned secno,
 	hpfs_lock_assert(s);
 
 	if (secno & 3) {
-		pr_warn("hpfs_get_4sectors: unaligned read\n");
+		pr_warn("%s(): unaligned read\n", __func__);
 		return NULL;
 	}
 
@@ -161,7 +161,7 @@ void *hpfs_get_4sectors(struct super_block *s, unsigned secno,
 	}
 
 	if (!(qbh->data = kmalloc(2048, GFP_NOFS))) {
-		pr_warn("hpfs_get_4sectors: out of memory\n");
+		pr_warn("%s(): out of memory\n", __func__);
 		goto bail4;
 	}
 	return qbh->data;
diff --git a/fs/hpfs/dnode.c b/fs/hpfs/dnode.c
index 69554e2..d10c5e9 100644
--- a/fs/hpfs/dnode.c
+++ b/fs/hpfs/dnode.c
@@ -17,7 +17,7 @@ static loff_t get_pos(struct dnode *d, struct hpfs_dirent *fde)
 		if (de == fde) return ((loff_t) le32_to_cpu(d->self) << 4) | (loff_t)i;
 		i++;
 	}
-	pr_info("get_pos: not_found\n");
+	pr_info("%s(): not_found\n", __func__);
 	return ((loff_t)le32_to_cpu(d->self) << 4) | (loff_t)1;
 }
 
@@ -94,8 +94,8 @@ static void hpfs_pos_ins(loff_t *p, loff_t d, loff_t c)
 	if ((*p & ~0x3f) == (d & ~0x3f) && (*p & 0x3f) >= (d & 0x3f)) {
 		int n = (*p & 0x3f) + c;
 		if (n > 0x3f)
-			pr_warn("hpfs_pos_ins: %08x + %d\n",
-				(int)*p, (int)c >> 8);
+			pr_warn("%s(): %08x + %d\n",
+				__func__, (int)*p, (int)c >> 8);
 		else
 			*p = (*p & ~0x3f) | n;
 	}
@@ -106,8 +106,8 @@ static void hpfs_pos_del(loff_t *p, loff_t d, loff_t c)
 	if ((*p & ~0x3f) == (d & ~0x3f) && (*p & 0x3f) >= (d & 0x3f)) {
 		int n = (*p & 0x3f) - c;
 		if (n < 1)
-			pr_warn("hpfs_pos_ins: %08x - %d\n",
-				(int)*p, (int)c >> 8);
+			pr_warn("%s(): %08x - %d\n",
+				__func__, (int)*p, (int)c >> 8);
 		else
 			*p = (*p & ~0x3f) | n;
 	}
@@ -251,7 +251,7 @@ static int hpfs_add_to_dnode(struct inode *i, dnode_secno dno,
 	}
 	go_up:
 	if (namelen >= 256) {
-		hpfs_error(i->i_sb, "hpfs_add_to_dnode: namelen == %d", namelen);
+		hpfs_error(i->i_sb, "%s(): namelen == %d", __func__, namelen);
 		kfree(nd);
 		kfree(nname);
 		return 1;
-- 
1.8.4.5
