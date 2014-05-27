Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752344AbaE0L1S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 07:27:18 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:19107 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751984AbaE0L1N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 07:27:13 -0400
X-AuditID: cbfee691-b7f2f6d0000040c4-2c-5384768f4fe1
From: Jonghwa Lee <jonghwa3.lee@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: linux-samsung-soc@vger.kernel.org, t.figa@samsung.com,
        mturquette@linaro.org, Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>
Subject: [PATCH v2] clk: exynos4: Add PPMU IP block source clocks.
Date: Tue, 27 May 2014 20:27:08 +0900
Message-id: <1401190028-21020-1-git-send-email-jonghwa3.lee@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrKLMWRmVeSWpSXmKPExsWyRsSkWLe/rCXYYM8LLYvrX56zWnSefcJs
	cXnXHDaLGef3MVk8nXCRzeJ24wo2i/UzXrM4sHvcubaHzaNvyypGj8+b5AKYo7hsUlJzMstS
	i/TtErgyZuxdyFIwzbhiU+9M9gbGNu0uRk4OCQETiY8nZjJB2GISF+6tZ+ti5OIQEljKKNH9
	6g8bTNGqfb2MEInpjBJ7np9lh3DamCR+fJ8KVsUmoCPxf99NdhBbREBBYnPvM1aQImaB04wS
	N072sIIkhAWcJBbO7mIBsVkEVCU+njkD1swr4CFx/ON/5i5GDqB1ChJzJtmA9EoI/GaTeDzt
	OCNEvYDEt8mHWCBqZCU2HWCGuE5S4uCKGywTGAUXMDKsYhRNLUguKE5KLzLVK07MLS7NS9dL
	zs/dxAgM0tP/nk3cwXj/gPUhxmSgcROZpUST84FBnlcSb2hsZmRhamJqbGRuaUaasJI4b/qj
	pCAhgfTEktTs1NSC1KL4otKc1OJDjEwcnFINjM2erNf3dnibveTRljm/ZPKa6krDc3vt3u6T
	uWQYH/ylr3nLzqijDwLO3BMRUAr306zVVT7trJcaOHP+Le8jKn1buX5eluvc+Som36OwT2CB
	y7WngmbiHM9+rHZR8rkSU53hudojIb9iYbFSUJRa48acgwyaX17E5Xw4cuzl3P/1r6dP1WWw
	VWIpzkg01GIuKk4EACKWEPRoAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrEIsWRmVeSWpSXmKPExsVy+t9jQd3+spZgg1fPFS2uf3nOatF59gmz
	xeVdc9gsZpzfx2TxdMJFNovbjSvYLNbPeM3iwO5x59oeNo++LasYPT5vkgtgjmpgtMlITUxJ
	LVJIzUvOT8nMS7dV8g6Od443NTMw1DW0tDBXUshLzE21VXLxCdB1y8wB2q6kUJaYUwoUCkgs
	LlbSt8M0ITTETdcCpjFC1zckCK7HyAANJKxhzJixdyFLwTTjik29M9kbGNu0uxg5OSQETCRW
	7etlhLDFJC7cW8/WxcjFISQwnVFiz/Oz7BBOG5PEj+9T2UCq2AR0JP7vu8kOYosIKEhs7n3G
	ClLELHCaUeLGyR5WkISwgJPEwtldLCA2i4CqxMczZ8CaeQU8JI5//M/cxcgBtE5BYs4kmwmM
	3AsYGVYxiqYWJBcUJ6XnGuoVJ+YWl+al6yXn525iBMfAM6kdjCsbLA4xCnAwKvHwTvBtDhZi
	TSwrrsw9xCjBwawkwru+pCVYiDclsbIqtSg/vqg0J7X4EGMy0PKJzFKiyfnA+MwriTc0NjEz
	sjQyN7QwMjYnTVhJnPdAq3WgkEB6YklqdmpqQWoRzBYmDk6pBsYjV7uFNqo4O5uUlN5xvXXv
	iwardu+pqMS5u1Rmc6a0Rt0zv8lS+1z0UWpSzayDKebSdTNuywbdqd0y4Yecis7GpLmTtgaz
	z19c8eJB5KHkVy3vWlOXCTOdnXavUm73z8A7G5bIpRjULd5g49l+uUbHykQs5nfJmTXq53/u
	ep5ZammTxBr38IkSS3FGoqEWc1FxIgBQ0Y5XxQIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Exynos4 has saveral PPMUs and each of them has operation clock which
can be gated through CMU's SFR control.

New clocks are listed below. All clocks are added as a gate-typed clock.

CLK_PPMULEFT, CLK_PPMURIGHT, CLK_PPMUCAMIF, CLK_PPMUTV, CLK_PPMUMFC_L,
CLK_PPMUMFC_R, CLK_G3D, CLK_PPMUIMAGE, CLK_PPMULCD0, CLK_PPMULCD1,
CLK_PPMUFILE, CLK_PPMUGPS, CLK_PPMUDMC0, CLK_PPMUDMC1, CLK_PPMUCPU,
CLK_PPMUACP,

Signed-off-by: Jonghwa Lee <jonghwa3.lee@samsung.com>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Myungjoo Ham <myungjoo.ham@samsung.com>
---
 V2 :
    - Change clock definition order.

 drivers/clk/samsung/clk-exynos4.c   |   19 +++++++++++++++++++
 include/dt-bindings/clock/exynos4.h |   18 ++++++++++++++++++
 2 files changed, 37 insertions(+)

diff --git a/drivers/clk/samsung/clk-exynos4.c b/drivers/clk/samsung/clk-exynos4.c
index b4f9672..bed19b9 100644
--- a/drivers/clk/samsung/clk-exynos4.c
+++ b/drivers/clk/samsung/clk-exynos4.c
@@ -680,6 +680,8 @@ static struct samsung_gate_clock exynos4_gate_clks[] __initdata = {
 	 * the device name and clock alias names specified below for some
 	 * of the clocks can be removed.
 	 */
+	GATE(CLK_PPMULEFT, "ppmuleft", "aclk200", GATE_IP_LEFTBUS, 1, 0, 0),
+	GATE(CLK_PPMURIGHT, "ppmuright", "aclk200", GATE_IP_RIGHTBUS, 1, 0, 0),
 	GATE(CLK_SCLK_HDMI, "sclk_hdmi", "mout_hdmi", SRC_MASK_TV, 0, 0, 0),
 	GATE(CLK_SCLK_SPDIF, "sclk_spdif", "mout_spdif", SRC_MASK_PERIL1, 8, 0,
 		0),
@@ -695,11 +697,13 @@ static struct samsung_gate_clock exynos4_gate_clks[] __initdata = {
 	GATE(CLK_SROMC, "sromc", "aclk133", GATE_IP_FSYS, 11, 0, 0),
 	GATE(CLK_SCLK_G3D, "sclk_g3d", "div_g3d", GATE_IP_G3D, 0,
 			CLK_SET_RATE_PARENT, 0),
+	GATE(CLK_PPMUG3D, "ppmug3d", "aclk200", GATE_IP_G3D, 1, 0, 0),
 	GATE(CLK_USB_DEVICE, "usb_device", "aclk133", GATE_IP_FSYS, 13, 0, 0),
 	GATE(CLK_ONENAND, "onenand", "aclk133", GATE_IP_FSYS, 15, 0, 0),
 	GATE(CLK_NFCON, "nfcon", "aclk133", GATE_IP_FSYS, 16, 0, 0),
 	GATE(CLK_GPS, "gps", "aclk133", GATE_IP_GPS, 0, 0, 0),
 	GATE(CLK_SMMU_GPS, "smmu_gps", "aclk133", GATE_IP_GPS, 1, 0, 0),
+	GATE(CLK_PPMUGPS, "ppmugps", "aclk200", GATE_IP_GPS, 2, 0, 0),
 	GATE(CLK_SLIMBUS, "slimbus", "aclk100", GATE_IP_PERIL, 25, 0, 0),
 	GATE(CLK_SCLK_CAM0, "sclk_cam0", "div_cam0", GATE_SCLK_CAM, 4,
 			CLK_SET_RATE_PARENT, 0),
@@ -781,19 +785,24 @@ static struct samsung_gate_clock exynos4_gate_clks[] __initdata = {
 			0, 0),
 	GATE(CLK_SMMU_JPEG, "smmu_jpeg", "aclk160", GATE_IP_CAM, 11,
 			0, 0),
+	GATE(CLK_PPMUCAMIF, "ppmucamif", "aclk160", GATE_IP_CAM, 16, 0, 0),
 	GATE(CLK_PIXELASYNCM0, "pxl_async0", "aclk160", GATE_IP_CAM, 17, 0, 0),
 	GATE(CLK_PIXELASYNCM1, "pxl_async1", "aclk160", GATE_IP_CAM, 18, 0, 0),
 	GATE(CLK_SMMU_TV, "smmu_tv", "aclk160", GATE_IP_TV, 4,
 			0, 0),
+	GATE(CLK_PPMUTV, "ppmutv", "aclk160", GATE_IP_TV, 5, 0, 0),
 	GATE(CLK_MFC, "mfc", "aclk100", GATE_IP_MFC, 0, 0, 0),
 	GATE(CLK_SMMU_MFCL, "smmu_mfcl", "aclk100", GATE_IP_MFC, 1,
 			0, 0),
 	GATE(CLK_SMMU_MFCR, "smmu_mfcr", "aclk100", GATE_IP_MFC, 2,
 			0, 0),
+	GATE(CLK_PPMUMFC_L, "ppmumfc_l", "aclk100", GATE_IP_MFC, 3, 0, 0),
+	GATE(CLK_PPMUMFC_R, "ppmumfc_r", "aclk100", GATE_IP_MFC, 4, 0, 0),
 	GATE(CLK_FIMD0, "fimd0", "aclk160", GATE_IP_LCD0, 0,
 			0, 0),
 	GATE(CLK_SMMU_FIMD0, "smmu_fimd0", "aclk160", GATE_IP_LCD0, 4,
 			0, 0),
+	GATE(CLK_PPMULCD0, "ppmulcd0", "aclk160", GATE_IP_LCD0, 5, 0, 0),
 	GATE(CLK_PDMA0, "pdma0", "aclk133", GATE_IP_FSYS, 0,
 			0, 0),
 	GATE(CLK_PDMA1, "pdma1", "aclk133", GATE_IP_FSYS, 1,
@@ -806,6 +815,7 @@ static struct samsung_gate_clock exynos4_gate_clks[] __initdata = {
 			0, 0),
 	GATE(CLK_SDMMC3, "sdmmc3", "aclk133", GATE_IP_FSYS, 8,
 			0, 0),
+	GATE(CLK_PPMUFILE, "ppmufile", "aclk133", GATE_IP_FSYS, 17, 0, 0),
 	GATE(CLK_UART0, "uart0", "aclk100", GATE_IP_PERIL, 0,
 			0, 0),
 	GATE(CLK_UART1, "uart1", "aclk100", GATE_IP_PERIL, 1,
@@ -852,6 +862,10 @@ static struct samsung_gate_clock exynos4_gate_clks[] __initdata = {
 			0, 0),
 	GATE(CLK_AC97, "ac97", "aclk100", GATE_IP_PERIL, 27,
 			0, 0),
+	GATE(CLK_PPMUDMC0, "ppmudmc0", "aclk133", GATE_IP_DMC, 8, 0, 0),
+	GATE(CLK_PPMUDMC1, "ppmudmc1", "aclk133", GATE_IP_DMC, 9, 0, 0),
+	GATE(CLK_PPMUCPU, "ppmucpu", "aclk133", GATE_IP_DMC, 10, 0, 0),
+	GATE(CLK_PPMUACP, "ppmuacp", "aclk133", GATE_IP_DMC, 16, 0, 0),
 };
 
 /* list of gate clocks supported in exynos4210 soc */
@@ -863,6 +877,9 @@ static struct samsung_gate_clock exynos4210_gate_clks[] __initdata = {
 	GATE(CLK_SMMU_G2D, "smmu_g2d", "aclk200", E4210_GATE_IP_IMAGE, 3, 0, 0),
 	GATE(CLK_SMMU_MDMA, "smmu_mdma", "aclk200", E4210_GATE_IP_IMAGE, 5, 0,
 		0),
+	GATE(CLK_PPMUIMAGE, "ppmuimage", "aclk200", E4210_GATE_IP_IMAGE, 9, 0,
+		0),
+	GATE(CLK_PPMULCD1, "ppmulcd1", "aclk160", E4210_GATE_IP_LCD1, 5, 0, 0),
 	GATE(CLK_PCIE_PHY, "pcie_phy", "aclk133", GATE_IP_FSYS, 2, 0, 0),
 	GATE(CLK_SATA_PHY, "sata_phy", "aclk133", GATE_IP_FSYS, 3, 0, 0),
 	GATE(CLK_SATA, "sata", "aclk133", GATE_IP_FSYS, 10, 0, 0),
@@ -906,6 +923,8 @@ static struct samsung_gate_clock exynos4x12_gate_clks[] __initdata = {
 	GATE(CLK_MDMA2, "mdma2", "aclk200", E4X12_GATE_IP_IMAGE, 2, 0, 0),
 	GATE(CLK_SMMU_MDMA, "smmu_mdma", "aclk200", E4X12_GATE_IP_IMAGE, 5, 0,
 		0),
+	GATE(CLK_PPMUIMAGE, "ppmuimage", "aclk200", E4X12_GATE_IP_IMAGE, 9, 0,
+		0),
 	GATE(CLK_MIPI_HSI, "mipi_hsi", "aclk133", GATE_IP_FSYS, 10, 0, 0),
 	GATE(CLK_CHIPID, "chipid", "aclk100", E4X12_GATE_IP_PERIR, 0, 0, 0),
 	GATE(CLK_SYSREG, "sysreg", "aclk100", E4X12_GATE_IP_PERIR, 1,
diff --git a/include/dt-bindings/clock/exynos4.h b/include/dt-bindings/clock/exynos4.h
index 75aff33..7dd7ec1 100644
--- a/include/dt-bindings/clock/exynos4.h
+++ b/include/dt-bindings/clock/exynos4.h
@@ -230,6 +230,24 @@
 #define CLK_MOUT_G3D		394
 #define CLK_ACLK400_MCUISP	395 /* Exynos4x12 only */
 
+/* gate clocks - ppmu */
+#define CLK_PPMULEFT		400
+#define CLK_PPMURIGHT		401
+#define CLK_PPMUCAMIF		402
+#define CLK_PPMUTV		403
+#define CLK_PPMUMFC_L		404
+#define CLK_PPMUMFC_R		405
+#define CLK_PPMUG3D		406
+#define CLK_PPMUIMAGE		407
+#define CLK_PPMULCD0		408
+#define CLK_PPMULCD1		409 /* Exynos4210 only */
+#define CLK_PPMUFILE		410
+#define CLK_PPMUGPS		411
+#define CLK_PPMUDMC0		412
+#define CLK_PPMUDMC1		413
+#define CLK_PPMUCPU		414
+#define CLK_PPMUACP		415
+
 /* div clocks */
 #define CLK_DIV_ISP0		450 /* Exynos4x12 only */
 #define CLK_DIV_ISP1		451 /* Exynos4x12 only */
-- 
1.7.9.5

