Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754031AbaGBNdF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 09:33:05 -0400
Received: from mail-yk0-f170.google.com ([209.85.160.170]:61002 "EHLO
	mail-yk0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752249AbaGBNdD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 09:33:03 -0400
From: =?UTF-8?q?Guido=20Mart=C3=ADnez?= <guido@vanguardiasur.com.ar>
To: Tony Lindgren <tony@atomide.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org,
        =?UTF-8?q?Ezequiel=20Garc=C3=ADa?= <ezequiel@vanguardiasur.com.ar>,
        pekon@ti.com,
        =?UTF-8?q?Guido=20Mart=C3=ADnez?= <guido@vanguardiasur.com.ar>
Subject: [PATCH v2] ARM: OMAP2+: Make GPMC skip disabled devices
Date: Wed,  2 Jul 2014 10:35:18 -0300
Message-Id: <1404308118-14843-1-git-send-email-guido@vanguardiasur.com.ar>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <20980858CB6D3A4BAE95CA194937D5E73EAF8D44@DBDE04.ent.ti.com>
References: <20980858CB6D3A4BAE95CA194937D5E73EAF8D44@DBDE04.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, child nodes of the gpmc node are iterated and probed
regardless of their 'status' property. This means adding 'status =
"disabled";' has no effect.

This patch changes the iteration to only probe nodes marked as
available.

Signed-off-by: Guido Martínez <guido@vanguardiasur.com.ar>
---
v2: Make patch title consistent with previous gpmc patches

 arch/arm/mach-omap2/gpmc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-omap2/gpmc.c b/arch/arm/mach-omap2/gpmc.c
index 2c0c281..8bc1338 100644
--- a/arch/arm/mach-omap2/gpmc.c
+++ b/arch/arm/mach-omap2/gpmc.c
@@ -1615,7 +1615,7 @@ static int gpmc_probe_dt(struct platform_device *pdev)
 		return ret;
 	}
 
-	for_each_child_of_node(pdev->dev.of_node, child) {
+	for_each_available_child_of_node(pdev->dev.of_node, child) {
 
 		if (!child->name)
 			continue;
-- 
2.0.0

