Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751294AbaBHGCe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Feb 2014 01:02:34 -0500
Received: from mail-we0-f179.google.com ([74.125.82.179]:57532 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750748AbaBHGCd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Feb 2014 01:02:33 -0500
From: Soren Brinkmann <soren.brinkmann@xilinx.com>
To: Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Soren Brinkmann <soren.brinkmann@xilinx.com>
Subject: [PATCH] ARM: smp_twd: Set the CLOCK_EVT_FEAT_PERCPU flag
Date: Fri,  7 Feb 2014 22:02:09 -0800
Message-Id: <1391839329-30971-1-git-send-email-soren.brinkmann@xilinx.com>
X-Mailer: git-send-email 1.8.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The twd timers are per CPU devices. Set the corresponding flag to mark
them as such.

Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
---
 arch/arm/kernel/smp_twd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/kernel/smp_twd.c b/arch/arm/kernel/smp_twd.c
index 6591e26fc13f..85407473c97d 100644
--- a/arch/arm/kernel/smp_twd.c
+++ b/arch/arm/kernel/smp_twd.c
@@ -294,7 +294,7 @@ static void twd_timer_setup(void)
 
 	clk->name = "local_timer";
 	clk->features = CLOCK_EVT_FEAT_PERIODIC | CLOCK_EVT_FEAT_ONESHOT |
-			CLOCK_EVT_FEAT_C3STOP;
+			CLOCK_EVT_FEAT_C3STOP | CLOCK_EVT_FEAT_PERCPU;
 	clk->rating = 350;
 	clk->set_mode = twd_set_mode;
 	clk->set_next_event = twd_set_next_event;
-- 
1.8.5.4

