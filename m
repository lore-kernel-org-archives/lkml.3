Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756319AbaDWBbZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 21:31:25 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:46793 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755879AbaDWB17 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 21:27:59 -0400
From: Joel Fernandes <joelf@ti.com>
To: Tony Lindgren <tony@atomide.com>, Rob Herring <rob.herring@calxeda.com>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Joel Fernandes <joelf@ti.com>
Subject: [PATCH 3/8] ARM: OMAP2+: timer: Add comment on timer clk parenting
Date: Tue, 22 Apr 2014 20:27:04 -0500
Message-ID: <1398216429-4681-4-git-send-email-joelf@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1398216429-4681-1-git-send-email-joelf@ti.com>
References: <1398216429-4681-1-git-send-email-joelf@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a comment describing the state of system timer clock parenting.  The code
following the comment should be deleted once all platforms can do DT boot, and
specially should not be executed for DT platforms once we can specify default
clock parents through DT.

Signed-off-by: Joel Fernandes <joelf@ti.com>
---
 arch/arm/mach-omap2/timer.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm/mach-omap2/timer.c b/arch/arm/mach-omap2/timer.c
index f192a41..9fdff5b 100644
--- a/arch/arm/mach-omap2/timer.c
+++ b/arch/arm/mach-omap2/timer.c
@@ -313,6 +313,10 @@ static int __init omap_dm_timer_init_one(struct omap_dm_timer *timer,
 	if (IS_ERR(timer->fclk))
 		return PTR_ERR(timer->fclk);
 
+	/*
+	 * Clock reparenting code, goes away for DT-boot atleast,
+	 * once clock layer can do it through DT.
+	 */
 	src = clk_get(NULL, fck_source);
 	if (IS_ERR(src))
 		return PTR_ERR(src);
-- 
1.7.9.5

