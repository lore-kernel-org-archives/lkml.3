Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756136AbbAGXx4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 18:53:56 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:14015 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755557AbbAGXvX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 18:51:23 -0500
X-AuditID: cbfee691-f79b86d000004a5a-85-54adc67740d3
From: Chanwoo Choi <cw00.choi@samsung.com>
To: myungjoo.ham@samsung.com, kgene@kernel.org
Cc: kyungmin.park@samsung.com, rafael.j.wysocki@intel.com,
        mark.rutland@arm.com, a.kesavan@samsung.com, tomasz.figa@gmail.com,
        k.kozlowski@samsung.com, b.zolnierkie@samsung.com, robh+dt@kernel.org,
        cw00.choi@samsung.com, inki.dae@samsung.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Subject: [PATCHv7 03/10] devfreq: event: Add resource-managed function for
 devfreq-event device
Date: Thu, 08 Jan 2015 08:51:10 +0900
Message-id: <1420674677-3077-4-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.5.5
In-reply-to: <1420674677-3077-1-git-send-email-cw00.choi@samsung.com>
References: <1420674677-3077-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupnkeLIzCtJLcpLzFFi42JZI2JSpFtxbG2IwQZvi8drFjNZbJyxntXi
	+pfnrBaT7k9gsXj9wtCi//FrZouzTW/YLTY9vsZqcXnXHDaLz71HGC1mnN/HZLH0+kUmi9uN
	K9gsHq94y27RuvcIu8WqXX8YHQQ81sxbw+ixc9Zddo/Fe14yeWxa1cnmsXlJvUffllWMHp83
	yQWwR3HZpKTmZJalFunbJXBlbHhvX9CpWNGy8iVTA2ODTBcjJ4eEgInEtZ4rbBC2mMSFe+uB
	bC4OIYGljBIz3n1nhClaunwvC0RiEaPEh393oJwmJompi2ewg1SxCWhJ7H9xA2yUiICeROex
	PWBxZoE/TBJNm1hAbGGBRIkTf7aCTWURUJXYuqWbGcTmFXCR2Ha1kQlim4LEsuUzWUFsTgFX
	iaWbF4LVCAHVvOz5xQiyWELgJbvEy/WP2CAGCUh8m3wIaAEHUEJWYtMBZog5khIHV9xgmcAo
	vICRYRWjaGpBckFxUnqRqV5xYm5xaV66XnJ+7iZGYDyd/vds4g7G+wesDzEKcDAq8fAW9K0J
	EWJNLCuuzD3EaAq0YSKzlGhyPjBq80riDY3NjCxMTUyNjcwtzZTEeXWkfwYLCaQnlqRmp6YW
	pBbFF5XmpBYfYmTi4JRqYPQW9ueYcM70xeryKbnaTI1RTPdZX7DMOJW2dZe69t57d5o9rm1/
	ePLpPu6Vtndfypatmb7BR97/xIuvVos6P6w4bfBOJ41vqvWHsI8z5i6s12v14fwh9aKz5N/r
	e4I8Cu8yL9hzL9DqPMar9umbgpH808nX7Oe2PZEy6D1mb3+vNO/gnyNXqr2UWIozEg21mIuK
	EwFGxTcWogIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrFIsWRmVeSWpSXmKPExsVy+t9jAd3yY2tDDDb3mFg8XrOYyWLjjPWs
	Fte/PGe1mHR/AovF6xeGFv2PXzNbnG16w26x6fE1VovLu+awWXzuPcJoMeP8PiaLpdcvMlnc
	blzBZvF4xVt2i9a9R9gtVu36w+gg4LFm3hpGj52z7rJ7LN7zkslj06pONo/NS+o9+rasYvT4
	vEkugD2qgdEmIzUxJbVIITUvOT8lMy/dVsk7ON453tTMwFDX0NLCXEkhLzE31VbJxSdA1y0z
	B+h4JYWyxJxSoFBAYnGxkr4dpgmhIW66FjCNEbq+IUFwPUYGaCBhDWPGhvf2BZ2KFS0rXzI1
	MDbIdDFyckgImEgsXb6XBcIWk7hwbz1bFyMXh5DAIkaJD//usEA4TUwSUxfPYAepYhPQktj/
	4gYbiC0ioCfReWwPWJxZ4A+TRNMmsEnCAokSJ/5sZQSxWQRUJbZu6WYGsXkFXCS2XW1kgtim
	ILFs+UxWEJtTwFVi6eaFYDVCQDUve34xTmDkXcDIsIpRNLUguaA4KT3XSK84Mbe4NC9dLzk/
	dxMjOF6fSe9gXNVgcYhRgINRiYe3oG9NiBBrYllxZe4hRgkOZiUR3rVta0OEeFMSK6tSi/Lj
	i0pzUosPMZoCXTWRWUo0OR+YSvJK4g2NTcyMLI3MDS2MjM2VxHmV7NtChATSE0tSs1NTC1KL
	YPqYODilGhhj99txrdrknvY0Z6fnkpPlRzykeoyjz61tfnzh1e/dribPl6Xz/vr7o2t3t2Zw
	s8T6MMGtz7yY9sw9GiMc97AgW6F030tn43AeHt78qbyn3V989duh83HN6cdrSptUL+dVfr1T
	4vk7t2D3zUr2+qkv2bbJrf98bi6Pzz/JQwxRonPclq+0kNVUYinOSDTUYi4qTgQAEnDspe0C	AAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add the resource-managed function for devfreq-event device as
following functions. The devm_devfreq_event_add_edev() manages automatically
the memory of devfreq-event device using resource management.
- devm_devfreq_event_add_edev()
- devm_devfreq_event_remove_edev()

Cc: Myungjoo Ham <myungjoo.ham@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
---
 drivers/devfreq/devfreq-event.c | 63 +++++++++++++++++++++++++++++++++++++++++
 include/linux/devfreq-event.h   | 16 +++++++++++
 2 files changed, 79 insertions(+)

diff --git a/drivers/devfreq/devfreq-event.c b/drivers/devfreq/devfreq-event.c
index 64c1764..5301e2b 100644
--- a/drivers/devfreq/devfreq-event.c
+++ b/drivers/devfreq/devfreq-event.c
@@ -451,6 +451,69 @@ int devfreq_event_remove_edev(struct devfreq_event_dev *edev)
 }
 EXPORT_SYMBOL_GPL(devfreq_event_remove_edev);
 
+static int devm_devfreq_event_match(struct device *dev, void *res, void *data)
+{
+	struct devfreq_event_dev **r = res;
+
+	if (WARN_ON(!r || !*r))
+		return 0;
+
+	return *r == data;
+}
+
+static void devm_devfreq_event_release(struct device *dev, void *res)
+{
+	devfreq_event_remove_edev(*(struct devfreq_event_dev **)res);
+}
+
+/**
+ * devm_devfreq_event_add_edev() - Resource-managed devfreq_event_add_edev()
+ * @dev		: the device owning the devfreq-event device being created
+ * @desc	: the devfreq-event device's decriptor which include essential
+ *		  data for devfreq-event device.
+ *
+ * Note that this function manages automatically the memory of devfreq-event
+ * device using device resource management and simplify the free operation
+ * for memory of devfreq-event device.
+ */
+struct devfreq_event_dev *devm_devfreq_event_add_edev(struct device *dev,
+						struct devfreq_event_desc *desc)
+{
+	struct devfreq_event_dev **ptr, *edev;
+
+	ptr = devres_alloc(devm_devfreq_event_release, sizeof(*ptr), GFP_KERNEL);
+	if (!ptr)
+		return ERR_PTR(-ENOMEM);
+
+	edev = devfreq_event_add_edev(dev, desc);
+	if (IS_ERR(edev)) {
+		devres_free(ptr);
+		return ERR_PTR(-ENOMEM);
+	}
+
+	*ptr = edev;
+	devres_add(dev, ptr);
+
+	return edev;
+}
+EXPORT_SYMBOL(devm_devfreq_event_add_edev);
+
+/**
+ * devm_devfreq_event_remove_edev()- Resource-managed devfreq_event_remove_edev()
+ * @dev		: the device owning the devfreq-event device being created
+ * @edev	: the devfreq-event device
+ *
+ * Note that this function manages automatically the memory of devfreq-event
+ * device using device resource management.
+ */
+void devm_devfreq_event_remove_edev(struct device *dev,
+				struct devfreq_event_dev *edev)
+{
+	WARN_ON(devres_release(dev, devm_devfreq_event_release,
+			       devm_devfreq_event_match, edev));
+}
+EXPORT_SYMBOL(devm_devfreq_event_remove_edev);
+
 /*
  * Device attributes for devfreq-event class.
  */
diff --git a/include/linux/devfreq-event.h b/include/linux/devfreq-event.h
index 13a5703..3c44ad1 100644
--- a/include/linux/devfreq-event.h
+++ b/include/linux/devfreq-event.h
@@ -123,6 +123,10 @@ extern int devfreq_event_get_edev_count(struct device *dev);
 extern struct devfreq_event_dev *devfreq_event_add_edev(struct device *dev,
 				struct devfreq_event_desc *desc);
 extern int devfreq_event_remove_edev(struct devfreq_event_dev *edev);
+extern struct devfreq_event_dev *devm_devfreq_event_add_edev(struct device *dev,
+				struct devfreq_event_desc *desc);
+extern void devm_devfreq_event_remove_edev(struct device *dev,
+				struct devfreq_event_dev *edev);
 
 #else
 static inline int devfreq_event_enable_edev(struct devfreq_event_dev *edev)
@@ -184,6 +188,18 @@ static inline int devfreq_event_remove_edev(struct devfreq_event_dev *edev)
 {
 	return -EINVAL;
 }
+
+static inline struct devfreq_event_dev *devm_devfreq_event_add_edev(
+					struct device *dev,
+					struct devfreq_event_desc *desc)
+{
+	return ERR_PTR(-EINVAL);
+}
+
+static inline void devm_devfreq_event_remove_edev(struct device *dev,
+					struct devfreq_event_dev *edev)
+{
+}
 #endif /* CONFIG_PM_DEVFREQ_EVENT */
 
 #endif /* __LINUX_DEVFREQ_EVENT_H__ */
-- 
1.8.5.5

