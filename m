Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756041Ab3JCGSt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 02:18:49 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:41554 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754832Ab3JCGSr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 02:18:47 -0400
Date: Thu, 03 Oct 2013 07:18:46 +0100
To: torvalds@linux-foundation.org
Subject: [PATCH 08/17] mnt_set_expiry() doesn't need vfsmount_lock
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
User-Agent: Heirloom mailx 12.5 7/5/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <E1VRcFK-0008A0-A3@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


->mnt_expire is protected by namespace_sem

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/namespace.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index 2632998..d5cd086 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -2080,11 +2080,9 @@ fail:
 void mnt_set_expiry(struct vfsmount *mnt, struct list_head *expiry_list)
 {
 	namespace_lock();
-	br_write_lock(&vfsmount_lock);
 
 	list_add_tail(&real_mount(mnt)->mnt_expire, expiry_list);
 
-	br_write_unlock(&vfsmount_lock);
 	namespace_unlock();
 }
 EXPORT_SYMBOL(mnt_set_expiry);
-- 
1.7.2.5


