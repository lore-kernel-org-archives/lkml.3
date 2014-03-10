Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754119AbaCJQd2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 12:33:28 -0400
Received: from mail1.bemta5.messagelabs.com ([195.245.231.142]:41059 "EHLO
	mail1.bemta5.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753411AbaCJQcu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 12:32:50 -0400
X-Env-Sender: stwiss.opensource@diasemi.com
X-Msg-Ref: server-13.tower-179.messagelabs.com!1394469134!31062966!2
X-Originating-IP: [82.210.246.133]
X-StarScan-Received: 
X-StarScan-Version: 6.9.16; banners=-,-,-
X-VirusChecked: Checked
Message-ID: <f5a169e00565134fa856a3daa615b17253ce844e.1394468644.git.stwiss.opensource@diasemi.com>
In-Reply-To: <cover.1394468644.git.stwiss.opensource@diasemi.com>
References: <cover.1394468644.git.stwiss.opensource@diasemi.com>
From: "Opensource [Steve Twiss]" <stwiss.opensource@diasemi.com>
Date: Mon, 10 Mar 2014 16:24:04 +0000
Subject: [PATCH V1 1/2] mfd: da9063: Linkages for ONKEY support in core files
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>
CC: David Dajun Chen <david.chen@diasemi.com>,
        LKML-INPUT <linux-input@vger.kernel.org>,
        LKML-KERNEL <linux-kernel@vger.kernel.org>,
        Mark Brown <broonie@linaro.org>,
        Philipp Zabel <p.zabel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Opensource [Steve Twiss] <stwiss.opensource@diasemi.com>

This change adds the name field "ONKEY" to the properties of the 
the OnKey IORESOURCE_IRQ resource structure (part of the mfd_cell
Onkey resource).

The addition of bool key_power which will be passed to the onkey
driver and allow KEY_POWER support to be turned on/off as a
driver configuration option.


Signed-off-by: Opensource [Steve Twiss] <stwiss.opensource@diasemi.com>
---
Checks performed with linux-next/next-20140307/scripts/checkpatch.pl
 da9063-core.c             total: 0 errors, 0 warnings, 189 lines checked
 pdata.h                   total: 0 errors, 0 warnings, 112 lines checked

This change is a dependency for the new DA9063 OnKey driver which
forms the remainder of this patch set.
This patch applies against kernel linux-next next-20140307

Regards,
Steve Twiss, Dialog Semiconductor Ltd.



 drivers/mfd/da9063-core.c        | 1 +
 include/linux/mfd/da9063/pdata.h | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/mfd/da9063-core.c b/drivers/mfd/da9063-core.c
index e70ae31..b410a14 100644
--- a/drivers/mfd/da9063-core.c
+++ b/drivers/mfd/da9063-core.c
@@ -60,6 +60,7 @@ static struct resource da9063_rtc_resources[] = {
 
 static struct resource da9063_onkey_resources[] = {
 	{
+		.name	= "ONKEY",
 		.start	= DA9063_IRQ_ONKEY,
 		.end	= DA9063_IRQ_ONKEY,
 		.flags	= IORESOURCE_IRQ,
diff --git a/include/linux/mfd/da9063/pdata.h b/include/linux/mfd/da9063/pdata.h
index 95c8742..612383b 100644
--- a/include/linux/mfd/da9063/pdata.h
+++ b/include/linux/mfd/da9063/pdata.h
@@ -103,6 +103,7 @@ struct da9063;
 struct da9063_pdata {
 	int				(*init)(struct da9063 *da9063);
 	int				irq_base;
+	bool				key_power;
 	unsigned			flags;
 	struct da9063_regulators_pdata	*regulators_pdata;
 	struct led_platform_data	*leds_pdata;
-- 
end-of-patch for PATCH V1

