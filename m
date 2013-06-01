Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758613Ab3FAJlT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jun 2013 05:41:19 -0400
Received: from www17.your-server.de ([213.133.104.17]:58909 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758271Ab3FAJlQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jun 2013 05:41:16 -0400
Message-ID: <1370079672.29224.11.camel@localhost.localdomain>
Subject: [PATCH] ocfs2: Cocci spatch "memdup.spatch"
From: Thomas Meyer <thomas@m3y3r.de>
To: linux-kernel@vger.kernel.org
Date: Sat, 01 Jun 2013 11:41:12 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
---

diff -u -p a/fs/ocfs2/localalloc.c b/fs/ocfs2/localalloc.c
--- a/fs/ocfs2/localalloc.c
+++ b/fs/ocfs2/localalloc.c
@@ -434,12 +434,11 @@ void ocfs2_shutdown_local_alloc(struct o
 	bh = osb->local_alloc_bh;
 	alloc = (struct ocfs2_dinode *) bh->b_data;
 
-	alloc_copy = kmalloc(bh->b_size, GFP_NOFS);
+	alloc_copy = kmemdup(alloc, bh->b_size, GFP_NOFS);
 	if (!alloc_copy) {
 		status = -ENOMEM;
 		goto out_commit;
 	}
-	memcpy(alloc_copy, alloc, bh->b_size);
 
 	status = ocfs2_journal_access_di(handle, INODE_CACHE(local_alloc_inode),
 					 bh, OCFS2_JOURNAL_ACCESS_WRITE);
@@ -1244,13 +1243,12 @@ static int ocfs2_local_alloc_slide_windo
 	 * local alloc shutdown won't try to double free main bitmap
 	 * bits. Make a copy so the sync function knows which bits to
 	 * free. */
-	alloc_copy = kmalloc(osb->local_alloc_bh->b_size, GFP_NOFS);
+	alloc_copy = kmemdup(alloc, osb->local_alloc_bh->b_size, GFP_NOFS);
 	if (!alloc_copy) {
 		status = -ENOMEM;
 		mlog_errno(status);
 		goto bail;
 	}
-	memcpy(alloc_copy, alloc, osb->local_alloc_bh->b_size);
 
 	status = ocfs2_journal_access_di(handle,
 					 INODE_CACHE(local_alloc_inode),


