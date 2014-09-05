Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752485AbaIEEac (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 00:30:32 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:27077 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750762AbaIEEaZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 00:30:25 -0400
X-AuditID: cbfee68f-f797f6d000001173-e5-54093c5e45f7
From: Chanwoo Choi <cw00.choi@samsung.com>
To: myungjoo.ham@samsung.com, linux-pm@vger.kernel.org
Cc: kyungmin.park@samsung.com, rafael.j.wysocki@intel.com,
        a.kesavan@samsung.com, kgene.kim@samsung.com, tomasz.figa@gmail.com,
        b.zolnierkie@samsung.com, nm@ti.com, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: [RFC PATCH 1/5] devfreq: Add new devfreq_event class to provide basic
 data for devfreq governor
Date: Fri, 05 Sep 2014 13:30:15 +0900
Message-id: <1409891419-28560-2-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1409891419-28560-1-git-send-email-cw00.choi@samsung.com>
References: <1409891419-28560-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrHLMWRmVeSWpSXmKPExsWyRsSkSDfOhjPEYMMTOYvHaxYzWWycsZ7V
	4vqX56wWvQuuslmcbXrDbrHp8TVWi8u75rBZfO49wmgx4/w+JovbjSvYLN78OMtk8XjFW3aL
	Vbv+MDrweuycdZfdY/Gel0wem5fUe/RtWcXocfzGdiaPz5vkAtiiuGxSUnMyy1KL9O0SuDKe
	LDrEWLAnr+LpsXVsDYyPY7oYOTkkBEwkzrUeYYKwxSQu3FvP1sXIxSEksJRR4tSxxUAOB1jR
	wYXVEPHpjBLLf/YwQThNTBItk08zgnSzCWhJ7H9xgw3EFhEwk9i34y8rSBGzwA4miWsHfoAV
	CQtkSfztfgdmswioShxZdRWsgVfAVeL1rQdQZ8hJfNjziB3E5hRwk1h7/xpYXAio5uLxScwg
	QyUEzrFLTPiyiAVikIDEt8mHWCBOlZXYdIAZYo6kxMEVN1gmMAovYGRYxSiaWpBcUJyUXmSs
	V5yYW1yal66XnJ+7iREYLaf/PevfwXj3gPUhRgEORiUe3gWfOUKEWBPLiitzDzGaAm2YyCwl
	mpwPjMm8knhDYzMjC1MTU2Mjc0szJXHehVI/g4UE0hNLUrNTUwtSi+KLSnNSiw8xMnFwSjUw
	Trkq0vRri4iu0PUT2RwZr7pd9h79O0vc1uhgVKfTX9l+7mTenvUpmmqPzJ4aTImQU2M9HD5r
	/8n8M3u+LP/D12Yb57FzaknUk83ca0/5u9p0/NQp3XbcdOHErVIhEVJlZ+cdVkqNDa8xvrnB
	ue9misxV7YUxmrsLC6cWVK058nnp5kP2IUvtlViKMxINtZiLihMBlrDWA5ECAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrBIsWRmVeSWpSXmKPExsVy+t9jQd04G84Qg837hC0er1nMZLFxxnpW
	i+tfnrNa9C64ymZxtukNu8Wmx9dYLS7vmsNm8bn3CKPFjPP7mCxuN65gs3jz4yyTxeMVb9kt
	Vu36w+jA67Fz1l12j8V7XjJ5bF5S79G3ZRWjx/Eb25k8Pm+SC2CLamC0yUhNTEktUkjNS85P
	ycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ0HXLzAG6VEmhLDGnFCgUkFhcrKRvh2lC
	aIibrgVMY4Sub0gQXI+RARpIWMOY8WTRIcaCPXkVT4+tY2tgfBzTxcjBISFgInFwYXUXIyeQ
	KSZx4d56ti5GLg4hgemMEst/9jBBOE1MEi2TTzOCVLEJaEnsf3GDDcQWETCT2LfjLytIEbPA
	DiaJawd+gBUJC2RJ/O1+B2azCKhKHFl1FayBV8BV4vWtB0wQ6+QkPux5xA5icwq4Say9fw0s
	LgRUc/H4JOYJjLwLGBlWMYqmFiQXFCel5xrpFSfmFpfmpesl5+duYgTH4jPpHYyrGiwOMQpw
	MCrx8C74zBEixJpYVlyZe4hRgoNZSYTX6w1QiDclsbIqtSg/vqg0J7X4EKMp0FUTmaVEk/OB
	aSKvJN7Q2MTMyNLI3NDCyNhcSZz3YKt1oJBAemJJanZqakFqEUwfEwenVAOjuiqj5HEnlj38
	R3SZM92z6689/OZ7xMjF7RFHsgrXgsMpvSzTTr6YJeWTph8cu4m9wLI08MfeuT0Ps75F+L5p
	fJWS1lJ1UriB5YLP/YRbAbM1WmTUJgS88fpqqmpWnysvscW441rKegml7E3Rx86vTVpw8OyN
	JbY7dVgu9adPVFA9c+fA22tKLMUZiYZazEXFiQBR5yNj2wIAAA==
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

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/devfreq/Kconfig         |   2 +
 drivers/devfreq/Makefile        |   5 +-
 drivers/devfreq/devfreq-event.c | 251 ++++++++++++++++++++++++++++++++++++++++
 drivers/devfreq/event/Makefile  |   1 +
 include/linux/devfreq.h         |  97 ++++++++++++++++
 5 files changed, 355 insertions(+), 1 deletion(-)
 create mode 100644 drivers/devfreq/devfreq-event.c
 create mode 100644 drivers/devfreq/event/Makefile

diff --git a/drivers/devfreq/Kconfig b/drivers/devfreq/Kconfig
index 3dced0a..ef839e7 100644
--- a/drivers/devfreq/Kconfig
+++ b/drivers/devfreq/Kconfig
@@ -88,4 +88,6 @@ config ARM_EXYNOS5_BUS_DEVFREQ
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
index 0000000..1629197
--- /dev/null
+++ b/drivers/devfreq/devfreq-event.c
@@ -0,0 +1,251 @@
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
+	struct devfreq_event_dev *edev;
+	static atomic_t event_no = ATOMIC_INIT(0);
+	int ret;
+
+	if (!dev || !desc)
+		return ERR_PTR(-EINVAL);
+
+	if (!desc->name || !desc->ops || !desc->dev)
+		return ERR_PTR(-EINVAL);
+
+	edev = kzalloc(sizeof(struct devfreq_event_dev), GFP_KERNEL);
+	if (!edev)
+		return ERR_PTR(-ENOMEM);
+
+	mutex_lock(&devfreq_event_list_lock);
+
+	mutex_init(&edev->mutex);
+	edev->desc = desc;
+	edev->driver_data = desc->driver_data;
+	edev->owner = desc->owner;
+
+	edev->dev.parent = dev;
+	edev->dev.class = devfreq_event_class;
+
+	dev_set_name(&edev->dev, "event.%d",
+		     atomic_inc_return(&event_no) - 1);
+	ret = device_register(&edev->dev);
+	if (ret != 0) {
+		put_device(&edev->dev);
+		goto err;
+	}
+	dev_set_drvdata(&edev->dev, edev);
+
+	/* Add devfreq event device to devfreq_event_list */
+	INIT_LIST_HEAD(&edev->node);
+	list_add(&edev->node, &devfreq_event_list);
+
+	mutex_unlock(&devfreq_event_list_lock);
+
+	return edev;
+err:
+	kfree(edev);
+	return ERR_PTR(ret);
+}
+EXPORT_SYMBOL(devfreq_add_event_device);
+
+struct devfreq_event_dev *devfreq_get_edev(const char *edev_name)
+{
+	struct devfreq_event_dev *edev;
+
+	mutex_lock(&devfreq_event_list_lock);
+	list_for_each_entry(edev, &devfreq_event_list, node) {
+		if (!strcmp(edev->desc->name, edev_name))
+			goto out;
+	}
+	edev = NULL;
+out:
+	mutex_unlock(&devfreq_event_list_lock);
+
+	return edev;
+}
+EXPORT_SYMBOL_GPL(devfreq_get_edev);
+
+struct devfreq_event_dev *devfreq_get_edev_by_phandle(struct device *dev,
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
+	edev = devfreq_get_edev(node->name);
+	if (!edev) {
+		dev_err(dev, "unable to get devfreq-event device : %s\n",
+			node->name);
+		return ERR_PTR(-ENODEV);
+	}
+
+	return edev;
+}
+EXPORT_SYMBOL_GPL(devfreq_get_edev_by_phandle);
+
+int devfreq_put_edev(struct devfreq_event_dev *edev)
+{
+	return 0;
+}
+EXPORT_SYMBOL_GPL(devfreq_put_edev);
+
+int devfreq_enable_edev(struct devfreq_event_dev *edev)
+{
+	if (!edev || !edev->desc)
+		return -EINVAL;
+
+	if (edev->desc->ops && edev->desc->ops->enable)
+		return edev->desc->ops->enable(edev);
+
+	return -EINVAL;
+}
+EXPORT_SYMBOL_GPL(devfreq_enable_edev);
+
+int devfreq_disable_edev(struct devfreq_event_dev *edev)
+{
+	if (!edev || !edev->desc)
+		return -EINVAL;
+
+	if (edev->desc->ops && edev->desc->ops->disable)
+		return edev->desc->ops->disable(edev);
+
+	return -EINVAL;
+}
+EXPORT_SYMBOL_GPL(devfreq_disable_edev);
+
+int devfreq_set_event_edev(struct devfreq_event_dev *edev)
+{
+	if (!edev || !edev->desc)
+		return -EINVAL;
+
+	if (edev->desc->ops && edev->desc->ops->set_event)
+		return edev->desc->ops->set_event(edev);
+
+	return -EINVAL;
+}
+EXPORT_SYMBOL_GPL(devfreq_set_event_edev);
+
+int devfreq_get_event_edev(struct devfreq_event_dev *edev)
+{
+	if (!edev || !edev->desc)
+		return -EINVAL;
+
+	if (edev->desc->ops && edev->desc->ops->get_event)
+		return edev->desc->ops->get_event(edev);
+
+	return -EINVAL;
+}
+EXPORT_SYMBOL_GPL(devfreq_get_event_edev);
+
+int devfreq_reset_edev(struct devfreq_event_dev *edev)
+{
+	if (!edev || !edev->desc)
+		return -EINVAL;
+
+	if (edev->desc->ops && edev->desc->ops->reset)
+		return edev->desc->ops->reset(edev);
+
+	return -EINVAL;
+}
+EXPORT_SYMBOL_GPL(devfreq_reset_edev);
+
+void *edev_get_drvdata(struct devfreq_event_dev *edev)
+{
+	return edev->driver_data;
+}
+EXPORT_SYMBOL_GPL(edev_get_drvdata);
+
+/*
+ * Device Attribues for devfreq event class
+ */
+static ssize_t name_show(struct device *dev,
+				       struct device_attribute *attr,
+				       char *buf)
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
index f1863dc..a87989b 100644
--- a/include/linux/devfreq.h
+++ b/include/linux/devfreq.h
@@ -175,6 +175,36 @@ struct devfreq {
 	unsigned long last_stat_updated;
 };
 
+struct devfreq_event_dev {
+	const struct devfreq_event_desc *desc;
+
+	struct list_head node;
+	struct device dev;
+	struct module *owner;
+	struct mutex mutex;
+
+	void *driver_data;
+};
+
+struct devfreq_event_ops {
+	int (*enable)(struct devfreq_event_dev *edev);
+	int (*disable)(struct devfreq_event_dev *edev);
+	int (*set_event)(struct devfreq_event_dev *edev);
+	int (*get_event)(struct devfreq_event_dev *edev);
+	int (*reset)(struct devfreq_event_dev *edev);
+};
+
+struct devfreq_event_desc {
+	const char *name;
+	unsigned int id;
+
+	struct devfreq_event_ops *ops;
+	struct device *dev;
+	struct module *owner;
+
+	void *driver_data;
+};
+
 #if defined(CONFIG_PM_DEVFREQ)
 extern struct devfreq *devfreq_add_device(struct device *dev,
 				  struct devfreq_dev_profile *profile,
@@ -204,6 +234,20 @@ extern int devm_devfreq_register_opp_notifier(struct device *dev,
 extern void devm_devfreq_unregister_opp_notifier(struct device *dev,
 						struct devfreq *devfreq);
 
+/* Functions for devfreq event device */
+extern struct devfreq_event_dev *devfreq_add_event_device(struct device *dev,
+				struct devfreq_event_desc *desc);
+extern struct devfreq_event_dev *devfreq_get_edev(const char *name);
+extern struct devfreq_event_dev *devfreq_get_edev_by_phandle(struct device *dev,
+							     int index);
+extern int devfreq_put_edev(struct devfreq_event_dev *edev);
+extern int devfreq_enable_edev(struct devfreq_event_dev *edev);
+extern int devfreq_disable_edev(struct devfreq_event_dev *edev);
+extern int devfreq_set_event_edev(struct devfreq_event_dev *edev);
+extern int devfreq_get_event_edev(struct devfreq_event_dev *edev);
+extern int devfreq_reset_edev(struct devfreq_event_dev *edev);
+extern void *edev_get_drvdata(struct devfreq_event_dev *edev);
+
 #if IS_ENABLED(CONFIG_DEVFREQ_GOV_SIMPLE_ONDEMAND)
 /**
  * struct devfreq_simple_ondemand_data - void *data fed to struct devfreq
@@ -233,6 +277,13 @@ static inline struct devfreq *devfreq_add_device(struct device *dev,
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
@@ -289,6 +340,52 @@ static inline void devm_devfreq_unregister_opp_notifier(struct device *dev,
 							struct devfreq *devfreq)
 {
 }
+
+static inline void *edev_get_drvdata(struct devfreq_event_dev *edev);
+{
+	return ERR_PTR(-EINVAL);
+}
+
+static inline struct devfreq_event_dev *devfreq_get_edev(const char *name)
+{
+	return ERR_PTR(-ENODEV);
+}
+
+struct devfreq_event_dev *devfreq_get_edev_by_phandle(struct device *dev,
+						      int index)
+{
+	return ERR_PTR(-ENODEV);
+}
+
+static inline int devfreq_put_edev(struct devfreq_event_dev *edev)
+{
+	return -EINVAL;
+}
+
+static inline int devfreq_enable_edev(struct devfreq_event_dev *edev)
+{
+	return -EINVAL;
+}
+
+static inline int devfreq_disable_edev(struct devfreq_event_dev *edev)
+{
+	return -EINVAL;
+}
+
+static inline int devfreq_set_event_edev(struct devfreq_event_dev *edev)
+{
+	return -EINVAL;
+}
+
+static inline int devfreq_get_event_edev(struct devfreq_event_dev *edev)
+{
+	return -EINVAL;
+}
+
+static inline int devfreq_reset_edev(struct devfreq_event_dev *edev)
+{
+	return -EINVAL;
+}
 #endif /* CONFIG_PM_DEVFREQ */
 
 #endif /* __LINUX_DEVFREQ_H__ */
-- 
1.8.0

