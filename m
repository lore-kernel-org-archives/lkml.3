Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757473AbaLIOQV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 09:16:21 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:26705 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753185AbaLIONO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 09:13:14 -0500
X-AuditID: cbfee68d-f79296d000004278-08-54870374acc3
From: Chanwoo Choi <cw00.choi@samsung.com>
To: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: myungjoo.ham@samsung.com, kyungmin.park@samsung.com, kgene.kim@samsung.com,
        rafael.j.wysocki@intel.com, a.kesavan@samsung.com,
        tomasz.figa@gmail.com, b.zolnierkie@samsung.com,
        k.kozlowski@samsung.com, cw00.choi@samsung.com,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Subject: [RFC PATCHv2 3/7] devfreq: event: Add the exclusive flag for
 devfreq-event device
Date: Tue, 09 Dec 2014 23:13:02 +0900
Message-id: <1418134386-14681-4-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.5.5
In-reply-to: <1418134386-14681-1-git-send-email-cw00.choi@samsung.com>
References: <1418134386-14681-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrLLMWRmVeSWpSXmKPExsWyRsSkULeEuT3EYO5iYYvHaxYzWWycsZ7V
	4vqX56wW84+cY7V4/cLQonfBVTaLs01v2C02Pb7GanF51xw2i8+9RxgtZpzfx2Rxu3EFm8Xj
	FW/ZLVbt+sPowOexc9Zddo/Fe14yeWxeUu/Rt2UVo8fnTXIBrFFcNimpOZllqUX6dglcGTOm
	vGMteKRTcWTJSeYGxh+qXYwcHBICJhIbNvl1MXICmWISF+6tZ+ti5OIQEljKKDFx4Td2iISJ
	RP/RGSwQiUWMEldOv2aGcJqYJN7s2s0KUsUmoCWx/8UNNhBbRMBK4vT/DrAiZoHzTBJLFu5n
	BkkIC8RIfH//AsxmEVCVmPpwK1gDr4CrxIVHT6DWKUgsWz4TbCingJtE0+5GFhBbCKjmw4lW
	dpChEgKn2CWObu1hhBgkIPFt8iEWiH9kJTYdYIaYIylxcMUNlgmMwgsYGVYxiqYWJBcUJ6UX
	GeoVJ+YWl+al6yXn525iBMbK6X/Pencw3j5gfYhRgINRiYdXw7ItRIg1say4MvcQoynQhonM
	UqLJ+cCIzCuJNzQ2M7IwNTE1NjK3NFMS51WU+hksJJCeWJKanZpakFoUX1Sak1p8iJGJg1Oq
	gZFt6RQ5Nj/t9gVhbGbbXyxqXGYosrCse9mkkP3ZO7d8Epk7XdrlG2tlff9Er3P/v97fucs2
	IvvC+5dH/GxfsDy66ajBFyPw4Wu5UeeszWLKyRrfnByiVte83vOYl3H6+yPFIjbLApStDR2e
	ReX+/xOUHGF03sHgh9U93qbN2TudJjBPYzX13qTEUpyRaKjFXFScCADgvI2kkAIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrBIsWRmVeSWpSXmKPExsVy+t9jAd0S5vYQg29POS0er1nMZLFxxnpW
	i+tfnrNazD9yjtXi9QtDi94FV9kszja9YbfY9Pgaq8XlXXPYLD73HmG0mHF+H5PF7cYVbBaP
	V7xlt1i16w+jA5/Hzll32T0W73nJ5LF5Sb1H35ZVjB6fN8kFsEY1MNpkpCampBYppOYl56dk
	5qXbKnkHxzvHm5oZGOoaWlqYKynkJeam2iq5+AToumXmAB2qpFCWmFMKFApILC5W0rfDNCE0
	xE3XAqYxQtc3JAiux8gADSSsYcyYMeUda8EjnYojS04yNzD+UO1i5OSQEDCR6D86gwXCFpO4
	cG89WxcjF4eQwCJGiSunXzNDOE1MEm927WYFqWIT0JLY/+IGG4gtImAlcfp/B1gRs8B5Jokl
	C/czgySEBWIkvr9/AWazCKhKTH24FayBV8BV4sKjJ+wQ6xQkli2fCTaUU8BNoml3I9gZQkA1
	H060sk9g5F3AyLCKUTS1ILmgOCk911CvODG3uDQvXS85P3cTIzgWn0ntYFzZYHGIUYCDUYmH
	V9OyLUSINbGsuDL3EKMEB7OSCO+Uo0Ah3pTEyqrUovz4otKc1OJDjKZAV01klhJNzgemibyS
	eENjEzMjSyNzQwsjY3MlcV4le6AmgfTEktTs1NSC1CKYPiYOTqkGxr7lM55O8Kr4Yhh96/yb
	B9ptTK0LLL3nLhH+m83K/dJMdE2Q44lk34efzJeVPfx5WGsf75HKu58X8b3e+cO6YlP5IqGW
	Sdq2d/lfrWp8v1uie3vIgxkzp/FFLGRjZWzae+q4jmNSw6OTy99OcaoK+Gz8eNXRVTtUy16d
	97f/L6Zkeee7UJpKCoMSS3FGoqEWc1FxIgCRgtah2wIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the exclusive flag for devfreq-event device. If the specific
devfreq-event device should be used in only one devfreq device driver,
devfreq driver have to use 'devfreq_enable_event_dev_exclusive()' function
to consist integrity of event data.

Cc: MyungJoo Ham <myungjoo.ham@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
---
 drivers/devfreq/devfreq-event.c | 44 +++++++++++++++++++++++++++++++++++++++++
 include/linux/devfreq.h         | 17 ++++++++++++++++
 2 files changed, 61 insertions(+)

diff --git a/drivers/devfreq/devfreq-event.c b/drivers/devfreq/devfreq-event.c
index a71fcee..e7ce5ba 100644
--- a/drivers/devfreq/devfreq-event.c
+++ b/drivers/devfreq/devfreq-event.c
@@ -142,6 +142,9 @@ int devfreq_enable_event_dev(struct devfreq_event_dev *event_dev)
 	if (!event_dev || !event_dev->desc)
 		return -EINVAL;
 
+	if (event_dev->event_flag & DEVFREQ_EVENT_FLAG_EXCLUSIVE)
+		return -EBUSY;
+
 	mutex_lock(&event_dev->lock);
 	if (event_dev->desc->ops && event_dev->desc->ops->enable) {
 		ret = event_dev->desc->ops->enable(event_dev);
@@ -156,6 +159,29 @@ err:
 }
 EXPORT_SYMBOL_GPL(devfreq_enable_event_dev);
 
+int devfreq_enable_event_dev_exclusive(struct devfreq_event_dev *event_dev)
+{
+	int ret;
+
+	if (!event_dev || !event_dev->desc)
+		return -EINVAL;
+
+	if (event_dev->event_flag & DEVFREQ_EVENT_FLAG_EXCLUSIVE)
+		return -EBUSY;
+
+	ret = devfreq_enable_event_dev(event_dev);
+	if (ret < 0)
+		return ret;
+
+	/* Set exclusive flag to devfreq-event device */
+	mutex_lock(&event_dev->lock);
+	event_dev->event_flag |= DEVFREQ_EVENT_FLAG_EXCLUSIVE;
+	mutex_unlock(&event_dev->lock);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(devfreq_enable_event_dev_exclusive);
+
 int devfreq_disable_event_dev(struct devfreq_event_dev *event_dev)
 {
 	int ret = 0;
@@ -163,6 +189,9 @@ int devfreq_disable_event_dev(struct devfreq_event_dev *event_dev)
 	if (!event_dev || !event_dev->desc)
 		return -EINVAL;
 
+	if (event_dev->event_flag & DEVFREQ_EVENT_FLAG_EXCLUSIVE)
+		return -EBUSY;
+
 	mutex_lock(&event_dev->lock);
 	if (event_dev->enable_count > 0) {
 		event_dev->enable_count--;
@@ -196,6 +225,9 @@ bool devfreq_is_enabled_event_dev(struct devfreq_event_dev *event_dev)
 	if (!(event_dev->enable_count > 0))
 		return enabled;
 
+	if (event_dev->event_flag & DEVFREQ_EVENT_FLAG_EXCLUSIVE)
+		return -EBUSY;
+
 	if (event_dev->desc->ops && event_dev->desc->ops->is_enabled)
 		enabled = event_dev->desc->ops->is_enabled(event_dev);
 
@@ -212,6 +244,9 @@ int devfreq_set_event_event_dev(struct devfreq_event_dev *event_dev,
 	if (!devfreq_is_enabled_event_dev(event_dev))
 		return -EPERM;
 
+	if (event_dev->event_flag & DEVFREQ_EVENT_FLAG_EXCLUSIVE)
+		return -EBUSY;
+
 	if ((event_dev->desc->event_type & event_type) == 0) {
 		dev_err(&event_dev->dev, "unsupported of devfreq-event type\n");
 		return -EINVAL;
@@ -236,6 +271,9 @@ int devfreq_get_event_event_dev(struct devfreq_event_dev *event_dev,
 	if (!devfreq_is_enabled_event_dev(event_dev))
 		return -EPERM;
 
+	if (event_dev->event_flag & DEVFREQ_EVENT_FLAG_EXCLUSIVE)
+		return -EBUSY;
+
 	if ((event_dev->desc->event_type & event_type) == 0) {
 		dev_err(&event_dev->dev, "unsupported of devfreq-event type\n");
 		return -EINVAL;
@@ -259,6 +297,9 @@ int devfreq_reset_event_dev(struct devfreq_event_dev *event_dev)
 	if (!devfreq_is_enabled_event_dev(event_dev))
 		return -EPERM;
 
+	if (event_dev->event_flag & DEVFREQ_EVENT_FLAG_EXCLUSIVE)
+		return -EBUSY;
+
 	if (event_dev->desc->ops && event_dev->desc->ops->reset)
 		return event_dev->desc->ops->reset(event_dev);
 
@@ -268,6 +309,9 @@ EXPORT_SYMBOL_GPL(devfreq_reset_event_dev);
 
 void *event_dev_get_drvdata(struct devfreq_event_dev *event_dev)
 {
+	if (event_dev->event_flag & DEVFREQ_EVENT_FLAG_EXCLUSIVE)
+		return ERR_PTR(-EBUSY);
+
 	return event_dev->desc->driver_data;
 }
 EXPORT_SYMBOL_GPL(event_dev_get_drvdata);
diff --git a/include/linux/devfreq.h b/include/linux/devfreq.h
index f6d44b7..e7fedea 100644
--- a/include/linux/devfreq.h
+++ b/include/linux/devfreq.h
@@ -175,6 +175,12 @@ struct devfreq {
 	unsigned long last_stat_updated;
 };
 
+/* The supported flags by devfreq-event device */
+enum devfreq_event_flag {
+	DEVFREQ_EVENT_FLAG_NONE		= BIT(0),
+	DEVFREQ_EVENT_FLAG_EXCLUSIVE	= BIT(1),
+};
+
 /**
  * struct devfreq_event_dev - the devfreq-event device 
  *
@@ -194,6 +200,9 @@ struct devfreq_event_dev {
 	struct mutex lock;
 	u32 enable_count;
 
+	enum devfreq_event_flag event_flag;
+	unsigned int enabled_count;
+
 	const struct devfreq_event_desc *desc;
 };
 
@@ -291,6 +300,8 @@ extern struct devfreq_event_dev *devfreq_get_event_dev_by_phandle(
 				struct device *dev, int index);
 extern int devfreq_put_event_dev(struct devfreq_event_dev *event_dev);
 extern int devfreq_enable_event_dev(struct devfreq_event_dev *event_dev);
+extern int devfreq_enable_event_dev_exclusive(
+					struct devfreq_event_dev *event_dev);
 extern int devfreq_disable_event_dev(struct devfreq_event_dev *event_dev);
 extern bool devfreq_is_enabled_event_dev(struct devfreq_event_dev *event_dev);
 extern int devfreq_set_event_event_dev(struct devfreq_event_dev *event_dev,
@@ -419,6 +430,12 @@ static inline int devfreq_enable_event_dev(struct devfreq_event_dev *event_dev)
 	return -EINVAL;
 }
 
+static inline int devfreq_enable_event_dev_exclusive(
+					struct devfreq_event_dev *event_dev)
+{
+	return -EINVAL;
+}
+
 static inline int devfreq_disable_event_dev(
 				struct devfreq_event_dev *event_dev)
 {
-- 
1.8.5.5

