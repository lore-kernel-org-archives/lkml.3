Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752057Ab3JTWPM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Oct 2013 18:15:12 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:1497 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751877Ab3JTWPJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Oct 2013 18:15:09 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Sun, 20 Oct 2013 15:10:32 -0700
From: Alexandre Courbot <acourbot@nvidia.com>
To: Linus Walleij <linus.walleij@linaro.org>
CC: <linux-gpio@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <gnurou@gmail.com>, Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH 1/3] gpiolib: devres: fix devm_gpiod_get_index()
Date: Sun, 20 Oct 2013 15:14:57 -0700
Message-ID: <1382307299-22587-2-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 1.8.4.1
In-Reply-To: <1382307299-22587-1-git-send-email-acourbot@nvidia.com>
References: <1382307299-22587-1-git-send-email-acourbot@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the return value if devm_gpiod_get_index(). It was returning 0 while
it should return the obtained GPIO descriptor.

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
---
 drivers/gpio/devres.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpio/devres.c b/drivers/gpio/devres.c
index 2caa257..fceebdc 100644
--- a/drivers/gpio/devres.c
+++ b/drivers/gpio/devres.c
@@ -80,7 +80,7 @@ struct gpio_desc *__must_check devm_gpiod_get_index(struct device *dev,
 	*dr = desc;
 	devres_add(dev, dr);
 
-	return 0;
+	return desc;
 }
 EXPORT_SYMBOL(devm_gpiod_get_index);
 
-- 
1.8.4.1

