Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752931AbaIVEpJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 00:45:09 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:22077 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752194AbaIVEpC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 00:45:02 -0400
X-AuditID: cbfee690-f79ab6d0000046f7-1b-541fa94b94ca
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: lee.jones@linaro.org, arnd@arndb.de, tomasz.figa@gmail.com,
        linux@arm.linux.org.uk, vikas.sajjan@samsung.com, joshi@samsung.com,
        naushad@samsung.com, thomas.ab@samsung.com, chow.kim@samsung.com,
        kgene.kim@samsung.com, b29396@freescale.com, Li.Xiubo@freescale.com,
        Pankaj Dubey <pankaj.dubey@samsung.com>
Subject: [PATCH v5] mfd: syscon: Decouple syscon interface from platform devices
Date: Mon, 22 Sep 2014 10:10:07 +0530
Message-id: <1411360807-7750-1-git-send-email-pankaj.dubey@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrFLMWRmVeSWpSXmKPExsWyRsSkRtd7pXyIQfdxC4u/k46xWzzc2c9i
	sWzSXTaL77u+sFv0LrjKZnH/61FGi84LHawWmx5fY7W4vGsOm8WM8/uYLG5f5rX4dPQ/q8Wi
	rUC1HcsYLVbt+sNocfPZdiYHAY+W5h42j9+/JjF6/Dvcz+Sxc9Zddo871/aweWxeUu/Rt2UV
	o8fnTXIBHFFcNimpOZllqUX6dglcGbMW1xfcNKto2NvO3MB4S6eLkZNDQsBEYsrTjWwQtpjE
	hXvrgWwuDiGBpYwSZyadZepi5AArOjUhGSK+iFHi77+VzBDOBCaJeZ9uMYN0swnoSjx5PxfM
	FhHIlui/vZoFxGYW2M0kcWh7IogtLBAg8eLmXVYQm0VAVWJ95yOwzbwC7hKbV95khFimIDFn
	kg3IfAmBS+wSl4+fYIGoF5D4NvkQC0SNrMSmA8wQR0tKHFxxg2UCo+ACRoZVjKKpBckFxUnp
	RSZ6xYm5xaV56XrJ+bmbGIFRcvrfswk7GO8dsD7EKMDBqMTD+6NFPkSINbGsuDL3EKMp0IaJ
	zFKiyfnAWMwriTc0NjOyMDUxNTYytzRTEud9LfUzWEggPbEkNTs1tSC1KL6oNCe1+BAjEwen
	VANjejC/t2uqreq+uJlPdu3b7X74/Yei1a221bsdrR6uFHfx79Xl6gxOiZ+uwiPeP31y1Ysn
	c2LmlaR/TRZd7lmelqHSoWI6/faLW2/1Ls8tddvwKt4us9A+/QPDb94y+SnKp6f4F95qP3PU
	aeaziDObnrw9uE9dcaps4FR5t6m+BfM+Ba71zLZSYinOSDTUYi4qTgQAzNSyPo0CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCIsWRmVeSWpSXmKPExsVy+t9jAV3vlfIhBqvPGVj8nXSM3eLhzn4W
	i2WT7rJZfN/1hd2id8FVNov7X48yWnRe6GC12PT4GqvF5V1z2CxmnN/HZHH7Mq/Fp6P/WS0W
	bQWq7VjGaLFq1x9Gi5vPtjM5CHi0NPewefz+NYnR49/hfiaPnbPusnvcubaHzWPzknqPvi2r
	GD0+b5IL4IhqYLTJSE1MSS1SSM1Lzk/JzEu3VfIOjneONzUzMNQ1tLQwV1LIS8xNtVVy8QnQ
	dcvMAXpASaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5vSBBcj5EBGkhYw5gxa3F9wU2zioa9
	7cwNjLd0uhg5OCQETCROTUjuYuQEMsUkLtxbz9bFyMUhJLCIUeLvv5XMEM4EJol5n24xg1Sx
	CehKPHk/F8wWEciW6L+9mgXEZhbYzSRxaHsiiC0sECDx4uZdVhCbRUBVYn3nIzYQm1fAXWLz
	ypuMEIsVJOZMspnAyL2AkWEVo2hqQXJBcVJ6rqFecWJucWleul5yfu4mRnAMPpPawbiyweIQ
	owAHoxIP74Im+RAh1sSy4srcQ4wSHMxKIrxHc4BCvCmJlVWpRfnxRaU5qcWHGE2Blk9klhJN
	zgemh7ySeENjE3NTY1NLEwsTM0slcd4DrdaBQgLpiSWp2ampBalFMH1MHJxSDYwZZZOLnqyQ
	Z+It8Z2aevW8Wcf+COV5j69ONdt+ymGNykYm3m+V7OsCjpR35Mw6kpe887lb7OkOv3mlzO/Y
	11+cnvJJfdWkvl9cM4v0E8VvvDU/NWNq+GK5VfY+dxNmRj+vvVSfv3PZ9WbJhzPmm6nvctvw
	1y3Oe+vPI5x7JjHFX9jb+ItB+2mbEktxRqKhFnNRcSIAdLHi3dcCAAA=
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
Tested-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
---
Patch v4 and related discussions can be found here [1].

Changes since v4:
 - Addressed Tomasz Figa's comments for v4.
 - Added error handing in of_syscon_register function.
 - Using devm_regmap_init_mmio instead of regmap_init_mmio.

Changes since v3:
 - Addressed Arnd's comment for v2.
 - Updated of_syscon_register for adding dev pointer in regmap_init_mmio.
 - For early users created dummy platform device.
   
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

[1]: https://lkml.org/lkml/2014/9/19/267

 drivers/mfd/syscon.c |  107 +++++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 85 insertions(+), 22 deletions(-)

diff --git a/drivers/mfd/syscon.c b/drivers/mfd/syscon.c
index ca15878..0b17f50 100644
--- a/drivers/mfd/syscon.c
+++ b/drivers/mfd/syscon.c
@@ -15,6 +15,7 @@
 #include <linux/err.h>
 #include <linux/io.h>
 #include <linux/module.h>
+#include <linux/list.h>
 #include <linux/of.h>
 #include <linux/of_address.h>
 #include <linux/of_platform.h>
@@ -22,31 +23,105 @@
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
+};
+
+static struct regmap_config syscon_regmap_config = {
+	.reg_bits = 32,
+	.val_bits = 32,
+	.reg_stride = 4,
 };
 
-static int syscon_match_node(struct device *dev, void *data)
+static struct syscon *of_syscon_register(struct device_node *np)
 {
-	struct device_node *dn = data;
+	struct platform_device *pdev = NULL;
+	struct syscon *syscon;
+	struct regmap *regmap;
+	void __iomem *base;
+	int ret;
+
+	if (!of_device_is_compatible(np, "syscon"))
+		return ERR_PTR(-EINVAL);
+
+	syscon = kzalloc(sizeof(*syscon), GFP_KERNEL);
+	if (!syscon)
+		return ERR_PTR(-ENOMEM);
+
+	base = of_iomap(np, 0);
+	if (!base) {
+		ret = -ENOMEM;
+		goto err_map;
+	}
+
+	/* if device is already populated and available then use it */
+	pdev = of_find_device_by_node(np);
+	if (!pdev) {
+		/* for early users create dummy syscon device and use it */
+		pdev = platform_device_alloc("dummy-syscon", -1);
+		if (!pdev) {
+			ret = -ENOMEM;
+			goto err_pdev;
+		}
+		pdev->dev.of_node = of_node_get(np);
+	}
+
+	regmap = devm_regmap_init_mmio(&pdev->dev, base, &syscon_regmap_config);
+	if (IS_ERR(regmap)) {
+		dev_err(&pdev->dev, "regmap init failed\n");
+		ret = PTR_ERR(regmap);
+		goto err_regmap;
+	}
+
+	syscon->regmap = regmap;
+	syscon->np = np;
 
-	return (dev->of_node == dn) ? 1 : 0;
+	spin_lock(&syscon_list_slock);
+	list_add_tail(&syscon->list, &syscon_list);
+	spin_unlock(&syscon_list_slock);
+
+	return syscon;
+
+err_regmap:
+	if (!strcmp(pdev->name, "dummy-syscon")) {
+		of_node_put(np);
+		platform_device_put(pdev);
+	}
+err_pdev:
+	iounmap(base);
+err_map:
+	kfree(syscon);
+	return ERR_PTR(ret);
 }
 
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
+
+	spin_unlock(&syscon_list_slock);
+
+	if (!syscon)
+		syscon = of_syscon_register(np);
+
+	if (IS_ERR(syscon))
+		return ERR_CAST(syscon);
 
 	return syscon->regmap;
 }
@@ -110,17 +185,6 @@ struct regmap *syscon_regmap_lookup_by_phandle(struct device_node *np,
 }
 EXPORT_SYMBOL_GPL(syscon_regmap_lookup_by_phandle);
 
-static const struct of_device_id of_syscon_match[] = {
-	{ .compatible = "syscon", },
-	{ },
-};
-
-static struct regmap_config syscon_regmap_config = {
-	.reg_bits = 32,
-	.val_bits = 32,
-	.reg_stride = 4,
-};
-
 static int syscon_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
@@ -167,7 +231,6 @@ static struct platform_driver syscon_driver = {
 	.driver = {
 		.name = "syscon",
 		.owner = THIS_MODULE,
-		.of_match_table = of_syscon_match,
 	},
 	.probe		= syscon_probe,
 	.id_table	= syscon_ids,
-- 
1.7.9.5

