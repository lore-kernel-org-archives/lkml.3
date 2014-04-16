Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755349AbaDPK1J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 06:27:09 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:12483 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754984AbaDPK1D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 06:27:03 -0400
X-AuditID: cbfee68d-b7fcd6d00000315b-f3-534e5af6c783
From: Sangjung Woo <sangjung.woo@samsung.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>
Cc: linux-kernel@vger.kernel.org, Sangjung Woo <sangjung.woo@samsung.com>
Subject: [PATCH 1/8] extcon: Add resource-managed extcon register function
Date: Wed, 16 Apr 2014 19:26:56 +0900
Message-id: <1397644023-32516-2-git-send-email-sangjung.woo@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1397644023-32516-1-git-send-email-sangjung.woo@samsung.com>
References: <1397644023-32516-1-git-send-email-sangjung.woo@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrCLMWRmVeSWpSXmKPExsWyRsSkSPdblF+wQecPdYvrX56zWlzeNYfN
	4nbjCjaLBXtKHFg8+rasYvT4vEkugCmKyyYlNSezLLVI3y6BK+Ph16CCDQoVPy9cZmxg/CTV
	xcjJISFgIrFu61I2CFtM4sK99UA2F4eQwFJGie0H9zLDFD368ZYJxBYSWMQoce9vMkRRG5NE
	/4E5YEVsAroSTw5cBrNFBIIlOk4eB2tgFvCUmDu5C2yDsICXxN2v11hBbBYBVYkJ0+aC2bwC
	HhLnb08FqucAWqYgMWeSDUiYE6h186tvzCBhIaCSe1/NQNZKCDxnk9j1uYMdYoyAxLfJh1gg
	WmUlNh2AOllS4uCKGywTGIUXMDKsYhRNLUguKE5KLzLUK07MLS7NS9dLzs/dxAgM0dP/nvXu
	YLx9wPoQYzLQuInMUqLJ+cAQzyuJNzQ2M7IwNTE1NjK3NCNNWEmcN+lhUpCQQHpiSWp2ampB
	alF8UWlOavEhRiYOTqkGRsdelsl/utprxeZzfs5yYZZz0p4n46q+k93ryr5H0zseVrHXGz0P
	v3LGt0BP8cdhKZ6u+PIwCf27ho2C8+dtPtv8IKXE7EnOef++k07OW46n1Ntu8CoW/xh+Z76C
	njq72HGuK/V7FgX+Sj/D5q0ZyFdRqftuiqWPebRM6FWjJ6FvX9kUNRxXYinOSDTUYi4qTgQA
	v2QAUWcCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrIIsWRmVeSWpSXmKPExsVy+t9jAd1vUX7BBntXyltc//Kc1eLyrjls
	FrcbV7BZLNhT4sDi0bdlFaPH501yAUxRDYw2GamJKalFCql5yfkpmXnptkrewfHO8aZmBoa6
	hpYW5koKeYm5qbZKLj4Bum6ZOUCLlBTKEnNKgUIBicXFSvp2mCaEhrjpWsA0Ruj6hgTB9RgZ
	oIGENYwZD78GFWxQqPh54TJjA+MnqS5GTg4JAROJRz/eMkHYYhIX7q1nA7GFBBYxStz7m9zF
	yAVktzFJ9B+YwwySYBPQlXhy4DKYLSIQLNFx8jhYM7OAp8TcyV1gzcICXhJ3v15jBbFZBFQl
	JkybC2bzCnhInL89FaieA2iZgsScSTYgYU6g1s2vvjGDhIWASu59NZvAyLuAkWEVo2hqQXJB
	cVJ6rpFecWJucWleul5yfu4mRnAEPJPewbiqweIQowAHoxIP78wc32Ah1sSy4srcQ4wSHMxK
	IryNkX7BQrwpiZVVqUX58UWlOanFhxiTgW6ayCwlmpwPjM68knhDYxMzI0sjc0MLI2Nz0oSV
	xHkPtloHCgmkJ5akZqemFqQWwWxh4uCUamDkzGrXEpCyeF632aWD6br7rI4XnffPt7grFx/Y
	bS7TqXlkSvuznF6v0yy/BS0WlIWE7PK8m5PbufuSxPxF9g92u0k0v+vz+K55oNX/dUNX66O/
	mcaH153XF1UsbFE6/8rb0nReL+OuyIIqG1WG20kvxGLYd/RkTWKTWaOwJ2JqYOrVv14Z/5RY
	ijMSDbWYi4oTAfb5OTHEAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add resource-managed extcon device register function for convenience.
For example, if a extcon device is attached with new
devm_extcon_dev_register(), that extcon device is automatically
unregistered on driver detach.

Signed-off-by: Sangjung Woo <sangjung.woo@samsung.com>
---
 drivers/extcon/extcon-class.c |   83 +++++++++++++++++++++++++++++++++++++++++
 include/linux/extcon.h        |    8 ++++
 2 files changed, 91 insertions(+)

diff --git a/drivers/extcon/extcon-class.c b/drivers/extcon/extcon-class.c
index 7ab21aa..accb49c 100644
--- a/drivers/extcon/extcon-class.c
+++ b/drivers/extcon/extcon-class.c
@@ -32,6 +32,7 @@
 #include <linux/slab.h>
 #include <linux/sysfs.h>
 #include <linux/of.h>
+#include <linux/gfp.h>
 
 /*
  * extcon_cable_name suggests the standard cable names for commonly used
@@ -819,6 +820,88 @@ void extcon_dev_unregister(struct extcon_dev *edev)
 }
 EXPORT_SYMBOL_GPL(extcon_dev_unregister);
 
+
+/*
+ * Device resource management
+ */
+
+struct extcon_devres {
+	struct extcon_dev *edev;
+};
+
+static void devm_extcon_release(struct device *dev, void *res)
+{
+	struct extcon_devres *dr = (struct extcon_devres *)res;
+
+	extcon_dev_unregister(dr->edev);
+}
+
+static int devm_extcon_match(struct device *dev, void *res, void *data)
+{
+	struct extcon_devres *dr = (struct extcon_devres *)res;
+	struct extcon_devres *match = (struct extcon_devres *)data;
+
+	return dr->edev == match->edev;
+}
+
+/**
+ * devm_extcon_dev_register() - Resource-managed extcon_dev_register()
+ * @dev:	device to allocate extcon device
+ * @edev:	the new extcon device to register
+ *
+ * Managed extcon_dev_register() function. If extcon device is attached with
+ * this function, that extcon device is automatically unregistered on driver
+ * detach. Internally this function calls extcon_dev_register() function.
+ * To get more information, refer that function.
+ *
+ * If extcon device is registered with this function and the device needs to be
+ * unregistered separately, devm_extcon_dev_unregister() should be used.
+ *
+ * RETURNS:
+ * 0 on success, negative error number on failure.
+ */
+int devm_extcon_dev_register(struct device *dev, struct extcon_dev *edev)
+{
+	struct extcon_devres *dr;
+	int rc;
+
+	dr = devres_alloc(devm_extcon_release, sizeof(struct extcon_devres),
+			GFP_KERNEL);
+	if (!dr)
+		return -ENOMEM;
+
+	rc = extcon_dev_register(edev);
+	if (rc) {
+		devres_free(dr);
+		return rc;
+	}
+
+	dr->edev = edev;
+	devres_add(dev, dr);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(devm_extcon_dev_register);
+
+/**
+ * devm_extcon_dev_unregister() - Resource-managed extcon_dev_unregister()
+ * @dev:	device the extcon belongs to
+ * @edev:	the extcon device to unregister
+ *
+ * Unregister extcon device that is registered with devm_extcon_dev_register()
+ * function.
+ */
+void devm_extcon_dev_unregister(struct device *dev, struct extcon_dev *edev)
+{
+	struct extcon_devres match_dr = { edev };
+
+	WARN_ON(devres_destroy(dev, devm_extcon_release,
+			devm_extcon_match, &match_dr));
+
+	extcon_dev_unregister(edev);
+}
+EXPORT_SYMBOL_GPL(devm_extcon_dev_unregister);
+
 #ifdef CONFIG_OF
 /*
  * extcon_get_edev_by_phandle - Get the extcon device from devicetree
diff --git a/include/linux/extcon.h b/include/linux/extcon.h
index f488145..e1e85a1 100644
--- a/include/linux/extcon.h
+++ b/include/linux/extcon.h
@@ -188,6 +188,14 @@ extern void extcon_dev_unregister(struct extcon_dev *edev);
 extern struct extcon_dev *extcon_get_extcon_dev(const char *extcon_name);
 
 /*
+ * Resource-managed extcon device register function.
+ */
+extern int devm_extcon_dev_register(struct device *dev,
+				struct extcon_dev *edev);
+extern void devm_extcon_dev_unregister(struct device *dev,
+				struct extcon_dev *edev);
+
+/*
  * get/set/update_state access the 32b encoded state value, which represents
  * states of all possible cables of the multistate port. For example, if one
  * calls extcon_set_state(edev, 0x7), it may mean that all the three cables
-- 
1.7.9.5

