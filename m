Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757122AbaLIOQn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 09:16:43 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:26705 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753041AbaLIONM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 09:13:12 -0500
X-AuditID: cbfee691-f79b86d000004a5a-36-54870373699b
From: Chanwoo Choi <cw00.choi@samsung.com>
To: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: myungjoo.ham@samsung.com, kyungmin.park@samsung.com, kgene.kim@samsung.com,
        rafael.j.wysocki@intel.com, a.kesavan@samsung.com,
        tomasz.figa@gmail.com, b.zolnierkie@samsung.com,
        k.kozlowski@samsung.com, cw00.choi@samsung.com,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Subject: [RFC PATCHv2 1/7] devfreq: event: Add new devfreq_event class to
 provide basic data for devfreq governor
Date: Tue, 09 Dec 2014 23:13:00 +0900
Message-id: <1418134386-14681-2-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.5.5
In-reply-to: <1418134386-14681-1-git-send-email-cw00.choi@samsung.com>
References: <1418134386-14681-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrDLMWRmVeSWpSXmKPExsWyRsSkWLeEuT3E4OVbdovHaxYzWWycsZ7V
	4vqX56wW84+cY7V4/cLQonfBVTaLs01v2C02Pb7GanF51xw2i8+9RxgtZpzfx2Rxu3EFm8Xj
	FUD9q3b9YXTg89g56y67x+I9L5k8Ni+p9+jbsorR4/MmuQDWKC6blNSczLLUIn27BK6Mc/cr
	CxZ1MVa83enUwDi7pIuRk0NCwERi+dStbBC2mMSFe+uBbC4OIYGljBKTZixkhil68foIM0Ri
	EaPEs78zoaqamCTWz29lB6liE9CS2P/iBtgoEQEridP/O8A6mAXOM0ksWbgfbJSwQLHEm8uf
	wGwWAVWJa0vnMYLYvAKuEod/b4O6Q0Fi2fKZrCA2p4CbRNPuRhYQWwio5sMJiGUSAsfYJTr3
	JEPMEZD4NvkQUA0HUFxWYtMBqKslJQ6uuMEygVF4ASPDKkbR1ILkguKk9CJTveLE3OLSvHS9
	5PzcTYzASDn979nEHYz3D1gfYhTgYFTi4dWwbAsRYk0sK67MPcRoCrRhIrOUaHI+MB7zSuIN
	jc2MLExNTI2NzC3NlMR5daR/BgsJpCeWpGanphakFsUXleakFh9iZOLglGpgtFnwrm3mKyuf
	sru9WtdVDrltLTPdtXBj3KeTrKn747cvZV/Ru7c0+fWE4G0vvc6sC/vuvPbSos8KtV83+n9Y
	JZfhtE5Av1qLi/lAzVbnpjzNrasqxCuedyg4+NvetXJ+kJMl+yY2J0j8fNONJAc5NjmJz11N
	5ZWNbN5nps3ln8W8au7jIy++KLEUZyQaajEXFScCAJcCEz2PAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrOIsWRmVeSWpSXmKPExsVy+t9jAd1i5vYQg7nzLSwer1nMZLFxxnpW
	i+tfnrNazD9yjtXi9QtDi94FV9kszja9YbfY9Pgaq8XlXXPYLD73HmG0mHF+H5PF7cYVbBaP
	V7xlt1i16w+jA5/Hzll32T0W73nJ5LF5Sb1H35ZVjB6fN8kFsEY1MNpkpCampBYppOYl56dk
	5qXbKnkHxzvHm5oZGOoaWlqYKynkJeam2iq5+AToumXmAB2qpFCWmFMKFApILC5W0rfDNCE0
	xE3XAqYxQtc3JAiux8gADSSsYcw4d7+yYFEXY8XbnU4NjLNLuhg5OSQETCRevD7CDGGLSVy4
	t56ti5GLQ0hgEaPEs78zoZwmJon181vZQarYBLQk9r+4wQZiiwhYSZz+38EMUsQscJ5JYsnC
	/WCjhAWKJd5c/gRmswioSlxbOo8RxOYVcJU4/HsbG8Q6BYlly2eygticAm4STbsbWUBsIaCa
	Dyda2Scw8i5gZFjFKJpakFxQnJSea6hXnJhbXJqXrpecn7uJERyJz6R2MK5ssDjEKMDBqMTD
	q2nZFiLEmlhWXJl7iFGCg1lJhHfKUaAQb0piZVVqUX58UWlOavEhRlOgqyYyS4km5wOTRF5J
	vKGxiZmRpZG5oYWRsbmSOK+SPVCTQHpiSWp2ampBahFMHxMHp1QD4/wwnYyLN54cev6s5+HD
	c0/k2TifeQQ/OyYh1yEc0CytHpmRvNmFYYnxxfJ+YY+fvIztTxoKmep3zfxzdmOZzGLl+0WX
	Qh8bdL4UF9RicnN56HljsTP7Y6n3bxyuv498skn4oL3QzsLpzBnvzyV3nC579+ht8Ey7i1M2
	JXNF3q6bmMqzcJF5jxJLcUaioRZzUXEiAMt40AXaAgAA
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
 drivers/devfreq/devfreq-event.c | 302 ++++++++++++++++++++++++++++++++++++++++
 drivers/devfreq/event/Makefile  |   1 +
 include/linux/devfreq.h         | 141 +++++++++++++++++++
 5 files changed, 450 insertions(+), 1 deletion(-)
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
index 0000000..b47329f
--- /dev/null
+++ b/drivers/devfreq/devfreq-event.c
@@ -0,0 +1,302 @@
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
+ * This driver is based on drivers/devfreq/devfreq.c
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
+struct devfreq_event_dev *devfreq_add_event_device(struct device *dev,
+					struct devfreq_event_desc *desc)
+{
+	struct devfreq_event_dev *event_dev;
+	static atomic_t event_no = ATOMIC_INIT(0);
+	int ret;
+
+	if (!dev || !desc)
+		return ERR_PTR(-EINVAL);
+
+	if (!desc->name || !desc->ops)
+		return ERR_PTR(-EINVAL);
+
+	event_dev = kzalloc(sizeof(struct devfreq_event_dev), GFP_KERNEL);
+	if (!event_dev)
+		return ERR_PTR(-ENOMEM);
+
+	mutex_lock(&devfreq_event_list_lock);
+
+	mutex_init(&event_dev->lock);
+	event_dev->desc = desc;
+	event_dev->dev.parent = dev;
+	event_dev->dev.class = devfreq_event_class;
+
+	dev_set_name(&event_dev->dev, "event.%d",
+		     atomic_inc_return(&event_no) - 1);
+	ret = device_register(&event_dev->dev);
+	if (ret != 0) {
+		put_device(&event_dev->dev);
+		goto err;
+	}
+	dev_set_drvdata(&event_dev->dev, event_dev);
+
+	/* Add devfreq event device to devfreq_event_list */
+	INIT_LIST_HEAD(&event_dev->node);
+	list_add(&event_dev->node, &devfreq_event_list);
+
+	mutex_unlock(&devfreq_event_list_lock);
+
+	return event_dev;
+err:
+	kfree(event_dev);
+	return ERR_PTR(ret);
+}
+EXPORT_SYMBOL(devfreq_add_event_device);
+
+struct devfreq_event_dev *devfreq_get_event_dev(const char *event_dev_name)
+{
+	struct devfreq_event_dev *event_dev;
+
+	mutex_lock(&devfreq_event_list_lock);
+	list_for_each_entry(event_dev, &devfreq_event_list, node) {
+		if (!strcmp(event_dev->desc->name, event_dev_name))
+			goto out;
+	}
+	event_dev = NULL;
+out:
+	mutex_unlock(&devfreq_event_list_lock);
+
+	return event_dev;
+}
+EXPORT_SYMBOL_GPL(devfreq_get_event_dev);
+
+struct devfreq_event_dev *devfreq_get_event_dev_by_phandle(struct device *dev,
+						      int index)
+{
+	struct device_node *node;
+	struct devfreq_event_dev *event_dev;
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
+	event_dev = devfreq_get_event_dev(node->name);
+	if (!event_dev) {
+		dev_err(dev, "unable to get devfreq-event device : %s\n",
+			node->name);
+		return ERR_PTR(-ENODEV);
+	}
+
+	return event_dev;
+}
+EXPORT_SYMBOL_GPL(devfreq_get_event_dev_by_phandle);
+
+int devfreq_put_event_dev(struct devfreq_event_dev *event_dev)
+{
+	return 0;
+}
+EXPORT_SYMBOL_GPL(devfreq_put_event_dev);
+
+int devfreq_enable_event_dev(struct devfreq_event_dev *event_dev)
+{
+	int ret = 0;
+
+	if (!event_dev || !event_dev->desc)
+		return -EINVAL;
+
+	mutex_lock(&event_dev->lock);
+	if (event_dev->desc->ops && event_dev->desc->ops->enable) {
+		ret = event_dev->desc->ops->enable(event_dev);
+		if (ret < 0)
+			goto err;
+	}
+	event_dev->enable_count++;
+err:
+	mutex_unlock(&event_dev->lock);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(devfreq_enable_event_dev);
+
+int devfreq_disable_event_dev(struct devfreq_event_dev *event_dev)
+{
+	int ret = 0;
+
+	if (!event_dev || !event_dev->desc)
+		return -EINVAL;
+
+	mutex_lock(&event_dev->lock);
+	if (event_dev->enable_count > 0) {
+		event_dev->enable_count--;
+	} else {
+		dev_warn(&event_dev->dev, "unbalanced enable_count\n");
+		ret = -EINVAL;
+		goto err;
+	}
+
+	if (event_dev->desc->ops && event_dev->desc->ops->disable) {
+		ret = event_dev->desc->ops->disable(event_dev);
+		if (ret < 0) {
+			event_dev->enable_count++;
+			goto err;
+		}
+	}
+err:
+	mutex_unlock(&event_dev->lock);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(devfreq_disable_event_dev);
+
+bool devfreq_is_enabled_event_dev(struct devfreq_event_dev *event_dev)
+{
+	bool enabled = false;
+
+	if (!event_dev || !event_dev->desc)
+		return enabled;
+
+	if (!(event_dev->enable_count > 0))
+		return enabled;
+
+	if (event_dev->desc->ops && event_dev->desc->ops->is_enabled)
+		enabled = event_dev->desc->ops->is_enabled(event_dev);
+
+	return enabled;
+}
+EXPORT_SYMBOL_GPL(devfreq_is_enabled_event_dev);
+
+int devfreq_set_event_event_dev(struct devfreq_event_dev *event_dev)
+{
+	if (!event_dev || !event_dev->desc)
+		return -EINVAL;
+
+	if (!devfreq_is_enabled_event_dev(event_dev))
+		return -EPERM;
+
+	if (event_dev->desc->ops && event_dev->desc->ops->set_event)
+		return event_dev->desc->ops->set_event(event_dev);
+
+	return -EINVAL;
+}
+EXPORT_SYMBOL_GPL(devfreq_set_event_event_dev);
+
+int devfreq_get_event_event_dev(struct devfreq_event_dev *event_dev,
+				int *total_event)
+{
+	if (!event_dev || !event_dev->desc)
+		return -EINVAL;
+
+	if (!devfreq_is_enabled_event_dev(event_dev))
+		return -EPERM;
+
+	if (event_dev->desc->ops && event_dev->desc->ops->get_event)
+		return event_dev->desc->ops->get_event(event_dev, total_event);
+
+	return -EINVAL;
+}
+EXPORT_SYMBOL_GPL(devfreq_get_event_event_dev);
+
+int devfreq_reset_event_dev(struct devfreq_event_dev *event_dev)
+{
+	if (!event_dev || !event_dev->desc)
+		return -EINVAL;
+
+	if (!devfreq_is_enabled_event_dev(event_dev))
+		return -EPERM;
+
+	if (event_dev->desc->ops && event_dev->desc->ops->reset)
+		return event_dev->desc->ops->reset(event_dev);
+
+	return -EINVAL;
+}
+EXPORT_SYMBOL_GPL(devfreq_reset_event_dev);
+
+void *event_dev_get_drvdata(struct devfreq_event_dev *event_dev)
+{
+	return event_dev->desc->driver_data;
+}
+EXPORT_SYMBOL_GPL(event_dev_get_drvdata);
+
+/*
+ * Device Attribues for devfreq event class
+ */
+static ssize_t name_show(struct device *dev,
+				       struct device_attribute *attr,
+				       char *buf)
+{
+	struct devfreq_event_dev *event_dev = to_devfreq_event(dev);
+
+	if (!event_dev || !event_dev->desc)
+		return -EINVAL;
+
+	return sprintf(buf, "%s\n", event_dev->desc->name);
+}
+static DEVICE_ATTR_RO(name);
+
+static struct attribute *devfreq_event_attrs[] = {
+	&dev_attr_name.attr,
+	NULL,
+};
+ATTRIBUTE_GROUPS(devfreq_event);
+
+static int __init devfreq_event_init(void)
+{
+	devfreq_event_class = class_create(THIS_MODULE, "devfreq_event");
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
+MODULE_DESCRIPTION("devfreq-event class support");
+MODULE_LICENSE("GPL");
diff --git a/drivers/devfreq/event/Makefile b/drivers/devfreq/event/Makefile
new file mode 100644
index 0000000..dc56005
--- /dev/null
+++ b/drivers/devfreq/event/Makefile
@@ -0,0 +1 @@
+# Exynos DEVFREQ Event Drivers
diff --git a/include/linux/devfreq.h b/include/linux/devfreq.h
index f1863dc..3c5f233 100644
--- a/include/linux/devfreq.h
+++ b/include/linux/devfreq.h
@@ -175,6 +175,68 @@ struct devfreq {
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
+ * struct devfreq_event_ops - the operations of devfreq-event device
+ *
+ * @enable	: Enable the devfreq-event device.
+ * @disable	: Disable the devfreq-event device.
+ * @is_enabled	: Return true if the devfreq-event is enabled, false if not.
+ * @set_event	: Set the specific event type for the devfreq-event device.
+ * @get_event	: Get the result of the devfreq-event devie with specific
+ *		  event type.
+ * @reset	: Reset all setting of the devfreq-event device.
+ *
+ * This structure contains devfreq-event device operations which can be
+ * implemented by devfreq-event device drivers.
+ */
+struct devfreq_event_ops {
+	int (*enable)(struct devfreq_event_dev *event_dev);
+	int (*disable)(struct devfreq_event_dev *event_dev);
+	bool (*is_enabled)(struct devfreq_event_dev *event_dev);
+	int (*set_event)(struct devfreq_event_dev *event_dev);
+	int (*get_event)(struct devfreq_event_dev *event_dev, int *total_event);
+	int (*reset)(struct devfreq_event_dev *event_dev);
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
@@ -204,6 +266,22 @@ extern int devm_devfreq_register_opp_notifier(struct device *dev,
 extern void devm_devfreq_unregister_opp_notifier(struct device *dev,
 						struct devfreq *devfreq);
 
+/* Functions for devfreq event device */
+extern struct devfreq_event_dev *devfreq_add_event_device(struct device *dev,
+				struct devfreq_event_desc *desc);
+extern void *event_dev_get_drvdata(struct devfreq_event_dev *event_dev);
+extern struct devfreq_event_dev *devfreq_get_event_dev(const char *name);
+extern struct devfreq_event_dev *devfreq_get_event_dev_by_phandle(
+				struct device *dev, int index);
+extern int devfreq_put_event_dev(struct devfreq_event_dev *event_dev);
+extern int devfreq_enable_event_dev(struct devfreq_event_dev *event_dev);
+extern int devfreq_disable_event_dev(struct devfreq_event_dev *event_dev);
+extern bool devfreq_is_enabled_event_dev(struct devfreq_event_dev *event_dev);
+extern int devfreq_set_event_event_dev(struct devfreq_event_dev *event_dev);
+extern int devfreq_get_event_event_dev(struct devfreq_event_dev *event_dev,
+					int *total_event);
+extern int devfreq_reset_event_dev(struct devfreq_event_dev *event_dev);
+
 #if IS_ENABLED(CONFIG_DEVFREQ_GOV_SIMPLE_ONDEMAND)
 /**
  * struct devfreq_simple_ondemand_data - void *data fed to struct devfreq
@@ -233,6 +311,13 @@ static inline struct devfreq *devfreq_add_device(struct device *dev,
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
@@ -289,6 +374,62 @@ static inline void devm_devfreq_unregister_opp_notifier(struct device *dev,
 							struct devfreq *devfreq)
 {
 }
+
+static inline void *event_dev_get_drvdata(struct devfreq_event_dev *event_dev)
+{
+	return ERR_PTR(-EINVAL);
+}
+
+static inline struct devfreq_event_dev *devfreq_get_event_dev(const char *name)
+{
+	return ERR_PTR(-ENODEV);
+}
+
+struct devfreq_event_dev *devfreq_get_event_dev_by_phandle(struct device *dev,
+						      int index)
+{
+	return ERR_PTR(-ENODEV);
+}
+
+static inline int devfreq_put_event_dev(struct devfreq_event_dev *event_dev)
+{
+	return -EINVAL;
+}
+
+static inline int devfreq_enable_event_dev(struct devfreq_event_dev *event_dev)
+{
+	return -EINVAL;
+}
+
+static inline int devfreq_disable_event_dev(
+				struct devfreq_event_dev *event_dev)
+{
+	return -EINVAL;
+}
+
+static inline bool devfreq_is_enabled_event_dev(
+				struct devfreq_event_dev *event_dev)
+{
+	return false;
+}
+
+static inline int devfreq_set_event_event_dev(
+				struct devfreq_event_dev *event_dev)
+{
+	return -EINVAL;
+}
+
+static inline int devfreq_get_event_event_dev(
+				struct devfreq_event_dev *event_dev,
+				int *total_event);
+{
+	return -EINVAL;
+}
+
+static inline int devfreq_reset_event_dev(struct devfreq_event_dev *event_dev)
+{
+	return -EINVAL;
+}
 #endif /* CONFIG_PM_DEVFREQ */
 
 #endif /* __LINUX_DEVFREQ_H__ */
-- 
1.8.5.5

