Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751941AbaL2AE6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2014 19:04:58 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:40700 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751476AbaL2AE0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2014 19:04:26 -0500
X-AuditID: cbfee68d-f79296d000004278-36-54a09a86d1ad
From: Chanwoo Choi <cw00.choi@samsung.com>
To: myungjoo.ham@samsung.com
Cc: kgene.kim@samsung.com, kyungmin.park@samsung.com,
        rafael.j.wysocki@intel.com, mark.rutland@arm.com,
        a.kesavan@samsung.com, tomasz.figa@gmail.com, k.kozlowski@samsung.com,
        cw00.choi@samsung.com, inki.dae@samsung.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Subject: [PATCHv6 1/9] devfreq: event: Add new devfreq_event class to provide
 basic data for devfreq governor
Date: Mon, 29 Dec 2014 09:04:05 +0900
Message-id: <1419811453-16160-2-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.5.5
In-reply-to: <1419811453-16160-1-git-send-email-cw00.choi@samsung.com>
References: <1419811453-16160-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupgkeLIzCtJLcpLzFFi42JZI2JSrNs+a0GIwZv9zBaP1yxmsrj+5Tmr
	xfwj51gtJt2fwGLx+oWhRe+Cq2wWZ5vesFtsenyN1eLyrjlsFp97jzBazDi/j8li6fWLTBa3
	G1ewWTxe8ZbdYtWuP4wO/B5r5q1h9Ng56y67x+I9L5k8Ni+p9+jbsorR4/MmuQC2KC6blNSc
	zLLUIn27BK6Mn+9TCl5sZay4eegRawPjmWmMXYwcHBICJhL3fxV1MXICmWISF+6tZ+ti5OIQ
	EljKKPHh9RYWiISJxNQdZ9khEtMZJdrPTGGBcJqYJBrPv2cEqWIT0JLY/+IGG4gtIiAjcXXj
	drAiZoFGZokvy/4zgSSEBfIlrv88wAxiswioShxefYMVxOYVcJV43t/NDrFOQWLZ8plgcU4B
	N4k9J26A1QsB1Zz/f5AVZKiEwC12iUsPWlghBglIfJt8iAXiH1mJTRDzJQQkJQ6uuMEygVF4
	ASPDKkbR1ILkguKk9CJDveLE3OLSvHS95PzcTYzACDr971nvDsbbB6wPMQpwMCrx8E44Nj9E
	iDWxrLgy9xCjKdCGicxSosn5wDjNK4k3NDYzsjA1MTU2Mrc0UxLnVZT6GSwkkJ5YkpqdmlqQ
	WhRfVJqTWnyIkYmDU6qBMU/oi9gxjhf1DEYpDkzr9KdcnujNcTRoSoipYo7/Qw+PL5/ilQ/k
	zur5PlMrom5T/hOfcK83c1d0O+rYsq3afHmX4vLJmxvYZ30xPvRzr5uy62y12m1Ld+u9/qGn
	vYpr682Wk1viw6f9XPJ0f3NK8BS/mI2LY6X3K98tM7jW5+KrsCmgZo/UZCWW4oxEQy3mouJE
	AOi2pwibAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrMIsWRmVeSWpSXmKPExsVy+t9jQd22WQtCDO5cNbJ4vGYxk8X1L89Z
	LeYfOcdqMen+BBaL1y8MLXoXXGWzONv0ht1i0+NrrBaXd81hs/jce4TRYsb5fUwWS69fZLK4
	3biCzeLxirfsFqt2/WF04PdYM28No8fOWXfZPRbvecnksXlJvUffllWMHp83yQWwRTUw2mSk
	JqakFimk5iXnp2TmpdsqeQfHO8ebmhkY6hpaWpgrKeQl5qbaKrn4BOi6ZeYAnaykUJaYUwoU
	CkgsLlbSt8M0ITTETdcCpjFC1zckCK7HyAANJKxhzPj5PqXgxVbGipuHHrE2MJ6ZxtjFyMkh
	IWAiMXXHWXYIW0ziwr31bF2MXBxCAtMZJdrPTGGBcJqYJBrPvwfrYBPQktj/4gYbiC0iICNx
	deN2sCJmgUZmiS/L/jOBJIQF8iWu/zzADGKzCKhKHF59gxXE5hVwlXje3w21TkFi2fKZYHFO
	ATeJPSdugNULAdWc/3+QdQIj7wJGhlWMoqkFyQXFSem5RnrFibnFpXnpesn5uZsYwRH6THoH
	46oGi0OMAhyMSjy8E47NDxFiTSwrrsw9xCjBwawkwmtUtiBEiDclsbIqtSg/vqg0J7X4EKMp
	0FUTmaVEk/OBySOvJN7Q2MTMyNLI3NDCyNhcSZxXyb4tREggPbEkNTs1tSC1CKaPiYNTqoFR
	aQ7zgkk5BZGKJw/vdT/Nm2okfy7XeKqY//ayMtfzeZm/xbU/39F6/dz/w66sq5VXOVZpnA7i
	SZRq/7e0+dzeWLkr3edjbQTffPVj3rNcuPfb5dW384N9norVm76dOmlG10/viH0BqVO/Ttk6
	PVTFvkPf7LjE2xCJW86CgqvzZD/7nNmc4lCnxFKckWioxVxUnAgAVJBSceYCAAA=
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
 drivers/devfreq/Makefile        |   6 +-
 drivers/devfreq/devfreq-event.c | 466 ++++++++++++++++++++++++++++++++++++++++
 drivers/devfreq/event/Kconfig   |  16 ++
 drivers/devfreq/event/Makefile  |   1 +
 include/linux/devfreq-event.h   | 170 +++++++++++++++
 6 files changed, 660 insertions(+), 1 deletion(-)
 create mode 100644 drivers/devfreq/devfreq-event.c
 create mode 100644 drivers/devfreq/event/Kconfig
 create mode 100644 drivers/devfreq/event/Makefile
 create mode 100644 include/linux/devfreq-event.h

diff --git a/drivers/devfreq/Kconfig b/drivers/devfreq/Kconfig
index faf4e70..21f8f17 100644
--- a/drivers/devfreq/Kconfig
+++ b/drivers/devfreq/Kconfig
@@ -87,4 +87,6 @@ config ARM_EXYNOS5_BUS_DEVFREQ
 	  It reads PPMU counters of memory controllers and adjusts the
 	  operating frequencies and voltages with OPP support.
 
+source "drivers/devfreq/event/Kconfig"
+
 endif # PM_DEVFREQ
diff --git a/drivers/devfreq/Makefile b/drivers/devfreq/Makefile
index 16138c9..c449336 100644
--- a/drivers/devfreq/Makefile
+++ b/drivers/devfreq/Makefile
@@ -1,4 +1,5 @@
-obj-$(CONFIG_PM_DEVFREQ)	+= devfreq.o
+obj-$(CONFIG_PM_DEVFREQ)		+= devfreq.o
+obj-$(CONFIG_PM_DEVFREQ_EVENT)		+= devfreq-event.o
 obj-$(CONFIG_DEVFREQ_GOV_SIMPLE_ONDEMAND)	+= governor_simpleondemand.o
 obj-$(CONFIG_DEVFREQ_GOV_PERFORMANCE)	+= governor_performance.o
 obj-$(CONFIG_DEVFREQ_GOV_POWERSAVE)	+= governor_powersave.o
@@ -7,3 +8,6 @@ obj-$(CONFIG_DEVFREQ_GOV_USERSPACE)	+= governor_userspace.o
 # DEVFREQ Drivers
 obj-$(CONFIG_ARM_EXYNOS4_BUS_DEVFREQ)	+= exynos/
 obj-$(CONFIG_ARM_EXYNOS5_BUS_DEVFREQ)	+= exynos/
+
+# DEVFREQ Event Drivers
+obj-$(CONFIG_PM_DEVFREQ_EVENT)		+= event/
diff --git a/drivers/devfreq/devfreq-event.c b/drivers/devfreq/devfreq-event.c
new file mode 100644
index 0000000..81448ba
--- /dev/null
+++ b/drivers/devfreq/devfreq-event.c
@@ -0,0 +1,466 @@
+/*
+ * devfreq-event: a framework to provide raw data and events of devfreq devices
+ *
+ * Copyright (C) 2014 Samsung Electronics
+ * Author: Chanwoo Choi <cw00.choi@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This driver is based on drivers/devfreq/devfreq.c.
+ */
+
+#include <linux/devfreq-event.h>
+#include <linux/kernel.h>
+#include <linux/err.h>
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/list.h>
+#include <linux/of.h>
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
+/**
+ * devfreq_event_get_edev_count() - Get the count of devfreq-event dev
+ * @dev		: the pointer to the given device
+ *
+ * Note that this function return the count of devfreq-event devices.
+ */
+int devfreq_event_get_edev_count(struct device *dev)
+{
+	int count;
+
+	if (!dev->of_node) {
+		dev_err(dev, "device does not have a device node entry\n");
+		return -EINVAL;
+	}
+
+	count = of_property_count_elems_of_size(dev->of_node, "devfreq-events",
+						sizeof(u32));
+	if (count < 0 ) {
+		dev_err(dev,
+			"failed to get the count of devfreq-event in %s node\n",
+			dev->of_node->full_name);
+		return count;
+	}
+
+	return count;
+}
+EXPORT_SYMBOL_GPL(devfreq_event_get_edev_count);
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
+
+	mutex_lock(&devfreq_event_list_lock);
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
diff --git a/drivers/devfreq/event/Kconfig b/drivers/devfreq/event/Kconfig
new file mode 100644
index 0000000..1ced42c
--- /dev/null
+++ b/drivers/devfreq/event/Kconfig
@@ -0,0 +1,16 @@
+menuconfig PM_DEVFREQ_EVENT
+	bool "DEVFREQ-Event device Support"
+	help
+	  The devfreq-event device provide the raw data and events which
+	  indicate the current state of devfreq-event device. The provided
+	  data from devfreq-event device is used to monitor the state of
+	  device and determine the suitable size of resource to reduce the
+	  wasted resource.
+
+	  The devfreq-event device can support the various type of events
+	  (e.g., raw data, utilization, latency, bandwidth). The events
+	  may be used by devfreq governor and other subsystem.
+
+if PM_DEVFREQ_EVENT
+
+endif # PM_DEVFREQ_EVENT
diff --git a/drivers/devfreq/event/Makefile b/drivers/devfreq/event/Makefile
new file mode 100644
index 0000000..dc56005
--- /dev/null
+++ b/drivers/devfreq/event/Makefile
@@ -0,0 +1 @@
+# Exynos DEVFREQ Event Drivers
diff --git a/include/linux/devfreq-event.h b/include/linux/devfreq-event.h
new file mode 100644
index 0000000..6023be8
--- /dev/null
+++ b/include/linux/devfreq-event.h
@@ -0,0 +1,170 @@
+/*
+ * devfreq-event: a framework to provide raw data and events of devfreq devices
+ *
+ * Copyright (C) 2014 Samsung Electronics
+ * Author: Chanwoo Choi <cw00.choi@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef __LINUX_DEVFREQ_EVENT_H__
+#define __LINUX_DEVFREQ_EVENT_H__
+
+#include <linux/device.h>
+
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
+#if defined(CONFIG_PM_DEVFREQ_EVENT)
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
+extern int devfreq_event_get_edev_count(struct device *dev);
+extern struct devfreq_event_dev *devfreq_event_add_edev(struct device *dev,
+				struct devfreq_event_desc *desc);
+extern int devfreq_event_remove_edev(struct devfreq_event_dev *edev);
+
+#else
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
+static inline int devfreq_event_get_edev_count(struct device *dev)
+{
+	return -EINVAL;
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
+#endif /* CONFIG_PM_DEVFREQ_EVENT */
+
+#endif /* __LINUX_DEVFREQ_EVENT_H__ */
-- 
1.8.5.5

