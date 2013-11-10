Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752127Ab3KJQ6v (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Nov 2013 11:58:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:19725 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751947Ab3KJQ6t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Nov 2013 11:58:49 -0500
Date: Sun, 10 Nov 2013 18:00:13 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Eilon Greenstein <eilong@broadcom.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] debugfs: use list_next_entry() in
	debugfs_remove_recursive()
Message-ID: <20131110170013.GA321@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131110165947.GA32758@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change debugfs_remove_recursive() to use list_next_entry(child),
no changes in generated code.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 fs/debugfs/inode.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/fs/debugfs/inode.c b/fs/debugfs/inode.c
index c7c83ff..9c0444c 100644
--- a/fs/debugfs/inode.c
+++ b/fs/debugfs/inode.c
@@ -566,8 +566,7 @@ void debugfs_remove_recursive(struct dentry *dentry)
 	mutex_lock(&parent->d_inode->i_mutex);
 
 	if (child != dentry) {
-		next = list_entry(child->d_u.d_child.next, struct dentry,
-					d_u.d_child);
+		next = list_next_entry(child, d_u.d_child);
 		goto up;
 	}
 
-- 
1.5.5.1

