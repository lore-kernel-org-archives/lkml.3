Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966903AbaFTUXt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 16:23:49 -0400
Received: from mailrelay002.isp.belgacom.be ([195.238.6.175]:3526 "EHLO
	mailrelay002.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966819AbaFTUXr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 16:23:47 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsHAEGXpFNXQzOZ/2dsb2JhbABZgw2rRwUBAQEBAQEFAZkqgQ4XdYQxLyOBGjeILgMVAcNlFYZDF4ViiEMBAQFOHYQtBI9tileLMIgqg0Q7gTo
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, Evgeniy Dushistov <dushistov@mail.ru>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 3/5] fs/ufs/super.c: use __func__ in logging
Date: Fri, 20 Jun 2014 22:22:29 +0200
Message-Id: <1403295749-4898-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace approximate function name by __func__
using standard format "function():"

Cc: Evgeniy Dushistov <dushistov@mail.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/ufs/super.c | 36 ++++++++++++++++++------------------
 1 file changed, 18 insertions(+), 18 deletions(-)

diff --git a/fs/ufs/super.c b/fs/ufs/super.c
index cfa878e..ca24557 100644
--- a/fs/ufs/super.c
+++ b/fs/ufs/super.c
@@ -1030,7 +1030,7 @@ again:
 		goto again;
 	}
 	if (!silent)
-		pr_err("ufs_read_super: bad magic number\n");
+		pr_err("%s(): bad magic number\n", __func__);
 	goto failed;
 
 magic_found:
@@ -1044,33 +1044,33 @@ magic_found:
 	uspi->s_fshift = fs32_to_cpu(sb, usb1->fs_fshift);
 
 	if (!is_power_of_2(uspi->s_fsize)) {
-		pr_err("ufs_read_super: fragment size %u is not a power of 2\n",
-		       uspi->s_fsize);
+		pr_err("%s(): fragment size %u is not a power of 2\n",
+		       __func__, uspi->s_fsize);
 		goto failed;
 	}
 	if (uspi->s_fsize < 512) {
-		pr_err("ufs_read_super: fragment size %u is too small\n",
-		       uspi->s_fsize);
+		pr_err("%s(): fragment size %u is too small\n",
+		       __func__, uspi->s_fsize);
 		goto failed;
 	}
 	if (uspi->s_fsize > 4096) {
-		pr_err("ufs_read_super: fragment size %u is too large\n",
-		       uspi->s_fsize);
+		pr_err("%s(): fragment size %u is too large\n",
+		       __func__, uspi->s_fsize);
 		goto failed;
 	}
 	if (!is_power_of_2(uspi->s_bsize)) {
-		pr_err("ufs_read_super: block size %u is not a power of 2\n",
-		       uspi->s_bsize);
+		pr_err("%s(): block size %u is not a power of 2\n",
+		       __func__, uspi->s_bsize);
 		goto failed;
 	}
 	if (uspi->s_bsize < 4096) {
-		pr_err("ufs_read_super: block size %u is too small\n",
-		       uspi->s_bsize);
+		pr_err("%s(): block size %u is too small\n",
+		       __func__, uspi->s_bsize);
 		goto failed;
 	}
 	if (uspi->s_bsize / uspi->s_fsize > 8) {
-		pr_err("ufs_read_super: too many fragments per block (%u)\n",
-		       uspi->s_bsize / uspi->s_fsize);
+		pr_err("%s(): too many fragments per block (%u)\n",
+		       __func__, uspi->s_bsize / uspi->s_fsize);
 		goto failed;
 	}
 	if (uspi->s_fsize != block_size || uspi->s_sbsize != super_block_size) {
@@ -1109,21 +1109,21 @@ magic_found:
 			UFSD("fs is DEC OSF/1\n");
 			break;
 		case UFS_FSACTIVE:
-			pr_err("ufs_read_super: fs is active\n");
+			pr_err("%s(): fs is active\n", __func__);
 			sb->s_flags |= MS_RDONLY;
 			break;
 		case UFS_FSBAD:
-			pr_err("ufs_read_super: fs is bad\n");
+			pr_err("%s(): fs is bad\n", __func__);
 			sb->s_flags |= MS_RDONLY;
 			break;
 		default:
-			pr_err("ufs_read_super: can't grok fs_clean 0x%x\n",
-			       usb1->fs_clean);
+			pr_err("%s(): can't grok fs_clean 0x%x\n",
+			       __func__, usb1->fs_clean);
 			sb->s_flags |= MS_RDONLY;
 			break;
 		}
 	} else {
-		pr_err("ufs_read_super: fs needs fsck\n");
+		pr_err("%s(): fs needs fsck\n", __func__);
 		sb->s_flags |= MS_RDONLY;
 	}
 
-- 
1.8.4.5

