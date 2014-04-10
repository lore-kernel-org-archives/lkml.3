Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161176AbaDJNS4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 09:18:56 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:47372 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161132AbaDJNSP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 09:18:15 -0400
X-AuditID: cbfee61b-b7f456d000006dfd-36-53469a16d809
From: Robert Baldyga <r.baldyga@samsung.com>
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org, rob@landley.net,
        myungjoo.ham@samsung.com, cw00.choi@samsung.com, dbaryshkov@gmail.com,
        dwmw2@infradead.org, balbi@ti.com, gregkh@linuxfoundation.org,
        grant.likely@linaro.org, ldewangan@nvidia.com, kishon@ti.com,
        gg@slimlogic.co.uk, anton@enomsg.org, jonghwa3.lee@samsung.com,
        rongjun.ying@csr.com, linux@roeck-us.net, aaro.koskinen@iki.fi,
        tony@atomide.com, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org, Robert Baldyga <r.baldyga@samsung.com>
Subject: [PATCH 04/13] extcon: extcon-class: match extcon device by devicetree
 node
Date: Thu, 10 Apr 2014 15:16:42 +0200
Message-id: <1397135811-12866-5-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1397135811-12866-1-git-send-email-r.baldyga@samsung.com>
References: <1397135811-12866-1-git-send-email-r.baldyga@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrEIsWRmVeSWpSXmKPExsVy+t9jAV2xWW7BBl+Oi1qseeFgcXCrpsXB
	+/UW1788Z7WY9OQ9s8X8I+dYLSaunMxs0f9mIatF/xYXiwN/djBaNC9ez2Zx7tVKRovOs0+Y
	LS487WGzWLpvNYvFwrYlLBaXd81hs5i9pJ/FYtGyVmaLJwvPMFksvX6RyeJ24wo2i+Vv/7NZ
	TJi+lsXiweGd7BbrXk5nsWjde4TdYt+FP6wW+694Och6rJm3htHj29dJLB6X+3qZPHbtnMPq
	MaH/E6PHzll32T1WLv/C5nH460IWj80rtDw2repk83i1eiarx51re9g89s9dw+7R2/yOzePl
	xN9sHju/N7AHiERx2aSk5mSWpRbp2yVwZaz/d4OpoM26Ys2f+0wNjH8Nuxg5OSQETCQuTt7L
	CGGLSVy4t56ti5GLQ0hgEaPEvGc32SGcdiaJR5d2MoNUsQnoSGz5PgGsQ0SAWWLB1POMIEXM
	AidZJVYd3A9WJCwQKtF9sgnMZhFQldj8q5MVxOYVcJU4vfIoUAMH0DoFiTmTbEBMTgE3ib2X
	lUFMIaCKqWuVJjDyLmBkWMUomlqQXFCclJ5rpFecmFtcmpeul5yfu4kRHJPPpHcwrmqwOMQo
	wMGoxMN7YJlrsBBrYllxZe4hRgkOZiUR3o1T3YKFeFMSK6tSi/Lji0pzUosPMUpzsCiJ8x5s
	tQ4UEkhPLEnNTk0tSC2CyTJxcEo1MHLeYl0onK72QamyO/2X6o8P1yxlciTqrlzhd1mxRMU1
	9GRSnM3CidbdU+svW3AxrLkn76B6pkk28XFgYcgf/+3Sqy8xac+T3/jOxV1rtaL6eoOG/7sq
	s01WtylfmahRMeVLal7vk60Zx64d2r8jUeHt5K0v1066E+e7Y2PRWwm2esdVkz0L65RYijMS
	DbWYi4oTAbbtOELFAgAA
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch modifies extcon_get_edev_by_phandle() function, to match
extcon device by devicetree node. This modification needed to add
field 'node' in extcon_dev structure, and fill it in probe function
of each extcon provider driver.

This patch replaces also extcon_get_extcon_dev() function with
of_extcon_get_extcon_dev(), returning extcon device which contains
given devicetree node.

Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
---
 drivers/extcon/extcon-adc-jack.c |    1 +
 drivers/extcon/extcon-arizona.c  |    1 +
 drivers/extcon/extcon-class.c    |   19 +++++++++----------
 drivers/extcon/extcon-gpio.c     |    1 +
 drivers/extcon/extcon-max14577.c |    2 ++
 drivers/extcon/extcon-max77693.c |    1 +
 drivers/extcon/extcon-max8997.c  |    1 +
 drivers/extcon/extcon-palmas.c   |    1 +
 include/linux/extcon.h           |    8 ++------
 9 files changed, 19 insertions(+), 16 deletions(-)

diff --git a/drivers/extcon/extcon-adc-jack.c b/drivers/extcon/extcon-adc-jack.c
index e23f1c2..d65915e 100644
--- a/drivers/extcon/extcon-adc-jack.c
+++ b/drivers/extcon/extcon-adc-jack.c
@@ -111,6 +111,7 @@ static int adc_jack_probe(struct platform_device *pdev)
 	}
 
 	data->edev.dev.parent = &pdev->dev;
+	data->edev.node = pdev->dev.of_node;
 	data->edev.supported_cable = pdata->cable_names;
 
 	/* Check the length of array and set num_cables */
diff --git a/drivers/extcon/extcon-arizona.c b/drivers/extcon/extcon-arizona.c
index 98a14f6..fc69cca 100644
--- a/drivers/extcon/extcon-arizona.c
+++ b/drivers/extcon/extcon-arizona.c
@@ -1153,6 +1153,7 @@ static int arizona_extcon_probe(struct platform_device *pdev)
 
 	info->edev.name = "Headset Jack";
 	info->edev.dev.parent = arizona->dev;
+	info->edev.node = pdev->dev.of_node;
 	info->edev.supported_cable = arizona_cable;
 
 	ret = extcon_dev_register(&info->edev);
diff --git a/drivers/extcon/extcon-class.c b/drivers/extcon/extcon-class.c
index 1b98c4e..1075ce8 100644
--- a/drivers/extcon/extcon-class.c
+++ b/drivers/extcon/extcon-class.c
@@ -358,24 +358,23 @@ int extcon_set_cable_state_(struct extcon_dev *edev,
 EXPORT_SYMBOL_GPL(extcon_set_cable_state_);
 
 /**
- * extcon_get_extcon_dev() - Get the extcon device instance from the name
- * @extcon_name:	The extcon name provided with extcon_dev_register()
+ * of_extcon_get_extcon_dev() - Get the extcon device instance from the name
+ * @np: The node of extcon device
  */
-struct extcon_dev *extcon_get_extcon_dev(const char *extcon_name)
+struct extcon_dev *of_extcon_get_extcon_dev(const struct device_node *np)
 {
-	struct extcon_dev *sd;
+	struct extcon_dev *edev;
 
 	mutex_lock(&extcon_dev_list_lock);
-	list_for_each_entry(sd, &extcon_dev_list, entry) {
-		if (!strcmp(sd->name, extcon_name))
+	list_for_each_entry(edev, &extcon_dev_list, entry) {
+		if (edev->node == np)
 			goto out;
 	}
-	sd = NULL;
+	edev = NULL;
 out:
 	mutex_unlock(&extcon_dev_list_lock);
-	return sd;
+	return edev;
 }
-EXPORT_SYMBOL_GPL(extcon_get_extcon_dev);
 
 static int _call_per_cable(struct notifier_block *nb, unsigned long val,
 			   void *ptr)
@@ -827,7 +826,7 @@ struct extcon_dev *extcon_get_edev_by_phandle(struct device *dev, int index)
 		return ERR_PTR(-ENODEV);
 	}
 
-	edev = extcon_get_extcon_dev(node->name);
+	edev = of_extcon_get_extcon_dev(node);
 	if (!edev) {
 		dev_err(dev, "unable to get extcon device : %s\n", node->name);
 		return ERR_PTR(-ENODEV);
diff --git a/drivers/extcon/extcon-gpio.c b/drivers/extcon/extcon-gpio.c
index 13d5222..fc90b7a 100644
--- a/drivers/extcon/extcon-gpio.c
+++ b/drivers/extcon/extcon-gpio.c
@@ -100,6 +100,7 @@ static int gpio_extcon_probe(struct platform_device *pdev)
 
 	extcon_data->edev.name = pdata->name;
 	extcon_data->edev.dev.parent = &pdev->dev;
+	extcon_data->edev.node = pdev->dev.of_node;
 	extcon_data->gpio = pdata->gpio;
 	extcon_data->gpio_active_low = pdata->gpio_active_low;
 	extcon_data->state_on = pdata->state_on;
diff --git a/drivers/extcon/extcon-max14577.c b/drivers/extcon/extcon-max14577.c
index 7a947d3..b017a0d 100644
--- a/drivers/extcon/extcon-max14577.c
+++ b/drivers/extcon/extcon-max14577.c
@@ -676,6 +676,8 @@ static int max14577_muic_probe(struct platform_device *pdev)
 		return -ENOMEM;
 	}
 	info->edev->name = DEV_NAME;
+	info->edev->dev.parent = &pdev->dev;
+	info->edev->node = pdev->dev.of_node;
 	info->edev->supported_cable = max14577_extcon_cable;
 	ret = extcon_dev_register(info->edev);
 	if (ret) {
diff --git a/drivers/extcon/extcon-max77693.c b/drivers/extcon/extcon-max77693.c
index 7a014cd..2cd8892 100644
--- a/drivers/extcon/extcon-max77693.c
+++ b/drivers/extcon/extcon-max77693.c
@@ -1200,6 +1200,7 @@ static int max77693_muic_probe(struct platform_device *pdev)
 	}
 	info->edev->name = DEV_NAME;
 	info->edev->dev.parent = &pdev->dev;
+	info->edev->node = pdev->dev.of_node;
 	info->edev->supported_cable = max77693_extcon_cable;
 	ret = extcon_dev_register(info->edev);
 	if (ret) {
diff --git a/drivers/extcon/extcon-max8997.c b/drivers/extcon/extcon-max8997.c
index a3df70d..c071588 100644
--- a/drivers/extcon/extcon-max8997.c
+++ b/drivers/extcon/extcon-max8997.c
@@ -718,6 +718,7 @@ static int max8997_muic_probe(struct platform_device *pdev)
 	}
 	info->edev->name = DEV_NAME;
 	info->edev->dev.parent = &pdev->dev;
+	info->edev->node = pdev->dev.of_node;
 	info->edev->supported_cable = max8997_extcon_cable;
 	ret = extcon_dev_register(info->edev);
 	if (ret) {
diff --git a/drivers/extcon/extcon-palmas.c b/drivers/extcon/extcon-palmas.c
index 26c0619..153a40e 100644
--- a/drivers/extcon/extcon-palmas.c
+++ b/drivers/extcon/extcon-palmas.c
@@ -199,6 +199,7 @@ static int palmas_usb_probe(struct platform_device *pdev)
 
 	palmas_usb->edev.supported_cable = palmas_extcon_cable;
 	palmas_usb->edev.dev.parent = palmas_usb->dev;
+	palmas_usb->edev.node = pdev->dev.of_node;
 	palmas_usb->edev.mutually_exclusive = mutually_exclusive;
 
 	status = extcon_dev_register(&palmas_usb->edev);
diff --git a/include/linux/extcon.h b/include/linux/extcon.h
index ed4a47b..d0fd810 100644
--- a/include/linux/extcon.h
+++ b/include/linux/extcon.h
@@ -77,6 +77,7 @@ struct extcon_cable;
 /**
  * struct extcon_dev - An extcon device represents one external connector.
  * @name:		The name of this extcon device. Parent device name is
+ * @node:		Devicetree node of parent device.
  *			used if NULL.
  * @supported_cable:	Array of supported cable names ending with NULL.
  *			If supported_cable is NULL, cable name related APIs
@@ -113,6 +114,7 @@ struct extcon_cable;
 struct extcon_dev {
 	/* Optional user initializing data */
 	const char *name;
+	const struct device_node *node;
 	const char **supported_cable;
 	const u32 *mutually_exclusive;
 
@@ -185,7 +187,6 @@ struct extcon_specific_cable_nb {
  */
 extern int extcon_dev_register(struct extcon_dev *edev);
 extern void extcon_dev_unregister(struct extcon_dev *edev);
-extern struct extcon_dev *extcon_get_extcon_dev(const char *extcon_name);
 
 /*
  * get/set/update_state access the 32b encoded state value, which represents
@@ -292,11 +293,6 @@ static inline int extcon_set_cable_state(struct extcon_dev *edev,
 	return 0;
 }
 
-static inline struct extcon_dev *extcon_get_extcon_dev(const char *extcon_name)
-{
-	return NULL;
-}
-
 static inline int extcon_register_notifier(struct extcon_dev *edev,
 					   struct notifier_block *nb)
 {
-- 
1.7.9.5

