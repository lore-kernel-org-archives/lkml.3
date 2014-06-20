Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967116AbaFTUYR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 16:24:17 -0400
Received: from mailrelay005.isp.belgacom.be ([195.238.6.171]:55872 "EHLO
	mailrelay005.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965993AbaFTUYN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 16:24:13 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsHALuXpFNXQzOZ/2dsb2JhbABZgw2rRwUBAQEBAQEFAZkqgQ4XdYQxLyOBGjeILgMVAcNlFYZDF4ViiEMBAU8dhC0Ej22KV4swiCqDRDuBOg
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, Evgeniy Dushistov <dushistov@mail.ru>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5/5] FS/UFS: convert UFSD printk to pr_debug
Date: Fri, 20 Jun 2014 22:22:56 +0200
Message-Id: <1403295776-5006-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert no level printk to pr_debug in UFSD.
DEBUG is defined with CONFIG_UFS_DEBUG so pr_debug
are emitted here.

Also fixing call to UFSD (add;)

Cc: Evgeniy Dushistov <dushistov@mail.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/ufs/super.c | 2 +-
 fs/ufs/ufs.h   | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/ufs/super.c b/fs/ufs/super.c
index 206f7d6..da73801 100644
--- a/fs/ufs/super.c
+++ b/fs/ufs/super.c
@@ -868,7 +868,7 @@ static int ufs_fill_super(struct super_block *sb, void *data, int silent)
 		break;
 
 	case UFS_MOUNT_UFSTYPE_SUNOS:
-		UFSD(("ufstype=sunos\n"))
+		UFSD("ufstype=sunos\n");
 		uspi->s_fsize = block_size = 1024;
 		uspi->s_fmask = ~(1024 - 1);
 		uspi->s_fshift = 10;
diff --git a/fs/ufs/ufs.h b/fs/ufs/ufs.h
index cbe1e9b..2a07396 100644
--- a/fs/ufs/ufs.h
+++ b/fs/ufs/ufs.h
@@ -77,9 +77,9 @@ struct ufs_inode_info {
  */
 #ifdef CONFIG_UFS_DEBUG
 #	define UFSD(f, a...)	{					\
-		printk ("UFSD (%s, %d): %s:",				\
+		pr_debug("UFSD (%s, %d): %s:",				\
 			__FILE__, __LINE__, __func__);		\
-		printk (f, ## a);					\
+		pr_debug(f, ## a);					\
 	}
 #else
 #	define UFSD(f, a...)	/**/
-- 
1.8.4.5

