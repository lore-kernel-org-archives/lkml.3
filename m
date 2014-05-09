Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754988AbaEIHnU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 03:43:20 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:9838 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750938AbaEIHnQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 03:43:16 -0400
X-AuditID: cbfee68e-b7fd86d0000038e3-78-536c87131035
From: Chanwoo Choi <cw00.choi@samsung.com>
To: myungjoo.ham@samsung.com, kyungmin.park@samsung.com
Cc: rafael.j.wysocki@intel.com, nm@ti.com, jkosina@suse.cz,
        labbe.montjoie@gmail.com, a.kesavan@samsung.com,
        sreekumar.c@samsung.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCHv2 2/5] devfreq: Add resource-managed function for devfreq device
Date: Fri, 09 May 2014 16:43:08 +0900
Message-id: <1399621391-27228-3-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1399621391-27228-1-git-send-email-cw00.choi@samsung.com>
References: <1399621391-27228-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupjkeLIzCtJLcpLzFFi42JZI2JSoCvcnhNsMGmlhMXjNYuZLK5/ec5q
	sXvOYhaLs01v2C3WL1jIZnF51xw2i8+9RxgtbjeuYLN48+Msk8XjFW/ZLQ4+XMDswO2xc9Zd
	do/Fe14yefRtWcXocWbBEXaP4ze2M3l83iQXwBbFZZOSmpNZllqkb5fAlXHn2DW2gjuKFVe/
	nGFpYHwu3cXIySEhYCIx9eVZdghbTOLCvfVsXYxcHEICSxklzq5+xgxTdODBViYQW0hgEaNE
	/1cLiKImJonzx7cxgiTYBLQk9r+4wQZiiwiYS+xa+hNsErPAC0aJjo2bwCYJCwRIHPv7mqWL
	kYODRUBV4vAMeZAwr4CrxJIJTYwQy+QkPux5BHYRp4CbxPq2CcwQi10lJi/rYoOoOcYuceCq
	IYjNIiAg8W3yIbCREgKyEpsOQN0sKXFwxQ2WCYzCCxgZVjGKphYkFxQnpRcZ6RUn5haX5qXr
	JefnbmIExsXpf8/6djDePGB9iDEZaNxEZinR5HxgXOWVxBsamxlZmJqYGhuZW5qRJqwkzrvo
	YVKQkEB6YklqdmpqQWpRfFFpTmrxIUYmDk6pBsYJQSnbZr9o/72x/tXjh+0XtpZnvtu1SS96
	20mbjYu6WjumfNc/rtIuZbkrZ+KtTWdjm96/rHt+tPKE7t3V/++zb2dnUN99OzZz11Y+w+B4
	iQufCvWm7vx62vMnx4K7+5Qd13495Vp+6opE9PO2714xpv97AngjgqvvpbEzpSz9fXsLt2dP
	spK9EktxRqKhFnNRcSIAE5s1raECAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrDIsWRmVeSWpSXmKPExsVy+t9jAV3h9pxgg9M7+C0er1nMZHH9y3NW
	i91zFrNYnG16w26xfsFCNovLu+awWXzuPcJocbtxBZvFmx9nmSwer3jLbnHw4QJmB26PnbPu
	snss3vOSyaNvyypGjzMLjrB7HL+xncnj8ya5ALaoBkabjNTElNQihdS85PyUzLx0WyXv4Hjn
	eFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKADlRTKEnNKgUIBicXFSvp2mCaEhrjpWsA0Ruj6
	hgTB9RgZoIGENYwZd45dYyu4o1hx9csZlgbG59JdjJwcEgImEgcebGWCsMUkLtxbzwZiCwks
	YpTo/2rRxcgFZDcxSZw/vo0RJMEmoCWx/8UNsCIRAXOJXUt/soEUMQu8YJTo2LiJGSQhLBAg
	cezva5YuRg4OFgFVicMz5EHCvAKuEksmNDFCLJOT+LDnETuIzSngJrG+bQIzxGJXicnLutgm
	MPIuYGRYxSiaWpBcUJyUnmukV5yYW1yal66XnJ+7iREcd8+kdzCuarA4xCjAwajEw/tiSnaw
	EGtiWXFl7iFGCQ5mJRFeqfScYCHelMTKqtSi/Pii0pzU4kOMyUBHTWSWEk3OB6aEvJJ4Q2MT
	MyNLI3NDCyNjc9KElcR5D7ZaBwoJpCeWpGanphakFsFsYeLglGpg9L1q2n3k4Z78MrOZnkr7
	NOZ+nuQ7dYbRzpWTdlZ1ii01vKYTmLl6zraEJBcpC8Gajol2NV+XLjA2W6+xqUBkV4Y2/+nf
	djYfX694zycYJlkh9MxTc8qXlu2Tj+2yufNxqt0r51ZFhknr3pixlp57vI6bPbU/yswh6OzG
	S6HeZdnbr8qJrtVZo8RSnJFoqMVcVJwIAM7mTij/AgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add resource-managed function for devfreq device as following
functions. The devm_devfreq_add_device() manages automatically the memory
of devfreq device using device resource management.
- devm_devfreq_add_device()
- devm_devfreq_remove_device()

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
---
 drivers/devfreq/devfreq.c | 63 +++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/devfreq.h   | 21 +++++++++++++++-
 2 files changed, 83 insertions(+), 1 deletion(-)

diff --git a/drivers/devfreq/devfreq.c b/drivers/devfreq/devfreq.c
index e960eb0..40fe650 100644
--- a/drivers/devfreq/devfreq.c
+++ b/drivers/devfreq/devfreq.c
@@ -659,6 +659,69 @@ int devfreq_remove_device(struct devfreq *devfreq)
 }
 EXPORT_SYMBOL(devfreq_remove_device);
 
+static int devm_devfreq_dev_match(struct device *dev, void *res, void *data)
+{
+	struct devfreq **r = res;
+
+	if (WARN_ON(!r || !*r))
+		return 0;
+
+	return *r == data;
+}
+
+static void devm_devfreq_dev_release(struct device *dev, void *res)
+{
+	devfreq_remove_device(*(struct devfreq **)res);
+}
+
+/**
+ * devm_devfreq_add_device() - Resource-managed devfreq_add_device()
+ * @dev:	the device to add devfreq feature.
+ * @profile:	device-specific profile to run devfreq.
+ * @governor_name:	name of the policy to choose frequency.
+ * @data:	private data for the governor. The devfreq framework does not
+ *		touch this value.
+ *
+ * This function manages automatically the memory of devfreq device using device
+ * resource management and simplify the free operation for memory of devfreq
+ * device.
+ */
+struct devfreq *devm_devfreq_add_device(struct device *dev,
+					struct devfreq_dev_profile *profile,
+					const char *governor_name,
+					void *data)
+{
+	struct devfreq **ptr, *devfreq;
+
+	ptr = devres_alloc(devm_devfreq_dev_release, sizeof(*ptr), GFP_KERNEL);
+	if (!ptr)
+		return ERR_PTR(-ENOMEM);
+
+	devfreq = devfreq_add_device(dev, profile, governor_name, data);
+	if (IS_ERR(devfreq)) {
+		devres_free(ptr);
+		return ERR_PTR(-ENOMEM);
+	}
+
+	*ptr = devfreq;
+	devres_add(dev, ptr);
+
+	return devfreq;
+}
+EXPORT_SYMBOL(devm_devfreq_add_device);
+
+/**
+ * devm_devfreq_remove_device() - Resource-managed devfreq_remove_device()
+ * @dev:	the device to add devfreq feature.
+ * @devfreq:	the devfreq instance to be removed
+ */
+void devm_devfreq_remove_device(struct device *dev, struct devfreq *devfreq)
+{
+	WARN_ON(devres_release(dev, devm_devfreq_dev_release,
+			       devm_devfreq_dev_match, devfreq));
+}
+EXPORT_SYMBOL(devm_devfreq_remove_device);
+
 /**
  * devfreq_suspend_device() - Suspend devfreq of a device.
  * @devfreq: the devfreq instance to be suspended
diff --git a/include/linux/devfreq.h b/include/linux/devfreq.h
index 4dd8cca..3a5fbc3 100644
--- a/include/linux/devfreq.h
+++ b/include/linux/devfreq.h
@@ -223,6 +223,12 @@ extern struct devfreq *devfreq_add_device(struct device *dev,
 				  const char *governor_name,
 				  void *data);
 extern int devfreq_remove_device(struct devfreq *devfreq);
+extern struct devfreq *devm_devfreq_add_device(struct device *dev,
+				  struct devfreq_dev_profile *profile,
+				  const char *governor_name,
+				  void *data);
+extern void devm_devfreq_remove_device(struct device *dev,
+				  struct devfreq *devfreq);
 
 /* Supposed to be called by PM_SLEEP/PM_RUNTIME callbacks */
 extern int devfreq_suspend_device(struct devfreq *devfreq);
@@ -262,7 +268,7 @@ static inline struct devfreq *devfreq_add_device(struct device *dev,
 					  const char *governor_name,
 					  void *data)
 {
-	return NULL;
+	return ERR_PTR(-ENOSYS);
 }
 
 static inline int devfreq_remove_device(struct devfreq *devfreq)
@@ -270,6 +276,19 @@ static inline int devfreq_remove_device(struct devfreq *devfreq)
 	return 0;
 }
 
+static inline struct devfreq *devm_devfreq_add_device(struct device *dev,
+					struct devfreq_dev_profile *profile,
+					const char *governor_name,
+					void *data)
+{
+	return ERR_PTR(-ENOSYS);
+}
+
+static inline void devm_devfreq_remove_device(struct device *dev,
+					struct devfreq *devfreq)
+{
+}
+
 static inline int devfreq_suspend_device(struct devfreq *devfreq)
 {
 	return 0;
-- 
1.8.0

