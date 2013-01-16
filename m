Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933123Ab3APQLj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 11:11:39 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:36955 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932622Ab3APQLf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 11:11:35 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Guo Chao <yan@linux.vnet.ibm.com>, "Theodore Ts'o" <tytso@mit.edu>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 216/222] ext4: release buffer in failed path in dx_probe()
Date: Wed, 16 Jan 2013 13:56:56 -0200
Message-Id: <1358351822-7675-217-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guo Chao <yan@linux.vnet.ibm.com>

commit 0ecaef0644973e9006fdbc6974301047aaff9bc6 upstream.

If checksum fails, we should also release the buffer
read from previous iteration.

Signed-off-by: Guo Chao <yan@linux.vnet.ibm.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>-
--
 fs/ext4/namei.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 fs/ext4/namei.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index ad6767e..20c13eb 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -706,7 +706,7 @@ dx_probe(const struct qstr *d_name, struct inode *dir,
 			ext4_warning(dir->i_sb, "Node failed checksum");
 			brelse(bh);
 			*err = ERR_BAD_DX_DIR;
-			goto fail;
+			goto fail2;
 		}
 		set_buffer_verified(bh);
 
-- 
1.7.9.5

