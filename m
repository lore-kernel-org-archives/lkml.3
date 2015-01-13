Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752780AbbAMWQP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 17:16:15 -0500
Received: from mail.sigma-star.at ([95.130.255.111]:14385 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751233AbbAMWQO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 17:16:14 -0500
From: Richard Weinberger <richard@nod.at>
To: user-mode-linux-devel@lists.sourceforge.net
Cc: dxld@darkboxed.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Richard Weinberger <richard@nod.at>,
        stable@vger.kernel.org
Subject: [PATCH] hostfs: Use noop_fsync for directories
Date: Tue, 13 Jan 2015 23:15:58 +0100
Message-Id: <1421187358-32600-1-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.8.4.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel reported that dpkg(1) dies if the root filesystem is a hostfs
because it does not expect fsync(2) to fail with EINVAL on directories.
While fsync(2) is allowed to fail with EINVAL if the filesystem does not
support it we can do better and use noop_fsync() to not confuse userspace
further.

Cc: stable@vger.kernel.org
Reported-and-tested-by: Daniel Gröber <dxld@darkboxed.org>
Signed-off-by: Richard Weinberger <richard@nod.at>
---
 fs/hostfs/hostfs_kern.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/hostfs/hostfs_kern.c b/fs/hostfs/hostfs_kern.c
index fd62cae..a7ac856 100644
--- a/fs/hostfs/hostfs_kern.c
+++ b/fs/hostfs/hostfs_kern.c
@@ -393,6 +393,7 @@ static const struct file_operations hostfs_dir_fops = {
 	.llseek		= generic_file_llseek,
 	.iterate	= hostfs_readdir,
 	.read		= generic_read_dir,
+	.fsync		= noop_fsync,
 };
 
 static int hostfs_writepage(struct page *page, struct writeback_control *wbc)
-- 
1.8.4.5

