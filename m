Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754142AbaDXVou (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 17:44:50 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:38807 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752503AbaDXVos (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 17:44:48 -0400
From: Joel Fernandes <joelf@ti.com>
To: Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Tony Lindgren <tony@atomide.com>, Joel Fernandes <joelf@ti.com>
Subject: [PATCH 16/26] ARM: OMAP2+: timer: Fix error message to not use hwmod structure
Date: Thu, 24 Apr 2014 16:43:59 -0500
Message-ID: <1398375849-6017-17-git-send-email-joelf@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1398375849-6017-1-git-send-email-joelf@ti.com>
References: <1398375849-6017-1-git-send-email-joelf@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

oh->name is no longer used, correct the error message.

Signed-off-by: Joel Fernandes <joelf@ti.com>
---
 arch/arm/mach-omap2/timer.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-omap2/timer.c b/arch/arm/mach-omap2/timer.c
index 4fcfd7a..519ccfd 100644
--- a/arch/arm/mach-omap2/timer.c
+++ b/arch/arm/mach-omap2/timer.c
@@ -331,8 +331,8 @@ static int __init omap_dm_timer_init_one(struct omap_dm_timer *timer,
 	if (clk_get_parent(timer->fclk) != src) {
 		r = clk_set_parent(timer->fclk, src);
 		if (r < 0) {
-			pr_warn("%s: %s cannot set source\n", __func__,
-				oh->name);
+			pr_warn("%s: cannot set timer's source\n", __func__);
+			WARN_ON(1);
 			clk_put(src);
 			return r;
 		}
-- 
1.7.9.5

