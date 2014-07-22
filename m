Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753080AbaGVHSZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 03:18:25 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:4646 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753003AbaGVHSW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 03:18:22 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 22 Jul 2014 00:10:34 -0700
From: Alexandre Courbot <acourbot@nvidia.com>
To: Linus Walleij <linus.walleij@linaro.org>
CC: <linux-gpio@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <gnurou@gmail.com>, Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH 1/5] gpio: remove export of private of_get_named_gpio_flags()
Date: Tue, 22 Jul 2014 16:17:39 +0900
Message-ID: <1406013463-19218-2-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <1406013463-19218-1-git-send-email-acourbot@nvidia.com>
References: <1406013463-19218-1-git-send-email-acourbot@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

of_get_named_gpio_flags() has been made gpiolib-private by commit
f01d907582, but its EXPORT statement has not been removed. Fix this.

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
---
 drivers/gpio/gpiolib-of.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/gpio/gpiolib-of.c b/drivers/gpio/gpiolib-of.c
index e60cdab1d15e..3e2fae205bee 100644
--- a/drivers/gpio/gpiolib-of.c
+++ b/drivers/gpio/gpiolib-of.c
@@ -95,7 +95,6 @@ struct gpio_desc *of_get_named_gpiod_flags(struct device_node *np,
 		 PTR_ERR_OR_ZERO(gg_data.out_gpio));
 	return gg_data.out_gpio;
 }
-EXPORT_SYMBOL(of_get_named_gpiod_flags);
 
 int of_get_named_gpio_flags(struct device_node *np, const char *list_name,
 			    int index, enum of_gpio_flags *flags)
-- 
2.0.1

