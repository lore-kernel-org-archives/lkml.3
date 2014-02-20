Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754967AbaBTI7l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 03:59:41 -0500
Received: from mail-pb0-f44.google.com ([209.85.160.44]:58066 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754927AbaBTI7h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 03:59:37 -0500
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: broonie@kernel.org, lgirdwood@gmail.com, sachin.kamat@linaro.org
Subject: [PATCH 16/23] regulator: tps6524x: Remove redundant error message
Date: Thu, 20 Feb 2014 14:23:16 +0530
Message-Id: <1392886403-10640-16-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1392886403-10640-1-git-send-email-sachin.kamat@linaro.org>
References: <1392886403-10640-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kzalloc prints its own OOM message upon failure.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/regulator/tps6524x-regulator.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/regulator/tps6524x-regulator.c b/drivers/regulator/tps6524x-regulator.c
index 9f6bfda711b7..5b494db9f95c 100644
--- a/drivers/regulator/tps6524x-regulator.c
+++ b/drivers/regulator/tps6524x-regulator.c
@@ -593,10 +593,9 @@ static int pmic_probe(struct spi_device *spi)
 	}
 
 	hw = devm_kzalloc(&spi->dev, sizeof(struct tps6524x), GFP_KERNEL);
-	if (!hw) {
-		dev_err(dev, "cannot allocate regulator private data\n");
+	if (!hw)
 		return -ENOMEM;
-	}
+
 	spi_set_drvdata(spi, hw);
 
 	memset(hw, 0, sizeof(struct tps6524x));
-- 
1.7.9.5

