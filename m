Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752330AbaLPX1R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 18:27:17 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:62174 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751122AbaLPX1E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 18:27:04 -0500
X-AuditID: cbfee690-f79ab6d0000046f7-30-5490bfc50b52
From: Chanwoo Choi <cw00.choi@samsung.com>
To: myungjoo.ham@samsung.com
Cc: kgene.kim@samsung.com, kyungmin.park@samsung.com,
        rafael.j.wysocki@intel.com, mark.rutland@arm.com,
        a.kesavan@samsung.com, tomasz.figa@gmail.com, k.kozlowski@samsung.com,
        cw00.choi@samsung.com, inki.dae@samsung.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Subject: [PATCHv4 1/8] devfreq: event: Add new devfreq_event class to provide
 basic data for devfreq governor
Date: Wed, 17 Dec 2014 08:26:50 +0900
Message-id: <1418772417-5164-2-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.5.5
In-reply-to: <1418772417-5164-1-git-send-email-cw00.choi@samsung.com>
References: <1418772417-5164-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupgkeLIzCtJLcpLzFFi42JZI2JSrHt0/4QQg9VrxCwer1nMZHH9y3NW
	i/lHzrFaTLo/gcXi9QtDi94FV9kszja9YbfY9Pgaq8XlXXPYLD73HmG0mHF+H5PF0usXmSxu
	N65gs3i84i27xapdfxgd+D3WzFvD6LFz1l12j8V7XjJ5bF5S79G3ZRWjx+dNcgFsUVw2Kak5
	mWWpRfp2CVwZ3dtfshWcWM9YsfPOIaYGxisTGbsYOTkkBEwk5k7rYYewxSQu3FvPBmILCSxl
	lNj/ORamZuPef0BxLqD4IkaJN5tusEA4TUwS/b1zmUGq2AS0JPa/uAHWLSIgI3F143awImaB
	RmaJL8v+M4EkhAXyJX6v/Aq2jkVAVeLK6V9ARRwcvAIuEvdeF0BsU5BYtnwmK4jNKeAq0XJj
	NRPERS4SnVd3soLMlBC4xy5xbPcsJog5AhLfJh8CmyMhICux6QAzxBxJiYMrbrBMYBRewMiw
	ilE0tSC5oDgpvchErzgxt7g0L10vOT93EyMwgk7/ezZhB+O9A9aHGAU4GJV4eAMK+0OEWBPL
	iitzDzGaAm2YyCwlmpwPjNO8knhDYzMjC1MTU2Mjc0szJXHe11I/g4UE0hNLUrNTUwtSi+KL
	SnNSiw8xMnFwSjUwCh58u6wuNojN1//IKePtZ/bltqwLOfD6mOF8+YTS+zxZnIeL24Klfp/O
	32J7O+UlzxR36xMCoXxceUJPtiWV2MU/KHzf5+Izd4qzSX/5j0ezdtWoMs84GXgjrunbNdnv
	bEZCyYWWGZv/FdjYzzZ1fGbPvsGzQ79mwQX+Kw9OTYtkFfu29c8SJZbijERDLeai4kQA4zP+
	FJsCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrMIsWRmVeSWpSXmKPExsVy+t9jAd2j+yeEGLyfzWHxeM1iJovrX56z
	Wsw/co7VYtL9CSwWr18YWvQuuMpmcbbpDbvFpsfXWC0u75rDZvG59wijxYzz+5gsll6/yGRx
	u3EFm8XjFW/ZLVbt+sPowO+xZt4aRo+ds+6yeyze85LJY/OSeo++LasYPT5vkgtgi2pgtMlI
	TUxJLVJIzUvOT8nMS7dV8g6Od443NTMw1DW0tDBXUshLzE21VXLxCdB1y8wBOllJoSwxpxQo
	FJBYXKykb4dpQmiIm64FTGOErm9IEFyPkQEaSFjDmNG9/SVbwYn1jBU77xxiamC8MpGxi5GT
	Q0LARGLj3n9sELaYxIV764FsLg4hgUWMEm823WCBcJqYJPp75zKDVLEJaEnsf3EDrENEQEbi
	6sbtYEXMAo3MEl+W/WcCSQgL5Ev8XvmVHcRmEVCVuHL6F1ARBwevgIvEvdcFENsUJJYtn8kK
	YnMKuEq03FgN1ioEVNJ5dSfrBEbeBYwMqxhFUwuSC4qT0nON9IoTc4tL89L1kvNzNzGCI/SZ
	9A7GVQ0WhxgFOBiVeHgDC/tDhFgTy4orcw8xSnAwK4nwWiyaECLEm5JYWZValB9fVJqTWnyI
	0RToqInMUqLJ+cDkkVcSb2hsYmZkaWRuaGFkbK4kzqtk3xYiJJCeWJKanZpakFoE08fEwSnV
	wCh/3jimR/L2rBsi4gpzjc3WrMy962qzpVZI+WnCt+02gmcr3pk3GrM0Vl1mO/rjuujnTC/b
	28sEVqp8jVAslHKafJ3tkrHGhgnawu+kYmSkFm7U/22cHnjyQMpJiRTn7Nm1N1aV2Ska/Z28
	xu3u/ftW2td36XZxbJnYr6OcuGXRbO1Z2rbTXyuxFGckGmoxFxUnAgBeg5Q/5gIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add new devfreq_event class for devfreq_event device which provide
raw data (e.g., memory bus utilization/GPU utilization). This raw data from
devfreq_event data would be used for the governor of devfreq subsystem.
- devfreq_event device : Provide raw data for governor of existing devfreq device
- devfreq device       : Monitor device state and change frequency/voltage of device
                         using the raw data from devfreq_event device

The devfreq subsystem support generic DVFS(Dynamic Voltage/Frequency Scaling)
for Non-CPU Devices. The devfreq device would dertermine current device state
using various governor (e.g., ondemand, performance, powersave). After completed
determination of system state, devfreq device would change the frequency/voltage
of devfreq device according to the result of governor.

But, devfreq governor must need basic data which indicates current device state.
Existing devfreq subsystem only consider devfreq device which check current system
state and determine proper system state using basic data. There is no subsystem
for device providing basic data to devfreq device.

The devfreq subsystem must need devfreq_event device(data-provider device) for
existing devfreq device. So, this patch add new devfreq_event class for
devfreq_event device which read various basic data(e.g, memory bus utilization,
GPU utilization) and provide measured data to existing devfreq device through
standard APIs of devfreq_event class.

The following description explains the feature of two kind of devfreq class:
- devfreq class (existing)
 : devfreq consumer device use raw data from devfreq_event device for
   determining proper current system state and change voltage/frequency
   dynamically using various governors.

- devfreq_event class (new)
 : Provide measured raw data to devfreq device for governor

Cc: MyungJoo Ham <myungjoo.ham@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
---
 drivers/devfreq/Kconfig         |   2 +
 drivers/devfreq/Makefile        |   5 +-
 drivers/devfreq/devfreq-event.c | 449 ++++++++++++++++++++++++++++++++++++++++
 drivers/devfreq/event/Makefile  |   1 +
 include/linux/devfreq.h         | 160 ++++++++++++++
 5 files changed, 616 insertions(+), 1 deletion(-)
 create mode 100644 drivers/devfreq/devfreq-event.c
 create mode 100644 drivers/devfreq/event/Makefile

diff --git a/drivers/devfreq/Kconfig b/drivers/devfreq/Kconfig
index faf4e70..4d15b62 100644
--- a/drivers/devfreq/Kconfig
+++ b/drivers/devfreq/Kconfig
@@ -87,4 +87,6 @@ config ARM_EXYNOS5_BUS_DEVFREQ
 	  It reads PPMU counters of memory controllers and adjusts the
 	  operating frequencies and voltages with OPP support.
 
+comment "DEVFREQ Event Drivers"
+
 endif # PM_DEVFREQ
diff --git a/drivers/devfreq/Makefile b/drivers/devfreq/Makefile
index 16138c9..a1ffabe 100644
--- a/drivers/devfreq/Makefile
+++ b/drivers/devfreq/Makefile
@@ -1,4 +1,4 @@
-obj-$(CONFIG_PM_DEVFREQ)	+= devfreq.o
+obj-$(CONFIG_PM_DEVFREQ)		+= devfreq.o devfreq-event.o
 obj-$(CONFIG_DEVFREQ_GOV_SIMPLE_ONDEMAND)	+= governor_simpleondemand.o
 obj-$(CONFIG_DEVFREQ_GOV_PERFORMANCE)	+= governor_performance.o
 obj-$(CONFIG_DEVFREQ_GOV_POWERSAVE)	+= governor_powersave.o
@@ -7,3 +7,6 @@ obj-$(CONFIG_DEVFREQ_GOV_USERSPACE)	+= governor_userspace.o
 # DEVFREQ Drivers
 obj-$(CONFIG_ARM_EXYNOS4_BUS_DEVFREQ)	+= exynos/
 obj-$(CONFIG_ARM_EXYNOS5_BUS_DEVFREQ)	+= exynos/
+
+# DEVFREQ Event Drivers
+obj-$(CONFIG_PM_DEVFREQ)		+= event/
diff --git a/drivers/devfreq/devfreq-event.c b/drivers/devfreq/devfreq-event.c
new file mode 100644
index 0000000..0e1948e
--- /dev/null
+++ b/drivers/devfreq/devfreq-event.c
@@ -0,0 +1,449 @@
+/*
+ * devfreq-event: Generic DEVFREQ Event class driver
+ *
+ * Copyright (C) 2014 Samsung Electronics
+ * Chanwoo Choi <cw00.choi@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This driver is based on drivers/devfreq/devfreq.c.
+ */
+
+#include <linux/kernel.h>
+#include <linux/sched.h>
+#include <linux/errno.h>
+#include <linux/err.h>
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/stat.h>
+#include <linux/pm_opp.h>
+#include <linux/devfreq.h>
+#include <linux/workqueue.h>
+#include <linux/platform_device.h>
+#include <linux/list.h>
+#include <linux/printk.h>
+#include <linux/hrtimer.h>
+#include <linux/of.h>
+#include "governor.h"
+
+static struct class *devfreq_event_class;
+
+/* The list of all devfreq event list */
+static LIST_HEAD(devfreq_event_list);
+static DEFINE_MUTEX(devfreq_event_list_lock);
+
+#define to_devfreq_event(DEV) container_of(DEV, struct devfreq_event_dev, dev)
+
+/**
+ * devfreq_event_enable_edev() - Enable the devfreq-event dev and increase
+ *				 the enable_count of devfreq-event dev.
+ * @edev	: the devfreq-event device
+ *
+ * Note that this function increase the enable_count and enable the
+ * devfreq-event device. The devfreq-event device should be enabled before
+ * using it by devfreq device.
+ */
+int devfreq_event_enable_edev(struct devfreq_event_dev *edev)
+{
+	int ret = 0;
+
+	if (!edev || !edev->desc)
+		return -EINVAL;
+
+	mutex_lock(&edev->lock);
+	if (edev->desc->ops && edev->desc->ops->enable) {
+		ret = edev->desc->ops->enable(edev);
+		if (ret < 0)
+			goto err;
+	}
+	edev->enable_count++;
+err:
+	mutex_unlock(&edev->lock);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(devfreq_event_enable_edev);
+
+/**
+ * devfreq_event_disable_edev() - Disable the devfreq-event dev and decrease
+ *				  the enable_count of the devfreq-event dev.
+ * @edev	: the devfreq-event device
+ *
+ * Note that this function decrease the enable_count and disable the
+ * devfreq-event device. After the devfreq-event device is disabled,
+ * devfreq device can't use the devfreq-event device for get/set/reset
+ * operations.
+ */
+int devfreq_event_disable_edev(struct devfreq_event_dev *edev)
+{
+	int ret = 0;
+
+	if (!edev || !edev->desc)
+		return -EINVAL;
+
+	mutex_lock(&edev->lock);
+	if (edev->enable_count > 0) {
+		edev->enable_count--;
+	} else {
+		dev_warn(&edev->dev, "unbalanced enable_count\n");
+		ret = -EINVAL;
+		goto err;
+	}
+
+	if (edev->desc->ops && edev->desc->ops->disable) {
+		ret = edev->desc->ops->disable(edev);
+		if (ret < 0) {
+			edev->enable_count++;
+			goto err;
+		}
+	}
+err:
+	mutex_unlock(&edev->lock);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(devfreq_event_disable_edev);
+
+/**
+ * devfreq_event_is_enabled() - Check whether devfreq-event dev is enabled or
+ *				not.
+ * @edev	: the devfreq-event device
+ *
+ * Note that this function check whether devfreq-event dev is enabled or not.
+ * If return true, the devfreq-event dev is enabeld. If return false, the
+ * devfreq-event dev is disabled.
+ */
+bool devfreq_event_is_enabled(struct devfreq_event_dev *edev)
+{
+	bool enabled = false;
+
+	if (!edev || !edev->desc)
+		return enabled;
+
+	mutex_lock(&edev->lock);
+
+	if (edev->enable_count > 0)
+		enabled = true;
+
+	if (edev->desc->ops && edev->desc->ops->is_enabled)
+		enabled |= edev->desc->ops->is_enabled(edev);
+
+	mutex_unlock(&edev->lock);
+
+	return enabled;
+}
+EXPORT_SYMBOL_GPL(devfreq_event_is_enabled);
+
+/**
+ * devfreq_event_set_event() - Set event to devfreq-event dev to start.
+ * @edev	: the devfreq-event device
+ *
+ * Note that this function set the event to the devfreq-event device to start
+ * for getting the event data which could be various event type.
+ */
+int devfreq_event_set_event(struct devfreq_event_dev *edev)
+{
+	int ret;
+
+	if (!edev || !edev->desc)
+		return -EINVAL;
+
+	if (!edev->desc->ops || !edev->desc->ops->set_event)
+		return -EINVAL;
+
+	if (!devfreq_event_is_enabled(edev))
+		return -EPERM;
+
+	mutex_lock(&edev->lock);
+	ret = edev->desc->ops->set_event(edev);
+	mutex_unlock(&edev->lock);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(devfreq_event_set_event);
+
+/**
+ * devfreq_event_get_event() - Get event and total_event from devfreq-event dev.
+ * @edev	: the devfreq-event device
+ * @edata	: the calculated data of devfreq-event device
+ *
+ * Note that this function get the calculated event data from devfreq-event dev
+ * after stoping the progress of whole sequence of devfreq-event dev.
+ */
+int devfreq_event_get_event(struct devfreq_event_dev *edev,
+			    struct devfreq_event_data *edata)
+{
+	int ret;
+
+	if (!edev || !edev->desc)
+		return -EINVAL;
+
+	if (!edev->desc->ops || !edev->desc->ops->get_event)
+		return -EINVAL;
+
+	if (!devfreq_event_is_enabled(edev))
+		return -EINVAL;
+
+	edata->event = edata->total_event = 0;
+
+	mutex_lock(&edev->lock);
+	ret = edev->desc->ops->get_event(edev, edata);
+	mutex_unlock(&edev->lock);
+
+	if ((edata->total_event <= 0)
+		|| (edata->event > edata->total_event)) {
+		edata->event = edata->total_event = 0;
+		ret = -EINVAL;
+	}
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(devfreq_event_get_event);
+
+/**
+ * devfreq_event_reset_event() - Reset all opeations of devfreq-event dev.
+ * @edev	: the devfreq-event device
+ *
+ * Note that this function stop all operations of devfreq-event dev and reset
+ * the current event data to make the devfreq-event device into initial state.
+ */
+int devfreq_event_reset_event(struct devfreq_event_dev *edev)
+{
+	int ret = 0;
+
+	if (!edev || !edev->desc)
+		return -EINVAL;
+
+	if (!devfreq_event_is_enabled(edev))
+		return -EPERM;
+
+	mutex_lock(&edev->lock);
+	if (edev->desc->ops && edev->desc->ops->reset)
+		ret = edev->desc->ops->reset(edev);
+	mutex_unlock(&edev->lock);
+
+	if (ret < 0)
+		return -EINVAL;
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(devfreq_event_reset_event);
+
+/**
+ * devfreq_event_get_drvdata() - Return driver-data of devfreq-event dev.
+ * @edev	: the devfreq-event device
+ *
+ * Note that this function return the driver-data of devfreq-event device.
+ */
+void *devfreq_event_get_drvdata(struct devfreq_event_dev *edev)
+{
+	return edev->desc->driver_data;
+}
+EXPORT_SYMBOL_GPL(devfreq_event_get_drvdata);
+
+/**
+ * devfreq_event_get_edev_by_phandle() - Get the devfreq-event dev from
+ *					 devicetree.
+ * @dev		: the pointer to the given device
+ * @index	: the index into list of devfreq-event device
+ *
+ * Note that this function return the pointer of devfreq-event device.
+ */
+struct devfreq_event_dev *devfreq_event_get_edev_by_phandle(struct device *dev,
+						      int index)
+{
+	struct device_node *node;
+	struct devfreq_event_dev *edev;
+
+	if (!dev->of_node) {
+		dev_err(dev, "device does not have a device node entry\n");
+		return ERR_PTR(-EINVAL);
+	}
+
+	node = of_parse_phandle(dev->of_node, "devfreq-events", index);
+	if (!node) {
+		dev_err(dev, "failed to get phandle in %s node\n",
+			dev->of_node->full_name);
+		return ERR_PTR(-ENODEV);
+	}
+
+	mutex_lock(&devfreq_event_list_lock);
+	list_for_each_entry(edev, &devfreq_event_list, node) {
+		if (!strcmp(edev->desc->name, node->name))
+			goto out;
+	}
+	edev = NULL;
+out:
+	mutex_unlock(&devfreq_event_list_lock);
+
+	if (!edev) {
+		dev_err(dev, "unable to get devfreq-event device : %s\n",
+			node->name);
+		of_node_put(node);
+		return ERR_PTR(-ENODEV);
+	}
+
+	of_node_put(node);
+
+	return edev;
+}
+EXPORT_SYMBOL_GPL(devfreq_event_get_edev_by_phandle);
+
+static void devfreq_event_release_edev(struct device *dev)
+{
+	struct devfreq_event_dev *edev = to_devfreq_event(dev);
+	int ret;
+
+	if (!edev) {
+		dev_warn(dev, "failed to release devfreq-event dev\n");
+		return;
+	}
+
+	if (devfreq_event_is_enabled(edev)) {
+		/* Reset the devfreq-event device */
+		ret = devfreq_event_reset_event(edev);
+		if (ret < 0)
+			dev_warn(dev, "failed to reset devfreq-event dev\n");
+
+		/* Disable the devfreq-event device */
+		ret = devfreq_event_disable_edev(edev);
+		if (ret < 0)
+			dev_warn(dev, "failed to disable devfreq-event dev\n");
+	}
+
+	mutex_lock(&devfreq_event_list_lock);
+	list_del(&edev->node);
+	mutex_unlock(&devfreq_event_list_lock);
+}
+
+/**
+ * devfreq_event_add_edev() - Add new devfreq-event device.
+ * @dev		: the device owning the devfreq-event device being created
+ * @desc	: the devfreq-event device's decriptor which include essential
+ *		  data for devfreq-event device.
+ *
+ * Note that this function add new devfreq-event device to devfreq-event class
+ * list and register the device of the devfreq-event device.
+ */
+struct devfreq_event_dev *devfreq_event_add_edev(struct device *dev,
+						struct devfreq_event_desc *desc)
+{
+	struct devfreq_event_dev *edev;
+	static atomic_t event_no = ATOMIC_INIT(0);
+	int ret;
+
+	if (!dev || !desc)
+		return ERR_PTR(-EINVAL);
+
+	if (!desc->name || !desc->ops)
+		return ERR_PTR(-EINVAL);
+
+	if (!desc->ops->set_event || !desc->ops->get_event)
+		return ERR_PTR(-EINVAL);
+
+	edev = devm_kzalloc(dev, sizeof(*edev), GFP_KERNEL);
+	if (!edev)
+		return ERR_PTR(-ENOMEM);
+
+	mutex_lock(&devfreq_event_list_lock);
+	mutex_init(&edev->lock);
+	edev->desc = desc;
+	edev->dev.parent = dev;
+	edev->dev.class = devfreq_event_class;
+	edev->dev.release = devfreq_event_release_edev;
+
+	dev_set_name(&edev->dev, "event.%d", atomic_inc_return(&event_no) - 1);
+	ret = device_register(&edev->dev);
+	if (ret < 0) {
+		put_device(&edev->dev);
+		mutex_unlock(&devfreq_event_list_lock);
+		return ERR_PTR(ret);
+	}
+	dev_set_drvdata(&edev->dev, edev);
+
+	INIT_LIST_HEAD(&edev->node);
+	list_add(&edev->node, &devfreq_event_list);
+	mutex_unlock(&devfreq_event_list_lock);
+
+	return edev;
+}
+EXPORT_SYMBOL(devfreq_event_add_edev);
+
+/**
+ * devfreq_event_remove_edev() - Remove the devfreq-event device registered.
+ * @dev		: the devfreq-event device
+ *
+ * Note that this function remove the registered devfreq-event device.
+ */
+int devfreq_event_remove_edev(struct devfreq_event_dev *edev)
+{
+	if (!edev)
+		return -EINVAL;
+
+	device_unregister(&edev->dev);
+	put_device(&edev->dev);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(devfreq_event_remove_edev);
+
+/*
+ * Device attributes for devfreq-event class.
+ */
+static ssize_t name_show(struct device *dev, struct device_attribute *attr,
+			 char *buf)
+{
+	struct devfreq_event_dev *edev = to_devfreq_event(dev);
+
+	if (!edev || !edev->desc)
+		return -EINVAL;
+
+	return sprintf(buf, "%s\n", edev->desc->name);
+}
+static DEVICE_ATTR_RO(name);
+
+static ssize_t enable_count_show(struct device *dev,
+				  struct device_attribute *attr, char *buf)
+{
+	struct devfreq_event_dev *edev = to_devfreq_event(dev);
+
+	if (!edev || !edev->desc)
+		return -EINVAL;
+
+	return sprintf(buf, "%d\n", edev->enable_count);
+}
+static DEVICE_ATTR_RO(enable_count);
+
+static struct attribute *devfreq_event_attrs[] = {
+	&dev_attr_name.attr,
+	&dev_attr_enable_count.attr,
+	NULL,
+};
+ATTRIBUTE_GROUPS(devfreq_event);
+
+static int __init devfreq_event_init(void)
+{
+	devfreq_event_class = class_create(THIS_MODULE, "devfreq-event");
+	if (IS_ERR(devfreq_event_class)) {
+		pr_err("%s: couldn't create class\n", __FILE__);
+		return PTR_ERR(devfreq_event_class);
+	}
+
+	devfreq_event_class->dev_groups = devfreq_event_groups;
+
+	return 0;
+}
+subsys_initcall(devfreq_event_init);
+
+static void __exit devfreq_event_exit(void)
+{
+	class_destroy(devfreq_event_class);
+}
+module_exit(devfreq_event_exit);
+
+MODULE_AUTHOR("Chanwoo Choi <cw00.choi@samsung.com>");
+MODULE_DESCRIPTION("DEVFREQ-Event class support");
+MODULE_LICENSE("GPL");
diff --git a/drivers/devfreq/event/Makefile b/drivers/devfreq/event/Makefile
new file mode 100644
index 0000000..dc56005
--- /dev/null
+++ b/drivers/devfreq/event/Makefile
@@ -0,0 +1 @@
+# Exynos DEVFREQ Event Drivers
diff --git a/include/linux/devfreq.h b/include/linux/devfreq.h
index f1863dc..ed85a8c 100644
--- a/include/linux/devfreq.h
+++ b/include/linux/devfreq.h
@@ -175,6 +175,85 @@ struct devfreq {
 	unsigned long last_stat_updated;
 };
 
+/**
+ * struct devfreq_event_dev - the devfreq-event device
+ *
+ * @node	: Contain the devfreq-event device that have been registered.
+ * @dev		: the device registered by devfreq-event class. dev.parent is
+ *		  the device using devfreq-event.
+ * @lock	: a mutex to protect accessing devfreq-event.
+ * @enable_count: the number of enable function have been called.
+ * @desc	: the description for devfreq-event device.
+ *
+ * This structure contains devfreq-event device information.
+ */
+struct devfreq_event_dev {
+	struct list_head node;
+
+	struct device dev;
+	struct mutex lock;
+	u32 enable_count;
+
+	const struct devfreq_event_desc *desc;
+};
+
+/**
+ * struct devfreq_event_data - the devfreq-event data
+ *
+ * @event	: the load of devfreq-event device for polling period
+ * @total_event	: the total load of devfreq-event device for polling period
+ *
+ * This structure contains the data of devfreq-event device for polling period.
+ */
+struct devfreq_event_data {
+	unsigned long event;
+	unsigned long total_event;
+};
+
+/**
+ * struct devfreq_event_ops - the operations of devfreq-event device
+ *
+ * @enable	: Enable the devfreq-event device.
+ * @disable	: Disable the devfreq-event device.
+ * @is_enabled	: Return true if the devfreq-event is enabled, false if not.
+ * @reset	: Reset all setting of the devfreq-event device.
+ * @set_event	: Set the specific event type for the devfreq-event device.
+ * @get_event	: Get the result of the devfreq-event devie with specific
+ *		  event type.
+ *
+ * This structure contains devfreq-event device operations which can be
+ * implemented by devfreq-event device drivers.
+ */
+struct devfreq_event_ops {
+	/* Optional functions */
+	int (*enable)(struct devfreq_event_dev *edev);
+	int (*disable)(struct devfreq_event_dev *edev);
+	bool (*is_enabled)(struct devfreq_event_dev *edev);
+	int (*reset)(struct devfreq_event_dev *edev);
+
+	/* Mandatory functions */
+	int (*set_event)(struct devfreq_event_dev *edev);
+	int (*get_event)(struct devfreq_event_dev *edev,
+			 struct devfreq_event_data *edata);
+};
+
+/**
+ * struct devfreq_event_desc - the descriptor of devfreq-event device
+ *
+ * @name	: the name of devfreq-event device.
+ * @driver_data	: the private data for devfreq-event driver.
+ * @ops		: the operation to control devfreq-event device.
+ *
+ * Each devfreq-event device is described with a this structure.
+ * This structure contains the various data for devfreq-event device.
+ */
+struct devfreq_event_desc {
+	const char *name;
+	void *driver_data;
+
+	struct devfreq_event_ops *ops;
+};
+
 #if defined(CONFIG_PM_DEVFREQ)
 extern struct devfreq *devfreq_add_device(struct device *dev,
 				  struct devfreq_dev_profile *profile,
@@ -204,6 +283,21 @@ extern int devm_devfreq_register_opp_notifier(struct device *dev,
 extern void devm_devfreq_unregister_opp_notifier(struct device *dev,
 						struct devfreq *devfreq);
 
+/* Functions for devfreq event device */
+extern int devfreq_event_enable_edev(struct devfreq_event_dev *edev);
+extern int devfreq_event_disable_edev(struct devfreq_event_dev *edev);
+extern bool devfreq_event_is_enabled(struct devfreq_event_dev *edev);
+extern int devfreq_event_set_event(struct devfreq_event_dev *edev);
+extern int devfreq_event_get_event(struct devfreq_event_dev *edev,
+				struct devfreq_event_data *edata);
+extern int devfreq_event_reset_event(struct devfreq_event_dev *edev);
+extern void *devfreq_event_get_drvdata(struct devfreq_event_dev *edev);
+extern struct devfreq_event_dev *devfreq_event_get_edev_by_phandle(
+				struct device *dev, int index);
+extern struct devfreq_event_dev *devfreq_event_add_edev(struct device *dev,
+				struct devfreq_event_desc *desc);
+extern int devfreq_event_remove_edev(struct devfreq_event_dev *edev);
+
 #if IS_ENABLED(CONFIG_DEVFREQ_GOV_SIMPLE_ONDEMAND)
 /**
  * struct devfreq_simple_ondemand_data - void *data fed to struct devfreq
@@ -233,6 +327,13 @@ static inline struct devfreq *devfreq_add_device(struct device *dev,
 	return ERR_PTR(-ENOSYS);
 }
 
+static inline struct devfreq_event_dev *devfreq_add_event_device(
+					struct device *dev,
+					struct devfreq_event_desc *desc);
+{
+	return ERR_PTR(-ENODEV);
+}
+
 static inline int devfreq_remove_device(struct devfreq *devfreq)
 {
 	return 0;
@@ -289,6 +390,65 @@ static inline void devm_devfreq_unregister_opp_notifier(struct device *dev,
 							struct devfreq *devfreq)
 {
 }
+
+static inline void *event_dev_get_drvdata(struct devfreq_event_dev *edev)
+{
+	return ERR_PTR(-EINVAL);
+}
+
+static inline int devfreq_event_enable_edev(struct devfreq_event_dev *edev)
+{
+	return -EINVAL;
+}
+
+static inline int devfreq_event_disable_edev(struct devfreq_event_dev *edev);
+{
+	return -EINVAL;
+}
+
+static inline bool devfreq_event_is_enabled(struct devfreq_event_dev *edev);
+{
+	return false;
+}
+
+static inline int devfreq_event_set_event(struct devfreq_event_dev *edev);
+{
+	return -EINVAL;
+}
+
+static inline int devfreq_event_get_event(struct devfreq_event_dev *edev,
+					struct devfreq_event_data *edata)
+{
+	return -EINVAL;
+}
+
+static inline int devfreq_event_reset_event(struct devfreq_event_dev *edev);
+{
+	return -EINVAL;
+}
+
+static inline void *devfreq_event_get_drvdata(struct devfreq_event_dev *edev);
+{
+	return ERR_PTR(-EINVAL);
+}
+
+static inline struct devfreq_event_dev *devfreq_event_get_edev_by_phandle(
+					struct device *dev, int index);
+{
+	return ERR_PTR(-EINVAL);
+}
+
+static inline struct devfreq_event_dev *devfreq_event_add_edev(struct device *dev,
+					struct devfreq_event_desc *desc);
+{
+	return ERR_PTR(-EINVAL);
+}
+
+static inline int devfreq_event_remove_edev(struct devfreq_event_dev *edev);
+{
+	return -EINVAL;
+}
+
 #endif /* CONFIG_PM_DEVFREQ */
 
 #endif /* __LINUX_DEVFREQ_H__ */
-- 
1.8.5.5

