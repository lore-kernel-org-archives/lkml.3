Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755093Ab3BDMFc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 07:05:32 -0500
Received: from mail-wg0-f44.google.com ([74.125.82.44]:48115 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755222Ab3BDL5O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 06:57:14 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org, broonie@opensource.wolfsonmicro.com
Cc: Marcus Cooper <marcus.xm.cooper@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 44/73] regulator: ab8500: Vaux5/6 cannot be disabled on the AB8540
Date: Mon,  4 Feb 2013 11:53:59 +0000
Message-Id: <1359978868-28736-45-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1359978868-28736-1-git-send-email-lee.jones@linaro.org>
References: <1359978868-28736-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marcus Cooper <marcus.xm.cooper@stericsson.com>

Add the flags to correctly configure the Vaux5/6 registers for
AB8540 based platforms.

Signed-off-by: Marcus Cooper <marcus.xm.cooper@stericsson.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Reviewed-by: Mattias WALLIN <mattias.wallin@stericsson.com>
---
 drivers/regulator/ab8500.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/regulator/ab8500.c b/drivers/regulator/ab8500.c
index 2a08642..c204380 100644
--- a/drivers/regulator/ab8500.c
+++ b/drivers/regulator/ab8500.c
@@ -740,10 +740,10 @@ static struct ab8500_regulator_info
 		/* values for CtrlVaux5 register */
 		.update_bank		= 0x01,
 		.update_reg		= 0x55,
-		.update_mask		= 0x08,
-		.update_val		= 0x00,
-		.update_val_idle	= 0x01,
-		.update_val_normal	= 0x00,
+		.update_mask		= 0x18,
+		.update_val		= 0x10,
+		.update_val_idle	= 0x18,
+		.update_val_normal	= 0x10,
 		.voltage_bank		= 0x01,
 		.voltage_reg		= 0x55,
 		.voltage_mask		= 0x07,
@@ -765,10 +765,10 @@ static struct ab8500_regulator_info
 		/* values for CtrlVaux6 register */
 		.update_bank		= 0x01,
 		.update_reg		= 0x56,
-		.update_mask		= 0x08,
-		.update_val		= 0x00,
-		.update_val_idle	= 0x01,
-		.update_val_normal	= 0x00,
+		.update_mask		= 0x18,
+		.update_val		= 0x10,
+		.update_val_idle	= 0x18,
+		.update_val_normal	= 0x10,
 		.voltage_bank		= 0x01,
 		.voltage_reg		= 0x56,
 		.voltage_mask		= 0x07,
-- 
1.7.9.5

