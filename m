Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751517AbaDUKgr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 06:36:47 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:15423 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750908AbaDUKgp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 06:36:45 -0400
X-AuditID: cbfee690-b7fcd6d0000026e0-50-5354f4afb1f5
From: Chanwoo Choi <cw00.choi@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: myungjoo.ham@samsung.com, balbi@ti.com, sangjung.woo@samsung.com,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCHv5] extcon: Add resource-managed extcon register function
Date: Mon, 21 Apr 2014 19:36:35 +0900
Message-id: <1398076595-18494-1-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrBLMWRmVeSWpSXmKPExsWyRsSkSHf9l5Bgg+NLJCwO3q+3uP7lOavF
	5V1z2CxuN65gs1iwp8SB1aNvyypGj+M3tjN5fN4kF8AcxWWTkpqTWZZapG+XwJVxrWkfY8EX
	xYp7EyexNDC2y3QxcnJICJhIrNy7hw3CFpO4cG89kM3FISSwlFHi6fJz7DBFx57MZ4ZILGKU
	6P3wgAnCaWKSmH3mAiNIFZuAlsT+FzfARokIKEhs7n3GCmIzC+RIbNqxBaxGWMBD4unqU2BT
	WQRUJX72PQGKc3DwCrhK3N6kAbFMTuLDnkfsIPMlBB6zScx++B6qXkDi2+RDLCD1EgKyEpsO
	MEPUS0ocXHGDZQKj4AJGhlWMoqkFyQXFSelFJnrFibnFpXnpesn5uZsYgaF4+t+zCTsY7x2w
	PsSYDDRuIrOUaHI+MJTzSuINjc2MLExNTI2NzC3NSBNWEudVe5QUJCSQnliSmp2aWpBaFF9U
	mpNafIiRiYNTqoHRg2Pd+5/T723lyWXZ//NK5d3etnsn3+Qv+cAk0SPy2sol8kF9ikwR12MV
	j8dya37t0NPqTJjk5Gtz9M2GLotzITf0JAKXnw5e8fNYmfSpH0n3rBsr5AKTntseeWOgJ9Z+
	OklNUNM/8PT+wi8TUmqudp82i7iZ93K3fYI5z1XmBUZ9WtLLtFyVWIozEg21mIuKEwFVAKlN
	WwIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrKIsWRmVeSWpSXmKPExsVy+t9jAd31X0KCDVZN4LU4eL/e4vqX56wW
	l3fNYbO43biCzWLBnhIHVo++LasYPY7f2M7k8XmTXABzVAOjTUZqYkpqkUJqXnJ+SmZeuq2S
	d3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7QRiWFssScUqBQQGJxsZK+HaYJoSFuuhYw
	jRG6viFBcD1GBmggYQ1jxrWmfYwFXxQr7k2cxNLA2C7TxcjJISFgInHsyXxmCFtM4sK99Wxd
	jFwcQgKLGCV6PzxggnCamCRmn7nACFLFJqAlsf/FDTYQW0RAQWJz7zNWEJtZIEdi044tYDXC
	Ah4ST1efYgexWQRUJX72PQGKc3DwCrhK3N6kAbFMTuLDnkfsExi5FzAyrGIUTS1ILihOSs81
	1CtOzC0uzUvXS87P3cQIDvRnUjsYVzZYHGIU4GBU4uGdURISLMSaWFZcmXuIUYKDWUmEN2I9
	UIg3JbGyKrUoP76oNCe1+BBjMtDyicxSosn5wCjMK4k3NDYxM7I0Mje0MDI2J01YSZz3QKt1
	oJBAemJJanZqakFqEcwWJg5OqQbG8IWHN26U/B9yOO6i/5SD1QHNi0TmMduqLddybGY6ql5q
	8/ycc9R2kcbieD/WpXPfdltPcjVUfrqEJYt38Ulen9iPKZxHFphxHQs0cH61o76daevL0iU8
	h29lHaz51BpmGW0eyBD4VMDNP/vc1fWXlafemfb1Tmf63YLUmSdeLN3jICwYfTZTiaU4I9FQ
	i7moOBEAL2WG07gCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sangjung Woo <sangjung.woo@samsung.com>

Add resource-managed extcon device register function for convenience.
For example, if a extcon device is attached with new
devm_extcon_dev_register(), that extcon device is automatically
unregistered on driver detach.

Signed-off-by: Sangjung Woo <sangjung.woo@samsung.com>
[Fix bug about devm_extcon_dev_match/release() and code clean by Chanwoo Choi]
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
---
 drivers/extcon/extcon-class.c | 69 +++++++++++++++++++++++++++++++++++++++++++
 include/linux/extcon.h        | 17 +++++++++++
 2 files changed, 86 insertions(+)

diff --git a/drivers/extcon/extcon-class.c b/drivers/extcon/extcon-class.c
index 7ab21aa..f6df689 100644
--- a/drivers/extcon/extcon-class.c
+++ b/drivers/extcon/extcon-class.c
@@ -819,6 +819,75 @@ void extcon_dev_unregister(struct extcon_dev *edev)
 }
 EXPORT_SYMBOL_GPL(extcon_dev_unregister);
 
+static void devm_extcon_dev_unreg(struct device *dev, void *res)
+{
+	extcon_dev_unregister(*(struct extcon_dev **)res);
+}
+
+static int devm_extcon_dev_match(struct device *dev, void *res, void *data)
+{
+	struct extcon_dev **r = res;
+
+	if (!r || !*r) {
+		WARN_ON(!r || !*r);
+		return 0;
+	}
+
+	return *r == data;
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
+ * Returns 0 if success or negaive error number if failure.
+ */
+int devm_extcon_dev_register(struct device *dev, struct extcon_dev *edev)
+{
+	struct extcon_dev **ptr;
+	int ret;
+
+	ptr = devres_alloc(devm_extcon_dev_unreg, sizeof(*ptr), GFP_KERNEL);
+	if (!ptr)
+		return -ENOMEM;
+
+	ret = extcon_dev_register(edev);
+	if (ret) {
+		devres_free(ptr);
+		return ret;
+	}
+
+	*ptr = edev;
+	devres_add(dev, ptr);
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
+	WARN_ON(devres_release(dev, devm_extcon_dev_unreg,
+			       devm_extcon_dev_match, edev));
+}
+EXPORT_SYMBOL_GPL(devm_extcon_dev_unregister);
+
 #ifdef CONFIG_OF
 /*
  * extcon_get_edev_by_phandle - Get the extcon device from devicetree
diff --git a/include/linux/extcon.h b/include/linux/extcon.h
index f488145..85a8a5b 100644
--- a/include/linux/extcon.h
+++ b/include/linux/extcon.h
@@ -188,6 +188,14 @@ extern void extcon_dev_unregister(struct extcon_dev *edev);
 extern struct extcon_dev *extcon_get_extcon_dev(const char *extcon_name);
 
 /*
+ * Resource-managed extcon device register function.
+ */
+extern int devm_extcon_dev_register(struct device *dev,
+				    struct extcon_dev *edev);
+extern void devm_extcon_dev_unregister(struct device *dev,
+				       struct extcon_dev *edev);
+
+/*
  * get/set/update_state access the 32b encoded state value, which represents
  * states of all possible cables of the multistate port. For example, if one
  * calls extcon_set_state(edev, 0x7), it may mean that all the three cables
@@ -254,6 +262,15 @@ static inline int extcon_dev_register(struct extcon_dev *edev)
 
 static inline void extcon_dev_unregister(struct extcon_dev *edev) { }
 
+static inline int devm_extcon_dev_register(struct device *dev,
+					   struct extcon_dev *edev)
+{
+	return -EINVAL;
+}
+
+static inline void devm_extcon_dev_unregister(struct device *dev,
+					      struct extcon_dev *edev) { }
+
 static inline u32 extcon_get_state(struct extcon_dev *edev)
 {
 	return 0;
-- 
1.8.0

