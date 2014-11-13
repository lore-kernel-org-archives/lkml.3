Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965044AbaKMVn4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 16:43:56 -0500
Received: from mail-wi0-f177.google.com ([209.85.212.177]:36296 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934504AbaKMV3c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 16:29:32 -0500
From: Pieter Smith <pieter@boesman.nl>
To: pieter@boesman.nl
Cc: Josh Triplett <josh@joshtriplett.org>, Sage Weil <sage@inktank.com>,
        ceph-devel@vger.kernel.org (open list:CEPH DISTRIBUTED...),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 13/56] fs/ceph: support compiling out splice
Date: Thu, 13 Nov 2014 22:22:50 +0100
Message-Id: <1415913813-362-14-git-send-email-pieter@boesman.nl>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415913813-362-1-git-send-email-pieter@boesman.nl>
References: <pieter@boesman.nl>
 <1415913813-362-1-git-send-email-pieter@boesman.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Compile out splice support from ceph when the splice-family of syscalls is not
supported by the system (i.e. CONFIG_SYSCALL_SPLICE is undefined).

Signed-off-by: Pieter Smith <pieter@boesman.nl>
---
 fs/ceph/file.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index 2eb02f8..c85396a 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -1251,8 +1251,8 @@ const struct file_operations ceph_file_fops = {
 	.fsync = ceph_fsync,
 	.lock = ceph_lock,
 	.flock = ceph_flock,
-	.splice_read = generic_file_splice_read,
-	.splice_write = iter_file_splice_write,
+	SPLICE_READ_INIT(generic_file_splice_read)
+	SPLICE_WRITE_INIT(iter_file_splice_write)
 	.unlocked_ioctl = ceph_ioctl,
 	.compat_ioctl	= ceph_ioctl,
 	.fallocate	= ceph_fallocate,
-- 
1.9.1

