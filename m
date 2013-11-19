Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752037Ab3KSKJw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 05:09:52 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:60893 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751628Ab3KSKJu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 05:09:50 -0500
X-IronPort-AV: E=Sophos;i="4.93,728,1378828800"; 
   d="scan'208";a="9074460"
Message-ID: <528B376F.7080105@cn.fujitsu.com>
Date: Tue, 19 Nov 2013 18:03:27 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Kim <jaegeuk.kim@samsung.com>
CC: f2fs <linux-f2fs-devel@lists.sourceforge.net>,
        fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/5] f2fs: convert dev_valid_block_count to void
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/11/19 18:07:51,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/11/19 18:07:55,
	Serialize complete at 2013/11/19 18:07:55
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
---
 fs/f2fs/f2fs.h |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 94fbec3..d0c6738 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -585,7 +585,7 @@ static inline bool inc_valid_block_count(struct f2fs_sb_info *sbi,
 	return true;
 }
 
-static inline int dec_valid_block_count(struct f2fs_sb_info *sbi,
+static inline void dec_valid_block_count(struct f2fs_sb_info *sbi,
 						struct inode *inode,
 						blkcnt_t count)
 {
@@ -595,7 +595,6 @@ static inline int dec_valid_block_count(struct f2fs_sb_info *sbi,
 	inode->i_blocks -= count;
 	sbi->total_valid_block_count -= (block_t)count;
 	spin_unlock(&sbi->stat_lock);
-	return 0;
 }
 
 static inline void inc_page_count(struct f2fs_sb_info *sbi, int count_type)
-- 
1.7.7

