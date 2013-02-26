Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760005Ab3BZBuB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 20:50:01 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:33437 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758303Ab3BZBuA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 20:50:00 -0500
X-AuditID: cbfee690-b7f6b6d000004563-5f-512c14c6154b
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Tejun Heo'" <tj@kernel.org>,
        "'Greg KH'" <greg@kroah.com>,
        "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH v3] rtc: add devm_rtc_device_{register,unregister}()
Date: Tue, 26 Feb 2013 10:49:57 +0900
Message-id: <009001ce13c3$9504bff0$bf0e3fd0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4Tw5Tl8LnUauaRRFO4J+k+4bUCfQ==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrEIsWRmVeSWpSXmKPExsVy+t8zA91jIjqBBt8vCVgsuXiV3WLO+jVs
	FucWzGC0uLzwEqvF5V1z2Cz2d3YwWvxafpTRgd1jz8STbB6bVnWyebx9GOBxYsZvFo++LasY
	PabP+8nk8XmTXAB7FJdNSmpOZllqkb5dAlfG85XrmAvaZCvO7G5nbmB8I97FyMEhIWAi0d5V
	0MXICWSKSVy4t56ti5GLQ0hgGaPEn9NP2CASJhJ/559hgkhMZ5Q4u+UgI4Tzi1Fi45S5zCBV
	bAJqEl++HGYHmSoioC/R1qIBUsMscIJR4tOLg6wgNcICLhKTWy+ATWURUJWYvvo/I4jNK2Ar
	sa+9EcoWlPgx+R4LiM0soCWxfudxJghbXmLzmrfMEFerSzz6qwsSFhHQk+jYdY4RokREYt+L
	d2C3SQi8ZJe4uHsaK8QuAYlvkw+xQPTKSmw6wAzxmKTEwRU3WCYwis1CsnkWks2zkGyehWTF
	AkaWVYyiqQXJBcVJ6UUmesWJucWleel6yfm5mxgh8TlhB+O9A9aHGJOB1k9klhJNzgfGd15J
	vKGxsYmZiamJuaWpuSlpwkrivPKXZAKFBNITS1KzU1MLUovii0pzUosPMTJxcEo1MCY6iH05
	lMJzYhXzvPwLbSVu78snp+pebIqI0ylqmvfzaId+mLq1C/+Klre6j22WuVzf1vL8oE1X9/VI
	PxWnF8c0GXhXes695cvwadHlfHOjv+a+Qc8iLOZHPxZektogaOCn+OqFkOBvY9P/G/P4VAQ8
	Uysb1gso7YllEVxZujaxdsXskOkOSizFGYmGWsxFxYkAZg6oqeUCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrAKsWRmVeSWpSXmKPExsVy+t9jQd1jIjqBBtMauS2WXLzKbjFn/Ro2
	i3MLZjBaXF54idXi8q45bBb7OzsYLX4tP8rowO6xZ+JJNo9NqzrZPN4+DPA4MeM3i0ffllWM
	HtPn/WTy+LxJLoA9qoHRJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VW
	ycUnQNctMwfoICWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFBcD1GBmggYR1jxvOV65gL
	2mQrzuxuZ25gfCPexcjJISFgIvF3/hkmCFtM4sK99WxdjFwcQgLTGSXObjnICOH8YpTYOGUu
	M0gVm4CaxJcvh9m7GDk4RAT0JdpaNEBqmAVOMEp8enGQFaRGWMBFYnLrBTYQm0VAVWL66v+M
	IDavgK3EvvZGKFtQ4sfkeywgNrOAlsT6nceZIGx5ic1r3jKDzJcQUJd49FcXJCwioCfRsesc
	I0SJiMS+F+8YJzAKzEIyaRaSSbOQTJqFpGUBI8sqRtHUguSC4qT0XEO94sTc4tK8dL3k/NxN
	jOD4fya1g3Flg8UhRgEORiUe3gQWnUAh1sSy4srcQ4wSHMxKIrycGdqBQrwpiZVVqUX58UWl
	OanFhxiTgR6dyCwlmpwPTE15JfGGxiZmRpZGZhZGJubmpAkrifMynnoSICSQnliSmp2aWpBa
	BLOFiYNTqoFR88NP1sRNQSt0Pv7LMXRn/Hhu83GjhxOmKNvnT+XW91Nv4vWVLliW/egL15u3
	G9TmSW43SLjc65HjnZXyyMVz9m5LYfe5V5nzfgftfrMh5rzIWQe7J0Ec+pznJp6W802pEtuz
	MGuh03zBZaK6dsKcRmypXr9CruT57TZdxj1FUlShfsNZjbdKLMUZiYZazEXFiQBDnuOAQwMA	AA==
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
Changes since v2:
- Removed unnecessary WARN_ON() of devm_rtc_device_match()

Changes since v1:
- Simplified 'if' statements using WARN_ON()
- Added a description of the return value of devm_rtc_device_register()

 drivers/rtc/class.c |   70 +++++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/rtc.h |    6 ++++
 2 files changed, 76 insertions(+), 0 deletions(-)

diff --git a/drivers/rtc/class.c b/drivers/rtc/class.c
index 9b742d3..b72b40b 100644
--- a/drivers/rtc/class.c
+++ b/drivers/rtc/class.c
@@ -259,6 +259,76 @@ void rtc_device_unregister(struct rtc_device *rtc)
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


