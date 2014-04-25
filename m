Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751582AbaDYAos (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 20:44:48 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:31110 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750719AbaDYAme (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 20:42:34 -0400
X-AuditID: cbfee68d-b7f4e6d000004845-ab-5359af7843fe
From: Chanwoo Choi <cw00.choi@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: myungjoo.ham@samsung.com, balbi@ti.com, gg@slimlogic.co.uk, kishon@ti.com,
        ckeepax@opensource.wolfsonmicro.com, broonie@kernel.org,
        k.kozlowski@samsung.com, kyungmin.park@samsung.com,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCHv4 2/9] extcon: Add devm_extcon_dev_allocate/free to manage the
 resource of extcon device
Date: Fri, 25 Apr 2014 09:42:17 +0900
Message-id: <1398386544-16295-3-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1398386544-16295-1-git-send-email-cw00.choi@samsung.com>
References: <1398386544-16295-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpnkeLIzCtJLcpLzFFi42JZI2JSpFuxPjLY4PAccYuD9+stpj58wmbx
	b8oNdovrX56zWvRvcbF4/cLQ4sLTHjaLs01v2C0u75rDZnG7cQWbA5fHplWdbB4vJ/5m8+jb
	sorRY+qUv4wex29sZ/L4vEkugC2KyyYlNSezLLVI3y6BK+PP0YmsBf/kK/53JDcwrpPqYuTk
	kBAwkbhzeDk7hC0mceHeerYuRi4OIYGljBJrD9xkhim62dvGCpGYzijR//UxE4TTxCSx+Oks
	JpAqNgEtif0vbrCB2CICChKbe5+BdTALPGOUOHH1BNAoDg5hgSyJ2W/rQGpYBFQl1u+Ywgpi
	8wq4SrTtuA51hpzEhz2PwGxOATeJQyd6WUBsIaCaV+fmgC2WENjFLjHn6xUWiEECEt8mH2IB
	mS8hICux6QDU1ZISB1fcYJnAKLyAkWEVo2hqQXJBcVJ6kaFecWJucWleul5yfu4mRmAknP73
	rHcH4+0D1ocYk4HGTWSWEk3OB0ZSXkm8obGZkYWpiamxkbmlGWnCSuK8SQ+TgoQE0hNLUrNT
	UwtSi+KLSnNSiw8xMnFwSjUwyvUtfnzn1y+v1XffvQg5xV9x4rCZaPH+CmOOXOk0j5OTxVr7
	N89crLjl+d3NxnPt9opWCM/RLjqqwp/gYq54RO5dYkER8z7XdC/VzkcXd+2uWj5bsOr5Q2bL
	gmyVBlPDNfprilcssLz5hDE8n/2p4cJVR6d3WK88OrsjRVvIJqrtWN5J067NSizFGYmGWsxF
	xYkA5p8BdJoCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCIsWRmVeSWpSXmKPExsVy+t9jQd2K9ZHBBleO8VkcvF9vMfXhEzaL
	f1NusFtc//Kc1aJ/i4vF6xeGFhee9rBZnG16w25xedccNovbjSvYHLg8Nq3qZPN4OfE3m0ff
	llWMHlOn/GX0OH5jO5PH501yAWxRDYw2GamJKalFCql5yfkpmXnptkrewfHO8aZmBoa6hpYW
	5koKeYm5qbZKLj4Bum6ZOUCHKSmUJeaUAoUCEouLlfTtME0IDXHTtYBpjND1DQmC6zEyQAMJ
	axgz/hydyFrwT77if0dyA+M6qS5GTg4JAROJm71trBC2mMSFe+vZuhi5OIQEpjNK9H99zATh
	NDFJLH46iwmkik1AS2L/ixtsILaIgILE5t5nrCBFzALPGCVOXD3B3MXIwSEskCUx+20dSA2L
	gKrE+h1TwDbwCrhKtO24zg6xTU7iw55HYDangJvEoRO9LCC2EFDNq3NzmCYw8i5gZFjFKJpa
	kFxQnJSea6hXnJhbXJqXrpecn7uJERxnz6R2MK5ssDjEKMDBqMTD+0EtMliINbGsuDL3EKME
	B7OSCK/yKqAQb0piZVVqUX58UWlOavEhxmSgqyYyS4km5wNTQF5JvKGxiZmRpZG5oYWRsTlp
	wkrivAdarQOFBNITS1KzU1MLUotgtjBxcEo1MErUSv9mfxj5dWeC0WOtGNWW2u1VB4O+Z89x
	2eIk5ZH2LMRX7NSzcpk9z81PJ1xqMb7Z9GW/4rJ1Z84/TGpVaZigmnbJ9/VKlhuyTZviHi7+
	bfNmzvIc5wTvyzwyC5qPPzi66dq1uwvdV6RlbWGdfG3pUsXaPo63oWl9JRkLS5Yt2fmweuK1
	//lKLMUZiYZazEXFiQCC/mrP9wIAAA==
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
 drivers/extcon/extcon-class.c | 72 +++++++++++++++++++++++++++++++++++--------
 include/linux/extcon.h        | 11 +++++++
 2 files changed, 71 insertions(+), 12 deletions(-)

diff --git a/drivers/extcon/extcon-class.c b/drivers/extcon/extcon-class.c
index 654ed52..24ede8b 100644
--- a/drivers/extcon/extcon-class.c
+++ b/drivers/extcon/extcon-class.c
@@ -601,6 +601,66 @@ void extcon_dev_free(struct extcon_dev *edev)
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
+ * Returns the pointer memory of allocated extcon_dev if success
+ * or ERR_PTR(err) if fail
+ */
+struct extcon_dev *devm_extcon_dev_allocate(struct device *dev,
+					    const char **supported_cable)
+{
+	struct extcon_dev **ptr, *edev;
+
+	ptr = devres_alloc(devm_extcon_dev_release, sizeof(*ptr), GFP_KERNEL);
+	if (!ptr)
+		return ERR_PTR(-ENOMEM);
+
+	edev = extcon_dev_allocate(supported_cable);
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
@@ -860,18 +920,6 @@ static void devm_extcon_dev_unreg(struct device *dev, void *res)
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

