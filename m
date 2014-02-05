Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751637AbaBEJEq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 04:04:46 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:51984 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751017AbaBEJEg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 04:04:36 -0500
From: Nishanth Menon <nm@ti.com>
To: Tony Lindgren <tony@atomide.com>
CC: <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, Tero Kristo <t-kristo@ti.com>,
        Nishanth Menon <nm@ti.com>
Subject: [PATCH] ARM: OMAP3+: DPLL: stop reparenting to same parent if already done
Date: Wed, 5 Feb 2014 03:04:08 -0600
Message-ID: <1391591048-19433-1-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

omap3_noncore_dpll_set_rate forces a reparent to the same clk_ref
for every call that takes place. This is an can be done only if a change
is detected.

Signed-off-by: Nishanth Menon <nm@ti.com>
---
 arch/arm/mach-omap2/dpll3xxx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-omap2/dpll3xxx.c b/arch/arm/mach-omap2/dpll3xxx.c
index 3185ced..d9bcbf7 100644
--- a/arch/arm/mach-omap2/dpll3xxx.c
+++ b/arch/arm/mach-omap2/dpll3xxx.c
@@ -525,7 +525,7 @@ int omap3_noncore_dpll_set_rate(struct clk_hw *hw, unsigned long rate,
 	* stuff is inherited for free
 	*/
 
-	if (!ret)
+	if (!ret && clk_get_parent(hw->clk) != new_parent)
 		__clk_reparent(hw->clk, new_parent);
 
 	return 0;
-- 
1.7.9.5

