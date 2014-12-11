Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934081AbaLKPsk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 10:48:40 -0500
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:46293 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933033AbaLKPsi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 10:48:38 -0500
Date: Thu, 11 Dec 2014 17:48:03 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Jacek Anaszewski <j.anaszewski@samsung.com>
Cc: linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, kyungmin.park@samsung.com,
        b.zolnierkie@samsung.com, pavel@ucw.cz, cooloney@gmail.com,
        rpurdie@rpsys.net, s.nawrocki@samsung.com, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        Andrzej Hajda <a.hajda@samsung.com>, Lee Jones <lee.jones@linaro.org>,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: Re: [PATCH/RFC v9 05/19] leds: Add support for max77693 mfd flash
 cell
Message-ID: <20141211154803.GT15559@valkosipuli.retiisi.org.uk>
References: <1417622814-10845-1-git-send-email-j.anaszewski@samsung.com>
 <1417622814-10845-6-git-send-email-j.anaszewski@samsung.com>
 <20141204093906.GO14746@valkosipuli.retiisi.org.uk>
 <54804053.7050903@samsung.com>
 <20141209131123.GK15559@valkosipuli.retiisi.org.uk>
 <5489A1E1.9040108@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5489A1E1.9040108@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jacek,

On Thu, Dec 11, 2014 at 02:53:37PM +0100, Jacek Anaszewski wrote:
> Hi Sakari,
> 
> On 12/09/2014 02:11 PM, Sakari Ailus wrote:
> >Hi Jacek,
> >
> >On Thu, Dec 04, 2014 at 12:06:59PM +0100, Jacek Anaszewski wrote:
> >>Hi Sakari,
> >>
> >>Thanks for the review.
> >
> >You're welcome! :-)
> >
> >>On 12/04/2014 10:39 AM, Sakari Ailus wrote:
> >>>Hi Jacek,
> >>>
> >>>On Wed, Dec 03, 2014 at 05:06:40PM +0100, Jacek Anaszewski wrote:
> >>>>This patch adds led-flash support to Maxim max77693 chipset.
> >>>>A device can be exposed to user space through LED subsystem
> >>>>sysfs interface. Device supports up to two leds which can
> >>>>work in flash and torch mode. The leds can be triggered
> >>>>externally or by software.
> >>>>
> >>>>Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
> >>>>Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
> >>>>Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
> >>>>Cc: Bryan Wu <cooloney@gmail.com>
> >>>>Cc: Richard Purdie <rpurdie@rpsys.net>
> >>>>Cc: Lee Jones <lee.jones@linaro.org>
> >>>>Cc: Chanwoo Choi <cw00.choi@samsung.com>
> >>>>---
> >>>>  drivers/leds/Kconfig         |   10 +
> >>>>  drivers/leds/Makefile        |    1 +
> >>>>  drivers/leds/leds-max77693.c | 1023 ++++++++++++++++++++++++++++++++++++++++++
> >>>>  3 files changed, 1034 insertions(+)
> >>>>  create mode 100644 drivers/leds/leds-max77693.c
> >>>>
> >>>>diff --git a/drivers/leds/Kconfig b/drivers/leds/Kconfig
> >>>>index fa8021e..2e66d55 100644
> >>>>--- a/drivers/leds/Kconfig
> >>>>+++ b/drivers/leds/Kconfig
> >>>>@@ -463,6 +463,16 @@ config LEDS_TCA6507
> >>>>  	  LED driver chips accessed via the I2C bus.
> >>>>  	  Driver support brightness control and hardware-assisted blinking.
> >>>>
> >>>>+config LEDS_MAX77693
> >>>>+	tristate "LED support for MAX77693 Flash"
> >>>>+	depends on LEDS_CLASS_FLASH
> >>>>+	depends on MFD_MAX77693
> >>>>+	depends on OF
> >>>>+	help
> >>>>+	  This option enables support for the flash part of the MAX77693
> >>>>+	  multifunction device. It has build in control for two leds in flash
> >>>>+	  and torch mode.
> >>>>+
> >>>>  config LEDS_MAX8997
> >>>>  	tristate "LED support for MAX8997 PMIC"
> >>>>  	depends on LEDS_CLASS && MFD_MAX8997
> >>>>diff --git a/drivers/leds/Makefile b/drivers/leds/Makefile
> >>>>index cbba921..57ca62b 100644
> >>>>--- a/drivers/leds/Makefile
> >>>>+++ b/drivers/leds/Makefile
> >>>>@@ -52,6 +52,7 @@ obj-$(CONFIG_LEDS_MC13783)		+= leds-mc13783.o
> >>>>  obj-$(CONFIG_LEDS_NS2)			+= leds-ns2.o
> >>>>  obj-$(CONFIG_LEDS_NETXBIG)		+= leds-netxbig.o
> >>>>  obj-$(CONFIG_LEDS_ASIC3)		+= leds-asic3.o
> >>>>+obj-$(CONFIG_LEDS_MAX77693)		+= leds-max77693.o
> >>>>  obj-$(CONFIG_LEDS_MAX8997)		+= leds-max8997.o
> >>>>  obj-$(CONFIG_LEDS_LM355x)		+= leds-lm355x.o
> >>>>  obj-$(CONFIG_LEDS_BLINKM)		+= leds-blinkm.o
> >>>>diff --git a/drivers/leds/leds-max77693.c b/drivers/leds/leds-max77693.c
> >>>>new file mode 100644
> >>>>index 0000000..67a2f8f
> >>>>--- /dev/null
> >>>>+++ b/drivers/leds/leds-max77693.c
> >>>>@@ -0,0 +1,1023 @@
> >>>>+/*
> >>>>+ * LED Flash class driver for the flash cell of max77693 mfd.
> >>>>+ *
> >>>>+ *	Copyright (C) 2014, Samsung Electronics Co., Ltd.
> >>>>+ *
> >>>>+ *	Authors: Jacek Anaszewski <j.anaszewski@samsung.com>
> >>>>+ *		 Andrzej Hajda <a.hajda@samsung.com>
> >>>>+ *
> >>>>+ * This program is free software; you can redistribute it and/or
> >>>>+ * modify it under the terms of the GNU General Public License
> >>>>+ * version 2 as published by the Free Software Foundation.
> >>>>+ */
> >>>>+
> >>>>+#include <asm/div64.h>
> >>>>+#include <linux/led-class-flash.h>
> >>>>+#include <linux/mfd/max77693.h>
> >>>>+#include <linux/mfd/max77693-private.h>
> >>>>+#include <linux/module.h>
> >>>>+#include <linux/mutex.h>
> >>>>+#include <linux/platform_device.h>
> >>>>+#include <linux/regmap.h>
> >>>>+#include <linux/slab.h>
> >>>>+#include <linux/workqueue.h>
> >>>>+
> >>>>+#define MODE_OFF		0
> >>>>+#define MODE_FLASH1		(1 << 0)
> >>>>+#define MODE_FLASH2		(1 << 1)
> >>>>+#define MODE_TORCH1		(1 << 2)
> >>>>+#define MODE_TORCH2		(1 << 3)
> >>>>+#define MODE_FLASH_EXTERNAL1	(1 << 4)
> >>>>+#define MODE_FLASH_EXTERNAL2	(1 << 5)
> >>>
> >>>You could do this based on an argument (led number). E.g.
> >>>
> >>>#define MODE_FLASH_EXTERNAL(a)	(1 << (4 + a))
> >>
> >>OK.
> >>
> >>>>+#define MODE_FLASH		(MODE_FLASH1 | MODE_FLASH2 | \
> >>>>+				 MODE_FLASH_EXTERNAL1 | MODE_FLASH_EXTERNAL2)
> >>>>+
> >>>>+#define FLED1_IOUT		(1 << 0)
> >>>>+#define FLED2_IOUT		(1 << 1)
> >>>>+
> >>>>+enum {
> >>>>+	FLED1,
> >>>>+	FLED2
> >>>>+};
> >>>>+
> >>>>+enum {
> >>>>+	FLASH,
> >>>>+	TORCH
> >>>>+};
> >>>>+
> >>>>+struct max77693_sub_led {
> >
> >This could then be renamed as "max77693_led"; up to you.
> 
> It will be better to rename the max77693_led structure to
> max77693_led_device instead of max77693_device like you proposed. This
> is because there is already max77693_dev structure in the mfd driver
> for max77693 and this is only a driver for the led part of a device.
> 
> Taking above into account I'd rather leave struct max77693_sub_led
> name unchanged.

Fine for me.

> >>>>+	struct led_classdev_flash ldev;
> >>>>+	struct work_struct work_brightness_set;
> >>>>+
> >>>>+	unsigned int torch_brightness;
> >>>>+	unsigned int flash_timeout;
> >>>>+};
> >>>>+
> >>>>+struct max77693_led {
> >>>
> >>>As this does not refer to a device, how about struct max77693_device, for
> >>>instance?
> >>
> >>OK.
> >>
> >>>>+	struct regmap *regmap;
> >>>>+	struct platform_device *pdev;
> >>>>+	struct max77693_led_platform_data *pdata;
> >>>>+	struct mutex lock;
> >>>>+
> >>>>+	struct max77693_sub_led sub_leds[2];
> >>>>+
> >>>>+	unsigned int current_flash_timeout;
> >>>>+	unsigned int mode_flags;
> >>>>+	u8 torch_iout_reg;
> >>>>+	bool iout_joint;
> >>>>+	int strobing_sub_led_id;
> >>>>+};
> >>>>+
> >>>>+struct max77693_led_settings {
> >>>>+	struct led_flash_setting torch_brightness;
> >>>>+	struct led_flash_setting flash_brightness;
> >>>>+	struct led_flash_setting flash_timeout;
> >>>>+};
> >>>>+
> >>>>+static u8 max77693_led_iout_to_reg(u32 ua)
> >>>>+{
> >>>>+	if (ua < FLASH_IOUT_MIN)
> >>>>+		ua = FLASH_IOUT_MIN;
> >>>>+	return (ua - FLASH_IOUT_MIN) / FLASH_IOUT_STEP;
> >>>>+}
> >>>>+
> >>>>+static u8 max77693_flash_timeout_to_reg(u32 us)
> >>>>+{
> >>>>+	return (us - FLASH_TIMEOUT_MIN) / FLASH_TIMEOUT_STEP;
> >>>>+}
> >>>>+
> >>>>+static inline struct max77693_led *ldev1_to_led(
> >>>>+					struct led_classdev_flash *ldev)
> >>>>+{
> >>>>+	struct max77693_sub_led *sub_led = container_of(ldev,
> >>>>+						struct max77693_sub_led,
> >>>>+						ldev);
> >>>>+	return container_of(sub_led, struct max77693_led, sub_leds[0]);
> >>>
> >>>You could have a common macro to find the flash controller struct if you add
> >>>the LED number to struct max77693_sub_led.
> >>>
> >>>>+}
> >>>>+
> >>>>+static inline struct max77693_led *ldev2_to_led(
> >>>>+					struct led_classdev_flash *ldev)
> >>>>+{
> >>>>+	struct max77693_sub_led *sub_led = container_of(ldev,
> >>>>+						struct max77693_sub_led,
> >>>>+						ldev);
> >>>>+	return container_of(sub_led, struct max77693_led, sub_leds[1]);
> >>>>+}
> >>>>+
> >>>>+static u8 max77693_led_vsys_to_reg(u32 mv)
> >>>>+{
> >>>>+	return ((mv - MAX_FLASH1_VSYS_MIN) / MAX_FLASH1_VSYS_STEP) << 2;
> >>>>+}
> >>>>+
> >>>>+static u8 max77693_led_vout_to_reg(u32 mv)
> >>>>+{
> >>>>+	return (mv - FLASH_VOUT_MIN) / FLASH_VOUT_STEP + FLASH_VOUT_RMIN;
> >>>>+}
> >>>>+
> >>>>+/* split composite current @i into two @iout according to @imax weights */
> >>>
> >>>What do you intend to do in the oint iout mode? A single LED connected to
> >>>iout pins which are soldered together?
> >>
> >>Exactly that what is written in the comment - split the current into
> >>both outputs.
> >
> >I think we discussed this on #v4l --- was it so that both outputs, if
> >they're connected, should have the same current if there's a single LED
> >connected to them?
> 
> Precisely: the current levels will differ between the outputs by
> no more than one level, as for odd levels it will be impossible
> to split the current to two even components.

True. If that's allowed from HW point of view, sure.

> >>>>+static int max77693_led_parse_dt(struct max77693_led *led,
> >>>>+				struct device_node *node)
> >>>>+{
> >>>>+	struct max77693_led_platform_data *p = led->pdata;
> >>>>+	struct device *dev = &led->pdev->dev;
> >>>>+	struct device_node *child_node;
> >>>>+	u32 fled_id;
> >>>>+	int ret;
> >>>>+
> >>>>+	of_property_read_u32_array(node, "maxim,fleds", p->fleds, 2);
> >>>>+	of_property_read_u32_array(node, "maxim,trigger", p->trigger, 2);
> >>>>+	of_property_read_u32_array(node, "maxim,trigger-type", p->trigger_type,
> >>>>+									2);
> >>>>+	of_property_read_u32(node, "maxim,boost-mode", &p->boost_mode);
> >>>>+	of_property_read_u32(node, "maxim,boost-vout", &p->boost_vout);
> >>>>+	of_property_read_u32(node, "maxim,vsys-min", &p->low_vsys);
> >>>>+
> >>>>+	for_each_available_child_of_node(node, child_node) {
> >>>>+		ret = of_property_read_u32(child_node, "maxim,fled_id",
> >>>>+						&fled_id);
> >>>>+		if (ret < 0) {
> >>>>+			dev_err(dev, "Error reading \"fled_id\" DT property\n");
> >>>>+			return ret;
> >>>>+		}
> >>>>+
> >>>>+		fled_id = clamp_val(fled_id, 1, 2);
> >>>
> >>>I think you should check fled_id is really correct, and not clamp it.
> >>
> >>Right.
> >>
> >>>>+		--fled_id;
> >>>>+
> >>>>+		p->sub_nodes[fled_id] = child_node;
> >>>
> >>>p->sub_nodes is not accessed anywhere else. Do you plan to use it for
> >>>something?
> >>
> >>It is passed to v4l2_flash_init. In this patch set I add the V4L2
> >>support in the separate patch. Probably this should be move there.
> >
> >Ok. I'm ok to keep it here as well, up to you.
> >
> 
> As I explained on #v4l it won't be needed because it turned out that
> the sub-node pointer can be stored in the dev member of
> the led_classdev structure.

Ack.

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
