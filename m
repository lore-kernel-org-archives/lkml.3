Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756769AbaEDQqf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 12:46:35 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36036 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753937AbaEDPlf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 11:41:35 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Charles Keepax <ckeepax@opensource.wolfsonmicro.com>,
        Mark Brown <broonie@linaro.org>
Subject: [PATCH 3.14 061/158] regulator: arizona-ldo1: Correct default regulator init_data
Date: Sun,  4 May 2014 11:39:30 -0400
Message-Id: <20140504154038.235697102@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140504154029.975081050@linuxfoundation.org>
References: <20140504154029.975081050@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>

commit a35ff2861690eaf9dbb38fa744a8a9e6f4ebfd61 upstream.

Both 5102 and 8997 have the regulator capable of supplying 1.8V, and the
voltage step from the 5110 regulator is different from what is specified
in the default description. This patch updates the default regulator
description to match 5110 and selects the 1.8V capable description for
8997.

Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Signed-off-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/regulator/arizona-ldo1.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/drivers/regulator/arizona-ldo1.c
+++ b/drivers/regulator/arizona-ldo1.c
@@ -153,11 +153,9 @@ static const struct regulator_desc arizo
 
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
@@ -203,6 +201,7 @@ static int arizona_ldo1_probe(struct pla
 	 */
 	switch (arizona->type) {
 	case WM5102:
+	case WM8997:
 		desc = &arizona_ldo1_hc;
 		ldo1->init_data = arizona_ldo1_dvfs;
 		break;


