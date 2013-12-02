Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753419Ab3LBKh0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 05:37:26 -0500
Received: from mail-pb0-f42.google.com ([209.85.160.42]:55366 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753087Ab3LBKhZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 05:37:25 -0500
From: Zhouyi Zhou <zhouzhouyi@gmail.com>
To: <dwmw2@infradead.org>, <linux-mtd@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Cc: Zhouyi Zhou <yizhouzhou@ict.ac.cn>
Subject: [PATCH] JFFS2: NULL return of kmem_cache_zalloc should be handled.
Date: Mon,  2 Dec 2013 18:37:05 +0800
Message-Id: <1385980625-26545-1-git-send-email-yizhouzhou@ict.ac.cn>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

NULL return of kmem_cache_zalloc should be handled in jffs2_alloc_xattr_datum
and jff2_alloc_xattr_ref.

Signed-off-by: Zhouyi Zhou <yizhouzhou@ict.ac.cn>
---
 fs/jffs2/malloc.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/jffs2/malloc.c b/fs/jffs2/malloc.c
index 4f47aa2..b8fd651 100644
--- a/fs/jffs2/malloc.c
+++ b/fs/jffs2/malloc.c
@@ -288,6 +288,8 @@ struct jffs2_xattr_datum *jffs2_alloc_xattr_datum(void)
 	struct jffs2_xattr_datum *xd;
 	xd = kmem_cache_zalloc(xattr_datum_cache, GFP_KERNEL);
 	dbg_memalloc("%p\n", xd);
+	if (!xd)
+		return NULL;
 
 	xd->class = RAWNODE_CLASS_XATTR_DATUM;
 	xd->node = (void *)xd;
@@ -306,6 +308,8 @@ struct jffs2_xattr_ref *jffs2_alloc_xattr_ref(void)
 	struct jffs2_xattr_ref *ref;
 	ref = kmem_cache_zalloc(xattr_ref_cache, GFP_KERNEL);
 	dbg_memalloc("%p\n", ref);
+	if (!ref)
+		return NULL;
 
 	ref->class = RAWNODE_CLASS_XATTR_REF;
 	ref->node = (void *)ref;
-- 
1.7.10.4

