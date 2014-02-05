Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753339AbaBEXZH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 18:25:07 -0500
Received: from mail-pb0-f44.google.com ([209.85.160.44]:54296 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752026AbaBEXZD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 18:25:03 -0500
Message-ID: <52F2C849.20903@gmail.com>
Date: Wed, 05 Feb 2014 15:24:57 -0800
From: Rajat Jain <rajatxjain@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Miklos Szeredi <miklos@szeredi.hu>, fuse-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
Subject: [PATCH] fs/fuse/file.c: fix "uninitialized variable" warning
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the following warning by initializing the parent to NULL:

In file included from include/linux/fs.h:16:0,
                 from fs/fuse/fuse_i.h:13,
                 from fs/fuse/file.c:9:
fs/fuse/file.c: In function 'fuse_file_poll':
include/linux/rbtree.h:82:28: warning: 'parent' may be used
uninitialized in this function [-Wmaybe-uninitialized]
fs/fuse/file.c:2592:27: note: 'parent' was declared here

Signed-off-by: Rajat Jain <rajatxjain@gmail.com>
---
 fs/fuse/file.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 77bcc30..2f8783d 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -2606,7 +2606,7 @@ static void fuse_register_polled_file(struct fuse_conn *fc,
 {
 	spin_lock(&fc->lock);
 	if (RB_EMPTY_NODE(&ff->polled_node)) {
-		struct rb_node **link, *parent;
+		struct rb_node **link, *parent = NULL;
 
 		link = fuse_find_polled_node(fc, ff->kh, &parent);
 		BUG_ON(*link);
-- 
1.7.9.5

