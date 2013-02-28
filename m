Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759791Ab3B1Rrr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 12:47:47 -0500
Received: from mail-ee0-f51.google.com ([74.125.83.51]:46830 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759507Ab3B1Rrp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 12:47:45 -0500
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Timo Kokkonen <timo.t.kokkonen@iki.fi>,
        Tony Lindgren <tony@atomide.com>,
        Joni Lapilainen <joni.lapilainen@gmail.com>
Subject: [PATCH] rc: ir-rx51: Fix compilation
Date: Thu, 28 Feb 2013 18:47:15 +0100
Message-Id: <1362073635-8167-1-git-send-email-pali.rohar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joni Lapilainen <joni.lapilainen@gmail.com>

Signed-off-by: Joni Lapilainen <joni.lapilainen@gmail.com>
---
 drivers/media/rc/ir-rx51.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/media/rc/ir-rx51.c b/drivers/media/rc/ir-rx51.c
index 8ead492..3971192 100644
--- a/drivers/media/rc/ir-rx51.c
+++ b/drivers/media/rc/ir-rx51.c
@@ -27,7 +27,8 @@
 #include <linux/wait.h>
 
 #include <plat/dmtimer.h>
-#include <plat/clock.h>
+
+#include "../../../arch/arm/mach-omap2/clock.h"
 
 #include <media/lirc.h>
 #include <media/lirc_dev.h>
@@ -209,7 +210,7 @@ static int lirc_rx51_init_port(struct lirc_rx51 *lirc_rx51)
 	}
 
 	clk_fclk = omap_dm_timer_get_fclk(lirc_rx51->pwm_timer);
-	lirc_rx51->fclk_khz = clk_fclk->rate / 1000;
+	lirc_rx51->fclk_khz = clk_get_rate(clk_fclk) / 1000;
 
 	return 0;
 
-- 
1.7.10.4

