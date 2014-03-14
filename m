Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755907AbaCNFOW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 01:14:22 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:52711 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755485AbaCNFOR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 01:14:17 -0400
X-AuditID: cbfee691-b7efc6d0000039d3-56-5322900bed6c
Date: Fri, 14 Mar 2014 14:13:46 +0900
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
Subject: [PATCH v11 25/27] iommu/exynos: use simpler function to get MMU version
Message-id: <20140314141346.101ae9148289467808857d13@samsung.com>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.10.14; i686-pc-mingw32)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMIsWRmVeSWpSXmKPExsVy+t8zI13uCUrBBtfbNC3u3D3HajH/CJB4
	deQHk8WC/dYWnbM3sFv0LrjKZrHp8TVWi8u75rBZzDi/j8niwoqN7BZTFh1mtTj8pp3V4uSf
	XkaL9TNes1jMvLWGxYHf48nBeUwesxsusnj8O9zP5HHn2h42j81L6j0m31jO6NG3ZRWjx+dN
	ch5Xjp5hCuCM4rJJSc3JLEst0rdL4Mr4ca2DveA/f8X8BycZGxiv83QxcnJICJhIfH/QxgJh
	i0lcuLeerYuRi0NIYBmjxLzOTlaYovuzTjJDJBYxSrw72QpVNZlJYu6HBrAqFgFVifNbTrCB
	2GwCWhKr5x5nBCkSEWhjkvjaeIgFxGEWmMss8fHbHLAqYYEAiXtnpoHZvAKOEu+3LYfaZyFx
	oamDHSIuKPFj8j2wA5mBpm7e1sQKYctLbF7zFuwmCYFeDokNX48yQZwhIPFtMsg2DqCErMSm
	A8wQMyUlDq64wTKBUWQWkrGzkIydhWTsAkbmVYyiqQXJBcVJ6UWmesWJucWleel6yfm5mxgh
	ETxxB+P9A9aHGJOBVk5klhJNzgcmgLySeENjMyMLUxNTYyNzSzPShJXEedMfJQUJCaQnlqRm
	p6YWpBbFF5XmpBYfYmTi4JRqYFT2OSfMNGnVjm/Oq9fs7ZmeEn4upMq86eNZ5m2Gmf7Shct2
	NDyJ9YgS63RcYzfl7kE7MbOf5tu/XGO/qHDeOXfZK83/VbOK1+QmeD91XO9659KvRKfoZr0j
	ZyJNFTa65NzN21aQ3Fm1u+r149+amQHNnfZiso3en0TOtZV6yu5/x9yS4uDQp8RSnJFoqMVc
	VJwIAHNRzr32AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrAKsWRmVeSWpSXmKPExsVy+t9jAV3uCUrBBvcXKFjcuXuO1WL+ESDx
	6sgPJosF+60tOmdvYLfoXXCVzWLT42usFpd3zWGzmHF+H5PFhRUb2S2mLDrManH4TTurxck/
	vYwW62e8ZrGYeWsNiwO/x5OD85g8ZjdcZPH4d7ifyePOtT1sHpuX1HtMvrGc0aNvyypGj8+b
	5DyuHD3DFMAZ1cBok5GamJJapJCal5yfkpmXbqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIT
	oOuWmQP0gZJCWWJOKVAoILG4WEnfDtOE0BA3XQuYxghd35AguB4jAzSQsI4x48e1DvaC//wV
	8x+cZGxgvM7TxcjJISFgInF/1klmCFtM4sK99WxdjFwcQgKLGCXenWyFciYzScz90MAKUsUi
	oCpxfssJNhCbTUBLYvXc44wgRSICbUwSXxsPsYA4zAJzmSU+fpsDViUsECBx78w0MJtXwFHi
	/bblrBD7LCQuNHWwQ8QFJX5MvscCYjMDTd28rYkVwpaX2LzmLfMERr5ZSMpmISmbhaRsASPz
	KkbR1ILkguKk9FwjveLE3OLSvHS95PzcTYzg9PBMegfjqgaLQ4wCHIxKPLwzjioGC7EmlhVX
	5h5ilOBgVhLhrYpQChbiTUmsrEotyo8vKs1JLT7EmAz090RmKdHkfGDqyiuJNzQ2MTOyNDKz
	MDIxNydNWEmc92CrdaCQQHpiSWp2ampBahHMFiYOTqkGxhl1UcUFawrXNGlf2qHgHTBhsV3s
	55OTAtuf+djZKE5jOiSefe525t85fka3Dx56cK52pmVd1BHj59EXA/O9Y7kk9xx98vPnPfMf
	KlePPmpcKhu5Wyrpf/kKddEbl64925J+6Nr2fhm9LyVCL63evE9eE/nyftkLJqeeqJT9Utz6
	SyQ33dJ68EqJpTgj0VCLuag4EQAEQiU+UwMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit changes the function to get MMU version simpler.

Signed-off-by: Cho KyongHo <pullip.cho@samsung.com>
---
 drivers/iommu/exynos-iommu.c |   30 ++++++------------------------
 1 file changed, 6 insertions(+), 24 deletions(-)

diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
index 6e716cc..3d4dabb 100644
--- a/drivers/iommu/exynos-iommu.c
+++ b/drivers/iommu/exynos-iommu.c
@@ -251,24 +251,6 @@ static unsigned int __raw_sysmmu_version(struct sysmmu_drvdata *data)
 	return MMU_RAW_VER(__raw_readl(data->sfrbase + REG_MMU_VERSION));
 }
 
-static unsigned int __sysmmu_version(struct sysmmu_drvdata *data,
-				     unsigned int *minor)
-{
-	unsigned int ver = 0;
-
-	ver = __raw_sysmmu_version(data);
-	if (ver > MAKE_MMU_VER(3, 3)) {
-		dev_err(data->sysmmu, "%s: version(%d.%d) is higher than 3.3\n",
-			__func__, MMU_MAJ_VER(ver), MMU_MIN_VER(ver));
-		BUG();
-	}
-
-	if (minor)
-		*minor = MMU_MIN_VER(ver);
-
-	return MMU_MAJ_VER(ver);
-}
-
 static bool sysmmu_block(void __iomem *sfrbase)
 {
 	int i = 120;
@@ -422,13 +404,13 @@ static bool __sysmmu_disable(struct sysmmu_drvdata *data)
 static void __sysmmu_init_config(struct sysmmu_drvdata *data)
 {
 	unsigned int cfg = CFG_LRU | CFG_QOS(15);
-	int maj, min = 0;
+	unsigned int ver;
 
-	maj = __sysmmu_version(data, &min);
-	if (maj == 3) {
-		if (min >= 2) {
+	ver = __raw_sysmmu_version(data);
+	if (MMU_MAJ_VER(ver) == 3) {
+		if (MMU_MIN_VER(ver) >= 2) {
 			cfg |= CFG_FLPDCACHE;
-			if (min == 3) {
+			if (MMU_MIN_VER(ver) == 3) {
 				cfg |= CFG_ACGEN;
 				cfg &= ~CFG_LRU;
 			} else {
@@ -583,7 +565,7 @@ static void sysmmu_tlb_invalidate_entry(struct device *dev, sysmmu_iova_t iova,
 			 * 1MB page can be cached in one of all sets.
 			 * 64KB page can be one of 16 consecutive sets.
 			 */
-			if (__sysmmu_version(data, NULL) == 2)
+			if (MMU_MAJ_VER(__raw_sysmmu_version(data)) == 2)
 				num_inv = min_t(unsigned int,
 						size / PAGE_SIZE, 64);
 
-- 
1.7.9.5

