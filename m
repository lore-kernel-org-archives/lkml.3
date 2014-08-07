Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932437AbaHGP2z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 11:28:55 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:24590 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932071AbaHGP2x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 11:28:53 -0400
Date: Thu, 7 Aug 2014 18:28:21 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Thomas Gleixner <tglx@linutronix.de>, Sricharan R <r.sricharan@ti.com>
Cc: Jason Cooper <jason@lakedaemon.net>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [patch] irqchip/irq-crossbar: off by one bugs in init
Message-ID: <20140807152821.GB10299@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

My static checker complains that the ">" should be ">=" or else we go
beyoned the end of the cb->irq_map[] array on the next line.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/irqchip/irq-crossbar.c b/drivers/irqchip/irq-crossbar.c
index 85c2985..bbbaf5d 100644
--- a/drivers/irqchip/irq-crossbar.c
+++ b/drivers/irqchip/irq-crossbar.c
@@ -220,7 +220,7 @@ static int __init crossbar_of_init(struct device_node *node)
 			of_property_read_u32_index(node,
 						   "ti,irqs-reserved",
 						   i, &entry);
-			if (entry > max) {
+			if (entry >= max) {
 				pr_err("Invalid reserved entry\n");
 				ret = -EINVAL;
 				goto err_irq_map;
@@ -238,7 +238,7 @@ static int __init crossbar_of_init(struct device_node *node)
 			of_property_read_u32_index(node,
 						   "ti,irqs-skip",
 						   i, &entry);
-			if (entry > max) {
+			if (entry >= max) {
 				pr_err("Invalid skip entry\n");
 				ret = -EINVAL;
 				goto err_irq_map;
