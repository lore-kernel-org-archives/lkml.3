Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934698AbaKMVlK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 16:41:10 -0500
Received: from mail-wi0-f171.google.com ([209.85.212.171]:51012 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934154AbaKMV3x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 16:29:53 -0500
From: Pieter Smith <pieter@boesman.nl>
To: pieter@boesman.nl
Cc: Josh Triplett <josh@joshtriplett.org>,
        Steven Whitehouse <swhiteho@redhat.com>,
        cluster-devel@redhat.com (open list:GFS2 FILE SYSTEM),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 24/56] fs/gfs2: support compiling out splice
Date: Thu, 13 Nov 2014 22:23:01 +0100
Message-Id: <1415913813-362-25-git-send-email-pieter@boesman.nl>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415913813-362-1-git-send-email-pieter@boesman.nl>
References: <pieter@boesman.nl>
 <1415913813-362-1-git-send-email-pieter@boesman.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Compile out splice support from gfs2 when the splice-family of syscalls is not
supported by the system (i.e. CONFIG_SYSCALL_SPLICE is undefined).

Signed-off-by: Pieter Smith <pieter@boesman.nl>
---
 fs/gfs2/file.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/gfs2/file.c b/fs/gfs2/file.c
index 26b3f95..f7cb861 100644
--- a/fs/gfs2/file.c
+++ b/fs/gfs2/file.c
@@ -1067,8 +1067,8 @@ const struct file_operations gfs2_file_fops = {
 	.fsync		= gfs2_fsync,
 	.lock		= gfs2_lock,
 	.flock		= gfs2_flock,
-	.splice_read	= generic_file_splice_read,
-	.splice_write	= iter_file_splice_write,
+	SPLICE_READ_INIT(generic_file_splice_read)
+	SPLICE_WRITE_INIT(iter_file_splice_write)
 	.setlease	= gfs2_setlease,
 	.fallocate	= gfs2_fallocate,
 };
@@ -1097,8 +1097,8 @@ const struct file_operations gfs2_file_fops_nolock = {
 	.open		= gfs2_open,
 	.release	= gfs2_release,
 	.fsync		= gfs2_fsync,
-	.splice_read	= generic_file_splice_read,
-	.splice_write	= iter_file_splice_write,
+	SPLICE_READ_INIT(generic_file_splice_read)
+	SPLICE_WRITE_INIT(iter_file_splice_write)
 	.setlease	= generic_setlease,
 	.fallocate	= gfs2_fallocate,
 };
-- 
1.9.1

