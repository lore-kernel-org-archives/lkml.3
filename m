Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752317AbaFFJcC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 05:32:02 -0400
Received: from mail-ig0-f182.google.com ([209.85.213.182]:60120 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750853AbaFFJb7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 05:31:59 -0400
From: chishanmingshen <chishanmingshen@gmail.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        chishanmingshen <chishanmingshen@gmail.com>
Subject: [RFC 1/1] vfs: del redundant BH_new flag on unrelated buffer heads.
Date: Fri,  6 Jun 2014 17:31:24 +0800
Message-Id: <1402047084-3844-1-git-send-email-chishanmingshen@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just skip the unrelated buffer heads when clear buffer head's BH_new flag.
This patch is *untested*.

Signed-off-by: chishanmingshen <chishanmingshen@gmail.com>
---
 fs/buffer.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index 9ddb9fc..a28a1a1 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -1987,8 +1987,8 @@ static int __block_commit_write(struct inode *inode, struct page *page,
 		} else {
 			set_buffer_uptodate(bh);
 			mark_buffer_dirty(bh);
+			clear_buffer_new(bh);
 		}
-		clear_buffer_new(bh);
 
 		block_start = block_end;
 		bh = bh->b_this_page;
-- 
1.7.9.5

