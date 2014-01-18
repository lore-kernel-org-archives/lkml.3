Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753343AbaARExT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 23:53:19 -0500
Received: from mail-pb0-f52.google.com ([209.85.160.52]:34137 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752066AbaARExQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 23:53:16 -0500
From: SeongJae Park <sj38.park@gmail.com>
To: gregkh@linuxfoundation.org, linus.walleij@linaro.org, gnurou@gmail.com
Cc: linux-gpio@vger.kernle.org, linux-kernel@vger.kernel.org,
        SeongJae Park <sj38.park@gmail.com>
Subject: [PATCH] gpio: mcp23s08: fix casting caused build warning
Date: Sat, 18 Jan 2014 13:53:04 +0900
Message-Id: <1390020784-21292-1-git-send-email-sj38.park@gmail.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: SeongJae Park <sj38.park@gmail.com>
---
 drivers/gpio/gpio-mcp23s08.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpio/gpio-mcp23s08.c b/drivers/gpio/gpio-mcp23s08.c
index b16401e..97198ef 100644
--- a/drivers/gpio/gpio-mcp23s08.c
+++ b/drivers/gpio/gpio-mcp23s08.c
@@ -640,7 +640,7 @@ static int mcp23s08_probe(struct spi_device *spi)
 
 	match = of_match_device(of_match_ptr(mcp23s08_spi_of_match), &spi->dev);
 	if (match) {
-		type = (int)match->data;
+		type = (int)(uintptr_t)match->data;
 		status = of_property_read_u32(spi->dev.of_node,
 			    "microchip,spi-present-mask", &spi_present_mask);
 		if (status) {
-- 
1.8.3.2

