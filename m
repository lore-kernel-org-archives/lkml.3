Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752032AbaH1RQr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 13:16:47 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:42081 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751945AbaH1RQq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 13:16:46 -0400
From: Grygorii Strashko <grygorii.strashko@ti.com>
To: Thomas Gleixner <tglx@linutronix.de>, <santosh.shilimkar@ti.com>,
        Jason Cooper <jason@lakedaemon.net>
CC: Dan Carpenter <dan.carpenter@oracle.com>, <linux-kernel@vger.kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [PATCH] irqchip: keystone: remove warning unsigned 'kirq->irq' is never less than zero
Date: Thu, 28 Aug 2014 20:16:29 +0300
Message-ID: <1409246189-29727-1-git-send-email-grygorii.strashko@ti.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1406126430-9978-1-git-send-email-grygorii.strashko@ti.com>
References: <1406126430-9978-1-git-send-email-grygorii.strashko@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove static checker warning:

	drivers/irqchip/irq-keystone.c:166 keystone_irq_probe()
	warn: unsigned 'kirq->irq' is never less than zero.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
---
 drivers/irqchip/irq-keystone.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/irqchip/irq-keystone.c b/drivers/irqchip/irq-keystone.c
index fea26bc..608abf9 100644
--- a/drivers/irqchip/irq-keystone.c
+++ b/drivers/irqchip/irq-keystone.c
@@ -36,7 +36,7 @@ struct keystone_irq_device {
 	struct device		*dev;
 	struct irq_chip		 chip;
 	u32			 mask;
-	u32			 irq;
+	int			 irq;
 	struct irq_domain	*irqd;
 	struct regmap		*devctrl_regs;
 	u32			devctrl_offset;
-- 
1.9.1

