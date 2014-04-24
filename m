Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756491AbaDXMrH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 08:47:07 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:13064 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756535AbaDXMe4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 08:34:56 -0400
X-AuditID: cbfee68d-b7f4e6d000004845-b1-535904ee7dbf
From: Chanwoo Choi <cw00.choi@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: myungjoo.ham@samsung.com, balbi@ti.com, gg@slimlogic.co.uk, kishon@ti.com,
        ckeepax@opensource.wolfsonmicro.com, broonie@kernel.org,
        k.kozlowski@samsung.com, kyungmin.park@samsung.com,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCHv3 1/9] extcon: Add extcon_dev_allocate/free() to control the
 memory of extcon device
Date: Thu, 24 Apr 2014 21:34:49 +0900
Message-id: <1398342897-23670-2-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1398342897-23670-1-git-send-email-cw00.choi@samsung.com>
References: <1398342897-23670-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpjkeLIzCtJLcpLzFFi42JZI2JSrPuOJTLYoG2GisXB+/UWUx8+YbP4
	N+UGu8X1L89ZLfq3uFi8fmFoceFpD5vF2aY37BaXd81hs7jduILNgctj06pONo+XE3+zefRt
	WcXoMXXKX0aP4ze2M3l83iQXwBbFZZOSmpNZllqkb5fAldF7W6OgQari5eVnjA2Me0W7GDk4
	JARMJKbO1eli5AQyxSQu3FvP1sXIxSEksJRR4nr/blaIhIlE9/5WqMR0Rom3m18xgSSEBJqY
	JKY/lgOx2QS0JPa/uMEGYosIKEhs7n3GCtLALPCMUeLE1RPMIAlhgTSJPQf2gRWxCKhK7D5w
	F8zmFXCVmLDjPhPENjmJD3sesYPYnAJuEmcvXGWDWOYqsbLhH9hQCYFt7BIbVvxjhxgkIPFt
	8iEWiHdkJTYdYIaYIylxcMUNlgmMwgsYGVYxiqYWJBcUJ6UXGeoVJ+YWl+al6yXn525iBMbB
	6X/Pencw3j5gfYgxGWjcRGYp0eR8YBzllcQbGpsZWZiamBobmVuakSasJM6b9DApSEggPbEk
	NTs1tSC1KL6oNCe1+BAjEwenVAPjDrXkRbt+Mr84ML1U6qr5jRtLeD1fTzqhv9ok++zC/9Pb
	JfnOdh+4+YnnW9zxf/p3HqdNKGjKtDqqzfyqoCBefeoyD82AicHzgvQNJ5Y8eVnDWMN5R7VT
	2OIMC9eEl83pLZWstQcvPf/nvuzkjiMzmXdtra3wbMmvd/b00lxilN1vmVgm/qhMiaU4I9FQ
	i7moOBEAKqJo5ZkCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCIsWRmVeSWpSXmKPExsVy+t9jQd13LJHBBhMeS1kcvF9vMfXhEzaL
	f1NusFtc//Kc1aJ/i4vF6xeGFhee9rBZnG16w25xedccNovbjSvYHLg8Nq3qZPN4OfE3m0ff
	llWMHlOn/GX0OH5jO5PH501yAWxRDYw2GamJKalFCql5yfkpmXnptkrewfHO8aZmBoa6hpYW
	5koKeYm5qbZKLj4Bum6ZOUCHKSmUJeaUAoUCEouLlfTtME0IDXHTtYBpjND1DQmC6zEyQAMJ
	axgzem9rFDRIVby8/IyxgXGvaBcjJ4eEgIlE9/5WNghbTOLCvfVANheHkMB0Rom3m18xgSSE
	BJqYJKY/lgOx2QS0JPa/uAHWICKgILG59xkrSAOzwDNGiRNXTzCDJIQF0iT2HNgHVsQioCqx
	+8BdMJtXwFViwo77TBDb5CQ+7HnEDmJzCrhJnL1wlQ1imavEyoZ/rBMYeRcwMqxiFE0tSC4o
	TkrPNdIrTswtLs1L10vOz93ECI6zZ9I7GFc1WBxiFOBgVOLhVbgVHizEmlhWXJl7iFGCg1lJ
	hHf2v4hgId6UxMqq1KL8+KLSnNTiQ4zJQFdNZJYSTc4HpoC8knhDYxMzI0sjc0MLI2Nz0oSV
	xHkPtloHCgmkJ5akZqemFqQWwWxh4uCUamBsONx8bKnBSYXObV0RMzy5XD/rLi7T5d3KtezP
	QvmAXqu2sDs71Yy21J4M3OtYss5ij5jVtRnsC+xr7q6/P4fxoZbeTJkPU0pv3sqRcZy46Faw
	imSCj45VfeNzpQ3Omx1SfA7McOt439X6i8nz/G6rALfdk/8+3/3ByGwG6yk1uziGxpjU/utK
	LMUZiYZazEXFiQAgMYcq9wIAAA==
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
 drivers/extcon/extcon-class.c | 39 +++++++++++++++++++++++++++++++++++++++
 include/linux/extcon.h        | 13 +++++++++++++
 2 files changed, 52 insertions(+)

diff --git a/drivers/extcon/extcon-class.c b/drivers/extcon/extcon-class.c
index f6df689..bec66d4 100644
--- a/drivers/extcon/extcon-class.c
+++ b/drivers/extcon/extcon-class.c
@@ -565,6 +565,45 @@ static void dummy_sysfs_dev_release(struct device *dev)
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
+	if (!edev) {
+		pr_err("Failed to allocate the memory for extcon device\n");
+		return ERR_PTR(-ENOMEM);
+	}
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
+	if (edev)
+		kfree(edev);
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

