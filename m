Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753242AbaELGRI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 02:17:08 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:25809 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753192AbaELGRC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 02:17:02 -0400
X-AuditID: cbfee68d-b7f4e6d000004845-9f-5370675d9e06
From: Shaik Ameer Basha <shaik.ameer@samsung.com>
To: linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Cc: joro@8bytes.org, arnd@arndb.de, t.figa@samsung.com, kgene.kim@samsung.com,
        pullip.cho@samsung.com, a.motakis@virtualopensystems.com,
        grundler@chromium.org, s.nawrocki@samsung.com, prathyush.k@samsung.com,
        rahul.sharma@samsung.com, sachin.kamat@linaro.org,
        supash.ramaswamy@linaro.org, varun.sethi@freescale.com,
        joshi@samsung.com, tomasz.figa@gmail.com,
        Shaik Ameeer Basha <shaik.ameer@samsung.com>
Subject: [PATCH v13 14/19] iommu/exynos: add devices attached to the System MMU
 to an IOMMU group
Date: Mon, 12 May 2014 11:44:59 +0530
Message-id: <1399875304-19948-15-git-send-email-shaik.ameer@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1399875304-19948-1-git-send-email-shaik.ameer@samsung.com>
References: <1399875304-19948-1-git-send-email-shaik.ameer@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrFIsWRmVeSWpSXmKPExsWyRsSkRjc2vSDYYPtpbos7d8+xWvyddIzd
	Yv4RIOvVkR9MFgv2W1t0zt7AbvF91xd2i94FV9ksNj2+xmpxedccNosZ5/cxWVxYsZHd4l/v
	QUaLKYsOs1ocftPOanHyTy+jxZGHu9ktWq73Mlmsn/GaxWLVrj+MFjNvrWFxEPV4cnAek8fv
	X5MYPWY3XGTx+He4n8lj56y77B53ru1h89i8pN5j8o3ljB59W1YxenzeJOdx5egZpgDuKC6b
	lNSczLLUIn27BK6M98ePsRZ84KtYeLKZuYFxD08XIyeHhICJxI4pr5khbDGJC/fWs3UxcnEI
	CSxllPjdco0FpmjJ1tOMEIlFjBLzn79nhXAmMEncPvCKHaSKTcBQYvu9K2AJEYHVjBJ9F8+w
	gzjMAnOYJf5sn8cKUiUskCzxoucqE4jNIqAqMePXSrDlvAIeEstbOoCWcwDtU5CYM8kGJMwJ
	FP68egobiC0k4C5x7NVVsAUSAls4JNasmsgCMUdA4tvkQywQvbISmw5A/SMpcXDFDZYJjMIL
	GBlWMYqmFiQXFCelFxnqFSfmFpfmpesl5+duYgTG6+l/z3p3MN4+YH2IMRlo3ERmKdHkfGC8
	55XEGxqbGVmYmpgaG5lbmpEmrCTOm/QwKUhIID2xJDU7NbUgtSi+qDQntfgQIxMHp1QDo9O+
	iYdfH7hs296VUmaa3LBZv/Zwhff7ZwkO2TdKHRq/hE9t6LESmt6jGXVDIWP3vaWHJurLzF3H
	pPwwsm2T4f0mEX5Fj5CgskN+yUzKl30TTpi8i1n5tbLPXUvFuGGbWuCPK41fFjwWdp80LZL/
	w8tPkuvu77P+036Z9SLrFtUb9ZJrc38tVGIpzkg01GIuKk4EAD8bD4ntAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrOKsWRmVeSWpSXmKPExsVy+t9jAd2Y9IJgg6ZNxhZ37p5jtfg76Ri7
	xfwjQNarIz+YLBbst7bonL2B3eL7ri/sFr0LrrJZbHp8jdXi8q45bBYzzu9jsriwYiO7xb/e
	g4wWUxYdZrU4/Kad1eLkn15GiyMPd7NbtFzvZbJYP+M1i8WqXX8YLWbeWsPiIOrx5OA8Jo/f
	vyYxesxuuMji8e9wP5PHzll32T3uXNvD5rF5Sb3H5BvLGT36tqxi9Pi8Sc7jytEzTAHcUQ2M
	NhmpiSmpRQqpecn5KZl56bZK3sHxzvGmZgaGuoaWFuZKCnmJuam2Si4+AbpumTlAnyoplCXm
	lAKFAhKLi5X07TBNCA1x07WAaYzQ9Q0JgusxMkADCWsYM94fP8Za8IGvYuHJZuYGxj08XYyc
	HBICJhJLtp5mhLDFJC7cW8/WxcjFISSwiFFi/vP3rBDOBCaJ2wdesYNUsQkYSmy/dwUsISKw
	mlGi7+IZdhCHWWAOs8Sf7fNYQaqEBZIlXvRcZQKxWQRUJWb8WskMYvMKeEgsb+kA2sEBtE9B
	Ys4kG5AwJ1D48+opbCC2kIC7xLFXV1knMPIuYGRYxSiaWpBcUJyUnmukV5yYW1yal66XnJ+7
	iRGcDJ5J72Bc1WBxiFGAg1GJh/cDQ0GwEGtiWXFl7iFGCQ5mJRHej/5AId6UxMqq1KL8+KLS
	nNTiQ4zJQEdNZJYSTc4HJqq8knhDYxNzU2NTSxMLEzNL0oSVxHkPtloHCgmkJ5akZqemFqQW
	wWxh4uCUamDcJsPud3/CzUlsU5drt/w70HajKLZBoLRwZ88l0T8RwinzL66Nud1i8bH/jqbC
	8Y+mt3Wf3GGWXLLwgcWj10+i73tEK2mwBezl6HsftkRrcUrvyh9pt3eK7Tnuqf1K3tDVveZc
	4v6rjNquaid2p8vGhkW5d5ZNM4s47jwxcIrGdnHJqBB+lUolluKMREMt5qLiRADOc/73SgMA	AA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Antonios Motakis <a.motakis@virtualopensystems.com>

Patch written by Antonios Motakis <a.motakis@virtualopensystems.com>:

IOMMU groups are expected by certain users of the IOMMU API,
e.g. VFIO. Since each device is behind its own System MMU, we
can allocate a new IOMMU group for each device.

Reviewed-by: Cho KyongHo <pullip.cho@samsung.com>
Signed-off-by: Antonios Motakis <a.motakis@virtualopensystems.com>
Signed-off-by: Shaik Ameeer Basha <shaik.ameer@samsung.com>
---
 drivers/iommu/exynos-iommu.c |   28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
index 3291619..d18dc37 100644
--- a/drivers/iommu/exynos-iommu.c
+++ b/drivers/iommu/exynos-iommu.c
@@ -964,6 +964,32 @@ static phys_addr_t exynos_iommu_iova_to_phys(struct iommu_domain *domain,
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
@@ -972,6 +998,8 @@ static struct iommu_ops exynos_iommu_ops = {
 	.map = &exynos_iommu_map,
 	.unmap = &exynos_iommu_unmap,
 	.iova_to_phys = &exynos_iommu_iova_to_phys,
+	.add_device = &exynos_iommu_add_device,
+	.remove_device = &exynos_iommu_remove_device,
 	.pgsize_bitmap = SECT_SIZE | LPAGE_SIZE | SPAGE_SIZE,
 };
 
-- 
1.7.9.5

