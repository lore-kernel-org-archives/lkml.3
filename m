Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756008Ab3JCGSj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 02:18:39 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:41552 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753958Ab3JCGSh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 02:18:37 -0400
Date: Thu, 03 Oct 2013 07:18:36 +0100
To: torvalds@linux-foundation.org
Subject: [PATCH 07/17] finish_automount() doesn't need vfsmount_lock for
 removal from expiry list
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
User-Agent: Heirloom mailx 12.5 7/5/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <E1VRcFA-00089O-9l@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/namespace.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index 8ea6676..2632998 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -2064,9 +2064,7 @@ fail:
 	/* remove m from any expiration list it may be on */
 	if (!list_empty(&mnt->mnt_expire)) {
 		namespace_lock();
-		br_write_lock(&vfsmount_lock);
 		list_del_init(&mnt->mnt_expire);
-		br_write_unlock(&vfsmount_lock);
 		namespace_unlock();
 	}
 	mntput(m);
-- 
1.7.2.5


