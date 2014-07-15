Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932375AbaGORDL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 13:03:11 -0400
Received: from mail-wg0-f41.google.com ([74.125.82.41]:39444 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755778AbaGORCP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 13:02:15 -0400
From: Sam Asadi <asadi.samuel@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Guido=20Mart=C3=ADnez?= <guido@vanguardiasur.com.ar>,
        Tony Lindgren <tony@atomide.com>, sam-the-6 <asadi.samuel@gmail.com>
Subject: [PATCH 45/94] ARM: OMAP2+: Make GPMC skip disabled devices
Date: Tue, 15 Jul 2014 20:01:00 +0300
Message-Id: <1405443709-15288-45-git-send-email-asadi.samuel@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1405443709-15288-1-git-send-email-asadi.samuel@gmail.com>
References: <1405443709-15288-1-git-send-email-asadi.samuel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Guido Martínez <guido@vanguardiasur.com.ar>

Currently, child nodes of the gpmc node are iterated and probed
regardless of their 'status' property. This means adding 'status =
"disabled";' has no effect.

This patch changes the iteration to only probe nodes marked as
available.

Signed-off-by: Guido Martínez <guido@vanguardiasur.com.ar>
Tested-by: Pekon Gupta <pekon@ti.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: sam-the-6 <asadi.samuel@gmail.com>
---
 arch/arm/mach-omap2/gpmc.c |    2 +-
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
1.7.10.4

