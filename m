Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752417Ab3EMI7G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 04:59:06 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:12314 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751840Ab3EMI7D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 04:59:03 -0400
X-IronPort-AV: E=Sophos;i="4.87,661,1363104000"; 
   d="scan'208,223";a="7255571"
Message-ID: <5190AAB9.5080904@cn.fujitsu.com>
Date: Mon, 13 May 2013 16:56:25 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: hirofumi@mail.parknet.co.jp
CC: linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] fs/fat: Use fat_msg() to replace printk() in __fat_fs_error()
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/05/13 16:57:27,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/05/13 16:57:28,
	Serialize complete at 2013/05/13 16:57:28
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 87141ec058aad35ac55bc7c3fc2eb378566a5a6a Mon Sep 17 00:00:00 2001
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
Date: Mon, 13 May 2013 17:48:19 +0900
Subject: [PATCH] fs/fat: Use fat_msg() to replace printk() in __fat_fs_error()


Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
---
 fs/fat/misc.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/fat/misc.c b/fs/fat/misc.c
index 359d307..628e22a 100644
--- a/fs/fat/misc.c
+++ b/fs/fat/misc.c
@@ -30,7 +30,7 @@ void __fat_fs_error(struct super_block *sb, int report, const char *fmt, ...)
 		va_start(args, fmt);
 		vaf.fmt = fmt;
 		vaf.va = &args;
-		printk(KERN_ERR "FAT-fs (%s): error, %pV\n", sb->s_id, &vaf);
+		fat_msg(sb, KERN_ERR, "error, %pV", &vaf);
 		va_end(args);
 	}
 
@@ -38,8 +38,7 @@ void __fat_fs_error(struct super_block *sb, int report, const char *fmt, ...)
 		panic("FAT-fs (%s): fs panic from previous error\n", sb->s_id);
 	else if (opts->errors == FAT_ERRORS_RO && !(sb->s_flags & MS_RDONLY)) {
 		sb->s_flags |= MS_RDONLY;
-		printk(KERN_ERR "FAT-fs (%s): Filesystem has been "
-				"set read-only\n", sb->s_id);
+		fat_msg(sb, KERN_ERR, "Filesystem has been set read-only");
 	}
 }
 EXPORT_SYMBOL_GPL(__fat_fs_error);
-- 
1.7.1

