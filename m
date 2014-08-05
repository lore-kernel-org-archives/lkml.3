Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754897AbaHEKtA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 06:49:00 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:9316 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754583AbaHEKsx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 06:48:53 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-a1-53e0b693f17f
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: iommu@lists.linux-foundation.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        linaro-mm-sig@lists.linaro.org, Arnd Bergmann <arnd@arndb.de>,
        Shaik Ameer Basha <shaik.ameer@samsung.com>,
        Cho KyongHo <pullip.cho@samsung.com>, Joerg Roedel <joro@8bytes.org>,
        Thierry Reding <treding@nvidia.com>, Olof Johansson <olof@lixom.net>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Rob Herring <robh@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Inki Dae <inki.dae@samsung.com>, Kukjin Kim <kgene.kim@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH 03/29] clk: exynos: add missing smmu_g2d clock and update
 comments
Date: Tue, 05 Aug 2014 12:47:31 +0200
Message-id: <1407235677-26324-4-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.9.2
In-reply-to: <1407235677-26324-1-git-send-email-m.szyprowski@samsung.com>
References: <1407235677-26324-1-git-send-email-m.szyprowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrOLMWRmVeSWpSXmKPExsVy+t/xq7qTtz0INth8Sd7i76Rj7BbNi9ez
	WUy6P4HFYsF+a4vO2RvYLXoXXGWzONv0ht2ic+ISdosvVx4yWWx6fI3V4vKuOWwWM87vY7JY
	e+Quu8Wp65/ZLP71HmS0OHP6EqvF/z072C0Ov2lntTjycDe7xapdfxgtbv/mcxD1eHJwHpPH
	71+TGD12zrrL7jG7Yyarx6ZVnWwe++euYffYvKTe4/a/x8wek28sZ/S4cqKJ1aO3+R2bx5ar
	7SwefVtWMXp83iQXwBfFZZOSmpNZllqkb5fAlXHwdztTwUm+imvbYxsYV/J0MXJySAiYSHyf
	+5AdwhaTuHBvPVsXIxeHkMBSRondzyewQjh9TBJ3Dn5jBKliEzCU6HrbBVYlItDLKNHf9IMJ
	xGEWWMcqsb/3OgtIlbBAiMS8bQ1gNouAqsTRCVdYQWxeAQ+J7jtvoPbJSfx/uYIJxOYU8JQ4
	fPMAWI0QUM3PDWvYJzDyLmBkWMUomlqaXFCclJ5rqFecmFtcmpeul5yfu4kREjlfdjAuPmZ1
	iFGAg1GJh9fg9N1gIdbEsuLK3EOMEhzMSiK8EmseBAvxpiRWVqUW5ccXleakFh9iZOLglGpg
	nH+m9W75+a28dSsE70R/bRf/nvAqz/JL8d9pL35U8rnNmvN0pdCrlceeWReo5M24oOSucuNZ
	3LFnrxefL0lJfmfII2f4WCNlscEJxSdlt686ZgpERP+9uPrGfPH8cr4zm/g096v8mMMQ9Mm7
	lu8zN/eUmFmNd/zDd/GUmM95V7pq3Y/DvH11G5RYijMSDbWYi4oTAcXms1V6AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds missing smmu_g2d clock implementation and updates
comment about Exynos4 clocks from 278-282 range. Those clocks are
available on all Exynos4 SoC series, so the misleading comment has been
removed.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/clk/samsung/clk-exynos4.c   |  1 +
 include/dt-bindings/clock/exynos4.h | 10 +++++-----
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/clk/samsung/clk-exynos4.c b/drivers/clk/samsung/clk-exynos4.c
index ac163d7..12a7cc3 100644
--- a/drivers/clk/samsung/clk-exynos4.c
+++ b/drivers/clk/samsung/clk-exynos4.c
@@ -1183,6 +1183,7 @@ static struct samsung_gate_clock exynos4x12_gate_clks[] __initdata = {
 	GATE(CLK_SPI1_ISP, "spi1_isp", "aclk200", E4X12_GATE_ISP1, 13,
 			CLK_IGNORE_UNUSED | CLK_GET_RATE_NOCACHE, 0),
 	GATE(CLK_G2D, "g2d", "aclk200", GATE_IP_DMC, 23, 0, 0),
+	GATE(CLK_SMMU_G2D, "smmu_g2d", "aclk200", GATE_IP_DMC, 24, 0, 0),
 	GATE(CLK_TMU_APBIF, "tmu_apbif", "aclk100", E4X12_GATE_IP_PERIR, 17, 0,
 		0),
 };
diff --git a/include/dt-bindings/clock/exynos4.h b/include/dt-bindings/clock/exynos4.h
index 459bd2b..fb981635 100644
--- a/include/dt-bindings/clock/exynos4.h
+++ b/include/dt-bindings/clock/exynos4.h
@@ -115,11 +115,11 @@
 #define CLK_SMMU_MFCR		275
 #define CLK_G3D			276
 #define CLK_G2D			277
-#define CLK_ROTATOR		278 /* Exynos4210 only */
-#define CLK_MDMA		279 /* Exynos4210 only */
-#define CLK_SMMU_G2D		280 /* Exynos4210 only */
-#define CLK_SMMU_ROTATOR	281 /* Exynos4210 only */
-#define CLK_SMMU_MDMA		282 /* Exynos4210 only */
+#define CLK_ROTATOR		278
+#define CLK_MDMA		279
+#define CLK_SMMU_G2D		280
+#define CLK_SMMU_ROTATOR	281
+#define CLK_SMMU_MDMA		282
 #define CLK_FIMD0		283
 #define CLK_MIE0		284
 #define CLK_MDNIE0		285 /* Exynos4412 only */
-- 
1.9.2

