Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751770AbaKFWi2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 17:38:28 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58478 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751660AbaKFWiS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 17:38:18 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jan Kara <jack@suse.cz>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 116/162] ext3: Don't check quota format when there are no quota files
Date: Thu,  6 Nov 2014 14:36:20 -0800
Message-Id: <1415313426-9622-117-git-send-email-kamal@canonical.com>
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

commit 7938db449bbc55bbeb164bec7af406212e7e98f1 upstream.

The check whether quota format is set even though there are no
quota files with journalled quota is pointless and it actually
makes it impossible to turn off journalled quotas (as there's
no way to unset journalled quota format). Just remove the check.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 fs/ext3/super.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/fs/ext3/super.c b/fs/ext3/super.c
index 37fd31e..0498390 100644
--- a/fs/ext3/super.c
+++ b/fs/ext3/super.c
@@ -1354,13 +1354,6 @@ set_qf_format:
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

