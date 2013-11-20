Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753857Ab3KTAWu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 19:22:50 -0500
Received: from mail-pd0-f171.google.com ([209.85.192.171]:36985 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753591Ab3KTAWp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 19:22:45 -0500
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: linux-sh@vger.kernel.org, linus.walleij@linaro.org,
        grant.likely@secretlab.ca, horms@verge.net.au,
        laurent.pinchart@ideasonboard.com, Magnus Damm <magnus.damm@gmail.com>
Date: Wed, 20 Nov 2013 09:23:26 +0900
Message-Id: <20131120002326.27342.83787.sendpatchset@w520>
In-Reply-To: <20131120002259.27342.35575.sendpatchset@w520>
References: <20131120002259.27342.35575.sendpatchset@w520>
Subject: [PATCH 03/05] gpio: em: Setup gpiochip->dev
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Magnus Damm <damm@opensource.se>

Make sure gpio_chip->dev is setup so of_gpiochip_add()
will work as expected.

Signed-off-by: Magnus Damm <damm@opensource.se>
Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
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
