Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757873Ab3IBAUl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Sep 2013 20:20:41 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:57809 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757392Ab3IBAUY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Sep 2013 20:20:24 -0400
X-AuditID: cbfee68f-b7f656d0000058e3-7b-5223d9c7b4c4
From: Chanwoo Choi <cw00.choi@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org, myungjoo.ham@samsung.com,
        kyungmin.park@samsung.com, Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCH 2/3] extcon: Change field type of 'dev' in extcon_dev structure
Date: Mon, 02 Sep 2013 09:20:07 +0900
Message-id: <1378081208-20274-3-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1378081208-20274-1-git-send-email-cw00.choi@samsung.com>
References: <1378081208-20274-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrLLMWRmVeSWpSXmKPExsWyRsSkUPf4TeUgg7k3OSyuf3nOatG8eD2b
	xdmmN+wWl3fNYbO43biCzYHVY//cNewefVtWMXp83iQXwBzFZZOSmpNZllqkb5fAlbHp5kq2
	gudmFXf2fWNsYHyh08XIySEhYCKx8n0DM4QtJnHh3no2EFtIYCmjxPlLal2MHGA1+96wQISn
	M0ps3J3YxcgFZDcySZz73ApWzyagJbH/xQ0wW0RAQWJz7zNWEJtZoFri3KnLYHFhAX+Jb1M/
	MYHMZBFQlfh53xbE5BVwlVi3OgXiAjmJD3sesYPYnAJuElNnHWCEWOsqMaN/N9SVv9kk1u2z
	BbFZBAQkvk0+xAJxpazEpgNQJZISB1fcYJnAKLyAkWEVo2hqQXJBcVJ6kbFecWJucWleul5y
	fu4mRmDQnv73rH8H490D1ocYk4HGTWSWEk3OBwZ9Xkm8obGZkYWpiamxkbmlGWnCSuK8ai3W
	gUIC6YklqdmpqQWpRfFFpTmpxYcYmTg4pRoYF/oc4p08/7x9+fPHx4JVD546LfjjU3q1okDy
	ZHf7nIQL37On781vnM2yes4hJ4XjP3WWn11xu4F3mjZ3NkvCcobOxDbNh/pC0ieXbnqa9Md1
	TuLx4M/v4s9vmfJow+m//1982ff0RFD2zUUiX5XqeYOm1y3b1FFtsnau+sF4c6UXBWzzruT6
	/FJiKc5INNRiLipOBADMY9lBcAIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrNIsWRmVeSWpSXmKPExsVy+t9jQd3jN5WDDDq8La5/ec5q0bx4PZvF
	2aY37BaXd81hs7jduILNgdVj/9w17B59W1YxenzeJBfAHNXAaJORmpiSWqSQmpecn5KZl26r
	5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6DrlpkDtFJJoSwxpxQoFJBYXKykb4dpQmiIm64F
	TGOErm9IEFyPkQEaSFjDmLHp5kq2gudmFXf2fWNsYHyh08XIwSEhYCKx7w1LFyMnkCkmceHe
	ejYQW0hgOqPExt2JXYxcQHYjk8S5z61gCTYBLYn9L26A2SICChKbe5+xgtjMAtUS505dBosL
	C/hLfJv6iQlkPouAqsTP+7YgJq+Aq8S61SkQq+QkPux5xA5icwq4SUyddYARYq2rxIz+3cwT
	GHkXMDKsYhRNLUguKE5KzzXUK07MLS7NS9dLzs/dxAiOimdSOxhXNlgcYhTgYFTi4a1YoRwk
	xJpYVlyZe4hRgoNZSYSXoUkpSIg3JbGyKrUoP76oNCe1+BBjMtBNE5mlRJPzgRGbVxJvaGxi
	ZmRpZG5oYWRsTpqwkjjvgVbrQCGB9MSS1OzU1ILUIpgtTBycUg2MTgoVe0OnzZ73va5roedN
	84y1K35HHp4fqNQ5dc7xdxeU5L9wZeb+ZDBamvhJ7Nv22DLL0xkCd/6F7fNZMftimNHVxy8f
	XWq76pMkWKhqfojv+fSW3JUGEhHTd7qJ6YRb8X14nFog7FzeuyTZeuWLZRG3VvVs/X5l+vRd
	Swsvh/XsPGylxzC5RImlOCPRUIu5qDgRAG9U6ZDOAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The extcon device must always need 'struct device' so this patch change
field type of 'dev' instead of allocating memory for 'struct device' on
extcon_dev_register() function.

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Myungjoo Ham <cw00.choi@samsung.com>
---
 drivers/extcon/extcon-adc-jack.c |  2 +-
 drivers/extcon/extcon-class.c    | 52 +++++++++++++++++++---------------------
 include/linux/extcon.h           |  4 ++--
 3 files changed, 27 insertions(+), 31 deletions(-)

diff --git a/drivers/extcon/extcon-adc-jack.c b/drivers/extcon/extcon-adc-jack.c
index 5d16428..90346d6 100644
--- a/drivers/extcon/extcon-adc-jack.c
+++ b/drivers/extcon/extcon-adc-jack.c
@@ -64,7 +64,7 @@ static void adc_jack_handler(struct work_struct *work)
 
 	ret = iio_read_channel_raw(data->chan, &adc_val);
 	if (ret < 0) {
-		dev_err(data->edev.dev, "read channel() error: %d\n", ret);
+		dev_err(&data->edev.dev, "read channel() error: %d\n", ret);
 		return;
 	}
 
diff --git a/drivers/extcon/extcon-class.c b/drivers/extcon/extcon-class.c
index ed456b3..8bc43e6 100644
--- a/drivers/extcon/extcon-class.c
+++ b/drivers/extcon/extcon-class.c
@@ -160,7 +160,7 @@ static ssize_t name_show(struct device *dev, struct device_attribute *attr,
 			return ret;
 	}
 
-	return sprintf(buf, "%s\n", dev_name(edev->dev));
+	return sprintf(buf, "%s\n", dev_name(&edev->dev));
 }
 
 static ssize_t cable_name_show(struct device *dev,
@@ -224,10 +224,11 @@ int extcon_update_state(struct extcon_dev *edev, u32 mask, u32 state)
 		edev->state |= state & mask;
 
 		raw_notifier_call_chain(&edev->nh, old_state, edev);
+
 		/* This could be in interrupt handler */
 		prop_buf = (char *)get_zeroed_page(GFP_ATOMIC);
 		if (prop_buf) {
-			length = name_show(edev->dev, NULL, prop_buf);
+			length = name_show(&edev->dev, NULL, prop_buf);
 			if (length > 0) {
 				if (prop_buf[length - 1] == '\n')
 					prop_buf[length - 1] = 0;
@@ -235,7 +236,7 @@ int extcon_update_state(struct extcon_dev *edev, u32 mask, u32 state)
 					"NAME=%s", prop_buf);
 				envp[env_offset++] = name_buf;
 			}
-			length = state_show(edev->dev, NULL, prop_buf);
+			length = state_show(&edev->dev, NULL, prop_buf);
 			if (length > 0) {
 				if (prop_buf[length - 1] == '\n')
 					prop_buf[length - 1] = 0;
@@ -247,15 +248,15 @@ int extcon_update_state(struct extcon_dev *edev, u32 mask, u32 state)
 			/* Unlock early before uevent */
 			spin_unlock_irqrestore(&edev->lock, flags);
 
-			kobject_uevent_env(&edev->dev->kobj, KOBJ_CHANGE, envp);
+			kobject_uevent_env(&edev->dev.kobj, KOBJ_CHANGE, envp);
 			free_page((unsigned long)prop_buf);
 		} else {
 			/* Unlock early before uevent */
 			spin_unlock_irqrestore(&edev->lock, flags);
 
-			dev_err(edev->dev,
+			dev_err(&edev->dev,
 				"out of memory in extcon_set_state\n");
-			kobject_uevent(&edev->dev->kobj, KOBJ_CHANGE);
+			kobject_uevent(&edev->dev.kobj, KOBJ_CHANGE);
 		}
 	} else {
 		/* No changes */
@@ -593,20 +594,17 @@ int extcon_dev_register(struct extcon_dev *edev, struct device *dev)
 	}
 
 	if (index > SUPPORTED_CABLE_MAX) {
-		dev_err(edev->dev,
+		dev_err(&edev->dev,
 			"maximum number of supported cables exceeded\n");
 		return -EINVAL;
 	}
 
-	edev->dev = kzalloc(sizeof(struct device), GFP_KERNEL);
-	if (!edev->dev)
-		return -ENOMEM;
-	edev->dev->parent = dev;
-	edev->dev->class = extcon_class;
-	edev->dev->release = extcon_dev_release;
+	edev->dev.parent = dev;
+	edev->dev.class = extcon_class;
+	edev->dev.release = extcon_dev_release;
 
 	edev->name = edev->name ? edev->name : dev_name(dev);
-	dev_set_name(edev->dev, "%s", edev->name);
+	dev_set_name(&edev->dev, "%s", edev->name);
 
 	if (edev->max_supported) {
 		char buf[10];
@@ -714,7 +712,7 @@ int extcon_dev_register(struct extcon_dev *edev, struct device *dev)
 			goto err_alloc_groups;
 		}
 
-		edev->extcon_dev_type.name = dev_name(edev->dev);
+		edev->extcon_dev_type.name = dev_name(&edev->dev);
 		edev->extcon_dev_type.release = dummy_sysfs_dev_release;
 
 		for (index = 0; index < edev->max_supported; index++)
@@ -724,25 +722,24 @@ int extcon_dev_register(struct extcon_dev *edev, struct device *dev)
 			edev->extcon_dev_type.groups[index] =
 				&edev->attr_g_muex;
 
-		edev->dev->type = &edev->extcon_dev_type;
+		edev->dev.type = &edev->extcon_dev_type;
 	}
 
-	ret = device_register(edev->dev);
+	ret = device_register(&edev->dev);
 	if (ret) {
-		put_device(edev->dev);
+		put_device(&edev->dev);
 		goto err_dev;
 	}
 #if defined(CONFIG_ANDROID)
 	if (switch_class)
-		ret = class_compat_create_link(switch_class, edev->dev,
-					       NULL);
+		ret = class_compat_create_link(switch_class, &edev->dev, NULL);
 #endif /* CONFIG_ANDROID */
 
 	spin_lock_init(&edev->lock);
 
 	RAW_INIT_NOTIFIER_HEAD(&edev->nh);
 
-	dev_set_drvdata(edev->dev, edev);
+	dev_set_drvdata(&edev->dev, edev);
 	edev->state = 0;
 
 	mutex_lock(&extcon_dev_list_lock);
@@ -768,7 +765,6 @@ err_alloc_cables:
 	if (edev->max_supported)
 		kfree(edev->cables);
 err_sysfs_alloc:
-	kfree(edev->dev);
 	return ret;
 }
 EXPORT_SYMBOL_GPL(extcon_dev_register);
@@ -788,9 +784,9 @@ void extcon_dev_unregister(struct extcon_dev *edev)
 	list_del(&edev->entry);
 	mutex_unlock(&extcon_dev_list_lock);
 
-	if (IS_ERR_OR_NULL(get_device(edev->dev))) {
-		dev_err(edev->dev, "Failed to unregister extcon_dev (%s)\n",
-				dev_name(edev->dev));
+	if (IS_ERR_OR_NULL(get_device(&edev->dev))) {
+		dev_err(&edev->dev, "Failed to unregister extcon_dev (%s)\n",
+				dev_name(&edev->dev));
 		return;
 	}
 
@@ -812,10 +808,10 @@ void extcon_dev_unregister(struct extcon_dev *edev)
 
 #if defined(CONFIG_ANDROID)
 	if (switch_class)
-		class_compat_remove_link(switch_class, edev->dev, NULL);
+		class_compat_remove_link(switch_class, &edev->dev, NULL);
 #endif
-	device_unregister(edev->dev);
-	put_device(edev->dev);
+	device_unregister(&edev->dev);
+	put_device(&edev->dev);
 }
 EXPORT_SYMBOL_GPL(extcon_dev_unregister);
 
diff --git a/include/linux/extcon.h b/include/linux/extcon.h
index c2b652dd..0269baf 100644
--- a/include/linux/extcon.h
+++ b/include/linux/extcon.h
@@ -93,7 +93,7 @@ struct extcon_cable;
  *			name of the extcon device.
  * @print_state:	An optional callback to override the method to print the
  *			status of the extcon device.
- * @dev:		Device of this extcon. Do not provide at register-time.
+ * @dev:		Device of this extcon.
  * @state:		Attach/detach state of this extcon. Do not provide at
  *			register-time.
  * @nh:			Notifier for the state change events from this extcon
@@ -121,7 +121,7 @@ struct extcon_dev {
 	ssize_t	(*print_state)(struct extcon_dev *edev, char *buf);
 
 	/* Internal data. Please do not set. */
-	struct device *dev;
+	struct device dev;
 	struct raw_notifier_head nh;
 	struct list_head entry;
 	int max_supported;
-- 
1.8.0

