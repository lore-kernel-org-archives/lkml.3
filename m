Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964929Ab3HHJjg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 05:39:36 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:28950 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964833Ab3HHJj2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 05:39:28 -0400
X-AuditID: cbfee68d-b7f096d0000043fc-43-5203674fb6c4
From: Cho KyongHo <pullip.cho@samsung.com>
To: "'Linux ARM Kernel'" <linux-arm-kernel@lists.infradead.org>,
        "'Linux IOMMU'" <iommu@lists.linux-foundation.org>,
        "'Linux Kernel'" <linux-kernel@vger.kernel.org>,
        "'Linux Samsung SOC'" <linux-samsung-soc@vger.kernel.org>,
        devicetree@vger.kernel.org
Cc: "'Joerg Roedel'" <joro@8bytes.org>, "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Prathyush'" <prathyush.k@samsung.com>,
        "'Rahul Sharma'" <rahul.sharma@samsung.com>,
        "'Subash Patel'" <supash.ramaswamy@linaro.org>,
        "'Grant Grundler'" <grundler@chromium.org>,
        "'Antonios Motakis'" <a.motakis@virtualopensystems.com>,
        kvmarm@lists.cs.columbia.edu,
        "'Sachin Kamat'" <sachin.kamat@linaro.org>
Subject: [PATCH v9 09/16] iommu/exynos: remove prefetch buffer setting when
 enabling System MMU
Date: Thu, 08 Aug 2013 18:39:27 +0900
Message-id: <002d01ce941b$2c8e1560$85aa4020$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac6UF5avKfzT2kHzSwK83z01UWdALA==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpkleLIzCtJLcpLzFFi42I5/e+Zvq5/OnOQwZSjmhZ37p5jtZh/BEi8
	OvKDyWLBfmuLztkb2C16F1xls/h46ji7xabH11gtLu+aw2Yx4/w+JosLKzayW0xZdJjV4uSf
	XkaLluu9TA58Hk8OzmPymN1wkcXjzrU9bB7nN61h9ti8pN5j8o3ljB59W1YxenzeJOdx5egZ
	pgDOKC6blNSczLLUIn27BK6MZ//mMRXMF6649TW3gfE0fxcjJ4eEgInE0U2LmSFsMYkL99az
	dTFycQgJLGOUeNW9kQ2m6OytFYwQiUWMEs+WdDJDOH8ZJf4tvQZWxSagJbF67nGwKhGB34wS
	t57NYQVxmAX+M0lsvd3EDlIlLJAo8a/vIQuIzSKgKnG+7QsjiM0rYCnxZ+sKVghbUOLH5Htg
	NcxAU9fvPM4EYctLbF7zFupYBYkdZ1+D9YoI6EnsnDeNFaJGRGLfi3dgV0gIzOWQaPt5lA1i
	mYDEt8mHgIZyACVkJTYdgJojKXFwxQ2WCYxis5CsnoVk9Swkq2chWbGAkWUVo2hqQXJBcVJ6
	kaFecWJucWleul5yfu4mRkj09+5gvH3A+hBjMtD6icxSosn5wOSRVxJvaGxmZGFqYmpsZG5p
	RpqwkjivWot1oJBAemJJanZqakFqUXxRaU5q8SFGJg5OqQbG2YuNYoIjeSyMZ1u3MD1s3aEg
	qvnu7N3nn+694t8svO5/05XClCq3DL6Sbf+P5x14JXPH/fftNGVtlwXPl1679SK5zS2gu4/j
	YABjbFoCy6PJJi9nhWt/t974SHji878NubPSLf/VZqv8MG6cftbPoabf+UpV9km2aWerJoex
	HVnvMafz8n4nJZbijERDLeai4kQAcMg6XBQDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrHKsWRmVeSWpSXmKPExsVy+t9jAV3/dOYgg1XTVC3u3D3HajH/CJB4
	deQHk8WC/dYWnbM3sFv0LrjKZvHx1HF2i02Pr7FaXN41h81ixvl9TBYXVmxkt5iy6DCrxck/
	vYwWLdd7mRz4PJ4cnMfkMbvhIovHnWt72DzOb1rD7LF5Sb3H5BvLGT36tqxi9Pi8Sc7jytEz
	TAGcUQ2MNhmpiSmpRQqpecn5KZl56bZK3sHxzvGmZgaGuoaWFuZKCnmJuam2Si4+AbpumTlA
	xysplCXmlAKFAhKLi5X07TBNCA1x07WAaYzQ9Q0JgusxMkADCesYM579m8dUMF+44tbX3AbG
	0/xdjJwcEgImEmdvrWCEsMUkLtxbz9bFyMUhJLCIUeLZkk5mCOcvo8S/pdfYQKrYBLQkVs89
	zgiSEBH4zShx69kcVhCHWeA/k8TW203sIFXCAokS//oesoDYLAKqEufbvoDt4BWwlPizdQUr
	hC0o8WPyPbAaZqCp63ceZ4Kw5SU2r3nLDHGTgsSOs6/BekUE9CR2zpvGClEjIrHvxTvGCYwC
	s5CMmoVk1Cwko2YhaVnAyLKKUTS1ILmgOCk911CvODG3uDQvXS85P3cTIzi1PJPawbiyweIQ
	owAHoxIPb0cAU5AQa2JZcWXuIUYJDmYlEd6LxUAh3pTEyqrUovz4otKc1OJDjMlAn05klhJN
	zgemvbySeENjEzMjSyMzCyMTc3PShJXEeQ+0WgcKCaQnlqRmp6YWpBbBbGHi4JRqYHRfZn/Y
	vSw74Kjk9mI/hkrnwkXPo1rXH49Yb+0Vp5HIosd+Yf5PB7eVx+XDrjV0LONVz7zdnL9lScxU
	01Bv/9Yb+x6kx2XMldfjqVvsE7t1xZNeRZ2bZqcOXf/cuqNuHve1LTqx8/OXpPXNTprLpPvk
	aPKinyf9u/Zcbr4psudmsvv1N2obHZVYijMSDbWYi4oTAZgxhsJxAwAA
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
index 005a7ed..88b9139 100644
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
@@ -201,6 +206,22 @@ static bool is_sysmmu_active(struct sysmmu_drvdata *data)
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
@@ -473,14 +494,15 @@ static int __exynos_sysmmu_enable(struct sysmmu_drvdata *data,
 	clk_enable(data->clk_master);
 
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


