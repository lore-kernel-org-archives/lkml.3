Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753833AbaFKFAL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 01:00:11 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:55617 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751203AbaFKFAI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 01:00:08 -0400
X-AuditID: cbfee68f-b7fef6d000003970-fd-5397e25526c2
From: Jingoo Han <jg1.han@samsung.com>
To: "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org,
        "'Thierry Reding'" <thierry.reding@gmail.com>,
        "'David Airlie'" <airlied@linux.ie>, "'Arnd Bergmann'" <arnd@arndb.de>,
        "'Florian Fainelli'" <f.fainelli@gmail.com>,
        "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH] devres: remove devm_request_and_ioremap()
Date: Wed, 11 Jun 2014 14:00:05 +0900
Message-id: <000901cf8532$026e5d40$074b17c0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac+FMgI5uEAib4vAQpW9X+c119CU7A==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrPIsWRmVeSWpSXmKPExsVy+t8zY93QR9ODDX69M7ToPXeSyeLvpGPs
	Fr/eHWG3aF68ns3i8sJLrBaXd81hs/i5ax6LA7vH71+TGD12zrrL7rH92wNWj/1z17B79G1Z
	xejxeZNcAFsUl01Kak5mWWqRvl0CV8baw0YF5wwq5v7rZGpg3KPexcjJISFgIjHv6RImCFtM
	4sK99WxdjFwcQgLLGCVmHt3NClM09dYkVojEdEaJtq132CGc34wSlz5tYwOpYhNQk/jy5TA7
	iC0iYCqx8f0URpAiZoEnjBJTzl9iBEkIC1hJ9De2gTWwCKhKvNnfzAJi8wrYSpzcfRLKFpT4
	MfkemM0soCWxfudxJghbXmLzmrfMXYwcQCepSzz6qwuxS0/i4Zuf7BAlIhL7XrwD2yshcItd
	oufMF3aIXQIS3yYfYoHolZXYdIAZ4jNJiYMrbrBMYBSbhWTzLCSbZyHZPAvJigWMLKsYRVML
	kguKk9KLjPWKE3OLS/PS9ZLzczcxQiKzfwfj3QPWhxiTgdZPZJYSTc4HRnZeSbyhsZmRhamJ
	qbGRuaUZacJK4rz3HyYFCQmkJ5akZqemFqQWxReV5qQWH2Jk4uCUamDcKexZpXRsV9K5sAXf
	+sz27N6aoHp7l3/5NGnzOqu1vMv8NrRzxDsvma6zvoqrgLXwR6zHY50Qn40+MaondFceYWVb
	Uvt3eVnZuk9Pg9wzLpx+s0Jd7lSB62+hs0dVDCS1PvmWnTB8Md/I4Y9Qtbn6smfemntbNm02
	jZFjFeDMmrnP9+brzLlKLMUZiYZazEXFiQAX+DaN4gIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrDKsWRmVeSWpSXmKPExsVy+t9jQd3QR9ODDTZs1rHoPXeSyeLvpGPs
	Fr/eHWG3aF68ns3i8sJLrBaXd81hs/i5ax6LA7vH71+TGD12zrrL7rH92wNWj/1z17B79G1Z
	xejxeZNcAFtUA6NNRmpiSmqRQmpecn5KZl66rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+A
	rltmDtAxSgpliTmlQKGAxOJiJX07TBNCQ9x0LWAaI3R9Q4LgeowM0EDCOsaMtYeNCs4ZVMz9
	18nUwLhHvYuRk0NCwERi6q1JrBC2mMSFe+vZuhi5OIQEpjNKtG29ww7h/GaUuPRpGxtIFZuA
	msSXL4fZQWwRAVOJje+nMIIUMQs8YZSYcv4SI0hCWMBKor+xDayBRUBV4s3+ZhYQm1fAVuLk
	7pNQtqDEj8n3wGxmAS2J9TuPM0HY8hKb17xl7mLkADpJXeLRX12IXXoSD9/8ZIcoEZHY9+Id
	4wRGgVlIJs1CMmkWkkmzkLQsYGRZxSiaWpBcUJyUnmukV5yYW1yal66XnJ+7iREc98+kdzCu
	arA4xCjAwajEwyshPT1YiDWxrLgy9xCjBAezkgjv7eNAId6UxMqq1KL8+KLSnNTiQ4zJQI9O
	ZJYSTc4HpqS8knhDYxMzI0sjMwsjE3Nz0oSVxHkPtloHCgmkJ5akZqemFqQWwWxh4uCUamDs
	WBynzLgvYumSuDj9tVOeVP/8t3jKwljza9fU2G6t+cb+7q2+1jsfu71eHCeObHjYc+3EuSKT
	eRrbQzdeuca558+pXwd2Mgb8PrbYeNpG2YtJG0peXP5m+bJS8dmS1LozR1wEDwX7arhUN/90
	YxK6fr99yrRUtv+eJ2/+lMoIad+8PFGePWniRyWW4oxEQy3mouJEABQdA1w/AwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

devm_request_and_ioremap() was obsoleted by the commit 7509657
("lib: devres: Introduce devm_ioremap_resource()") and has been
deprecated for a long time. So, let's remove this function.
In addition, all usages of devm_request_and_ioremap() are also
removed.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
Based-on the latest linux kernel
(dfb9454 Merge git://www.linux-watchdog.org/linux-watchdog)

 Documentation/driver-model/devres.txt              |    1 -
 drivers/bus/brcmstb_gisb.c                         |    6 +-
 drivers/gpu/drm/armada/armada_crtc.c               |    8 +-
 include/linux/device.h                             |    2 -
 lib/devres.c                                       |   28 ------
 scripts/coccinelle/api/devm_ioremap_resource.cocci |   90 --------------------
 6 files changed, 6 insertions(+), 129 deletions(-)
 delete mode 100644 scripts/coccinelle/api/devm_ioremap_resource.cocci

diff --git a/Documentation/driver-model/devres.txt b/Documentation/driver-model/devres.txt
index 8947255..001740b 100644
--- a/Documentation/driver-model/devres.txt
+++ b/Documentation/driver-model/devres.txt
@@ -278,7 +278,6 @@ IOMAP
   devm_ioremap_nocache()
   devm_iounmap()
   devm_ioremap_resource() : checks resource, requests memory region, ioremaps
-  devm_request_and_ioremap() : obsoleted by devm_ioremap_resource()
   pcim_iomap()
   pcim_iounmap()
   pcim_iomap_table()	: array of mapped addresses indexed by BAR
diff --git a/drivers/bus/brcmstb_gisb.c b/drivers/bus/brcmstb_gisb.c
index 6159b77..f2cd6a2d 100644
--- a/drivers/bus/brcmstb_gisb.c
+++ b/drivers/bus/brcmstb_gisb.c
@@ -212,9 +212,9 @@ static int brcmstb_gisb_arb_probe(struct platform_device *pdev)
 	mutex_init(&gdev->lock);
 	INIT_LIST_HEAD(&gdev->next);
 
-	gdev->base = devm_request_and_ioremap(&pdev->dev, r);
-	if (!gdev->base)
-		return -ENOMEM;
+	gdev->base = devm_ioremap_resource(&pdev->dev, r);
+	if (IS_ERR(gdev->base))
+		return PTR_ERR(gdev->base);
 
 	err = devm_request_irq(&pdev->dev, timeout_irq,
 				brcmstb_gisb_timeout_handler, 0, pdev->name,
diff --git a/drivers/gpu/drm/armada/armada_crtc.c b/drivers/gpu/drm/armada/armada_crtc.c
index 81c34f9..3aedf9e 100644
--- a/drivers/gpu/drm/armada/armada_crtc.c
+++ b/drivers/gpu/drm/armada/armada_crtc.c
@@ -1039,11 +1039,9 @@ int armada_drm_crtc_create(struct drm_device *dev, unsigned num,
 	if (ret)
 		return ret;
 
-	base = devm_request_and_ioremap(dev->dev, res);
-	if (!base) {
-		DRM_ERROR("failed to ioremap register\n");
-		return -ENOMEM;
-	}
+	base = devm_ioremap_resource(dev->dev, res);
+	if (IS_ERR(base))
+		return PTR_ERR(base);
 
 	dcrtc = kzalloc(sizeof(*dcrtc), GFP_KERNEL);
 	if (!dcrtc) {
diff --git a/include/linux/device.h b/include/linux/device.h
index af424ac..921fa0a 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -631,8 +631,6 @@ extern unsigned long devm_get_free_pages(struct device *dev,
 extern void devm_free_pages(struct device *dev, unsigned long addr);
 
 void __iomem *devm_ioremap_resource(struct device *dev, struct resource *res);
-void __iomem *devm_request_and_ioremap(struct device *dev,
-			struct resource *res);
 
 /* allows to add/remove a custom action to devres stack */
 int devm_add_action(struct device *dev, void (*action)(void *), void *data);
diff --git a/lib/devres.c b/lib/devres.c
index f562bf6..6a4aee8 100644
--- a/lib/devres.c
+++ b/lib/devres.c
@@ -142,34 +142,6 @@ void __iomem *devm_ioremap_resource(struct device *dev, struct resource *res)
 }
 EXPORT_SYMBOL(devm_ioremap_resource);
 
-/**
- * devm_request_and_ioremap() - Check, request region, and ioremap resource
- * @dev: Generic device to handle the resource for
- * @res: resource to be handled
- *
- * Takes all necessary steps to ioremap a mem resource. Uses managed device, so
- * everything is undone on driver detach. Checks arguments, so you can feed
- * it the result from e.g. platform_get_resource() directly. Returns the
- * remapped pointer or NULL on error. Usage example:
- *
- *	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
- *	base = devm_request_and_ioremap(&pdev->dev, res);
- *	if (!base)
- *		return -EADDRNOTAVAIL;
- */
-void __iomem *devm_request_and_ioremap(struct device *dev,
-				       struct resource *res)
-{
-	void __iomem *dest_ptr;
-
-	dest_ptr = devm_ioremap_resource(dev, res);
-	if (IS_ERR(dest_ptr))
-		return NULL;
-
-	return dest_ptr;
-}
-EXPORT_SYMBOL(devm_request_and_ioremap);
-
 #ifdef CONFIG_HAS_IOPORT_MAP
 /*
  * Generic iomap devres
diff --git a/scripts/coccinelle/api/devm_ioremap_resource.cocci b/scripts/coccinelle/api/devm_ioremap_resource.cocci
deleted file mode 100644
index 495daa3..0000000
--- a/scripts/coccinelle/api/devm_ioremap_resource.cocci
+++ /dev/null
@@ -1,90 +0,0 @@
-virtual patch
-virtual report
-
-@depends on patch@
-expression base, dev, res;
-@@
-
--base = devm_request_and_ioremap(dev, res);
-+base = devm_ioremap_resource(dev, res);
- ...
- if (
--base == NULL
-+IS_ERR(base)
- || ...) {
-<...
--	return ...;
-+	return PTR_ERR(base);
-...>
- }
-
-@depends on patch@
-expression e, E, ret;
-identifier l;
-@@
-
- e = devm_ioremap_resource(...);
- ...
- if (IS_ERR(e) || ...) {
- 	... when any
--	ret = E;
-+	ret = PTR_ERR(e);
- 	...
-(
- 	return ret;
-|
- 	goto l;
-)
- }
-
-@depends on patch@
-expression e;
-@@
-
- e = devm_ioremap_resource(...);
- ...
- if (IS_ERR(e) || ...) {
- 	...
--	\(dev_dbg\|dev_err\|pr_debug\|pr_err\|DRM_ERROR\)(...);
- 	...
- }
-
-@depends on patch@
-expression e;
-identifier l;
-@@
-
- e = devm_ioremap_resource(...);
- ...
- if (IS_ERR(e) || ...)
--{
-(
- 	return ...;
-|
- 	goto l;
-)
--}
-
-@r depends on report@
-expression e;
-identifier l;
-position p1;
-@@
-
-*e = devm_request_and_ioremap@p1(...);
- ...
- if (e == NULL || ...) {
- 	...
-(
- 	return ...;
-|
- 	goto l;
-)
- }
-
-@script:python depends on r@
-p1 << r.p1;
-@@
-
-msg = "ERROR: deprecated devm_request_and_ioremap() API used on line %s" % (p1[0].line)
-coccilib.report.print_report(p1[0], msg)
-- 
1.7.10.4


