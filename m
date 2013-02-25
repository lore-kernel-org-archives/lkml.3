Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756701Ab3BYHgI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 02:36:08 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:53703 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753985Ab3BYHgG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 02:36:06 -0500
X-AuditID: cbfee690-b7f6b6d000004563-ad-512b145aa0aa
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Tejun Heo'" <tj@kernel.org>,
        "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH] rtc: add devm_rtc_device_{register,unregister}()
Date: Mon, 25 Feb 2013 16:35:53 +0900
Message-id: <000e01ce132a$be08b940$3a1a2bc0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4TKr3P225TlgmCSq+KXSMzTosvig==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJIsWRmVeSWpSXmKPExsVy+t8zI90oEe1Agz3tbBZLLl5lt5izfg2b
	xeWFl1gtLu+aw2axv7OD0eLX8qOMDmweeyaeZPPYtKqTzePEjN8sHn1bVjF6TJ/3k8nj8ya5
	ALYoLpuU1JzMstQifbsEroymPr+CLdIVm+9fYWlg3CbWxcjJISFgIvFnbhsrhC0mceHeerYu
	Ri4OIYFljBKbDh9ihSmafmMCK0RiOqPE7QnzmCCcX4wSXTf3MYNUsQmoSXz5cpi9i5GDQ0RA
	X6KtRQOkhllgDaPEisYTLCA1wgKOErP+rwObyiKgKnH+fycTiM0rYCtxcfscVghbUOLH5Htg
	9cwCWhLrdx5ngrDlJTavecsMMl9CQF3i0V9dkLCIgJ7Ej5m3oEpEJPa9eMcIsldC4BK7xLbO
	1ewQuwQkvk0+xALRKyux6QAzxGOSEgdX3GCZwCg2C8nmWUg2z0KyeRaSFQsYWVYxiqYWJBcU
	J6UXmegVJ+YWl+al6yXn525ihETjhB2M9w5YH2JMBlo/kVlKNDkfGM15JfGGxsYmZiamJuaW
	puampAkrifPKX5IJFBJITyxJzU5NLUgtii8qzUktPsTIxMEp1cAodHrvxt7tU5ZM8b9a3yu8
	3aY/4skXR7mE37UrVY49UREqyJ77b0rasa0zsiqWzZ2Quv7RJfUpMi7OD/9c9fYL3Lnd1knO
	ekf2mszb3ixaJzuKintDq+t3J/ZZ7WiJdTer8uFb2vLln9R2S3Up9pWe+et2qfaLJmy8GG1z
	0PG679JfV9cskQ5SYinOSDTUYi4qTgQAnFTEddwCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrKKsWRmVeSWpSXmKPExsVy+t9jQd0oEe1Ag6vhFksuXmW3mLN+DZvF
	5YWXWC0u75rDZrG/s4PR4tfyo4wObB57Jp5k89i0qpPN48SM3ywefVtWMXpMn/eTyePzJrkA
	tqgGRpuM1MSU1CKF1Lzk/JTMvHRbJe/geOd4UzMDQ11DSwtzJYW8xNxUWyUXnwBdt8wcoDOU
	FMoSc0qBQgGJxcVK+naYJoSGuOlawDRG6PqGBMH1GBmggYR1jBlNfX4FW6QrNt+/wtLAuE2s
	i5GTQ0LARGL6jQmsELaYxIV769m6GLk4hASmM0rcnjCPCcL5xSjRdXMfM0gVm4CaxJcvh9m7
	GDk4RAT0JdpaNEBqmAXWMEqsaDzBAlIjLOAoMev/OrCpLAKqEuf/dzKB2LwCthIXt89hhbAF
	JX5MvgdWzyygJbF+53EmCFteYvOat8wg8yUE1CUe/dUFCYsI6En8mHkLqkREYt+Ld4wTGAVm
	IZk0C8mkWUgmzULSsoCRZRWjaGpBckFxUnqukV5xYm5xaV66XnJ+7iZGcKQ/k97BuKrB4hCj
	AAejEg9vw0qtQCHWxLLiytxDjBIczEoivJqhQCHelMTKqtSi/Pii0pzU4kOMyUCPTmSWEk3O
	ByahvJJ4Q2MTMyNLIzMLIxNzc9KElcR5GU89CRASSE8sSc1OTS1ILYLZwsTBKdXAuOQmu3/+
	E8eZMtMOMaTeOM7BOO97gt5/ucCD3Ekrtp/VXvavI1fawWaF59xImdZY93/7XQTXL1pZXf7n
	98OwRiat1EfpKjmz7q9pl9mlOUn46InsfbuP3sv8x8p2VSZ++96wpa5TV1SGnvT+f7b8j7rK
	X9GoVTLP45W/K38UkTjaIXyU6dX9PUosxRmJhlrMRcWJAGZQ6W44AwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These functios allows the driver core to automatically clean up
any allocation made by rtc drivers. Thus, it simplifies the error
paths.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/rtc/class.c |   72 +++++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/rtc.h |    6 ++++
 2 files changed, 78 insertions(+), 0 deletions(-)

diff --git a/drivers/rtc/class.c b/drivers/rtc/class.c
index 9b742d3..bd3c8ca 100644
--- a/drivers/rtc/class.c
+++ b/drivers/rtc/class.c
@@ -259,6 +259,78 @@ void rtc_device_unregister(struct rtc_device *rtc)
 }
 EXPORT_SYMBOL_GPL(rtc_device_unregister);
 
+static void devm_rtc_device_release(struct device *dev, void *res)
+{
+	struct rtc_device *rtc = *(struct rtc_device **)res;
+
+	rtc_device_unregister(rtc);
+}
+
+static int devm_rtc_device_match(struct device *dev, void *res, void *data)
+{
+	struct rtc **r = res;
+	if (!r || !*r) {
+		WARN_ON(!r || !*r);
+		return 0;
+	}
+	return *r == data;
+}
+
+/**
+ * devm_rtc_device_register - resource managed rtc_device_register()
+ * @name: the name of the device
+ * @dev: the device to register
+ * @ops: the rtc operations structure
+ * @owner: the module owner
+ *
+ * Managed rtc_device_register(). The rtc_device returned from this function
+ * are automatically freed on driver detach. See rtc_device_register()
+ * for more information.
+ */
+
+struct rtc_device *devm_rtc_device_register(const char *name,
+					struct device *dev,
+					const struct rtc_class_ops *ops,
+					struct module *owner)
+{
+	struct rtc_device **ptr, *rtc;
+
+	ptr = devres_alloc(devm_rtc_device_release, sizeof(*ptr), GFP_KERNEL);
+	if (!ptr)
+		return ERR_PTR(-ENOMEM);
+
+	rtc = rtc_device_register(name, dev, ops, owner);
+	if (!IS_ERR(rtc)) {
+		*ptr = rtc;
+		devres_add(dev, ptr);
+	} else {
+		devres_free(ptr);
+	}
+
+	return rtc;
+}
+EXPORT_SYMBOL_GPL(devm_rtc_device_register);
+
+/**
+ * devm_rtc_device_unregister - resource managed devm_rtc_device_unregister()
+ * @dev: the device to unregister
+ * @rtc: the RTC class device to unregister
+ *
+ * Deallocated a rtc allocated with devm_rtc_device_register(). Normally this
+ * function will not need to be called and the resource management code will
+ * ensure that the resource is freed.
+ */
+void devm_rtc_device_unregister(struct device *dev, struct rtc_device *rtc)
+{
+	int rc;
+
+	rc = devres_release(dev, devm_rtc_device_release,
+				devm_rtc_device_match, rtc);
+	if (rc != 0)
+		WARN_ON(rc);
+}
+EXPORT_SYMBOL_GPL(devm_rtc_device_unregister);
+
 static int __init rtc_init(void)
 {
 	rtc_class = class_create(THIS_MODULE, "rtc");
diff --git a/include/linux/rtc.h b/include/linux/rtc.h
index 580b24c..d955768 100644
--- a/include/linux/rtc.h
+++ b/include/linux/rtc.h
@@ -133,7 +133,13 @@ extern struct rtc_device *rtc_device_register(const char *name,
 					struct device *dev,
 					const struct rtc_class_ops *ops,
 					struct module *owner);
+extern struct rtc_device *devm_rtc_device_register(const char *name,
+					struct device *dev,
+					const struct rtc_class_ops *ops,
+					struct module *owner);
 extern void rtc_device_unregister(struct rtc_device *rtc);
+extern void devm_rtc_device_unregister(struct device *dev,
+					struct rtc_device *rtc);
 
 extern int rtc_read_time(struct rtc_device *rtc, struct rtc_time *tm);
 extern int rtc_set_time(struct rtc_device *rtc, struct rtc_time *tm);
-- 
1.7.2.5


