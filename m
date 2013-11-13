Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751987Ab3KMW7Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 17:59:16 -0500
Received: from mail-pd0-f179.google.com ([209.85.192.179]:34263 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751936Ab3KMW7H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 17:59:07 -0500
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: linux-sh@vger.kernel.org, linus.walleij@linaro.org,
        grant.likely@secretlab.ca, horms@verge.net.au,
        laurent.pinchart@ideasonboard.com, Magnus Damm <magnus.damm@gmail.com>
Date: Thu, 14 Nov 2013 07:59:46 +0900
Message-Id: <20131113225946.21449.68990.sendpatchset@w520>
In-Reply-To: <20131113225927.21449.78044.sendpatchset@w520>
References: <20131113225927.21449.78044.sendpatchset@w520>
Subject: [PATCH 02/03] gpio: em: Setup gpiochip->dev
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Magnus Damm <damm@opensource.se>

Make sure gpio_chip->dev is setup so of_gpiochip_add()
will work as expected.

Signed-off-by: Magnus Damm <damm@opensource.se>
---

 drivers/gpio/gpio-em.c |    1 +
 1 file changed, 1 insertion(+)

--- 0001/drivers/gpio/gpio-em.c
+++ work/drivers/gpio/gpio-em.c	2013-11-13 20:47:40.000000000 +0900
@@ -327,6 +327,7 @@ static int em_gio_probe(struct platform_
 	gpio_chip->request = em_gio_request;
 	gpio_chip->free = em_gio_free;
 	gpio_chip->label = name;
+	gpio_chip->dev = &pdev->dev;
 	gpio_chip->owner = THIS_MODULE;
 	gpio_chip->base = pdata->gpio_base;
 	gpio_chip->ngpio = pdata->number_of_pins;
