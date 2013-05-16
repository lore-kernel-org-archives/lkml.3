Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752830Ab3EPF2b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 01:28:31 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:64210 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751329Ab3EPF22 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 01:28:28 -0400
X-AuditID: cbfee691-b7fef6d000002d62-23-51946e7b0ec4
Date: Thu, 16 May 2013 05:28:27 +0000 (GMT)
From: Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH 1/2] backlight: add
 devm_backlight_device_{register,unregister}()
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, tj@kernel.org, jg1.han@samsung.com
Reply-to: jg1.han@samsung.com
MIME-version: 1.0
X-MTR: 20130516052654212@jg1.han
Msgkey: 20130516052654212@jg1.han
X-EPLocale: en_US.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20130516052654212@jg1.han
X-ParentMTR: 
X-ArchiveUser: EV
X-CPGSPASS: N
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <20226221.131531368682106551.JavaMail.weblogic@epml12>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrEJsWRmVeSWpSXmKPExsVy+t8zY93qvCmBBlcaeC0u75rD5sDo8XmT
	XABjVAOjTWJRckZmWapCal5yfkpmXrqtUmiIm66FkkJGfnGJrVK0kYGxnpGpiZ6RibmepUGs
	lZGpkkJeYm6qrVKFLlSvkkJRcgFQbW5lMdCAnFQ9qLhecWpeikNWfinIJXrFibnFpXnpesn5
	uUoKZYk5pUAjlPQTpjJmHL1kUHBCp+JXzxfmBsYN2l2MnBxCAkoSk07uZQSxJQRMJKbP3wdl
	i0lcuLeeDaJmGaPEs3tKMDV3n18DquECis9nlLjcdYoVJMEioCqx+P80MJtNQF1iwu9mFhBb
	WCBQ4svp+cwgtgjQslndfUwgNrNAuMTlz5uZIBbIStybPBushldAUOLkzCcsEMsUJLau2coE
	EVeUOHr7I9RxEhJ37u9nhbB5JWa0P4Wql5OY9nUNM4QtLXF+1ga4ZxZ/fwwV55c4dnsH0EwO
	sN4n94Nhxuze/IUNwhaQmHrmIFSrqsThny+g4nwSaxa+hVolKHH6WjczTO/9LXOh3lKUmNL9
	kB3C1pL48mMfG7q3eAWcJB6f7mOfwKg8C0lqFpL2WUjakdUsYGRZxSiaWpBcUJyUXmSKHNeb
	GCFJcOIOxvsHrA8x7mcExslEZinR5HxgGs0riTc0NjOyMDUxNTYytzSjUNjE1MLCxIgqwkri
	vOot1oFCAumJJanZqakFqUXxRaU5qcWHGJk4OKUaGFfujE3P2HljjU/HbgWlpJl7MmfeXcP3
	VDpxOatfeonY91Oe2ydcbX98LjEjd9m5OOe2NdL7z2u/Ps7Wannb8uNLLc/NWXNyA9NVK2om
	WhWEXzT3mX5s94RZnAHlKQu9JrI3rAieWXqmM3Gx2JTUB4Xa2+s4Ymxr9ruJcbClBt0L8IiZ
	xxn5VImlOCPRUIu5qDgRABq///H1AwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpkk+LIzCtJLcpLzFFi42I5/e/2DN3qvCmBBu+Oc1pc3jWHzYHR4/Mm
	uQDGqAybjNTElNQihdS85PyUzLx0WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKCh
	SgpliTmlQKGAxOJiJX07m6L80pJUhYz84hJbpWgjA2M9I1MTPSNjAz1jy1grQwMDI1OgqoSM
	jKOXDApO6FT86vnC3MC4QbuLkZNDSEBJYtLJvYwgtoSAicTd59egbDGJC/fWs3UxcgHVzGeU
	uNx1ihUkwSKgKrH4/zQwm01AXWLC72YWEFtYIFDiy+n5zCC2CNDQWd19TCA2s0C4xOXPm5kg
	lslK3Js8G6yGV0BQ4uTMJywQyxQktq7ZygQRV5Q4evsj1BESEnfu72eFsHklZrQ/haqXk5j2
	dQ0zhC0tcX7WBrijF39/DBXnlzh2ewfQTA6w3if3g2HG7N78hQ3CFpCYeuYgVKuqxOGfL6Di
	fBJrFr6FWiUocfpaNzNM7/0tc6HeUpSY0v2QHcLWkvjyYx8burd4BZwkHp/uY5/AKDcLSWoW
	kvZZSNqR1SxgZFnFKJpakFxQnJReYaJXnJhbXJqXrpecn7uJEZygni3ZwdhwwfoQowAHoxIP
	74mEKYFCrIllxZW5hxglOJiVRHhnpAKFeFMSK6tSi/Lji0pzUosPMSYDI3Ais5Rocj4weeaV
	xBsaG5uYmZiaG1gYWJqTJqwkzvus1TpQSCA9sSQ1OzW1ILUIZgsTB6dUA2PKtXteNxJb/l86
	mW7m9C75z9EfkjmL13/cozf1g/7GY5umLLxR/qzAWEz65d4cpq8yB8TMGqcb/2o6qPXOqpM7
	r/mjSumKX8++HKy8MP/8TOei5KR4l0XSNfxM1bu7J/8uP7Blp+Jjo3quxoa0Sx79qUerD8hu
	/nKAd/6NXSpneCU3V/Af7ZmixFKckWioxVxUnAgAtDaLW5QDAAA=
DLP-Filter: Pass
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r4G5Sdvs019806

These functions allow the driver core to automatically clean up any
allocation made by backlight drivers. Thus it simplifies the error
paths.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/video/backlight/backlight.c |   75 +++++++++++++++++++++++++++++++++++
 include/linux/backlight.h           |    6 +++
 2 files changed, 81 insertions(+)

diff --git a/drivers/video/backlight/backlight.c b/drivers/video/backlight/backlight.c
index c74e7aa..feb68af 100644
--- a/drivers/video/backlight/backlight.c
+++ b/drivers/video/backlight/backlight.c
@@ -370,6 +370,81 @@ void backlight_device_unregister(struct backlight_device *bd)
 }
 EXPORT_SYMBOL(backlight_device_unregister);
 
+static void devm_backlight_device_release(struct device *dev, void *res)
+{
+	struct backlight_device *backlight = *(struct backlight_device **)res;
+
+	backlight_device_unregister(backlight);
+}
+
+static int devm_backlight_device_match(struct device *dev, void *res,
+					void *data)
+{
+	struct backlight_device **r = res;
+
+	return *r == data;
+}
+
+/**
+ * devm_backlight_device_register - resource managed backlight_device_register()
+ * @dev: the device to register
+ * @name: the name of the device
+ * @parent: a pointer to the parent device
+ * @devdata: an optional pointer to be stored for private driver use
+ * @ops: the backlight operations structure
+ * @props: the backlight properties
+ *
+ * @return a struct backlight on success, or an ERR_PTR on error
+ *
+ * Managed backlight_device_register(). The backlight_device returned
+ * from this function are automatically freed on driver detach.
+ * See backlight_device_register() for more information.
+ */
+struct backlight_device *devm_backlight_device_register(struct device *dev,
+	const char *name, struct device *parent, void *devdata,
+	const struct backlight_ops *ops,
+	const struct backlight_properties *props)
+{
+	struct backlight_device **ptr, *backlight;
+
+	ptr = devres_alloc(devm_backlight_device_release, sizeof(*ptr),
+			GFP_KERNEL);
+	if (!ptr)
+		return ERR_PTR(-ENOMEM);
+
+	backlight = backlight_device_register(name, parent, devdata, ops,
+						props);
+	if (!IS_ERR(backlight)) {
+		*ptr = backlight;
+		devres_add(dev, ptr);
+	} else {
+		devres_free(ptr);
+	}
+
+	return backlight;
+}
+EXPORT_SYMBOL(devm_backlight_device_register);
+
+/**
+ * devm_backlight_device_unregister - resource managed backlight_device_unregister()
+ * @dev: the device to unregister
+ * @bd: the backlight device to unregister
+ *
+ * Deallocated a backlight allocated with devm_backlight_device_register().
+ * Normally this function will not need to be called and the resource management
+ * code will ensure that the resource is freed.
+ */
+void devm_backlight_device_unregister(struct device *dev,
+				struct backlight_device *bd)
+{
+	int rc;
+
+	rc = devres_release(dev, devm_backlight_device_release,
+				devm_backlight_device_match, bd);
+	WARN_ON(rc);
+}
+EXPORT_SYMBOL(devm_backlight_device_unregister);
+
 #ifdef CONFIG_OF
 static int of_parent_match(struct device *dev, const void *data)
 {
diff --git a/include/linux/backlight.h b/include/linux/backlight.h
index da9a082..53b7794 100644
--- a/include/linux/backlight.h
+++ b/include/linux/backlight.h
@@ -114,7 +114,13 @@ static inline void backlight_update_status(struct backlight_device *bd)
 extern struct backlight_device *backlight_device_register(const char *name,
 	struct device *dev, void *devdata, const struct backlight_ops *ops,
 	const struct backlight_properties *props);
+extern struct backlight_device *devm_backlight_device_register(
+	struct device *dev, const char *name, struct device *parent,
+	void *devdata, const struct backlight_ops *ops,
+	const struct backlight_properties *props);
 extern void backlight_device_unregister(struct backlight_device *bd);
+extern void devm_backlight_device_unregister(struct device *dev,
+					struct backlight_device *bd);
 extern void backlight_force_update(struct backlight_device *bd,
 				   enum backlight_update_reason reason);
 
-- 
1.7.10.4

ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
