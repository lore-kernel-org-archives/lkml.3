Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933751AbaEMKL7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 06:11:59 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:33415 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933699AbaEMKLz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 06:11:55 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 119/182] ext4: use i_size_read in ext4_unaligned_aio()
Date: Tue, 13 May 2014 11:27:51 +0200
Message-Id: <9505d50f2bc90559fce9a74188f1bfcd1394f38f.1399973152.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
References: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
In-Reply-To: <cover.1399973152.git.jslaby@suse.cz>
References: <cover.1399973152.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Theodore Ts'o <tytso@mit.edu>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 6e6358fc3c3c862bfe9a5bc029d3f8ce43dc9765 upstream.

We haven't taken i_mutex yet, so we need to use i_size_read().

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 fs/ext4/file.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index 3da21945ff1f..1b890101397b 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -82,7 +82,7 @@ ext4_unaligned_aio(struct inode *inode, const struct iovec *iov,
 	size_t count = iov_length(iov, nr_segs);
 	loff_t final_size = pos + count;
 
-	if (pos >= inode->i_size)
+	if (pos >= i_size_read(inode))
 		return 0;
 
 	if ((pos & blockmask) || (final_size & blockmask))
-- 
1.9.3

