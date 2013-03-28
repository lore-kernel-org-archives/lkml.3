Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757053Ab3C1QSW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 12:18:22 -0400
Received: from mail-da0-f47.google.com ([209.85.210.47]:43189 "EHLO
	mail-da0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756953Ab3C1QSS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 12:18:18 -0400
Message-ID: <1364487492.10838.1.camel@phoenix>
Subject: [PATCH] pinctrl: coh901: Fix error checking in u300_gpio_to_irq
From: Axel Lin <axel.lin@ingics.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-kernel@vger.kernel.org
Date: Fri, 29 Mar 2013 00:18:12 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The pointer "port" is always not NULL if gpio->port_list is not empty.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/pinctrl/pinctrl-coh901.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-coh901.c b/drivers/pinctrl/pinctrl-coh901.c
index 86887850..edde3ac 100644
--- a/drivers/pinctrl/pinctrl-coh901.c
+++ b/drivers/pinctrl/pinctrl-coh901.c
@@ -318,13 +318,16 @@ static int u300_gpio_to_irq(struct gpio_chip *chip, unsigned offset)
 	struct u300_gpio_port *port = NULL;
 	struct list_head *p;
 	int retirq;
+	bool found = false;
 
 	list_for_each(p, &gpio->port_list) {
 		port = list_entry(p, struct u300_gpio_port, node);
-		if (port->number == portno)
+		if (port->number == portno) {
+			found = true;
 			break;
+		}
 	}
-	if (port == NULL) {
+	if (!found) {
 		dev_err(gpio->dev, "could not locate port for GPIO %d IRQ\n",
 			offset);
 		return -EINVAL;
-- 
1.7.10.4



