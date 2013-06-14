Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752042Ab3FNHP6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 03:15:58 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:10626 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751344Ab3FNHPz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 03:15:55 -0400
X-AuditID: cbfee68f-b7f436d000000f81-48-51bac3244408
From: Chanwoo Choi <cw00.choi@samsung.com>
To: kishon@ti.com, myungjoo.ham@samsung.com, cw00.choi@samsung.com,
        balbi@ti.com, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-omap@vger.kernel.org
Cc: grant.likely@linaro.org, rob.herring@calxeda.com, rob@landley.net,
        gregkh@linuxfoundation.org, benoit.cousson@linaro.org,
        anish198519851985@gmail.com, pmeerw@pmeerw.net
Subject: [PATCH v2] extcon: Add an API to get extcon device from dt node
Date: Fri, 14 Jun 2013 16:15:46 +0900
Message-id: <1371194146-17260-1-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1370276020-17446-2-git-send-email-kishon@ti.com>
References: <1370276020-17446-2-git-send-email-kishon@ti.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrNIsWRmVeSWpSXmKPExsWyRsSkSFf18K5Ag2NaFpdvdDFbHLxfbzHz
	0002i+tfnrNaHJj9EEj82cFo0bx4PZvFhac9bBYL25awWFzeNYfNYvaSfhaLRctamS1uN65g
	s/i96xi7xeEVB5gs1r2czuIg4LHg8xV2j52z7rJ7vFo9k9XjzrU9bB77565h9zg/YyGjx/nm
	I4wefVtWMXocv7GdyePzJrkArigum5TUnMyy1CJ9uwSujBmfGpgLHmtUdP2TaWD8qtjFyMkh
	IWAice9FFzuELSZx4d56ti5GLg4hgaWMErf3vGCEKTo35TwLRGI6o8T8lttQVf8ZJc51dIO1
	swloSex/cQMsISLwmlFiZ9cqsBZmgQ2MEm+WdzGDVAkLeEi8fncEbC6LgKrEn1sL2EBsXgFX
	iT/TLjJB7JOT+LDnEdhUTgE7iX0L+li7GDmA1tlKNC4Bmykh0MohMeHjDXaIOQIS3yYfYgGp
	kRCQldh0gBlijKTEwRU3WCYwCi9gZFjFKJpakFxQnJReZKxXnJhbXJqXrpecn7uJERhxp/89
	69/BePeA9SHGZKBxE5mlRJPzgRGbVxJvaGxmZGFqYmpsZG5pRpqwkjivWot1oJBAemJJanZq
	akFqUXxRaU5q8SFGJg5OqQZGs9mXmW8HqS8oqP5Seovdz+vb3yl1O/OfN2pw7GLT2BgV8yVf
	LqY4Q2VtWItS9S6erLjZNo+LmedYBepcmr/ITHj3oo2lv35Zb14TdDR8ZszGlCaBcJ8/EjFP
	Y2zuOPd+czc5w3O6KGtr/KGDFUl9PHlLLkfpTeh8/ravKqIoZkrYyrTkrR+VWIozEg21mIuK
	EwFeyztNzgIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprJKsWRmVeSWpSXmKPExsVy+t9jQV2Vw7sCDc68MLC4fKOL2eLg/XqL
	mZ9usllc//Kc1eLA7IdA4s8ORovmxevZLC487WGzWNi2hMXi8q45bBazl/SzWCxa1spscbtx
	BZvF713H2C0OrzjAZLHu5XQWBwGPBZ+vsHvsnHWX3ePV6pmsHneu7WHz2D93DbvH+RkLGT3O
	Nx9h9OjbsorR4/iN7UwenzfJBXBFNTDaZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpa
	mCsp5CXmptoqufgE6Lpl5gA9o6RQlphTChQKSCwuVtK3wzQhNMRN1wKmMULXNyQIrsfIAA0k
	rGHMmPGpgbngsUZF1z+ZBsavil2MnBwSAiYS56acZ4GwxSQu3FvP1sXIxSEkMJ1RYn7LbSjn
	P6PEuY5udpAqNgEtif0vboAlRAReM0rs7FrFAuIwC2xglHizvIsZpEpYwEPi9bsjjCA2i4Cq
	xJ9bC9hAbF4BV4k/0y4yQeyTk/iw5xHYVE4BO4l9C/pYuxg5gNbZSjQuYZnAyLuAkWEVo2hq
	QXJBcVJ6rqFecWJucWleul5yfu4mRnBEP5PawbiyweIQowAHoxIPb8KFnYFCrIllxZW5hxgl
	OJiVRHjD/wKFeFMSK6tSi/Lji0pzUosPMSYDHTWRWUo0OR+YbPJK4g2NTcyMLI3MDS2MjM1J
	E1YS5z3Qah0oJJCeWJKanZpakFoEs4WJg1OqgTEhgfmj9stZccocm4/5bg/tOdb+1P/Y6Wd5
	/28fs9/945xqbJLsva/Ra9/xmG/m296x+MQFmVMb/gS1im0sn/XYoHLp64VKwiv1Qi715GWH
	tAmJN3MdyPw180vg3hVODiZRDGrKkwssxRbfzfe+rLNmfiffr6iNWWfj5zbcWLru0PUzvTlJ
	FQJKLMUZiYZazEXFiQDkn3enLAMAAA==
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
Changes since v1:
- If edev->name is NULL, dev_name(dev) is used as edev->name.
- Change filename from of-extcon.* to of_extcon.*
- Fix build error when CONFIG_OF is not set
- Add header file(linux/err.h) to of_extcon.c

 drivers/extcon/Makefile          |  2 ++
 drivers/extcon/extcon-class.c    |  3 +-
 drivers/extcon/of_extcon.c       | 64 ++++++++++++++++++++++++++++++++++++++++
 include/linux/extcon/of_extcon.h | 30 +++++++++++++++++++
 4 files changed, 98 insertions(+), 1 deletion(-)
 create mode 100644 drivers/extcon/of_extcon.c
 create mode 100644 include/linux/extcon/of_extcon.h

diff --git a/drivers/extcon/Makefile b/drivers/extcon/Makefile
index 540e2c3..83468f7 100644
--- a/drivers/extcon/Makefile
+++ b/drivers/extcon/Makefile
@@ -2,6 +2,8 @@
 # Makefile for external connector class (extcon) devices
 #
 
+obj-$(CONFIG_OF)		+= of_extcon.o
+
 obj-$(CONFIG_EXTCON)		+= extcon-class.o
 obj-$(CONFIG_EXTCON_GPIO)	+= extcon-gpio.o
 obj-$(CONFIG_EXTCON_ADC_JACK)	+= extcon-adc-jack.o
diff --git a/drivers/extcon/extcon-class.c b/drivers/extcon/extcon-class.c
index 23f11ea..08509ea 100644
--- a/drivers/extcon/extcon-class.c
+++ b/drivers/extcon/extcon-class.c
@@ -602,7 +602,8 @@ int extcon_dev_register(struct extcon_dev *edev, struct device *dev)
 	edev->dev->class = extcon_class;
 	edev->dev->release = extcon_dev_release;
 
-	dev_set_name(edev->dev, edev->name ? edev->name : dev_name(dev));
+	edev->name = edev->name ? edev->name : dev_name(dev);
+	dev_set_name(edev->dev, edev->name);
 
 	if (edev->max_supported) {
 		char buf[10];
diff --git a/drivers/extcon/of_extcon.c b/drivers/extcon/of_extcon.c
new file mode 100644
index 0000000..72173ec
--- /dev/null
+++ b/drivers/extcon/of_extcon.c
@@ -0,0 +1,64 @@
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
+#include <linux/err.h>
+#include <linux/extcon.h>
+#include <linux/of.h>
+#include <linux/of_platform.h>
+#include <linux/extcon/of_extcon.h>
+
+/*
+ * of_extcon_get_extcon_dev - Get the name of extcon device from devicetree
+ * @dev - instance to the given device
+ * @index - index into list of extcon_dev
+ *
+ * return the instance of extcon device
+ */
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
diff --git a/include/linux/extcon/of_extcon.h b/include/linux/extcon/of_extcon.h
new file mode 100644
index 0000000..462f071
--- /dev/null
+++ b/include/linux/extcon/of_extcon.h
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
+#if defined(CONFIG_OF) && defined(CONFIG_EXTCON)
+extern struct extcon_dev
+	*of_extcon_get_extcon_dev(struct device *dev, int index);
+#else
+static inline struct extcon_dev
+	*of_extcon_get_extcon_dev(struct device *dev, int index)
+{
+	return NULL;
+}
+#endif /* CONFIG_OF */
+
+#endif /* __LINUX_OF_EXTCON_H */
-- 
1.8.0

