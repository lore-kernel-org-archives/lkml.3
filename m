Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751937Ab3C0PWB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 11:22:01 -0400
Received: from mail-ea0-f175.google.com ([209.85.215.175]:63693 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751463Ab3C0PWA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 11:22:00 -0400
From: Fabio Baltieri <fabio.baltieri@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Fabio Baltieri <fabio.baltieri@linaro.org>
Subject: [PATCH] ARM: ux500: update V-INTCORE constraints
Date: Wed, 27 Mar 2013 16:21:34 +0100
Message-Id: <1364397694-14126-1-git-send-email-fabio.baltieri@linaro.org>
X-Mailer: git-send-email 1.8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update V-INTCORE regulator constraints to allow voltage and
configuration changes from consumer drivers.

Signed-off-by: Fabio Baltieri <fabio.baltieri@linaro.org>
---
Hi Linus,

this patch adds the regulators bits I'm missing for ux500-musb patches.
Without this I just get a runtime warning like:

V-INTCORE: operation not allowed

but the driver works anyway and there are no build dependencies, so I
think this can safely go in the arm-soc tree on its own, and the whole
thing should work happily in -next.

Thanks,
Fabio

 arch/arm/mach-ux500/board-mop500-regulators.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/arch/arm/mach-ux500/board-mop500-regulators.c b/arch/arm/mach-ux500/board-mop500-regulators.c
index 2a17bc5..0a428db 100644
--- a/arch/arm/mach-ux500/board-mop500-regulators.c
+++ b/arch/arm/mach-ux500/board-mop500-regulators.c
@@ -392,7 +392,15 @@ struct regulator_init_data ab8500_regulators[AB8500_NUM_REGULATORS] = {
 	[AB8500_LDO_INTCORE] = {
 		.constraints = {
 			.name = "V-INTCORE",
-			.valid_ops_mask = REGULATOR_CHANGE_STATUS,
+			.min_uV = 1250000,
+			.max_uV = 1350000,
+			.input_uV = 1800000,
+			.valid_ops_mask = REGULATOR_CHANGE_VOLTAGE |
+					  REGULATOR_CHANGE_STATUS |
+					  REGULATOR_CHANGE_MODE |
+					  REGULATOR_CHANGE_DRMS,
+			.valid_modes_mask = REGULATOR_MODE_NORMAL |
+					    REGULATOR_MODE_IDLE,
 		},
 		.num_consumer_supplies = ARRAY_SIZE(ab8500_vintcore_consumers),
 		.consumer_supplies = ab8500_vintcore_consumers,
-- 
1.8.1.3

