Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757388Ab3FCKFu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 06:05:50 -0400
Received: from mga14.intel.com ([143.182.124.37]:31689 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757237Ab3FCKFI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 06:05:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,791,1363158000"; 
   d="scan'208";a="249941841"
From: Huajun Li <huajun.li@intel.com>
To: jaegeuk.kim@samsung.com, linux-fsdevel@vger.kernel.org,
        huajun.li.lee@gmail.com
Cc: namjae.jeon@samsung.com, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        Haicheng Li <haicheng.li@linux.intel.com>,
        Huajun Li <huajun.li@intel.com>
Subject: [RFC 4/5] f2fs: Add Kconfig interface for inline data support
Date: Mon,  3 Jun 2013 18:04:13 +0800
Message-Id: <1370253854-15084-5-git-send-email-huajun.li@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1370253854-15084-1-git-send-email-huajun.li@intel.com>
References: <1370253854-15084-1-git-send-email-huajun.li@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Haicheng Li <haicheng.li@linux.intel.com>

Add Kconfig interface for inline data support, and update Makefile to
compile new added source file.

Signed-off-by: Haicheng Li <haicheng.li@linux.intel.com>
Signed-off-by: Huajun Li <huajun.li@intel.com>
---
 fs/f2fs/Kconfig  |   10 ++++++++++
 fs/f2fs/Makefile |    1 +
 2 files changed, 11 insertions(+)

diff --git a/fs/f2fs/Kconfig b/fs/f2fs/Kconfig
index fd27e7e..75da2e4 100644
--- a/fs/f2fs/Kconfig
+++ b/fs/f2fs/Kconfig
@@ -51,3 +51,13 @@ config F2FS_FS_POSIX_ACL
 	  Linux website <http://acl.bestbits.at/>.
 
 	  If you don't know what Access Control Lists are, say N
+
+config F2FS_INLINE_DATA
+	bool "F2FS inline data support"
+	depends on F2FS_FS
+	default y
+	help
+	  Inline data support is an optimization of F2FS data space management,
+	  which utilizes the unused space within f2fs inode to keep real data.
+
+	  If unsure, say N.
diff --git a/fs/f2fs/Makefile b/fs/f2fs/Makefile
index 27a0820..e1ff7b8 100644
--- a/fs/f2fs/Makefile
+++ b/fs/f2fs/Makefile
@@ -5,3 +5,4 @@ f2fs-y		+= checkpoint.o gc.o data.o node.o segment.o recovery.o
 f2fs-$(CONFIG_F2FS_STAT_FS) += debug.o
 f2fs-$(CONFIG_F2FS_FS_XATTR) += xattr.o
 f2fs-$(CONFIG_F2FS_FS_POSIX_ACL) += acl.o
+f2fs-$(CONFIG_F2FS_INLINE_DATA) += inline.o
-- 
1.7.9.5

