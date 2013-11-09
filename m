Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758455Ab3KIXgT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Nov 2013 18:36:19 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:39935 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758334Ab3KIXgS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Nov 2013 18:36:18 -0500
Date: Sun, 10 Nov 2013 02:35:56 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Linus Walleij <linus.walleij@linaro.org>,
        Patrice CHOTARD <patrice.chotard@st.com>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] pinctrl: abx500: fix some more bitwise AND tests
Message-ID: <20131109233556.GA13643@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I sent a patch to fix some bitwise AND tests but I guess I missed some.
Sorry about that.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/pinctrl/pinctrl-abx500.c b/drivers/pinctrl/pinctrl-abx500.c
index 4780959..5183e7bb 100644
--- a/drivers/pinctrl/pinctrl-abx500.c
+++ b/drivers/pinctrl/pinctrl-abx500.c
@@ -418,7 +418,7 @@ static int abx500_set_mode(struct pinctrl_dev *pctldev, struct gpio_chip *chip,
 			ret = abx500_gpio_set_bits(chip,
 					AB8500_GPIO_ALTFUN_REG,
 					af.alt_bit1,
-					!!(af.alta_val && BIT(0)));
+					!!(af.alta_val & BIT(0)));
 			if (ret < 0)
 				goto out;
 
@@ -439,7 +439,7 @@ static int abx500_set_mode(struct pinctrl_dev *pctldev, struct gpio_chip *chip,
 			goto out;
 
 		ret = abx500_gpio_set_bits(chip, AB8500_GPIO_ALTFUN_REG,
-				af.alt_bit1, !!(af.altb_val && BIT(0)));
+				af.alt_bit1, !!(af.altb_val & BIT(0)));
 		if (ret < 0)
 			goto out;
 
@@ -462,7 +462,7 @@ static int abx500_set_mode(struct pinctrl_dev *pctldev, struct gpio_chip *chip,
 			goto out;
 
 		ret = abx500_gpio_set_bits(chip, AB8500_GPIO_ALTFUN_REG,
-				af.alt_bit2, !!(af.altc_val && BIT(1)));
+				af.alt_bit2, !!(af.altc_val & BIT(1)));
 		break;
 
 	default:
