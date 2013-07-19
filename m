Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760934Ab3GSRsD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 13:48:03 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:33859 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751540Ab3GSRsB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 13:48:01 -0400
From: Mark Brown <broonie@kernel.org>
To: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>
Cc: linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        Mark Brown <broonie@linaro.org>
Date: Fri, 19 Jul 2013 18:47:34 +0100
Message-Id: <1374256055-26894-1-git-send-email-broonie@kernel.org>
X-Mailer: git-send-email 1.8.3.2
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [PATCH 1/2] extcon: gpio: Use power efficient workqueue for debounce
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Brown <broonie@linaro.org>

The debounce timeout is generally quite long and the work not performance
critical so allow the scheduler to run the work anywhere rather than in
the normal per-CPU workqueue.

Signed-off-by: Mark Brown <broonie@linaro.org>
---
 drivers/extcon/extcon-gpio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/extcon/extcon-gpio.c b/drivers/extcon/extcon-gpio.c
index 02bec32..f874c30 100644
--- a/drivers/extcon/extcon-gpio.c
+++ b/drivers/extcon/extcon-gpio.c
@@ -56,7 +56,7 @@ static irqreturn_t gpio_irq_handler(int irq, void *dev_id)
 {
 	struct gpio_extcon_data *extcon_data = dev_id;
 
-	schedule_delayed_work(&extcon_data->work,
+	queue_delayed_work(system_power_efficient_wq, &extcon_data->work,
 			      extcon_data->debounce_jiffies);
 	return IRQ_HANDLED;
 }
-- 
1.8.3.2

