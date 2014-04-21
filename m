Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752210AbaDUKMU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 06:12:20 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:23049 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751876AbaDUKKX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 06:10:23 -0400
X-AuditID: cbfee68d-b7f4e6d000004845-ca-5354ee89e6cc
From: Sangjung Woo <sangjung.woo@samsung.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>
Cc: linux-kernel@vger.kernel.org, Sangjung Woo <sangjung.woo@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>
Subject: [PATCHv4 1/8] extcon: Add resource-managed extcon register function
Date: Mon, 21 Apr 2014 19:10:08 +0900
Message-id: <1398075015-19211-2-git-send-email-sangjung.woo@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1398075015-19211-1-git-send-email-sangjung.woo@samsung.com>
References: <1398075015-19211-1-git-send-email-sangjung.woo@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrPLMWRmVeSWpSXmKPExsWyRsSkWLfzXUiwwYtfbBbXvzxntXj9wtDi
	8q45bBa3G1ewWSzYU2IxY/JLNgc2j74tqxg9Pm+SC2CK4rJJSc3JLEst0rdL4Mr4u3khc8EV
	+Yovk/cxNTDOl+pi5OCQEDCRWDSztouRE8gUk7hwbz1bFyMXh5DAUkaJjzc+M0IkTCRuXGlh
	B7GFBBYxSvx6xwhR1MYkMeVqO1gRm4CuxJMDl5lBbBGBYImOk8eZQIqYBZYwSvw7eYsNJCEs
	4CPx9VwbWBGLgKrEh/+rwGxeAQ+J1afesUJcpCAxZ5INSJhTwFNi0dSFjBCLPSROf5rPDDJT
	QuA/m8SyY19YIeYISHybfIgFoldWYtMBZoijJSUOrrjBMoFReAEjwypG0dSC5ILipPQiQ73i
	xNzi0rx0veT83E2MwMA9/e9Z7w7G2wesDzEmA42byCwlmpwPDPy8knhDYzMjC1MTU2Mjc0sz
	0oSVxHmTHiYFCQmkJ5akZqemFqQWxReV5qQWH2Jk4uCUamDkkFFYVPXpkUOBsfLCReZ6p1st
	1Kz9Y+vOaHC88TEW+PXmzTbWKYsa5hvqrpB59j9JynlT+6bdKZyZmxa3PbN4pjljhuBX1amK
	DeFlorI+jLOeX7Gv3WXree+pnEr7+hWGeV75OhLyHVM8zv+bx8fx6JwSc9tPmU1v5P3nnzjV
	b5pwP83pV6oSS3FGoqEWc1FxIgAW3OF6cgIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrLIsWRmVeSWpSXmKPExsVy+t9jAd2OdyHBBq92WFtc//Kc1eL1C0OL
	y7vmsFncblzBZrFgT4nFjMkv2RzYPPq2rGL0+LxJLoApqoHRJiM1MSW1SCE1Lzk/JTMv3VbJ
	OzjeOd7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwdoo5JCWWJOKVAoILG4WEnfDtOE0BA3XQuY
	xghd35AguB4jAzSQsIYx4+/mhcwFV+Qrvkzex9TAOF+qi5GTQ0LAROLGlRZ2CFtM4sK99Wwg
	tpDAIkaJX+8Yuxi5gOw2JokpV9sZQRJsAroSTw5cZgaxRQSCJTpOHmcCKWIWWMIo8e/kLbBu
	YQEfia/n2sCKWARUJT78XwVm8wp4SKw+9Y61i5EDaJuCxJxJNiBhTgFPiUVTFzJCLPaQOP1p
	PvMERt4FjAyrGEVTC5ILipPSc430ihNzi0vz0vWS83M3MYIj45n0DsZVDRaHGAU4GJV4eF/k
	hwQLsSaWFVfmHmKU4GBWEuGNWA8U4k1JrKxKLcqPLyrNSS0+xJgMdNREZinR5Hxg1OaVxBsa
	m5gZWRqZG1oYGZuTJqwkznuw1TpQSCA9sSQ1OzW1ILUIZgsTB6dUA6OzyqplJT2PBJ5JTC8X
	sWGJlbutccMjN9T9/hvJU1Nl1Jy0rGzkeeUsH1y5d37ZtU8rVQ78b95YIx71ZFrP++/eD+fp
	7Z1pwtG46vTlH4XB8rFSfUKTDuseXFx+eYqa284u90TbFxOY2CJYNu3Lf/zZ8tmVwPXeX6f1
	57xJ0Z7bobWiKzTBc7ESS3FGoqEWc1FxIgDqYFMo0AIAAA==
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
 drivers/extcon/extcon-class.c |   64 +++++++++++++++++++++++++++++++++++++++++
 include/linux/extcon.h        |   17 +++++++++++
 2 files changed, 81 insertions(+)

diff --git a/drivers/extcon/extcon-class.c b/drivers/extcon/extcon-class.c
index 7ab21aa..645b02b 100644
--- a/drivers/extcon/extcon-class.c
+++ b/drivers/extcon/extcon-class.c
@@ -819,6 +819,70 @@ void extcon_dev_unregister(struct extcon_dev *edev)
 }
 EXPORT_SYMBOL_GPL(extcon_dev_unregister);
 
+static void devm_extcon_dev_release(struct device *dev, void *res)
+{
+	extcon_dev_unregister((struct extcon_dev *)res);
+}
+
+static int devm_extcon_dev_match(struct device *dev, void *res, void *data)
+{
+	return res == data;
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
+	struct extcon_dev **ptr;
+	int ret;
+
+	ptr = devres_alloc(devm_extcon_dev_release, sizeof(*ptr),
+			GFP_KERNEL);
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
+	WARN_ON(devres_release(dev, devm_extcon_dev_release,
+			devm_extcon_dev_match, edev));
+}
+EXPORT_SYMBOL_GPL(devm_extcon_dev_unregister);
+
 #ifdef CONFIG_OF
 /*
  * extcon_get_edev_by_phandle - Get the extcon device from devicetree
diff --git a/include/linux/extcon.h b/include/linux/extcon.h
index f488145..6a17f69 100644
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
 
+static inline devm_extcon_dev_register(struct device *dev,
+				       struct extcon_dev *edev)
+{
+	return 0;
+}
+
+static inline devm_extcon_dev_unregister(struct device *dev,
+					 struct extcon_dev *edev) { }
+
 static inline u32 extcon_get_state(struct extcon_dev *edev)
 {
 	return 0;
-- 
1.7.9.5

