Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761527AbbA1ETS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 23:19:18 -0500
Received: from mail.kernel.org ([198.145.29.136]:38745 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759882AbbA1ETO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 23:19:14 -0500
From: lizf@kernel.org
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Jan Kara <jack@suse.cz>,
        "Theodore Ts'o" <tytso@mit.edu>, Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 060/177] ext4: don't check quota format when there are no quota files
Date: Wed, 28 Jan 2015 12:08:07 +0800
Message-Id: <1422418236-12852-120-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422418050-12581-1-git-send-email-lizf@kernel.org>
References: <1422418050-12581-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Kara <jack@suse.cz>

3.4.106-rc1 review patch.  If anyone has any objections, please let me know.

------------------


commit 279bf6d390933d5353ab298fcc306c391a961469 upstream.

The check whether quota format is set even though there are no
quota files with journalled quota is pointless and it actually
makes it impossible to turn off journalled quotas (as there's
no way to unset journalled quota format). Just remove the check.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 fs/ext4/super.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index f0e4e46..481f924 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1642,13 +1642,6 @@ static int parse_options(char *options, struct super_block *sb,
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

