Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934078Ab3CHKJd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 05:09:33 -0500
Received: from mail-la0-f43.google.com ([209.85.215.43]:53592 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934020Ab3CHKJb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 05:09:31 -0500
From: Johan Hovold <jhovold@gmail.com>
To: Evgeniy Polyakov <zbr@ioremap.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, Johan Hovold <jhovold@gmail.com>
Subject: [PATCH 2/2] w1-gpio: fix unused variable warning
Date: Fri,  8 Mar 2013 11:08:00 +0100
Message-Id: <1362737280-13714-2-git-send-email-jhovold@gmail.com>
X-Mailer: git-send-email 1.8.1.1
In-Reply-To: <1362737280-13714-1-git-send-email-jhovold@gmail.com>
References: <1362737280-13714-1-git-send-email-jhovold@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 8a1861d997 ("w1-gpio: Simplify & get rid of defines") removed the
compile guards from the device-tree id table, thereby generating a
warning when building without device-tree support.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
---
 drivers/w1/masters/w1-gpio.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/w1/masters/w1-gpio.c b/drivers/w1/masters/w1-gpio.c
index 012817a..46d9701 100644
--- a/drivers/w1/masters/w1-gpio.c
+++ b/drivers/w1/masters/w1-gpio.c
@@ -47,11 +47,13 @@ static u8 w1_gpio_read_bit(void *data)
 	return gpio_get_value(pdata->pin) ? 1 : 0;
 }
 
+#if defined(CONFIG_OF)
 static struct of_device_id w1_gpio_dt_ids[] = {
 	{ .compatible = "w1-gpio" },
 	{}
 };
 MODULE_DEVICE_TABLE(of, w1_gpio_dt_ids);
+#endif
 
 static int w1_gpio_probe_dt(struct platform_device *pdev)
 {
-- 
1.8.1.1

