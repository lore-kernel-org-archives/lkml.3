Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751587AbaKKREi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 12:04:38 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:53302 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751534AbaKKREg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 12:04:36 -0500
Date: Tue, 11 Nov 2014 17:04:32 +0000
From: Richard Fitzgerald <rf@opensource.wolfsonmicro.com>
To: lee.jones@linaro.org, broonie@kernel.org, linus.walleij@linaro.org,
        gnurou@gmail.com
Cc: lgirdwood@gmail.com, perex@perex.cz, tiwai@suse.de,
        linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org, patches@opensource.wolfsonmicro.com,
        ckeepax@opensource.wolfsonmicro.com
Subject: [PATCH 2/3] gpio: arizona: Add support for CS47L24
Message-ID: <20141111170432.GB25738@opensource.wolfsonmicro.com>
References: <20141111165227.GA24344@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141111165227.GA24344@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Richard Fitzgerald <rf@opensource.wolfsonmicro.com>
---
 drivers/gpio/gpio-arizona.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/gpio/gpio-arizona.c b/drivers/gpio/gpio-arizona.c
index fe369f5..9e29ed0 100644
--- a/drivers/gpio/gpio-arizona.c
+++ b/drivers/gpio/gpio-arizona.c
@@ -1,6 +1,7 @@
 /*
  * gpiolib support for Wolfson Arizona class devices
  *
+ * Copyright 2014 CirrusLogic, Inc.
  * Copyright 2012 Wolfson Microelectronics PLC.
  *
  * Author: Mark Brown <broonie@opensource.wolfsonmicro.com>
@@ -119,6 +120,10 @@ static int arizona_gpio_probe(struct platform_device *pdev)
 	case WM8997:
 		arizona_gpio->gpio_chip.ngpio = 5;
 		break;
+	case WM1831:
+	case CS47L24:
+		arizona_gpio->gpio_chip.ngpio = 2;
+		break;
 	default:
 		dev_err(&pdev->dev, "Unknown chip variant %d\n",
 			arizona->type);
-- 
1.7.2.5


