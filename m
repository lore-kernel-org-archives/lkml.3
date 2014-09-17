Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751514AbaIQGgd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 02:36:33 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:57554 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751362AbaIQGgb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 02:36:31 -0400
X-AuditID: cbfee68f-f797f6d000001173-62-54192bedc62a
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: lee.jones@linaro.org, arnd@arndb.de, tomasz.figa@gmail.com,
        linux@arm.linux.org.uk, vikas.sajjan@samsung.com, joshi@samsung.com,
        naushad@samsung.com, thomas.ab@samsung.com, chow.kim@samsung.com,
        kgene.kim@samsung.com, Pankaj Dubey <pankaj.dubey@samsung.com>
Subject: [PATCH v3] mfd: syscon: Decouple syscon interface from platform devices
Date: Wed, 17 Sep 2014 12:01:50 +0530
Message-id: <1410935510-1567-1-git-send-email-pankaj.dubey@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrFLMWRmVeSWpSXmKPExsWyRsSkWvettmSIwZJnPBZ/Jx1jt1g26S6b
	xfddX9gtehdcZbO4//Uoo8Wmx9dYLS7vmsNmMeP8PiaL25d5LT4d/c9qsWgrUFnHMkaLVbv+
	MFrcfLadyYHPo6W5h83j969JjB47Z91l97hzbQ+bx+Yl9R59W1YxenzeJBfAHsVlk5Kak1mW
	WqRvl8CVcWbWQ5aCc3oVpw6fYm1gXKbWxcjBISFgIvFuUVYXIyeQKSZx4d56ti5GLg4hgaWM
	En/f/GKFSJhIPDs8kxUisYhRov31amaQhJDABCaJufOcQWw2AV2JJ+/ngsVFBLIl+m+vZgFp
	YBboZpLY/HwaO0hCWCBAYs+me0wgNouAqsTetvNsIFfwCrhLfGiOhjhIQWLOJBuIvYfYJf4f
	8oGoFpD4NvkQC0SJrMSmA8wQJZISB1fcYJnAKLiAkWEVo2hqQXJBcVJ6kbFecWJucWleul5y
	fu4mRmAUnP73rH8H490D1ocYBTgYlXh4N1yWCBFiTSwrrsw9xGgKtGEis5Rocj4w1vJK4g2N
	zYwsTE1MjY3MLc2UxHkXSv0MFhJITyxJzU5NLUgtii8qzUktPsTIxMEp1cCYtfeT0z4R78V7
	ZzIWLzE8s+Xjmx8q5vHSwp6CjJsXv5RoC38wu3ED66zLN6dbJunFNTS7qHjdkdsYV+PXXnMn
	6XTFRLmr9yen/r846a/F+fIPpRlT77CYJr1gizynFnd+inTXRtP1vhHMdcIH3rKvC+25OW/B
	s6t9xUtEYy21ZhWYLLggnhuuxFKckWioxVxUnAgAEVUnu30CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrGIsWRmVeSWpSXmKPExsVy+t9jAd232pIhBlvfMFn8nXSM3WLZpLts
	Ft93fWG36F1wlc3i/tejjBabHl9jtbi8aw6bxYzz+5gsbl/mtfh09D+rxaKtQGUdyxgtVu36
	w2hx89l2Jgc+j5bmHjaP378mMXrsnHWX3ePOtT1sHpuX1Hv0bVnF6PF5k1wAe1QDo01GamJK
	apFCal5yfkpmXrqtkndwvHO8qZmBoa6hpYW5kkJeYm6qrZKLT4CuW2YO0MVKCmWJOaVAoYDE
	4mIlfTtME0JD3HQtYBojdH1DguB6jAzQQMIaxowzsx6yFJzTqzh1+BRrA+MytS5GTg4JAROJ
	Z4dnskLYYhIX7q1n62Lk4hASWMQo0f56NTNIQkhgApPE3HnOIDabgK7Ek/dzweIiAtkS/bdX
	s4A0MAt0M0lsfj6NHSQhLBAgsWfTPSYQm0VAVWJv23mgqRwcvALuEh+ao0FMCQEFiTmTbCYw
	ci9gZFjFKJpakFxQnJSea6RXnJhbXJqXrpecn7uJERxnz6R3MK5qsDjEKMDBqMTDu+GyRIgQ
	a2JZcWXuIUYJDmYlEV6Re0Ah3pTEyqrUovz4otKc1OJDjKZAuycyS4km5wNTQF5JvKGxibmp
	samliYWJmaWSOO/BVutAIYH0xJLU7NTUgtQimD4mDk6pBkanabvjKuwWtcYt2Wi2UPX5i6/t
	QX+s1p64Nad7z7vTOv+WXcwwf75N3unWrs6ThsVLY6erWT388lhR5FzXBfGJOXmiEo88a1Nu
	p4Wk+/zjscw+2NURrJGiKa49daV7rp6085l9S2siN2rcUYuT+2vGoC1VNlXx0S139jkFl3o/
	v2rQ/Gu7cL8SS3FGoqEWc1FxIgAtHU3ryQIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently a syscon entity can be only registered directly through a
platform device that binds to a dedicated syscon driver. However in
certain use cases it is desirable to make a device used with another
driver a syscon interface provider.

For example, certain SoCs (e.g. Exynos) contain system controller
blocks which perform various functions such as power domain control,
CPU power management, low power mode control, but in addition contain
certain IP integration glue, such as various signal masks,
coprocessor power control, etc. In such case, there is a need to have
a dedicated driver for such system controller but also share registers
with other drivers. The latter is where the syscon interface is helpful.

In case of DT based platforms, this patch decouples syscon object from
syscon platform driver, and allows to create syscon objects first time
when it is required by calling of syscon_regmap_lookup_by APIs and keep
a list of such syscon objects along with syscon provider device_nodes
and regmap handles.

For non-DT based platforms, this patch keeps syscon platform driver
structure where is can be probed and such non-DT based drivers can use
syscon_regmap_lookup_by_pdev API and get access to regmap handles.
Once all users of "syscon_regmap_lookup_by_pdev" migrated to DT based,
we can completly remove platform driver of syscon, and keep only helper
functions to get regmap handles.

Suggested-by: Arnd Bergmann <arnd@arndb.de>
Suggested-by: Tomasz Figa <tomasz.figa@gmail.com>
Tested-by: Vivek Gautam <gautam.vivek@samsung.com>
Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
---
V2 of this patchset and related discussion can be found here [1].

Changes since v2:
 - Added back platform device support from syscon, with one change that
   syscon will not be probed for DT based platform.
 - Added back syscon_regmap_lookup_by_pdevname API so that non-DT base
   users of syscon will not be broken.
 - Removed unwanted change in syscon.h.
 - Modified Signed-off-by list, added Suggested-by of Tomasz Figa and
   Arnd Bergmann.
 - Added Tested-by of Vivek Gautam for testing on Exynos platform.

Changes since v1:
 - Removed of_syscon_unregister function.
 - Modified of_syscon_register function and it will be used by syscon.c 
   to create syscon objects whenever required. 
 - Removed platform device support from syscon.
 - Removed syscon_regmap_lookup_by_pdevname API support.
 - As there are significant changes w.r.t patchset v1, I am taking over
   author for this patchset from Tomasz Figa.

[1]: https://lkml.org/lkml/2014/9/2/299

 drivers/mfd/syscon.c |   78 ++++++++++++++++++++++++++++++++++++--------------
 1 file changed, 57 insertions(+), 21 deletions(-)

diff --git a/drivers/mfd/syscon.c b/drivers/mfd/syscon.c
index ca15878..4a4bad9 100644
--- a/drivers/mfd/syscon.c
+++ b/drivers/mfd/syscon.c
@@ -15,40 +15,49 @@
 #include <linux/err.h>
 #include <linux/io.h>
 #include <linux/module.h>
+#include <linux/list.h>
 #include <linux/of.h>
 #include <linux/of_address.h>
-#include <linux/of_platform.h>
 #include <linux/platform_data/syscon.h>
 #include <linux/platform_device.h>
 #include <linux/regmap.h>
 #include <linux/mfd/syscon.h>
+#include <linux/slab.h>
 
 static struct platform_driver syscon_driver;
 
+static DEFINE_SPINLOCK(syscon_list_slock);
+static LIST_HEAD(syscon_list);
+
 struct syscon {
+	struct device_node *np;
 	struct regmap *regmap;
+	struct list_head list;
 };
 
-static int syscon_match_node(struct device *dev, void *data)
-{
-	struct device_node *dn = data;
-
-	return (dev->of_node == dn) ? 1 : 0;
-}
+static struct syscon *of_syscon_register(struct device_node *np);
 
 struct regmap *syscon_node_to_regmap(struct device_node *np)
 {
-	struct syscon *syscon;
-	struct device *dev;
+	struct syscon *entry, *syscon = NULL;
 
-	dev = driver_find_device(&syscon_driver.driver, NULL, np,
-				 syscon_match_node);
-	if (!dev)
-		return ERR_PTR(-EPROBE_DEFER);
+	spin_lock(&syscon_list_slock);
 
-	syscon = dev_get_drvdata(dev);
+	list_for_each_entry(entry, &syscon_list, list)
+		if (entry->np == np) {
+			syscon = entry;
+			break;
+		}
 
-	return syscon->regmap;
+	spin_unlock(&syscon_list_slock);
+
+	if (!syscon)
+		syscon = of_syscon_register(np);
+
+	if (!IS_ERR(syscon))
+		return syscon->regmap;
+
+	return ERR_CAST(syscon);
 }
 EXPORT_SYMBOL_GPL(syscon_node_to_regmap);
 
@@ -110,17 +119,45 @@ struct regmap *syscon_regmap_lookup_by_phandle(struct device_node *np,
 }
 EXPORT_SYMBOL_GPL(syscon_regmap_lookup_by_phandle);
 
-static const struct of_device_id of_syscon_match[] = {
-	{ .compatible = "syscon", },
-	{ },
-};
-
 static struct regmap_config syscon_regmap_config = {
 	.reg_bits = 32,
 	.val_bits = 32,
 	.reg_stride = 4,
 };
 
+static struct syscon *of_syscon_register(struct device_node *np)
+{
+	struct syscon *syscon;
+	struct regmap *regmap;
+	void __iomem *base;
+
+	if (!of_device_is_compatible(np, "syscon"))
+		return ERR_PTR(-EINVAL);
+
+	syscon = kzalloc(sizeof(*syscon), GFP_KERNEL);
+	if (!syscon)
+		return ERR_PTR(-ENOMEM);
+
+	base = of_iomap(np, 0);
+	if (!base)
+		return ERR_PTR(-ENOMEM);
+
+	regmap = regmap_init_mmio(NULL, base, &syscon_regmap_config);
+	if (IS_ERR(regmap)) {
+		pr_err("regmap init failed\n");
+		return ERR_CAST(regmap);
+	}
+
+	syscon->regmap = regmap;
+	syscon->np = np;
+
+	spin_lock(&syscon_list_slock);
+	list_add_tail(&syscon->list, &syscon_list);
+	spin_unlock(&syscon_list_slock);
+
+	return syscon;
+}
+
 static int syscon_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
@@ -167,7 +204,6 @@ static struct platform_driver syscon_driver = {
 	.driver = {
 		.name = "syscon",
 		.owner = THIS_MODULE,
-		.of_match_table = of_syscon_match,
 	},
 	.probe		= syscon_probe,
 	.id_table	= syscon_ids,
-- 
1.7.9.5

