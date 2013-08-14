Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932730Ab3HNKlZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 06:41:25 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:34720 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932443Ab3HNKib (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 06:38:31 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "Theodore Ts'o" <tytso@mit.edu>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 70/75] ext4: allow the mount options nodelalloc and data=journal
Date: Wed, 14 Aug 2013 11:36:59 +0100
Message-Id: <1376476624-10011-71-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1376476624-10011-1-git-send-email-luis.henriques@canonical.com>
References: <1376476624-10011-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.19 -stable review patch.  If anyone has any objections, please let me know.

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
[ luis: backported to 3.5: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/ext4/super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 0689c5d..92b883a 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1435,7 +1435,7 @@ static const struct mount_opts {
 	{Opt_discard, EXT4_MOUNT_DISCARD, MOPT_SET},
 	{Opt_nodiscard, EXT4_MOUNT_DISCARD, MOPT_CLEAR},
 	{Opt_delalloc, EXT4_MOUNT_DELALLOC, MOPT_SET | MOPT_EXPLICIT},
-	{Opt_nodelalloc, EXT4_MOUNT_DELALLOC, MOPT_CLEAR | MOPT_EXPLICIT},
+	{Opt_nodelalloc, EXT4_MOUNT_DELALLOC, MOPT_CLEAR},
 	{Opt_journal_checksum, EXT4_MOUNT_JOURNAL_CHECKSUM, MOPT_SET},
 	{Opt_journal_async_commit, (EXT4_MOUNT_JOURNAL_ASYNC_COMMIT |
 				    EXT4_MOUNT_JOURNAL_CHECKSUM), MOPT_SET},
-- 
1.8.3.2

