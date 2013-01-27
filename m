Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755979Ab3A0UIQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2013 15:08:16 -0500
Received: from server19320154104.serverpool.info ([193.201.54.104]:36865 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755445Ab3A0UIN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2013 15:08:13 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: gregkh@linuxfoundation.org
Cc: zbr@ioremap.net, panto@antoniou-consulting.com,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH] w1-gpio: fix section mismatch
Date: Sun, 27 Jan 2013 21:07:57 +0100
Message-Id: <1359317277-29161-1-git-send-email-hauke@hauke-m.de>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes the following section mismatch:

WARNING: drivers/w1/masters/w1-gpio.o(.data+0x188): Section mismatch in
reference from the variable w1_gpio_driver to the function
.init.text:w1_gpio_probe()
The variable w1_gpio_driver references
the function __init w1_gpio_probe()
If the reference is valid then annotate the
variable with __init* or __refdata (see linux/init.h) or name the variable:
*_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---

This patch is based on 3.8-rc5.

 drivers/w1/masters/w1-gpio.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/w1/masters/w1-gpio.c b/drivers/w1/masters/w1-gpio.c
index 85b363a..d39dfa4 100644
--- a/drivers/w1/masters/w1-gpio.c
+++ b/drivers/w1/masters/w1-gpio.c
@@ -72,7 +72,7 @@ static int w1_gpio_probe_dt(struct platform_device *pdev)
 	return 0;
 }
 
-static int __init w1_gpio_probe(struct platform_device *pdev)
+static int w1_gpio_probe(struct platform_device *pdev)
 {
 	struct w1_bus_master *master;
 	struct w1_gpio_platform_data *pdata;
-- 
1.7.10.4

