Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932651AbaEQMZi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2014 08:25:38 -0400
Received: from mout.gmx.net ([212.227.17.20]:60128 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756738AbaEQMZh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2014 08:25:37 -0400
From: =?UTF-8?q?Manuel=20Sch=C3=B6lling?= <manuel.schoelling@gmx.de>
To: anton@tuxera.com
Cc: linux-ntfs-dev@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Manuel=20Sch=C3=B6lling?= <manuel.schoelling@gmx.de>
Subject: [PATCH] ntfs: Cleanup string initializations (char[] instead of char *)
Date: Sat, 17 May 2014 14:25:22 +0200
Message-Id: <1400329522-17875-1-git-send-email-manuel.schoelling@gmx.de>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K0:+BBow0Q8dEtvp63tjjTq/XryAyZOI6RpzumX20PgSuKQiwOMW0i
 s+FHSmciAoNKnYBGjnAYjZgpqrxqcXm9AvJG21YU32LDUQPViKAoiefdiqzkKZazS8nZLB2
 446WLivcXW1i34FiljnWNMeSu/+1sryk0m3IrG2xEp2PQdDv1B0BbpwvFGJw/nlbpA0quo3
 cIpqUpw7J7AxWf3iP6o9A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Initializations like 'char *foo = "bar"' will create two variables: a static
string and a pointer (foo) to that static string. Instead 'char foo[] = "bar"'
will allocate only a declare a single variable and will end up in shorter
assembly (according to Jeff Garzik on the KernelJanitor's TODO list).

Signed-off-by: Manuel Schölling <manuel.schoelling@gmx.de>
---
 fs/ntfs/inode.c |    2 +-
 fs/ntfs/super.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ntfs/inode.c b/fs/ntfs/inode.c
index f47af5e..3975798 100644
--- a/fs/ntfs/inode.c
+++ b/fs/ntfs/inode.c
@@ -2368,7 +2368,7 @@ int ntfs_truncate(struct inode *vi)
 	ntfs_attr_search_ctx *ctx;
 	MFT_RECORD *m;
 	ATTR_RECORD *a;
-	const char *te = "  Leaving file length out of sync with i_size.";
+	const char te[] = "  Leaving file length out of sync with i_size.";
 	int err, mp_size, size_change, alloc_change;
 	u32 attr_len;
 
diff --git a/fs/ntfs/super.c b/fs/ntfs/super.c
index 9de2491..eb2c195 100644
--- a/fs/ntfs/super.c
+++ b/fs/ntfs/super.c
@@ -676,7 +676,7 @@ not_ntfs:
 static struct buffer_head *read_ntfs_boot_sector(struct super_block *sb,
 		const int silent)
 {
-	const char *read_err_str = "Unable to read %s boot sector.";
+	const char read_err_str[] = "Unable to read %s boot sector.";
 	struct buffer_head *bh_primary, *bh_backup;
 	sector_t nr_blocks = NTFS_SB(sb)->nr_blocks;
 
-- 
1.7.10.4

