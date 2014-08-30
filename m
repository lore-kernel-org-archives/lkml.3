Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751539AbaH3LN3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2014 07:13:29 -0400
Received: from smtp105.ord1c.emailsrvr.com ([108.166.43.105]:56753 "EHLO
	smtp105.ord1c.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751287AbaH3LN1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2014 07:13:27 -0400
X-Sender-Id: pramod.gurav@smartplayin.com
From: Pramod Gurav <pramod.gurav@smartplayin.com>
To: linux-kernel@vger.kernel.org
Cc: Pramod Gurav <pramod.gurav@smartplayin.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Barry Song <Baohua.Song@csr.com>, Rongjun Ying <rongjun.ying@csr.com>,
        Yuping Luo <yuping.luo@csr.com>
Subject: [PATCH] pinctrl: sirf: Remove gpiochip  on failure cases
Date: Sat, 30 Aug 2014 16:43:00 +0530
Message-Id: <1409397180-32736-1-git-send-email-pramod.gurav@smartplayin.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch releases gpiochip related resources by calling
gpiochip_remove when gpiochip_irqchip_add fails.

CC: Linus Walleij <linus.walleij@linaro.org>
CC: Barry Song <Baohua.Song@csr.com>
CC: Rongjun Ying <rongjun.ying@csr.com>
CC: Yuping Luo <yuping.luo@csr.com>
Signed-off-by: Pramod Gurav <pramod.gurav@smartplayin.com>
---
 drivers/pinctrl/sirf/pinctrl-sirf.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/pinctrl/sirf/pinctrl-sirf.c b/drivers/pinctrl/sirf/pinctrl-sirf.c
index 4c1d7c6..66c1837 100644
--- a/drivers/pinctrl/sirf/pinctrl-sirf.c
+++ b/drivers/pinctrl/sirf/pinctrl-sirf.c
@@ -839,7 +839,7 @@ static int sirfsoc_gpio_probe(struct device_node *np)
 	if (err) {
 		dev_err(&pdev->dev,
 			"could not connect irqchip to gpiochip\n");
-		goto out;
+		goto out_banks;
 	}
 
 	for (i = 0; i < SIRFSOC_GPIO_NO_OF_BANKS; i++) {
-- 
1.7.0.4

