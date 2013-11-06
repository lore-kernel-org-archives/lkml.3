Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756192Ab3KFH5c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 02:57:32 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:17590 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756001Ab3KFH5J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 02:57:09 -0500
X-IronPort-AV: E=Sophos;i="4.93,644,1378828800"; 
   d="scan'208";a="8960236"
From: Duan Jiong <duanj.fnst@cn.fujitsu.com>
To: kernel@pengutronix.de, linux@arm.linux.org.uk, a.zummo@towertech.it,
        airlied@linux.ie, dmitry.torokhov@gmail.com
Cc: linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com,
        dri-devel@lists.freedesktop.org, linux-tegra@vger.kernel.org,
        linux-input@vger.kernel.org, Duan Jiong <duanj.fnst@cn.fujitsu.com>
Subject: [PATCH] libcrc32c: replace IS_ERR and PTR_ERR with PTR_ERR_OR_ZERO
Date: Wed, 6 Nov 2013 15:55:00 +0800
Message-Id: <1383724500-15568-1-git-send-email-duanj.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.3.1
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/11/06 15:55:13,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/11/06 15:55:13,
	Serialize complete at 2013/11/06 15:55:13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes coccinelle error regarding usage of IS_ERR and
PTR_ERR instead of PTR_ERR_OR_ZERO.

Signed-off-by: Duan Jiong <duanj.fnst@cn.fujitsu.com>
---
 lib/libcrc32c.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/lib/libcrc32c.c b/lib/libcrc32c.c
index 244f548..b3131f5 100644
--- a/lib/libcrc32c.c
+++ b/lib/libcrc32c.c
@@ -62,10 +62,7 @@ EXPORT_SYMBOL(crc32c);
 static int __init libcrc32c_mod_init(void)
 {
 	tfm = crypto_alloc_shash("crc32c", 0, 0);
-	if (IS_ERR(tfm))
-		return PTR_ERR(tfm);
-
-	return 0;
+	return PTR_ERR_OR_ZERO(tfm);
 }
 
 static void __exit libcrc32c_mod_fini(void)
-- 
1.8.3.1

