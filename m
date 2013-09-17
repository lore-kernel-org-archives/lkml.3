Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754100Ab3IQWpn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 18:45:43 -0400
Received: from shell.v3.sk ([195.168.3.45]:55958 "EHLO shell.v3.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753435Ab3IQWpl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 18:45:41 -0400
X-Greylist: delayed 373 seconds by postgrey-1.27 at vger.kernel.org; Tue, 17 Sep 2013 18:45:41 EDT
From: Lubomir Rintel <lkundrak@v3.sk>
To: linux-kernel@vger.kernel.org
Cc: Christoph Hellwig <hch@infradead.org>, Lubomir Rintel <lkundrak@v3.sk>
Subject: [PATCH] sysv: Add forgotten superblock lock init for v7 fs
Date: Wed, 18 Sep 2013 00:39:16 +0200
Message-Id: <1379457556-8902-1-git-send-email-lkundrak@v3.sk>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Superblock lock was replaced with (un)lock_super() removal, but left
uninitialized for Seventh Edition UNIX filesystem in the following commit (3.7):
c07cb01 sysv: drop lock/unlock super

Signed-off-by: Lubomir Rintel <lkundrak@v3.sk>
---
 fs/sysv/super.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/sysv/super.c b/fs/sysv/super.c
index d0c6a00..eda1095 100644
--- a/fs/sysv/super.c
+++ b/fs/sysv/super.c
@@ -487,6 +487,7 @@ static int v7_fill_super(struct super_block *sb, void *data, int silent)
 	sbi->s_sb = sb;
 	sbi->s_block_base = 0;
 	sbi->s_type = FSTYPE_V7;
+	mutex_init(&sbi->s_lock);
 	sb->s_fs_info = sbi;
 	
 	sb_set_blocksize(sb, 512);
-- 
1.7.1

