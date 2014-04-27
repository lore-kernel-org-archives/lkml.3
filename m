Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753908AbaD0Hla (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 03:41:30 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:31232 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753262AbaD0Hjw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 03:39:52 -0400
X-AuditID: cbfee691-b7f3e6d000002ce8-d2-535cb44702af
From: Shaik Ameer Basha <shaik.ameer@samsung.com>
To: linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Cc: kgene.kim@samsung.com, tomasz.figa@gmail.com, pullip.cho@samsung.com,
        a.motakis@virtualopensystems.com, grundler@chromium.org,
        joro@8bytes.org, prathyush.k@samsung.com, rahul.sharma@samsung.com,
        sachin.kamat@linaro.org, supash.ramaswamy@linaro.org,
        Varun.Sethi@freescale.com, s.nawrocki@samsung.com, t.figa@samsung.com,
        joshi@samsung.com
Subject: [PATCH v12 23/31] iommu/exynos: use simpler function to get MMU version
Date: Sun, 27 Apr 2014 13:07:55 +0530
Message-id: <1398584283-22846-24-git-send-email-shaik.ameer@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1398584283-22846-1-git-send-email-shaik.ameer@samsung.com>
References: <1398584283-22846-1-git-send-email-shaik.ameer@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFIsWRmVeSWpSXmKPExsWyRsSkVtd9S0ywwZROM4s7d8+xWsw/AiRe
	HfnBZLFgv7VF5+wN7Bbfd31ht+hdcJXNYtPja6wWl3fNYbOYcX4fk8WFFRvZLf71HmS0mLLo
	MKvF4TftrBYn//QyWrRc72WyWD/jNYvFql1/GC1m3lrD4iDs8eTgPCaP2Q0XWTz+He5n8tg5
	6y67x51re9g8Ni+p95h8YzmjR9+WVYwenzfJeVw5eoYpgCuKyyYlNSezLLVI3y6BK+PqiYSC
	tQIVEzv/sjcw/uPpYuTkkBAwkdi97xoThC0mceHeerYuRi4OIYGljBIXTixlhilqW76DFSKx
	iFFiyuTv7BDOBCaJbyvOsYBUsQkYSmy/dwWsSkRgNaNE38UzYFXMAneZJOasescIUiUsECDx
	Yu0cMJtFQFWie8ZKsOW8Ah4SW5c1A3VzAO1TkJgzyQYkzAkUfnJnD9gCIQF3ibenvoAtkBCY
	ySHRtK4Jao6AxLfJh1ggemUlNh2AOltS4uCKGywTGIUXMDKsYhRNLUguKE5KLzLVK07MLS7N
	S9dLzs/dxAiMx9P/nk3cwXj/gPUhxmSgcROZpUST84HxnFcSb2hsZmRhamJqbGRuaUaasJI4
	b/qjpCAhgfTEktTs1NSC1KL4otKc1OJDjEwcnFINjCIcd0V9QqK8pt9IyPt445z+ojW6r1bY
	PlKcsjqgNujU+39d7zboy3JoJm8x5HD9PfHO9yUHDp/mu2GrdO/hv40t4tksXSrJGxI137bt
	Zj/9zmjnpZ7mJQIPpt8yiZb8reG8ab3b97P3/0rmSwaeNrbr+/tD00auLa/EOlgofO3ErWfy
	JXbb/lZiKc5INNRiLipOBAB8KVLU3QIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrOKsWRmVeSWpSXmKPExsVy+t9jAV33LTHBBi+PalvcuXuO1WL+ESDx
	6sgPJosF+60tOmdvYLf4vusLu0XvgqtsFpseX2O1uLxrDpvFjPP7mCwurNjIbvGv9yCjxZRF
	h1ktDr9pZ7U4+aeX0aLlei+TxfoZr1ksVu36w2gx89YaFgdhjycH5zF5zG64yOLx73A/k8fO
	WXfZPe5c28PmsXlJvcfkG8sZPfq2rGL0+LxJzuPK0TNMAVxRDYw2GamJKalFCql5yfkpmXnp
	tkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUCvKSmUJeaUAoUCEouLlfTtME0IDXHT
	tYBpjND1DQmC6zEyQAMJaxgzrp5IKFgrUDGx8y97A+M/ni5GTg4JAROJtuU7WCFsMYkL99az
	dTFycQgJLGKUmDL5OzuEM4FJ4tuKcywgVWwChhLb711hBUmICKxmlOi7eAasilngLpPEnFXv
	GEGqhAUCJF6snQNmswioSnTPWMkEYvMKeEhsXdYM1M0BtE9BYs4kG5AwJ1D4yZ09YAuEBNwl
	3p76wjqBkXcBI8MqRtHUguSC4qT0XCO94sTc4tK8dL3k/NxNjOBofya9g3FVg8UhRgEORiUe
	3h/SMcFCrIllxZW5hxglOJiVRHg5pwOFeFMSK6tSi/Lji0pzUosPMSYDHTWRWUo0OR+YiPJK
	4g2NTcxNjU0tTSxMzCxJE1YS5z3Yah0oJJCeWJKanZpakFoEs4WJg1OqgXFhSp15wrU16y0W
	/6k7feKd2ZsHN1gWnHnEZFS6bTv7DPn7j+e+MbcuPv7d/OqJ44sXu/up98tF/5pbLvuya6nx
	31uLJlkvZPuW4PJW1fXoHBHWqw9+RTHuf56dFGfU1dJtF/4w9fWnKZZW7c99DubxPs+M+Vxx
	SGemwYw/c2esi1J6b3r0wId/SizFGYmGWsxFxYkA8yQcyToDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cho KyongHo <pullip.cho@samsung.com>

This commit changes the function to get MMU version simpler.

Signed-off-by: Cho KyongHo <pullip.cho@samsung.com>
---
 drivers/iommu/exynos-iommu.c |   30 ++++++------------------------
 1 file changed, 6 insertions(+), 24 deletions(-)

diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
index 00915f2..54011e5 100755
--- a/drivers/iommu/exynos-iommu.c
+++ b/drivers/iommu/exynos-iommu.c
@@ -252,24 +252,6 @@ static unsigned int __raw_sysmmu_version(struct sysmmu_drvdata *data)
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
@@ -427,13 +409,13 @@ static bool __sysmmu_disable(struct sysmmu_drvdata *data)
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
@@ -591,7 +573,7 @@ static void sysmmu_tlb_invalidate_entry(struct device *dev, sysmmu_iova_t iova,
 			 * 1MB page can be cached in one of all sets.
 			 * 64KB page can be one of 16 consecutive sets.
 			 */
-			if (__sysmmu_version(data, NULL) == 2)
+			if (MMU_MAJ_VER(__raw_sysmmu_version(data)) == 2)
 				num_inv = min_t(unsigned int,
 						size / PAGE_SIZE, 64);
 
-- 
1.7.9.5

