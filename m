Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752530AbaAJGDL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 01:03:11 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:37969 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750800AbaAJGDH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 01:03:07 -0500
From: Neil Zhang <zhangwm@marvell.com>
To: <linus.walleij@linaro.org>, <gnurou@gmail.com>,
        <linux-gpio@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Neil Zhang <zhangwm@marvell.com>
Subject: [PATCH] gpio: pxa: normalize the return value for gpio_get
Date: Fri, 10 Jan 2014 14:03:03 +0800
Message-ID: <1389333783-3372-1-git-send-email-zhangwm@marvell.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.87,1.0.14,0.0.0000
 definitions=2014-01-10_02:2014-01-09,2014-01-10,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1305240000 definitions=main-1401090264
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It would be convenient to normalize the return value for gpio_get.

I have checked mach-mmp / mach-pxa / plat-pxa / plat-orion / mach-orion5x.
It's OK for all of them to change this function to return 0 and 1.

Signed-off-by: Neil Zhang <zhangwm@marvell.com>
---
 drivers/gpio/gpio-pxa.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpio/gpio-pxa.c b/drivers/gpio/gpio-pxa.c
index cc13d1b..42e6e64 100644
--- a/drivers/gpio/gpio-pxa.c
+++ b/drivers/gpio/gpio-pxa.c
@@ -263,7 +263,8 @@ static int pxa_gpio_direction_output(struct gpio_chip *chip,
 
 static int pxa_gpio_get(struct gpio_chip *chip, unsigned offset)
 {
-	return readl_relaxed(gpio_chip_base(chip) + GPLR_OFFSET) & (1 << offset);
+	u32 gplr = readl_relaxed(gpio_chip_base(chip) + GPLR_OFFSET);
+	return !!(gplr & (1 << offset));
 }
 
 static void pxa_gpio_set(struct gpio_chip *chip, unsigned offset, int value)
-- 
1.7.9.5

