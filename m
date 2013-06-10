Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753574Ab3FJLuQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 07:50:16 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:64916 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753494Ab3FJLuL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 07:50:11 -0400
From: Tushar Behera <tushar.behera@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: thierry.reding@gmail.com, patches@linaro.org, linux-gpio@vger.kernel.org,
        Grant Likely <grant.likely@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 05/15] gpio-sta2x11: Convert to use devm_ioremap_resource
Date: Mon, 10 Jun 2013 17:05:03 +0530
Message-Id: <1370864113-17895-6-git-send-email-tushar.behera@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1370864113-17895-1-git-send-email-tushar.behera@linaro.org>
References: <1370864113-17895-1-git-send-email-tushar.behera@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 75096579c3ac ("lib: devres: Introduce devm_ioremap_resource()")
introduced devm_ioremap_resource() and deprecated the use of
devm_request_and_ioremap().

Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
CC: linux-gpio@vger.kernel.org
CC: Grant Likely <grant.likely@linaro.org>
CC: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/gpio/gpio-sta2x11.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpio/gpio-sta2x11.c b/drivers/gpio/gpio-sta2x11.c
index 5585425..c977c14 100644
--- a/drivers/gpio/gpio-sta2x11.c
+++ b/drivers/gpio/gpio-sta2x11.c
@@ -372,7 +372,9 @@ static int gsta_probe(struct platform_device *dev)
 
 	chip = devm_kzalloc(&dev->dev, sizeof(*chip), GFP_KERNEL);
 	chip->dev = &dev->dev;
-	chip->reg_base = devm_request_and_ioremap(&dev->dev, res);
+	chip->reg_base = devm_ioremap_resource(&dev->dev, res);
+	if (IS_ERR(chip->reg_base))
+		return PTR_ERR(chip->reg_base);
 
 	for (i = 0; i < GSTA_NR_BLOCKS; i++) {
 		chip->regs[i] = chip->reg_base + i * 4096;
-- 
1.7.9.5

