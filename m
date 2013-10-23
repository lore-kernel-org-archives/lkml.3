Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751911Ab3JWINU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 04:13:20 -0400
Received: from teakhout.nixpanic.net ([83.161.152.167]:34052 "EHLO
	ndevos-laptop.usersys.redhat.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751504Ab3JWINS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 04:13:18 -0400
X-Greylist: delayed 540 seconds by postgrey-1.27 at vger.kernel.org; Wed, 23 Oct 2013 04:13:18 EDT
From: Niels de Vos <ndevos@redhat.com>
To: trivial@kernel.org, linux-kernel@vger.kernel.org
Cc: Al Viro <viro@zeniv.linux.org.uk>, Niels de Vos <ndevos@redhat.com>
Subject: [TRIVIAL PATCH] exportfs: use dprintk() for debug message
Date: Wed, 23 Oct 2013 10:04:08 +0200
Message-Id: <1382515448-22202-1-git-send-email-ndevos@redhat.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All of the debug messages in reconnect_path() use dprintk(), except for
one. Users have no idea what "reconnect_path: npd != pd" means, or how
to act on it. This message without the other dprintk() output is near to
useless anyway, so use dprintk() instead of printk() for it.

Signed-off-by: Niels de Vos <ndevos@redhat.com>
---
 fs/exportfs/expfs.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/exportfs/expfs.c b/fs/exportfs/expfs.c
index a235f00..49ce614 100644
--- a/fs/exportfs/expfs.c
+++ b/fs/exportfs/expfs.c
@@ -189,7 +189,7 @@ reconnect_path(struct vfsmount *mnt, struct dentry *target_dir, char *nbuf)
 			if (npd == pd)
 				noprogress = 0;
 			else
-				printk("%s: npd != pd\n", __func__);
+				dprintk("%s: npd != pd\n", __func__);
 			dput(npd);
 			dput(ppd);
 			if (IS_ROOT(pd)) {
-- 
1.7.1

