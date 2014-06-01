Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752344AbaFAMxJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2014 08:53:09 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:37041 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751637AbaFAMxH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2014 08:53:07 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@linaro.org>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Rob Herring <robh+dt@kernel.org>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH] pinctrl: pinctrl-abx500.c:  Cleaning up uninitialized variables
Date: Sun,  1 Jun 2014 14:54:00 +0200
Message-Id: <1401627240-16524-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a risk that the variable will be used without being initialized.

This was largely found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/pinctrl/pinctrl-abx500.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/pinctrl-abx500.c b/drivers/pinctrl/pinctrl-abx500.c
index 163da9c..57802be 100644
--- a/drivers/pinctrl/pinctrl-abx500.c
+++ b/drivers/pinctrl/pinctrl-abx500.c
@@ -164,7 +164,7 @@ static int abx500_gpio_set_bits(struct gpio_chip *chip, u8 reg,
 static int abx500_gpio_get(struct gpio_chip *chip, unsigned offset)
 {
 	struct abx500_pinctrl *pct = to_abx500_pinctrl(chip);
-	bool bit;
+	bool bit = 0;
 	bool is_out;
 	u8 gpio_offset = offset - 1;
 	int ret;
-- 
1.7.10.4

