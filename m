Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753864AbaKFWzz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 17:55:55 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:59031 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753169AbaKFWnq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 17:43:46 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jan Kara <jack@suse.cz>, "Theodore Ts'o" <tytso@mit.edu>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 059/162] ext4: don't check quota format when there are no quota files
Date: Thu,  6 Nov 2014 14:35:23 -0800
Message-Id: <1415313426-9622-60-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415313426-9622-1-git-send-email-kamal@canonical.com>
References: <1415313426-9622-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

commit 279bf6d390933d5353ab298fcc306c391a961469 upstream.

The check whether quota format is set even though there are no
quota files with journalled quota is pointless and it actually
makes it impossible to turn off journalled quotas (as there's
no way to unset journalled quota format). Just remove the check.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 fs/ext4/super.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index a46030d..5ee03e5d 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1706,13 +1706,6 @@ static int parse_options(char *options, struct super_block *sb,
 					"not specified");
 			return 0;
 		}
-	} else {
-		if (sbi->s_jquota_fmt) {
-			ext4_msg(sb, KERN_ERR, "journaled quota format "
-					"specified with no journaling "
-					"enabled");
-			return 0;
-		}
 	}
 #endif
 	if (test_opt(sb, DIOREAD_NOLOCK)) {
-- 
1.9.1

