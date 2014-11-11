Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752471AbaKKLjM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 06:39:12 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57619 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754159AbaKKLKk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 06:10:40 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jan Kara <jack@suse.cz>, Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 104/170] ext3: Don't check quota format when there are no quota files
Date: Tue, 11 Nov 2014 11:07:43 +0000
Message-Id: <1415704129-12709-105-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
References: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

commit 7938db449bbc55bbeb164bec7af406212e7e98f1 upstream.

The check whether quota format is set even though there are no
quota files with journalled quota is pointless and it actually
makes it impossible to turn off journalled quotas (as there's
no way to unset journalled quota format). Just remove the check.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/ext3/super.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/fs/ext3/super.c b/fs/ext3/super.c
index 08cdfe5461e3..a2e09d4c7700 100644
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
2.1.0

