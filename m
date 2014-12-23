Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754702AbaLWDSe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 22:18:34 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:20492 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754518AbaLWDSW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 22:18:22 -0500
X-AuditID: cbfee68f-f791c6d000004834-21-5498defb11dd
From: Chanwoo Choi <cw00.choi@samsung.com>
To: myungjoo.ham@samsung.com
Cc: kgene.kim@samsung.com, kyungmin.park@samsung.com,
        rafael.j.wysocki@intel.com, mark.rutland@arm.com,
        a.kesavan@samsung.com, tomasz.figa@gmail.com, k.kozlowski@samsung.com,
        cw00.choi@samsung.com, inki.dae@samsung.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Subject: [PATCHv5 2/9] devfreq: event: Add the list of supported devfreq-event
 type
Date: Tue, 23 Dec 2014 12:18:10 +0900
Message-id: <1419304697-14789-3-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.5.5
In-reply-to: <1419304697-14789-1-git-send-email-cw00.choi@samsung.com>
References: <1419304697-14789-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpnkeLIzCtJLcpLzFFi42JZI2JSrPv73owQg5ZWFYvHaxYzWVz/8pzV
	Yv6Rc6wWk+5PYLF4/cLQonfBVTaLs01v2C02Pb7GanF51xw2i8+9RxgtZpzfx2Sx9PpFJovb
	jSvYLB6veMtusWrXH0YHfo8189YweuycdZfdY/Gel0wem5fUe/RtWcXo8XmTXABbFJdNSmpO
	Zllqkb5dAlfG0l3HmQsOmlScbJNrYDyt3cXIySEhYCIx40k/C4QtJnHh3nq2LkYuDiGBpYwS
	dw8fZIIpavy2ACqxiFGifcVqdginiUni76GvYFVsAloS+1/cYAOxRQRkJK5u3M4CUsQs0Mgs
	8WXZf7AiYYFQiQmtm1hBbBYBVYmV658xgti8Aq4SnzZ9ZoVYpyCxbPlMMJtTwE3iz7ynYLYQ
	UM3EjutMIEMlBK6xS3T0bGWEGCQg8W3yIaBtHEAJWYlNB5gh5khKHFxxg2UCo/ACRoZVjKKp
	BckFxUnpRcZ6xYm5xaV56XrJ+bmbGIHxc/rfs/4djHcPWB9iFOBgVOLhXXBmRogQa2JZcWXu
	IUZToA0TmaVEk/OBUZpXEm9obGZkYWpiamxkbmmmJM67UOpnsJBAemJJanZqakFqUXxRaU5q
	8SFGJg5OqQbGSR9ubDt7hVnXYeeJxMYC9X1+vnz/p73TO2m0+tDHack+1uvLPLh4p/ZnH/jm
	9vfoqYCWf2vuVFg7v5f70OHrv89H/rSYqXfkm8qwLyJa+1Rn/vvtp/J+3gPxiZzHHmmdXP+K
	xVFwld3nYuFXAYr/7nisY+X6MOlmnULK5s+O5/WP72SO/hD0QImlOCPRUIu5qDgRAMPDwOWa	AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrIIsWRmVeSWpSXmKPExsVy+t9jAd3f92aEGPzqkrJ4vGYxk8X1L89Z
	LeYfOcdqMen+BBaL1y8MLXoXXGWzONv0ht1i0+NrrBaXd81hs/jce4TRYsb5fUwWS69fZLK4
	3biCzeLxirfsFqt2/WF04PdYM28No8fOWXfZPRbvecnksXlJvUffllWMHp83yQWwRTUw2mSk
	JqakFimk5iXnp2TmpdsqeQfHO8ebmhkY6hpaWpgrKeQl5qbaKrn4BOi6ZeYAnaykUJaYUwoU
	CkgsLlbSt8M0ITTETdcCpjFC1zckCK7HyAANJKxhzFi66zhzwUGTipNtcg2Mp7W7GDk5JARM
	JBq/LWCDsMUkLtxbD2RzcQgJLGKUaF+xmh3CaWKS+HvoKxNIFZuAlsT+FzfAOkQEZCSubtzO
	AlLELNDILPFl2X+wImGBUIkJrZtYQWwWAVWJleufMYLYvAKuEp82fWaFWKcgsWz5TDCbU8BN
	4s+8p2C2EFDNxI7rTBMYeRcwMqxiFE0tSC4oTkrPNdIrTswtLs1L10vOz93ECI7OZ9I7GFc1
	WBxiFOBgVOLhXXBmRogQa2JZcWXuIUYJDmYlEV71VqAQb0piZVVqUX58UWlOavEhRlOgqyYy
	S4km5wMTR15JvKGxiZmRpZG5oYWRsbmSOK+SfVuIkEB6YklqdmpqQWoRTB8TB6dUA6PIjwt/
	1q3STZM+yVTT1r3kMCf3pSDVujWcLHbvLYSWeTF5LzxyqWXqHUd14bh35tznBbt3TP7QkFl/
	amG77A3NSy6WM3wn6l+pszbcsmLRvO8ypkzZkko6Z110gp391C+HnQ/bYHD93PmH51cne1at
	ORKiqGRwRfxx6cL/Cz/oipSc0eo9PUuJpTgj0VCLuag4EQCXpc675AIAAA==
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
index ac426d5..1a87a16 100644
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
@@ -123,12 +140,14 @@ static inline bool devfreq_event_is_enabled(struct devfreq_event_dev *edev);
 	return false;
 }
 
-static inline int devfreq_event_set_event(struct devfreq_event_dev *edev);
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

