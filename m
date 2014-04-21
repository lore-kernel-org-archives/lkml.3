Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752575AbaDUMEx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 08:04:53 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:42742 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751323AbaDUMCT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 08:02:19 -0400
X-AuditID: cbfee68e-b7fd86d0000038e3-61-535508ca7d92
From: Chanwoo Choi <cw00.choi@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: myungjoo.ham@samsung.com, balbi@ti.com, gg@slimlogic.co.uk, kishon@ti.com,
        ckeepax@opensource.wolfsonmicro.com, broonie@kernel.org,
        k.kozlowski@samsung.com, kyungmin.park@samsung.com,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCHv2 2/9] extcon: Add devm_extcon_dev_allocate/free to manage the
 resource of extcon device
Date: Mon, 21 Apr 2014 21:02:15 +0900
Message-id: <1398081742-24277-3-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1398081742-24277-1-git-send-email-cw00.choi@samsung.com>
References: <1398081742-24277-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupgkeLIzCtJLcpLzFFi42JZI2JSrHuKIzTYoGcmt8XB+/UWUx8+YbP4
	N+UGu8X1L89ZLfq3uFi8fmFoceFpD5vF2aY37BaXd81hs7jduILNgctj06pONo+XE3+zefRt
	WcXoMXXKX0aP4ze2M3l83iQXwBbFZZOSmpNZllqkb5fAldH16w1LwXPpiom77jA1ME4S72Lk
	5JAQMJFYdvg1G4QtJnHh3nogm4tDSGApo8Stl08ZYYq2LdjKCJFYxChx+EUXM4TTxCRx/s9C
	sCo2AS2J/S9ugI0SEVCQ2Nz7jBWkiFngGaPEiasnmEESwgJZEq92TWQFsVkEVCXe9BwGi/MK
	uErcv74Xap2cxIc9j9i7GDk4OAXcJC6cKAcJCwGVPPq9GewKCYFd7BKrN75kh5gjIPFt8iEW
	kHoJAVmJTQeYIcZIShxccYNlAqPwAkaGVYyiqQXJBcVJ6UVGesWJucWleel6yfm5mxiBsXD6
	37O+HYw3D1gfYkwGGjeRWUo0OR8YS3kl8YbGZkYWpiamxkbmlmakCSuJ8y56mBQkJJCeWJKa
	nZpakFoUX1Sak1p8iJGJg1OqgZG3nuGivOD2jUu3Cl+3OuS3967/4SizaAUeFvlm42Xz9b/P
	5dDqci9/2PssdtrDi53HAzOfezzQ+7sz6fmNVS63tq36LBl06MOnQ4U629k+7tTearerqsS+
	UPU5S0tF2ZuJ7md7pThVP3VHPpZ5l7Dr4gTW3vl/jPIfxTGmN+udnrztwdlPi6YpsRRnJBpq
	MRcVJwIAtv2VopsCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKIsWRmVeSWpSXmKPExsVy+t9jAd1THKHBBrsfMFocvF9vMfXhEzaL
	f1NusFtc//Kc1aJ/i4vF6xeGFhee9rBZnG16w25xedccNovbjSvYHLg8Nq3qZPN4OfE3m0ff
	llWMHlOn/GX0OH5jO5PH501yAWxRDYw2GamJKalFCql5yfkpmXnptkrewfHO8aZmBoa6hpYW
	5koKeYm5qbZKLj4Bum6ZOUCHKSmUJeaUAoUCEouLlfTtME0IDXHTtYBpjND1DQmC6zEyQAMJ
	axgzun69YSl4Ll0xcdcdpgbGSeJdjJwcEgImEtsWbGWEsMUkLtxbz9bFyMUhJLCIUeLwiy5m
	CKeJSeL8n4VgVWwCWhL7X9xgA7FFBBQkNvc+YwUpYhZ4xihx4uoJZpCEsECWxKtdE1lBbBYB
	VYk3PYfB4rwCrhL3r++FWicn8WHPI/YuRg4OTgE3iQsnykHCQkAlj35vZpzAyLuAkWEVo2hq
	QXJBcVJ6rqFecWJucWleul5yfu4mRnCkPZPawbiyweIQowAHoxIP74ySkGAh1sSy4srcQ4wS
	HMxKIrwR64FCvCmJlVWpRfnxRaU5qcWHGJOBjprILCWanA9MAnkl8YbGJmZGlkbmhhZGxuak
	CSuJ8x5otQ4UEkhPLEnNTk0tSC2C2cLEwSnVwJhv2vLo7fscnqus1c2nXU5NeH2f30wuyUZV
	VeTZgeucHS/m/N9wqyZ+9sb514QfyxZsiopavPBb+r/dzFtOPFuYssieeZVz5mobLvv/75vO
	V755rx/6R3vpW3/ZMo1H7/f0pyx7aRaea81quW5NczW7XU/CiqUJag6CK9Z21QakCGve2S7s
	1aHEUpyRaKjFXFScCAC2frZo+AIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add device managed devm_extcon_dev_{allocate,free} to automatically
free the memory of extcon_dev structure without handling free operation.

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
---
 drivers/extcon/extcon-class.c | 46 +++++++++++++++++++++++++++++++++++++++++++
 include/linux/extcon.h        | 11 +++++++++++
 2 files changed, 57 insertions(+)

diff --git a/drivers/extcon/extcon-class.c b/drivers/extcon/extcon-class.c
index 3e485bc..677c502 100644
--- a/drivers/extcon/extcon-class.c
+++ b/drivers/extcon/extcon-class.c
@@ -848,6 +848,11 @@ void extcon_dev_free(struct extcon_dev *edev)
 }
 EXPORT_SYMBOL_GPL(extcon_dev_free);
 
+static void devm_extcon_dev_release(struct device *dev, void *res)
+{
+	extcon_dev_free(*(struct extcon_dev **)res);
+}
+
 static void devm_extcon_dev_unreg(struct device *dev, void *res)
 {
 	extcon_dev_unregister(*(struct extcon_dev **)res);
@@ -866,6 +871,47 @@ static int devm_extcon_dev_match(struct device *dev, void *res, void *data)
 }
 
 /**
+ * devm_extcon_dev_allocate - Allocate managed extcon device
+ * @dev:		device owning the extcon device being created
+ * @supported_cable:	Array of supported cable names ending with NULL.
+ *			If supported_cable is NULL, cable name related APIs
+ *			are disabled.
+ *
+ * This function manages automatically the memory of extcon device using device
+ * resource management and simplify the control of freeing the memory of extcon
+ * device.
+ *
+ * Returns the pointer memory of allocated extcon_dev if success or NULL if fail
+ */
+struct extcon_dev *devm_extcon_dev_allocate(struct device *dev,
+					    const char **supported_cable)
+{
+	struct extcon_dev **ptr, *edev;
+
+	ptr = devres_alloc(devm_extcon_dev_release, sizeof(*ptr), GFP_KERNEL);
+	if (!ptr)
+		return NULL;
+
+	edev = extcon_dev_allocate(supported_cable);
+	if (!IS_ERR(edev)) {
+		*ptr = edev;
+		devres_add(dev, ptr);
+	} else {
+		devres_free(ptr);
+	}
+
+	return edev;
+}
+EXPORT_SYMBOL_GPL(devm_extcon_dev_allocate);
+
+void devm_extcon_dev_free(struct device *dev, struct extcon_dev *edev)
+{
+	WARN_ON(devres_release(dev, devm_extcon_dev_release,
+			       devm_extcon_dev_match, edev));
+}
+EXPORT_SYMBOL_GPL(devm_extcon_dev_free);
+
+/**
  * devm_extcon_dev_register() - Resource-managed extcon_dev_register()
  * @dev:	device to allocate extcon device
  * @edev:	the new extcon device to register
diff --git a/include/linux/extcon.h b/include/linux/extcon.h
index 20587ee..2bc66ca 100644
--- a/include/linux/extcon.h
+++ b/include/linux/extcon.h
@@ -254,6 +254,9 @@ extern int extcon_unregister_notifier(struct extcon_dev *edev,
 /*
  * Following APIs control the memory of extcon device.
  */
+extern struct extcon_dev *devm_extcon_dev_allocate(struct device *dev,
+						   const char **cables);
+extern void devm_extcon_dev_free(struct device *dev, struct extcon_dev *edev);
 extern struct extcon_dev *extcon_dev_allocate(const char **cables);
 extern void extcon_dev_free(struct extcon_dev *edev);
 
@@ -368,5 +371,13 @@ static inline struct extcon_dev *extcon_dev_allocate(const char **cables)
 }
 
 static inline void extcon_dev_free(struct extcon_dev *edev) { }
+
+static inline struct extcon_dev *devm_extcon_dev_allocate(struct device *dev,
+							  const char **cables)
+{
+	return ERR_PTR(-ENOMEM);
+}
+
+static inline void devm_extcon_dev_free(struct extcon_dev *edev) { }
 #endif /* CONFIG_EXTCON */
 #endif /* __LINUX_EXTCON_H__ */
-- 
1.8.0

