Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754930AbaCKL5C (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 07:57:02 -0400
Received: from mail1.bemta5.messagelabs.com ([195.245.231.147]:14042 "EHLO
	mail1.bemta5.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754672AbaCKL5A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 07:57:00 -0400
X-Env-Sender: Adam.Thomson.Opensource@diasemi.com
X-Msg-Ref: server-13.tower-178.messagelabs.com!1394539009!31081465!1
X-Originating-IP: [82.210.246.133]
X-StarScan-Received: 
X-StarScan-Version: 6.9.16; banners=-,-,-
X-VirusChecked: Checked
Message-ID: <6038e89a5f611a7b866f028f77c3df37015931db.1394536652.git.Adam.Thomson.Opensource@diasemi.com>
In-Reply-To: <cover.1394536652.git.Adam.Thomson.Opensource@diasemi.com>
References: <cover.1394536652.git.Adam.Thomson.Opensource@diasemi.com>
From: Adam Thomson <Adam.Thomson.Opensource@diasemi.com>
Date: Tue, 11 Mar 2014 11:56:47 +0000
Subject: [PATCH Resend 1/2] input: da9055_onkey: Remove use of regmap_irq_get_virq()
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Dmitry Torokhov <dtor@mail.ru>,
        Alessandro Zummo <a.zummo@towertech.it>
CC: <linux-kernel@vger.kernel.org>, <rtc-linux@googlegroups.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using platform_get_irq_byname() to retrieve the IRQ number
returns the VIRQ number rather than the local IRQ number for
the device. Passing that value then into regmap_irq_get_virq()
causes a failure because the function is expecting the local
IRQ number (e.g. 0, 1, 2, 3, etc). This patch removes use of
regmap_irq_get_virq() to prevent this failure from happening.

Signed-off-by: Adam Thomson <Adam.Thomson.Opensource@diasemi.com>
---
 drivers/input/misc/da9055_onkey.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/input/misc/da9055_onkey.c b/drivers/input/misc/da9055_onkey.c
index 4b11ede..4765799 100644
--- a/drivers/input/misc/da9055_onkey.c
+++ b/drivers/input/misc/da9055_onkey.c
@@ -109,7 +109,6 @@ static int da9055_onkey_probe(struct platform_device *pdev)

 	INIT_DELAYED_WORK(&onkey->work, da9055_onkey_work);

-	irq = regmap_irq_get_virq(da9055->irq_data, irq);
 	err = request_threaded_irq(irq, NULL, da9055_onkey_irq,
 				   IRQF_TRIGGER_HIGH | IRQF_ONESHOT,
 				   "ONKEY", onkey);
--
1.7.0.4

