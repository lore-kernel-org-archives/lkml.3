Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757913Ab3JKMZq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 08:25:46 -0400
Received: from mail-qc0-f179.google.com ([209.85.216.179]:51562 "EHLO
	mail-qc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757727Ab3JKMZc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 08:25:32 -0400
From: Jeff Layton <jlayton@redhat.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, nfs-ganesha-devel@lists.sourceforge.net,
        samba-technical@lists.samba.org
Subject: [RFC PATCH 5/5] locks: show private lock types in /proc/locks
Date: Fri, 11 Oct 2013 08:25:22 -0400
Message-Id: <1381494322-2426-6-git-send-email-jlayton@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1381494322-2426-1-git-send-email-jlayton@redhat.com>
References: <1381494322-2426-1-git-send-email-jlayton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Show "private" locks in /proc/locks with a 'P' suffix.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/locks.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/locks.c b/fs/locks.c
index 3bde157..31abb70 100644
--- a/fs/locks.c
+++ b/fs/locks.c
@@ -2393,8 +2393,8 @@ static void lock_get_status(struct seq_file *f, struct file_lock *fl,
 	} else {
 		seq_printf(f, "%s ",
 			       (lease_breaking(fl))
-			       ? (fl->fl_type == F_UNLCK) ? "UNLCK" : "READ "
-			       : (fl->fl_type == F_WRLCK) ? "WRITE" : "READ ");
+			       ? (fl->fl_type == F_UNLCK) ? "UNLCK " : (IS_PRIVATE(fl) ? "READP " : "READ  ")
+			       : (fl->fl_type == F_WRLCK) ?  (IS_PRIVATE(fl) ? "WRITEP" : "WRITE ") : IS_PRIVATE(fl) ? "READP " : "READ  ");
 	}
 	if (inode) {
 #ifdef WE_CAN_BREAK_LSLK_NOW
-- 
1.8.3.1

