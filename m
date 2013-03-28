Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756768Ab3C1QL7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 12:11:59 -0400
Received: from mail-we0-f182.google.com ([74.125.82.182]:59862 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756703Ab3C1QL5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 12:11:57 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org, broonie@opensource.wolfsonmicro.com
Cc: Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 03/33] ARM: ux500: Provide a mechanism to over-ride regulator init values
Date: Thu, 28 Mar 2013 16:11:03 +0000
Message-Id: <1364487093-19551-4-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1364487093-19551-1-git-send-email-lee.jones@linaro.org>
References: <1364487093-19551-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If particular platforms require non-standard initialisation values,
they can use this function to adapt them as required.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/mach-ux500/board-mop500-regulators.c |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/arch/arm/mach-ux500/board-mop500-regulators.c b/arch/arm/mach-ux500/board-mop500-regulators.c
index 089cf2a..22dfaf3 100644
--- a/arch/arm/mach-ux500/board-mop500-regulators.c
+++ b/arch/arm/mach-ux500/board-mop500-regulators.c
@@ -476,3 +476,21 @@ struct ab8500_regulator_platform_data ab8500_regulator_plat_data = {
 	.ext_regulator          = ab8500_ext_regulators,
 	.num_ext_regulator      = ARRAY_SIZE(ab8500_ext_regulators),
 };
+
+static void ab8500_modify_reg_init(int id, u8 mask, u8 value)
+{
+	int i;
+
+	for (i = ARRAY_SIZE(ab8500_reg_init) - 1; i >= 0; i--) {
+		if (ab8500_reg_init[i].id == id) {
+			u8 initval = ab8500_reg_init[i].value;
+			initval = (initval & ~mask) | (value & mask);
+			ab8500_reg_init[i].value = initval;
+
+			BUG_ON(mask & ~ab8500_reg_init[i].mask);
+			return;
+		}
+	}
+
+	BUG_ON(1);
+}
-- 
1.7.10.4

