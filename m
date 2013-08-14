Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759927Ab3HNM0D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 08:26:03 -0400
Received: from mail-vb0-f50.google.com ([209.85.212.50]:53408 "EHLO
	mail-vb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759902Ab3HNMZ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 08:25:59 -0400
From: Jeff Layton <jlayton@redhat.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH 3/3] locks: add __acquires and __releases annotations to locks_start and locks_stop
Date: Wed, 14 Aug 2013 08:25:49 -0400
Message-Id: <1376483149-7633-4-git-send-email-jlayton@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1376483149-7633-1-git-send-email-jlayton@redhat.com>
References: <1376483149-7633-1-git-send-email-jlayton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

...to make sparse happy.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/locks.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/locks.c b/fs/locks.c
index b1e5bfe..b1e321e 100644
--- a/fs/locks.c
+++ b/fs/locks.c
@@ -2390,6 +2390,7 @@ static int locks_show(struct seq_file *f, void *v)
 }
 
 static void *locks_start(struct seq_file *f, loff_t *pos)
+	__acquires(&blocked_lock_lock)
 {
 	struct locks_iterator *iter = f->private;
 
@@ -2408,6 +2409,7 @@ static void *locks_next(struct seq_file *f, void *v, loff_t *pos)
 }
 
 static void locks_stop(struct seq_file *f, void *v)
+	__releases(&blocked_lock_lock)
 {
 	spin_unlock(&blocked_lock_lock);
 	lg_global_unlock(&file_lock_lglock);
-- 
1.8.3.1

