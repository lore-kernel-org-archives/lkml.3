Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751663AbaDUJhA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 05:37:00 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:21881 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056AbaDUJg0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 05:36:26 -0400
X-AuditID: cbfee68e-b7fd86d0000038e3-e9-5354e6979784
From: Chanwoo Choi <cw00.choi@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: myungjoo.ham@samsung.com, gg@slimlogic.co.uk, kishon@ti.com, balbi@ti.com,
        ckeepax@opensource.wolfsonmicro.com, broonie@kernel.org,
        k.kozlowski@samsung.com, kyungmin.park@samsung.com,
        sangjung.woo@samsung.com, Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCH 2/9] extcon: Add devm_extcon_dev_allocate/free to manage the
 resource of extcon device
Date: Mon, 21 Apr 2014 18:36:19 +0900
Message-id: <1398072986-17386-3-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1398072986-17386-1-git-send-email-cw00.choi@samsung.com>
References: <1398072986-17386-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupikeLIzCtJLcpLzFFi42JZI2JSojv9WUiwwZJ10hYH79dbTH34hM3i
	35Qb7BbXvzxntejf4mLx+oWhxYWnPWwWZ5vesFtc3jWHzeJ24wo2iwV7Shy4PTat6mTzeDnx
	N5tH35ZVjB5Tp/xl9Dh+YzuTx+dNcgFsUVw2Kak5mWWpRfp2CVwZCw9tYC14LVPxZsdlxgbG
	e+JdjBwcEgImEtv3hHcxcgKZYhIX7q1nA7GFBJYySrTvZ4aIm0jMfLqDtYuRCyi+iFFiTt9B
	JginiUniQudiJpAqNgEtif0vboB1iwgoSGzufQbWwSzQwCQx59MCJpBtwgIZEmvv+IHUsAio
	Ssx9egesnlfAVeLy33Z2iG1yEh/2PAKzOQXcJNb96GaFuMhVouN9HyPITAmBfewSJ9d+ZIEY
	JCDxbfIhFohvZCU2HYC6WlLi4IobLBMYhRcwMqxiFE0tSC4oTkovMtIrTswtLs1L10vOz93E
	CIyH0/+e9e1gvHnA+hBjMtC4icxSosn5wHjKK4k3NDYzsjA1MTU2Mrc0I01YSZx30cOkICGB
	9MSS1OzU1ILUovii0pzU4kOMTBycUg2M+a/FF5hLnpiz6LCr1P5ERsY9901eH6jRfn4n4rKP
	wPS2eXcO168v/sEsqH57iez2dcI2OXU935TuxQqtUwr+u6RJ2z7ARdovTWZbaYaty4R/mysm
	b/nw++qya3NOVswqeMF3ySDRl//dx0VvLztr/otS81pwYlkG/5mz2TU9ArbTUlKi4ta+U2Ip
	zkg01GIuKk4EANoRtiCdAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrJIsWRmVeSWpSXmKPExsVy+t9jAd3pz0KCDW4cF7U4eL/eYurDJ2wW
	/6bcYLe4/uU5q0X/FheL1y8MLS487WGzONv0ht3i8q45bBa3G1ewWSzYU+LA7bFpVSebx8uJ
	v9k8+rasYvSYOuUvo8fxG9uZPD5vkgtgi2pgtMlITUxJLVJIzUvOT8nMS7dV8g6Od443NTMw
	1DW0tDBXUshLzE21VXLxCdB1y8wBOk5JoSwxpxQoFJBYXKykb4dpQmiIm64FTGOErm9IEFyP
	kQEaSFjDmLHw0AbWgtcyFW92XGZsYLwn3sXIySEhYCIx8+kOVghbTOLCvfVsXYxcHEICixgl
	5vQdZIJwmpgkLnQuZgKpYhPQktj/4gYbiC0ioCCxufcZK0gRs0ADk8ScTwuAijg4hAUyJNbe
	8QOpYRFQlZj79A5YPa+Aq8Tlv+3sENvkJD7seQRmcwq4Saz70Q12hRBQTcf7PsYJjLwLGBlW
	MYqmFiQXFCel5xrpFSfmFpfmpesl5+duYgRH3DPpHYyrGiwOMQpwMCrx8L7IDwkWYk0sK67M
	PcQowcGsJMIbsR4oxJuSWFmVWpQfX1Sak1p8iDEZ6KqJzFKiyfnAZJBXEm9obGJmZGlkbmhh
	ZGxOmrCSOO/BVutAIYH0xJLU7NTUgtQimC1MHJxSDYw8N07OVFkRskNHLHBfOe/JwgarnbYa
	liLafq0Xy5y3it/rnZIfsCD307m1DjeT5u5g+TojtUN3f47Y/iyDgvXTGNokOf3aN8vOuz/h
	5qu0Tu2tlZO7s3OO3nlcKztHhXWrWfeeVL+zMYH3LOea++YU/OvwOutfuqTvgNBHwV8Jrhb3
	JSWCPyqxFGckGmoxFxUnAgCGHgVM/AIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add device managed devm_extcon_dev_{allocate,free} to automatically
free the memory of extcon_dev structure without handling free operation.

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
---
 drivers/extcon/extcon-class.c | 57 +++++++++++++++++++++++++++++++++++++++++++
 include/linux/extcon.h        | 16 ++++++++++++
 2 files changed, 73 insertions(+)

diff --git a/drivers/extcon/extcon-class.c b/drivers/extcon/extcon-class.c
index 600043c..b130446 100644
--- a/drivers/extcon/extcon-class.c
+++ b/drivers/extcon/extcon-class.c
@@ -848,6 +848,63 @@ void extcon_dev_free(struct extcon_dev *edev)
 }
 EXPORT_SYMBOL_GPL(extcon_dev_free);
 
+static void devm_extcon_device_release(struct device *dev, void *res)
+{
+	extcon_dev_free(*(struct extcon_dev **)res);
+}
+
+static int devm_extcon_dev_match(struct device *dev, void *res, void *data)
+{
+	struct extcon_dev **r = res;
+	if (!r || !*r) {
+		WARN_ON(!r || !*r);
+		return 0;
+	}
+	return *r == data;
+}
+
+/**
+ * devm_extcon_dev_allocate - Allocate managed extcon device
+ * @dev:		device owning the extcon device being created
+ * @supported_cable:	Array of supported cable names ending with NULL.
+ *			If supported_cable is NULL, cable name related APIs
+ *			are disabled.
+ *
+ * This function manages automatically the memory of extcon device using device
+ * resource management and simplify the control of freeing the memory of extcon
+ * device.
+ *
+ * Returns the pointer memory of allocated extcon_dev if success or NULL if fail
+ */
+struct extcon_dev *devm_extcon_dev_allocate(struct device *dev,
+					    const char **supported_cable)
+{
+	struct extcon_dev **res, *edev;
+
+	res = devres_alloc(devm_extcon_device_release, sizeof(*res),
+			   GFP_KERNEL);
+	if (!res)
+		return NULL;
+
+	edev = extcon_dev_allocate(supported_cable);
+	if (!IS_ERR(edev)) {
+		*res = edev;
+		devres_add(dev, res);
+	} else {
+		devres_free(res);
+	}
+
+	return edev;
+}
+EXPORT_SYMBOL_GPL(devm_extcon_dev_allocate);
+
+void devm_extcon_dev_free(struct device *dev, struct extcon_dev *edev)
+{
+	WARN_ON(devres_release(dev, devm_extcon_device_release,
+			       devm_extcon_dev_match, edev));
+}
+EXPORT_SYMBOL_GPL(devm_extcon_dev_free);
+
 #ifdef CONFIG_OF
 /*
  * extcon_get_edev_by_phandle - Get the extcon device from devicetree
diff --git a/include/linux/extcon.h b/include/linux/extcon.h
index ffb3a03..12ab2a8 100644
--- a/include/linux/extcon.h
+++ b/include/linux/extcon.h
@@ -246,6 +246,8 @@ extern int extcon_unregister_notifier(struct extcon_dev *edev,
 /*
  * Following APIs control the memory of extcon device.
  */
+extern struct extcon_dev *devm_extcon_dev_allocate(struct device *dev,
+						   const char **cables);
 extern struct extcon_dev *extcon_dev_allocate(const char **cables);
 extern void extcon_dev_free(struct extcon_dev *edev);
 
@@ -345,11 +347,25 @@ static inline struct extcon_dev *extcon_get_edev_by_phandle(struct device *dev,
 	return ERR_PTR(-ENODEV);
 }
 
+static inline struct extcon_dev *devm_extcon_dev_allocate(struct device *dev,
+							  const char **cables)
+{
+	return -ENOMEM;
+}
+
 static inline struct extcon_dev *extcon_dev_allocate(const char **cables)
 {
 	return ERR_PTR(-ENOMEM);
 }
 
 static inline void extcon_dev_free(struct extcon_dev *edev) { }
+
+static inline struct extcon_dev *devm_extcon_dev_allocate(struct device *dev,
+							  const char **cables)
+{
+	return ERR_PTR(-ENOMEM);
+}
+
+static inline void devm_extcon_dev_free(struct extcon_dev *edev) { }
 #endif /* CONFIG_EXTCON */
 #endif /* __LINUX_EXTCON_H__ */
-- 
1.8.0

