Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755138Ab3BDL47 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 06:56:59 -0500
Received: from mail-wi0-f176.google.com ([209.85.212.176]:50565 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754594Ab3BDL4x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 06:56:53 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org, broonie@opensource.wolfsonmicro.com
Cc: Bengt Jonsson <bengt.g.jonsson@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 35/73] regulator: ab8500-ext: Add support for AB8505/AB9540
Date: Mon,  4 Feb 2013 11:53:50 +0000
Message-Id: <1359978868-28736-36-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1359978868-28736-1-git-send-email-lee.jones@linaro.org>
References: <1359978868-28736-1-git-send-email-lee.jones@linaro.org>
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

