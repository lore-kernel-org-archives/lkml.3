Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755108AbaF3UeW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 16:34:22 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:60955 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753830AbaF3UeT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 16:34:19 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 1/4] [3.8-stable-only] Revert "ARM: OMAP3: clock: Back-propagate rate change from cam_mclk to dpll4_m5 on all OMAP3 platforms"
Date: Mon, 30 Jun 2014 13:34:01 -0700
Message-Id: <1404160444-9157-2-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404160444-9157-1-git-send-email-kamal@canonical.com>
References: <1404160444-9157-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.26 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kamal Mostafa <kamal@canonical.com>

This reverts commit 5cc705002f753f10b957b4bb128b15b2caed4577.

Commit is not suitable for 3.8-based kernels; breaks the OMAP build (oops)!

Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/arm/mach-omap2/cclock3xxx_data.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/arm/mach-omap2/cclock3xxx_data.c b/arch/arm/mach-omap2/cclock3xxx_data.c
index 622c912..6ef8758 100644
--- a/arch/arm/mach-omap2/cclock3xxx_data.c
+++ b/arch/arm/mach-omap2/cclock3xxx_data.c
@@ -418,8 +418,7 @@ static struct clk_hw_omap dpll4_m5x2_ck_hw = {
 	.clkdm_name	= "dpll4_clkdm",
 };
 
-DEFINE_STRUCT_CLK_FLAGS(dpll4_m5x2_ck, dpll4_m5x2_ck_parent_names,
-			dpll4_m5x2_ck_ops, CLK_SET_RATE_PARENT);
+DEFINE_STRUCT_CLK(dpll4_m5x2_ck, dpll4_m5x2_ck_parent_names, dpll4_m5x2_ck_ops);
 
 static struct clk dpll4_m5x2_ck_3630 = {
 	.name		= "dpll4_m5x2_ck",
-- 
1.9.1

