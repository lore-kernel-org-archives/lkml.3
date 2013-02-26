Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760032Ab3BZBVO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 20:21:14 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:48063 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751878Ab3BZBVL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 20:21:11 -0500
X-AuditID: cbfee690-b7f6b6d000004563-2e-512c0e034bb1
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Tejun Heo'" <tj@kernel.org>,
        "'Greg KH'" <greg@kroah.com>,
        "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH V2] rtc: add devm_rtc_device_{register,unregister}()
Date: Tue, 26 Feb 2013 10:21:06 +0900
Message-id: <008c01ce13bf$8d2cd550$a7867ff0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4Tv4zwa5T+1xKSRRS0i/CcbKGXyQ==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrMIsWRmVeSWpSXmKPExsVy+t8zI11mPp1Ag4nd7BZLLl5lt5izfg2b
	xbkFMxgtLi+8xGpxedccNov9nR2MFr+WH2V0YPfYM/Ekm8emVZ1sHm8fBnicmPGbxaNvyypG
	j+nzfjJ5fN4kF8AexWWTkpqTWZZapG+XwJVx+vsHpoJ7MhVbbrUwNjAeE+9i5OSQEDCROHhv
	FiOELSZx4d56ti5GLg4hgWWMEjNa1rLDFC1e2AmVmM4osePQRyYI5xejxOcFy1lBqtgE1CS+
	fDkM1MHBISKgL9HWogFSwyxwglHi04uDYDXCAi4S3/79BVvHIqAqcejVVrA4r4CtxOFHa1kg
	bEGJH5PvgdnMAloS63ceZ4Kw5SU2r3nLDDJfQkBd4tFfXZCwiICexPGm91AlIhL7XrxjBNkr
	IfCIXeLK1pdsELsEJL5NPsQC0SsrsekAM8RjkhIHV9xgmcAoNgvJ5llINs9CsnkWkhULGFlW
	MYqmFiQXFCelF5noFSfmFpfmpesl5+duYoRE6IQdjPcOWB9iTAZaP5FZSjQ5HxjheSXxhsbG
	JmYmpibmlqbmpqQJK4nzyl+SCRQSSE8sSc1OTS1ILYovKs1JLT7EyMTBKdXAGPGxq+FR+b4X
	ZlOdnu8QdpBurntuo39UW/H2iX1+j1f4HJm6dKXXqdqcw7LS1xTXf57KMueEgO3p6Fx57b99
	z2u4hdfN4H7qzvvin8htN1muQmX9RQG3py3+GtZ+/W1K2pQZtj3FL1fo3pxw4VXWbImOO8wG
	//dUpMzsfrJwztF5059qebestFBiKc5INNRiLipOBABJif4/5gIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrAKsWRmVeSWpSXmKPExsVy+t9jQV1mPp1Ag+eHGS2WXLzKbjFn/Ro2
	i3MLZjBaXF54idXi8q45bBb7OzsYLX4tP8rowO6xZ+JJNo9NqzrZPN4+DPA4MeM3i0ffllWM
	HtPn/WTy+LxJLoA9qoHRJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VW
	ycUnQNctMwfoICWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFBcD1GBmggYR1jxunvH5gK
	7slUbLnVwtjAeEy8i5GTQ0LARGLxwk42CFtM4sK99UA2F4eQwHRGiR2HPjJBOL8YJT4vWM4K
	UsUmoCbx5cth9i5GDg4RAX2JthYNkBpmgROMEp9eHASrERZwkfj27y8jiM0ioCpx6NVWsDiv
	gK3E4UdrWSBsQYkfk++B2cwCWhLrdx5ngrDlJTavecsMMl9CQF3i0V9dkLCIgJ7E8ab3UCUi
	EvtevGOcwCgwC8mkWUgmzUIyaRaSlgWMLKsYRVMLkguKk9JzDfWKE3OLS/PS9ZLzczcxguP/
	mdQOxpUNFocYBTgYlXh4E1h0AoVYE8uKK3MPMUpwMCuJ8HJmaAcK8aYkVlalFuXHF5XmpBYf
	YkwGenQis5Rocj4wNeWVxBsam5gZWRqZWRiZmJuTJqwkzst46kmAkEB6YklqdmpqQWoRzBYm
	Dk6pBsasjGYzjaLw3donL4Q4PmiOeVYxQ1VltfTxY0+LlqhVeWz5N2++jp5R7YnTRm375+Vk
	/Pux0OXL67I61ZwPU/32L9uUKKJps4u55gwD0/flb5knqoQfWn+KN/3lpRd/FRNea4elyk9N
	Xns5c8FO0Z07rjivs9WR2h39+uQUx5ONeqz+y1SKQkWVWIozEg21mIuKEwElJP1EQwMAAA==
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
Changes since v1:
- Simplified 'if' statements using WARN_ON()
- Added a description of the return value of devm_rtc_device_register()

 drivers/rtc/class.c |   72 +++++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/rtc.h |    6 ++++
 2 files changed, 78 insertions(+), 0 deletions(-)

diff --git a/drivers/rtc/class.c b/drivers/rtc/class.c
index 9b742d3..31496bc 100644
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
+	if (WARN_ON(!r || !*r))
+		return 0;
+
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
+ * @return a struct rtc on success, or an ERR_PTR on error
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
+	WARN_ON(rc);
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


