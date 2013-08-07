Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932994Ab3HGNKa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 09:10:30 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:43283 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932909Ab3HGNK1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 09:10:27 -0400
X-AuditID: cbfee690-b7f6f6d00000740c-4a-5202474123e7
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-usb@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        stern@rowland.harvard.edu, balbi@ti.com, kishon@ti.com,
        jwerner@chromium.org
Subject: [PATCH] usb: phy: Cleanup error code in **_usb_get_phy_**() APIs
Date: Wed, 07 Aug 2013 18:38:58 +0530
Message-id: <1375880938-6979-1-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.6.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrILMWRmVeSWpSXmKPExsWyRsSkWtfRnSnI4OcSMYuD9+stmhevZ7Po
	OPSYyeLC0x42i8u75rBZzDi/j8li0bJWZosJvy+wOXB4zG64yOKxf+4ado/Zd38wehy/sZ3J
	4/MmuQDWKC6blNSczLLUIn27BK6MT8fVCjbrVzw5NJO1gXGZWhcjJ4eEgInEp+W72SBsMYkL
	99YD2VwcQgJLGSUefV/ADlN0Y00XI4gtJDCdUaL/qwlE0RQmieUN+1lBEmwCuhJNb3eBFYkI
	OEgsWXoHbBKzQA+jxJxlV5hAEsICnhJb1kwEm8oioCpx+U4jWDOvgLvEjjtXoM5QkHhz+xkz
	hN3OLtH7vwqiXkDi2+RDLF2MHEBxWYlNB6BKJCUOrrjBMoFRcAEjwypG0dSC5ILipPQiE73i
	xNzi0rx0veT83E2MwOA9/e/ZhB2M9w5YH2JMBho3kVlKNDkfGPx5JfGGxmZGFqYmpsZG5pZm
	pAkrifOqt1gHCgmkJ5akZqemFqQWxReV5qQWH2Jk4uCUamDs3fXT+KVZi2tG08Z7KWVSSWx+
	wRI2y1cu/3Q4MtmofW97SbX7N+vdKjwKVwQ2ilVf/O+ZuF5J+QB35l3GvJv63YwJO9+drDqU
	bnfSe/8M5n9nfuxPUf1wgTXg/R8L4U/37Le9UhcTshc0vyGX2lBZVeHL8//yDGafeMOCvENt
	ISG1E7oTzyuxFGckGmoxFxUnAgD3PxQVdAIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrPIsWRmVeSWpSXmKPExsVy+t9jQV1Hd6Ygg58ruS0O3q+3aF68ns2i
	49BjJosLT3vYLC7vmsNmMeP8PiaLRctamS0m/L7A5sDhMbvhIovH/rlr2D1m3/3B6HH8xnYm
	j8+b5AJYoxoYbTJSE1NSixRS85LzUzLz0m2VvIPjneNNzQwMdQ0tLcyVFPISc1NtlVx8AnTd
	MnOAblFSKEvMKQUKBSQWFyvp22GaEBripmsB0xih6xsSBNdjZIAGEtYwZnw6rlawWb/iyaGZ
	rA2My9S6GDk5JARMJG6s6WKEsMUkLtxbzwZiCwlMZ5To/2rSxcgFZE9hkljesJ8VJMEmoCvR
	9HYXWIOIgIPEkqV32ECKmAV6GCXmLLvCBJIQFvCU2LJmIjuIzSKgKnH5TiNYM6+Au8SOO1fY
	ILYpSLy5/Yx5AiP3AkaGVYyiqQXJBcVJ6blGesWJucWleel6yfm5mxjB0fFMegfjqgaLQ4wC
	HIxKPLwVYoxBQqyJZcWVuYcYJTiYlUR4c42ZgoR4UxIrq1KL8uOLSnNSiw8xJgNtn8gsJZqc
	D4zcvJJ4Q2MTc1NjU0sTCxMzS9KElcR5D7ZaBwoJpCeWpGanphakFsFsYeLglGpgXDovZ85C
	LWaRqwGKLeeFTjaX/YifevDr5H/fCic/cG5gnxVg2f/UcuO5rPyT8fWXHDdaLZp0xDP/SEyc
	aHvh1IpLBgWPjs3cssDzyZr6mF0S6TG7bnHkfHowSU2iM97ni/zLV86Ps5Vnz36yWn7njfNX
	C5mC1nZVXlH9nid3nl2r/k/7T8XHzUosxRmJhlrMRcWJAKJNqDzSAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

**_usb_get_phy_**() APIs should generate equivalent
error codes in case of failure in getting phy. There's no
need of returning NULL pointer, like in devm_usb_get_phy()
or devm_usb_get_phy_dev(), since it's nowhere handled.

Earlier series of patches starting:
9ee1c7f usb: host: ohci-exynos: fix PHY error handling,
fixed PHY error handling.

Also adding error handling in usb_phy_**() APIs.

Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
---
 drivers/usb/phy/phy.c   |   18 ++++++++++--------
 include/linux/usb/phy.h |   42 ++++++++++++++++++++++--------------------
 2 files changed, 32 insertions(+), 28 deletions(-)

diff --git a/drivers/usb/phy/phy.c b/drivers/usb/phy/phy.c
index a9984c7..86f9905 100644
--- a/drivers/usb/phy/phy.c
+++ b/drivers/usb/phy/phy.c
@@ -25,7 +25,7 @@ static DEFINE_SPINLOCK(phy_lock);
 static struct usb_phy *__usb_find_phy(struct list_head *list,
 	enum usb_phy_type type)
 {
-	struct usb_phy  *phy = NULL;
+	struct usb_phy  *phy;
 
 	list_for_each_entry(phy, list, head) {
 		if (phy->type != type)
@@ -40,7 +40,7 @@ static struct usb_phy *__usb_find_phy(struct list_head *list,
 static struct usb_phy *__usb_find_phy_dev(struct device *dev,
 	struct list_head *list, u8 index)
 {
-	struct usb_phy_bind *phy_bind = NULL;
+	struct usb_phy_bind *phy_bind;
 
 	list_for_each_entry(phy_bind, list, list) {
 		if (!(strcmp(phy_bind->dev_name, dev_name(dev))) &&
@@ -94,11 +94,11 @@ static int devm_usb_phy_match(struct device *dev, void *res, void *match_data)
  */
 struct usb_phy *devm_usb_get_phy(struct device *dev, enum usb_phy_type type)
 {
-	struct usb_phy **ptr, *phy;
+	struct usb_phy	*phy = ERR_PTR(-ENOMEM), **ptr;
 
 	ptr = devres_alloc(devm_usb_phy_release, sizeof(*ptr), GFP_KERNEL);
 	if (!ptr)
-		return NULL;
+		goto err0;
 
 	phy = usb_get_phy(type);
 	if (!IS_ERR(phy)) {
@@ -107,6 +107,7 @@ struct usb_phy *devm_usb_get_phy(struct device *dev, enum usb_phy_type type)
 	} else
 		devres_free(ptr);
 
+err0:
 	return phy;
 }
 EXPORT_SYMBOL_GPL(devm_usb_get_phy);
@@ -123,7 +124,7 @@ EXPORT_SYMBOL_GPL(devm_usb_get_phy);
  */
 struct usb_phy *usb_get_phy(enum usb_phy_type type)
 {
-	struct usb_phy	*phy = NULL;
+	struct usb_phy	*phy;
 	unsigned long	flags;
 
 	spin_lock_irqsave(&phy_lock, flags);
@@ -221,7 +222,7 @@ EXPORT_SYMBOL_GPL(devm_usb_get_phy_by_phandle);
  */
 struct usb_phy *usb_get_phy_dev(struct device *dev, u8 index)
 {
-	struct usb_phy	*phy = NULL;
+	struct usb_phy	*phy;
 	unsigned long	flags;
 
 	spin_lock_irqsave(&phy_lock, flags);
@@ -254,11 +255,11 @@ EXPORT_SYMBOL_GPL(usb_get_phy_dev);
  */
 struct usb_phy *devm_usb_get_phy_dev(struct device *dev, u8 index)
 {
-	struct usb_phy **ptr, *phy;
+	struct usb_phy	*phy = ERR_PTR(-ENOMEM), **ptr;
 
 	ptr = devres_alloc(devm_usb_phy_release, sizeof(*ptr), GFP_KERNEL);
 	if (!ptr)
-		return NULL;
+		goto err0;
 
 	phy = usb_get_phy_dev(dev, index);
 	if (!IS_ERR(phy)) {
@@ -267,6 +268,7 @@ struct usb_phy *devm_usb_get_phy_dev(struct device *dev, u8 index)
 	} else
 		devres_free(ptr);
 
+err0:
 	return phy;
 }
 EXPORT_SYMBOL_GPL(devm_usb_get_phy_dev);
diff --git a/include/linux/usb/phy.h b/include/linux/usb/phy.h
index 4403680..9aa6aae 100644
--- a/include/linux/usb/phy.h
+++ b/include/linux/usb/phy.h
@@ -142,7 +142,7 @@ extern void usb_remove_phy(struct usb_phy *);
 /* helpers for direct access thru low-level io interface */
 static inline int usb_phy_io_read(struct usb_phy *x, u32 reg)
 {
-	if (x->io_ops && x->io_ops->read)
+	if (!IS_ERR(x) && x->io_ops && x->io_ops->read)
 		return x->io_ops->read(x, reg);
 
 	return -EINVAL;
@@ -150,7 +150,7 @@ static inline int usb_phy_io_read(struct usb_phy *x, u32 reg)
 
 static inline int usb_phy_io_write(struct usb_phy *x, u32 val, u32 reg)
 {
-	if (x->io_ops && x->io_ops->write)
+	if (!IS_ERR(x) && x->io_ops && x->io_ops->write)
 		return x->io_ops->write(x, val, reg);
 
 	return -EINVAL;
@@ -159,7 +159,7 @@ static inline int usb_phy_io_write(struct usb_phy *x, u32 val, u32 reg)
 static inline int
 usb_phy_init(struct usb_phy *x)
 {
-	if (x->init)
+	if (!IS_ERR(x) && x->init)
 		return x->init(x);
 
 	return 0;
@@ -168,26 +168,27 @@ usb_phy_init(struct usb_phy *x)
 static inline void
 usb_phy_shutdown(struct usb_phy *x)
 {
-	if (x->shutdown)
+	if (!IS_ERR(x) && x->shutdown)
 		x->shutdown(x);
 }
 
 static inline int
 usb_phy_vbus_on(struct usb_phy *x)
 {
-	if (!x->set_vbus)
-		return 0;
+	if (!IS_ERR(x) && x->set_vbus)
+		return x->set_vbus(x, true);
 
-	return x->set_vbus(x, true);
+	return 0;
 }
 
 static inline int
 usb_phy_vbus_off(struct usb_phy *x)
 {
-	if (!x->set_vbus)
-		return 0;
+	if (!IS_ERR(x) && x->set_vbus)
+		return x->set_vbus(x, false);
+
+	return 0;
 
-	return x->set_vbus(x, false);
 }
 
 /* for usb host and peripheral controller drivers */
@@ -249,8 +250,9 @@ static inline int usb_bind_phy(const char *dev_name, u8 index,
 static inline int
 usb_phy_set_power(struct usb_phy *x, unsigned mA)
 {
-	if (x && x->set_power)
+	if (!IS_ERR(x) && x->set_power)
 		return x->set_power(x, mA);
+
 	return 0;
 }
 
@@ -258,28 +260,28 @@ usb_phy_set_power(struct usb_phy *x, unsigned mA)
 static inline int
 usb_phy_set_suspend(struct usb_phy *x, int suspend)
 {
-	if (x->set_suspend != NULL)
+	if (!IS_ERR(x) && x->set_suspend != NULL)
 		return x->set_suspend(x, suspend);
-	else
-		return 0;
+
+	return 0;
 }
 
 static inline int
 usb_phy_notify_connect(struct usb_phy *x, enum usb_device_speed speed)
 {
-	if (x->notify_connect)
+	if (!IS_ERR(x) && x->notify_connect)
 		return x->notify_connect(x, speed);
-	else
-		return 0;
+
+	return 0;
 }
 
 static inline int
 usb_phy_notify_disconnect(struct usb_phy *x, enum usb_device_speed speed)
 {
-	if (x->notify_disconnect)
+	if (!IS_ERR(x) && x->notify_disconnect)
 		return x->notify_disconnect(x, speed);
-	else
-		return 0;
+
+	return 0;
 }
 
 /* notifiers */
-- 
1.7.6.5

