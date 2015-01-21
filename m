Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753851AbbAUVei (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 16:34:38 -0500
Received: from 7of9.schinagl.nl ([88.159.158.68]:39409 "EHLO 7of9.schinagl.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752308AbbAUVeR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 16:34:17 -0500
From: Olliver Schinagl <o.schinagl@ultimaker.com>
To: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Bryan Wu <cooloney@gmail.com>, Richard Purdie <rpurdie@rpsys.net>,
        Olliver Schinagl <oliver@schinagl.nl>,
        Robin Gong <b38343@freescale.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Aaron Lu <aaron.lu@intel.com>, Grant Likely <grant.likely@linaro.org>,
        Jingoo Han <jg1.han@samsung.com>, Alexander Shiyan <shc_work@mail.ru>,
        Wolfram Sang <wsa@the-dreams.de>
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-gpio@vger.kernel.org, linux-input@vger.kernel.org,
        linux-leds@vger.kernel.org
Subject: [PATCH v2 1/4] gpio: use sizeof() instead of hardcoded values
Date: Wed, 21 Jan 2015 22:33:45 +0100
Message-Id: <1421876028-22799-2-git-send-email-o.schinagl@ultimaker.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1421876028-22799-1-git-send-email-o.schinagl@ultimaker.com>
References: <1421876028-22799-1-git-send-email-o.schinagl@ultimaker.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Olliver Schinagl <oliver@schinagl.nl>

gpiolib uses a fixed string for the suffixes and defines it at 32 bytes.
Later in the code snprintf is used with this fixed value of 32. Using
sizeof() is safer in case the size for the suffixes is ever changed.

Signed-off-by: Olliver Schinagl <oliver@schinagl.nl>
---
 drivers/gpio/gpiolib.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index c926641..bf6016d 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -1665,9 +1665,11 @@ static struct gpio_desc *of_find_gpio(struct device *dev, const char *con_id,
 
 	for (i = 0; i < ARRAY_SIZE(suffixes); i++) {
 		if (con_id)
-			snprintf(prop_name, 32, "%s-%s", con_id, suffixes[i]);
+			snprintf(prop_name, sizeof(prop_name), "%s-%s", con_id,
+							       suffixes[i]);
 		else
-			snprintf(prop_name, 32, "%s", suffixes[i]);
+			snprintf(prop_name, sizeof(prop_name), "%s",
+							       suffixes[i]);
 
 		desc = of_get_named_gpiod_flags(dev->of_node, prop_name, idx,
 						&of_flags);
-- 
2.1.4

