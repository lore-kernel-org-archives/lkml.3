Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751332Ab3LPFhV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 00:37:21 -0500
Received: from mail-oa0-f41.google.com ([209.85.219.41]:53603 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750839Ab3LPFhU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 00:37:20 -0500
MIME-Version: 1.0
Date: Sun, 15 Dec 2013 21:37:19 -0800
Message-ID: <CAJuevmANPg28tBovqT7PFBHorjVeh0SiBEkcmfocJMwy8NX5fg@mail.gmail.com>
Subject: [PATCH] REGULATOR: s2mps11: fix regmap, renamed to regmap_pmic
From: Stephen Engelman <stephen.engelman@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Sangbeom Kim <sbkim73@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change regmap to regmap_pmic.  This is needed for commit
3e1e4a5f3a324502c27c4e8808e06ac2ea842360 ("mfd/rtc: s5m: fix register
updating by adding regmap for RTC") to rename regmap to regmap_pmic in
include/linux/mfd/samsung/core.h.

Signed-off-by: Stephen Engelman <stephen.engelman@gmail.com>
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Sangbeom Kim <sbkim73@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Mark Brown <broonie@kernel.org>

---
 drivers/regulator/s2mps11.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/s2mps11.c b/drivers/regulator/s2mps11.c
index 333677d..9e61922 100644
--- a/drivers/regulator/s2mps11.c
+++ b/drivers/regulator/s2mps11.c
@@ -438,7 +438,7 @@ common_reg:
        platform_set_drvdata(pdev, s2mps11);

        config.dev = &pdev->dev;
-       config.regmap = iodev->regmap;
+       config.regmap = iodev->regmap_pmic;
        config.driver_data = s2mps11;
        for (i = 0; i < S2MPS11_REGULATOR_MAX; i++) {
                if (!reg_np) {
