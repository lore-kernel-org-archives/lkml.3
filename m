Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755659Ab3JCGRj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 02:17:39 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:41540 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754245Ab3JCGRh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 02:17:37 -0400
Date: Thu, 03 Oct 2013 07:17:36 +0100
To: torvalds@linux-foundation.org
Subject: [PATCH 01/17] initialize namespace_sem statically
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
User-Agent: Heirloom mailx 12.5 7/5/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <E1VRcEC-00086h-7R@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/namespace.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index da5c494..6d73d3a 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -39,7 +39,7 @@ static int mnt_group_start = 1;
 static struct list_head *mount_hashtable __read_mostly;
 static struct list_head *mountpoint_hashtable __read_mostly;
 static struct kmem_cache *mnt_cache __read_mostly;
-static struct rw_semaphore namespace_sem;
+static DECLARE_RWSEM(namespace_sem);
 
 /* /sys/fs */
 struct kobject *fs_kobj;
@@ -2767,8 +2767,6 @@ void __init mnt_init(void)
 	unsigned u;
 	int err;
 
-	init_rwsem(&namespace_sem);
-
 	mnt_cache = kmem_cache_create("mnt_cache", sizeof(struct mount),
 			0, SLAB_HWCACHE_ALIGN | SLAB_PANIC, NULL);
 
-- 
1.7.2.5


