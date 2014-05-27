Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752240AbaE0Iga (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 04:36:30 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:42333 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751706AbaE0Ifo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 04:35:44 -0400
X-AuditID: cbfee690-b7fb56d000003439-a3-53844e5edf2d
From: Jonghwa Lee <jonghwa3.lee@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: linux-samsung-soc@vger.kernel.org, t.figa@samsung.com,
        mturquette@linaro.org, Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>
Subject: [PATCH] clk: exynos4: Add PPMU IP block source clocks.
Date: Tue, 27 May 2014 17:35:37 +0900
Message-id: <1401179737-27521-1-git-send-email-jonghwa3.lee@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrELMWRmVeSWpSXmKPExsWyRsSkQDfOryXYoPc6n8X1L89ZLTrPPmG2
	uLxrDpvFjPP7mCyeTrjIZnG7cQWbxfoZr1kc2D3uXNvD5tG3ZRWjx+dNcgHMUVw2Kak5mWWp
	Rfp2CVwZt7efZyzYLVdx7MI95gbGp5JdjBwcEgImEp+/6ncxcgKZYhIX7q1nA7GFBJYySmyf
	owdT0v6RtYuRCyg8nVFiw4JjzBBOG5NE38L9TCANbAI6Ev/33WQHsUUEFCQ29z4D62AWOM0o
	ceNkDytIQljAXuLJyytgG1gEVCV+/rnNAmLzCnhIrL39khVim4LEnEk2IL0SAr/ZJJrnb2OF
	qBeQ+Db5EAtEjazEpgPMEEdLShxccYNlAqPgAkaGVYyiqQXJBcVJ6UUmesWJucWleel6yfm5
	mxiB4Xn637MJOxjvHbA+xJgMNG4is5Rocj4wvPNK4g2NzYwsTE1MjY3MLc1IE1YS51V7lBQk
	JJCeWJKanZpakFoUX1Sak1p8iJGJg1OqgbHGx47X/Ei1knj3dp357/Wnn2qp3p0wPSn95ruq
	ORJB3V7qgk0rqnp2lV96VubpceuxWdEe4Z/PxNx4Ste3Ov94X3hy1pEN16KPcqy5wXea1+z6
	pZRgDtMyKT6nSfOnH13Afd8uWzdM+cK15wnXKppmWO5Remh0ozuSN/e6tdTOED3dq3eNryqx
	FGckGmoxFxUnAgCD5vXGZQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrIIsWRmVeSWpSXmKPExsVy+t9jQd04v5Zgg8Xn2Syuf3nOatF59gmz
	xeVdc9gsZpzfx2TxdMJFNovbjSvYLNbPeM3iwO5x59oeNo++LasYPT5vkgtgjmpgtMlITUxJ
	LVJIzUvOT8nMS7dV8g6Od443NTMw1DW0tDBXUshLzE21VXLxCdB1y8wB2q6kUJaYUwoUCkgs
	LlbSt8M0ITTETdcCpjFC1zckCK7HyAANJKxhzLi9/TxjwW65imMX7jE3MD6V7GLk4JAQMJFo
	/8jaxcgJZIpJXLi3nq2LkYtDSGA6o8SGBceYIZw2Jom+hfuZQKrYBHQk/u+7yQ5iiwgoSGzu
	fcYKUsQscJpR4sbJHrBRwgL2Ek9eXmEDsVkEVCV+/rnNAmLzCnhIrL39khVis4LEnEk2Exi5
	FzAyrGIUTS1ILihOSs810itOzC0uzUvXS87P3cQIjoBn0jsYVzVYHGIU4GBU4uGd4NscLMSa
	WFZcmXuIUYKDWUmEt9OlJViINyWxsiq1KD++qDQntfgQYzLQ8onMUqLJ+cDozCuJNzQ2MTOy
	NDI3tDAyNidNWEmc92CrdaCQQHpiSWp2ampBahHMFiYOTqkGxpwlK3I3+evsuT/x9/YW+/r5
	yorfZZgaFrOdOzXpodrE+js5BSsW/y6fVzCBybVO2Xfxhx3rcv9eqHwnZdf47xHLrnP1mQu+
	CL7b/GvDz2edAvZqmz1Ou0dsSYjmNn/1leHb9DMtPGWbJ2z3Lbv5Jz7u9vrSitWrzNdz3Uu9
	+mTBzi6mV7w7XtoqsRRnJBpqMRcVJwIAJ26K1MQCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Exynos4 has saveral PPMUs and each of them has operation clock which
can be gated through CMU's SFR control.

New clocks are listed below. All clocks are added as a gate-typed clock.

CLK_PPMULEFT, CLK_PPMURIGHT, CLK_PPMUG3D, CLK_PPMUCAMIF, CLK_PPMUTV,
CLK_PPMUMFC_L, CLK_PPMUMFC_R, CLK_PPMUIMAGE, CLK_PPMULCD0, CLK_PPMULCD1,
CLK_PPMUFILE, CLK_PPMUGPS, CLK_PPMUCPU, CLK_PPMUACP, CLK_PPMUDMC0,
CLK_PPMUDMC1

Signed-off-by: Jonghwa Lee <jonghwa3.lee@samsung.com>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Myungjoo Ham <myungjoo.ham@samsung.com>
---
 drivers/clk/samsung/clk-exynos4.c   |   20 ++++++++++++++++++++
 include/dt-bindings/clock/exynos4.h |   18 ++++++++++++++++++
 2 files changed, 38 insertions(+)

diff --git a/drivers/clk/samsung/clk-exynos4.c b/drivers/clk/samsung/clk-exynos4.c
index b4f9672..5648437 100644
--- a/drivers/clk/samsung/clk-exynos4.c
+++ b/drivers/clk/samsung/clk-exynos4.c
@@ -852,6 +852,22 @@ static struct samsung_gate_clock exynos4_gate_clks[] __initdata = {
 			0, 0),
 	GATE(CLK_AC97, "ac97", "aclk100", GATE_IP_PERIL, 27,
 			0, 0),
+	GATE(CLK_PPMULEFT, "ppmuleft", "aclk200", GATE_IP_LEFTBUS, 1, 0, 0),
+	GATE(CLK_PPMURIGHT, "ppmuright", "aclk200", GATE_IP_RIGHTBUS,
+			1, 0, 0),
+	GATE(CLK_PPMUG3D, "ppmug3d", "aclk200", GATE_IP_G3D,
+			1, 0, 0),
+	GATE(CLK_PPMUCAMIF, "ppmucamif", "aclk160", GATE_IP_CAM, 16, 0, 0),
+	GATE(CLK_PPMUTV, "ppmutv", "aclk160", GATE_IP_TV, 5, 0, 0),
+	GATE(CLK_PPMUMFC_L, "ppmumfc_l", "aclk100", GATE_IP_MFC, 3, 0, 0),
+	GATE(CLK_PPMUMFC_R, "ppmumfc_r", "aclk100", GATE_IP_MFC, 4, 0, 0),
+	GATE(CLK_PPMULCD0, "ppmulcd0", "aclk160", GATE_IP_LCD0, 5, 0, 0),
+	GATE(CLK_PPMUFILE, "ppmufile", "aclk133", GATE_IP_FSYS, 17, 0, 0),
+	GATE(CLK_PPMUGPS, "ppmugps", "aclk200", GATE_IP_GPS, 2, 0, 0),
+	GATE(CLK_PPMUCPU, "ppmucpu", "aclk133", GATE_IP_DMC, 10, 0, 0),
+	GATE(CLK_PPMUACP, "ppmuacp", "aclk133", GATE_IP_DMC, 16, 0, 0),
+	GATE(CLK_PPMUDMC0, "ppmudmc0", "aclk133", GATE_IP_DMC, 8, 0, 0),
+	GATE(CLK_PPMUDMC1, "ppmudmc1", "aclk133", GATE_IP_DMC, 9, 0, 0),
 };
 
 /* list of gate clocks supported in exynos4210 soc */
@@ -896,6 +912,9 @@ static struct samsung_gate_clock exynos4210_gate_clks[] __initdata = {
 			CLK_SET_RATE_PARENT, 0),
 	GATE(CLK_TMU_APBIF, "tmu_apbif", "aclk100", E4210_GATE_IP_PERIR, 17, 0,
 		0),
+	GATE(CLK_PPMUIMAGE, "ppmuimage", "aclk200", E4210_GATE_IP_IMAGE, 9,
+		0, 0),
+	GATE(CLK_PPMULCD1, "ppmulcd1", "aclk160", E4210_GATE_IP_LCD1, 5, 0, 0),
 };
 
 /* list of gate clocks supported in exynos4x12 soc */
@@ -1001,6 +1020,7 @@ static struct samsung_gate_clock exynos4x12_gate_clks[] __initdata = {
 	GATE(CLK_G2D, "g2d", "aclk200", GATE_IP_DMC, 23, 0, 0),
 	GATE(CLK_TMU_APBIF, "tmu_apbif", "aclk100", E4X12_GATE_IP_PERIR, 17, 0,
 		0),
+	GATE(CLK_PPMUIMAGE, "ppmuimage", "aclk200", E4X12_GATE_IP_IMAGE, 9, 0, 0),
 };
 
 static struct samsung_clock_alias exynos4_aliases[] __initdata = {
diff --git a/include/dt-bindings/clock/exynos4.h b/include/dt-bindings/clock/exynos4.h
index 75aff33..9f331f1 100644
--- a/include/dt-bindings/clock/exynos4.h
+++ b/include/dt-bindings/clock/exynos4.h
@@ -230,6 +230,24 @@
 #define CLK_MOUT_G3D		394
 #define CLK_ACLK400_MCUISP	395 /* Exynos4x12 only */
 
+/* gate clocks - ppmu */
+#define CLK_PPMULEFT		400
+#define CLK_PPMURIGHT		401
+#define CLK_PPMUG3D		402
+#define CLK_PPMUCAMIF		403
+#define CLK_PPMUTV		404
+#define CLK_PPMUMFC_L		405
+#define CLK_PPMUMFC_R		406
+#define CLK_PPMUIMAGE		407
+#define CLK_PPMULCD0		408
+#define CLK_PPMULCD1		409
+#define CLK_PPMUFILE		410
+#define CLK_PPMUGPS		411
+#define CLK_PPMUCPU		412
+#define CLK_PPMUACP		413
+#define CLK_PPMUDMC0		414
+#define CLK_PPMUDMC1		415
+
 /* div clocks */
 #define CLK_DIV_ISP0		450 /* Exynos4x12 only */
 #define CLK_DIV_ISP1		451 /* Exynos4x12 only */
-- 
1.7.9.5

