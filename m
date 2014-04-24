Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756983AbaDXMrJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 08:47:09 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:33458 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756092AbaDXMe4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 08:34:56 -0400
X-AuditID: cbfee68f-b7eff6d000002b70-4f-535904ef5af5
From: Chanwoo Choi <cw00.choi@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: myungjoo.ham@samsung.com, balbi@ti.com, gg@slimlogic.co.uk, kishon@ti.com,
        ckeepax@opensource.wolfsonmicro.com, broonie@kernel.org,
        k.kozlowski@samsung.com, kyungmin.park@samsung.com,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCHv3 2/9] extcon: Add devm_extcon_dev_allocate/free to manage the
 resource of extcon device
Date: Thu, 24 Apr 2014 21:34:50 +0900
Message-id: <1398342897-23670-3-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1398342897-23670-1-git-send-email-cw00.choi@samsung.com>
References: <1398342897-23670-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupgkeLIzCtJLcpLzFFi42JZI2JSoPueJTLYYNsVNouD9+stpj58wmbx
	b8oNdovrX56zWvRvcbF4/cLQ4sLTHjaLs01v2C0u75rDZnG7cQWbA5fHplWdbB4vJ/5m8+jb
	sorRY+qUv4wex29sZ/L4vEkugC2KyyYlNSezLLVI3y6BK+PEzivsBVfkK3b/3czawNgu1cXI
	ySEhYCIxv2cvC4QtJnHh3nq2LkYuDiGBpYwSL3pessEVdRxgh0hMZ5Rob7nCDJIQEmhikpj+
	WA7EZhPQktj/4gZYg4iAgsTm3mesIA3MAs8YJU5cPQHWICyQJTHnz2KwdSwCqhKPP01nArF5
	BVwlPs2dyg6xTU7iw55HYDangJvE2QtX2SCWuUqsbPgHNlRCYBu7xKuX11ghBglIfJt8CGgo
	B1BCVmLTAWaIOZISB1fcYJnAKLyAkWEVo2hqQXJBcVJ6kbFecWJucWleul5yfu4mRmAsnP73
	rH8H490D1ocYk4HGTWSWEk3OB8ZSXkm8obGZkYWpiamxkbmlGWnCSuK89x8mBQkJpCeWpGan
	phakFsUXleakFh9iZOLglGpgLFRRWfN6TfDudn+7nQICVbOjd9w/3zXBfbPcEabiRFffrB5F
	FyO3xZZCeZUMH9ZXmsilvIrjcl71ZfNzySnCqhEn15ypvZQsvjlqG0OQyY2FxZNZZ4Sdi6xn
	Cu5/vf5tyULx0l6NgEe/Ax6Zli2cUjF1q3SQj6bGyl+32FZsrDe9tkXGvthPiaU4I9FQi7mo
	OBEAvKQhN5sCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKIsWRmVeSWpSXmKPExsVy+t9jQd13LJHBBl/7rS0O3q+3mPrwCZvF
	vyk32C2uf3nOatG/xcXi9QtDiwtPe9gszja9Ybe4vGsOm8XtxhVsDlwem1Z1snm8nPibzaNv
	yypGj6lT/jJ6HL+xncnj8ya5ALaoBkabjNTElNQihdS85PyUzLx0WyXv4HjneFMzA0NdQ0sL
	cyWFvMTcVFslF58AXbfMHKDDlBTKEnNKgUIBicXFSvp2mCaEhrjpWsA0Ruj6hgTB9RgZoIGE
	NYwZJ3ZeYS+4Il+x++9m1gbGdqkuRk4OCQETifkdB9ghbDGJC/fWs3UxcnEICUxnlGhvucIM
	khASaGKSmP5YDsRmE9CS2P/iBhuILSKgILG59xkrSAOzwDNGiRNXT4A1CAtkScz5s5gFxGYR
	UJV4/Gk6E4jNK+Aq8WnuVKhtchIf9jwCszkF3CTOXrjKBrHMVWJlwz/WCYy8CxgZVjGKphYk
	FxQnpeca6hUn5haX5qXrJefnbmIER9ozqR2MKxssDjEKcDAq8fAeuBAeLMSaWFZcmXuIUYKD
	WUmEd/a/iGAh3pTEyqrUovz4otKc1OJDjMlAV01klhJNzgcmgbySeENjEzMjSyNzQwsjY3PS
	hJXEeQ+0WgcKCaQnlqRmp6YWpBbBbGHi4JRqYDwt1XJ13/P27MVbwiYbvctdIt1W02fwyIOZ
	J9jrCedqT6Gin+sWxt86sKK7oz/4nZmdeLTp7zTeBQa7jzeKZWXbvL09/XFc1dynIaaaNR4/
	Kw++Snz70i2p+uvaxmN765SOst32drV/+S/85AZjxw88vewzDXYo+nMEHtbRW2Drr7NiVpTk
	VyWW4oxEQy3mouJEAPnq+nn4AgAA
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
 drivers/extcon/extcon-class.c | 70 +++++++++++++++++++++++++++++++++++--------
 include/linux/extcon.h        | 11 +++++++
 2 files changed, 69 insertions(+), 12 deletions(-)

diff --git a/drivers/extcon/extcon-class.c b/drivers/extcon/extcon-class.c
index bec66d4..f369168 100644
--- a/drivers/extcon/extcon-class.c
+++ b/drivers/extcon/extcon-class.c
@@ -604,6 +604,64 @@ void extcon_dev_free(struct extcon_dev *edev)
 }
 EXPORT_SYMBOL_GPL(extcon_dev_free);
 
+static int devm_extcon_dev_match(struct device *dev, void *res, void *data)
+{
+	struct extcon_dev **r = res;
+
+	if (!r || !*r) {
+		WARN_ON(!r || !*r);
+		return 0;
+	}
+
+	return *r == data;
+}
+
+static void devm_extcon_dev_release(struct device *dev, void *res)
+{
+	extcon_dev_free(*(struct extcon_dev **)res);
+}
+
+/**
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
 /**
  * extcon_dev_register() - Register a new extcon device
  * @edev	: the new extcon device (should be allocated before calling)
@@ -863,18 +921,6 @@ static void devm_extcon_dev_unreg(struct device *dev, void *res)
 	extcon_dev_unregister(*(struct extcon_dev **)res);
 }
 
-static int devm_extcon_dev_match(struct device *dev, void *res, void *data)
-{
-	struct extcon_dev **r = res;
-
-	if (!r || !*r) {
-		WARN_ON(!r || !*r);
-		return 0;
-	}
-
-	return *r == data;
-}
-
 /**
  * devm_extcon_dev_register() - Resource-managed extcon_dev_register()
  * @dev:	device to allocate extcon device
diff --git a/include/linux/extcon.h b/include/linux/extcon.h
index f4fc983..3fd831b 100644
--- a/include/linux/extcon.h
+++ b/include/linux/extcon.h
@@ -196,6 +196,9 @@ extern struct extcon_dev *extcon_get_extcon_dev(const char *extcon_name);
  */
 extern struct extcon_dev *extcon_dev_allocate(const char **cables);
 extern void extcon_dev_free(struct extcon_dev *edev);
+extern struct extcon_dev *devm_extcon_dev_allocate(struct device *dev,
+						   const char **cables);
+extern void devm_extcon_dev_free(struct device *dev, struct extcon_dev *edev);
 
 /*
  * get/set/update_state access the 32b encoded state value, which represents
@@ -280,6 +283,14 @@ static inline struct extcon_dev *extcon_dev_allocate(const char **cables)
 
 static inline void extcon_dev_free(struct extcon_dev *edev) { }
 
+static inline struct extcon_dev *devm_extcon_dev_allocate(struct device *dev,
+							  const char **cables)
+{
+	return ERR_PTR(-ENOMEM);
+}
+
+static inline void devm_extcon_dev_free(struct extcon_dev *edev) { }
+
 static inline u32 extcon_get_state(struct extcon_dev *edev)
 {
 	return 0;
-- 
1.8.0

