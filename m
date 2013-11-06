Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756177Ab3KFH5K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 02:57:10 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:17590 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751270Ab3KFH5H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 02:57:07 -0500
X-IronPort-AV: E=Sophos;i="4.93,644,1378828800"; 
   d="scan'208";a="8960234"
From: Duan Jiong <duanj.fnst@cn.fujitsu.com>
To: kernel@pengutronix.de, linux@arm.linux.org.uk, a.zummo@towertech.it,
        airlied@linux.ie, dmitry.torokhov@gmail.com
Cc: linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com,
        dri-devel@lists.freedesktop.org, linux-tegra@vger.kernel.org,
        linux-input@vger.kernel.org, Duan Jiong <duanj.fnst@cn.fujitsu.com>
Subject: [PATCH] leds: leds-mc13783: replace IS_ERR and PTR_ERR with PTR_ERR_OR_ZERO
Date: Wed, 6 Nov 2013 15:54:44 +0800
Message-Id: <1383724484-15520-1-git-send-email-duanj.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.3.1
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/11/06 15:54:57,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/11/06 15:54:58,
	Serialize complete at 2013/11/06 15:54:58
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes coccinelle error regarding usage of IS_ERR and
PTR_ERR instead of PTR_ERR_OR_ZERO.

Signed-off-by: Duan Jiong <duanj.fnst@cn.fujitsu.com>
---
 arch/arm/mach-imx/mach-mx31moboard.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/arch/arm/mach-imx/mach-mx31moboard.c b/arch/arm/mach-imx/mach-mx31moboard.c
index 6f424ec..118ea68 100644
--- a/arch/arm/mach-imx/mach-mx31moboard.c
+++ b/arch/arm/mach-imx/mach-mx31moboard.c
@@ -446,10 +446,7 @@ static int __init moboard_usbh2_init(void)
 		return -ENODEV;
 
 	pdev = imx31_add_mxc_ehci_hs(2, &usbh2_pdata);
-	if (IS_ERR(pdev))
-		return PTR_ERR(pdev);
-
-	return 0;
+	return PTR_ERR_OR_ZERO(pdev);
 }
 
 static const struct gpio_led mx31moboard_leds[] __initconst = {
-- 
1.8.3.1

