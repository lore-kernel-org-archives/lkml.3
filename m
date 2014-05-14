Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752481AbaENVfS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 17:35:18 -0400
Received: from mail-oa0-f47.google.com ([209.85.219.47]:51019 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751243AbaENVfO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 17:35:14 -0400
From: Seth Forshee <seth.forshee@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jens Axboe <axboe@kernel.dk>, Arnd Bergmann <arnd@arndb.de>,
        Eric Biederman <ebiederm@xmission.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        lxc-devel@lists.linuxcontainers.org,
        Seth Forshee <seth.forshee@canonical.com>
Subject: [RFC PATCH 03/11] tmpfs: Add sub-filesystem data pointer to shmem_sb_info
Date: Wed, 14 May 2014 16:34:51 -0500
Message-Id: <1400103299-144589-4-git-send-email-seth.forshee@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1400103299-144589-1-git-send-email-seth.forshee@canonical.com>
References: <1400103299-144589-1-git-send-email-seth.forshee@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

devtmpfs is built on top of tmpfs but also needs to store some
data of its own. Add a sub_fs_data pointer to
struct shmem_sb_info for this purpose.

Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
---
 include/linux/shmem_fs.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/shmem_fs.h b/include/linux/shmem_fs.h
index 4d1771c2d29f..7e2c33a0c73a 100644
--- a/include/linux/shmem_fs.h
+++ b/include/linux/shmem_fs.h
@@ -33,6 +33,7 @@ struct shmem_sb_info {
 	kgid_t gid;		    /* Mount gid for root directory */
 	umode_t mode;		    /* Mount mode for root directory */
 	struct mempolicy *mpol;     /* default memory policy for mappings */
+	void *sub_fs_data;	    /* data for other shmem-based fses */
 };
 
 static inline struct shmem_inode_info *SHMEM_I(struct inode *inode)
-- 
1.9.1

