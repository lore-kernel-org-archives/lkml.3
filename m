Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933830AbaFQQQb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 12:16:31 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50463 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933535AbaFQQQ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 12:16:27 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "Theodore Ts'o" <tytso@mit.edu>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 027/121] ext4: use i_size_read in ext4_unaligned_aio()
Date: Tue, 17 Jun 2014 09:13:40 -0700
Message-Id: <1403021714-16320-28-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403021714-16320-1-git-send-email-kamal@canonical.com>
References: <1403021714-16320-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.24 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Theodore Ts'o <tytso@mit.edu>

commit 6e6358fc3c3c862bfe9a5bc029d3f8ce43dc9765 upstream.

We haven't taken i_mutex yet, so we need to use i_size_read().

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 fs/ext4/file.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index 216a633..7cf5b11 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -81,7 +81,7 @@ ext4_unaligned_aio(struct inode *inode, const struct iovec *iov,
 	size_t count = iov_length(iov, nr_segs);
 	loff_t final_size = pos + count;
 
-	if (pos >= inode->i_size)
+	if (pos >= i_size_read(inode))
 		return 0;
 
 	if ((pos & blockmask) || (final_size & blockmask))
-- 
1.9.1

