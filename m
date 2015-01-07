Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756011AbbAGXv2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 18:51:28 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:44586 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752315AbbAGXvW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 18:51:22 -0500
X-AuditID: cbfee68f-f791c6d000004834-7e-54adc677ad29
From: Chanwoo Choi <cw00.choi@samsung.com>
To: myungjoo.ham@samsung.com, kgene@kernel.org
Cc: kyungmin.park@samsung.com, rafael.j.wysocki@intel.com,
        mark.rutland@arm.com, a.kesavan@samsung.com, tomasz.figa@gmail.com,
        k.kozlowski@samsung.com, b.zolnierkie@samsung.com, robh+dt@kernel.org,
        cw00.choi@samsung.com, inki.dae@samsung.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Subject: [PATCHv7 02/10] devfreq: event: Add the list of supported
 devfreq-event type
Date: Thu, 08 Jan 2015 08:51:09 +0900
Message-id: <1420674677-3077-3-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.5.5
In-reply-to: <1420674677-3077-1-git-send-email-cw00.choi@samsung.com>
References: <1420674677-3077-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprAIsWRmVeSWpSXmKPExsWyRsSkRLf82NoQg62/zCwer1nMZLFxxnpW
	i+tfnrNaTLo/gcXi9QtDi/7Hr5ktzja9YbfY9Pgaq8XlXXPYLD73HmG0mHF+H5PF0usXmSxu
	N65gs3i84i27ReveI+wWq3b9YXQQ8Fgzbw2jx85Zd9k9Fu95yeSxaVUnm8fmJfUefVtWMXp8
	3iQXwB7FZZOSmpNZllqkb5fAlfFz/y72gv0mFUseBjQwntTuYuTkkBAwkVi2+A47hC0mceHe
	erYuRi4OIYGljBL3181jhCm6//IyK0RiEaPE6qNXmSGcJiaJqYtngLWzCWhJ7H9xgw3EFhHQ
	k+g8tgcszizwh0miaRMLiC0sEC7xZuJKJhCbRUBVom3RdDCbV8BFYvXG16wQ2xQkli2fCWZz
	CrhKLN28kBnEFgKqednzixFksYTAS3aJc1cWM0IMEpD4NvkQ0AIOoISsxKYDzBBzJCUOrrjB
	MoFReAEjwypG0dSC5ILipPQiY73ixNzi0rx0veT83E2MwIg6/e9Z/w7GuwesDzEKcDAq8fAW
	9K0JEWJNLCuuzD3EaAq0YSKzlGhyPjBu80riDY3NjCxMTUyNjcwtzZTEeRdK/QwWEkhPLEnN
	Tk0tSC2KLyrNSS0+xMjEwSnVwDix+O9609DLsno3m1Wut7/uucV3Zt2npHcaQc07a5RX6k9u
	nP3mv3jyy9+NvBnXvWYWS+0ocIwLvttwdXrrKbt3Z+7NzxI2y9jAI7w5Qure3xOrkrTKjSaa
	PA413m21e6Lsgr41rfnHpL142Y/ynjA/vkG/U+7uu6clHpvWn1c/3+Z/VqzqUrkSS3FGoqEW
	c1FxIgA/jwAeowIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrFIsWRmVeSWpSXmKPExsVy+t9jAd3yY2tDDJY+07F4vGYxk8XGGetZ
	La5/ec5qMen+BBaL1y8MLfofv2a2ONv0ht1i0+NrrBaXd81hs/jce4TRYsb5fUwWS69fZLK4
	3biCzeLxirfsFq17j7BbrNr1h9FBwGPNvDWMHjtn3WX3WLznJZPHplWdbB6bl9R79G1Zxejx
	eZNcAHtUA6NNRmpiSmqRQmpecn5KZl66rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+Arltm
	DtDxSgpliTmlQKGAxOJiJX07TBNCQ9x0LWAaI3R9Q4LgeowM0EDCGsaMn/t3sRfsN6lY8jCg
	gfGkdhcjJ4eEgInE/ZeXWSFsMYkL99azdTFycQgJLGKUWH30KjOE08QkMXXxDHaQKjYBLYn9
	L26wgdgiAnoSncf2gMWZBf4wSTRtYgGxhQXCJd5MXMkEYrMIqEq0LZoOZvMKuEis3vgaapuC
	xLLlM8FsTgFXiaWbFzKD2EJANS97fjFOYORdwMiwilE0tSC5oDgpPddIrzgxt7g0L10vOT93
	EyM4Xp9J72Bc1WBxiFGAg1GJh7egb02IEGtiWXFl7iFGCQ5mJRHetW1rQ4R4UxIrq1KL8uOL
	SnNSiw8xmgJdNZFZSjQ5H5hK8kriDY1NzIwsjcwNLYyMzZXEeZXs20KEBNITS1KzU1MLUotg
	+pg4OKUaGJdctSoTrWSbP+uNSPiTo/GvylKt+2IucK+uO1qpvP3Z25SnswuTDlnFxz8L94k4
	GWOSXrJBgK/V/lzen5fd4n+CJywV8DuyRmIe166IeUmcR73+HVyf9Hf7+n9WPxonC+xb+bpy
	zqzrJR3+dUvMPybXF/IedP4/U3j30zcOIeHht7cVznKp/KfEUpyRaKjFXFScCAA1VFpj7QIA	AA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the list of supported devfreq-event type as following.
Each devfreq-event device driver would support the various devfreq-event type
for devfreq governor at the same time.
- DEVFREQ_EVENT_TYPE_RAW_DATA
- DEVFREQ_EVENT_TYPE_UTILIZATION
- DEVFREQ_EVENT_TYPE_BANDWIDTH
- DEVFREQ_EVENT_TYPE_LATENCY

Cc: MyungJoo Ham <myungjoo.ham@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
---
 drivers/devfreq/devfreq-event.c | 58 ++++++++++++++++++++++++++++++++++++-----
 include/linux/devfreq-event.h   | 25 +++++++++++++++---
 2 files changed, 73 insertions(+), 10 deletions(-)

diff --git a/drivers/devfreq/devfreq-event.c b/drivers/devfreq/devfreq-event.c
index 81448ba..64c1764 100644
--- a/drivers/devfreq/devfreq-event.c
+++ b/drivers/devfreq/devfreq-event.c
@@ -20,6 +20,9 @@
 #include <linux/list.h>
 #include <linux/of.h>
 
+#define EVENT_TYPE_RAW_DATA_MAX		ULONG_MAX
+#define EVENT_TYPE_UTILIZATION_MAX	100
+
 static struct class *devfreq_event_class;
 
 /* The list of all devfreq event list */
@@ -132,7 +135,8 @@ EXPORT_SYMBOL_GPL(devfreq_event_is_enabled);
  * Note that this function set the event to the devfreq-event device to start
  * for getting the event data which could be various event type.
  */
-int devfreq_event_set_event(struct devfreq_event_dev *edev)
+int devfreq_event_set_event(struct devfreq_event_dev *edev,
+				enum devfreq_event_type type)
 {
 	int ret;
 
@@ -146,7 +150,15 @@ int devfreq_event_set_event(struct devfreq_event_dev *edev)
 		return -EPERM;
 
 	mutex_lock(&edev->lock);
-	ret = edev->desc->ops->set_event(edev);
+
+	if ((edev->desc->type & type) == 0) {
+		dev_err(&edev->dev, "unsupported devfreq-event type\n");
+		mutex_unlock(&edev->lock);
+		return -EINVAL;
+	}
+
+	ret = edev->desc->ops->set_event(edev, type);
+
 	mutex_unlock(&edev->lock);
 
 	return ret;
@@ -162,6 +174,7 @@ EXPORT_SYMBOL_GPL(devfreq_event_set_event);
  * after stoping the progress of whole sequence of devfreq-event dev.
  */
 int devfreq_event_get_event(struct devfreq_event_dev *edev,
+			    enum devfreq_event_type type,
 			    struct devfreq_event_data *edata)
 {
 	int ret;
@@ -175,18 +188,49 @@ int devfreq_event_get_event(struct devfreq_event_dev *edev,
 	if (!devfreq_event_is_enabled(edev))
 		return -EINVAL;
 
+	mutex_lock(&edev->lock);
+
+	if ((edev->desc->type & type) == 0) {
+		dev_err(&edev->dev, "unsupported devfreq-event type\n");
+		return -EINVAL;
+	}
+
 	edata->event = edata->total_event = 0;
+	ret = edev->desc->ops->get_event(edev, type, edata);
+	if (ret < 0
+		|| edata->total_event <= 0
+		|| edata->event > edata->total_event) {
+		edata->event = edata->total_event = 0;
+		mutex_unlock(&edev->lock);
+		return -EINVAL;
+	}
 
-	mutex_lock(&edev->lock);
-	ret = edev->desc->ops->get_event(edev, edata);
-	mutex_unlock(&edev->lock);
+	switch (type) {
+	case DEVFREQ_EVENT_TYPE_RAW_DATA:
+	case DEVFREQ_EVENT_TYPE_BANDWIDTH:
+	case DEVFREQ_EVENT_TYPE_LATENCY:
+		if ((edata->event > EVENT_TYPE_RAW_DATA_MAX) ||
+			(edata->total_event > EVENT_TYPE_RAW_DATA_MAX)) {
+			edata->event = edata->total_event = 0;
+			ret = -EINVAL;
+		}
+		break;
+	case DEVFREQ_EVENT_TYPE_UTILIZATION:
+		edata->total_event = EVENT_TYPE_UTILIZATION_MAX;
 
-	if ((edata->total_event <= 0)
-		|| (edata->event > edata->total_event)) {
+		if (edata->event > EVENT_TYPE_UTILIZATION_MAX) {
+			edata->event = edata->total_event = 0;
+			ret = -EINVAL;
+		}
+		break;
+	default:
 		edata->event = edata->total_event = 0;
 		ret = -EINVAL;
+		break;
 	}
 
+	mutex_unlock(&edev->lock);
+
 	return ret;
 }
 EXPORT_SYMBOL_GPL(devfreq_event_get_event);
diff --git a/include/linux/devfreq-event.h b/include/linux/devfreq-event.h
index b7363f5..13a5703 100644
--- a/include/linux/devfreq-event.h
+++ b/include/linux/devfreq-event.h
@@ -36,6 +36,14 @@ struct devfreq_event_dev {
 	const struct devfreq_event_desc *desc;
 };
 
+/* The supported type by devfreq-event device */
+enum devfreq_event_type {
+	DEVFREQ_EVENT_TYPE_RAW_DATA	= BIT(0),
+	DEVFREQ_EVENT_TYPE_UTILIZATION	= BIT(1),
+	DEVFREQ_EVENT_TYPE_BANDWIDTH	= BIT(2),
+	DEVFREQ_EVENT_TYPE_LATENCY	= BIT(3),
+};
+
 /**
  * struct devfreq_event_data - the devfreq-event data
  *
@@ -69,8 +77,10 @@ struct devfreq_event_ops {
 	int (*reset)(struct devfreq_event_dev *edev);
 
 	/* Mandatory functions */
-	int (*set_event)(struct devfreq_event_dev *edev);
+	int (*set_event)(struct devfreq_event_dev *edev,
+			 enum devfreq_event_type type);
 	int (*get_event)(struct devfreq_event_dev *edev,
+			 enum devfreq_event_type type,
 			 struct devfreq_event_data *edata);
 };
 
@@ -79,6 +89,10 @@ struct devfreq_event_ops {
  *
  * @name	: the name of devfreq-event device.
  * @driver_data	: the private data for devfreq-event driver.
+ * @event_type	: the supported devfreq-event type among as following
+ *		  - DEVFREQ_EVENT_TYPE_UTILIZATION
+ *		  - DEVFREQ_EVENT_TYPE_BANDWIDTH
+ *		  - DEVFREQ_EVENT_TYPE_LATENCY
  * @ops		: the operation to control devfreq-event device.
  *
  * Each devfreq-event device is described with a this structure.
@@ -87,6 +101,7 @@ struct devfreq_event_ops {
 struct devfreq_event_desc {
 	const char *name;
 	void *driver_data;
+	enum devfreq_event_type type;
 
 	struct devfreq_event_ops *ops;
 };
@@ -95,8 +110,10 @@ struct devfreq_event_desc {
 extern int devfreq_event_enable_edev(struct devfreq_event_dev *edev);
 extern int devfreq_event_disable_edev(struct devfreq_event_dev *edev);
 extern bool devfreq_event_is_enabled(struct devfreq_event_dev *edev);
-extern int devfreq_event_set_event(struct devfreq_event_dev *edev);
+extern int devfreq_event_set_event(struct devfreq_event_dev *edev,
+				enum devfreq_event_type type);
 extern int devfreq_event_get_event(struct devfreq_event_dev *edev,
+				enum devfreq_event_type type,
 				struct devfreq_event_data *edata);
 extern int devfreq_event_reset_event(struct devfreq_event_dev *edev);
 extern void *devfreq_event_get_drvdata(struct devfreq_event_dev *edev);
@@ -123,12 +140,14 @@ static inline bool devfreq_event_is_enabled(struct devfreq_event_dev *edev)
 	return false;
 }
 
-static inline int devfreq_event_set_event(struct devfreq_event_dev *edev)
+static inline int devfreq_event_set_event(struct devfreq_event_dev *edev,
+					enum devfreq_event_type type)
 {
 	return -EINVAL;
 }
 
 static inline int devfreq_event_get_event(struct devfreq_event_dev *edev,
+					enum devfreq_event_type type,
 					struct devfreq_event_data *edata)
 {
 	return -EINVAL;
-- 
1.8.5.5

