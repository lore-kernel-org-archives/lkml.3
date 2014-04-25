Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752946AbaDYJJf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 05:09:35 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:13336 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752806AbaDYJIY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 05:08:24 -0400
X-AuditID: cbfee68d-b7f4e6d000004845-dd-535a260137b4
From: Chanwoo Choi <cw00.choi@samsung.com>
To: myungjoo.ham@samsung.com, kyungmin.park@samsung.com
Cc: rafael.j.wysocki@intel.com, nm@ti.com, cw00.choi@samsung.com,
        jkosina@suse.cz, labbe.montjoie@gmail.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/5] devfreq: Add resource-managed function for devfreq device
Date: Fri, 25 Apr 2014 18:08:11 +0900
Message-id: <1398416894-6782-3-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1398416894-6782-1-git-send-email-cw00.choi@samsung.com>
References: <1398416894-6782-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpjkeLIzCtJLcpLzFFi42JZI2JSoMuoFhVssHaxisX1L89ZLXbPWcxi
	cbbpDbvF+gUL2Swu75rDZvG59wijxe3GFWwWb36cZbJ4vOItuwOnx85Zd9k9Fu95yeTRt2UV
	o8eZBUfYPY7f2M7k8XmTXABbFJdNSmpOZllqkb5dAldGx67JzAVvFCs+7TzO3MD4UbqLkZND
	QsBEYuL/b2wQtpjEhXvrgWwuDiGBpYwS17qXMsEU/T8zkwkisYhRYvO6iVBOE5PExS+f2UGq
	2AS0JPa/uAE2SkTAXGLX0p9gNrPAckaJrXPDQGxhAT+JN4+Wg01lEVCVmPa8hxXE5hVwkbj4
	B+YMOYkPex6BzeQUcJVo//kWrEYIqKbx8St2kMUSApvYJW7+W8EIMUhA4tvkQyxdjBxACVmJ
	TQeYIeZIShxccYNlAqPwAkaGVYyiqQXJBcVJ6UWGesWJucWleel6yfm5mxiBcXD637PeHYy3
	D1gfYkwGGjeRWUo0OR8YR3kl8YbGZkYWpiamxkbmlmakCSuJ8yY9TAoSEkhPLEnNTk0tSC2K
	LyrNSS0+xMjEwSnVwGjd0/nub+ihWXN1W6Kzj8zYvHO218J/ceGnpopqPVz+9byK08HWfJmp
	s2W/xS5of/yoZUrn3S4ZRmnvU63T+JuKOyzPLvvfxtY928BT/uyaxJuT7vacso7WPzXfJnWp
	0pFIQSMbNReXq6lS8xQFX/VWLQw1PizluOW0C2eySX//EffwJObdPUosxRmJhlrMRcWJABh+
	qTuZAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMIsWRmVeSWpSXmKPExsVy+t9jAV1Gtahgg/l7pS2uf3nOarF7zmIW
	i7NNb9gt1i9YyGZxedccNovPvUcYLW43rmCzePPjLJPF4xVv2R04PXbOusvusXjPSyaPvi2r
	GD3OLDjC7nH8xnYmj8+b5ALYohoYbTJSE1NSixRS85LzUzLz0m2VvIPjneNNzQwMdQ0tLcyV
	FPISc1NtlVx8AnTdMnOAzlJSKEvMKQUKBSQWFyvp22GaEBripmsB0xih6xsSBNdjZIAGEtYw
	ZnTsmsxc8Eax4tPO48wNjB+luxg5OSQETCT+n5nJBGGLSVy4t56ti5GLQ0hgEaPE5nUTmSCc
	JiaJi18+s4NUsQloSex/cYMNxBYRMJfYtfQnmM0ssJxRYuvcMBBbWMBP4s2j5WBTWQRUJaY9
	72EFsXkFXCQu/vnGBrFNTuLDnkdgMzkFXCXaf74FqxECqml8/Ip9AiPvAkaGVYyiqQXJBcVJ
	6bmGesWJucWleel6yfm5mxjBUfZMagfjygaLQ4wCHIxKPLwf1CKDhVgTy4orcw8xSnAwK4nw
	zpCIChbiTUmsrEotyo8vKs1JLT7EmAx01URmKdHkfGACyCuJNzQ2MTOyNDI3tDAyNidNWEmc
	90CrdaCQQHpiSWp2ampBahHMFiYOTqkGRt2kFT+bA/89tgq48C3TdW9K1vvII9ckJk5/ox90
	7X27t4KewwndY4Etx3bPui7J+eGh90kJnycs2/JtPzBvZUs08L+kle1b0BoyR/US89JNXJuY
	pnn+1pPr0Nu7InpN0cINRzbIWaf2r89JNH89Y26AouTtq87RxWlltl5/LGSbgrijyqf1KbEU
	ZyQaajEXFScCAOhRC9X2AgAA
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
index e960eb0..0b80b60 100644
--- a/drivers/devfreq/devfreq.c
+++ b/drivers/devfreq/devfreq.c
@@ -659,6 +659,69 @@ int devfreq_remove_device(struct devfreq *devfreq)
 }
 EXPORT_SYMBOL(devfreq_remove_device);
 
+static int devm_devfreq_dev_match(struct device *dev, void *res, void *data)
+{
+	struct devfreq **r = res;
+	if (!r || !*r) {
+		WARN_ON(!r || !*r);
+		return 0;
+	}
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
index 4dd8cca..45c29db 100644
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
+	return ERR_PTR(-ENOMEM);
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
+	return ERR_PTR(-ENOMEM);
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

