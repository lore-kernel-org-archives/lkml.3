Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753718Ab3JUOTF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 10:19:05 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:64583 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753618Ab3JUOS7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 10:18:59 -0400
X-AuditID: cbfee61a-b7f836d0000025d7-0a-526537d191a9
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
To: devicetree@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org, kyungmin.park@samsung.com,
        t.figa@samsung.com, kishon@ti.com, sw0312.kim@samsung.com,
        inki.dae@samsung.com, rahul.sharma@samsung.com, kgene.kim@samsung.com,
        s.nawrocki@samsung.com, thomas.abraham@linaro.org,
        mturquette@linaro.org, Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: [RFC 02/12] clk: exynos4: export sclk_hdmiphy clock
Date: Mon, 21 Oct 2013 16:18:21 +0200
Message-id: <1382365111-6533-3-git-send-email-t.stanislaws@samsung.com>
X-Mailer: git-send-email 1.7.10
In-reply-to: <1382365111-6533-1-git-send-email-t.stanislaws@samsung.com>
References: <1382365111-6533-1-git-send-email-t.stanislaws@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrNLMWRmVeSWpSXmKPExsVy+t9jAd2L5qlBBn+PmlrMP3KO1eLK1/ds
	FpPuT2Cx6F1wlc3iwtMeNouzTW/YLS7vmsNmMeP8PiaLpxMusllMWXSY1eLwm3ZWixmTX7JZ
	rJ/xmsViXvtLVotjM5YwOvB73Lm2h83jfvdxJo++LasYPY7f2M7k8XmTXABrFJdNSmpOZllq
	kb5dAlfGzv/7WQo281es33uVqYHxAU8XIyeHhICJxPXdc1khbDGJC/fWs3UxcnEICSxilDiz
	fhorhNPFJLF1yTdmkCo2oI5jSz4zgtgiAokSv5rvMoMUMQscYpLY3TIFyOHgEBawkehqdwCp
	YRFQlfi+cykbSJhXwF1i4fFIiGXyEk/v97GB2JwCHhKnXq4FGykEVPLu2zyWCYy8CxgZVjGK
	phYkFxQnpeca6hUn5haX5qXrJefnbmIEB+kzqR2MKxssDjEKcDAq8fAGuKQECbEmlhVX5h5i
	lOBgVhLhrTJNDRLiTUmsrEotyo8vKs1JLT7EKM3BoiTOe6DVOlBIID2xJDU7NbUgtQgmy8TB
	KdXAeCByZ29tv0Ivb4T4qerf317G75umdc+Ju3zi8f95t86wOElrCZw1v9GYVbdyasMiTr6A
	xezVL1qE/W6LPr47qWGqT1/Ru8imV3PNlIRl/onLfJ6slajB32ldlG67ye5qRKKshMW8Vv3t
	73jnxKXcmXjbaMkjgy3b08w/v1IyCzvwaKWNh+dOJZbijERDLeai4kQAc8XRx04CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Export sclk_hdmiphy clock to be usable from DT.

Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
---
 .../devicetree/bindings/clock/exynos4-clock.txt    |    1 +
 drivers/clk/samsung/clk-exynos4.c                  |    4 ++--
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/clock/exynos4-clock.txt b/Documentation/devicetree/bindings/clock/exynos4-clock.txt
index c6bf8a6..cb08f5d 100644
--- a/Documentation/devicetree/bindings/clock/exynos4-clock.txt
+++ b/Documentation/devicetree/bindings/clock/exynos4-clock.txt
@@ -46,6 +46,7 @@ Exynos4 SoC and this is specified where applicable.
   mout_mpll_user_c    18      Exynos4x12
   mout_core           19
   mout_apll           20
+  sclk_hdmiphy        21
 
 
             [Clock Gate for Special Clocks]
diff --git a/drivers/clk/samsung/clk-exynos4.c b/drivers/clk/samsung/clk-exynos4.c
index ad5ff50..df79ca6 100644
--- a/drivers/clk/samsung/clk-exynos4.c
+++ b/drivers/clk/samsung/clk-exynos4.c
@@ -148,7 +148,7 @@ enum exynos4_clks {
 	xxti, xusbxti, fin_pll, fout_apll, fout_mpll, fout_epll, fout_vpll,
 	sclk_apll, sclk_mpll, sclk_epll, sclk_vpll, arm_clk, aclk200, aclk100,
 	aclk160, aclk133, mout_mpll_user_t, mout_mpll_user_c, mout_core,
-	mout_apll, /* 20 */
+	mout_apll, sclk_hdmiphy, /* 21 */
 
 	/* gate for special clocks (sclk) */
 	sclk_fimc0 = 128, sclk_fimc1, sclk_fimc2, sclk_fimc3, sclk_cam0,
@@ -354,7 +354,7 @@ static struct samsung_fixed_rate_clock exynos4_fixed_rate_ext_clks[] __initdata
 /* fixed rate clocks generated inside the soc */
 static struct samsung_fixed_rate_clock exynos4_fixed_rate_clks[] __initdata = {
 	FRATE(none, "sclk_hdmi24m", NULL, CLK_IS_ROOT, 24000000),
-	FRATE(none, "sclk_hdmiphy", NULL, CLK_IS_ROOT, 27000000),
+	FRATE(sclk_hdmiphy, "sclk_hdmiphy", NULL, CLK_IS_ROOT, 27000000),
 	FRATE(none, "sclk_usbphy0", NULL, CLK_IS_ROOT, 48000000),
 };
 
-- 
1.7.9.5

