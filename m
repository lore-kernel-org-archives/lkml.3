Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760228Ab3CZTip (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 15:38:45 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:45921 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753505Ab3CZTio (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 15:38:44 -0400
From: Mike Turquette <mturquette@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org,
        Mike Turquette <mturquette@linaro.org>,
        Shawn Guo <shawn.guo@linaro.org>,
        Peter De Schrijver <pdeschrijver@nvidia.com>
Subject: [PATCH] ARM: imx: replace width with mask for clk_busy_mux
Date: Tue, 26 Mar 2013 12:38:05 -0700
Message-Id: <1364326685-8545-1-git-send-email-mturquette@linaro.org>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The recent addition of table-based parent lookups[1] in the common
clk_mux implementation removed the width member of struct clk_mux and
replaced it with an arbitrary mask.  This broke compilation for i.MX
platforms using clk_busy_mux which builds upon the common clk_mux.

Fixed by populating the mask member during clk_busy_mux registration
instead of the now non-existent width member.

[1] http://article.gmane.org/gmane.linux.ports.tegra/10028

Cc: Shawn Guo <shawn.guo@linaro.org>
Cc: Peter De Schrijver <pdeschrijver@nvidia.com>
Signed-off-by: Mike Turquette <mturquette@linaro.org>
---
 arch/arm/mach-imx/clk-busy.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-imx/clk-busy.c b/arch/arm/mach-imx/clk-busy.c
index 1ab91b5..85b728c 100644
--- a/arch/arm/mach-imx/clk-busy.c
+++ b/arch/arm/mach-imx/clk-busy.c
@@ -169,7 +169,7 @@ struct clk *imx_clk_busy_mux(const char *name, void __iomem *reg, u8 shift,
 
 	busy->mux.reg = reg;
 	busy->mux.shift = shift;
-	busy->mux.width = width;
+	busy->mux.mask = BIT(width) - 1;
 	busy->mux.lock = &imx_ccm_lock;
 	busy->mux_ops = &clk_mux_ops;
 
-- 
1.7.10.4

