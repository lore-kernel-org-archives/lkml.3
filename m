Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753041Ab3CEG71 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 01:59:27 -0500
Received: from mail-ie0-f182.google.com ([209.85.223.182]:51725 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753094Ab3CEG7H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 01:59:07 -0500
Message-ID: <1362466733.9427.2.camel@phoenix>
Subject: [PATCH RFT] pinctrl: abx500: Fix checking if pin use
 AlternateFunction register
From: Axel Lin <axel.lin@ingics.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Lee Jones <lee.jones@linaro.org>, linux-kernel@vger.kernel.org
Date: Tue, 05 Mar 2013 14:58:53 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's pointless to check "af.alt_bit1 == UNUSED" twice.
This looks like a copy-paste bug, I think what we want is to check if *both*
af.alt_bit1 and af.alt_bit2 are UNUSED.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
Hi,
I don't have the datasheet and hw.
I'd appreciate if someone can review and test this patch.

Thanks,
Axel
 drivers/pinctrl/pinctrl-abx500.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/pinctrl-abx500.c b/drivers/pinctrl/pinctrl-abx500.c
index e8abc3c..0cf3fa4 100644
--- a/drivers/pinctrl/pinctrl-abx500.c
+++ b/drivers/pinctrl/pinctrl-abx500.c
@@ -422,7 +422,7 @@ static u8 abx500_get_mode(struct pinctrl_dev *pctldev, struct gpio_chip *chip,
 	}
 
 	/* check if pin use AlternateFunction register */
-	if ((af.alt_bit1 == UNUSED) && (af.alt_bit1 == UNUSED))
+	if ((af.alt_bit1 == UNUSED) && (af.alt_bit2 == UNUSED))
 		return mode;
 	/*
 	 * if pin GPIOSEL bit is set and pin supports alternate function,
-- 
1.7.9.5



