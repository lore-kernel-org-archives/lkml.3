Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754019AbaIBOrW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 10:47:22 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:9212 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752611AbaIBOrU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 10:47:20 -0400
X-AuditID: cbfee691-f79546d0000011a1-76-5405d876754b
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: lee.jones@linaro.org, kgene.kim@samsung.com, linux@arm.linux.org.uk,
        arnd@arndb.de, vikas.sajjan@samsung.com, joshi@samsung.com,
        naushad@samsung.com, thomas.ab@samsung.com, chow.kim@samsung.com,
        tomasz.figa@gmail.com, Pankaj Dubey <pankaj.dubey@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>
Subject: [PATCH v2] mfd: syscon: Decouple syscon interface from platform devices
Date: Tue, 02 Sep 2014 20:12:15 +0530
Message-id: <1409668935-10667-1-git-send-email-pankaj.dubey@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrELMWRmVeSWpSXmKPExsWyRsSkVrfsBmuIwYTfQhZ/Jx1jt1g26S6b
	xfddX9gtehdcZbO4//Uoo8Wmx9dYLS7vmsNmMeP8PiaL25d5LT4d/c9qsWgrUNn6Ga9ZLDqW
	MVqs2vWH0eLms+1MDvweLc09bB6/f01i9Ng56y67x51re9g8Ni+p9+jbsorR4/MmuQD2KC6b
	lNSczLLUIn27BK6M7bMlC47bVJzpu8DUwLjIqIuRk0NCwERiyfsWZghbTOLCvfVsXYxcHEIC
	Sxkl3p6+ygZT9HvOARaIxHRGiclXupghnAlMEtumL2EFqWIT0JV48n4u2CgRgWyJ/turwTqY
	BdYzSXza8A6sSFggQGLZu+mMIDaLgKrE8/kz2UFsXgEPiUV/lwA1cACtU5CYM8kGpFdC4Bi7
	xKf250wQ9QIS3yYfgqqRldh0AOpsSYmDK26wTGAUXMDIsIpRNLUguaA4Kb3IVK84Mbe4NC9d
	Lzk/dxMjMCpO/3s2cQfj/QPWhxgFOBiVeHglfrCECLEmlhVX5h5iNAXaMJFZSjQ5Hxh7eSXx
	hsZmRhamJqbGRuaWZkrivDrSP4OFBNITS1KzU1MLUovii0pzUosPMTJxcEo1MKY/jZ4TmCzz
	/dbvhJszv8c+Lnj91PS0ApeZ6N5S+WNrjjtFz5i9uKrU78+uxQWX/rBN+F948khDXutj5qlF
	D9frL028/+jB6tvzNNpWzJGS//y/ZZpf4fvYe3edeb9U1q18tox57vMpauHqhY+v3N5zQfDN
	Gik5tpchxWJPJ+qbcZ3pWmZ1NktaiaU4I9FQi7moOBEAiTzZ0IUCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrDIsWRmVeSWpSXmKPExsVy+t9jQd2yG6whBjvWclj8nXSM3WLZpLts
	Ft93fWG36F1wlc3i/tejjBabHl9jtbi8aw6bxYzz+5gsbl/mtfh09D+rxaKtQGXrZ7xmsehY
	xmixatcfRoubz7YzOfB7tDT3sHn8/jWJ0WPnrLvsHneu7WHz2Lyk3qNvyypGj8+b5ALYoxoY
	bTJSE1NSixRS85LzUzLz0m2VvIPjneNNzQwMdQ0tLcyVFPISc1NtlVx8AnTdMnOAzlZSKEvM
	KQUKBSQWFyvp22GaEBripmsB0xih6xsSBNdjZIAGEtYwZmyfLVlw3KbiTN8FpgbGRUZdjJwc
	EgImEr/nHGCBsMUkLtxbz9bFyMUhJDCdUWLylS5mCGcCk8S26UtYQarYBHQlnryfywxiiwhk
	S/TfXs0CUsQssJ5J4tOGd2BFwgIBEsveTWcEsVkEVCWez5/JDmLzCnhILPq7BKiBA2idgsSc
	STYTGLkXMDKsYhRNLUguKE5KzzXUK07MLS7NS9dLzs/dxAiOuWdSOxhXNlgcYhTgYFTi4ZX8
	wRIixJpYVlyZe4hRgoNZSYR370XWECHelMTKqtSi/Pii0pzU4kOMpkDLJzJLiSbnA9NBXkm8
	obGJuamxqaWJhYmZpZI474FW60AhgfTEktTs1NSC1CKYPiYOTqkGxn0hM5cHKe5IU3Dc+t7u
	y+6yF+cfBP1YUyRVbSP99dCpZ6Wa98tPaCU7d67I8LU3WPBgyVzZZSVvltSyuM/TTtoSaW/+
	2vvTndNbIorrcy3v8Z1QKpbJZA9WO2tf6X1Tln2SuaVZm3n1ba+/u7o+1c9bbHSrMD1WqjJx
	59W3y88ulHB021dWqsRSnJFoqMVcVJwIAOwuU+fPAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently a syscon entity can only be registered directly through a
platform device that binds to a dedicated syscon driver. However in
certain cases it is required to bind a device with it's dedicated
driver rather than binding with syscon driver.

For example, certain SoCs (e.g. Exynos) contain system controller
blocks which perform various functions such as power domain control,
CPU power management, low power mode control, but in addition contain
certain IP integration glue, such as various signal masks,
coprocessor power control, etc. In such case, there is a need to have
a dedicated driver for such system controller but also share registers
with other drivers. The latter is where the syscon interface is helpful.

This patch decouples syscon object from syscon platform driver, and
allows to create syscon objects first time when it is required by
calling of syscon_regmap_lookup_by APIs and keeps a list of such syscon
objects along with syscon provider device_nodes and regmap handles.

Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
Signed-off-by: Tomasz Figa <t.figa@samsung.com>
---
V1 of this patchset [1] and related discussion can be found here [1].
 
Changes since v1:
 - Removed of_syscon_unregister function.
 - Modified of_syscon_register function and it will be used by syscon.c 
   to create syscon objects whenever required. 
 - Removed platform device support from syscon.
 - Removed syscon_regmap_lookup_by_pdevname API support.
 - As there are significant changes w.r.t patchset v1, I am taking over
   author for this patchset from Tomasz Figa.
 
Note: Current kernel has clps711x user of syscon_regmap_lookup_by_pdevname and 
will be broken after this patch. As per discussion over here [1], patches 
for making these drivers DT based are ready and once that is done they can use
syscon_regmap_lookup_by_phandle or syscon_regmap_lookup_by_compatible.

[1]: https://lkml.org/lkml/2014/8/22/81


 drivers/mfd/syscon.c       |  143 +++++++++++++-------------------------------
 include/linux/mfd/syscon.h |    1 +
 2 files changed, 44 insertions(+), 100 deletions(-)

diff --git a/drivers/mfd/syscon.c b/drivers/mfd/syscon.c
index ca15878..8247e93 100644
--- a/drivers/mfd/syscon.c
+++ b/drivers/mfd/syscon.c
@@ -14,41 +14,45 @@
 
 #include <linux/err.h>
 #include <linux/io.h>
-#include <linux/module.h>
+#include <linux/list.h>
 #include <linux/of.h>
 #include <linux/of_address.h>
-#include <linux/of_platform.h>
-#include <linux/platform_data/syscon.h>
-#include <linux/platform_device.h>
 #include <linux/regmap.h>
 #include <linux/mfd/syscon.h>
+#include <linux/slab.h>
 
-static struct platform_driver syscon_driver;
+static DEFINE_SPINLOCK(syscon_list_slock);
+static LIST_HEAD(syscon_list);
 
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
+
+	spin_lock(&syscon_list_slock);
 
-	dev = driver_find_device(&syscon_driver.driver, NULL, np,
-				 syscon_match_node);
-	if (!dev)
-		return ERR_PTR(-EPROBE_DEFER);
+	list_for_each_entry(entry, &syscon_list, list)
+		if (entry->np == np) {
+			syscon = entry;
+			break;
+		}
 
-	syscon = dev_get_drvdata(dev);
+	spin_unlock(&syscon_list_slock);
 
-	return syscon->regmap;
+	if (!syscon)
+		syscon = of_syscon_register(np);
+
+	if (!IS_ERR(syscon))
+		return syscon->regmap;
+	else
+		return ERR_CAST(syscon);
 }
 EXPORT_SYMBOL_GPL(syscon_node_to_regmap);
 
@@ -68,27 +72,6 @@ struct regmap *syscon_regmap_lookup_by_compatible(const char *s)
 }
 EXPORT_SYMBOL_GPL(syscon_regmap_lookup_by_compatible);
 
-static int syscon_match_pdevname(struct device *dev, void *data)
-{
-	return !strcmp(dev_name(dev), (const char *)data);
-}
-
-struct regmap *syscon_regmap_lookup_by_pdevname(const char *s)
-{
-	struct device *dev;
-	struct syscon *syscon;
-
-	dev = driver_find_device(&syscon_driver.driver, NULL, (void *)s,
-				 syscon_match_pdevname);
-	if (!dev)
-		return ERR_PTR(-EPROBE_DEFER);
-
-	syscon = dev_get_drvdata(dev);
-
-	return syscon->regmap;
-}
-EXPORT_SYMBOL_GPL(syscon_regmap_lookup_by_pdevname);
-
 struct regmap *syscon_regmap_lookup_by_phandle(struct device_node *np,
 					const char *property)
 {
@@ -110,81 +93,41 @@ struct regmap *syscon_regmap_lookup_by_phandle(struct device_node *np,
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
 
-static int syscon_probe(struct platform_device *pdev)
+static struct syscon *of_syscon_register(struct device_node *np)
 {
-	struct device *dev = &pdev->dev;
-	struct syscon_platform_data *pdata = dev_get_platdata(dev);
 	struct syscon *syscon;
-	struct resource *res;
+	struct regmap *regmap;
 	void __iomem *base;
 
-	syscon = devm_kzalloc(dev, sizeof(*syscon), GFP_KERNEL);
-	if (!syscon)
-		return -ENOMEM;
+	if (!of_device_is_compatible(np, "syscon"))
+		return ERR_PTR(-EINVAL);
 
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res)
-		return -ENOENT;
+	syscon = kzalloc(sizeof(*syscon), GFP_KERNEL);
+	if (!syscon)
+		return ERR_PTR(-ENOMEM);
 
-	base = devm_ioremap(dev, res->start, resource_size(res));
+	base = of_iomap(np, 0);
 	if (!base)
-		return -ENOMEM;
-
-	syscon_regmap_config.max_register = res->end - res->start - 3;
-	if (pdata)
-		syscon_regmap_config.name = pdata->label;
-	syscon->regmap = devm_regmap_init_mmio(dev, base,
-					&syscon_regmap_config);
-	if (IS_ERR(syscon->regmap)) {
-		dev_err(dev, "regmap init failed\n");
-		return PTR_ERR(syscon->regmap);
-	}
-
-	platform_set_drvdata(pdev, syscon);
+		return ERR_PTR(-ENOMEM);
 
-	dev_dbg(dev, "regmap %pR registered\n", res);
-
-	return 0;
-}
-
-static const struct platform_device_id syscon_ids[] = {
-	{ "syscon", },
-	{ }
-};
+	regmap = regmap_init_mmio(NULL, base, &syscon_regmap_config);
+	if (IS_ERR(regmap)) {
+		pr_err("regmap init failed\n");
+		return ERR_CAST(regmap);
+	}
 
-static struct platform_driver syscon_driver = {
-	.driver = {
-		.name = "syscon",
-		.owner = THIS_MODULE,
-		.of_match_table = of_syscon_match,
-	},
-	.probe		= syscon_probe,
-	.id_table	= syscon_ids,
-};
+	syscon->regmap = regmap;
+	syscon->np = np;
 
-static int __init syscon_init(void)
-{
-	return platform_driver_register(&syscon_driver);
-}
-postcore_initcall(syscon_init);
+	spin_lock(&syscon_list_slock);
+	list_add_tail(&syscon->list, &syscon_list);
+	spin_unlock(&syscon_list_slock);
 
-static void __exit syscon_exit(void)
-{
-	platform_driver_unregister(&syscon_driver);
+	return syscon;
 }
-module_exit(syscon_exit);
-
-MODULE_AUTHOR("Dong Aisheng <dong.aisheng@linaro.org>");
-MODULE_DESCRIPTION("System Control driver");
-MODULE_LICENSE("GPL v2");
diff --git a/include/linux/mfd/syscon.h b/include/linux/mfd/syscon.h
index 75e543b..a8e4c4b 100644
--- a/include/linux/mfd/syscon.h
+++ b/include/linux/mfd/syscon.h
@@ -18,6 +18,7 @@
 #include <linux/err.h>
 
 struct device_node;
+struct regmap;
 
 #ifdef CONFIG_MFD_SYSCON
 extern struct regmap *syscon_node_to_regmap(struct device_node *np);
-- 
1.7.9.5

