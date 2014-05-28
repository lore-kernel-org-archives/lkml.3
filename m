Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754964AbaE1RM1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 13:12:27 -0400
Received: from top.free-electrons.com ([176.31.233.9]:46298 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752882AbaE1RL2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 13:11:28 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: carlo@caione.org, Boris Brezillon <boris@free-electrons.com>,
        Mark Brown <broonie@kernel.org>, lgirdwood@gmail.com,
        lee.jones@linaro.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kevin.z.m.zh@gmail.com, sunny@allwinnertech.com,
        shuge@allwinnertech.com, zhuzhenhua@allwinnertech.com,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH 4/5] mfd: axp209x: Drop the parent supplies field
Date: Wed, 28 May 2014 19:11:08 +0200
Message-Id: <1401297069-7423-5-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1401297069-7423-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1401297069-7423-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that the regulator code get its parent supplies purely from the DT, we can
drop the parent supplies resources in the MFD driver.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 drivers/mfd/axp20x.c | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/drivers/mfd/axp20x.c b/drivers/mfd/axp20x.c
index 5734f8c82abf..6231adbb295d 100644
--- a/drivers/mfd/axp20x.c
+++ b/drivers/mfd/axp20x.c
@@ -140,15 +140,6 @@ static const struct regmap_irq_chip axp20x_regmap_irq_chip = {
 	.init_ack_masked	= true,
 };
 
-static const char * axp20x_supplies[] = {
-	"acin",
-	"vin2",
-	"vin3",
-	"ldo24in",
-	"ldo3in",
-	"ldo5in",
-};
-
 static struct mfd_cell axp20x_cells[] = {
 	{
 		.name			= "axp20x-pek",
@@ -156,8 +147,6 @@ static struct mfd_cell axp20x_cells[] = {
 		.resources		= axp20x_pek_resources,
 	}, {
 		.name			= "axp20x-regulator",
-		.parent_supplies	= axp20x_supplies,
-		.num_parent_supplies	= ARRAY_SIZE(axp20x_supplies),
 	},
 };
 
-- 
1.9.3

