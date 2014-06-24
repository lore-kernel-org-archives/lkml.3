Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751165AbaFXCT7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 22:19:59 -0400
Received: from cpanel09.rubas.ch ([195.182.222.79]:37276 "EHLO
	cpanel09.rubas.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751014AbaFXCT6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 22:19:58 -0400
From: =?UTF-8?q?J=C3=BCrg=20Billeter?= <j@bitron.ch>
To: Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>
Cc: Magnus Damm <damm@opensource.se>, linux-gpio@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        =?UTF-8?q?J=C3=BCrg=20Billeter?= <j@bitron.ch>
Subject: [PATCH] gpio: rcar: clamp returned value to [0,1]
Date: Tue, 24 Jun 2014 04:19:50 +0200
Message-Id: <1403576390-28381-1-git-send-email-j@bitron.ch>
X-Mailer: git-send-email 2.0.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - cpanel09.rubas.ch
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - bitron.ch
X-Get-Message-Sender-Via: cpanel09.rubas.ch: authenticated_id: juerg@bitron.ch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While it will be clamped to bool by gpiolib, let's make this sane
in the driver as well.

Signed-off-by: Jürg Billeter <j@bitron.ch>
---
 drivers/gpio/gpio-rcar.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpio/gpio-rcar.c b/drivers/gpio/gpio-rcar.c
index 0c9f803..7c62121 100644
--- a/drivers/gpio/gpio-rcar.c
+++ b/drivers/gpio/gpio-rcar.c
@@ -240,9 +240,9 @@ static int gpio_rcar_get(struct gpio_chip *chip, unsigned offset)
 	/* testing on r8a7790 shows that INDT does not show correct pin state
 	 * when configured as output, so use OUTDT in case of output pins */
 	if (gpio_rcar_read(gpio_to_priv(chip), INOUTSEL) & bit)
-		return (int)(gpio_rcar_read(gpio_to_priv(chip), OUTDT) & bit);
+		return !!(gpio_rcar_read(gpio_to_priv(chip), OUTDT) & bit);
 	else
-		return (int)(gpio_rcar_read(gpio_to_priv(chip), INDT) & bit);
+		return !!(gpio_rcar_read(gpio_to_priv(chip), INDT) & bit);
 }
 
 static void gpio_rcar_set(struct gpio_chip *chip, unsigned offset, int value)
-- 
2.0.0

