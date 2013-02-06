Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757410Ab3BFKzS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 05:55:18 -0500
Received: from mail-we0-f171.google.com ([74.125.82.171]:63171 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757294Ab3BFKzE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 05:55:04 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: broonie@opensource.wolfsonmicro.com, linus.walleij@linaro.org,
        Bengt Jonsson <bengt.g.jonsson@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 25/49] regulator: ab8500-ext: Add support for AB8505/AB9540
Date: Wed,  6 Feb 2013 10:53:47 +0000
Message-Id: <1360148051-7560-26-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1360148051-7560-1-git-send-email-lee.jones@linaro.org>
References: <1360148051-7560-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bengt Jonsson <bengt.g.jonsson@stericsson.com>

The external regulator driver checks for old AB8500 HW
to apply a fix. This patch adds a check to see that
it is a AB8500 (not AB8505/AB9540).

Signed-off-by: Bengt Jonsson <bengt.g.jonsson@stericsson.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/regulator/ab8500-ext.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/ab8500-ext.c b/drivers/regulator/ab8500-ext.c
index 3af40fd..f3ec867 100644
--- a/drivers/regulator/ab8500-ext.c
+++ b/drivers/regulator/ab8500-ext.c
@@ -386,7 +386,7 @@ int ab8500_ext_regulator_init(struct platform_device *pdev)
 	}
 
 	/* check for AB8500 2.x */
-	if (abx500_get_chip_id(&pdev->dev) < 0x30) {
+	if (is_ab8500_2p0_or_earlier(ab8500)) {
 		struct ab8500_ext_regulator_info *info;
 
 		/* VextSupply3LPn is inverted on AB8500 2.x */
-- 
1.7.9.5

