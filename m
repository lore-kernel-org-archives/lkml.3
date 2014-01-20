Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752541AbaATAyx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jan 2014 19:54:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56084 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752245AbaATAyv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jan 2014 19:54:51 -0500
From: Dave Airlie <airlied@redhat.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Dave Airlie <airlied@redhat.com>
Subject: [PATCH] fs: export simple_dname for drm drivers.
Date: Mon, 20 Jan 2014 10:54:44 +1000
Message-Id: <1390179284-4824-1-git-send-email-airlied@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Herrmann's changes to use a pseudo filesystem for drm's shared
inodes requires this be exported for drm to build as a module.

I'd like to merge this via the drm tree, so please ack.

Signed-off-by: Dave Airlie <airlied@redhat.com>
---
 fs/dcache.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/dcache.c b/fs/dcache.c
index 6055d61..27d66b8 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -3107,6 +3107,7 @@ char *simple_dname(struct dentry *dentry, char *buffer, int buflen)
 		end = ERR_PTR(-ENAMETOOLONG);
 	return end;
 }
+EXPORT_SYMBOL(simple_dname);
 
 /*
  * Write full pathname from the root of the filesystem into the buffer.
-- 
1.8.4.2

