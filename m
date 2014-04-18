Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751845AbaDRAct (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 20:32:49 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:30892 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751357AbaDRAcj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 20:32:39 -0400
X-AuditID: cbfee68e-b7f566d000002344-3f-535072a599bb
From: Sangjung Woo <sangjung.woo@samsung.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>
Cc: linux-kernel@vger.kernel.org, Sangjung Woo <sangjung.woo@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>
Subject: [PATCHv3 1/8] extcon: Add resource-managed extcon register function
Date: Fri, 18 Apr 2014 09:32:33 +0900
Message-id: <1397781160-744-2-git-send-email-sangjung.woo@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1397781160-744-1-git-send-email-sangjung.woo@samsung.com>
References: <1397781160-744-1-git-send-email-sangjung.woo@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrALMWRmVeSWpSXmKPExsWyRsSkWHdpUUCwwY+vqhbXvzxntXj9wtDi
	8q45bBa3G1ewWSzYU2IxY/JLNgc2j74tqxg9Pm+SC2CK4rJJSc3JLEst0rdL4MqY0T+TueCe
	QsW5pzOYGxjnS3cxcnJICJhI/P58iQXCFpO4cG89WxcjF4eQwFJGiWttexm7GDnAiv60S0DE
	FzFKrDu+ix3CaWOS2P/sNDNIN5uArsSTA5fBbBGBYImOk8eZQIqYBZYwSvw7eYsNJCEs4CNx
	e9ltsCIWAVWJjS/Pgdm8Am4SX293MEFsU5CYM8kGJMwp4C4xa9dOJhBbCKjk+ZapjCAzJQT+
	s0l8O3qeCWKOgMS3yYdYIHplJTYdYIb4RlLi4IobLBMYhRcwMqxiFE0tSC4oTkovMtIrTswt
	Ls1L10vOz93ECAzd0/+e9e1gvHnA+hBjMtC4icxSosn5wNDPK4k3NDYzsjA1MTU2Mrc0I01Y
	SZx30cOkICGB9MSS1OzU1ILUovii0pzU4kOMTBycUg2M0/4mPC53MI7vstXONI9mUcuYVv7T
	1/jtPY+D+/aVrFPf9Pbtd4vc81PU3wYapHo3bv60b3L3snUWoq0r0zfmT0zc/qKMXclcdsf0
	/Qm+TXJtWyLcS1Rnh5/znyXluulXdNWuPuf7/k6n1u0TzxLfsdbti5CQuf8sC6UTurHBX7in
	6Vb7K8xSYinOSDTUYi4qTgQAkM44CXMCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrLIsWRmVeSWpSXmKPExsVy+t9jAd2lRQHBBnteylhc//Kc1eL1C0OL
	y7vmsFncblzBZrFgT4nFjMkv2RzYPPq2rGL0+LxJLoApqoHRJiM1MSW1SCE1Lzk/JTMv3VbJ
	OzjeOd7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwdoo5JCWWJOKVAoILG4WEnfDtOE0BA3XQuY
	xghd35AguB4jAzSQsIYxY0b/TOaCewoV557OYG5gnC/dxcjBISFgIvGnXaKLkRPIFJO4cG89
	WxcjF4eQwCJGiXXHd7FDOG1MEvufnWYGqWIT0JV4cuAymC0iECzRcfI4E0gRs8ASRol/J2+x
	gSSEBXwkbi+7DVbEIqAqsfHlOTCbV8BN4uvtDiaIzQoScybZgIQ5BdwlZu3ayQRiCwGVPN8y
	lXECI+8CRoZVjKKpBckFxUnpuUZ6xYm5xaV56XrJ+bmbGMGR8Ux6B+OqBotDjAIcjEo8vBe+
	+gcLsSaWFVfmHmKU4GBWEuE9nxYQLMSbklhZlVqUH19UmpNafIgxGeioicxSosn5wKjNK4k3
	NDYxM7I0Mje0MDI2J01YSZz3YKt1oJBAemJJanZqakFqEcwWJg5OqQZGrxlnNAzNes+ceHE3
	bCnjXTuuzlzeGW8E9E+vmbH1qKbfodwL5+R2f9nWZhVzYpEY474ZS076cB8sD+MOc5h8Ttf0
	yY3t/96lOMllXL+kUDF1udgeyxv6e4py43OupBvfvFnzNWftL2N/o6K1740DBY+KmSes+yUa
	2SYn+Sn5ZqRi+obflxIrlViKMxINtZiLihMBD0BFNNACAAA=
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
 drivers/extcon/extcon-class.c |   72 +++++++++++++++++++++++++++++++++++++++++
 include/linux/extcon.h        |   17 ++++++++++
 2 files changed, 89 insertions(+)

diff --git a/drivers/extcon/extcon-class.c b/drivers/extcon/extcon-class.c
index 7ab21aa..e177edb6 100644
--- a/drivers/extcon/extcon-class.c
+++ b/drivers/extcon/extcon-class.c
@@ -819,6 +819,78 @@ void extcon_dev_unregister(struct extcon_dev *edev)
 }
 EXPORT_SYMBOL_GPL(extcon_dev_unregister);
 
+
+/*
+ * Device resource management
+ */
+static void devm_extcon_dev_release(struct device *dev, void *res)
+{
+	struct extcon_dev *devres = res;
+
+	extcon_dev_unregister(devres);
+}
+
+static int devm_extcon_dev_match(struct device *dev, void *res, void *data)
+{
+	struct extcon_dev *devres = res;
+	struct extcon_dev *match = data;
+	return devres == match;
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
+	struct extcon_dev *devres;
+	int ret;
+
+	devres = devres_alloc(devm_extcon_dev_release, sizeof(*devres),
+			GFP_KERNEL);
+	if (!devres)
+		return -ENOMEM;
+
+	ret = extcon_dev_register(edev);
+	if (ret) {
+		devres_free(devres);
+		return ret;
+	}
+
+	devres = edev;
+	devres_add(dev, devres);
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
index f488145..35f3343 100644
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
@@ -254,6 +262,15 @@ static inline int extcon_dev_register(struct extcon_dev *edev)
 
 static inline void extcon_dev_unregister(struct extcon_dev *edev) { }
 
+static inline devm_extcon_dev_register(struct device *dev,
+		struct extcon_dev *edev)
+{
+	return 0;
+}
+
+static inline devm_extcon_dev_unregister(struct device *dev,
+		struct extcon_dev *edev) { }
+
 static inline u32 extcon_get_state(struct extcon_dev *edev)
 {
 	return 0;
-- 
1.7.9.5

