Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753382AbaI2Iwj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 04:52:39 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:21175 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753189AbaI2Iwd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 04:52:33 -0400
X-AuditID: cbfee68d-f79296d000004278-df-54291dce58a5
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Cc: arnd@arndb.de, b29396@freescale.com, lee.jones@linaro.org,
        boris.brezillon@free-electrons.com, tomasz.figa@gmail.com,
        linux@arm.linux.org.uk, vikas.sajjan@samsung.com, naushad@samsung.com,
        thomas.ab@samsung.com, kgene.kim@samsung.com, Li.Xiubo@freescale.com,
        geert+renesas@glider.be, swarren@nvidia.com,
        Pankaj Dubey <pankaj.dubey@samsung.com>
Subject: [PATCH v6] mfd: syscon: Decouple syscon interface from platform devices
Date: Mon, 29 Sep 2014 14:17:38 +0530
Message-id: <1411980458-32329-1-git-send-email-pankaj.dubey@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupjkeLIzCtJLcpLzFFi42JZI2JSo3tOVjPE4PFhSYu/k46xWzzc2c9i
	ceDFQhaLubMnMVr0LrjKZnH/61FGi84LHawWmx5fY7W4vGsOm8WM8/uYLG5f5rX4dPQ/q8Wi
	rV/YLW5Mb2G16FjGaLFq1x9Gi5vPtjM5CHq0NPewefz+NYnR48mmi4we/w73M3lMPKvrsXPW
	XXaPO9f2sHlsXlLv0dv8js2jb8sqRo/Pm+QCuKO4bFJSczLLUov07RK4Ml7PfMRW0GlXsfr5
	QqYGxudGXYycHBICJhJ7dk5mgrDFJC7cW8/WxcjFISSwlFFiyrWpbDBFd568h0osYpTYNv8N
	lDOBSeLI9Idg7WwCuhJP3s9lBrFFBLIlfnybzAJiMws8ZZL4/UESxBYWCJDYsf04UJyDg0VA
	VeLAvCKQMK+Ah8S+o+/ZQcISAgoScybZgIyXEPjILrFlzgKw8SwCAhLfJh9igaiRldh0gBni
	NkmJgytusExgFFzAyLCKUTS1ILmgOCm9yFCvODG3uDQvXS85P3cTIzCaTv971ruD8fYB60OM
	AhyMSjy8G5ZqhAixJpYVV+YeYjQF2jCRWUo0OR8Ys3kl8YbGZkYWpiamxkbmlmZK4ryKUj+D
	hQTSE0tSs1NTC1KL4otKc1KLDzEycXBKNTAyGGb8ObCe9RWbY8Cnx8bh9os2Kf1i5SsX57SN
	YP668kisPJd3h0+QUyuv8bb1H5sZXSSPqob6q95/Okng8jeeszNdvC5kNulWVOhVGD5vZbHg
	ued2i3ltefb/r1eS2Lmff1LR1e20Ohq6pF5tY+j0Q0rVH599lH7R9mtGRGv7gTsvxedqCiix
	FGckGmoxFxUnAgDnlVKkoQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrBIsWRmVeSWpSXmKPExsVy+t9jAd1zspohBpP2CFj8nXSM3eLhzn4W
	iwMvFrJYzJ09idGid8FVNov7X48yWnRe6GC12PT4GqvF5V1z2CxmnN/HZHH7Mq/Fp6P/WS0W
	bf3CbnFjegurRccyRotVu/4wWtx8tp3JQdCjpbmHzeP3r0mMHk82XWT0+He4n8lj4lldj52z
	7rJ73Lm2h81j85J6j97md2wefVtWMXp83iQXwB3VwGiTkZqYklqkkJqXnJ+SmZduq+QdHO8c
	b2pmYKhraGlhrqSQl5ibaqvk4hOg65aZA/STkkJZYk4pUCggsbhYSd8O04TQEDddC5jGCF3f
	kCC4HiMDNJCwhjHj9cxHbAWddhWrny9kamB8btTFyMkhIWAicefJezYIW0ziwr31QDYXh5DA
	IkaJbfPfQDkTmCSOTH/IBFLFJqAr8eT9XGYQW0QgW+LHt8ksIDazwFMmid8fJEFsYYEAiR3b
	jwPFOThYBFQlDswrAgnzCnhI7Dv6nh0kLCGgIDFnks0ERu4FjAyrGEVTC5ILipPScw31ihNz
	i0vz0vWS83M3MYJj9ZnUDsaVDRaHGAU4GJV4eDcs1QgRYk0sK67MPcQowcGsJMKrJq0ZIsSb
	klhZlVqUH19UmpNafIjRFGj3RGYp0eR8YBrJK4k3NDYxNzU2tTSxMDGzVBLnPdBqHSgkkJ5Y
	kpqdmlqQWgTTx8TBKdXAyLdW/vDSkpba9W4r2ncuWtAVt/b76uOsJv8MJGLt+aSC876WJC43
	4LM7x3Brk0roucCAu6/9m+WCb72cteSK9N5jGy7My89niWuJc9ket/ytmUTEtL0auSarp3XX
	aTTyd4SvC8qbIvbBIkFm3839V1nNYqeUFB483Tjl/9fCSE4zvojgs9s8lViKMxINtZiLihMB
	LfY80+sCAAA=
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
we can completely remove platform driver of syscon, and keep only helper
functions to get regmap handles.

Suggested-by: Arnd Bergmann <arnd@arndb.de>
Suggested-by: Tomasz Figa <tomasz.figa@gmail.com>
Tested-by: Vivek Gautam <gautam.vivek@samsung.com>
Tested-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
---
Patch v5 and related discussions can be found here [1].

Change since v5:
 - Dropping creation of dummy platform device in of_syscon_register.
 - As we are changing syscon to decouple from platform_device, creation of 
   dummy platform_device does not look good option, and as suggested by Arnd,
   I made another attempt so that regmap_mmio_init API should work with NULL
   dev pointer itself. Since regmap needs to know about Syscon device node
   properties so let's parse device node of syscon in syscon itself for any
   such properties and using regmap_config parameter pass all such information
   to regmap. Other concern of crashes due to NULL dev pointer in regmap already
   addressed in separate patches of regmap. Please see [2] and [3].
  

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

[1]: https://lkml.org/lkml/2014/9/22/12
[2]: https://lkml.org/lkml/2014/9/18/130
[3]: https://lkml.org/lkml/2014/9/27/2

 drivers/mfd/syscon.c |  106 +++++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 84 insertions(+), 22 deletions(-)

diff --git a/drivers/mfd/syscon.c b/drivers/mfd/syscon.c
index ca15878..00a8410 100644
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
@@ -22,31 +23,104 @@
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
+	struct syscon *syscon;
+	struct regmap *regmap;
+	void __iomem *base;
+	int ret;
+	enum regmap_endian endian = REGMAP_ENDIAN_DEFAULT;
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
+	/* Parse the device's DT node for an endianness specification */
+	if (of_property_read_bool(np, "big-endian"))
+		endian = REGMAP_ENDIAN_BIG;
+	 else if (of_property_read_bool(np, "little-endian"))
+		endian = REGMAP_ENDIAN_LITTLE;
+
+	/* If the endianness was specified in DT, use that */
+	if (endian != REGMAP_ENDIAN_DEFAULT)
+		syscon_regmap_config.val_format_endian = endian;
+
+	regmap = regmap_init_mmio(NULL, base, &syscon_regmap_config);
+	if (IS_ERR(regmap)) {
+		pr_err("regmap init failed\n");
+		ret = PTR_ERR(regmap);
+		goto err_regmap;
+	}
+
+	syscon->regmap = regmap;
+	syscon->np = np;
+
+	spin_lock(&syscon_list_slock);
+	list_add_tail(&syscon->list, &syscon_list);
+	spin_unlock(&syscon_list_slock);
 
-	return (dev->of_node == dn) ? 1 : 0;
+	/* Change back endianness of syscon_regmap_config.
+	 * As this is static config in this file and in one system we may
+	 * have more than one syscon
+	 */
+	syscon_regmap_config.val_format_endian = REGMAP_ENDIAN_DEFAULT;
+
+	return syscon;
+
+err_regmap:
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
@@ -110,17 +184,6 @@ struct regmap *syscon_regmap_lookup_by_phandle(struct device_node *np,
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
@@ -167,7 +230,6 @@ static struct platform_driver syscon_driver = {
 	.driver = {
 		.name = "syscon",
 		.owner = THIS_MODULE,
-		.of_match_table = of_syscon_match,
 	},
 	.probe		= syscon_probe,
 	.id_table	= syscon_ids,
-- 
1.7.9.5

