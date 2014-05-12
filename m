Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752915AbaELGQo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 02:16:44 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:35459 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751115AbaELGQh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 02:16:37 -0400
X-AuditID: cbfee691-b7f3e6d000002ce8-3a-5370673eb3cb
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
        Shaik Ameer Basha <shaik.ameer@samsung.com>
Subject: [PATCH v13 04/19] iommu/exynos: fix L2TLB invalidation
Date: Mon, 12 May 2014 11:44:49 +0530
Message-id: <1399875304-19948-5-git-send-email-shaik.ameer@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1399875304-19948-1-git-send-email-shaik.ameer@samsung.com>
References: <1399875304-19948-1-git-send-email-shaik.ameer@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrBIsWRmVeSWpSXmKPExsWyRsSkStcuvSDYYPIbDYs7d8+xWvyddIzd
	Yv4RIOvVkR9MFgv2W1t0zt7AbvF91xd2i94FV9ksNj2+xmpxedccNosZ5/cxWVxYsZHd4l/v
	QUaLKYsOs1ocftPOanHyTy+jxZGHu9ktWq73Mlmsn/GaxWLVrj+MFjNvrWFxEPV4cnAek8fv
	X5MYPWY3XGTx+He4n8lj56y77B53ru1h89i8pN5j8o3ljB59W1YxenzeJOdx5egZpgDuKC6b
	lNSczLLUIn27BK6MF4v6WAv2SFYcnLuZrYHxjEgXIyeHhICJxI3Dp5kgbDGJC/fWs4HYQgJL
	GSUm75CCqfm4p5MZIr6IUaLrkkMXIxeQPYFJ4tGl/WANbAKGEtvvXWEFSYgIrGaU6Lt4hh3E
	YRaYzSxx5NFiRpAqYQF7iW975rOC2CwCqhJ/u4+AdfMKuEsc27QN6AwOoHUKEnMm2YCEOQU8
	JD6vngJ1EVDJq6tgCyQEVnJIzPyxnRlijoDEt8mHWCB6ZSU2HWCGuFpS4uCKGywTGIUXMDKs
	YhRNLUguKE5KLzLVK07MLS7NS9dLzs/dxAiM1dP/nk3cwXj/gPUhxmSgcROZpUST84GxnlcS
	b2hsZmRhamJqbGRuaUaasJI4b/qjpCAhgfTEktTs1NSC1KL4otKc1OJDjEwcnFINjJkn2d7Y
	2/VPvCu47Idy89XQS/fMDm1hniMyZ8+L/Jjpe8K4GM89/mu8vpldpq/C+Ni0q+F8Bw9FMVRO
	u2yZxc/7jvfnusypNhwnr85U+fUifWr73OoKRyXeah2Ts8nVj553zFtW2upjGFDs8fxiXEf5
	2Uf7ZnIuNznYt/nLPeGX786VsV/mVlZiKc5INNRiLipOBABhRgSp6wIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrGKsWRmVeSWpSXmKPExsVy+t9jAV279IJggxlX5Szu3D3HavF30jF2
	i/lHgKxXR34wWSzYb23ROXsDu8X3XV/YLXoXXGWz2PT4GqvF5V1z2CxmnN/HZHFhxUZ2i3+9
	Bxktpiw6zGpx+E07q8XJP72MFkce7ma3aLney2SxfsZrFotVu/4wWsy8tYbFQdTjycF5TB6/
	f01i9JjdcJHF49/hfiaPnbPusnvcubaHzWPzknqPyTeWM3r0bVnF6PF5k5zHlaNnmAK4oxoY
	bTJSE1NSixRS85LzUzLz0m2VvIPjneNNzQwMdQ0tLcyVFPISc1NtlVx8AnTdMnOAPlVSKEvM
	KQUKBSQWFyvp22GaEBripmsB0xih6xsSBNdjZIAGEtYwZrxY1MdasEey4uDczWwNjGdEuhg5
	OSQETCQ+7ulkhrDFJC7cW88GYgsJLGKU6Lrk0MXIBWRPYJJ4dGk/WIJNwFBi+70rrCAJEYHV
	jBJ9F8+wgzjMArOZJY48WswIUiUsYC/xbc98VhCbRUBV4m/3EbBuXgF3iWObtjF1MXIArVOQ
	mDPJBiTMKeAh8Xn1FKjNQCWvrrJOYORdwMiwilE0tSC5oDgpPddQrzgxt7g0L10vOT93EyM4
	FTyT2sG4ssHiEKMAB6MSD+8HhoJgIdbEsuLK3EOMEhzMSiK8H/2BQrwpiZVVqUX58UWlOanF
	hxiTgY6ayCwlmpwPTFN5JfGGxibmpsamliYWJmaWpAkrifMeaLUOFBJITyxJzU5NLUgtgtnC
	xMEp1cBo8snVO8jspopGgUx/7Zyl9yWeH/gcvfqc57vD0izzHuff//t+U6CFq2mR6zsJlz1r
	OxvtElb3e/Z6dVksbBF7aMG22dec+ZyLcUtNlFsBZ6SpRICB4o9Pzz6Gd77b71sXb5sb6MqY
	aNI8tSq80WEHZ9eUSTpqDK0/9DZppbicYor6+fDUSyWW4oxEQy3mouJEAKuYxEFJAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cho KyongHo <pullip.cho@samsung.com>

L2TLB is 8-way set-associative TLB with 512 entries. The number of
sets is 64.
A single 4KB(small page) translation information is cached
only to a set whose index is the same with the lower 6 bits of the page
frame number.
A single 64KB(large page) translation information can be
cached to any 16 sets whose top two bits of their indices are the same
with the bit [5:4] of the page frame number.
A single 1MB(section) or larger translation information can be cached to
any set in the TLB.

It is required to invalidate entire sets that may cache the target
translation information to guarantee that the L2TLB has no stale data.

Signed-off-by: Cho KyongHo <pullip.cho@samsung.com>
Signed-off-by: Shaik Ameer Basha <shaik.ameer@samsung.com>
---
 drivers/iommu/exynos-iommu.c |   32 +++++++++++++++++++++++++++-----
 1 file changed, 27 insertions(+), 5 deletions(-)

diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
index 4ff4b0b..06fc70e 100644
--- a/drivers/iommu/exynos-iommu.c
+++ b/drivers/iommu/exynos-iommu.c
@@ -226,9 +226,14 @@ static void __sysmmu_tlb_invalidate(void __iomem *sfrbase)
 }
 
 static void __sysmmu_tlb_invalidate_entry(void __iomem *sfrbase,
-						unsigned long iova)
+				unsigned long iova, unsigned int num_inv)
 {
-	__raw_writel((iova & SPAGE_MASK) | 1, sfrbase + REG_MMU_FLUSH_ENTRY);
+	unsigned int i;
+	for (i = 0; i < num_inv; i++) {
+		__raw_writel((iova & SPAGE_MASK) | 1,
+				sfrbase + REG_MMU_FLUSH_ENTRY);
+		iova += SPAGE_SIZE;
+	}
 }
 
 static void __sysmmu_set_ptbase(void __iomem *sfrbase,
@@ -452,7 +457,8 @@ static bool exynos_sysmmu_disable(struct device *dev)
 	return disabled;
 }
 
-static void sysmmu_tlb_invalidate_entry(struct device *dev, unsigned long iova)
+static void sysmmu_tlb_invalidate_entry(struct device *dev, unsigned long iova,
+					size_t size)
 {
 	unsigned long flags;
 	struct sysmmu_drvdata *data = dev_get_drvdata(dev->archdata.iommu);
@@ -460,9 +466,25 @@ static void sysmmu_tlb_invalidate_entry(struct device *dev, unsigned long iova)
 	read_lock_irqsave(&data->lock, flags);
 
 	if (is_sysmmu_active(data)) {
+		unsigned int maj;
+		unsigned int num_inv = 1;
+		maj = __raw_readl(data->sfrbase + REG_MMU_VERSION);
+		/*
+		 * L2TLB invalidation required
+		 * 4KB page: 1 invalidation
+		 * 64KB page: 16 invalidation
+		 * 1MB page: 64 invalidation
+		 * because it is set-associative TLB
+		 * with 8-way and 64 sets.
+		 * 1MB page can be cached in one of all sets.
+		 * 64KB page can be one of 16 consecutive sets.
+		 */
+		if ((maj >> 28) == 2) /* major version number */
+			num_inv = min_t(unsigned int, size / PAGE_SIZE, 64);
+
 		if (sysmmu_block(data->sfrbase)) {
 			__sysmmu_tlb_invalidate_entry(
-					data->sfrbase, iova);
+				data->sfrbase, iova, num_inv);
 			sysmmu_unblock(data->sfrbase);
 		}
 	} else {
@@ -915,7 +937,7 @@ done:
 
 	spin_lock_irqsave(&priv->lock, flags);
 	list_for_each_entry(data, &priv->clients, node)
-		sysmmu_tlb_invalidate_entry(data->dev, iova);
+		sysmmu_tlb_invalidate_entry(data->dev, iova, size);
 	spin_unlock_irqrestore(&priv->lock, flags);
 
 	return size;
-- 
1.7.9.5

