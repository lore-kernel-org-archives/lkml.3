Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757760Ab3FLBkO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 21:40:14 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:39379 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753814Ab3FLBkD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 21:40:03 -0400
X-AuditID: cbfee690-b7f6f6d00000740c-65-51b7d1711729
From: Chanwoo Choi <cw00.choi@samsung.com>
To: kishon@ti.com, myungjoo.ham@samsung.com, cw00.choi@samsung.com,
        balbi@ti.com, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-omap@vger.kernel.org
Cc: grant.likely@linaro.org, rob.herring@calxeda.com, rob@landley.net,
        gregkh@linuxfoundation.org, benoit.cousson@linaro.org,
        anish198519851985@gmail.com, pmeerw@pmeerw.net
Subject: [PATCH] extcon: Add an API to get extcon device from dt node
Date: Wed, 12 Jun 2013 10:39:09 +0900
Message-id: <1371001149-16906-1-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1370276020-17446-2-git-send-email-kishon@ti.com>
References: <1370276020-17446-2-git-send-email-kishon@ti.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrNIsWRmVeSWpSXmKPExsWyRsSkULfw4vZAg1Xd2haXb3QxWxy8X28x
	89NNNovrX56zWhyY/RBI/NnBaNG8eD2bxYWnPWwWC9uWsFhc3jWHzWL2kn4Wi0XLWpktbjeu
	YLP4vesYu8XhFQeYLNa9nM7iIOCx4PMVdo+ds+6ye7xaPZPV4861PWwe++euYfc4P2Mho8f5
	5iOMHn1bVjF6HL+xncnj8ya5AK4oLpuU1JzMstQifbsErozpT2axFMxTrOicuImxgfGWdBcj
	J4eEgInEtfu72CFsMYkL99azgdhCAksZJd5PloKpWbjrNGMXIxdQfDqjxMpLf6Gc/4wSV25v
	A+tmE9CS2P/iBhtIQkTgNaPEzq5VLCAOs8AGRok3y7uYuxg5OIQFXCXu/QkFaWARUJW4se87
	E4jNCxRe+XYxI8Q6OYkPex6BDeUUsJPYt6CPFaRVSMBWonEJ2EgJgVYOiXWT5jJDzBGQ+Db5
	EAtIjYSArMSmA8wQYyQlDq64wTKBUXgBI8MqRtHUguSC4qT0IhO94sTc4tK8dL3k/NxNjMCI
	O/3v2YQdjPcOWB9iTAYaN5FZSjQ5HxixeSXxhsZmRhamJqbGRuaWZqQJK4nzqrdYBwoJpCeW
	pGanphakFsUXleakFh9iZOLglGpgtOV/q5ui1z2jdflzTbHsOD/dLK0fNiYd1atiCu4ySeed
	ffbD+tU8CQHe9Q7ft26wEf7it+2Oo4C/edGmFXFpNsYvNnUcKMy1lW0SyL8Ssuz/i28r7l9f
	mZlUuHVN5LRbKRKcD/xWM7J1ld6/eTvcef3KKc3+Np/M9Tfn7n7UxzvFdMd3x5+PlFiKMxIN
	tZiLihMBiFmc7M4CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprJKsWRmVeSWpSXmKPExsVy+t9jQd3Ci9sDDXZ+lbe4fKOL2eLg/XqL
	mZ9usllc//Kc1eLA7IdA4s8ORovmxevZLC487WGzWNi2hMXi8q45bBazl/SzWCxa1spscbtx
	BZvF713H2C0OrzjAZLHu5XQWBwGPBZ+vsHvsnHWX3ePV6pmsHneu7WHz2D93DbvH+RkLGT3O
	Nx9h9OjbsorR4/iN7UwenzfJBXBFNTDaZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpa
	mCsp5CXmptoqufgE6Lpl5gA9o6RQlphTChQKSCwuVtK3wzQhNMRN1wKmMULXNyQIrsfIAA0k
	rGHMmP5kFkvBPMWKzombGBsYb0l3MXJySAiYSCzcdZoRwhaTuHBvPVsXIxeHkMB0RomVl/4y
	Qjj/GSWu3N7GDlLFJqAlsf/FDbAqEYHXjBI7u1axgDjMAhsYJd4s72LuYuTgEBZwlbj3JxSk
	gUVAVeLGvu9MIDYvUHjl28VQ6+QkPux5BDaUU8BOYt+CPlaQViEBW4nGJSwTGHkXMDKsYhRN
	LUguKE5KzzXSK07MLS7NS9dLzs/dxAiO6GfSOxhXNVgcYhTgYFTi4T1gtj1QiDWxrLgy9xCj
	BAezkgivbi5QiDclsbIqtSg/vqg0J7X4EGMy0FETmaVEk/OBySavJN7Q2MTMyNLI3NDCyNic
	NGElcd6DrdaBQgLpiSWp2ampBalFMFuYODilGhizixZvMJxlrNjxd9olP8dV8lfuPv6jJHK4
	c+uBPV0mV54Y9l5NiLoW9Hb5cuGVkUILappTOOsvKN/76F943zC9N/XVLkuG1xLeKqF7uDJN
	2j1SrzlNkEja+6qqosQxeFqx/ve4LveDxrtl18XNyI9r+nOx63mL8OFkYZsVwWqXgyrksj7y
	MCixFGckGmoxFxUnAgBdy4njLAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kishon Vijay Abraham I <kishon@ti.com>

Added an API of_extcon_get_extcon_dev() to be used by drivers to get
extcon device in the case of dt boot (this can be used instead of
extcon_get_extcon_dev()).

Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Myungjoo Ham <myungjoo.ham@samsung.com>
---
 drivers/extcon/Makefile          |  3 +++
 drivers/extcon/of-extcon.c       | 56 ++++++++++++++++++++++++++++++++++++++++
 include/linux/extcon/of-extcon.h | 30 +++++++++++++++++++++
 3 files changed, 89 insertions(+)
 create mode 100644 drivers/extcon/of-extcon.c
 create mode 100644 include/linux/extcon/of-extcon.h

diff --git a/drivers/extcon/Makefile b/drivers/extcon/Makefile
index 540e2c3..39cdf95 100644
--- a/drivers/extcon/Makefile
+++ b/drivers/extcon/Makefile
@@ -2,9 +2,12 @@
 # Makefile for external connector class (extcon) devices
 #
 
+obj-$(CONFIG_OF)		+= of-extcon.o
+
 obj-$(CONFIG_EXTCON)		+= extcon-class.o
 obj-$(CONFIG_EXTCON_GPIO)	+= extcon-gpio.o
 obj-$(CONFIG_EXTCON_ADC_JACK)	+= extcon-adc-jack.o
+
 obj-$(CONFIG_EXTCON_MAX77693)	+= extcon-max77693.o
 obj-$(CONFIG_EXTCON_MAX8997)	+= extcon-max8997.o
 obj-$(CONFIG_EXTCON_ARIZONA)	+= extcon-arizona.o
diff --git a/drivers/extcon/of-extcon.c b/drivers/extcon/of-extcon.c
new file mode 100644
index 0000000..29f82b4
--- /dev/null
+++ b/drivers/extcon/of-extcon.c
@@ -0,0 +1,56 @@
+/*
+ * OF helpers for External connector (extcon) framework
+ *
+ * Copyright (C) 2013 Texas Instruments, Inc.
+ * Kishon Vijay Abraham I <kishon@ti.com>
+ *
+ * Copyright (C) 2013 Samsung Electronics
+ * Chanwoo Choi <cw00.choi@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/extcon.h>
+#include <linux/of.h>
+#include <linux/of_platform.h>
+#include <linux/extcon/of-extcon.h>
+
+struct extcon_dev *of_extcon_get_extcon_dev(struct device *dev, int index)
+{
+	struct device_node *node;
+	struct extcon_dev *edev;
+	struct platform_device *extcon_parent_dev;
+
+	if (!dev->of_node) {
+		dev_dbg(dev, "device does not have a device node entry\n");
+		return ERR_PTR(-EINVAL);
+	}
+
+	node = of_parse_phandle(dev->of_node, "extcon", index);
+	if (!node) {
+		dev_dbg(dev, "failed to get phandle in %s node\n",
+			dev->of_node->full_name);
+		return ERR_PTR(-ENODEV);
+	}
+
+	extcon_parent_dev = of_find_device_by_node(node);
+	if (!extcon_parent_dev) {
+		dev_dbg(dev, "unable to find device by node\n");
+		return ERR_PTR(-EPROBE_DEFER);
+	}
+
+	edev = extcon_get_extcon_dev(dev_name(&extcon_parent_dev->dev));
+	if (!edev) {
+		dev_dbg(dev, "unable to get extcon device : %s\n",
+				dev_name(&extcon_parent_dev->dev));
+		return ERR_PTR(-ENODEV);
+	}
+
+	return edev;
+}
+EXPORT_SYMBOL_GPL(of_extcon_get_extcon_dev);
diff --git a/include/linux/extcon/of-extcon.h b/include/linux/extcon/of-extcon.h
new file mode 100644
index 0000000..77d01ba
--- /dev/null
+++ b/include/linux/extcon/of-extcon.h
@@ -0,0 +1,30 @@
+/*
+ * OF helpers for External connector (extcon) framework
+ *
+ * Copyright (C) 2013 Texas Instruments, Inc.
+ * Kishon Vijay Abraham I <kishon@ti.com>
+ *
+ * Copyright (C) 2013 Samsung Electronics
+ * Chanwoo Choi <cw00.choi@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#ifndef __LINUX_OF_EXTCON_H
+#define __LINUX_OF_EXTCON_H
+
+#if defined(CONFIG_OF)
+extern struct extcon_dev
+	*of_extcon_get_extcon_dev(struct device *dev, int index);
+#else
+static inline struct extcon_dev
+	*of_extcon_get_extcon_dev(struct device *dev, int index);
+{
+	return NULL;
+}
+#endif /* CONFIG_OF */
+
+#endif /* __LINUX_OF_EXTCON_H */
-- 
1.8.0

