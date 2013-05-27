Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755247Ab3E0QUQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 12:20:16 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:52935 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754339Ab3E0QTT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 12:19:19 -0400
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>,
        Shawn Guo <shawn.guo@linaro.org>, Sascha Hauer <kernel@pengutronix.de>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCH 2/3] arm: mxs: don't check for CONFIG_PHYLIB as builtin
Date: Mon, 27 May 2013 18:18:43 +0200
Message-Id: <1369671524-14797-3-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1369671524-14797-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1369671524-14797-1-git-send-email-alexandre.belloni@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 arch/arm/mach-mxs/mach-mxs.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/arm/mach-mxs/mach-mxs.c b/arch/arm/mach-mxs/mach-mxs.c
index 5b62b64..91c2bd2 100644
--- a/arch/arm/mach-mxs/mach-mxs.c
+++ b/arch/arm/mach-mxs/mach-mxs.c
@@ -273,9 +273,8 @@ static void __init apx4devkit_init(void)
 {
 	enable_clk_enet_out();
 
-	if (IS_BUILTIN(CONFIG_PHYLIB))
-		phy_register_fixup_for_uid(PHY_ID_KSZ8051, MICREL_PHY_ID_MASK,
-					   apx4devkit_phy_fixup);
+	phy_register_fixup_for_uid(PHY_ID_KSZ8051, MICREL_PHY_ID_MASK,
+			apx4devkit_phy_fixup);
 }
 
 #define ENET0_MDC__GPIO_4_0	MXS_GPIO_NR(4, 0)
-- 
1.8.1.2

