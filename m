Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932365AbaAWOUK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 09:20:10 -0500
Received: from mail-we0-f177.google.com ([74.125.82.177]:53417 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932104AbaAWOUI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 09:20:08 -0500
From: Linus Walleij <linus.walleij@linaro.org>
To: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        linux-kernel@vger.kernel.org
Cc: Lee Jones <lee.jones@linaro.org>, Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH] regulator: ab3100: cast fix
Date: Thu, 23 Jan 2014 15:20:01 +0100
Message-Id: <1390486801-4839-1-git-send-email-linus.walleij@linaro.org>
X-Mailer: git-send-email 1.8.4.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The AB3100 regulator driver emits a warning when compiled on 64bit
systems like this:

drivers/regulator/ab3100.c:
In function ‘ab3100_regulator_of_probe’:
srivers/regulator/ab3100.c:649:4:
warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]

As the int is a different size than the 64bit pointer used to
pass regulator data. Switch to using an unsigned long as ID
passed for the regulator to get rid of the warning.

Reported-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/regulator/ab3100.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/ab3100.c b/drivers/regulator/ab3100.c
index 77b46d0b37a6..e10febe9ec34 100644
--- a/drivers/regulator/ab3100.c
+++ b/drivers/regulator/ab3100.c
@@ -498,7 +498,7 @@ static int ab3100_regulator_register(struct platform_device *pdev,
 				     struct ab3100_platform_data *plfdata,
 				     struct regulator_init_data *init_data,
 				     struct device_node *np,
-				     int id)
+				     unsigned long id)
 {
 	struct regulator_desc *desc;
 	struct ab3100_regulator *reg;
@@ -646,7 +646,7 @@ ab3100_regulator_of_probe(struct platform_device *pdev, struct device_node *np)
 		err = ab3100_regulator_register(
 			pdev, NULL, ab3100_regulator_matches[i].init_data,
 			ab3100_regulator_matches[i].of_node,
-			(int) ab3100_regulator_matches[i].driver_data);
+			(unsigned long)ab3100_regulator_matches[i].driver_data);
 		if (err) {
 			ab3100_regulators_remove(pdev);
 			return err;
-- 
1.8.4.2

