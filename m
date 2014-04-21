Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751907AbaDUMCY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 08:02:24 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:26536 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751188AbaDUMCT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 08:02:19 -0400
X-AuditID: cbfee68d-b7f4e6d000004845-02-535508c9a85b
From: Chanwoo Choi <cw00.choi@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: myungjoo.ham@samsung.com, balbi@ti.com, gg@slimlogic.co.uk, kishon@ti.com,
        ckeepax@opensource.wolfsonmicro.com, broonie@kernel.org,
        k.kozlowski@samsung.com, kyungmin.park@samsung.com,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCHv2 1/9] extcon: Add extcon_dev_allocate/free() to control the
 memory of extcon device
Date: Mon, 21 Apr 2014 21:02:14 +0900
Message-id: <1398081742-24277-2-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1398081742-24277-1-git-send-email-cw00.choi@samsung.com>
References: <1398081742-24277-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupgkeLIzCtJLcpLzFFi42JZI2JSrHuSIzTYYP0fWYuD9+stpj58wmbx
	b8oNdovrX56zWvRvcbF4/cLQ4sLTHjaLs01v2C0u75rDZnG7cQWbA5fHplWdbB4vJ/5m8+jb
	sorRY+qUv4wex29sZ/L4vEkugC2KyyYlNSezLLVI3y6BK+NQ0wy2gmcpFTd7pjE2MD4P6mLk
	5JAQMJGY+uMeC4QtJnHh3nq2LkYuDiGBpYwSjbvOssIUTW7YxQqRWMQose3hJKiqJiaJ838W
	MoJUsQloSex/cYMNxBYRUJDY3PsMrINZ4BmjxImrJ5hBEsICaRLbp7SDjWURUJXo39QKFucV
	cJX4s+g1O8Q6OYkPex4B2RwcnAJuEhdOlIOEhYBKHv3ezAgyU0JgG7tE2/Up7BBzBCS+TT7E
	AlIvISArsekAM8QYSYmDK26wTGAUXsDIsIpRNLUguaA4Kb3IUK84Mbe4NC9dLzk/dxMjMBZO
	/3vWu4Px9gHrQ4zJQOMmMkuJJucDYymvJN7Q2MzIwtTE1NjI3NKMNGElcd6kh0lBQgLpiSWp
	2ampBalF8UWlOanFhxiZODilGhhPfDjL8zvY8m7ffKVMm2rTWR/F9D3bfb0erjmwy0igXGDv
	91BBmXXFsqGL9yzac7nZqSuTddVyM9Fls+Yce3PzycI7x36+X3Ja92UhS4nLFjP2x2nWKX+Y
	vzExHtK3vFVhVOt1WMvJziZ23rlXc488L5ykfczY83puV9j9ussJ7Y/LvljccW1QYinOSDTU
	Yi4qTgQAsEgr5ZsCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKIsWRmVeSWpSXmKPExsVy+t9jAd2THKHBBi+uCFocvF9vMfXhEzaL
	f1NusFtc//Kc1aJ/i4vF6xeGFhee9rBZnG16w25xedccNovbjSvYHLg8Nq3qZPN4OfE3m0ff
	llWMHlOn/GX0OH5jO5PH501yAWxRDYw2GamJKalFCql5yfkpmXnptkrewfHO8aZmBoa6hpYW
	5koKeYm5qbZKLj4Bum6ZOUCHKSmUJeaUAoUCEouLlfTtME0IDXHTtYBpjND1DQmC6zEyQAMJ
	axgzDjXNYCt4llJxs2caYwPj86AuRk4OCQETickNu1ghbDGJC/fWs3UxcnEICSxilNj2cBKU
	08Qkcf7PQkaQKjYBLYn9L26wgdgiAgoSm3ufsYIUMQs8Y5Q4cfUEM0hCWCBNYvuUdrCxLAKq
	Ev2bWsHivAKuEn8WvWaHWCcn8WHPIyCbg4NTwE3iwolykLAQUMmj35sZJzDyLmBkWMUomlqQ
	XFCclJ5rpFecmFtcmpeul5yfu4kRHGnPpHcwrmqwOMQowMGoxMP7Ij8kWIg1say4MvcQowQH
	s5IIb8R6oBBvSmJlVWpRfnxRaU5q8SHGZKCjJjJLiSbnA5NAXkm8obGJmZGlkbmhhZGxOWnC
	SuK8B1utA4UE0hNLUrNTUwtSi2C2MHFwSjUwrrvy7Wr3sZXdae5cauE2RgHhn56Xr1GXDr9U
	xnOm8unZDP51L+ou7vjiu392a3ClzBm5uf8ZT28U0bOInbjx3+XwpRJCmdHbFP2Un9iFb16z
	fsYrv6f98r2CR09tsVMT4H4xRZJR89n99ZkHl0zi2naVj6Pd8f7e2S/2HOn5dbhAU/TJo6nS
	c5VYijMSDbWYi4oTARx5Zkn4AgAA
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
index f6df689..3e485bc 100644
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
 
 static void devm_extcon_dev_unreg(struct device *dev, void *res)
 {
diff --git a/include/linux/extcon.h b/include/linux/extcon.h
index 85a8a5b..20587ee 100644
--- a/include/linux/extcon.h
+++ b/include/linux/extcon.h
@@ -179,6 +179,8 @@ struct extcon_specific_cable_nb {
 
 #if IS_ENABLED(CONFIG_EXTCON)
 
+#define dev_to_extcon_dev(d) container_of(d, struct extcon_dev, dev)
+
 /*
  * Following APIs are for notifiers or configurations.
  * Notifiers are the external port and connection devices.
@@ -250,6 +252,12 @@ extern int extcon_unregister_notifier(struct extcon_dev *edev,
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
@@ -353,5 +361,12 @@ static inline struct extcon_dev *extcon_get_edev_by_phandle(struct device *dev,
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

