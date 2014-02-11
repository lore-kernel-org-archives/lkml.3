Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751753AbaBKKTC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 05:19:02 -0500
Received: from mail1.bemta5.messagelabs.com ([195.245.231.151]:36961 "EHLO
	mail1.bemta5.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751675AbaBKKS6 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 05:18:58 -0500
X-Env-Sender: Adam.Thomson.Opensource@diasemi.com
X-Msg-Ref: server-15.tower-179.messagelabs.com!1392113936!26637316!1
X-Originating-IP: [82.210.246.133]
X-StarScan-Received: 
X-StarScan-Version: 6.9.16; banners=-,-,-
X-VirusChecked: Checked
Message-ID: <68b98f4a080bb8be65eb97e63a5fb6c72ca555eb.1392044599.git.Adam.Thomson.Opensource@diasemi.com>
In-Reply-To: <cover.1392044599.git.Adam.Thomson.Opensource@diasemi.com>
References: <cover.1392044599.git.Adam.Thomson.Opensource@diasemi.com>
From: Adam Thomson <adam.thomson@diasemi.com>
Date: Tue, 11 Feb 2014 10:18:54 +0000
Subject: [PATCH 1/2] onkey: da9055: Remove use of regmap_irq_get_virq()
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Dmitry Torokhov <dtor@mail.ru>,
        Alessandro Zummo <a.zummo@towertech.it>
CC: <linux-kernel@vger.kernel.org>, <rtc-linux@googlegroups.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
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

-       irq = regmap_irq_get_virq(da9055->irq_data, irq);
        err = request_threaded_irq(irq, NULL, da9055_onkey_irq,
                                   IRQF_TRIGGER_HIGH | IRQF_ONESHOT,
                                   "ONKEY", onkey);
--
1.7.0.4

Legal Disclaimer: This e-mail communication (and any attachment/s) is confidential and contains proprietary information, some or all of which may be legally privileged. It is intended solely for the use of the individual or entity to which it is addressed. Access to this email by anyone else is unauthorized. If you are not the intended recipient, any disclosure, copying, distribution or any action taken or omitted to be taken in reliance on it, is prohibited and may be unlawful.

Please consider the environment before printing this e-mail


