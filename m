Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756235Ab3HPWin (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 18:38:43 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51523 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753619Ab3HPWik (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 18:38:40 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "Theodore Ts'o" <tytso@mit.edu>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 117/133] ext4: allow the mount options nodelalloc and data=journal
Date: Fri, 16 Aug 2013 15:34:19 -0700
Message-Id: <1376692475-28413-118-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1376692475-28413-1-git-send-email-kamal@canonical.com>
References: <1376692475-28413-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Theodore Ts'o <tytso@mit.edu>

commit 59d9fa5c2e9086db11aa287bb4030151d0095a17 upstream.

Commit 26092bf ("ext4: use a table-driven handler for mount options")
wrongly disallows the specifying the mount options nodelalloc and
data=journal simultaneously.  This is incorrect; it should have only
disallowed the combination of delalloc and data=journal
simultaneously.

Reported-by: Piotr Sarna <p.sarna@partner.samsung.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
[ kamal: backport to 3.8 (context) ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 fs/ext4/super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index d757050..1e4b5926 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1426,7 +1426,7 @@ static const struct mount_opts {
 	{Opt_discard, EXT4_MOUNT_DISCARD, MOPT_SET},
 	{Opt_nodiscard, EXT4_MOUNT_DISCARD, MOPT_CLEAR},
 	{Opt_delalloc, EXT4_MOUNT_DELALLOC, MOPT_SET | MOPT_EXPLICIT},
-	{Opt_nodelalloc, EXT4_MOUNT_DELALLOC, MOPT_CLEAR | MOPT_EXPLICIT},
+	{Opt_nodelalloc, EXT4_MOUNT_DELALLOC, MOPT_CLEAR},
 	{Opt_journal_checksum, EXT4_MOUNT_JOURNAL_CHECKSUM, MOPT_SET},
 	{Opt_journal_async_commit, (EXT4_MOUNT_JOURNAL_ASYNC_COMMIT |
 				    EXT4_MOUNT_JOURNAL_CHECKSUM), MOPT_SET},
-- 
1.8.1.2

