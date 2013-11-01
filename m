Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755803Ab3KAKCZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 06:02:25 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:28346 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755273Ab3KAKCX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 06:02:23 -0400
X-IronPort-AV: E=Sophos;i="4.93,615,1378828800"; 
   d="scan'208";a="8921266"
From: Duan Jiong <duanj.fnst@cn.fujitsu.com>
To: acme@ghostprotocols.net
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Duan Jiong <duanj.fnst@cn.fujitsu.com>
Subject: [PATCH] drivers/net: replace IS_ERR and PTR_ERR with PTR_ERR_OR_ZERO
Date: Fri, 1 Nov 2013 18:00:16 +0800
Message-Id: <1383300016-5947-1-git-send-email-duanj.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.3.1
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/11/01 18:00:35,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/11/01 18:00:36,
	Serialize complete at 2013/11/01 18:00:36
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes coccinelle error regarding usage of IS_ERR and
PTR_ERR instead of PTR_ERR_OR_ZERO.

Signed-off-by: Duan Jiong <duanj.fnst@cn.fujitsu.com>
---
 drivers/net/appletalk/ipddp.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/appletalk/ipddp.c b/drivers/net/appletalk/ipddp.c
index 10d0dba..78f06cb 100644
--- a/drivers/net/appletalk/ipddp.c
+++ b/drivers/net/appletalk/ipddp.c
@@ -312,9 +312,7 @@ module_param(ipddp_mode, int, 0);
 static int __init ipddp_init_module(void)
 {
 	dev_ipddp = ipddp_init();
-        if (IS_ERR(dev_ipddp))
-                return PTR_ERR(dev_ipddp);
-	return 0;
+        return PTR_ERR_OR_ZERO(dev_ipddp);
 }
 
 static void __exit ipddp_cleanup_module(void)
-- 
1.8.3.1

