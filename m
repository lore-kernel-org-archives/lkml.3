Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759594AbaGDVEK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 17:04:10 -0400
Received: from mail-ig0-f173.google.com ([209.85.213.173]:48764 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752011AbaGDVEJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 17:04:09 -0400
From: Nicholas Krause <xerofoify@gmail.com>
To: paul@pwsan.com
Cc: tony@atomide.com, linux@arm.linux.org.uk, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] mach-omap2: Change if statement in omap2_dflt_clk_enable
Date: Fri,  4 Jul 2014 17:04:03 -0400
Message-Id: <1404507843-3648-1-git-send-email-xerofoify@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch changes this function to check for if v is returning value from the
called function. If not it does the else. Furthermore fixes the FIXME message above
if statement for holding INVERT_ENABLE bit when not needing to be checked for
in if statement by just checking for if v is not Null.

Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
---
 arch/arm/mach-omap2/clock.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-omap2/clock.c b/arch/arm/mach-omap2/clock.c
index 591581a..626363d 100644
--- a/arch/arm/mach-omap2/clock.c
+++ b/arch/arm/mach-omap2/clock.c
@@ -379,7 +379,7 @@ void omap2_dflt_clk_disable(struct clk_hw *hw)
 	}
 
 	v = omap2_clk_readl(clk, clk->enable_reg);
-	if (clk->flags & INVERT_ENABLE)
+	if (v)
 		v |= (1 << clk->enable_bit);
 	else
 		v &= ~(1 << clk->enable_bit);
-- 
1.9.1

