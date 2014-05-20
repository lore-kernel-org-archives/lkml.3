Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754139AbaETOlV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 10:41:21 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:54254 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752582AbaETOlS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 10:41:18 -0400
Date: Tue, 20 May 2014 15:41:13 +0100
From: Giedrius Rekasius <giedrius.rekasius@gmail.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: [PATCH] ext4: remove unused local variable "store" from
 ext4_readdir(...)
Message-ID: <20140520144113.GB13333@vaio>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Giedrius Rekasius <giedrius.rekasius@gmail.com>

Remove unused local variable "store" from ext4_readdir(...)

Local variable "stored" is initialized however never used inside the function.

Signed-off-by: Giedrius Rekasius <giedrius.rekasius@gmail.com>
---
 fs/ext4/dir.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/ext4/dir.c b/fs/ext4/dir.c
index d638c57..ef1bed6 100644
--- a/fs/ext4/dir.c
+++ b/fs/ext4/dir.c
@@ -105,7 +105,7 @@ int __ext4_check_dir_entry(const char *function, u
 static int ext4_readdir(struct file *file, struct dir_context *ctx)
 {
        unsigned int offset;
-       int i, stored;
+       int i;
        struct ext4_dir_entry_2 *de;
        int err;
        struct inode *inode = file_inode(file);
@@ -133,7 +133,6 @@ static int ext4_readdir(struct file *file, struct
                        return ret;
        }

-       stored = 0;
        offset = ctx->pos & (sb->s_blocksize - 1);

        while (ctx->pos < inode->i_size) {

