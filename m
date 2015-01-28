Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934663AbbA1EuG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 23:50:06 -0500
Received: from mail.kernel.org ([198.145.29.136]:40008 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759610AbbA1EWa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 23:22:30 -0500
From: lizf@kernel.org
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Jan Kara <jack@suse.cz>,
        Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 092/177] ext3: Don't check quota format when there are no quota files
Date: Wed, 28 Jan 2015 12:09:10 +0800
Message-Id: <1422418236-12852-183-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422418050-12581-1-git-send-email-lizf@kernel.org>
References: <1422418050-12581-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Kara <jack@suse.cz>

3.4.106-rc1 review patch.  If anyone has any objections, please let me know.

------------------


commit 7938db449bbc55bbeb164bec7af406212e7e98f1 upstream.

The check whether quota format is set even though there are no
quota files with journalled quota is pointless and it actually
makes it impossible to turn off journalled quotas (as there's
no way to unset journalled quota format). Just remove the check.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 fs/ext3/super.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/fs/ext3/super.c b/fs/ext3/super.c
index ef4c812..564f942 100644
--- a/fs/ext3/super.c
+++ b/fs/ext3/super.c
@@ -1292,13 +1292,6 @@ set_qf_format:
 					"not specified.");
 			return 0;
 		}
-	} else {
-		if (sbi->s_jquota_fmt) {
-			ext3_msg(sb, KERN_ERR, "error: journaled quota format "
-					"specified with no journaling "
-					"enabled.");
-			return 0;
-		}
 	}
 #endif
 	return 1;
-- 
1.9.1

