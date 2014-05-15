Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753215AbaEORBZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 13:01:25 -0400
Received: from mailrelay012.isp.belgacom.be ([195.238.6.179]:59270 "EHLO
	mailrelay012.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751587AbaEORBY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 13:01:24 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AoMRAGLydFNXQwiB/2dsb2JhbABZgwaDPqhZBAEBAQEBAQUBmhkCAoERF3SCUxMcIxiBAiQTiEUB0SuFVIh6hEcBA48qiiYBiw2IB4M4Ow
Date: Thu, 15 May 2014 19:01:21 +0200
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Vyacheslav Dubeyko <slava@dubeyko.com>, akpm <akpm@linux-foundation.org>
Subject: [PATCH 1/1] fs/hfsplus/bnode.c: replace min/casting by min_t
Message-Id: <20140515190121.986e8999c2f305086106db86@skynet.be>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Also fixes some pr_ formats

Cc: Vyacheslav Dubeyko <slava@dubeyko.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/hfsplus/bnode.c | 32 +++++++++++++++-----------------
 1 file changed, 15 insertions(+), 17 deletions(-)

diff --git a/fs/hfsplus/bnode.c b/fs/hfsplus/bnode.c
index 11c8602..285502a 100644
--- a/fs/hfsplus/bnode.c
+++ b/fs/hfsplus/bnode.c
@@ -27,13 +27,13 @@ void hfs_bnode_read(struct hfs_bnode *node, void *buf, int off, int len)
 	pagep = node->page + (off >> PAGE_CACHE_SHIFT);
 	off &= ~PAGE_CACHE_MASK;
 
-	l = min(len, (int)PAGE_CACHE_SIZE - off);
+	l = min_t(int, len, PAGE_CACHE_SIZE - off);
 	memcpy(buf, kmap(*pagep) + off, l);
 	kunmap(*pagep);
 
 	while ((len -= l) != 0) {
 		buf += l;
-		l = min(len, (int)PAGE_CACHE_SIZE);
+		l = min_t(int, len, PAGE_CACHE_SIZE);
 		memcpy(buf, kmap(*++pagep), l);
 		kunmap(*pagep);
 	}
@@ -80,14 +80,14 @@ void hfs_bnode_write(struct hfs_bnode *node, void *buf, int off, int len)
 	pagep = node->page + (off >> PAGE_CACHE_SHIFT);
 	off &= ~PAGE_CACHE_MASK;
 
-	l = min(len, (int)PAGE_CACHE_SIZE - off);
+	l = min_t(int, len, PAGE_CACHE_SIZE - off);
 	memcpy(kmap(*pagep) + off, buf, l);
 	set_page_dirty(*pagep);
 	kunmap(*pagep);
 
 	while ((len -= l) != 0) {
 		buf += l;
-		l = min(len, (int)PAGE_CACHE_SIZE);
+		l = min_t(int, len, PAGE_CACHE_SIZE);
 		memcpy(kmap(*++pagep), buf, l);
 		set_page_dirty(*pagep);
 		kunmap(*pagep);
@@ -110,13 +110,13 @@ void hfs_bnode_clear(struct hfs_bnode *node, int off, int len)
 	pagep = node->page + (off >> PAGE_CACHE_SHIFT);
 	off &= ~PAGE_CACHE_MASK;
 
-	l = min(len, (int)PAGE_CACHE_SIZE - off);
+	l = min_t(int, len, PAGE_CACHE_SIZE - off);
 	memset(kmap(*pagep) + off, 0, l);
 	set_page_dirty(*pagep);
 	kunmap(*pagep);
 
 	while ((len -= l) != 0) {
-		l = min(len, (int)PAGE_CACHE_SIZE);
+		l = min_t(int, len, PAGE_CACHE_SIZE);
 		memset(kmap(*++pagep), 0, l);
 		set_page_dirty(*pagep);
 		kunmap(*pagep);
@@ -142,14 +142,14 @@ void hfs_bnode_copy(struct hfs_bnode *dst_node, int dst,
 	dst &= ~PAGE_CACHE_MASK;
 
 	if (src == dst) {
-		l = min(len, (int)PAGE_CACHE_SIZE - src);
+		l = min_t(int, len, PAGE_CACHE_SIZE - src);
 		memcpy(kmap(*dst_page) + src, kmap(*src_page) + src, l);
 		kunmap(*src_page);
 		set_page_dirty(*dst_page);
 		kunmap(*dst_page);
 
 		while ((len -= l) != 0) {
-			l = min(len, (int)PAGE_CACHE_SIZE);
+			l = min_t(int, len, PAGE_CACHE_SIZE);
 			memcpy(kmap(*++dst_page), kmap(*++src_page), l);
 			kunmap(*src_page);
 			set_page_dirty(*dst_page);
@@ -251,7 +251,7 @@ void hfs_bnode_move(struct hfs_bnode *node, int dst, int src, int len)
 		dst &= ~PAGE_CACHE_MASK;
 
 		if (src == dst) {
-			l = min(len, (int)PAGE_CACHE_SIZE - src);
+			l = min_t(int, len, PAGE_CACHE_SIZE - src);
 			memmove(kmap(*dst_page) + src,
 				kmap(*src_page) + src, l);
 			kunmap(*src_page);
@@ -259,7 +259,7 @@ void hfs_bnode_move(struct hfs_bnode *node, int dst, int src, int len)
 			kunmap(*dst_page);
 
 			while ((len -= l) != 0) {
-				l = min(len, (int)PAGE_CACHE_SIZE);
+				l = min_t(int, len, PAGE_CACHE_SIZE);
 				memmove(kmap(*++dst_page),
 					kmap(*++src_page), l);
 				kunmap(*src_page);
@@ -386,9 +386,8 @@ struct hfs_bnode *hfs_bnode_findhash(struct hfs_btree *tree, u32 cnid)
 	struct hfs_bnode *node;
 
 	if (cnid >= tree->node_count) {
-		pr_err("request for non-existent node "
-				"%d in B*Tree\n",
-			cnid);
+		pr_err("request for non-existent node %d in B*Tree\n",
+		       cnid);
 		return NULL;
 	}
 
@@ -409,9 +408,8 @@ static struct hfs_bnode *__hfs_bnode_create(struct hfs_btree *tree, u32 cnid)
 	loff_t off;
 
 	if (cnid >= tree->node_count) {
-		pr_err("request for non-existent node "
-				"%d in B*Tree\n",
-			cnid);
+		pr_err("request for non-existent node %d in B*Tree\n",
+		       cnid);
 		return NULL;
 	}
 
@@ -602,7 +600,7 @@ struct hfs_bnode *hfs_bnode_create(struct hfs_btree *tree, u32 num)
 
 	pagep = node->page;
 	memset(kmap(*pagep) + node->page_offset, 0,
-	       min((int)PAGE_CACHE_SIZE, (int)tree->node_size));
+	       min_t(int, PAGE_CACHE_SIZE, tree->node_size));
 	set_page_dirty(*pagep);
 	kunmap(*pagep);
 	for (i = 1; i < tree->pages_per_bnode; i++) {
-- 
1.8.4.5

