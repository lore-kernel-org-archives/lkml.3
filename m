Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753486AbaAVU0Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 15:26:24 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:58357 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752578AbaAVU0U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 15:26:20 -0500
From: Mark Brown <broonie@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: linaro-kernel@lists.linaro.org, Mark Brown <broonie@linaro.org>
Date: Wed, 22 Jan 2014 20:26:14 +0000
Message-Id: <1390422374-26293-1-git-send-email-broonie@kernel.org>
X-Mailer: git-send-email 1.8.5.3
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [PATCH] regmap: irq: Remove domain on exit
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Brown <broonie@linaro.org>

irqdomain now supports removal of domains on exit so we can properly clean
up on deletion of a regmap irqchip.

Signed-off-by: Mark Brown <broonie@linaro.org>
---
 drivers/base/regmap/regmap-irq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/base/regmap/regmap-irq.c b/drivers/base/regmap/regmap-irq.c
index 82692068d3cb..52ce0c17c68b 100644
--- a/drivers/base/regmap/regmap-irq.c
+++ b/drivers/base/regmap/regmap-irq.c
@@ -533,7 +533,7 @@ void regmap_del_irq_chip(int irq, struct regmap_irq_chip_data *d)
 		return;
 
 	free_irq(irq, d);
-	/* We should unmap the domain but... */
+	irq_domain_remove(d->domain);
 	kfree(d->wake_buf);
 	kfree(d->mask_buf_def);
 	kfree(d->mask_buf);
-- 
1.8.5.3

