Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757899AbaD3ICT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 04:02:19 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:46812 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751060AbaD3ICK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 04:02:10 -0400
From: Toby Smith <toby@tismith.id.au>
To: linus.walleij@linaro.org, gnurou@gmail.com, grant.likely@linaro.org,
        robh+dt@kernel.org
Cc: linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Toby Smith <toby@tismith.id.au>
Subject: [PATCH 2/2] gpio: pca953x: request a shared interrupt
Date: Wed, 30 Apr 2014 18:01:41 +1000
Message-Id: <8d517ae1adc265643ff9de4b1a2d1b65a4bb6997.1398844809.git.toby@tismith.id.au>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <cover.1398844809.git.toby@tismith.id.au>
References: <cover.1398844809.git.toby@tismith.id.au>
In-Reply-To: <cover.1398844809.git.toby@tismith.id.au>
References: <cover.1398844809.git.toby@tismith.id.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Request a shared interrupt when requesting a pca953x GPIO interrupt

Signed-off-by: Toby Smith <toby@tismith.id.au>
---
 drivers/gpio/gpio-pca953x.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpio/gpio-pca953x.c b/drivers/gpio/gpio-pca953x.c
index 83cc2c8..6398f8a 100644
--- a/drivers/gpio/gpio-pca953x.c
+++ b/drivers/gpio/gpio-pca953x.c
@@ -586,7 +586,8 @@ static int pca953x_irq_setup(struct pca953x_chip *chip,
 					client->irq,
 					   NULL,
 					   pca953x_irq_handler,
-					   IRQF_TRIGGER_LOW | IRQF_ONESHOT,
+					   IRQF_TRIGGER_LOW | IRQF_ONESHOT |
+						   IRQF_SHARED,
 					   dev_name(&client->dev), chip);
 		if (ret) {
 			dev_err(&client->dev, "failed to request irq %d\n",
-- 
1.8.3.2

