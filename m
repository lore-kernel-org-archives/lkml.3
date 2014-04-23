Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755854AbaDWBa5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 21:30:57 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:32907 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756625AbaDWB2B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 21:28:01 -0400
From: Joel Fernandes <joelf@ti.com>
To: Tony Lindgren <tony@atomide.com>, Rob Herring <rob.herring@calxeda.com>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Joel Fernandes <joelf@ti.com>
Subject: [PATCH 6/8] ARM: OMAP2+: timer: Fix error message to not use hwmod structure
Date: Tue, 22 Apr 2014 20:27:07 -0500
Message-ID: <1398216429-4681-7-git-send-email-joelf@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1398216429-4681-1-git-send-email-joelf@ti.com>
References: <1398216429-4681-1-git-send-email-joelf@ti.com>
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

