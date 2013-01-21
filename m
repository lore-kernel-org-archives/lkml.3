Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753101Ab3AUKQt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 05:16:49 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:59484 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753033Ab3AUKJs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 05:09:48 -0500
From: Thierry Reding <thierry.reding@avionic-design.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, Wolfram Sang <w.sang@pengutronix.de>,
        Jonathan Cameron <jic23@cam.ac.uk>, linux-iio@vger.kernel.org
Subject: [PATCH 11/33] iio: Convert to devm_ioremap_resource()
Date: Mon, 21 Jan 2013 11:09:04 +0100
Message-Id: <1358762966-20791-12-git-send-email-thierry.reding@avionic-design.de>
X-Mailer: git-send-email 1.8.1.1
In-Reply-To: <1358762966-20791-1-git-send-email-thierry.reding@avionic-design.de>
References: <1358762966-20791-1-git-send-email-thierry.reding@avionic-design.de>
X-Provags-ID: V02:K0:mGTqJGpp/Kz59gwyr9MKxMIs4zjctdEr4Vqta9xOUio
 ftz8eYRoE2yMUApcF4Bgo9X6jwkn6QA/iu1Gvm+uVaFrk4fxyJ
 Vd8RyK7zsL1ZzujcPTs2nEsRg5O0A37oL5MPhhayyp6v5kM83s
 Tu1OLF4kLQbLKf7SDXQQVxl3BjpygeV5gJPYyLP4Rwyy7ABOyf
 RqX1HZs+K/iE6jAlh0HrTtt5uKgU4FPn1o3w7K8mYPe2g6mz8N
 5kUpzCywAS9OwQhTWPk9PqkJ0cdg4hkSNT5Z4BrCVBmsD1aToD
 O/8TjBrm1hpmzg/44gf/RY033grkY/tcSq5QBf2c0Zz3o6MM9b
 lGOuffKcWp8yVrlvjtK/w2ygophd+54G+4dLERBONYyRRsLSqD
 cUzu9iwEiGMP8KqaTu/Kt5XSNbIiM0kLF95F/gomhV4fiT7Hr5
 tY/me
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert all uses of devm_request_and_ioremap() to the newly introduced
devm_ioremap_resource() which provides more consistent error handling.

Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
Cc: Jonathan Cameron <jic23@cam.ac.uk>
Cc: linux-iio@vger.kernel.org
---
 drivers/iio/adc/at91_adc.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/iio/adc/at91_adc.c b/drivers/iio/adc/at91_adc.c
index a526c0e..83c836b 100644
--- a/drivers/iio/adc/at91_adc.c
+++ b/drivers/iio/adc/at91_adc.c
@@ -557,9 +557,9 @@ static int at91_adc_probe(struct platform_device *pdev)
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 
-	st->reg_base = devm_request_and_ioremap(&pdev->dev, res);
-	if (!st->reg_base) {
-		ret = -ENOMEM;
+	st->reg_base = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(st->reg_base)) {
+		ret = PTR_ERR(st->reg_base);
 		goto error_free_device;
 	}
 
-- 
1.8.1.1

