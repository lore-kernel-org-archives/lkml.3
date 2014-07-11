Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754784AbaGKOFJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 10:05:09 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:59406 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754755AbaGKOFC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 10:05:02 -0400
X-AuditID: cbfee61a-f79e46d00000134f-89-53bfef0b8937
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-leds@vger.kernel.org, devicetree@vger.kernel.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: kyungmin.park@samsung.com, b.zolnierkie@samsung.com,
        Jacek Anaszewski <j.anaszewski@samsung.com>,
        Bryan Wu <cooloney@gmail.com>, Richard Purdie <rpurdie@rpsys.net>
Subject: [PATCH/RFC v4 08/21] leds: Add sysfs and kernel internal API for flash
 LEDs
Date: Fri, 11 Jul 2014 16:04:11 +0200
Message-id: <1405087464-13762-9-git-send-email-j.anaszewski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1405087464-13762-1-git-send-email-j.anaszewski@samsung.com>
References: <1405087464-13762-1-git-send-email-j.anaszewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprNLMWRmVeSWpSXmKPExsVy+t9jQV3u9/uDDc68kLHYOGM9q8XRnROZ
	LOYfOcdq0Xv1OaPF2aY37BaXd81hs9j6Zh2jRc+GrawWu3c9ZXXg9Ng56y67x575P1g9+ras
	YvT4vEkugCWKyyYlNSezLLVI3y6BK+Peu12sBRMXsVQ83z6fuYFx8j7mLkZODgkBE4llZ14w
	QthiEhfurWfrYuTiEBKYziixe/09JginnUni6ZXzrCBVbAKGEj9fvGYCsUUEyiV63j8D62AW
	WM0ocWfrV7AiYYEwia6Zc8GKWARUJW5++ggW5xXwkDg5bwNQnANonYLEnEk2IGFOAU+Jg/03
	2UBsIaCSh2tPsE9g5F3AyLCKUTS1ILmgOCk911CvODG3uDQvXS85P3cTIzjInkntYFzZYHGI
	UYCDUYmHV2H9vmAh1sSy4srcQ4wSHMxKIrxX3+wPFuJNSaysSi3Kjy8qzUktPsQozcGiJM57
	oNU6UEggPbEkNTs1tSC1CCbLxMEp1cDIzOcZvmj6YVsRNWUPq9rWmuXlSc9MFubVcy1Inreh
	/kHq5SWbdNji/zFVyepM1hEru2z0QHrfmoPek58kWGk8XZblU1z35FKF28PS9ewOQu8VfoQ9
	D3W4uzrm639e6w4/wQsH8qVNfFXm1Sk1bmV8zHqq6Jxls2hKar/9vPeq5xo3rz1tcFSJpTgj
	0VCLuag4EQC7x1kYLgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some LED devices support two operation modes - torch and flash.
This patch provides support for flash LED devices in the LED subsystem
by introducing new sysfs attributes and kernel internal interface.
The attributes being introduced are: flash_brightness, flash_strobe,
flash_timeout, max_flash_timeout, max_flash_brightness, flash_fault,
external_strobe, indicator_brightness, max_indicator_brightness,
strobe_provider, strobe_providerN, blocking_strobe. All the flash
related features are placed in a separate module.

The modifications aim to be compatible with V4L2 framework requirements
related to the flash devices management. The design assumes that V4L2
sub-device can take of the LED class device control and communicate
with it through the kernel internal interface. When V4L2 Flash sub-device
file is opened, the LED class device sysfs interface is made
unavailable.

Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Bryan Wu <cooloney@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
---
 drivers/leds/Kconfig                 |   13 +
 drivers/leds/Makefile                |    5 +
 drivers/leds/led-class-flash.c       |  715 ++++++++++++++++++++++++++++++++++
 drivers/leds/led-class.c             |    4 +
 drivers/leds/led-flash-gpio-mux.c    |  102 +++++
 drivers/leds/led-flash-manager.c     |  698 +++++++++++++++++++++++++++++++++
 drivers/leds/led-triggers.c          |    5 +
 drivers/leds/of_led_flash_manager.c  |  155 ++++++++
 include/linux/led-class-flash.h      |  290 ++++++++++++++
 include/linux/led-flash-gpio-mux.h   |   68 ++++
 include/linux/led-flash-manager.h    |  121 ++++++
 include/linux/leds.h                 |    4 +
 include/linux/of_led_flash_manager.h |   80 ++++
 13 files changed, 2260 insertions(+)
 create mode 100644 drivers/leds/led-class-flash.c
 create mode 100644 drivers/leds/led-flash-gpio-mux.c
 create mode 100644 drivers/leds/led-flash-manager.c
 create mode 100644 drivers/leds/of_led_flash_manager.c
 create mode 100644 include/linux/led-class-flash.h
 create mode 100644 include/linux/led-flash-gpio-mux.h
 create mode 100644 include/linux/led-flash-manager.h
 create mode 100644 include/linux/of_led_flash_manager.h

diff --git a/drivers/leds/Kconfig b/drivers/leds/Kconfig
index 6784c17..5032c6f 100644
--- a/drivers/leds/Kconfig
+++ b/drivers/leds/Kconfig
@@ -19,6 +19,19 @@ config LEDS_CLASS
 	  This option enables the led sysfs class in /sys/class/leds.  You'll
 	  need this to do anything useful with LEDs.  If unsure, say N.
 
+config LEDS_CLASS_FLASH
+	tristate "LED Flash Class Support"
+	depends on LEDS_CLASS
+	depends on OF
+	help
+	  This option enables the flash led sysfs class in /sys/class/leds.
+	  It wrapps LED Class and adds flash LEDs specific sysfs attributes
+	  and kernel internal API to it. It allows also for dynamic routing
+	  of external strobe signals basing on the information provided
+	  in the Device Tree binding. You'll need this to provide support
+	  for the flash related features of a LED device. It can be built
+	  as a module.
+
 comment "LED drivers"
 
 config LEDS_88PM860X
diff --git a/drivers/leds/Makefile b/drivers/leds/Makefile
index 79c5155..237c5ba 100644
--- a/drivers/leds/Makefile
+++ b/drivers/leds/Makefile
@@ -2,6 +2,11 @@
 # LED Core
 obj-$(CONFIG_NEW_LEDS)			+= led-core.o
 obj-$(CONFIG_LEDS_CLASS)		+= led-class.o
+obj-$(CONFIG_LEDS_CLASS_FLASH)		+= led-flash.o
+led-flash-objs				:= led-class-flash.o \
+					   led-flash-manager.o \
+					   led-flash-gpio-mux.o \
+					   of_led_flash_manager.o
 obj-$(CONFIG_LEDS_TRIGGERS)		+= led-triggers.o
 
 # LED Platform Drivers
diff --git a/drivers/leds/led-class-flash.c b/drivers/leds/led-class-flash.c
new file mode 100644
index 0000000..607f2d7
--- /dev/null
+++ b/drivers/leds/led-class-flash.c
@@ -0,0 +1,715 @@
+/*
+ * LED Flash Class interface
+ *
+ * Copyright (C) 2014 Samsung Electronics Co., Ltd.
+ * Author: Jacek Anaszewski <j.anaszewski@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/device.h>
+#include <linux/init.h>
+#include <linux/leds.h>
+#include <linux/led-class-flash.h>
+#include <linux/led-flash-manager.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <media/v4l2-flash.h>
+#include "leds.h"
+
+#define has_flash_op(flash, op)				\
+	(flash && flash->ops->op)
+
+#define call_flash_op(flash, op, args...)		\
+	((has_flash_op(flash, op)) ?			\
+			(flash->ops->op(flash, args)) :	\
+			-EINVAL)
+
+static ssize_t flash_brightness_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t size)
+{
+	struct led_classdev *led_cdev = dev_get_drvdata(dev);
+	struct led_classdev_flash *flash = lcdev_to_flash(led_cdev);
+	unsigned long state;
+	ssize_t ret;
+
+	mutex_lock(&led_cdev->led_lock);
+
+	if (led_sysfs_is_locked(led_cdev)) {
+		ret = -EBUSY;
+		goto unlock;
+	}
+
+	ret = kstrtoul(buf, 10, &state);
+	if (ret)
+		goto unlock;
+
+	ret = led_set_flash_brightness(flash, state);
+	if (ret < 0)
+		goto unlock;
+
+	ret = size;
+unlock:
+	mutex_unlock(&led_cdev->led_lock);
+	return ret;
+}
+
+static ssize_t flash_brightness_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct led_classdev *led_cdev = dev_get_drvdata(dev);
+	struct led_classdev_flash *flash = lcdev_to_flash(led_cdev);
+
+	/* no lock needed for this */
+	led_update_flash_brightness(flash);
+
+	return sprintf(buf, "%u\n", flash->brightness.val);
+}
+static DEVICE_ATTR_RW(flash_brightness);
+
+static ssize_t max_flash_brightness_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct led_classdev *led_cdev = dev_get_drvdata(dev);
+	struct led_classdev_flash *flash = lcdev_to_flash(led_cdev);
+
+	return sprintf(buf, "%u\n", flash->brightness.max);
+}
+static DEVICE_ATTR_RO(max_flash_brightness);
+
+static ssize_t indicator_brightness_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t size)
+{
+	struct led_classdev *led_cdev = dev_get_drvdata(dev);
+	struct led_classdev_flash *flash = lcdev_to_flash(led_cdev);
+	unsigned long state;
+	ssize_t ret;
+
+	mutex_lock(&led_cdev->led_lock);
+
+	if (led_sysfs_is_locked(led_cdev)) {
+		ret = -EBUSY;
+		goto unlock;
+	}
+
+	ret = kstrtoul(buf, 10, &state);
+	if (ret)
+		goto unlock;
+
+	ret = led_set_indicator_brightness(flash, state);
+	if (ret < 0)
+		goto unlock;
+
+	ret = size;
+unlock:
+	mutex_unlock(&led_cdev->led_lock);
+	return ret;
+}
+
+static ssize_t indicator_brightness_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct led_classdev *led_cdev = dev_get_drvdata(dev);
+	struct led_classdev_flash *flash = lcdev_to_flash(led_cdev);
+
+	/* no lock needed for this */
+	led_update_indicator_brightness(flash);
+
+	return sprintf(buf, "%u\n", flash->indicator_brightness->val);
+}
+static DEVICE_ATTR_RW(indicator_brightness);
+
+static ssize_t max_indicator_brightness_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct led_classdev *led_cdev = dev_get_drvdata(dev);
+	struct led_classdev_flash *flash = lcdev_to_flash(led_cdev);
+
+	return sprintf(buf, "%u\n", flash->indicator_brightness->max);
+}
+static DEVICE_ATTR_RO(max_indicator_brightness);
+
+static ssize_t flash_strobe_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t size)
+{
+	struct led_classdev *led_cdev = dev_get_drvdata(dev);
+	struct led_classdev_flash *flash = lcdev_to_flash(led_cdev);
+	unsigned long state;
+	ssize_t ret = -EINVAL;
+
+	mutex_lock(&led_cdev->led_lock);
+
+	if (led_sysfs_is_locked(led_cdev)) {
+		ret = -EBUSY;
+		goto unlock;
+	}
+
+	ret = kstrtoul(buf, 10, &state);
+	if (ret)
+		goto unlock;
+
+	if (state < 0 || state > 1) {
+		ret = -EINVAL;
+		goto unlock;
+	}
+
+	ret = led_set_flash_strobe(flash, state);
+	if (ret < 0)
+		goto unlock;
+	ret = size;
+unlock:
+	mutex_unlock(&led_cdev->led_lock);
+	return ret;
+}
+
+static ssize_t flash_strobe_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct led_classdev *led_cdev = dev_get_drvdata(dev);
+	struct led_classdev_flash *flash = lcdev_to_flash(led_cdev);
+	bool state;
+	int ret;
+
+	/* no lock needed for this */
+	ret = led_get_flash_strobe(flash, &state);
+	if (ret < 0)
+		return ret;
+
+	return sprintf(buf, "%u\n", state);
+}
+static DEVICE_ATTR_RW(flash_strobe);
+
+static ssize_t flash_timeout_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t size)
+{
+	struct led_classdev *led_cdev = dev_get_drvdata(dev);
+	struct led_classdev_flash *flash = lcdev_to_flash(led_cdev);
+	unsigned long flash_timeout;
+	ssize_t ret;
+
+	mutex_lock(&led_cdev->led_lock);
+
+	if (led_sysfs_is_locked(led_cdev)) {
+		ret = -EBUSY;
+		goto unlock;
+	}
+
+	ret = kstrtoul(buf, 10, &flash_timeout);
+	if (ret)
+		goto unlock;
+
+	ret = led_set_flash_timeout(flash, flash_timeout);
+	if (ret < 0)
+		goto unlock;
+
+	ret = size;
+unlock:
+	mutex_unlock(&led_cdev->led_lock);
+	return ret;
+}
+
+static ssize_t flash_timeout_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct led_classdev *led_cdev = dev_get_drvdata(dev);
+	struct led_classdev_flash *flash = lcdev_to_flash(led_cdev);
+
+	return sprintf(buf, "%u\n", flash->timeout.val);
+}
+static DEVICE_ATTR_RW(flash_timeout);
+
+static ssize_t max_flash_timeout_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct led_classdev *led_cdev = dev_get_drvdata(dev);
+	struct led_classdev_flash *flash = lcdev_to_flash(led_cdev);
+
+	return sprintf(buf, "%u\n", flash->timeout.max);
+}
+static DEVICE_ATTR_RO(max_flash_timeout);
+
+static ssize_t flash_fault_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct led_classdev *led_cdev = dev_get_drvdata(dev);
+	struct led_classdev_flash *flash = lcdev_to_flash(led_cdev);
+	u32 fault;
+	int ret;
+
+	ret = led_get_flash_fault(flash, &fault);
+	if (ret < 0)
+		return -EINVAL;
+
+	return sprintf(buf, "0x%8.8x\n", fault);
+}
+static DEVICE_ATTR_RO(flash_fault);
+
+static ssize_t external_strobe_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t size)
+{
+	struct led_classdev *led_cdev = dev_get_drvdata(dev);
+	struct led_classdev_flash *flash = lcdev_to_flash(led_cdev);
+	unsigned long external_strobe;
+	ssize_t ret;
+
+	mutex_lock(&led_cdev->led_lock);
+
+	if (led_sysfs_is_locked(led_cdev)) {
+		ret = -EBUSY;
+		goto unlock;
+	}
+
+	ret = kstrtoul(buf, 10, &external_strobe);
+	if (ret)
+		goto unlock;
+
+	if (external_strobe > 1) {
+		ret = -EINVAL;
+		goto unlock;
+	}
+
+	ret = led_set_external_strobe(flash, external_strobe);
+	if (ret < 0)
+		goto unlock;
+	ret = size;
+unlock:
+	mutex_unlock(&led_cdev->led_lock);
+	return ret;
+}
+
+static ssize_t external_strobe_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct led_classdev *led_cdev = dev_get_drvdata(dev);
+	struct led_classdev_flash *flash = lcdev_to_flash(led_cdev);
+
+	return sprintf(buf, "%u\n", flash->external_strobe);
+}
+static DEVICE_ATTR_RW(external_strobe);
+
+static struct attribute *led_flash_strobe_attrs[] = {
+	&dev_attr_flash_strobe.attr,
+	NULL,
+};
+
+static struct attribute *led_flash_indicator_attrs[] = {
+	&dev_attr_indicator_brightness.attr,
+	&dev_attr_max_indicator_brightness.attr,
+	NULL,
+};
+
+static struct attribute *led_flash_timeout_attrs[] = {
+	&dev_attr_flash_timeout.attr,
+	&dev_attr_max_flash_timeout.attr,
+	NULL,
+};
+
+static struct attribute *led_flash_brightness_attrs[] = {
+	&dev_attr_flash_brightness.attr,
+	&dev_attr_max_flash_brightness.attr,
+	NULL,
+};
+
+static struct attribute *led_flash_external_strobe_attrs[] = {
+	&dev_attr_external_strobe.attr,
+	NULL,
+};
+
+static struct attribute *led_flash_fault_attrs[] = {
+	&dev_attr_flash_fault.attr,
+	NULL,
+};
+
+static struct attribute_group led_flash_strobe_group = {
+	.attrs = led_flash_strobe_attrs,
+};
+
+static struct attribute_group led_flash_brightness_group = {
+	.attrs = led_flash_brightness_attrs,
+};
+
+static struct attribute_group led_flash_timeout_group = {
+	.attrs = led_flash_timeout_attrs,
+};
+
+static struct attribute_group led_flash_indicator_group = {
+	.attrs = led_flash_indicator_attrs,
+};
+
+static struct attribute_group led_flash_fault_group = {
+	.attrs = led_flash_fault_attrs,
+};
+
+static struct attribute_group led_flash_external_strobe_group = {
+	.attrs = led_flash_external_strobe_attrs,
+};
+
+static void led_flash_resume(struct led_classdev *led_cdev)
+{
+	struct led_classdev_flash *flash = lcdev_to_flash(led_cdev);
+
+	call_flash_op(flash, flash_brightness_set, flash->brightness.val);
+	call_flash_op(flash, timeout_set, flash->timeout.val);
+	call_flash_op(flash, indicator_brightness_set,
+				flash->indicator_brightness->val);
+}
+
+#ifdef CONFIG_V4L2_FLASH_LED_CLASS
+const struct v4l2_flash_ops led_flash_v4l2_ops = {
+	.torch_brightness_set = led_set_torch_brightness,
+	.torch_brightness_update = led_update_brightness,
+	.flash_brightness_set = led_set_flash_brightness,
+	.flash_brightness_update = led_update_flash_brightness,
+	.indicator_brightness_set = led_set_indicator_brightness,
+	.indicator_brightness_update = led_update_indicator_brightness,
+	.strobe_set = led_set_flash_strobe,
+	.strobe_get = led_get_flash_strobe,
+	.timeout_set = led_set_flash_timeout,
+	.external_strobe_set = led_set_external_strobe,
+	.fault_get = led_get_flash_fault,
+	.sysfs_lock = led_sysfs_lock,
+	.sysfs_unlock = led_sysfs_unlock,
+};
+
+const struct v4l2_flash_ops *led_get_v4l2_flash_ops(void)
+{
+	return &led_flash_v4l2_ops;
+}
+EXPORT_SYMBOL_GPL(led_get_v4l2_flash_ops);
+#endif
+
+static void led_flash_remove_sysfs_groups(struct led_classdev_flash *flash)
+{
+	struct led_classdev *led_cdev = &flash->led_cdev;
+	int i;
+
+	for (i = 0; i < LED_FLASH_MAX_SYSFS_GROUPS; ++i)
+		if (flash->sysfs_groups[i])
+			sysfs_remove_group(&led_cdev->dev->kobj,
+						flash->sysfs_groups[i]);
+}
+
+static int led_flash_create_sysfs_groups(struct led_classdev_flash *flash)
+{
+	struct led_classdev *led_cdev = &flash->led_cdev;
+	const struct led_flash_ops *ops = flash->ops;
+	int ret, num_sysfs_groups = 0;
+
+	memset(flash->sysfs_groups, 0, sizeof(*flash->sysfs_groups) *
+						LED_FLASH_MAX_SYSFS_GROUPS);
+
+	ret = sysfs_create_group(&led_cdev->dev->kobj, &led_flash_strobe_group);
+	if (ret < 0)
+		goto err_create_group;
+	flash->sysfs_groups[num_sysfs_groups++] = &led_flash_strobe_group;
+
+	if (flash->indicator_brightness) {
+		ret = sysfs_create_group(&led_cdev->dev->kobj,
+					&led_flash_indicator_group);
+		if (ret < 0)
+			goto err_create_group;
+		flash->sysfs_groups[num_sysfs_groups++] =
+					&led_flash_indicator_group;
+	}
+
+	if (ops->flash_brightness_set) {
+		ret = sysfs_create_group(&led_cdev->dev->kobj,
+					&led_flash_brightness_group);
+		if (ret < 0)
+			goto err_create_group;
+		flash->sysfs_groups[num_sysfs_groups++] =
+					&led_flash_brightness_group;
+	}
+
+	if (ops->timeout_set) {
+		ret = sysfs_create_group(&led_cdev->dev->kobj,
+					&led_flash_timeout_group);
+		if (ret < 0)
+			goto err_create_group;
+		flash->sysfs_groups[num_sysfs_groups++] =
+					&led_flash_timeout_group;
+	}
+
+	if (ops->fault_get) {
+		ret = sysfs_create_group(&led_cdev->dev->kobj,
+					&led_flash_fault_group);
+		if (ret < 0)
+			goto err_create_group;
+		flash->sysfs_groups[num_sysfs_groups++] =
+					&led_flash_fault_group;
+	}
+
+	if (flash->has_external_strobe) {
+		ret = sysfs_create_group(&led_cdev->dev->kobj,
+					&led_flash_external_strobe_group);
+		if (ret < 0)
+			goto err_create_group;
+		flash->sysfs_groups[num_sysfs_groups++] =
+					&led_flash_external_strobe_group;
+	}
+
+	return 0;
+
+err_create_group:
+	led_flash_remove_sysfs_groups(flash);
+	return ret;
+}
+
+int led_classdev_flash_register(struct device *parent,
+				struct led_classdev_flash *flash,
+				struct device_node *node)
+{
+	struct led_classdev *led_cdev;
+	const struct led_flash_ops *ops;
+	int ret = -EINVAL;
+
+	if (!flash)
+		return -EINVAL;
+
+	led_cdev = &flash->led_cdev;
+
+	/* Torch capability is default for every LED Flash Class device */
+	led_cdev->flags |= LED_DEV_CAP_TORCH;
+
+	if (led_cdev->flags & LED_DEV_CAP_FLASH) {
+		if (!led_cdev->torch_brightness_set)
+			return -EINVAL;
+
+		ops = flash->ops;
+		if (!ops || !ops->strobe_set)
+			return -EINVAL;
+
+		if ((led_cdev->flags & LED_DEV_CAP_INDICATOR) &&
+		    (!flash->indicator_brightness ||
+		     !ops->indicator_brightness_set))
+			return -EINVAL;
+
+		led_cdev->flash_resume = led_flash_resume;
+	}
+
+	/* Register led class device */
+	ret = led_classdev_register(parent, led_cdev);
+	if (ret < 0)
+		return -EINVAL;
+
+	/* Register in the flash manager if there is related data to parse */
+	if (node) {
+		ret = led_flash_manager_register_flash(flash, node);
+		if (ret < 0)
+			goto err_flash_manager_register;
+	}
+
+	/* Create flash led specific sysfs attributes */
+	ret = led_flash_create_sysfs_groups(flash);
+	if (ret < 0)
+		goto err_create_sysfs_groups;
+
+	return 0;
+
+err_create_sysfs_groups:
+	led_flash_manager_unregister_flash(flash);
+err_flash_manager_register:
+	led_classdev_unregister(led_cdev);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(led_classdev_flash_register);
+
+void led_classdev_flash_unregister(struct led_classdev_flash *flash)
+{
+	led_flash_remove_sysfs_groups(flash);
+	led_flash_manager_unregister_flash(flash);
+	led_classdev_unregister(&flash->led_cdev);
+}
+EXPORT_SYMBOL_GPL(led_classdev_flash_unregister);
+
+int led_set_flash_strobe(struct led_classdev_flash *flash, bool state)
+{
+	struct led_classdev *led_cdev = &flash->led_cdev;
+	int ret = 0;
+
+	if (flash->external_strobe)
+		return -EBUSY;
+
+	/* strobe can be stopped without flash manager involvement */
+	if (!state)
+		return call_flash_op(flash, strobe_set, state);
+
+	/*
+	 * Flash manager needs to be involved in setting flash
+	 * strobe if there were strobe gates defined in the
+	 * device tree binding. This call blocks the caller for
+	 * the current flash timeout period if state == true and
+	 * the flash led device depends on shared muxes. Locking is
+	 * required for assuring that nobody will reconfigure muxes
+	 * in the meantime.
+	 */
+	if ((led_cdev->flags & LED_DEV_CAP_FL_MANAGER))
+		ret = led_flash_manager_setup_strobe(flash, false);
+	else
+		ret = call_flash_op(flash, strobe_set, true);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(led_set_flash_strobe);
+
+int led_get_flash_strobe(struct led_classdev_flash *flash, bool *state)
+{
+	return call_flash_op(flash, strobe_get, state);
+}
+EXPORT_SYMBOL_GPL(led_get_flash_strobe);
+
+void led_clamp_align(struct led_flash_setting *s)
+{
+	u32 v, offset;
+
+	v = s->val + s->step / 2;
+	v = clamp(v, s->min, s->max);
+	offset = v - s->min;
+	offset = s->step * (offset / s->step);
+	s->val = s->min + offset;
+}
+
+int led_set_flash_timeout(struct led_classdev_flash *flash, u32 timeout)
+{
+	struct led_classdev *led_cdev = &flash->led_cdev;
+	struct led_flash_setting *s = &flash->timeout;
+	int ret = 0;
+
+	s->val = timeout;
+	led_clamp_align(s);
+
+	if (!(led_cdev->flags & LED_SUSPENDED))
+		ret = call_flash_op(flash, timeout_set, s->val);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(led_set_flash_timeout);
+
+int led_get_flash_fault(struct led_classdev_flash *flash, u32 *fault)
+{
+	return call_flash_op(flash, fault_get, fault);
+}
+EXPORT_SYMBOL_GPL(led_get_flash_fault);
+
+int led_set_external_strobe(struct led_classdev_flash *flash, bool enable)
+{
+	struct led_classdev *led_cdev = &flash->led_cdev;
+	int ret;
+
+	if (flash->has_external_strobe) {
+		/*
+		 * Some flash led devices need altering their register
+		 * settings to start listen to the external strobe signal.
+		 */
+		if (has_flash_op(flash, external_strobe_set)) {
+			ret = call_flash_op(flash, external_strobe_set, enable);
+			if (ret < 0)
+				return ret;
+		}
+
+		flash->external_strobe = enable;
+
+		/*
+		 * Flash manager needs to be involved in setting external
+		 * strobe mode if there were strobe gates defined in the
+		 * device tree binding. This call blocks the caller for
+		 * the current flash timeout period if enable == true and
+		 * the flash led device depends on shared muxes. Locking is
+		 * required for assuring that nobody will reconfigure muxes
+		 * while the flash device is awaiting external strobe signal.
+		 */
+		if (enable && (led_cdev->flags & LED_DEV_CAP_FL_MANAGER)) {
+			ret = led_flash_manager_setup_strobe(flash, true);
+			if (ret < 0)
+				return ret;
+		}
+	} else if (enable) {
+		return -EINVAL;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(led_set_external_strobe);
+
+int led_set_flash_brightness(struct led_classdev_flash *flash,
+				u32 brightness)
+{
+	struct led_classdev *led_cdev = &flash->led_cdev;
+	struct led_flash_setting *s = &flash->brightness;
+	int ret = 0;
+
+	s->val = brightness;
+	led_clamp_align(s);
+
+	if (!(led_cdev->flags & LED_SUSPENDED))
+		ret = call_flash_op(flash, flash_brightness_set, s->val);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(led_set_flash_brightness);
+
+int led_update_flash_brightness(struct led_classdev_flash *flash)
+{
+	struct led_flash_setting *s = &flash->brightness;
+	u32 brightness;
+	int ret = 0;
+
+	if (has_flash_op(flash, flash_brightness_get)) {
+		ret = call_flash_op(flash, flash_brightness_get,
+						&brightness);
+		if (ret < 0)
+			return ret;
+		s->val = brightness;
+	}
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(led_update_flash_brightness);
+
+int led_set_indicator_brightness(struct led_classdev_flash *flash,
+					u32 brightness)
+{
+	struct led_classdev *led_cdev = &flash->led_cdev;
+	struct led_flash_setting *s = flash->indicator_brightness;
+	int ret = 0;
+
+	if (!s)
+		return -EINVAL;
+
+	s->val = brightness;
+	led_clamp_align(s);
+
+	if (!(led_cdev->flags & LED_SUSPENDED))
+		ret = call_flash_op(flash, indicator_brightness_set, s->val);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(led_set_indicator_brightness);
+
+int led_update_indicator_brightness(struct led_classdev_flash *flash)
+{
+	struct led_flash_setting *s = flash->indicator_brightness;
+	u32 brightness;
+	int ret = 0;
+
+	if (!s)
+		return -EINVAL;
+
+	if (has_flash_op(flash, indicator_brightness_get)) {
+		ret = call_flash_op(flash, indicator_brightness_get,
+							&brightness);
+		if (ret < 0)
+			return ret;
+		s->val = brightness;
+	}
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(led_update_indicator_brightness);
+
+MODULE_AUTHOR("Jacek Anaszewski <j.anaszewski@samsung.com>");
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("LED Flash Class Interface");
diff --git a/drivers/leds/led-class.c b/drivers/leds/led-class.c
index c17dda0..165a1fb 100644
--- a/drivers/leds/led-class.c
+++ b/drivers/leds/led-class.c
@@ -189,6 +189,10 @@ EXPORT_SYMBOL_GPL(led_classdev_suspend);
 void led_classdev_resume(struct led_classdev *led_cdev)
 {
 	led_cdev->brightness_set(led_cdev, led_cdev->brightness);
+
+	if (led_cdev->flash_resume)
+		led_cdev->flash_resume(led_cdev);
+
 	led_cdev->flags &= ~LED_SUSPENDED;
 }
 EXPORT_SYMBOL_GPL(led_classdev_resume);
diff --git a/drivers/leds/led-flash-gpio-mux.c b/drivers/leds/led-flash-gpio-mux.c
new file mode 100644
index 0000000..2803fcc
--- /dev/null
+++ b/drivers/leds/led-flash-gpio-mux.c
@@ -0,0 +1,102 @@
+/*
+ * LED Flash Class gpio mux
+ *
+ *      Copyright (C) 2014 Samsung Electronics Co., Ltd
+ *      Author: Jacek Anaszewski <j.anaszewski@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation."
+ */
+
+#include <linux/gpio.h>
+#include <linux/led-flash-gpio-mux.h>
+#include <linux/of_gpio.h>
+#include <linux/slab.h>
+
+int led_flash_gpio_mux_select_line(u32 line_id, void *mux)
+{
+	struct led_flash_gpio_mux *gpio_mux = (struct led_flash_gpio_mux *) mux;
+	struct led_flash_gpio_mux_selector *sel;
+	u32 mask = 1;
+
+	/* Setup selectors */
+	list_for_each_entry(sel, &gpio_mux->selectors, list) {
+		gpio_set_value(sel->gpio, !!(line_id & mask));
+		mask <<= 1;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(led_flash_gpio_mux_select_line);
+
+/* Create standard gpio mux */
+int led_flash_gpio_mux_create(struct led_flash_gpio_mux **new_mux,
+			      struct device_node *mux_node)
+{
+	struct led_flash_gpio_mux *mux;
+	struct led_flash_gpio_mux_selector *sel;
+	int gpio_num, gpio, ret, i;
+	char gpio_name[20];
+	static int cnt_gpio;
+
+	/* Get the number of mux selectors */
+	gpio_num = of_gpio_count(mux_node);
+	if (gpio_num == 0)
+		return -EINVAL;
+
+	mux = kzalloc(sizeof(*mux), GFP_KERNEL);
+	if (!mux)
+		return -ENOMEM;
+
+	INIT_LIST_HEAD(&mux->selectors);
+
+	/* Request gpios for all selectors */
+	for (i = 0; i < gpio_num; ++i) {
+		gpio = of_get_gpio(mux_node, i);
+		if (gpio_is_valid(gpio)) {
+			sprintf(gpio_name, "v4l2_mux selector %d", cnt_gpio++);
+			ret = gpio_request_one(gpio, GPIOF_DIR_OUT, gpio_name);
+			if (ret < 0)
+				goto err_gpio_request;
+
+			/* Add new entry to the gpio selectors list */
+			sel = kzalloc(sizeof(*sel), GFP_KERNEL);
+			if (!sel) {
+				ret = -ENOMEM;
+				goto err_gpio_request;
+			}
+			sel->gpio = gpio;
+
+			list_add_tail(&sel->list, &mux->selectors);
+		} else {
+			ret = -EINVAL;
+			goto err_gpio_request;
+		}
+
+	}
+
+	*new_mux = mux;
+
+	return 0;
+
+err_gpio_request:
+	led_flash_gpio_mux_release(mux);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(led_flash_gpio_mux_create);
+
+void led_flash_gpio_mux_release(void *mux)
+{
+	struct led_flash_gpio_mux *gpio_mux = (struct led_flash_gpio_mux *) mux;
+	struct led_flash_gpio_mux_selector *sel, *n;
+
+	list_for_each_entry_safe(sel, n, &gpio_mux->selectors, list) {
+		if (gpio_is_valid(sel->gpio))
+			gpio_free(sel->gpio);
+		kfree(sel);
+	}
+	kfree(gpio_mux);
+}
+EXPORT_SYMBOL_GPL(led_flash_gpio_mux_release);
diff --git a/drivers/leds/led-flash-manager.c b/drivers/leds/led-flash-manager.c
new file mode 100644
index 0000000..2133277
--- /dev/null
+++ b/drivers/leds/led-flash-manager.c
@@ -0,0 +1,698 @@
+/*
+ *  LED Flash Manager for maintaining LED Flash Class devices
+ *  along with their corresponding muxex, faciliating dynamic
+ *  reconfiguration of the strobe signal source.
+ *
+ *	Copyright (C) 2014 Samsung Electronics Co., Ltd
+ *	Author: Jacek Anaszewski <j.anaszewski@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation."
+ */
+
+#include <linux/delay.h>
+#include <linux/led-class-flash.h>
+#include <linux/led-flash-gpio-mux.h>
+#include <linux/led-flash-manager.h>
+#include <linux/module.h>
+#include <linux/mutex.h>
+#include <linux/of_gpio.h>
+#include <linux/of_led_flash_manager.h>
+#include <linux/slab.h>
+
+static LIST_HEAD(flash_list);
+static LIST_HEAD(mux_bound_list);
+static LIST_HEAD(mux_waiting_list);
+static DEFINE_MUTEX(fm_lock);
+
+static ssize_t strobe_provider_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t size)
+{
+	struct led_classdev *led_cdev = dev_get_drvdata(dev);
+	struct led_classdev_flash *flash = lcdev_to_flash(led_cdev);
+	unsigned long provider_id;
+	ssize_t ret;
+
+	mutex_lock(&led_cdev->led_lock);
+
+	if (led_sysfs_is_locked(led_cdev)) {
+		ret = -EBUSY;
+		goto unlock;
+	}
+
+	ret = kstrtoul(buf, 10, &provider_id);
+	if (ret)
+		goto unlock;
+
+	if (provider_id > flash->num_strobe_providers - 1) {
+		ret = -ERANGE;
+		goto unlock;
+	}
+
+	flash->strobe_provider_id = provider_id;
+
+	ret = size;
+unlock:
+	mutex_unlock(&led_cdev->led_lock);
+	return ret;
+}
+
+static ssize_t strobe_provider_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct led_classdev *led_cdev = dev_get_drvdata(dev);
+	struct led_classdev_flash *flash = lcdev_to_flash(led_cdev);
+
+	return sprintf(buf, "%u\n", flash->strobe_provider_id);
+}
+static DEVICE_ATTR_RW(strobe_provider);
+
+static ssize_t available_strobe_providers_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct led_flash_strobe_provider *provider =
+		container_of(attr, struct led_flash_strobe_provider, attr);
+	const char *no_name = "undefined";
+	const char *provider_name;
+
+	provider_name = provider->name ? provider->name :
+					 no_name;
+
+	return sprintf(buf, "%s\n", provider_name);
+}
+
+static ssize_t blocking_strobe_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct led_classdev *led_cdev = dev_get_drvdata(dev);
+	struct led_classdev_flash *flash = lcdev_to_flash(led_cdev);
+
+	return sprintf(buf, "%u\n", !!flash->num_shared_muxes);
+}
+static DEVICE_ATTR_RO(blocking_strobe);
+
+static int led_flash_manager_create_providers_attrs(
+					struct led_classdev_flash *flash)
+{
+	struct led_flash_strobe_provider *provider;
+	struct led_classdev *led_cdev = &flash->led_cdev;
+	int cnt_attr = 0;
+	int ret;
+
+	list_for_each_entry(provider, &flash->strobe_providers, list) {
+		provider->attr.show = available_strobe_providers_show;
+		provider->attr.attr.mode = S_IRUGO;
+
+		sprintf(provider->attr_name, "strobe_provider%d",
+							cnt_attr++);
+		provider->attr.attr.name = provider->attr_name;
+
+		sysfs_attr_init(&provider->attr.attr);
+
+		ret = sysfs_create_file(&led_cdev->dev->kobj,
+						&provider->attr.attr);
+		if (ret < 0)
+			goto error_create_attr;
+
+		provider->attr_registered = true;
+	}
+
+	/*
+	 * strobe_provider attribute is required only if there have been more
+	 * than one strobe source defined for the LED Flash Class device.
+	 */
+	if (cnt_attr > 1) {
+		ret = sysfs_create_file(&led_cdev->dev->kobj,
+					&dev_attr_strobe_provider.attr);
+		if (ret < 0)
+			goto error_create_attr;
+	}
+
+	return 0;
+
+error_create_attr:
+	list_for_each_entry(provider, &flash->strobe_providers, list) {
+		if (!provider->attr_registered)
+			break;
+		sysfs_remove_file(&led_cdev->dev->kobj, &provider->attr.attr);
+	}
+
+	return ret;
+}
+
+static void led_flash_manager_remove_providers_attrs(
+					struct led_classdev_flash *flash)
+{
+	struct led_flash_strobe_provider *provider;
+	struct led_classdev *led_cdev = &flash->led_cdev;
+	int cnt_attr = 0;
+
+	list_for_each_entry(provider, &flash->strobe_providers, list) {
+		if (!provider->attr_registered)
+			break;
+		sysfs_remove_file(&led_cdev->dev->kobj, &provider->attr.attr);
+		provider->attr_registered = false;
+		++cnt_attr;
+	}
+
+	/*
+	 * If there was more than one strobe_providerN attr to remove
+	 * than there is also strobe_provider attr to remove.
+	 */
+	if (cnt_attr > 1)
+		sysfs_remove_file(&led_cdev->dev->kobj,
+				  &dev_attr_strobe_provider.attr);
+}
+
+/* Return mux associated with gate */
+static struct led_flash_mux *led_flash_manager_get_mux_by_gate(
+					struct led_flash_strobe_gate *gate,
+					struct list_head *mux_list)
+{
+	struct led_flash_mux *mux;
+
+	list_for_each_entry(mux, mux_list, list)
+		if (mux->node == gate->mux_node)
+			return mux;
+
+	return NULL;
+}
+
+/* Setup all muxes in the gate list */
+static int led_flash_manager_setup_muxes(struct led_classdev_flash *flash,
+					  struct list_head *gate_list)
+{
+	struct led_classdev *led_cdev = &flash->led_cdev;
+	struct led_flash_strobe_gate *gate;
+	struct led_flash_mux *mux;
+	struct device *dev = led_cdev->dev->parent;
+	int ret = 0;
+
+	list_for_each_entry(gate, gate_list, list) {
+		mux = led_flash_manager_get_mux_by_gate(gate, &mux_bound_list);
+		if (!mux) {
+			dev_err(dev, "Flash mux not bound (%s)\n",
+				gate->mux_node->name);
+			return -ENODEV;
+		}
+
+		ret = mux->ops->select_line(gate->line_id,
+						mux->private_data);
+	}
+
+	return ret;
+}
+
+/*
+ * Setup all muxes required to open the route
+ * to the external strobe signal provider
+ */
+static int led_flash_manager_select_strobe_provider(
+					struct led_classdev_flash *flash,
+					int provider_id)
+{
+	struct led_flash_strobe_provider *provider;
+	int ret, provider_cnt = 0;
+
+	list_for_each_entry(provider, &flash->strobe_providers, list)
+		if (provider_cnt++ == provider_id) {
+			ret = led_flash_manager_setup_muxes(flash,
+						&provider->strobe_gates);
+			return ret;
+		}
+
+	return -EINVAL;
+}
+
+/*
+ * Setup all muxes required to open the route
+ * either to software or external strobe source.
+ */
+static int led_flash_manager_set_external_strobe(
+					struct led_classdev_flash *flash,
+					bool external)
+{
+	int ret;
+
+	if (external)
+		ret = led_flash_manager_select_strobe_provider(flash,
+						flash->strobe_provider_id);
+	else
+		ret = led_flash_manager_setup_muxes(flash,
+						&flash->software_strobe_gates);
+
+	return ret;
+}
+
+/* Notify flash manager that async mux is available. */
+int led_flash_manager_bind_async_mux(struct led_flash_mux *async_mux)
+{
+	struct led_flash_mux *mux;
+	bool mux_found = false;
+	int ret = 0;
+
+	if (!async_mux)
+		return -EINVAL;
+
+	mutex_lock(&fm_lock);
+
+	/*
+	 * Check whether the LED Flash Class device using this
+	 * mux has been already registered in the flash manager.
+	 */
+	list_for_each_entry(mux, &mux_waiting_list, list)
+		if (async_mux->node == mux->node) {
+			/* Move the mux to the bound muxes list */
+
+			list_move(&mux->list, &mux_bound_list);
+			mux_found = true;
+
+			if (!try_module_get(async_mux->owner)) {
+				ret = -ENODEV;
+				goto unlock;
+			}
+
+			break;
+		}
+
+	if (!mux_found) {
+		/* This is a new mux - create its representation */
+		mux = kzalloc(sizeof(*mux), GFP_KERNEL);
+		if (!mux) {
+			ret = -ENOMEM;
+			goto unlock;
+		}
+
+		INIT_LIST_HEAD(&mux->refs);
+
+		/* Add the mux to the bound list. */
+		list_add(&mux->list, &mux_bound_list);
+	}
+
+	mux->ops = async_mux->ops;
+	mux->node = async_mux->node;
+	mux->owner = async_mux->owner;
+
+unlock:
+	mutex_unlock(&fm_lock);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(led_flash_manager_bind_async_mux);
+
+int led_flash_manager_unbind_async_mux(struct device_node *mux_node)
+{
+	struct led_flash_mux *mux;
+	int ret = -ENODEV;
+
+	mutex_lock(&fm_lock);
+
+	/*
+	 * Mux can be unbound only when is not used by any
+	 * flash led device, otherwise this is erroneous call.
+	 */
+	list_for_each_entry(mux, &mux_waiting_list, list)
+		if (mux->node == mux_node) {
+			list_move(&mux->list, &mux_waiting_list);
+			ret = 0;
+			break;
+		}
+
+	mutex_unlock(&fm_lock);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(led_flash_manager_unbind_async_mux);
+
+struct led_flash_mux_ops gpio_mux_ops = {
+	.select_line = led_flash_gpio_mux_select_line,
+	.release_private_data = led_flash_gpio_mux_release,
+};
+
+static int __add_mux_ref(struct led_flash_mux_ref *ref,
+				struct led_flash_mux *mux)
+{
+	struct led_flash_mux_ref *r;
+	int ret;
+
+	/*
+	 * A flash can be associated with a mux through
+	 * more than one gate - increment mux reference
+	 * count in such a case.
+	 */
+	list_for_each_entry(r, &mux->refs, list)
+		if (r->flash == ref->flash)
+			return 0;
+
+	/* protect async mux against rmmod */
+	if (mux->owner) {
+		ret = try_module_get(mux->owner);
+		if (ret < 0)
+			return ret;
+	}
+
+	list_add(&ref->list, &mux->refs);
+	++mux->num_refs;
+
+	if (mux->num_refs == 2) {
+		list_for_each_entry(r, &mux->refs, list) {
+			++r->flash->num_shared_muxes;
+		}
+		return 0;
+	}
+
+	if (mux->num_refs > 2)
+		++ref->flash->num_shared_muxes;
+
+	return 0;
+}
+
+static void __remove_mux_ref(struct led_flash_mux_ref *ref,
+				struct led_flash_mux *mux)
+{
+	struct led_flash_mux_ref *r;
+
+	/* decrement async mux refcount */
+	if (mux->owner)
+		module_put(mux->owner);
+
+	list_del(&ref->list);
+	--mux->num_refs;
+
+	if (mux->num_refs == 1) {
+		r = list_first_entry(&mux->refs, struct led_flash_mux_ref,
+						list);
+		--r->flash->num_shared_muxes;
+		return;
+	}
+
+	if (mux->num_refs > 1)
+		--ref->flash->num_shared_muxes;
+}
+
+/*
+ * Parse mux node and add the mux it refers to either to waiting
+ * or bound list depending on the mux type (gpio or asynchronous).
+ */
+static int led_flash_manager_parse_mux_node(struct led_classdev_flash *flash,
+					    struct led_flash_strobe_gate *gate)
+{
+	struct led_flash_mux *mux;
+	struct device_node *async_mux_node;
+	struct led_flash_gpio_mux *gpio_mux;
+	struct led_flash_mux_ref *ref;
+	int ret = -EINVAL;
+
+	/* Create flash ref to be added to the mux references list */
+	ref = kzalloc(sizeof(*ref), GFP_KERNEL);
+	if (!ref)
+		return -ENOMEM;
+	ref->flash = flash;
+
+	/* if this is async mux update gate's mux_node accordingly */
+	async_mux_node = of_parse_phandle(gate->mux_node, "mux-async", 0);
+	if (async_mux_node)
+		gate->mux_node = async_mux_node;
+
+	/* Check if the mux isn't already on waiting list */
+	list_for_each_entry(mux, &mux_waiting_list, list)
+		if (mux->node == gate->mux_node)
+			return __add_mux_ref(ref, mux);
+
+	/* Check if the mux isn't already on bound list */
+	list_for_each_entry(mux, &mux_bound_list, list)
+		if (mux->node == gate->mux_node)
+			return __add_mux_ref(ref, mux);
+
+	/* This is a new mux - create its representation */
+	mux = kzalloc(sizeof(*mux), GFP_KERNEL);
+	if (!mux)
+		return -ENOMEM;
+
+	mux->node = gate->mux_node;
+
+	INIT_LIST_HEAD(&mux->refs);
+
+	/* Increment reference count */
+	ret = __add_mux_ref(ref, mux);
+	if (ret < 0)
+		return ret;
+
+	/*
+	 * Check if this mux has its own driver
+	 * or this is standard gpio mux.
+	 */
+	if (async_mux_node) {
+		/* Add async mux to the waiting list */
+		list_add(&mux->list, &mux_waiting_list);
+	} else {
+		/* Create default gpio mux */
+		ret = led_flash_gpio_mux_create(&gpio_mux, gate->mux_node);
+		if (ret < 0)
+			goto err_gpio_mux_init;
+
+		/* Register gpio mux device */
+		mux->private_data = gpio_mux;
+		mux->ops = &gpio_mux_ops;
+		list_add(&mux->list, &mux_bound_list);
+	}
+
+	return 0;
+
+err_gpio_mux_init:
+	kfree(mux);
+	kfree(ref);
+
+	return ret;
+}
+
+static void led_flash_manager_release_mux(struct led_flash_mux *mux)
+{
+	if (mux->ops->release_private_data) {
+		if (mux->ops->release_private_data)
+			mux->ops->release_private_data(mux->private_data);
+		list_del(&mux->list);
+		kfree(mux);
+	}
+}
+
+static void led_flash_manager_remove_flash_refs(
+					struct led_classdev_flash *flash)
+{
+	struct led_flash_mux_ref *ref, *rn;
+	struct led_flash_mux *mux, *mn;
+
+	/*
+	 * Remove references to the flash from
+	 * all the muxes on the list.
+	 */
+	list_for_each_entry_safe(mux, mn, &mux_bound_list, list)
+		/* Seek for matching flash ref */
+		list_for_each_entry_safe(ref, rn, &mux->refs, list)
+			if (ref->flash == flash) {
+				/* Decrement reference count */
+				__remove_mux_ref(ref, mux);
+				kfree(ref);
+				/*
+				 * Release mux if there are no more
+				 * references pointing to it.
+				 */
+				if (list_empty(&mux->refs))
+					led_flash_manager_release_mux(mux);
+			}
+}
+
+int led_flash_manager_setup_strobe(struct led_classdev_flash *flash,
+				 bool external)
+{
+	u32 flash_timeout = flash->timeout.val / 1000;
+	int ret;
+
+	mutex_lock(&fm_lock);
+
+	/* Setup muxes */
+	ret = led_flash_manager_set_external_strobe(flash, external);
+	if (ret < 0)
+		goto unlock;
+
+	/*
+	 * Trigger software strobe under flash manager lock
+	 * to make sure that nobody will reconfigure muxes
+	 * in the meantime.
+	 */
+	if (!external) {
+		ret = flash->ops->strobe_set(flash, true);
+		if (ret < 0)
+			goto unlock;
+	}
+
+	/*
+	 * Hold lock for the time of strobing if the
+	 * LED Flash Class device depends on shared muxes.
+	 */
+	if (flash->num_shared_muxes > 0) {
+		msleep(flash_timeout);
+		/*
+		 * external strobe is turned on only for the time of
+		 * this call if there are shared muxes involved
+		 * in strobe signal routing.
+		 */
+		flash->external_strobe = false;
+	}
+
+unlock:
+	mutex_unlock(&fm_lock);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(led_flash_manager_setup_strobe);
+
+int led_flash_manager_create_sysfs_attrs(struct led_classdev_flash *flash)
+{
+	struct led_classdev *led_cdev = &flash->led_cdev;
+	int ret;
+
+	/*
+	 * Create sysfs attribtue for indicating if activation of
+	 * software or external flash strobe will block the caller.
+	 */
+	sysfs_attr_init(&dev_attr_blocking_strobe.attr);
+	ret = sysfs_create_file(&led_cdev->dev->kobj,
+					&dev_attr_blocking_strobe.attr);
+	if (ret < 0)
+		return ret;
+
+	/* Create strobe_providerN attributes */
+	ret = led_flash_manager_create_providers_attrs(flash);
+	if (ret < 0)
+		goto err_create_provider_attrs;
+
+	return 0;
+
+err_create_provider_attrs:
+	sysfs_remove_file(&led_cdev->dev->kobj,
+				&dev_attr_blocking_strobe.attr);
+
+	return ret;
+}
+
+void led_flash_manager_remove_sysfs_attrs(struct led_classdev_flash *flash)
+{
+	struct led_classdev *led_cdev = &flash->led_cdev;
+
+	led_flash_manager_remove_providers_attrs(flash);
+	sysfs_remove_file(&led_cdev->dev->kobj,
+				&dev_attr_blocking_strobe.attr);
+}
+
+int led_flash_manager_register_flash(struct led_classdev_flash *flash,
+				     struct device_node *node)
+{
+	struct led_flash_strobe_provider *provider;
+	struct led_flash_strobe_gate *gate;
+	struct led_classdev_flash *fl;
+	struct led_classdev *led_cdev = &flash->led_cdev;
+	int ret = 0;
+
+	if (!flash || !node)
+		return -EINVAL;
+
+	mutex_lock(&fm_lock);
+
+	/* Don't allow to register the same flash more than once */
+	list_for_each_entry(fl, &flash_list, list)
+		if (fl == flash)
+			goto unlock;
+
+	INIT_LIST_HEAD(&flash->software_strobe_gates);
+	INIT_LIST_HEAD(&flash->strobe_providers);
+
+	ret = of_led_flash_manager_parse_dt(flash, node);
+	if (ret < 0)
+		goto unlock;
+
+	/*
+	 * Register mux devices declared by the flash device
+	 * if they have not been yet known to the flash manager.
+	 */
+	list_for_each_entry(gate, &flash->software_strobe_gates, list) {
+		ret = led_flash_manager_parse_mux_node(flash, gate);
+		if (ret < 0)
+			goto err_parse_mux_node;
+	}
+
+	list_for_each_entry(provider, &flash->strobe_providers, list) {
+		list_for_each_entry(gate, &provider->strobe_gates, list) {
+			ret = led_flash_manager_parse_mux_node(flash, gate);
+			if (ret < 0)
+				goto err_parse_mux_node;
+		}
+		++flash->num_strobe_providers;
+	}
+
+	/*
+	 * It doesn't make sense to register in the flash manager
+	 * if there are no strobe providers defined.
+	 */
+	if (flash->num_strobe_providers == 0)
+		goto unlock;
+
+	led_cdev->flags |= LED_DEV_CAP_FL_MANAGER;
+	flash->has_external_strobe = true;
+	flash->strobe_provider_id = 0;
+
+	ret = led_flash_manager_create_sysfs_attrs(flash);
+	if (ret < 0)
+		goto err_parse_mux_node;
+
+	/* Add flash to the list of flashes maintained by the flash manager. */
+	list_add_tail(&flash->list, &flash_list);
+
+	mutex_unlock(&fm_lock);
+
+	return ret;
+
+err_parse_mux_node:
+	led_flash_manager_remove_flash_refs(flash);
+	of_led_flash_manager_release_dt_data(flash);
+unlock:
+	mutex_unlock(&fm_lock);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(led_flash_manager_register_flash);
+
+void led_flash_manager_unregister_flash(struct led_classdev_flash *flash)
+{
+	struct led_classdev_flash *fl, *n;
+	bool found_flash = false;
+
+	mutex_lock(&fm_lock);
+
+	/* Remove flash from the list, if found */
+	list_for_each_entry_safe(fl, n, &flash_list, list)
+		if (fl == flash) {
+			found_flash = true;
+			break;
+		}
+
+	if (!found_flash)
+		goto unlock;
+
+	list_del(&fl->list);
+
+	led_flash_manager_remove_sysfs_attrs(flash);
+
+	/* Remove all references to the flash */
+	led_flash_manager_remove_flash_refs(flash);
+	of_led_flash_manager_release_dt_data(flash);
+
+unlock:
+	mutex_unlock(&fm_lock);
+}
+EXPORT_SYMBOL_GPL(led_flash_manager_unregister_flash);
+
+MODULE_AUTHOR("Jacek Anaszewski <j.anaszewski@samsung.com>");
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("LED Flash Manager");
diff --git a/drivers/leds/led-triggers.c b/drivers/leds/led-triggers.c
index 0545530..e8380bb 100644
--- a/drivers/leds/led-triggers.c
+++ b/drivers/leds/led-triggers.c
@@ -41,6 +41,11 @@ ssize_t led_trigger_store(struct device *dev, struct device_attribute *attr,
 
 	mutex_lock(&led_cdev->led_lock);
 
+	if (led_sysfs_is_locked(led_cdev)) {
+		ret = -EBUSY;
+		goto exit_unlock;
+	}
+
 	trigger_name[sizeof(trigger_name) - 1] = '\0';
 	strncpy(trigger_name, buf, sizeof(trigger_name) - 1);
 	len = strlen(trigger_name);
diff --git a/drivers/leds/of_led_flash_manager.c b/drivers/leds/of_led_flash_manager.c
new file mode 100644
index 0000000..d22d853
--- /dev/null
+++ b/drivers/leds/of_led_flash_manager.c
@@ -0,0 +1,155 @@
+/*
+ * LED flash manager of helpers.
+ *
+ *	Copyright (C) 2014 Samsung Electronics Co., Ltd
+ *	Author: Jacek Anaszewski <j.anaszewski@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation."
+ */
+
+#include <linux/device.h>
+#include <linux/led-class-flash.h>
+#include <linux/of.h>
+#include <linux/of_led_flash_manager.h>
+#include <linux/slab.h>
+
+static int __parse_strobe_gate_node(struct led_classdev_flash *flash,
+				    struct device_node *node,
+				    struct list_head *gates)
+{
+	struct device_node *mux_node, *subnode;
+	struct led_flash_strobe_gate *gate;
+	struct led_classdev *led_cdev = &flash->led_cdev;
+	u32 line_id;
+	int ret, num_gates = 0;
+
+	/* Get node mux node */
+	mux_node = of_parse_phandle(node, "mux", 0);
+	if (!mux_node)
+		return -EINVAL;
+
+	/* Get the value the mux has to be written to open the gate */
+	ret = of_property_read_u32(node, "mux-line-id", &line_id);
+	if (ret < 0)
+		return ret;
+
+	gate = kzalloc(sizeof(*gate), GFP_KERNEL);
+	if (!gate)
+		return -ENOMEM;
+
+	gate->mux_node = mux_node;
+	gate->line_id = line_id;
+	list_add_tail(&gate->list, gates);
+
+	/* Parse nested gate nodes */
+	for_each_available_child_of_node(node, subnode) {
+		if (!of_node_ncmp(subnode->name, "gate", 4)) {
+			ret = __parse_strobe_gate_node(flash, subnode, gates);
+			if (ret < 0) {
+				dev_dbg(led_cdev->dev->parent,
+				"Failed to parse gate node (%d)\n",
+				ret);
+				goto err_parse_gate;
+			}
+
+			if (++num_gates > 1) {
+				dev_dbg(led_cdev->dev->parent,
+				"Only one available child gate is allowed.\n");
+				ret = -EINVAL;
+				goto err_parse_gate;
+			}
+		}
+	}
+
+	return 0;
+
+err_parse_gate:
+	kfree(gate);
+
+	return ret;
+}
+
+static int __parse_strobe_provider_node(struct led_classdev_flash *flash,
+			       struct device_node *node)
+{
+	struct device_node *provider_node;
+	struct led_flash_strobe_provider *provider;
+	int ret;
+
+	/* Create strobe provider representation */
+	provider = kzalloc(sizeof(*provider), GFP_KERNEL);
+	if (!provider)
+		return -ENOMEM;
+
+	/* Get phandle of the device generating strobe source signal */
+	provider_node = of_parse_phandle(node, "strobe-provider", 0);
+
+	/* provider property may be absent */
+	if (provider_node) {
+		/* Use compatible property as a strobe provider name */
+		ret = of_property_read_string(provider_node, "compatible",
+					(const char **) &provider->name);
+		if (ret < 0)
+			goto err_read_name;
+	}
+
+	INIT_LIST_HEAD(&provider->strobe_gates);
+
+	list_add_tail(&provider->list, &flash->strobe_providers);
+
+	ret = __parse_strobe_gate_node(flash, node, &provider->strobe_gates);
+	if (ret < 0)
+		goto err_read_name;
+
+	return 0;
+
+err_read_name:
+	kfree(provider);
+
+	return ret;
+}
+
+int of_led_flash_manager_parse_dt(struct led_classdev_flash *flash,
+				  struct device_node *node)
+{
+	struct device_node *subnode;
+	int ret;
+
+	for_each_available_child_of_node(node, subnode) {
+		if (!of_node_cmp(subnode->name, "gate-software-strobe")) {
+			ret = __parse_strobe_gate_node(flash, subnode,
+						&flash->software_strobe_gates);
+			if (ret < 0)
+				return ret;
+		}
+		if (!of_node_ncmp(subnode->name, "gate-external-strobe", 20)) {
+			ret = __parse_strobe_provider_node(flash, subnode);
+			if (ret < 0)
+				return ret;
+		}
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(of_led_flash_manager_parse_dt);
+
+void of_led_flash_manager_release_dt_data(struct led_classdev_flash *flash)
+{
+	struct list_head *gate_list;
+	struct led_flash_strobe_gate *gate, *gn;
+	struct led_flash_strobe_provider *provider, *sn;
+
+	gate_list = &flash->software_strobe_gates;
+	list_for_each_entry_safe(gate, gn, gate_list, list)
+		kfree(gate);
+
+	list_for_each_entry_safe(provider, sn, &flash->strobe_providers, list) {
+		list_for_each_entry_safe(gate, gn, &provider->strobe_gates,
+								list)
+			kfree(gate);
+		kfree(provider);
+	}
+}
+EXPORT_SYMBOL_GPL(of_led_flash_manager_release_dt_data);
diff --git a/include/linux/led-class-flash.h b/include/linux/led-class-flash.h
new file mode 100644
index 0000000..6ed7e8a
--- /dev/null
+++ b/include/linux/led-class-flash.h
@@ -0,0 +1,290 @@
+/*
+ * LED Flash Class interface
+ *
+ * Copyright (C) 2014 Samsung Electronics Co., Ltd.
+ * Author: Jacek Anaszewski <j.anaszewski@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+#ifndef __LINUX_FLASH_LEDS_H_INCLUDED
+#define __LINUX_FLASH_LEDS_H_INCLUDED
+
+#include <linux/leds.h>
+
+struct v4l2_flash_ops;
+struct led_classdev_flash;
+struct device_node;
+
+/*
+ * Supported led fault bits - must be kept in synch
+ * with V4L2_FLASH_FAULT bits.
+ */
+#define LED_FAULT_OVER_VOLTAGE		 V4L2_FLASH_FAULT_OVER_VOLTAGE
+#define LED_FAULT_TIMEOUT		 V4L2_FLASH_FAULT_TIMEOUT
+#define LED_FAULT_OVER_TEMPERATURE	 V4L2_FLASH_FAULT_OVER_TEMPERATURE
+#define LED_FAULT_SHORT_CIRCUIT		 V4L2_FLASH_FAULT_SHORT_CIRCUIT
+#define LED_FAULT_OVER_CURRENT		 V4L2_FLASH_FAULT_OVER_CURRENT
+#define LED_FAULT_INDICATOR		 V4L2_FLASH_FAULT_INDICATOR
+#define LED_FAULT_UNDER_VOLTAGE		 V4L2_FLASH_FAULT_UNDER_VOLTAGE
+#define LED_FAULT_INPUT_VOLTAGE		 V4L2_FLASH_FAULT_INPUT_VOLTAGE
+#define LED_FAULT_LED_OVER_TEMPERATURE	 V4L2_FLASH_OVER_TEMPERATURE
+
+#define LED_FLASH_MAX_SYSFS_GROUPS 6
+
+struct led_flash_ops {
+	/* set flash brightness */
+	int (*flash_brightness_set)(struct led_classdev_flash *flash,
+					u32 brightness);
+	/* get flash brightness */
+	int (*flash_brightness_get)(struct led_classdev_flash *flash,
+					u32 *brightness);
+	/* set flash indicator brightness */
+	int (*indicator_brightness_set)(struct led_classdev_flash *flash,
+					u32 brightness);
+	/* get flash indicator brightness */
+	int (*indicator_brightness_get)(struct led_classdev_flash *flash,
+					u32 *brightness);
+	/* set flash strobe state */
+	int (*strobe_set)(struct led_classdev_flash *flash, bool state);
+	/* get flash strobe state */
+	int (*strobe_get)(struct led_classdev_flash *flash, bool *state);
+	/* set flash timeout */
+	int (*timeout_set)(struct led_classdev_flash *flash, u32 timeout);
+	/* setup the device to strobe the flash upon a pin state assertion */
+	int (*external_strobe_set)(struct led_classdev_flash *flash,
+					bool enable);
+	/* get the flash LED fault */
+	int (*fault_get)(struct led_classdev_flash *flash, u32 *fault);
+};
+
+/*
+ * Current value of a flash setting along
+ * with its constraints.
+ */
+struct led_flash_setting {
+	/* maximum allowed value */
+	u32 min;
+	/* maximum allowed value */
+	u32 max;
+	/* step value */
+	u32 step;
+	/* current value */
+	u32 val;
+};
+
+/*
+ * Aggregated flash settings - designed for ease
+ * of passing initialization data to the clients
+ * wrapping a LED Flash class device.
+ */
+struct led_flash_config {
+	struct led_flash_setting torch_brightness;
+	struct led_flash_setting flash_brightness;
+	struct led_flash_setting indicator_brightness;
+	struct led_flash_setting flash_timeout;
+	u32 flash_faults;
+};
+
+struct led_classdev_flash {
+	/* led-flash-manager uses it to link flashes */
+	struct list_head list;
+	/* led class device */
+	struct led_classdev led_cdev;
+	/* flash led specific ops */
+	const struct led_flash_ops *ops;
+
+	/* flash sysfs groups */
+	struct attribute_group *sysfs_groups[LED_FLASH_MAX_SYSFS_GROUPS];
+
+	/* flash brightness value in microamperes along with its constraints */
+	struct led_flash_setting brightness;
+
+	/* timeout value in microseconds along with its constraints */
+	struct led_flash_setting timeout;
+
+	/*
+	 * Indicator brightness value in microamperes along with
+	 * its constraints - this is an optional setting and must
+	 * be allocated by the driver if the device supports privacy
+	 * indicator led.
+	 */
+	struct led_flash_setting *indicator_brightness;
+
+	/*
+	 * determines if a device supports external
+	 * flash strobe sources
+	 */
+	bool has_external_strobe;
+
+	/* If true the flash led is strobed from external source */
+	bool external_strobe;
+
+	/* Flash manager data */
+	/* Strobe signals topology data */
+	struct list_head software_strobe_gates;
+	struct list_head strobe_providers;
+
+	/* identifier of the selected strobe signal provider */
+	int strobe_provider_id;
+
+	/* number of defined strobe providers */
+	int num_strobe_providers;
+
+	/*
+	 * number of muxes that this device shares
+	 * with other LED Flash Class devices.
+	 */
+	int num_shared_muxes;
+};
+
+static inline struct led_classdev_flash *lcdev_to_flash(
+						struct led_classdev *lcdev)
+{
+	return container_of(lcdev, struct led_classdev_flash, led_cdev);
+}
+
+/**
+ * led_classdev_flash_register - register a new object of led_classdev_flash class
+				 with support for flash LEDs
+ * @parent: the device to register
+ * @flash: the led_classdev_flash structure for this device
+ * @node: device tree node of the LED Flash Class device - it must be
+	  initialized if the device is to be registered in the flash manager
+ *
+ * Returns: 0 on success or negative error value on failure
+ */
+int led_classdev_flash_register(struct device *parent,
+				struct led_classdev_flash *flash,
+				struct device_node *node);
+
+/**
+ * led_classdev_flash_unregister - unregisters an object of led_classdev_flash class
+				   with support for flash LEDs
+ * @flash: the flash led device to unregister
+ *
+ * Unregisters a previously registered via led_classdev_flash_register object
+ */
+void led_classdev_flash_unregister(struct led_classdev_flash *flash);
+
+/**
+ * led_set_flash_strobe - setup flash strobe
+ * @flash: the flash LED to set strobe on
+ * @state: 1 - strobe flash, 0 - stop flash strobe
+ *
+ * Setup flash strobe - trigger flash strobe
+ *
+ * Returns: 0 on success or negative error value on failure
+ */
+extern int led_set_flash_strobe(struct led_classdev_flash *flash,
+				bool state);
+
+/**
+ * led_get_flash_strobe - get flash strobe status
+ * @flash: the LED to query
+ * @state: 1 - flash is strobing, 0 - flash is off
+ *
+ * Check whether the flash is strobing at the moment or not.
+ *
+u* Returns: 0 on success or negative error value on failure
+ */
+extern int led_get_flash_strobe(struct led_classdev_flash *flash,
+				bool *state);
+/**
+ * led_set_flash_brightness - set flash LED brightness
+ * @flash: the LED to set
+ * @brightness: the brightness to set it to
+ *
+ * Returns: 0 on success or negative error value on failure
+ *
+ * Set a flash LED's brightness.
+ */
+extern int led_set_flash_brightness(struct led_classdev_flash *flash,
+					u32 brightness);
+
+/**
+ * led_update_flash_brightness - update flash LED brightness
+ * @flash: the LED to query
+ *
+ * Get a flash LED's current brightness and update led_flash->brightness
+ * member with the obtained value.
+ *
+ * Returns: 0 on success or negative error value on failure
+ */
+extern int led_update_flash_brightness(struct led_classdev_flash *flash);
+
+/**
+ * led_set_flash_timeout - set flash LED timeout
+ * @flash: the LED to set
+ * @timeout: the flash timeout to set it to
+ *
+ * Set the flash strobe duration. The duration set by the driver
+ * is returned in the timeout argument and may differ from the
+ * one that was originally passed.
+ *
+ * Returns: 0 on success or negative error value on failure
+ */
+extern int led_set_flash_timeout(struct led_classdev_flash *flash,
+					u32 timeout);
+
+/**
+ * led_get_flash_fault - get the flash LED fault
+ * @flash: the LED to query
+ * @fault: bitmask containing flash faults
+ *
+ * Get the flash LED fault.
+ *
+ * Returns: 0 on success or negative error value on failure
+ */
+extern int led_get_flash_fault(struct led_classdev_flash *flash,
+					u32 *fault);
+
+/**
+ * led_set_external_strobe - set the flash LED external_strobe mode
+ * @flash: the LED to set
+ * @enable: the state to set it to
+ *
+ * Enable/disable strobing the flash LED with use of external source
+ *
+  Returns: 0 on success or negative error value on failure
+ */
+extern int led_set_external_strobe(struct led_classdev_flash *flash,
+					bool enable);
+
+/**
+ * led_set_indicator_brightness - set indicator LED brightness
+ * @flash: the LED to set
+ * @brightness: the brightness to set it to
+ *
+ * Set an indicator LED's brightness.
+ *
+ * Returns: 0 on success or negative error value on failure
+ */
+extern int led_set_indicator_brightness(struct led_classdev_flash *flash,
+					u32 led_brightness);
+
+/**
+ * led_update_indicator_brightness - update flash indicator LED brightness
+ * @flash: the LED to query
+ *
+ * Get a flash indicator LED's current brightness and update
+ * led_flash->indicator_brightness member with the obtained value.
+ *
+ * Returns: 0 on success or negative error value on failure
+ */
+extern int led_update_indicator_brightness(struct led_classdev_flash *flash);
+
+#ifdef CONFIG_V4L2_FLASH_LED_CLASS
+/**
+ * led_get_v4l2_flash_ops - get ops for controlling LED Flash Class
+			    device with use of V4L2 Flash controls
+ * Returns: v4l2_flash_ops
+ */
+const struct v4l2_flash_ops *led_get_v4l2_flash_ops(void);
+#else
+#define led_get_v4l2_flash_ops() (0)
+#endif
+
+#endif	/* __LINUX_FLASH_LEDS_H_INCLUDED */
diff --git a/include/linux/led-flash-gpio-mux.h b/include/linux/led-flash-gpio-mux.h
new file mode 100644
index 0000000..c56d38f
--- /dev/null
+++ b/include/linux/led-flash-gpio-mux.h
@@ -0,0 +1,68 @@
+/*
+ * LED Flash Class gpio mux
+ *
+ *	Copyright (C) 2014 Samsung Electronics Co., Ltd
+ *	Author: Jacek Anaszewski <j.anaszewski@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation."
+ */
+
+#ifndef _LED_FLASH_GPIO_MUX_H
+#define _LED_FLASH_GPIO_MUX_H
+
+struct device_node;
+
+struct list_head;
+
+/**
+ * struct led_flash_gpio_mux_selector - element of gpio mux selectors list
+ * @list: links mux selectors
+ * @gpio: mux selector gpio
+ */
+struct led_flash_gpio_mux_selector {
+	struct list_head list;
+	int gpio;
+};
+
+/**
+ * struct led_flash_gpio_mux - gpio mux
+ * @selectors:	mux selectors
+ */
+struct led_flash_gpio_mux {
+	struct list_head selectors;
+};
+
+/**
+ * led_flash_gpio_mux_create - create gpio mux
+ * @new_mux: created mux
+ * @mux_node: device tree node with gpio definitions
+ *
+ * Create V4L2 subdev wrapping given LED subsystem device.
+ *
+ * Returns: 0 on success or negative error value on failure
+ */
+int led_flash_gpio_mux_create(struct led_flash_gpio_mux **new_mux,
+			struct device_node *mux_node);
+
+/**
+ * led_flash_gpio_mux_release - release gpio mux
+ * @gpio_mux: mux to be released
+ *
+ * Create V4L2 subdev wrapping given LED subsystem device.
+ */
+void led_flash_gpio_mux_release(void *gpio_mux);
+
+/**
+ * led_flash_gpio_mux_select_line - select mux line
+ * @line_id: id of the line to be selected
+ * @mux: mux to be set
+ *
+ * Create V4L2 subdev wrapping given LED subsystem device.
+ *
+ * Returns: 0 on success or negative error value on failure
+ */
+int led_flash_gpio_mux_select_line(u32 line_id, void *mux);
+
+#endif /* _LED_FLASH_GPIO_MUX_H */
diff --git a/include/linux/led-flash-manager.h b/include/linux/led-flash-manager.h
new file mode 100644
index 0000000..174eedb
--- /dev/null
+++ b/include/linux/led-flash-manager.h
@@ -0,0 +1,121 @@
+/*
+ *  LED Flash Manager for maintaining LED Flash Class devices
+ *  along with their corresponding muxes that faciliate dynamic
+ *  reconfiguration of the strobe signal source.
+ *
+ *	Copyright (C) 2014 Samsung Electronics Co., Ltd
+ *	Author: Jacek Anaszewski <j.anaszewski@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation."
+ */
+
+#ifndef _LED_FLASH_MANAGER_H
+#define _LED_FLASH_MANAGER_H
+
+#include <linux/types.h>
+
+struct list_head;
+
+struct led_flash_mux_ops {
+	/* select mux line */
+	int (*select_line)(u32 line_id, void *mux);
+	/*
+	 * release private mux data - it is intended for gpio muxes
+	 * only and mustn't be initialized by asynchronous muxes.
+	 */
+	void (*release_private_data)(void *mux);
+};
+
+/**
+ * struct led_flash_mux_ref - flash mux reference
+ * @list:	links flashes pointing to a mux
+ * @flash:	flash holding a mux reference
+ */
+struct led_flash_mux_ref {
+	struct list_head list;
+	struct led_classdev_flash *flash;
+};
+
+/**
+ * struct led_flash_mux - flash mux used for routing strobe signal
+ * @list:		list of muxes declared by registered flashes
+ * @node:		mux Device Tree node
+ * @private_data:	mux internal data
+ * @ops:		ops facilitating mux state manipulation
+ * @refs:		list of flashes using the mux
+ * @num_refs:		number of flashes using the mux
+ * @owner:		module owning an async mux driver
+ */
+struct led_flash_mux {
+	struct list_head list;
+	struct device_node *node;
+	void *private_data;
+	struct led_flash_mux_ops *ops;
+	struct list_head refs;
+	int num_refs;
+	struct module *owner;
+};
+
+/**
+ * led_flash_manager_setup_strobe - setup flash strobe
+ * @flash: the LED Flash Class device to strobe
+ * @external: true - setup external strobe,
+ *	      false - setup software strobe
+ *
+ * Configure muxes to route relevant strobe signals to the
+ * flash led device and strobe the flash if software strobe
+ * is to be activated. If the flash device depends on shared
+ * muxes the caller is blocked for the flash_timeout period.
+ *
+ * Returns: 0 on success or negative error value on failure.
+ */
+int led_flash_manager_setup_strobe(struct led_classdev_flash *flash,
+				   bool external);
+
+/**
+ * led_flash_manager_bind_async_mux - bind asynchronous mulitplexer
+ * @async_mux: mux registration data
+ *
+ * Notify the flash manager that an asychronous mux has been probed.
+ *
+ * Returns: 0 on success or negative error value on failure.
+ */
+int led_flash_manager_bind_async_mux(struct led_flash_mux *async_mux);
+
+/**
+ * led_flash_manager_unbind_async_mux - unbind asynchronous mulitplexer
+ * @mux_node: device node of the mux to be unbound
+ *
+ * Notify the flash manager that an asychronous mux has been removed.
+ *
+ * Returns: 0 on success or negative error value on failure.
+ */
+int led_flash_manager_unbind_async_mux(struct device_node *mux_node);
+
+/**
+ * led_flash_manager_register_flash - register LED Flash Class device
+				      in the flash manager
+ * @flash: the LED Flash Class device to be registered
+ * @node: Device Tree node - it is expected to contain information
+ *	  about strobe signal topology
+ *
+ * Register LED Flash Class device and retrieve information
+ * about related strobe signals topology.
+ *
+ * Returns: 0 on success or negative error value on failure.
+ */
+int led_flash_manager_register_flash(struct led_classdev_flash *flash,
+				     struct device_node *node);
+
+/**
+ * led_flash_manager_unregister_flash - unregister LED Flash Class device
+ *					from the flash manager
+ * @flash: the LED Flash Class device to be unregistered
+ *
+ * Unregister LED Flash Class device from the flash manager.
+ */
+void led_flash_manager_unregister_flash(struct led_classdev_flash *flash);
+
+#endif /* _LED_FLASH_MANAGER_H */
diff --git a/include/linux/leds.h b/include/linux/leds.h
index 9bea9e6..1f12d36 100644
--- a/include/linux/leds.h
+++ b/include/linux/leds.h
@@ -45,6 +45,9 @@ struct led_classdev {
 #define LED_BLINK_INVERT	(1 << 19)
 #define LED_SYSFS_LOCK		(1 << 20)
 #define LED_DEV_CAP_TORCH	(1 << 21)
+#define LED_DEV_CAP_FLASH	(1 << 22)
+#define LED_DEV_CAP_INDICATOR	(1 << 23)
+#define LED_DEV_CAP_FL_MANAGER	(1 << 24)
 
 	/* Set LED brightness level */
 	/* Must not sleep, use a workqueue if needed */
@@ -83,6 +86,7 @@ struct led_classdev {
 	unsigned long		 blink_delay_on, blink_delay_off;
 	struct timer_list	 blink_timer;
 	int			 blink_brightness;
+	void			(*flash_resume)(struct led_classdev *led_cdev);
 
 	struct work_struct	set_brightness_work;
 	int			delayed_set_value;
diff --git a/include/linux/of_led_flash_manager.h b/include/linux/of_led_flash_manager.h
new file mode 100644
index 0000000..d27cb46
--- /dev/null
+++ b/include/linux/of_led_flash_manager.h
@@ -0,0 +1,80 @@
+/*
+ * LED flash manager of helpers.
+ *
+ *	Copyright (C) 2014 Samsung Electronics Co., Ltd
+ *	Author: Jacek Anaszewski <j.anaszewski@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation."
+ */
+
+#ifndef _OF_LED_FLASH_MANAGER_H
+#define _OF_LED_FLASH_MANAGER_H
+
+#include <linux/sysfs.h>
+#include <linux/device.h>
+
+struct led_classdev_flash;
+struct device_node;
+struct list_head;
+
+#define MAX_ATTR_NAME 18 /* allows for strobe providers ids up to 999 */
+
+/**
+ * struct led_flash_strobe_gate - strobe signal gate
+ * @list:	links gates
+ * @mux_node:	gate's parent mux
+ * @line_id:	id of a mux line that the gate represents
+ */
+struct led_flash_strobe_gate {
+	struct list_head list;
+	struct device_node *mux_node;
+	u32 line_id;
+};
+
+/**
+ * struct led_flash_strobe_provider - external strobe signal provider that
+				      may be associated with the flash device
+ * @list:		links strobe providers
+ * @strobe_gates:	list of gates that route strobe signal
+			from the strobe provider to the flash device
+ * @node:		device node of the strobe provider device
+ */
+struct led_flash_strobe_provider {
+	struct list_head list;
+	struct list_head strobe_gates;
+	const char *name;
+	struct device_attribute attr;
+	char attr_name[MAX_ATTR_NAME];
+	bool attr_registered;
+};
+
+/**
+ * of_led_flash_manager_parse_dt - parse flash manager data of
+ *				   a LED Flash Class device DT node
+ *
+ * @flash: the LED Flash Class device to store the parsed data in
+ * @node: device node to parse
+ *
+ * Parse the multiplexers' settings that need to be applied for
+ * opening a route to all the flash strobe signals available for
+ * the device.
+ *
+ * Returns: 0 on success or negative error value on failure
+ */
+int of_led_flash_manager_parse_dt(struct led_classdev_flash *flash,
+					 struct device_node *node);
+
+
+/**
+ * of_led_flash_manager_release_dt_data - release parsed DT data
+ *
+ * @flash: the LED Flash Class device to release data from
+ *
+ * Release data structures containing information about strobe
+ * source routes available for the device.
+ */
+void of_led_flash_manager_release_dt_data(struct led_classdev_flash *flash);
+
+#endif /* _OF_LED_FLASH_MANAGER_H */
-- 
1.7.9.5

