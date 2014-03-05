Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759225AbaCEPYc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 10:24:32 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:40840 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756831AbaCEOZG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 09:25:06 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Pekon Gupta <pekon@ti.com>, Tony Lindgren <tony@atomide.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 031/131] ARM: OMAP2+: gpmc: fix: DT ONENAND child nodes not probed when MTD_ONENAND is built as module
Date: Wed,  5 Mar 2014 14:22:35 +0000
Message-Id: <1394029455-23128-32-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1394029455-23128-1-git-send-email-luis.henriques@canonical.com>
References: <1394029455-23128-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pekon Gupta <pekon@ti.com>

commit 980386d2d6d49e0b42f48550853ef1ad6aa5d79a upstream.

Fixes: commit 75d3625e0e86b2d8d77b4e9c6f685fd7ea0d5a96
       ARM: OMAP2+: gpmc: add DT bindings for OneNAND

OMAP SoC(s) depend on GPMC controller driver to parse GPMC DT child nodes and
register them platform_device for ONENAND driver to probe later. However this does
not happen if generic MTD_ONENAND framework is built as module (CONFIG_MTD_ONENAND=m).

Therefore, when MTD/ONENAND and MTD/ONENAND/OMAP2 modules are loaded, they are unable
to find any matching platform_device and remain un-binded. This causes on board
ONENAND flash to remain un-detected.

This patch causes GPMC controller to parse DT nodes when
CONFIG_MTD_ONENAND=y || CONFIG_MTD_ONENAND=m

Signed-off-by: Pekon Gupta <pekon@ti.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/arm/mach-omap2/gpmc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-omap2/gpmc.c b/arch/arm/mach-omap2/gpmc.c
index 0fe1f7f..8d993d7 100644
--- a/arch/arm/mach-omap2/gpmc.c
+++ b/arch/arm/mach-omap2/gpmc.c
@@ -1409,7 +1409,7 @@ static int gpmc_probe_nand_child(struct platform_device *pdev,
 }
 #endif
 
-#ifdef CONFIG_MTD_ONENAND
+#if IS_ENABLED(CONFIG_MTD_ONENAND)
 static int gpmc_probe_onenand_child(struct platform_device *pdev,
 				 struct device_node *child)
 {
-- 
1.9.0

