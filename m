Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758214Ab3BYHAk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 02:00:40 -0500
Received: from mail-pa0-f54.google.com ([209.85.220.54]:51732 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757286Ab3BYG7n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 01:59:43 -0500
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Evgeniy Polyakov <zbr@ioremap.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ville Syrjala <syrjala@sci.fi>, Daniel Mack <zonque@gmail.com>,
        Matt Ranostay <mranostay@gmail.com>, panto@antoniou-consulting.com,
        koen@dominion.thruhere.net
Subject: [PATCH 3/5] W1: w1-gpio - guard DT IDs with CONFIG_OF
Date: Sun, 24 Feb 2013 22:59:35 -0800
Message-Id: <1361775577-4578-3-git-send-email-dmitry.torokhov@gmail.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1361775577-4578-1-git-send-email-dmitry.torokhov@gmail.com>
References: <1361606320-4479-1-git-send-email-dmitry.torokhov@gmail.com>
 <1361775577-4578-1-git-send-email-dmitry.torokhov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes the following warning:

  CC      drivers/w1/masters/w1-gpio.o
drivers/w1/masters/w1-gpio.c:50:28: warning: ‘w1_gpio_dt_ids’ defined but not used [-Wunused-variable]

Also provide stub for w1_gpio_probe_dt() if device tree support is
disabled.

Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
---
 drivers/w1/masters/w1-gpio.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/w1/masters/w1-gpio.c b/drivers/w1/masters/w1-gpio.c
index c45b9ae..aa97a96 100644
--- a/drivers/w1/masters/w1-gpio.c
+++ b/drivers/w1/masters/w1-gpio.c
@@ -47,6 +47,8 @@ static u8 w1_gpio_read_bit(void *data)
 	return gpio_get_value(pdata->pin) ? 1 : 0;
 }
 
+#ifdef CONFIG_OF
+
 static struct of_device_id w1_gpio_dt_ids[] = {
 	{ .compatible = "w1-gpio" },
 	{}
@@ -72,6 +74,15 @@ static int w1_gpio_probe_dt(struct platform_device *pdev)
 	return 0;
 }
 
+#else
+
+static inline int w1_gpio_probe_dt(struct platform_device *pdev)
+{
+	return -ENOSYS;
+}
+
+#endif
+
 static int w1_gpio_probe(struct platform_device *pdev)
 {
 	struct w1_bus_master *master;
-- 
1.7.11.7

