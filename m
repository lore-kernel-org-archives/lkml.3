Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753142Ab3KZEZG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 23:25:06 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:56321 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751524Ab3KZEZD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 23:25:03 -0500
X-AuditID: cbfee691-b7f666d0000048b0-38-5294229cc124
From: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
To: linux-i2c@vger.kernel.org
Cc: sjg@chromium.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, wsa@the-dreams.de,
        ben-linux@fluff.org, grant.likely@secretlab.ca, broonie@kernel.org,
        dianders@chromium.org, cpgs@samsung.com, t.figa@samsung.com
Subject: [PATCH 1/2 v2] i2c: exynos5: add support for HSI2C on Exynos5260 SoC
Date: Tue, 26 Nov 2013 09:56:17 +0530
Message-id: <1385439977-19077-1-git-send-email-ch.naveen@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1385100726-32165-1-git-send-email-ch.naveen@samsung.com>
References: <1385100726-32165-1-git-send-email-ch.naveen@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprEIsWRmVeSWpSXmKPExsWyRsSkSneO0pQgg65eNYtJ6w4wWUx9+ITN
	4uUhTYuzyw6yWbw6s5HNouPvF0aLy7vmsFnMOL+PyeLblm2MFutnvGaxWHliFrMDt8fshoss
	Hn9XvWD22LSqk82jb8sqRo+fL3U8Tp56wuLxeZNcAHsUl01Kak5mWWqRvl0CV8aav/sYC2aI
	VUxeepG9gXGaUBcjJ4eEgInEpKnnmCFsMYkL99azdTFycQgJLGWUOPpuNitM0YIHk1ggEtMZ
	JTpP32cESQgJ9DBJ/P7HD2KzCZhJHFy0mh3EFhGQlWh9sIYZpIFZ4D2jxL3b3UAJDg5hAV+J
	HauKQGpYBFQlWtf8BVvAK+Aq8WvPGUaIZYoS3c8msIHYnAJuElcvTmOH2OUq0bL6DBPITAmB
	U+wSbx7dYYIYJCDxbfIhFpD5EkCLNx2A+kZS4uCKGywTGIUXMDKsYhRNLUguKE5KLzLVK07M
	LS7NS9dLzs/dxAiMj9P/nk3cwXj/gPUhxmSgcROZpUST84HxlVcSb2hsZmRhamJqbGRuaUaa
	sJI4b/qjpCAhgfTEktTs1NSC1KL4otKc1OJDjEwcnFINjPUe75+fMeAtk+N8ffouy3LrMHYr
	5tR5960Kj/OYWi+3//8n0uCmjMamGEPTi4rCFpuDa5d0h/yUT0qY7rhgvYP/4tSXamp77+ce
	YtzKN0vRa22g17Xt8nyLbssZJH62Ez9s7xvjtv97V2h3yA27s+cniK9r2Hm7/YHp5Duzl9l8
	zW3hy9J2UmIpzkg01GIuKk4EAKWoVP+lAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrPIsWRmVeSWpSXmKPExsVy+t9jQd05SlOCDBY1yFlMWneAyWLqwyds
	Fi8PaVqcXXaQzeLVmY1sFh1/vzBaXN41h81ixvl9TBbftmxjtFg/4zWLxcoTs5gduD1mN1xk
	8fi76gWzx6ZVnWwefVtWMXr8fKnjcfLUExaPz5vkAtijGhhtMlITU1KLFFLzkvNTMvPSbZW8
	g+Od403NDAx1DS0tzJUU8hJzU22VXHwCdN0yc4BuVFIoS8wpBQoFJBYXK+nbYZoQGuKmawHT
	GKHrGxIE12NkgAYS1jBmrPm7j7FghljF5KUX2RsYpwl1MXJySAiYSCx4MIkFwhaTuHBvPVsX
	IxeHkMB0RonO0/cZQRJCAj1MEr//8YPYbAJmEgcXrWYHsUUEZCVaH6xhBmlgFnjPKHHvdjdQ
	goNDWMBXYseqIpAaFgFVidY1f1lBbF4BV4lfe84wQixTlOh+NoENxOYUcJO4enEaO8QuV4mW
	1WeYJjDyLmBkWMUomlqQXFCclJ5rpFecmFtcmpeul5yfu4kRHH3PpHcwrmqwOMQowMGoxMMr
	0Tk5SIg1say4MvcQowQHs5IIr+t9oBBvSmJlVWpRfnxRaU5q8SHGZKCrJjJLiSbnAxNDXkm8
	obGJuamxqaWJhYmZJWnCSuK8B1utA4UE0hNLUrNTUwtSi2C2MHFwSjUw2n3dHNvobLjf+p9z
	RzeHO8dT99R1uXoKJSvkl6xLL1E7/FLuXLqnxtHlCTqbVpl90vDo7U5M/bzFzD5CZ4ecT/gv
	5SolVSlhv8xFkhWPlh/veB1o6hPBOfvtM3MNHYlvy+psleMOO87LPWCavty2tCqfe8qfjz9t
	b0VKJ89bsTvBbPnau5JKLMUZiYZazEXFiQBKVgJ8AgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds new compatible to support HSI2C module on Exynos5260
HSI2C module on Exynos5260 needs to be reset during during initialization.

Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
---
Changes since v1:
Rebasing on linux-i2c for-next

 .../devicetree/bindings/i2c/i2c-exynos5.txt        |    6 +++-
 drivers/i2c/busses/i2c-exynos5.c                   |   31 ++++++++++++++++++--
 2 files changed, 34 insertions(+), 3 deletions(-)

diff --git a/Documentation/devicetree/bindings/i2c/i2c-exynos5.txt b/Documentation/devicetree/bindings/i2c/i2c-exynos5.txt
index 056732c..704ab92 100644
--- a/Documentation/devicetree/bindings/i2c/i2c-exynos5.txt
+++ b/Documentation/devicetree/bindings/i2c/i2c-exynos5.txt
@@ -5,7 +5,11 @@ at various speeds ranging from 100khz to 3.4Mhz.
 
 Required properties:
   - compatible: value should be.
-      -> "samsung,exynos5-hsi2c", for i2c compatible with exynos5 hsi2c.
+	-> "samsung,exynos5-hsi2c", for i2c compatible with HSI2C available on
+				Exynos5250/5420 SoCs.
+	-> "samsung,exynos5260-hsi2c", for i2c compatible with HSI2C available
+				on Exynos5260 SoCs.
+
   - reg: physical base address of the controller and length of memory mapped
     region.
   - interrupts: interrupt number to the cpu.
diff --git a/drivers/i2c/busses/i2c-exynos5.c b/drivers/i2c/busses/i2c-exynos5.c
index da39ff0..497ff91 100644
--- a/drivers/i2c/busses/i2c-exynos5.c
+++ b/drivers/i2c/busses/i2c-exynos5.c
@@ -184,14 +184,35 @@ struct exynos5_i2c {
 	 * 2. Fast speed upto 1Mbps
 	 */
 	int			speed_mode;
+
+	/* Version of HS-I2C Hardware */
+	unsigned int		version;
+};
+
+enum hsi2c_version {
+	EXYNOS_5,
+	EXYNOS_5260
 };
 
 static const struct of_device_id exynos5_i2c_match[] = {
-	{ .compatible = "samsung,exynos5-hsi2c" },
+	{
+		.compatible = "samsung,exynos5-hsi2c",
+		.data = (void *)EXYNOS_5 },
+	{
+		.compatible = "samsung,exynos5260-hsi2c",
+		.data = (void *)EXYNOS_5260 },
 	{},
 };
 MODULE_DEVICE_TABLE(of, exynos5_i2c_match);
 
+static inline unsigned int exynos5_i2c_get_version(struct platform_device *pdev)
+{
+	const struct of_device_id *match;
+
+	match = of_match_node(exynos5_i2c_match, pdev->dev.of_node);
+	return (unsigned int)match->data;
+}
+
 static void exynos5_i2c_clr_pend_irq(struct exynos5_i2c *i2c)
 {
 	writel(readl(i2c->regs + HSI2C_INT_STATUS),
@@ -692,7 +713,13 @@ static int exynos5_i2c_probe(struct platform_device *pdev)
 	if (ret)
 		goto err_clk;
 
-	exynos5_i2c_init(i2c);
+	i2c->version = exynos5_i2c_get_version(pdev);
+
+	/* The HS-I2C core on Exynos5260 needs a reset to start with */
+	if (i2c->version == EXYNOS_5260)
+		exynos5_i2c_reset(i2c);
+	else
+		exynos5_i2c_init(i2c);
 
 	ret = i2c_add_adapter(&i2c->adap);
 	if (ret < 0) {
-- 
1.7.10.4

