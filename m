Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753275AbbALMjF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 07:39:05 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:12725 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752416AbbALMfF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 07:35:05 -0500
X-AuditID: cbfee68e-f79b46d000002b74-77-54b3bf744608
From: Chanwoo Choi <cw00.choi@samsung.com>
To: myungjoo.ham@samsung.com, kgene@kernel.org
Cc: kyungmin.park@samsung.com, rafael.j.wysocki@intel.com,
        mark.rutland@arm.com, a.kesavan@samsung.com, tomasz.figa@gmail.com,
        k.kozlowski@samsung.com, b.zolnierkie@samsung.com, robh+dt@kernel.org,
        cw00.choi@samsung.com, inki.dae@samsung.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Subject: [PATCHv8 2/9] devfreq: event: Add resource-managed function for
 devfreq-event device
Date: Mon, 12 Jan 2015 21:34:50 +0900
Message-id: <1421066097-26237-3-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.5.5
In-reply-to: <1421066097-26237-1-git-send-email-cw00.choi@samsung.com>
References: <1421066097-26237-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupnkeLIzCtJLcpLzFFi42JZI2JSpFu6f3OIwSFVi8drFjNZbJyxntXi
	+pfnrBaT7k9gsXj9wtCi//FrZouzTW/YLTY9vsZqcXnXHDaLz71HGC1mnN/HZLH0+kUmi9uN
	K9gsHq94y27RuvcIu8WqXX8YHQQ81sxbw+ixc9Zddo/Fe14yeWxa1cnmsXlJvUffllWMHp83
	yQWwR3HZpKTmZJalFunbJXBlfDh+lbFgomJF1+OZjA2MHTJdjJwcEgImEgt7rjND2GISF+6t
	Z+ti5OIQEljKKDF5yl12mKLtp7uZIBKLGCX2P2hnh3CamCRu9l5kAqliE9CS2P/iBhuILSKg
	J9F5bA9YN7PAHyaJpk0sILawQLzEy+/XwNaxCKhKTLi1EqyeV8BVYs6DKSwQ2xQkli2fyQpi
	cwq4SbzbvQaohgNomavEjfX1IHslBF6yS/xZ28wKMUdA4tvkQywgNRICshKbDkB9IylxcMUN
	lgmMwgsYGVYxiqYWJBcUJ6UXGekVJ+YWl+al6yXn525iBMbT6X/P+nYw3jxgfYhRgINRiYfX
	QmpziBBrYllxZe4hRlOgDROZpUST84FRm1cSb2hsZmRhamJqbGRuaaYkzpsg9TNYSCA9sSQ1
	OzW1ILUovqg0J7X4ECMTB6dUAyNfUv1uresNvfc0OHfW+WwoYjx4bNazi68S2Hv5Vhn7hj4U
	jEi9Ui29/I7Vg5/NTkE1as98bVfmeCrkTtWt8CxNz7bnX2XIpyBiIXi8cpb66v+3zlqU5yg5
	ek01XhcmxNmxTOjbR76eG/u2fzqx6cQO3cpt18NWHXGcY+kSpHtyypPJHZ0Bf5VYijMSDbWY
	i4oTAa6/BXmiAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrFIsWRmVeSWpSXmKPExsVy+t9jAd2S/ZtDDBo+mVg8XrOYyWLjjPWs
	Fte/PGe1mHR/AovF6xeGFv2PXzNbnG16w26x6fE1VovLu+awWXzuPcJoMeP8PiaLpdcvMlnc
	blzBZvF4xVt2i9a9R9gtVu36w+gg4LFm3hpGj52z7rJ7LN7zkslj06pONo/NS+o9+rasYvT4
	vEkugD2qgdEmIzUxJbVIITUvOT8lMy/dVsk7ON453tTMwFDX0NLCXEkhLzE31VbJxSdA1y0z
	B+h4JYWyxJxSoFBAYnGxkr4dpgmhIW66FjCNEbq+IUFwPUYGaCBhDWPGh+NXGQsmKlZ0PZ7J
	2MDYIdPFyMkhIWAisf10NxOELSZx4d56ti5GLg4hgUWMEvsftLNDOE1MEjd7L4JVsQloSex/
	cYMNxBYR0JPoPLaHHcRmFvjDJNG0iQXEFhaIl3j5/RoziM0ioCox4dZKsHpeAVeJOQ+msEBs
	U5BYtnwmK4jNKeAm8W73GqAaDqBlrhI31tdPYORdwMiwilE0tSC5oDgpPddQrzgxt7g0L10v
	OT93EyM4Xp9J7WBc2WBxiFGAg1GJh9dCanOIEGtiWXFl7iFGCQ5mJRFe1zKgEG9KYmVValF+
	fFFpTmrxIUZToKMmMkuJJucDU0leSbyhsYmZkaWRuaGFkbG5kjivkn1biJBAemJJanZqakFq
	EUwfEwenVAPj6RMm2d4FbROXdkwzmdHzbmrM9IB9njM3VdVwTy76qMD8l/nKz5oo/hWr6vZq
	fOUP0uy7kR86/WiY7v1Xa+7sV920zXbuVqYnG87Kqq15l6V61PFobMI771+tzoKTRHfkpjfV
	eFl3PNY3mTfjZcRSq8tNk65LRrxYE9cUJbJ4Rf7CC9kOKtzXlFiKMxINtZiLihMBGAERx+0C	AAA=
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
index 9ba5ba4..57529af 100644
--- a/drivers/devfreq/devfreq-event.c
+++ b/drivers/devfreq/devfreq-event.c
@@ -389,6 +389,69 @@ int devfreq_event_remove_edev(struct devfreq_event_dev *edev)
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
+EXPORT_SYMBOL_GPL(devm_devfreq_event_add_edev);
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
+EXPORT_SYMBOL_GPL(devm_devfreq_event_remove_edev);
+
 /*
  * Device attributes for devfreq-event class.
  */
diff --git a/include/linux/devfreq-event.h b/include/linux/devfreq-event.h
index b7363f5..b6e3afa 100644
--- a/include/linux/devfreq-event.h
+++ b/include/linux/devfreq-event.h
@@ -106,6 +106,10 @@ extern int devfreq_event_get_edev_count(struct device *dev);
 extern struct devfreq_event_dev *devfreq_event_add_edev(struct device *dev,
 				struct devfreq_event_desc *desc);
 extern int devfreq_event_remove_edev(struct devfreq_event_dev *edev);
+extern struct devfreq_event_dev *devm_devfreq_event_add_edev(struct device *dev,
+				struct devfreq_event_desc *desc);
+extern void devm_devfreq_event_remove_edev(struct device *dev,
+				struct devfreq_event_dev *edev);
 
 #else
 static inline int devfreq_event_enable_edev(struct devfreq_event_dev *edev)
@@ -165,6 +169,18 @@ static inline int devfreq_event_remove_edev(struct devfreq_event_dev *edev)
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

