Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759245AbaCEPYs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 10:24:48 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:40835 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756826AbaCEOZF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 09:25:05 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Pekon Gupta <pekon@ti.com>, Tony Lindgren <tony@atomide.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 030/131] ARM: OMAP2+: gpmc: fix: DT NAND child nodes not probed when MTD_NAND is built as module
Date: Wed,  5 Mar 2014 14:22:34 +0000
Message-Id: <1394029455-23128-31-git-send-email-luis.henriques@canonical.com>
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

commit 6b187b21c92b6e2c7e8ef0b450181c37a3f31681 upstream.

Fixes: commit bc6b1e7b86f5d8e4a6fc1c0189e64bba4077efe0
       ARM: OMAP: gpmc: add DT bindings for GPMC timings and NAND

OMAP SoC(s) depend on GPMC controller driver to parse GPMC DT child nodes and
register them platform_device for NAND driver to probe later. However this does
not happen if generic MTD_NAND framework is built as module (CONFIG_MTD_NAND=m).

Therefore, when MTD/NAND and MTD/NAND/OMAP2 modules are loaded, they are unable
to find any matching platform_device and remain un-binded. This causes on board
NAND flash to remain un-detected.

This patch causes GPMC controller to parse DT nodes when
CONFIG_MTD_NAND=y || CONFIG_MTD_NAND=m

Signed-off-by: Pekon Gupta <pekon@ti.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/arm/mach-omap2/gpmc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-omap2/gpmc.c b/arch/arm/mach-omap2/gpmc.c
index f3fdd6a..0fe1f7f 100644
--- a/arch/arm/mach-omap2/gpmc.c
+++ b/arch/arm/mach-omap2/gpmc.c
@@ -1339,7 +1339,7 @@ static void __maybe_unused gpmc_read_timings_dt(struct device_node *np,
 		of_property_read_bool(np, "gpmc,time-para-granularity");
 }
 
-#ifdef CONFIG_MTD_NAND
+#if IS_ENABLED(CONFIG_MTD_NAND)
 
 static const char * const nand_ecc_opts[] = {
 	[OMAP_ECC_HAMMING_CODE_DEFAULT]		= "sw",
-- 
1.9.0

