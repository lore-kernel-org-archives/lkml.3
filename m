Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751943AbaH3Rfy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2014 13:35:54 -0400
Received: from smtp65.ord1c.emailsrvr.com ([108.166.43.65]:48343 "EHLO
	smtp65.ord1c.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751585AbaH3Rfx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2014 13:35:53 -0400
X-Sender-Id: pramod.gurav@smartplayin.com
From: Pramod Gurav <pramod.gurav@smartplayin.com>
To: linux-kernel@vger.kernel.org
Cc: Pramod Gurav <pramod.gurav@smartplayin.com>,
        Sonic Zhang <sonic.zhang@analog.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH] pinctrl: adi2: Remove duplicate gpiochip_remove_pin_ranges from remove function
Date: Sat, 30 Aug 2014 23:05:13 +0530
Message-Id: <1409420113-13731-1-git-send-email-pramod.gurav@smartplayin.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes call to gpiochip_remove_pin_ranges() from platform_driver remove
function as it will anway be called by gpiochip_remove().

CC: Sonic Zhang <sonic.zhang@analog.com>
CC: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Pramod Gurav <pramod.gurav@smartplayin.com>
---
 drivers/pinctrl/pinctrl-adi2.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-adi2.c b/drivers/pinctrl/pinctrl-adi2.c
index b092b93..e9909b9 100644
--- a/drivers/pinctrl/pinctrl-adi2.c
+++ b/drivers/pinctrl/pinctrl-adi2.c
@@ -1041,7 +1041,6 @@ static int adi_gpio_remove(struct platform_device *pdev)
 	u8 offset;
 
 	list_del(&port->node);
-	gpiochip_remove_pin_ranges(&port->chip);
 	gpiochip_remove(&port->chip);
 	if (port->pint) {
 		for (offset = 0; offset < port->width; offset++)
-- 
1.7.0.4

