Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753883Ab3KTAW5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 19:22:57 -0500
Received: from mail-pd0-f170.google.com ([209.85.192.170]:57504 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753396Ab3KTAWy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 19:22:54 -0500
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: linux-sh@vger.kernel.org, linus.walleij@linaro.org,
        grant.likely@secretlab.ca, horms@verge.net.au,
        laurent.pinchart@ideasonboard.com, Magnus Damm <magnus.damm@gmail.com>
Date: Wed, 20 Nov 2013 09:23:35 +0900
Message-Id: <20131120002335.27342.16796.sendpatchset@w520>
In-Reply-To: <20131120002259.27342.35575.sendpatchset@w520>
References: <20131120002259.27342.35575.sendpatchset@w520>
Subject: [PATCH 04/05 v2] gpio: em: Use lazy disable
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Magnus Damm <damm@opensource.se>

Set the ->irq_enable() and ->irq_disable() methods to NULL
to enable lazy disable of interrupts. This by itself provides
some level of optimization, but is mainly enabled as ground
work for future Suspend-to-RAM wake up support.

Signed-off-by: Magnus Damm <damm@opensource.se>
---

 drivers/gpio/gpio-em.c |    2 --
 1 file changed, 2 deletions(-)

--- 0010/drivers/gpio/gpio-em.c
+++ work/drivers/gpio/gpio-em.c	2013-11-20 08:32:49.000000000 +0900
@@ -336,8 +336,6 @@ static int em_gio_probe(struct platform_
 	irq_chip->name = name;
 	irq_chip->irq_mask = em_gio_irq_disable;
 	irq_chip->irq_unmask = em_gio_irq_enable;
-	irq_chip->irq_enable = em_gio_irq_enable;
-	irq_chip->irq_disable = em_gio_irq_disable;
 	irq_chip->irq_set_type = em_gio_irq_set_type;
 	irq_chip->flags	= IRQCHIP_SKIP_SET_WAKE;
 
