Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755865Ab3JCGR6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 02:17:58 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:41544 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755782Ab3JCGR5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 02:17:57 -0400
Date: Thu, 03 Oct 2013 07:17:56 +0100
To: torvalds@linux-foundation.org
Subject: [PATCH 03/17] dup_mnt_ns(): get rid of pointless grabbing of
 vfsmount_lock
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
User-Agent: Heirloom mailx 12.5 7/5/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <E1VRcEW-00087S-7y@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


mnt_list is protected by namespace_sem, not vfsmount_lock

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/namespace.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index f6b7010..09a255d 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -2444,9 +2444,7 @@ static struct mnt_namespace *dup_mnt_ns(struct mnt_namespace *mnt_ns,
 		return ERR_CAST(new);
 	}
 	new_ns->root = new;
-	br_write_lock(&vfsmount_lock);
 	list_add_tail(&new_ns->list, &new->mnt_list);
-	br_write_unlock(&vfsmount_lock);
 
 	/*
 	 * Second pass: switch the tsk->fs->* elements and mark new vfsmounts
-- 
1.7.2.5


