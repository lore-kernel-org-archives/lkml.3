Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753526AbaFKAXP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 20:23:15 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:48005 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751633AbaFKAXN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 20:23:13 -0400
X-AuditID: cbfee691-b7f2f6d0000040c4-fd-5397a16eb670
From: Jonghwa Lee <jonghwa3.lee@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: linux-samsung-soc@vger.kernel.org, t.figa@samsung.com,
        mturquette@linaro.org, Jonghwa Lee <jonghwa3.lee@samsung.com>
Subject: [RESEND PATCH v2] clk: exynos4: Add PPMU IP block source clocks.
Date: Wed, 11 Jun 2014 09:22:51 +0900
Message-id: <1402446171-3560-1-git-send-email-jonghwa3.lee@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrOLMWRmVeSWpSXmKPExsWyRsSkWDdv4fRgg79HxSw6zz5htri8aw6b
	xYzz+5gsnk64yGaxfsZrFgdWjzvX9rB59G1ZxejxeZNcAHMUl01Kak5mWWqRvl0CV0b/cpOC
	m0YVzV0TmBoYz2l1MXJwSAiYSJxZVd/FyAlkiklcuLeerYuRi0NIYCmjRN+81WwQCROJZTOW
	s4DYQgLTGSVmTrGFKGpjktjQ0ccOkmAT0JH4v+8mmC0ioCCxufcZK4jNLFAlMbV7EVhcWMBT
	Yll3A9hQFgFViX13V4EN5RVwl9i25BojxEEKEnMm2YDMlxB4zCbxe+16qHoBiW+TD7FA1MhK
	bDrADHGbpMTBFTdYJjAKLmBkWMUomlqQXFCclF5kqlecmFtcmpeul5yfu4kRGIin/z2buIPx
	/gHrQ4zJQOMmMkuJJucDAzmvJN7Q2MzIwtTE1NjI3NKMNGElcd70R0lBQgLpiSWp2ampBalF
	8UWlOanFhxiZODilGhjLiitMVghm/l6WW3Pj6XnRWwbPE9/enPX6tN8ui2yf5wecJpkevsS0
	7YrlX/U/Vq4HvA2KDLbXVh14fPr12UjRNSWMPEzat3eJ/jbYcfn/xVCtk36H1219/cj+VjOz
	0ZXS/P7GSc8dGe3XLb5ZueXNiUv5E8+nXPZIOPfc+5qcVvKkt4o5x59NUWIpzkg01GIuKk4E
	ABygLVNaAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrKIsWRmVeSWpSXmKPExsVy+t9jQd28hdODDbZN4rPoPPuE2eLyrjls
	FjPO72OyeDrhIpvF+hmvWRxYPe5c28Pm0bdlFaPH501yAcxRDYw2GamJKalFCql5yfkpmXnp
	tkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUA7lRTKEnNKgUIBicXFSvp2mCaEhrjp
	WsA0Ruj6hgTB9RgZoIGENYwZ/ctNCm4aVTR3TWBqYDyn1cXIySEhYCKxbMZyFghbTOLCvfVs
	ILaQwHRGiZlTbLsYuYDsNiaJDR197CAJNgEdif/7boLZIgIKEpt7n7GC2MwCVRJTuxeBxYUF
	PCWWdTeADWIRUJXYd3cV2AJeAXeJbUuuMXYxcgAtU5CYM8lmAiP3AkaGVYyiqQXJBcVJ6blG
	esWJucWleel6yfm5mxjBgf5MegfjqgaLQ4wCHIxKPLwS0tODhVgTy4orcw8xSnAwK4nw2qQB
	hXhTEiurUovy44tKc1KLDzEmAy2fyCwlmpwPjMK8knhDYxMzI0sjc0MLI2Nz0oSVxHkPtloH
	CgmkJ5akZqemFqQWwWxh4uCUamDUYZf6yrjUJeCWiqiJogdL4cHZe5qY1Fby7siJz7X6OW/H
	V9OOA2pVUTcLZL5UO9+o++G8McTyb9OGU9zXvZ48+5qw9/7/2z8cnurcSXf/UXR2iYrb5j5e
	ix81rDdTX3ifamTVPC947fAO+fmbFwpK3HmYnfS292vT0d/RzA/DV2zddoQhNa1PiaU4I9FQ
	i7moOBEA9tKbP7gCAAA=
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
Acked-by: Chanwoo Choi <cw00.choi@samsung.com>
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

