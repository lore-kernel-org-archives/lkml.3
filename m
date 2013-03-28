Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757322Ab3C1QUr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 12:20:47 -0400
Received: from mail-wg0-f52.google.com ([74.125.82.52]:49489 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756870Ab3C1QMR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 12:12:17 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org, broonie@opensource.wolfsonmicro.com
Cc: Bengt Jonsson <bengt.g.jonsson@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 13/33] regulator: ab8500-ext: Add support for AB8505/AB9540
Date: Thu, 28 Mar 2013 16:11:13 +0000
Message-Id: <1364487093-19551-14-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1364487093-19551-1-git-send-email-lee.jones@linaro.org>
References: <1364487093-19551-1-git-send-email-lee.jones@linaro.org>
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
index 95fe706..c73d544 100644
--- a/drivers/regulator/ab8500-ext.c
+++ b/drivers/regulator/ab8500-ext.c
@@ -385,7 +385,7 @@ int ab8500_ext_regulator_init(struct platform_device *pdev)
 	}
 
 	/* check for AB8500 2.x */
-	if (abx500_get_chip_id(&pdev->dev) < 0x30) {
+	if (is_ab8500_2p0_or_earlier(ab8500)) {
 		struct ab8500_ext_regulator_info *info;
 
 		/* VextSupply3LPn is inverted on AB8500 2.x */
-- 
1.7.10.4

