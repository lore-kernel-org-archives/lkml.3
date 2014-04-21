Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751767AbaDUJhN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 05:37:13 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:60998 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751285AbaDUJg1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 05:36:27 -0400
X-AuditID: cbfee68e-b7fd86d0000038e3-e1-5354e696c44f
From: Chanwoo Choi <cw00.choi@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: myungjoo.ham@samsung.com, gg@slimlogic.co.uk, kishon@ti.com, balbi@ti.com,
        ckeepax@opensource.wolfsonmicro.com, broonie@kernel.org,
        k.kozlowski@samsung.com, kyungmin.park@samsung.com,
        sangjung.woo@samsung.com, Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCH 1/9] extcon: Add extcon_dev_allocate/free() to control the
 memory of extcon device
Date: Mon, 21 Apr 2014 18:36:18 +0900
Message-id: <1398072986-17386-2-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1398072986-17386-1-git-send-email-cw00.choi@samsung.com>
References: <1398072986-17386-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuplkeLIzCtJLcpLzFFi42JZI2JSqDvtWUiwweOV2hYH79dbTH34hM3i
	35Qb7BbXvzxntejf4mLx+oWhxYWnPWwWZ5vesFtc3jWHzeJ24wo2iwV7Shy4PTat6mTzeDnx
	N5tH35ZVjB5Tp/xl9Dh+YzuTx+dNcgFsUVw2Kak5mWWpRfp2CVwZrw/PYCrYnlJxvPcMUwPj
	3qAuRk4OCQETibd32xkhbDGJC/fWs3UxcnEICSxllDi1p5ENpuhr9zkmiMQiRonXZ9ZBOU1M
	Ehc6FzOBVLEJaEnsf3EDrENEQEFic+8zVpAiZoEGJok5nxaAFQkLpEjMv/WCFcRmEVCVmPLs
	CZjNK+Aq0dxykh1inZzEhz2PwGxOATeJdT+6wWqEgGo63vcxggyVENjFLvH+9no2iEECEt8m
	H2LpYuQASshKbDrADDFHUuLgihssExiFFzAyrGIUTS1ILihOSi8y0itOzC0uzUvXS87P3cQI
	jIrT/5717WC8ecD6EGMy0LiJzFKiyfnAqMoriTc0NjOyMDUxNTYytzQjTVhJnHfRw6QgIYH0
	xJLU7NTUgtSi+KLSnNTiQ4xMHJxSDYwztu0yfuDVem2LV/efqP0f3jascO/mMpW7fXbeHcV5
	Ag2hcQ2OIQsFJ4eGXDO6pBok3CvIZhZ95/o9+zXhR7Rk2yp5mV9ucTlglVmXlGqWptPH8CpB
	Xf7LPamuFTaTfnw51r96xXOpownXRdS0GfjOFNruvansOo9VkoMrkqumsnb140PGF5RYijMS
	DbWYi4oTAfUAiC6gAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrFIsWRmVeSWpSXmKPExsVy+t9jAd1pz0KCDQ79l7c4eL/eYurDJ2wW
	/6bcYLe4/uU5q0X/FheL1y8MLS487WGzONv0ht3i8q45bBa3G1ewWSzYU+LA7bFpVSebx8uJ
	v9k8+rasYvSYOuUvo8fxG9uZPD5vkgtgi2pgtMlITUxJLVJIzUvOT8nMS7dV8g6Od443NTMw
	1DW0tDBXUshLzE21VXLxCdB1y8wBOk5JoSwxpxQoFJBYXKykb4dpQmiIm64FTGOErm9IEFyP
	kQEaSFjDmPH68Aymgu0pFcd7zzA1MO4N6mLk5JAQMJH42n2OCcIWk7hwbz1bFyMXh5DAIkaJ
	12fWMUE4TUwSFzoXg1WxCWhJ7H9xgw3EFhFQkNjc+4wVpIhZoIFJYs6nBWBFwgIpEvNvvWAF
	sVkEVCWmPHsCZvMKuEo0t5xkh1gnJ/FhzyMwm1PATWLdj26wGiGgmo73fYwTGHkXMDKsYhRN
	LUguKE5KzzXSK07MLS7NS9dLzs/dxAiOuWfSOxhXNVgcYhTgYFTi4X2RHxIsxJpYVlyZe4hR
	goNZSYQ3Yj1QiDclsbIqtSg/vqg0J7X4EGMy0FUTmaVEk/OB6SCvJN7Q2MTMyNLI3NDCyNic
	NGElcd6DrdaBQgLpiSWp2ampBalFMFuYODilGhgX6R/VnyTpKOWmZ/9/RUKx5Ha2NMvXrqbP
	Z+XNPFxy71/3rovlt2Nj2Hd/zJ1x/rfE6sPvS5mMghkPaH/ZZMb76uTbHTeUFB74/rqhxPRA
	8MnsGQ2+62LXVYUKhyzr1Xx0i7/v0v2qE7sVlujWcthdf+Tw3p5VPT55vvsejQX+l45FCLj+
	cm5WYinOSDTUYi4qTgQA6sbc2f0CAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add APIs to control the extcon device on extcon provider driver.
The extcon_dev_allocate() allocates the memory of extcon device and initializes
supported cables. And then extcon_dev_free() decrement the reference of the
device of extcon device and free the memory of the extcon device. This APIs
must need to implement devm_extcon_dev_allocate()/free() APIs.

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
---
 drivers/extcon/extcon-class.c | 295 +++++++++++++++++++++++-------------------
 include/linux/extcon.h        |  15 +++
 2 files changed, 177 insertions(+), 133 deletions(-)

diff --git a/drivers/extcon/extcon-class.c b/drivers/extcon/extcon-class.c
index 7ab21aa..600043c 100644
--- a/drivers/extcon/extcon-class.c
+++ b/drivers/extcon/extcon-class.c
@@ -558,6 +558,9 @@ static int create_extcon_class(void)
 
 static void extcon_dev_release(struct device *dev)
 {
+	struct extcon_dev *edev = dev_to_extcon_dev(dev);
+
+	kfree(edev);
 }
 
 static const char *muex_name = "mutually_exclusive";
@@ -576,7 +579,7 @@ static void dummy_sysfs_dev_release(struct device *dev)
  */
 int extcon_dev_register(struct extcon_dev *edev)
 {
-	int ret, index = 0;
+	int ret;
 
 	if (!extcon_class) {
 		ret = create_extcon_class();
@@ -584,80 +587,150 @@ int extcon_dev_register(struct extcon_dev *edev)
 			return ret;
 	}
 
-	if (edev->supported_cable) {
-		/* Get size of array */
-		for (index = 0; edev->supported_cable[index]; index++)
-			;
-		edev->max_supported = index;
-	} else {
-		edev->max_supported = 0;
+	edev->name = edev->name ? edev->name : dev_name(edev->dev.parent);
+	if (IS_ERR_OR_NULL(edev->name)) {
+		dev_err(&edev->dev, "extcon device name is null\n");
+		return -EINVAL;
 	}
+	dev_set_name(&edev->dev, "%s", edev->name);
 
-	if (index > SUPPORTED_CABLE_MAX) {
-		dev_err(&edev->dev, "extcon: maximum number of supported cables exceeded.\n");
-		return -EINVAL;
+	ret = device_add(&edev->dev);
+	if (ret) {
+		put_device(&edev->dev);
+		return ret;
 	}
+#if defined(CONFIG_ANDROID)
+	if (switch_class)
+		ret = class_compat_create_link(switch_class, &edev->dev, NULL);
+#endif /* CONFIG_ANDROID */
 
-	edev->dev.class = extcon_class;
-	edev->dev.release = extcon_dev_release;
+	RAW_INIT_NOTIFIER_HEAD(&edev->nh);
 
-	edev->name = edev->name ? edev->name : dev_name(edev->dev.parent);
-	if (IS_ERR_OR_NULL(edev->name)) {
-		dev_err(&edev->dev,
-			"extcon device name is null\n");
-		return -EINVAL;
+	dev_set_drvdata(&edev->dev, edev);
+	edev->state = 0;
+
+	mutex_lock(&extcon_dev_list_lock);
+	list_add(&edev->entry, &extcon_dev_list);
+	mutex_unlock(&extcon_dev_list_lock);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(extcon_dev_register);
+
+/**
+ * extcon_dev_unregister() - Unregister the extcon device.
+ * @edev:	the extcon device instance to be unregistered.
+ */
+void extcon_dev_unregister(struct extcon_dev *edev)
+{
+	mutex_lock(&extcon_dev_list_lock);
+	list_del(&edev->entry);
+	mutex_unlock(&extcon_dev_list_lock);
+
+	if (IS_ERR_OR_NULL(get_device(&edev->dev))) {
+		dev_err(&edev->dev, "Failed to unregister extcon_dev (%s)\n",
+				dev_name(&edev->dev));
+		return;
 	}
-	dev_set_name(&edev->dev, "%s", edev->name);
 
-	if (edev->max_supported) {
-		char buf[10];
-		char *str;
-		struct extcon_cable *cable;
+	device_unregister(&edev->dev);
 
-		edev->cables = kzalloc(sizeof(struct extcon_cable) *
-				       edev->max_supported, GFP_KERNEL);
-		if (!edev->cables) {
+#if defined(CONFIG_ANDROID)
+	if (switch_class)
+		class_compat_remove_link(switch_class, &edev->dev, NULL);
+#endif
+}
+EXPORT_SYMBOL_GPL(extcon_dev_unregister);
+
+/*
+ * extcon_dev_allocate() - Allocate the memory of extcon device.
+ * @supported_cable:	Array of supported cable names ending with NULL.
+ *			If supported_cable is NULL, cable name related APIs
+ *			are disabled.
+ *
+ * This function allocates the memory for extcon device without allocating
+ * memory in each extcon provider driver and initialize default setting for
+ * extcon device.
+ *
+ * Return the pointer of extcon device if success or ERR_PTR(err) if fail
+ */
+struct extcon_dev *extcon_dev_allocate(const char **supported_cable)
+{
+	struct extcon_dev *edev;
+	int index, ret, count = 0;
+
+	edev = kzalloc(sizeof(*edev), GFP_KERNEL);
+	if (!edev) {
+		pr_err("Failed to allocate the memory for extcon device\n");
+		return ERR_PTR(-ENOMEM);
+	}
+
+	edev->max_supported = 0;
+	edev->supported_cable = supported_cable;
+	if (edev->supported_cable) {
+		for (count = 0; edev->supported_cable[count]; count++)
+			;
+		edev->max_supported = count;
+		if (count > SUPPORTED_CABLE_MAX) {
+			pr_err("Exceed max number of supported cables\n");
 			ret = -ENOMEM;
-			goto err_sysfs_alloc;
+			goto err;
 		}
-		for (index = 0; index < edev->max_supported; index++) {
-			cable = &edev->cables[index];
+	}
 
-			snprintf(buf, 10, "cable.%d", index);
-			str = kzalloc(sizeof(char) * (strlen(buf) + 1),
-				      GFP_KERNEL);
-			if (!str) {
-				for (index--; index >= 0; index--) {
-					cable = &edev->cables[index];
-					kfree(cable->attr_g.name);
-				}
-				ret = -ENOMEM;
+	edev->dev.class = extcon_class;
+	edev->dev.release = extcon_dev_release;
+	device_initialize(&edev->dev);
+	spin_lock_init(&edev->lock);
+
+	if (!edev->max_supported)
+		return 0;
+
+	edev->cables = kzalloc(sizeof(struct extcon_cable) *
+			       edev->max_supported, GFP_KERNEL);
+	if (!edev->cables) {
+		ret = -ENOMEM;
+		goto err;
+	}
 
-				goto err_alloc_cables;
+	for (index = 0; index < edev->max_supported; index++) {
+		struct extcon_cable *cable = &edev->cables[index];
+		char buf[10];
+		char *str;
+
+		snprintf(buf, 10, "cable.%d", index);
+		str = kzalloc(sizeof(char) * (strlen(buf) + 1),
+			      GFP_KERNEL);
+		if (!str) {
+			for (index--; index >= 0; index--) {
+				cable = &edev->cables[index];
+				kfree(cable->attr_g.name);
 			}
-			strcpy(str, buf);
-
-			cable->edev = edev;
-			cable->cable_index = index;
-			cable->attrs[0] = &cable->attr_name.attr;
-			cable->attrs[1] = &cable->attr_state.attr;
-			cable->attrs[2] = NULL;
-			cable->attr_g.name = str;
-			cable->attr_g.attrs = cable->attrs;
-
-			sysfs_attr_init(&cable->attr_name.attr);
-			cable->attr_name.attr.name = "name";
-			cable->attr_name.attr.mode = 0444;
-			cable->attr_name.show = cable_name_show;
-
-			sysfs_attr_init(&cable->attr_state.attr);
-			cable->attr_state.attr.name = "state";
-			cable->attr_state.attr.mode = 0444;
-			cable->attr_state.show = cable_state_show;
+			ret = -ENOMEM;
+			goto err_alloc_cables;
 		}
+		strcpy(str, buf);
+
+		cable->edev = edev;
+		cable->cable_index = index;
+		cable->attrs[0] = &cable->attr_name.attr;
+		cable->attrs[1] = &cable->attr_state.attr;
+		cable->attrs[2] = NULL;
+		cable->attr_g.name = str;
+		cable->attr_g.attrs = cable->attrs;
+
+		sysfs_attr_init(&cable->attr_name.attr);
+		cable->attr_name.attr.name = "name";
+		cable->attr_name.attr.mode = 0444;
+		cable->attr_name.show = cable_name_show;
+
+		sysfs_attr_init(&cable->attr_state.attr);
+		cable->attr_state.attr.name = "state";
+		cable->attr_state.attr.mode = 0444;
+		cable->attr_state.show = cable_state_show;
 	}
 
-	if (edev->max_supported && edev->mutually_exclusive) {
+	if (edev->mutually_exclusive) {
 		char buf[80];
 		char *name;
 
@@ -703,59 +776,32 @@ int extcon_dev_register(struct extcon_dev *edev)
 		}
 		edev->attr_g_muex.name = muex_name;
 		edev->attr_g_muex.attrs = edev->attrs_muex;
-
 	}
 
-	if (edev->max_supported) {
-		edev->extcon_dev_type.groups =
-			kzalloc(sizeof(struct attribute_group *) *
-				(edev->max_supported + 2), GFP_KERNEL);
-		if (!edev->extcon_dev_type.groups) {
-			ret = -ENOMEM;
-			goto err_alloc_groups;
-		}
-
-		edev->extcon_dev_type.name = dev_name(&edev->dev);
-		edev->extcon_dev_type.release = dummy_sysfs_dev_release;
-
-		for (index = 0; index < edev->max_supported; index++)
-			edev->extcon_dev_type.groups[index] =
-				&edev->cables[index].attr_g;
-		if (edev->mutually_exclusive)
-			edev->extcon_dev_type.groups[index] =
-				&edev->attr_g_muex;
-
-		edev->dev.type = &edev->extcon_dev_type;
+	edev->extcon_dev_type.groups =
+		kzalloc(sizeof(struct attribute_group *) *
+			(edev->max_supported + 2), GFP_KERNEL);
+	if (!edev->extcon_dev_type.groups) {
+		ret = -ENOMEM;
+		goto err_alloc_groups;
 	}
 
-	ret = device_register(&edev->dev);
-	if (ret) {
-		put_device(&edev->dev);
-		goto err_dev;
-	}
-#if defined(CONFIG_ANDROID)
-	if (switch_class)
-		ret = class_compat_create_link(switch_class, &edev->dev, NULL);
-#endif /* CONFIG_ANDROID */
-
-	spin_lock_init(&edev->lock);
-
-	RAW_INIT_NOTIFIER_HEAD(&edev->nh);
+	edev->extcon_dev_type.name = dev_name(&edev->dev);
+	edev->extcon_dev_type.release = dummy_sysfs_dev_release;
 
-	dev_set_drvdata(&edev->dev, edev);
-	edev->state = 0;
+	for (index = 0; index < edev->max_supported; index++)
+		edev->extcon_dev_type.groups[index] =
+			&edev->cables[index].attr_g;
+	if (edev->mutually_exclusive)
+		edev->extcon_dev_type.groups[index] =
+			&edev->attr_g_muex;
 
-	mutex_lock(&extcon_dev_list_lock);
-	list_add(&edev->entry, &extcon_dev_list);
-	mutex_unlock(&extcon_dev_list_lock);
+	edev->dev.type = &edev->extcon_dev_type;
 
-	return 0;
+	return edev;
 
-err_dev:
-	if (edev->max_supported)
-		kfree(edev->extcon_dev_type.groups);
 err_alloc_groups:
-	if (edev->max_supported && edev->mutually_exclusive) {
+	if (edev->mutually_exclusive) {
 		for (index = 0; edev->mutually_exclusive[index]; index++)
 			kfree(edev->d_attrs_muex[index].attr.name);
 		kfree(edev->d_attrs_muex);
@@ -765,36 +811,22 @@ err_muex:
 	for (index = 0; index < edev->max_supported; index++)
 		kfree(edev->cables[index].attr_g.name);
 err_alloc_cables:
-	if (edev->max_supported)
-		kfree(edev->cables);
-err_sysfs_alloc:
-	return ret;
+	kfree(edev->cables);
+err:
+	kfree(edev);
+
+	return ERR_PTR(ret);
 }
-EXPORT_SYMBOL_GPL(extcon_dev_register);
+EXPORT_SYMBOL_GPL(extcon_dev_allocate);
 
-/**
- * extcon_dev_unregister() - Unregister the extcon device.
- * @edev:	the extcon device instance to be unregistered.
- *
- * Note that this does not call kfree(edev) because edev was not allocated
- * by this class.
+/*
+ * extcon_dev_free() - Free the memory of extcon device.
+ * @edev:	the extcon device to free
  */
-void extcon_dev_unregister(struct extcon_dev *edev)
+void extcon_dev_free(struct extcon_dev *edev)
 {
 	int index;
 
-	mutex_lock(&extcon_dev_list_lock);
-	list_del(&edev->entry);
-	mutex_unlock(&extcon_dev_list_lock);
-
-	if (IS_ERR_OR_NULL(get_device(&edev->dev))) {
-		dev_err(&edev->dev, "Failed to unregister extcon_dev (%s)\n",
-				dev_name(&edev->dev));
-		return;
-	}
-
-	device_unregister(&edev->dev);
-
 	if (edev->mutually_exclusive && edev->max_supported) {
 		for (index = 0; edev->mutually_exclusive[index];
 				index++)
@@ -811,13 +843,10 @@ void extcon_dev_unregister(struct extcon_dev *edev)
 		kfree(edev->cables);
 	}
 
-#if defined(CONFIG_ANDROID)
-	if (switch_class)
-		class_compat_remove_link(switch_class, &edev->dev, NULL);
-#endif
-	put_device(&edev->dev);
+	if (edev)
+		put_device(&edev->dev);
 }
-EXPORT_SYMBOL_GPL(extcon_dev_unregister);
+EXPORT_SYMBOL_GPL(extcon_dev_free);
 
 #ifdef CONFIG_OF
 /*
diff --git a/include/linux/extcon.h b/include/linux/extcon.h
index f488145..ffb3a03 100644
--- a/include/linux/extcon.h
+++ b/include/linux/extcon.h
@@ -179,6 +179,8 @@ struct extcon_specific_cable_nb {
 
 #if IS_ENABLED(CONFIG_EXTCON)
 
+#define dev_to_extcon_dev(d) container_of(d, struct extcon_dev, dev)
+
 /*
  * Following APIs are for notifiers or configurations.
  * Notifiers are the external port and connection devices.
@@ -242,6 +244,12 @@ extern int extcon_unregister_notifier(struct extcon_dev *edev,
 				      struct notifier_block *nb);
 
 /*
+ * Following APIs control the memory of extcon device.
+ */
+extern struct extcon_dev *extcon_dev_allocate(const char **cables);
+extern void extcon_dev_free(struct extcon_dev *edev);
+
+/*
  * Following API get the extcon device from devicetree.
  * This function use phandle of devicetree to get extcon device directly.
  */
@@ -336,5 +344,12 @@ static inline struct extcon_dev *extcon_get_edev_by_phandle(struct device *dev,
 {
 	return ERR_PTR(-ENODEV);
 }
+
+static inline struct extcon_dev *extcon_dev_allocate(const char **cables)
+{
+	return ERR_PTR(-ENOMEM);
+}
+
+static inline void extcon_dev_free(struct extcon_dev *edev) { }
 #endif /* CONFIG_EXTCON */
 #endif /* __LINUX_EXTCON_H__ */
-- 
1.8.0

