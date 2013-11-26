Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754386Ab3KZIu4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 03:50:56 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:33076 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753498Ab3KZIuv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 03:50:51 -0500
X-IronPort-AV: E=Sophos;i="4.93,773,1378828800"; 
   d="scan'208";a="9128249"
Message-ID: <52945F60.4070005@cn.fujitsu.com>
Date: Tue, 26 Nov 2013 16:44:16 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Kim <jaegeuk.kim@samsung.com>
CC: f2fs <linux-f2fs-devel@lists.sourceforge.net>,
        fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [f2fs-dev][PATCH] f2fs: fix a potential out of range issue
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/11/26 16:48:43,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/11/26 16:48:44,
	Serialize complete at 2013/11/26 16:48:44
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a potential out of range issue introduced by commit:
22fb72225a
f2fs: simplify write_orphan_inodes for better readable



Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
---
 fs/f2fs/checkpoint.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c
index 7fe69ff..3e62987 100644
--- a/fs/f2fs/checkpoint.c
+++ b/fs/f2fs/checkpoint.c
@@ -323,9 +323,9 @@ static void write_orphan_inodes(struct f2fs_sb_info *sbi, block_t start_blk)
 			memset(orphan_blk, 0, sizeof(*orphan_blk));
 		}
 
-		orphan_blk->ino[nentries] = cpu_to_le32(orphan->ino);
+		orphan_blk->ino[nentries++] = cpu_to_le32(orphan->ino);
 
-		if (nentries++ == F2FS_ORPHANS_PER_BLOCK) {
+		if (nentries == F2FS_ORPHANS_PER_BLOCK) {
 			/*
 			 * an orphan block is full of 1020 entries,
 			 * then we need to flush current orphan blocks
-- 
1.7.7

