Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753319Ab3CKOXr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 10:23:47 -0400
Received: from mail-bk0-f49.google.com ([209.85.214.49]:60207 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752341Ab3CKOXq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 10:23:46 -0400
MIME-Version: 1.0
Date: Mon, 11 Mar 2013 22:23:45 +0800
Message-ID: <CAPgLHd9n7nmyhUcRgPwEyjweZKA+fgi409yEJgK6LmF2Wu6n-g@mail.gmail.com>
Subject: [PATCH -next] pinctrl: sirf: using for_each_set_bit to simplify the code
From: Wei Yongjun <weiyj.lk@gmail.com>
To: baohua.song@csr.com, linus.walleij@linaro.org, grant.likely@secretlab.ca,
        rob.herring@calxeda.com
Cc: yongjun_wei@trendmicro.com.cn, linux-arm-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Using for_each_set_bit() to simplify the code.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/pinctrl/pinctrl-sirf.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-sirf.c b/drivers/pinctrl/pinctrl-sirf.c
index 498b2ba..d6cf500 100644
--- a/drivers/pinctrl/pinctrl-sirf.c
+++ b/drivers/pinctrl/pinctrl-sirf.c
@@ -1669,15 +1669,12 @@ static void sirfsoc_gpio_set_pullup(const u32 *pullups)
 	const unsigned long *p = (const unsigned long *)pullups;
 
 	for (i = 0; i < SIRFSOC_GPIO_NO_OF_BANKS; i++) {
-		n = find_first_bit(p + i, BITS_PER_LONG);
-		while (n < BITS_PER_LONG) {
+		for_each_set_bit(n, p + i, BITS_PER_LONG) {
 			u32 offset = SIRFSOC_GPIO_CTRL(i, n);
 			u32 val = readl(sgpio_bank[i].chip.regs + offset);
 			val |= SIRFSOC_GPIO_CTL_PULL_MASK;
 			val |= SIRFSOC_GPIO_CTL_PULL_HIGH;
 			writel(val, sgpio_bank[i].chip.regs + offset);
-
-			n = find_next_bit(p + i, BITS_PER_LONG, n + 1);
 		}
 	}
 }
@@ -1688,15 +1685,12 @@ static void sirfsoc_gpio_set_pulldown(const u32 *pulldowns)
 	const unsigned long *p = (const unsigned long *)pulldowns;
 
 	for (i = 0; i < SIRFSOC_GPIO_NO_OF_BANKS; i++) {
-		n = find_first_bit(p + i, BITS_PER_LONG);
-		while (n < BITS_PER_LONG) {
+		for_each_set_bit(n, p + i, BITS_PER_LONG) {
 			u32 offset = SIRFSOC_GPIO_CTRL(i, n);
 			u32 val = readl(sgpio_bank[i].chip.regs + offset);
 			val |= SIRFSOC_GPIO_CTL_PULL_MASK;
 			val &= ~SIRFSOC_GPIO_CTL_PULL_HIGH;
 			writel(val, sgpio_bank[i].chip.regs + offset);
-
-			n = find_next_bit(p + i, BITS_PER_LONG, n + 1);
 		}
 	}
 }

