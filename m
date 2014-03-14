Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755414AbaCNFM3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 01:12:29 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:52427 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752152AbaCNFM0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 01:12:26 -0400
X-AuditID: cbfee691-b7efc6d0000039d3-2b-53228fa9138f
Date: Fri, 14 Mar 2014 14:12:09 +0900
From: Cho KyongHo <pullip.cho@samsung.com>
To: Linux ARM Kernel <linux-arm-kernel@lists.infradead.org>,
        Linux DeviceTree <devicetree@vger.kernel.org>,
        Linux IOMMU <iommu@lists.linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Samsung SOC <linux-samsung-soc@vger.kernel.org>
Cc: Antonios Motakis <a.motakis@virtualopensystems.com>,
        Grant Grundler <grundler@chromium.org>, Joerg Roedel <joro@8bytes.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Prathyush <prathyush.k@samsung.com>,
        Rahul Sharma <rahul.sharma@samsung.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Varun Sethi <Varun.Sethi@freescale.com>
Subject: [PATCH v11 22/27] iommu/exynos: add devices attached to the System MMU
 to an IOMMU group
Message-id: <20140314141209.f48ffd3314ee743deae3e2cb@samsung.com>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.10.14; i686-pc-mingw32)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrEIsWRmVeSWpSXmKPExsVy+t8zA92V/UrBBltn6lvcuXuO1WL+ESDx
	6sgPJosF+60tOmdvYLfoXXCVzWLT42usFpd3zWGzmHF+H5PFhRUb2S2mLDrManH4TTurxck/
	vYwW62e8ZrGYeWsNiwO/x5OD85g8ZjdcZPH4d7ifyePOtT1sHpuX1HtMvrGc0aNvyypGj8+b
	5DyuHD3DFMAZxWWTkpqTWZZapG+XwJXR1jWPueAXb8W7h8tYGxgvc3cxcnJICJhITL/0jhXC
	FpO4cG89WxcjF4eQwDJGiX89O5hhii5+2QyVWMQo8bP3AZQzmUmid8pOpi5GDg4WAVWJk9ed
	QRrYBLQkVs89zghSIyLQxiTxtfEQC4jDLDCXWeLjtzlsIFXCAskSn/7OYgGxeQUcJdY23oFa
	ZyFxoamDHSIuKPFj8j2wGmagqZu3NbFC2PISm9e8ZQYZKiHQySGx8l8fWBGLgIDEt8kg2ziA
	ErISmw5AzZSUOLjiBssERpFZSMbOQjJ2FpKxCxiZVzGKphYkFxQnpReZ6hUn5haX5qXrJefn
	bmKExO/EHYz3D1gfYkwGWjmRWUo0OR8Y/3kl8YbGZkYWpiamxkbmlmakCSuJ86Y/SgoSEkhP
	LEnNTk0tSC2KLyrNSS0+xMjEwSnVwGi+dl3owzTxhfs5LAK5K7a9sV/4O/r+bseNRlHub7+d
	jrD4sXtGidDrtVd0d0V6hgnab/XvtJx8vfRlQEyG3efU7j/ld/XPuBoGLZ31sKf9gYTdCcdw
	za2TZ+9ddFRE+2rBoy2xWnPO/5e4O6/v+qynj/V335dLNlF531Yw70mib+Z2fvNbX7YqsRRn
	JBpqMRcVJwIABa9Of/UCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrPKsWRmVeSWpSXmKPExsVy+t9jAd2V/UrBBhe3alrcuXuO1WL+ESDx
	6sgPJosF+60tOmdvYLfoXXCVzWLT42usFpd3zWGzmHF+H5PFhRUb2S2mLDrManH4TTurxck/
	vYwW62e8ZrGYeWsNiwO/x5OD85g8ZjdcZPH4d7ifyePOtT1sHpuX1HtMvrGc0aNvyypGj8+b
	5DyuHD3DFMAZ1cBok5GamJJapJCal5yfkpmXbqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIT
	oOuWmQP0gZJCWWJOKVAoILG4WEnfDtOE0BA3XQuYxghd35AguB4jAzSQsI4xo61rHnPBL96K
	dw+XsTYwXubuYuTkkBAwkbj4ZTMbhC0mceHeeiCbi0NIYBGjxM/eB1DOZCaJ3ik7mboYOThY
	BFQlTl53BmlgE9CSWD33OCNIjYhAG5PE18ZDLCAOs8BcZomP3+aAjRUWSJb49HcWC4jNK+Ao
	sbbxDjPEOguJC00d7BBxQYkfk++B1TADTd28rYkVwpaX2LzmLfMERr5ZSMpmISmbhaRsASPz
	KkbR1ILkguKk9FxDveLE3OLSvHS95PzcTYzg5PBMagfjygaLQ4wCHIxKPLwOhxWDhVgTy4or
	cw8xSnAwK4nwVkUoBQvxpiRWVqUW5ccXleakFh9iTAZ6eyKzlGhyPjBx5ZXEGxqbmBlZGplZ
	GJmYm5MmrCTOe6DVOlBIID2xJDU7NbUgtQhmCxMHp1QDo+9fMdn0V6sPOxl/lpR+4mS0dJn9
	9xQZ+QzeSSv3Rr85kLe++afCqc1KmuJOcg28WUtnxbnN3DJJKuHW4pMqfT+VprjciPQVZl6m
	GebOcExpd0IDR/CaOWsPMe1+mO0horVUxMq+95Js+eL3ridETp1mEpJzWMK5yzEy7F+z7e6z
	67rDtkz8rsRSnJFoqMVcVJwIAOPYq55SAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch written by Antonios Motakis <a.motakis@virtualopensystems.com>:

IOMMU groups are expected by certain users of the IOMMU API,
e.g. VFIO. Since each device is behind its own System MMU, we
can allocate a new IOMMU group for each device.

Reviewd-by: Cho KyongHo <pullip.cho@samsung.com>
Signed-off-by: Antonios Motakis <a.motakis@virtualopensystems.com>
---
 drivers/iommu/exynos-iommu.c |   28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
index 543ea2e0..2beb197 100644
--- a/drivers/iommu/exynos-iommu.c
+++ b/drivers/iommu/exynos-iommu.c
@@ -1213,6 +1213,32 @@ static phys_addr_t exynos_iommu_iova_to_phys(struct iommu_domain *domain,
 	return phys;
 }
 
+static int exynos_iommu_add_device(struct device *dev)
+{
+	struct iommu_group *group;
+	int ret;
+
+	group = iommu_group_get(dev);
+
+	if (!group) {
+		group = iommu_group_alloc();
+		if (IS_ERR(group)) {
+			dev_err(dev, "Failed to allocate IOMMU group\n");
+			return PTR_ERR(group);
+		}
+	}
+
+	ret = iommu_group_add_device(group, dev);
+	iommu_group_put(group);
+
+	return ret;
+}
+
+static void exynos_iommu_remove_device(struct device *dev)
+{
+	iommu_group_remove_device(dev);
+}
+
 static struct iommu_ops exynos_iommu_ops = {
 	.domain_init = &exynos_iommu_domain_init,
 	.domain_destroy = &exynos_iommu_domain_destroy,
@@ -1221,6 +1247,8 @@ static struct iommu_ops exynos_iommu_ops = {
 	.map = &exynos_iommu_map,
 	.unmap = &exynos_iommu_unmap,
 	.iova_to_phys = &exynos_iommu_iova_to_phys,
+	.add_device = &exynos_iommu_add_device,
+	.remove_device = &exynos_iommu_remove_device,
 	.pgsize_bitmap = SECT_SIZE | LPAGE_SIZE | SPAGE_SIZE,
 };
 
-- 
1.7.9.5

