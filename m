Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755809Ab3JCGRt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 02:17:49 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:41543 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755675Ab3JCGRr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 02:17:47 -0400
Date: Thu, 03 Oct 2013 07:17:46 +0100
To: torvalds@linux-foundation.org
Subject: [PATCH 02/17] fs_is_visible only needs namespace_sem held shared
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
User-Agent: Heirloom mailx 12.5 7/5/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <E1VRcEM-000879-7k@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/namespace.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index 6d73d3a..f6b7010 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -2873,7 +2873,7 @@ bool fs_fully_visible(struct file_system_type *type)
 	if (unlikely(!ns))
 		return false;
 
-	namespace_lock();
+	down_read(&namespace_sem);
 	list_for_each_entry(mnt, &ns->list, mnt_list) {
 		struct mount *child;
 		if (mnt->mnt.mnt_sb->s_type != type)
@@ -2894,7 +2894,7 @@ bool fs_fully_visible(struct file_system_type *type)
 	next:	;
 	}
 found:
-	namespace_unlock();
+	up_read(&namespace_sem);
 	return visible;
 }
 
-- 
1.7.2.5


