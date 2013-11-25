Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752023Ab3KYV55 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 16:57:57 -0500
Received: from mail-qe0-f43.google.com ([209.85.128.43]:39428 "EHLO
	mail-qe0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751119Ab3KYV54 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 16:57:56 -0500
From: Fabio Estevam <festevam@gmail.com>
To: broonie@kernel.org
Cc: shawn.guo@linaro.org, linux-kernel@vger.kernel.org,
        thierry.reding@gmail.com, Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH] regulator: core: Use postcore_initcall(regulator_init_complete)
Date: Mon, 25 Nov 2013 19:57:35 -0200
Message-Id: <1385416655-7859-1-git-send-email-festevam@gmail.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fabio Estevam <fabio.estevam@freescale.com>

Commit 22ceeee1 (pwm-backlight: Add power supply support) introduced the usage
of regulator API into the pwm backlight driver and caused a regression on some 
boards like mx28evk and mx6qsabresd, resulting in blank display output:

pwm-backlight backlight.18: dummy supplies not allowed

Calling regulator_init_complete via late_initcall can be too 'late' for the 
regulator to be available for the pwm backlight driver.

Call regulator_init_complete with postcore_initcall level instead.

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
 drivers/regulator/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 3fe1313..d908a95 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -3850,4 +3850,4 @@ unlock:
 
 	return 0;
 }
-late_initcall(regulator_init_complete);
+postcore_initcall(regulator_init_complete);
-- 
1.8.1.2

