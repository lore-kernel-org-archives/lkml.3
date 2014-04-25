Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751537AbaDYAoq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 20:44:46 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:8729 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750755AbaDYAme (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 20:42:34 -0400
X-AuditID: cbfee68f-b7eff6d000002b70-78-5359af777387
From: Chanwoo Choi <cw00.choi@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: myungjoo.ham@samsung.com, balbi@ti.com, gg@slimlogic.co.uk, kishon@ti.com,
        ckeepax@opensource.wolfsonmicro.com, broonie@kernel.org,
        k.kozlowski@samsung.com, kyungmin.park@samsung.com,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCHv4 1/9] extcon: Add extcon_dev_allocate/free() to control the
 memory of extcon device
Date: Fri, 25 Apr 2014 09:42:16 +0900
Message-id: <1398386544-16295-2-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1398386544-16295-1-git-send-email-cw00.choi@samsung.com>
References: <1398386544-16295-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupgkeLIzCtJLcpLzFFi42JZI2JSpFu+PjLYYOcVDYuD9+stpj58wmbx
	b8oNdovrX56zWvRvcbF4/cLQ4sLTHjaLs01v2C0u75rDZnG7cQWbA5fHplWdbB4vJ/5m8+jb
	sorRY+qUv4wex29sZ/L4vEkugC2KyyYlNSezLLVI3y6BK+P/Hq2C5ZIVx07eZmlg/CHSxcjJ
	ISFgIjFzUycjhC0mceHeerYuRi4OIYGljBJrvh9mginaePUGC0RiOqPEse4ORginiUli8dNZ
	YFVsAloS+1/cYAOxRQQUJDb3PmMFKWIWeMYoceLqCWaQhLBAmsTXa7/AbBYBVYndC96C2bwC
	rhJ9c3+wQayTk/iw5xE7iM0p4CZx6EQvC4gtBFTz6twcJpChEgLb2CWeTfrJBDFIQOLb5ENA
	RRxACVmJTQeYIeZIShxccYNlAqPwAkaGVYyiqQXJBcVJ6UXGesWJucWleel6yfm5mxiBsXD6
	37P+HYx3D1gfYkwGGjeRWUo0OR8YS3kl8YbGZkYWpiamxkbmlmakCSuJ895/mBQkJJCeWJKa
	nZpakFoUX1Sak1p8iJGJg1OqgfF4gspP34L+gzmBjyzabu64rjMnfuEDhpaW3ix3G8dzDqKh
	qos/sIes/JLXWnvQr6Wo19CnevXmH9V9GoHcj52OXVE5/vGh+O2ZexuOfkxzn7VynoBsUccG
	U56oaZvXzr7ms32OE/9i6Zflf7clnJ5eOafyiJNdxJOD38o8eJ0yg1MXiXq/YVdiKc5INNRi
	LipOBACTpAakmwIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKIsWRmVeSWpSXmKPExsVy+t9jQd3y9ZHBBi3vFCwO3q+3mPrwCZvF
	vyk32C2uf3nOatG/xcXi9QtDiwtPe9gszja9Ybe4vGsOm8XtxhVsDlwem1Z1snm8nPibzaNv
	yypGj6lT/jJ6HL+xncnj8ya5ALaoBkabjNTElNQihdS85PyUzLx0WyXv4HjneFMzA0NdQ0sL
	cyWFvMTcVFslF58AXbfMHKDDlBTKEnNKgUIBicXFSvp2mCaEhrjpWsA0Ruj6hgTB9RgZoIGE
	NYwZ//doFSyXrDh28jZLA+MPkS5GTg4JAROJjVdvsEDYYhIX7q1n62Lk4hASmM4ocay7gxHC
	aWKSWPx0FhNIFZuAlsT+FzfYQGwRAQWJzb3PWEGKmAWeMUqcuHqCGSQhLJAm8fXaLzCbRUBV
	YveCt2A2r4CrRN/cH2wQ6+QkPux5xA5icwq4SRw60Qt2hhBQzatzc5gmMPIuYGRYxSiaWpBc
	UJyUnmuoV5yYW1yal66XnJ+7iREcac+kdjCubLA4xCjAwajEw/tBLTJYiDWxrLgy9xCjBAez
	kgiv8iqgEG9KYmVValF+fFFpTmrxIcZkoKsmMkuJJucDk0BeSbyhsYmZkaWRuaGFkbE5acJK
	4rwHWq0DhQTSE0tSs1NTC1KLYLYwcXBKNTAGf30W9OWP5s6cYL55e8UbHirNDXi0pU844n32
	kfb2nf+kT1VJ+of3rOObJxj0j0WJe3Pw5JN/pWM0Ix9laLPoGBw7u1fl/UZxNQnP+46/8/cq
	/Ttbc2XmcmllU7WXzYfnHlm1QlrPzkEt/A/r9v9Mmew+FnrTXWPi9qw80HRv9fQLcue5hByV
	WIozEg21mIuKEwH20ZN0+AIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add APIs to control the extcon device on extcon provider driver.
The extcon_dev_allocate() allocates the memory of extcon device and initializes
supported cables. And then extcon_dev_free() decrement the reference of the
device of extcon device and free the memory of the extcon device. This APIs
must need to implement devm_extcon_dev_allocate()/free() APIs.

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
---
 drivers/extcon/extcon-class.c | 36 ++++++++++++++++++++++++++++++++++++
 include/linux/extcon.h        | 13 +++++++++++++
 2 files changed, 49 insertions(+)

diff --git a/drivers/extcon/extcon-class.c b/drivers/extcon/extcon-class.c
index f6df689..654ed52 100644
--- a/drivers/extcon/extcon-class.c
+++ b/drivers/extcon/extcon-class.c
@@ -565,6 +565,42 @@ static void dummy_sysfs_dev_release(struct device *dev)
 {
 }
 
+/*
+ * extcon_dev_allocate() - Allocate the memory of extcon device.
+ * @supported_cable:	Array of supported cable names ending with NULL.
+ *			If supported_cable is NULL, cable name related APIs
+ *			are disabled.
+ *
+ * This function allocates the memory for extcon device without allocating
+ * memory in each extcon provider driver and initialize default setting for
+ * extcon device.
+ *
+ * Return the pointer of extcon device if success or ERR_PTR(err) if fail
+ */
+struct extcon_dev *extcon_dev_allocate(const char **supported_cable)
+{
+	struct extcon_dev *edev;
+
+	edev = kzalloc(sizeof(*edev), GFP_KERNEL);
+	if (!edev)
+		return ERR_PTR(-ENOMEM);
+
+	edev->max_supported = 0;
+	edev->supported_cable = supported_cable;
+
+	return edev;
+}
+
+/*
+ * extcon_dev_free() - Free the memory of extcon device.
+ * @edev:	the extcon device to free
+ */
+void extcon_dev_free(struct extcon_dev *edev)
+{
+	kfree(edev);
+}
+EXPORT_SYMBOL_GPL(extcon_dev_free);
+
 /**
  * extcon_dev_register() - Register a new extcon device
  * @edev	: the new extcon device (should be allocated before calling)
diff --git a/include/linux/extcon.h b/include/linux/extcon.h
index 548447b..f4fc983 100644
--- a/include/linux/extcon.h
+++ b/include/linux/extcon.h
@@ -192,6 +192,12 @@ extern void devm_extcon_dev_unregister(struct device *dev,
 extern struct extcon_dev *extcon_get_extcon_dev(const char *extcon_name);
 
 /*
+ * Following APIs control the memory of extcon device.
+ */
+extern struct extcon_dev *extcon_dev_allocate(const char **cables);
+extern void extcon_dev_free(struct extcon_dev *edev);
+
+/*
  * get/set/update_state access the 32b encoded state value, which represents
  * states of all possible cables of the multistate port. For example, if one
  * calls extcon_set_state(edev, 0x7), it may mean that all the three cables
@@ -267,6 +273,13 @@ static inline int devm_extcon_dev_register(struct device *dev,
 static inline void devm_extcon_dev_unregister(struct device *dev,
 					      struct extcon_dev *edev) { }
 
+static inline struct extcon_dev *extcon_dev_allocate(const char **cables)
+{
+	return ERR_PTR(-ENOMEM);
+}
+
+static inline void extcon_dev_free(struct extcon_dev *edev) { }
+
 static inline u32 extcon_get_state(struct extcon_dev *edev)
 {
 	return 0;
-- 
1.8.0

