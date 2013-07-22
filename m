Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751955Ab3GVW1l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 18:27:41 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:45088 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751214Ab3GVW1j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 18:27:39 -0400
From: "=?UTF-8?q?J=C3=B3hann=20B=2E=20Gu=C3=B0mundsson?=" 
	<johannbg@gmail.com>
To: Theodore Tso <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-ext4@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        =?UTF-8?q?J=C3=B3hann=20B=2E=20Gu=C3=B0mundsson?= 
	<johannbg@fedoraproject.org>
Subject: [PATCH 1/1] ext4: Fix Opts: (null)
Date: Mon, 22 Jul 2013 22:24:28 +0000
Message-Id: <1374531868-1800-1-git-send-email-johannbg@fedoraproject.org>
X-Mailer: git-send-email 1.8.1.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

null null null no more Opts: (null) but something that actually makes sense to
human beings...

Signed-off-by: Jóhann B. Guðmundsson <johannbg@fedoraproject.org>
---
 fs/ext4/super.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 85b3dd6..ef141b7 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -4088,8 +4088,8 @@ no_journal:
 				 "the device does not support discard");
 	}
 
-	ext4_msg(sb, KERN_INFO, "mounted filesystem with%s. "
-		 "Opts: %s%s%s", descr, sbi->s_es->s_mount_opts,
+	ext4_msg(sb, KERN_INFO, "mounted filesystem with%s "
+		 "%s%s%s mount option(s)", descr, sbi->s_es->s_mount_opts,
 		 *sbi->s_es->s_mount_opts ? "; " : "", orig_data);
 
 	if (es->s_error_count)
@@ -4866,7 +4866,7 @@ static int ext4_remount(struct super_block *sb, int *flags, char *data)
 	}
 #endif
 
-	ext4_msg(sb, KERN_INFO, "re-mounted. Opts: %s", orig_data);
+	ext4_msg(sb, KERN_INFO, "re-mounted %s mount option(s)", orig_data);
 	kfree(orig_data);
 	return 0;
 
-- 
1.8.1.4

