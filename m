Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755573AbaKRO3v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 09:29:51 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57041 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755123AbaKROKR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 09:10:17 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Jan Kara <jack@suse.cz>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 181/206] ext3: Don't check quota format when there are no quota files
Date: Tue, 18 Nov 2014 15:08:56 +0100
Message-Id: <5cc34e7c722026c0460c003aed940713e726c03c.1416319692.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
References: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
In-Reply-To: <cover.1416319692.git.jslaby@suse.cz>
References: <cover.1416319692.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Kara <jack@suse.cz>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 7938db449bbc55bbeb164bec7af406212e7e98f1 upstream.

The check whether quota format is set even though there are no
quota files with journalled quota is pointless and it actually
makes it impossible to turn off journalled quotas (as there's
no way to unset journalled quota format). Just remove the check.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 fs/ext3/super.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/fs/ext3/super.c b/fs/ext3/super.c
index c50c76190373..03fd6bce713b 100644
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
2.1.3

