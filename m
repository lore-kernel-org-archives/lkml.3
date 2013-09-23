Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753949Ab3IWUvG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 16:51:06 -0400
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:57043 "EHLO
	relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753451Ab3IWUvE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 16:51:04 -0400
X-Greylist: delayed 97151 seconds by postgrey-1.27 at vger.kernel.org; Mon, 23 Sep 2013 16:51:03 EDT
X-Originating-IP: 83.160.107.163
Date: Mon, 23 Sep 2013 22:50:56 +0200
From: Matthias Kaehlcke <matthias.list@kaehlcke.net>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Samuel Ortiz <sameo@linux.intel.com>, Felipe Balbi <balbi@ti.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] input: touchscreen: ti_am335x_tsc: Enable FIFO threshold
 interrupt on resume
Message-ID: <20130923205056.GH27515@raspi>
Mail-Followup-To: Matthias Kaehlcke <matthias.list@kaehlcke.net>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Samuel Ortiz <sameo@linux.intel.com>, Felipe Balbi <balbi@ti.com>,
	linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When returning from suspend the FIFO threshold interrupt is
disabled, re-enable it on resume

Signed-off-by: Matthias Kaehlcke <matthias@kaehlcke.net>

---
 drivers/input/touchscreen/ti_am335x_tsc.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/input/touchscreen/ti_am335x_tsc.c b/drivers/input/touchscreen/ti_am335x_tsc.c
index e1c5300..d86f140 100644
--- a/drivers/input/touchscreen/ti_am335x_tsc.c
+++ b/drivers/input/touchscreen/ti_am335x_tsc.c
@@ -480,6 +480,8 @@ static int titsc_resume(struct device *dev)
 	titsc_step_config(ts_dev);
 	titsc_writel(ts_dev, REG_FIFO0THR,
 			ts_dev->coordinate_readouts * 2 + 2 - 1);
+	titsc_writel(ts_dev, REG_IRQENABLE, IRQENB_FIFO0THRES);
+
 	return 0;
 }
 
-- 
1.7.9.5

