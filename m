Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754999AbaDKHte (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 03:49:34 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:58426 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750909AbaDKHtc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 03:49:32 -0400
X-IronPort-AV: E=Sophos;i="4.97,839,1389715200"; 
   d="scan'208";a="29139291"
From: Duan Jiong <duanj.fnst@cn.fujitsu.com>
To: <shawn.guo@freescale.com>, <kernel@pengutronix.de>,
        <linux@arm.linux.org.uk>
CC: <linux-kernel@vger.kernel.org>, Duan Jiong <duanj.fnst@cn.fujitsu.com>
Subject: [PATCH] ARM: imx: replace IS_ERR and PTR_ERR with PTR_ERR_OR_ZERO
Date: Fri, 11 Apr 2014 15:46:41 +0800
Message-ID: <1397202401-16023-1-git-send-email-duanj.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.225.86]
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

