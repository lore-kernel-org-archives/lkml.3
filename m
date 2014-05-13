Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752630AbaEMAaQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 20:30:16 -0400
Received: from mail-oa0-f49.google.com ([209.85.219.49]:34770 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751871AbaEMAaN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 20:30:13 -0400
From: Rob Herring <robherring2@gmail.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Rob Herring <robh@kernel.org>, Shawn Guo <shawn.guo@freescale.com>,
        Sascha Hauer <kernel@pengutronix.de>
Subject: [PATCH 1/7] ARM: imx: fix function type for CLK_OF_DECLARE
Date: Mon, 12 May 2014 19:29:47 -0500
Message-Id: <1399940993-1773-2-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1399940993-1773-1-git-send-email-robherring2@gmail.com>
References: <1399940993-1773-1-git-send-email-robherring2@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <robh@kernel.org>

Adding function type checking to CLK_OF_DECLARE found a type mismatch with
mx35_clocks_init_dt. The function should return void.

Signed-off-by: Rob Herring <robh@kernel.org>
Cc: Shawn Guo <shawn.guo@freescale.com>
Cc: Sascha Hauer <kernel@pengutronix.de>
---
 arch/arm/mach-imx/clk-imx35.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/arch/arm/mach-imx/clk-imx35.c b/arch/arm/mach-imx/clk-imx35.c
index a4d5e42..71c86a2 100644
--- a/arch/arm/mach-imx/clk-imx35.c
+++ b/arch/arm/mach-imx/clk-imx35.c
@@ -289,14 +289,12 @@ int __init mx35_clocks_init(void)
 	return 0;
 }
 
-static int __init mx35_clocks_init_dt(struct device_node *ccm_node)
+static void __init mx35_clocks_init_dt(struct device_node *ccm_node)
 {
 	clk_data.clks = clk;
 	clk_data.clk_num = ARRAY_SIZE(clk);
 	of_clk_add_provider(ccm_node, of_clk_src_onecell_get, &clk_data);
 
 	mx35_clocks_init();
-
-	return 0;
 }
 CLK_OF_DECLARE(imx35, "fsl,imx35-ccm", mx35_clocks_init_dt);
-- 
1.9.1

