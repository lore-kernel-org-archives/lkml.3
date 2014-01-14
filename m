Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752185AbaANTLt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 14:11:49 -0500
Received: from mail-qe0-f54.google.com ([209.85.128.54]:36501 "EHLO
	mail-qe0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751690AbaANTHN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 14:07:13 -0500
From: Jeff Layton <jlayton@redhat.com>
To: linux-fsdevel@vger.kernel.org
Cc: nfs-ganesha-devel@lists.sourceforge.net, samba-technical@lists.samba.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v6 04/14] locks: add __acquires and __releases annotations to locks_start and locks_stop
Date: Tue, 14 Jan 2014 14:06:44 -0500
Message-Id: <1389726414-30990-5-git-send-email-jlayton@redhat.com>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1389726414-30990-1-git-send-email-jlayton@redhat.com>
References: <1389726414-30990-1-git-send-email-jlayton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

...to make sparse happy.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/locks.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/locks.c b/fs/locks.c
index 049a144..6084f5a 100644
--- a/fs/locks.c
+++ b/fs/locks.c
@@ -2430,6 +2430,7 @@ static int locks_show(struct seq_file *f, void *v)
 }
 
 static void *locks_start(struct seq_file *f, loff_t *pos)
+	__acquires(&blocked_lock_lock)
 {
 	struct locks_iterator *iter = f->private;
 
@@ -2448,6 +2449,7 @@ static void *locks_next(struct seq_file *f, void *v, loff_t *pos)
 }
 
 static void locks_stop(struct seq_file *f, void *v)
+	__releases(&blocked_lock_lock)
 {
 	spin_unlock(&blocked_lock_lock);
 	lg_global_unlock(&file_lock_lglock);
-- 
1.8.4.2

