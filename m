Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758733Ab3GZL2y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 07:28:54 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:51060 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758567Ab3GZL2w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 07:28:52 -0400
X-AuditID: cbfee68e-b7f276d000002279-17-51f25d72793a
From: Cho KyongHo <pullip.cho@samsung.com>
To: "'Linux ARM Kernel'" <linux-arm-kernel@lists.infradead.org>,
        "'Linux IOMMU'" <iommu@lists.linux-foundation.org>,
        "'Linux Kernel'" <linux-kernel@vger.kernel.org>,
        "'Linux Samsung SOC'" <linux-samsung-soc@vger.kernel.org>
Cc: "'Hyunwoong Kim'" <khw0178.kim@samsung.com>,
        "'Joerg Roedel'" <joro@8bytes.org>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Prathyush'" <prathyush.k@samsung.com>,
        "'Rahul Sharma'" <rahul.sharma@samsung.com>,
        "'Subash Patel'" <supash.ramaswamy@linaro.org>,
        "'Keyyoung Park'" <keyyoung.park@samsung.com>,
        "'Grant Grundler'" <grundler@chromium.org>,
        "'Antonios Motakis'" <a.motakis@virtualopensystems.com>,
        kvmarm@lists.cs.columbia.edu,
        "'Sachin Kamat'" <sachin.kamat@linaro.org>
Subject: [PATCH v8 08/12] iommu/exynos: remove prefetch buffer setting when
 enabling System MMU
Date: Fri, 26 Jul 2013 20:28:49 +0900
Message-id: <003e01ce89f3$4cdb45e0$e691d1a0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac6J8btIHglpVUGYQ3ehne12BgN9Pw==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpjleLIzCtJLcpLzFFi42I5/e+ZsW5R7KdAgxmHVC3u3D3HavHqyA8m
	iwX7rS06Z29gt9h8cB2LRe+Cq2wWjfcmsFl8PHWc3WLT42usFpd3zWGzmHF+H5PFhRUb2S2m
	LDrManHyTy+jRcv1XiYHfo8nB+cxecxuuMjicefaHjaP85vWMHtsXlLvMfnGckaPvi2rGD0+
	b5LzuHL0DFMAZxSXTUpqTmZZapG+XQJXRvf0d6wFs4QrXu/dwNjAeIS/i5GTQ0LAROLxod+s
	ELaYxIV769m6GLk4hASWMUpM7t3BClP05uJ5JojEdEaJN6tPMUI4fxklFi1pZQepYhPQklg9
	9zgjiC0icJdR4uV5HpAiZoHbzBLTfr4CSwgLJEpse7APbCyLgKrEu7PrwWxeAUuJyy+6WSBs
	QYkfk++B2cxAQ9fvPM4EYctLbF7zlhniJAWJHWdfQy3Tk5g9dyYbRI2IxL4X78CukxBYyiHx
	bDrERSwCAhLfJh8CGsoBlJCV2HQAao6kxMEVN1gmMIrNQrJ6FpLVs5CsnoVkxQJGllWMoqkF
	yQXFSelFRnrFibnFpXnpesn5uZsYIWmgbwfjzQPWhxiTgdZPZJYSTc4HppG8knhDYzMjC1MT
	U2Mjc0sz0oSVxHnVWqwDhQTSE0tSs1NTC1KL4otKc1KLDzEycXBKNTDmf1GVtb72QWZjlUDZ
	aW+BadUH9m0SXHbc/ErL9K0rjqY9W3NcN6CFu+K0lJ9ovyYfZ2nDuYfXtN+uz55d3M7YMLf2
	/bWPf0IE45mSyuzrd50+MbkjU4739rZJB5n85k44uP2pavOuFRqql8u7/Re/3D5d5++Cri+2
	ZqfO/yzR45+7fuFmo/9HlViKMxINtZiLihMBScCC/xkDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMKsWRmVeSWpSXmKPExsVy+t9jQd2i2E+BBsfuKljcuXuO1eLVkR9M
	Fgv2W1t0zt7AbrH54DoWi94FV9ksGu9NYLP4eOo4u8Wmx9dYLS7vmsNmMeP8PiaLCys2sltM
	WXSY1eLkn15Gi5brvUwO/B5PDs5j8pjdcJHF4861PWwe5zetYfbYvKTeY/KN5YwefVtWMXp8
	3iTnceXoGaYAzqgGRpuM1MSU1CKF1Lzk/JTMvHRbJe/geOd4UzMDQ11DSwtzJYW8xNxUWyUX
	nwBdt8wcoA+UFMoSc0qBQgGJxcVK+naYJoSGuOlawDRG6PqGBMH1GBmggYR1jBnd09+xFswS
	rni9dwNjA+MR/i5GTg4JAROJNxfPM0HYYhIX7q1n62Lk4hASmM4o8Wb1KUYI5y+jxKIlrewg
	VWwCWhKr5x5nBLFFBO4ySrw8zwNSxCxwm1li2s9XYAlhgUSJbQ/2sYLYLAKqEu/OrgezeQUs
	JS6/6GaBsAUlfky+B2YzAw1dv/M4E4QtL7F5zVtmiJMUJHacfQ21TE9i9tyZbBA1IhL7Xrxj
	nMAoMAvJqFlIRs1CMmoWkpYFjCyrGEVTC5ILipPSc430ihNzi0vz0vWS83M3MYKTzDPpHYyr
	GiwOMQpwMCrx8Co4fQwUYk0sK67MPcQowcGsJMJ73ftToBBvSmJlVWpRfnxRaU5q8SHGZKBP
	JzJLiSbnAxNgXkm8obGJmZGlkZmFkYm5OWnCSuK8B1utA4UE0hNLUrNTUwtSi2C2MHFwSjUw
	it3a9ubIuvkqphuWPRXvEZm64fm0uWv4ujhjzf4m5f51fDGnOO7+ziU25d/59/vXiTH+X8WY
	/2BmVkDlO/6Nlf3ud58whnwJvPz1eumhhbvXSLTLtidl7StU/Xf3z9tEs4v7//cU19RZf2Bf
	UWHXkGP3z8/rvMdOycvz8q8+vxoVeLDsW8DEHUosxRmJhlrMRcWJACMErot2AwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Prefetch buffer must be handled accurately, exact range of a buffer,
frame by frame manually. Otherwise, it may causes page fault or
deadlock in System MMU.
Thus this patch removes prefetch buffer setting when System MMU is
initialized(enabled).

Signed-off-by: Cho KyongHo <pullip.cho@samsung.com>
---
 drivers/iommu/exynos-iommu.c |   32 +++++++++++++++++++++++++++-----
 1 files changed, 27 insertions(+), 5 deletions(-)

diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
index cfc02ed..87f6bb7 100644
--- a/drivers/iommu/exynos-iommu.c
+++ b/drivers/iommu/exynos-iommu.c
@@ -80,6 +80,8 @@
 #define CTRL_BLOCK	0x7
 #define CTRL_DISABLE	0x0
 
+#define CFG_FLPDCACHE	(1 << 20) /* System MMU 3.2+ only */
+
 #define REG_MMU_CTRL		0x000
 #define REG_MMU_CFG		0x004
 #define REG_MMU_STATUS		0x008
@@ -96,6 +98,9 @@
 
 #define REG_MMU_VERSION		0x034
 
+#define MMU_MAJ_VER(reg)	(reg >> 28)
+#define MMU_MIN_VER(reg)	((reg >> 21) & 0x7F)
+
 #define REG_PB0_SADDR		0x04C
 #define REG_PB0_EADDR		0x050
 #define REG_PB1_SADDR		0x054
@@ -200,6 +205,22 @@ static bool is_sysmmu_active(struct sysmmu_drvdata *data)
 	return data->activations > 0;
 }
 
+static unsigned int __sysmmu_version(struct sysmmu_drvdata *data,
+				     int idx, unsigned int *minor)
+{
+	unsigned long major;
+
+	major = readl(data->sfrbases[idx] + REG_MMU_VERSION);
+
+	if (minor)
+		*minor = MMU_MIN_VER(major);
+
+	if (MMU_MAJ_VER(major) > 3)
+		return 1;
+
+	return MMU_MAJ_VER(major);
+}
+
 static void sysmmu_unblock(void __iomem *sfrbase)
 {
 	__raw_writel(CTRL_ENABLE, sfrbase + REG_MMU_CTRL);
@@ -460,14 +481,15 @@ static int __exynos_sysmmu_enable(struct sysmmu_drvdata *data,
 	data->pgtable = pgtable;
 
 	for (i = 0; i < data->nsfrs; i++) {
+		unsigned int min;
+
 		__sysmmu_set_ptbase(data->sfrbases[i], pgtable);
 
-		if ((readl(data->sfrbases[i] + REG_MMU_VERSION) >> 28) == 3) {
-			/* System MMU version is 3.x */
-			__raw_writel((1 << 12) | (2 << 28),
+		if ((__sysmmu_version(data, i, &min) == 3) && (min > 1)) {
+			unsigned long cfg;
+			cfg = __raw_readl(data->sfrbases[i] + REG_MMU_CFG);
+			__raw_writel(cfg | CFG_FLPDCACHE,
 					data->sfrbases[i] + REG_MMU_CFG);
-			__sysmmu_set_prefbuf(data->sfrbases[i], 0, -1, 0);
-			__sysmmu_set_prefbuf(data->sfrbases[i], 0, -1, 1);
 		}
 
 		__raw_writel(CTRL_ENABLE, data->sfrbases[i] + REG_MMU_CTRL);
-- 
1.7.2.5


