Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760834AbaEMJ6Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 05:58:24 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:60835 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760079AbaEMJ24 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 05:28:56 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Charles Keepax <ckeepax@opensource.wolfsonmicro.com>,
        Mark Brown <broonie@linaro.org>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 052/182] regulator: arizona-ldo1: Correct default regulator init_data
Date: Tue, 13 May 2014 11:26:44 +0200
Message-Id: <c710bb21a8881d7312d780464faf43be4c6f9a7d.1399973152.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
References: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
In-Reply-To: <cover.1399973152.git.jslaby@suse.cz>
References: <cover.1399973152.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit a35ff2861690eaf9dbb38fa744a8a9e6f4ebfd61 upstream.

Both 5102 and 8997 have the regulator capable of supplying 1.8V, and the
voltage step from the 5110 regulator is different from what is specified
in the default description. This patch updates the default regulator
description to match 5110 and selects the 1.8V capable description for
8997.

Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Signed-off-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/regulator/arizona-ldo1.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/regulator/arizona-ldo1.c b/drivers/regulator/arizona-ldo1.c
index 81d8681c3195..7917bb2fa834 100644
--- a/drivers/regulator/arizona-ldo1.c
+++ b/drivers/regulator/arizona-ldo1.c
@@ -153,11 +153,9 @@ static const struct regulator_desc arizona_ldo1 = {
 
 	.vsel_reg = ARIZONA_LDO1_CONTROL_1,
 	.vsel_mask = ARIZONA_LDO1_VSEL_MASK,
-	.bypass_reg = ARIZONA_LDO1_CONTROL_1,
-	.bypass_mask = ARIZONA_LDO1_BYPASS,
 	.min_uV = 900000,
-	.uV_step = 50000,
-	.n_voltages = 7,
+	.uV_step = 25000,
+	.n_voltages = 13,
 	.enable_time = 500,
 
 	.owner = THIS_MODULE,
@@ -203,6 +201,7 @@ static int arizona_ldo1_probe(struct platform_device *pdev)
 	 */
 	switch (arizona->type) {
 	case WM5102:
+	case WM8997:
 		desc = &arizona_ldo1_hc;
 		ldo1->init_data = arizona_ldo1_dvfs;
 		break;
-- 
1.9.3

