Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754198Ab3EPFaN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 01:30:13 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:11140 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751810Ab3EPFaK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 01:30:10 -0400
X-AuditID: cbfee690-b7efc6d000006d92-4c-51946ed67dca
Date: Thu, 16 May 2013 05:29:58 +0000 (GMT)
From: Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH 2/2] lcd: add devm_lcd_device_{register,unregister}()
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, tj@kernel.org, jg1.han@samsung.com
Reply-to: jg1.han@samsung.com
MIME-version: 1.0
X-MTR: 20130516052838808@jg1.han
Msgkey: 20130516052838808@jg1.han
X-EPLocale: en_US.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20130516052838808@jg1.han
X-ParentMTR: 
X-ArchiveUser: EV
X-CPGSPASS: N
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <15131311.131631368682197663.JavaMail.weblogic@epml12>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrEJsWRmVeSWpSXmKPExsVy+t8zQ91reVMCDe5/ELG4vGsOmwOjx+dN
	cgGMUQ2MNolFyRmZZakKqXnJ+SmZeem2SqEhbroWSgoZ+cUltkrRRgbGekamJnpGJuZ6lgax
	VkamSgp5ibmptkoVulC9SgpFyQVAtbmVxUADclL1oOJ6xal5KQ5Z+aUgl+gVJ+YWl+al6yXn
	5yoplCXmlAKNUNJPmMqY8ffQJraCB6oVy84dZW1gfKDSxcjJISSgJDHp5F5GEFtCwETi3cFz
	bBC2mMSFe+uBbC6gmmWMEjOPNsMVde/qYYZIzGeU6Fj0EyzBIqAqsf7obDCbTUBdYsLvZhYQ
	W1jAVWLChB6wuAjQtlndfUwgNrNAuMTlz5uZIK6Qlbg3eTYziM0rIChxcuYTFohlChJ96/qA
	4hxAcUWJAz9MIMISEnfu72eFsHklZrQ/hSqXk5j2dQ0zhC0tcX7WBkaYZxZ/fwwV55c4dnsH
	E8hIkN4n94Nhxuze/AXqdwGJqWcOMkKUqErcOlACEeaTWLPwLdQmQYnT17qZYVrvb5kL9ZSi
	xJTuh+wQtpbElx/72NA9xSvgJPHtwyTGCYzKs5CkZiFpn4WkHVnNAkaWVYyiqQXJBcVJ6UUm
	yHG9iRGSBCfsYLx3wPoQ435GYIxMZJYSTc4HptG8knhDYzMjC1MTU2Mjc0szCoVNTC0sTIyo
	IqwkzqveYh0oJJCeWJKanZpakFoUX1Sak1p8iJGJg1OqgVFyvQLX1SD9MMMJSlzmvRlHEh+l
	Sr/79+44h+RNhsUxbk9FP89MCbi93Nzel0n1zLS1oQ92/WO7ERAqecGa5+LzvPcaGz8Uykq+
	Wn/DaNU5yf1738q/FcxWNPXPZbgoF1W5+lVXW+zsTVnCxwRuhTK9UQz6VndI91hw8pECFf/X
	sXrcq9nq9iixFGckGmoxFxUnAgAiEUHs9QMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpgk+LIzCtJLcpLzFFi42I5/e/2DN1reVMCDWasELS4vGsOmwOjx+dN
	cgGMURk2GamJKalFCql5yfkpmXnptkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUBD
	lRTKEnNKgUIBicXFSvp2NkX5pSWpChn5xSW2StFGBsZ6RqYmekbGBnrGlrFWhgYGRqZAVQkZ
	GX8PbWIreKBasezcUdYGxgcqXYycHEICShKTTu5lBLElBEwkunf1MEPYYhIX7q1n62LkAqqZ
	zyjRsegnWBGLgKrE+qOzwWw2AXWJCb+bWUBsYQFXiQkTesDiIkBDZ3X3MYHYzALhEpc/b2aC
	WCYrcW/ybLAFvAKCEidnPmGBWKYg0beuDyjOARRXlDjwwwQiLCFx5/5+VgibV2JG+1OocjmJ
	aV/XQN0pLXF+1gZGmJsXf38MFeeXOHZ7BxPISJDeJ/eDYcbs3vyFDcIWkJh65iAjRImqxK0D
	JRBhPok1C99CbRKUOH2tmxmm9f6WuVBPKUpM6X7IDmFrSXz5sY8N3VO8Ak4S3z5MYpzAKDcL
	SWoWkvZZSNqR1SxgZFnFKJpakFxQnJReYaRXnJhbXJqXrpecn7uJEZyeni3awfjvvPUhRgEO
	RiUe3hMJUwKFWBPLiitzDzFKcDArifDOSAUK8aYkVlalFuXHF5XmpBYfYkwGRt9EZinR5Hxg
	6swriTc0NjYxMzE1N7AwsDQnTVhJnPdZq3WgkEB6YklqdmpqQWoRzBYmDk6pBsbAZ+tuFrHb
	3O0/vnBnvZv7ZYuCc2GNOgEfuOYsC0i2O1w/7/7R9gOF9R80nvfOKn3Eczb4lW/ApMo1H1iP
	98i0NFs+2VJXys0Q01eyqbJt7ZTvW/fxCx7dmyn4tMWg5OaJm7kVkc+epHmZHzF7tbRXyeii
	i/519bAdT14sNAp6mV8jv6ml+I0SS3FGoqEWc1FxIgAsOXo5kwMAAA==
DLP-Filter: Pass
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r4G5UJEJ019814

These functions allow the driver core to automatically clean up any
allocation made by lcd drivers. Thus it simplifies the error paths.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/video/backlight/lcd.c |   70 +++++++++++++++++++++++++++++++++++++++++
 include/linux/lcd.h           |    5 +++
 2 files changed, 75 insertions(+)

diff --git a/drivers/video/backlight/lcd.c b/drivers/video/backlight/lcd.c
index 34fb6bd..6f28902 100644
--- a/drivers/video/backlight/lcd.c
+++ b/drivers/video/backlight/lcd.c
@@ -260,6 +260,76 @@ void lcd_device_unregister(struct lcd_device *ld)
 }
 EXPORT_SYMBOL(lcd_device_unregister);
 
+static void devm_lcd_device_release(struct device *dev, void *res)
+{
+	struct lcd_device *lcd = *(struct lcd_device **)res;
+
+	lcd_device_unregister(lcd);
+}
+
+static int devm_lcd_device_match(struct device *dev, void *res, void *data)
+{
+	struct lcd_device **r = res;
+
+	return *r == data;
+}
+
+/**
+ * devm_lcd_device_register - resource managed lcd_device_register()
+ * @dev: the device to register
+ * @name: the name of the device
+ * @parent: a pointer to the parent device
+ * @devdata: an optional pointer to be stored for private driver use
+ * @ops: the lcd operations structure
+ *
+ * @return a struct lcd on success, or an ERR_PTR on error
+ *
+ * Managed lcd_device_register(). The lcd_device returned from this function
+ * are automatically freed on driver detach. See lcd_device_register()
+ * for more information.
+ */
+struct lcd_device *devm_lcd_device_register(struct device *dev,
+		const char *name, struct device *parent,
+		void *devdata, struct lcd_ops *ops)
+{
+	struct lcd_device **ptr, *lcd;
+
+	ptr = devres_alloc(devm_lcd_device_release, sizeof(*ptr), GFP_KERNEL);
+	if (!ptr)
+		return ERR_PTR(-ENOMEM);
+
+	lcd = lcd_device_register(name, parent, devdata, ops);
+	if (!IS_ERR(lcd)) {
+		*ptr = lcd;
+		devres_add(dev, ptr);
+	} else {
+		devres_free(ptr);
+	}
+
+	return lcd;
+}
+EXPORT_SYMBOL(devm_lcd_device_register);
+
+/**
+ * devm_lcd_device_unregister - resource managed lcd_device_unregister()
+ * @dev: the device to unregister
+ * @ld: the lcd device to unregister
+ *
+ * Deallocated a lcd allocated with devm_lcd_device_register(). Normally
+ * this function will not need to be called and the resource management
+ * code will ensure that the resource is freed.
+ */
+void devm_lcd_device_unregister(struct device *dev, struct lcd_device *ld)
+{
+	int rc;
+
+	rc = devres_release(dev, devm_lcd_device_release,
+				devm_lcd_device_match, ld);
+	WARN_ON(rc);
+}
+EXPORT_SYMBOL(devm_lcd_device_unregister);
+
+
 static void __exit lcd_class_exit(void)
 {
 	class_destroy(lcd_class);
diff --git a/include/linux/lcd.h b/include/linux/lcd.h
index e00c3b0..504f624 100644
--- a/include/linux/lcd.h
+++ b/include/linux/lcd.h
@@ -112,7 +112,12 @@ static inline void lcd_set_power(struct lcd_device *ld, int power)
 
 extern struct lcd_device *lcd_device_register(const char *name,
 	struct device *parent, void *devdata, struct lcd_ops *ops);
+extern struct lcd_device *devm_lcd_device_register(struct device *dev,
+	const char *name, struct device *parent,
+	void *devdata, struct lcd_ops *ops);
 extern void lcd_device_unregister(struct lcd_device *ld);
+extern void devm_lcd_device_unregister(struct device *dev,
+	struct lcd_device *ld);
 
 #define to_lcd_device(obj) container_of(obj, struct lcd_device, dev)
 
-- 
1.7.10.4

ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
