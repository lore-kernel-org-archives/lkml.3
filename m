Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759296AbaGYCZ4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 22:25:56 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:21740 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758109AbaGYCZy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 22:25:54 -0400
X-AuditID: cbfee61b-f79f86d00000144c-3e-53d1c03190c5
From: Chao Yu <chao2.yu@samsung.com>
To: anton@tuxera.com
Cc: linux-ntfs-dev@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [PATCH] ntfs: avoid incorrectly release for root inode in fill_super
Date: Fri, 25 Jul 2014 10:25:10 +0800
Message-id: <002901cfa7af$c2024dc0$4606e940$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac+nr5C8RjVjMtA/R/uBZCN+mMfx0g==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJLMWRmVeSWpSXmKPExsVy+t9jAV3DAxeDDZ73cFns3LSF1eLyrjls
	Fu0dcxgdmD12L/jM5LFi5Xsmj8+b5AKYo7hsUlJzMstSi/TtErgyeuc+Zi3Yylbx+nInSwNj
	P2sXIyeHhICJxMSJ35ggbDGJC/fWs3UxcnEICSxilDhwdiMjhPODUWL28ZlgVWwCKhLLO/6D
	2SICIhLz9j5jA7GZBdwkHh0AaeDkEBbwlTjSf4MdxGYRUJVY/ugWWJxXwFKiad1bFghbUOLH
	5HssEL1aEut3HmeCsOUlNq95ywxxkYLEjrOvgXo5gHbpSVxemgFRIi6x8cgtlgmMArOQTJqF
	ZNIsJJNmIWlZwMiyilE0tSC5oDgpPddIrzgxt7g0L10vOT93EyM4gJ9J72Bc1WBxiFGAg1GJ
	h7ej/mKwEGtiWXFl7iFGCQ5mJRFet7lAId6UxMqq1KL8+KLSnNTiQ4zSHCxK4rwHW60DhQTS
	E0tSs1NTC1KLYLJMHJxSDYxG+2Ll2GxS+S7z/tvZL+Xkr36y+MPDug3r3M0Cj65sFr2+NeVg
	1ZSoLPYbvzeeO1Ig6mT1wWSddX/EiZ4sNbY0s/v9wd233wQtt7t+23/h77gfnq8+NPyYc+BI
	gtKWae+n/ws4kt7acuDsq6Vf65/dTdn1NuiWkEbkk+znVismMl7Jurxw2uNeJZbijERDLeai
	4kQAjKRyFVwCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In d_make_root, when we fail to allocate dentry for root inode, we will iput
root inode in this function.
So we do not need to release this inode again at d_make_root's caller.

Signed-off-by: Chao Yu <chao2.yu@samsung.com>
---
 fs/ntfs/super.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/ntfs/super.c b/fs/ntfs/super.c
index 6c3296e..99c5cc6 100644
--- a/fs/ntfs/super.c
+++ b/fs/ntfs/super.c
@@ -2975,7 +2975,11 @@ static int ntfs_fill_super(struct super_block *sb, void *opt, const int silent)
 			vol->secure_ino = NULL;
 		}
 	}
-	iput(vol->root_ino);
+
+	/*
+	 * Just set NULL value here because we have already iput root_ino
+	 * in d_make_root.
+	 */
 	vol->root_ino = NULL;
 	iput(vol->lcnbmp_ino);
 	vol->lcnbmp_ino = NULL;
-- 
2.0.1.474.g72c7794


