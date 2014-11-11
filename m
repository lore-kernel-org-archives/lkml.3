Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754725AbaKKLQA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 06:16:00 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57917 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754523AbaKKLLf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 06:11:35 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>,
        "Theodore Ts'o" <tytso@mit.edu>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 159/170] ext4: enable journal checksum when metadata checksum feature enabled
Date: Tue, 11 Nov 2014 11:08:38 +0000
Message-Id: <1415704129-12709-160-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
References: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Darrick J. Wong" <darrick.wong@oracle.com>

commit 98c1a7593fa355fda7f5a5940c8bf5326ca964ba upstream.

If metadata checksumming is turned on for the FS, we need to tell the
journal to use checksumming too.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/ext4/super.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index a6c188bb5265..447ccd4af707 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -3502,6 +3502,10 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 #ifdef CONFIG_EXT4_FS_POSIX_ACL
 	set_opt(sb, POSIX_ACL);
 #endif
+	/* don't forget to enable journal_csum when metadata_csum is enabled. */
+	if (ext4_has_metadata_csum(sb))
+		set_opt(sb, JOURNAL_CHECKSUM);
+
 	if ((def_mount_opts & EXT4_DEFM_JMODE) == EXT4_DEFM_JMODE_DATA)
 		set_opt(sb, JOURNAL_DATA);
 	else if ((def_mount_opts & EXT4_DEFM_JMODE) == EXT4_DEFM_JMODE_ORDERED)
-- 
2.1.0

