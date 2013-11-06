Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756058Ab3KFHzG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 02:55:06 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:15541 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753854Ab3KFHzD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 02:55:03 -0500
X-IronPort-AV: E=Sophos;i="4.93,644,1378828800"; 
   d="scan'208";a="8960193"
From: Duan Jiong <duanj.fnst@cn.fujitsu.com>
To: kernel@pengutronix.de, linux@arm.linux.org.uk
Cc: linux-kernel@vger.kernel.org, Duan Jiong <duanj.fnst@cn.fujitsu.com>
Subject: [PATCH] ARM: imx: replace IS_ERR and PTR_ERR with PTR_ERR_OR_ZERO
Date: Wed, 6 Nov 2013 15:52:45 +0800
Message-Id: <1383724365-15196-1-git-send-email-duanj.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.3.1
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/11/06 15:53:06,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/11/06 15:53:09,
	Serialize complete at 2013/11/06 15:53:09
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes coccinelle error regarding usage of IS_ERR and
PTR_ERR instead of PTR_ERR_OR_ZERO.

Signed-off-by: Duan Jiong <duanj.fnst@cn.fujitsu.com>
---
 arch/arm/mach-imx/mx31moboard-smartbot.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/arch/arm/mach-imx/mx31moboard-smartbot.c b/arch/arm/mach-imx/mx31moboard-smartbot.c
index 04ae45d..af6550e 100644
--- a/arch/arm/mach-imx/mx31moboard-smartbot.c
+++ b/arch/arm/mach-imx/mx31moboard-smartbot.c
@@ -141,10 +141,7 @@ static int __init smartbot_otg_host_init(void)
 		return -ENODEV;
 
 	pdev = imx31_add_mxc_ehci_otg(&otg_host_pdata);
-	if (IS_ERR(pdev))
-		return PTR_ERR(pdev);
-
-	return 0;
+	return PTR_ERR_OR_ZERO(pdev);
 }
 #else
 static inline int smartbot_otg_host_init(void) { return 0; }
-- 
1.8.3.1

