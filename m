Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752766AbaDDOyR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 10:54:17 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:12761 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752502AbaDDOyL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 10:54:11 -0400
X-AuditID: cbfee61b-b7f456d000006dfd-86-533ec79243ba
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
To: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Cc: t.figa@samsung.com, mturquette@linaro.org, kgene.kim@samsung.com,
        inki.dae@samsung.com, sw0312.kim@samsung.com,
        kyungmin.park@samsung.com, airlied@linux.ie, rob.herring@calxeda.com,
        sylvester.nawrocki@gmail.com, a.hajda@samsung.com, kishon@ti.com,
        Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: [PATCH 2/4] clk: exynos4: export sclk_hdmiphy clock
Date: Fri, 04 Apr 2014 16:53:19 +0200
Message-id: <1396623201-26000-3-git-send-email-t.stanislaws@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1396623201-26000-1-git-send-email-t.stanislaws@samsung.com>
References: <1396623201-26000-1-git-send-email-t.stanislaws@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNLMWRmVeSWpSXmKPExsVy+t9jQd1Jx+2CDb5tVLC4te4cq0XvuZNM
	FvOPAFlXvr5ns5h0fwKLRe+Cq2wWF572sFmcbXrDbrHp8TVWi8u75rBZzDi/j8ni6YSLbBaH
	Vxxgspgx+SWbxbzPO5ks1s94zWIxr/0lq4Ogx4LPV9g9ds66y+5x59oeNo/t3x6wetzvPs7k
	sXlJvUffllWMHsdvbGfy+LxJLoAzissmJTUnsyy1SN8ugSvjyOUWtoJ/XBXtz94zNjBu4+xi
	5OSQEDCR2PHsHiOELSZx4d56ti5GLg4hgemMEjNnNLNAOF1MEtMfr2UGqWID6ji25DMjSEJE
	YBWjxMT/T9lBHGaBTUwSOxu7WUCqhAVsJLZOXQA2l0VAVWLvrmNg3bwCHhI337YzQexTlOh+
	NoENxOYU8JToXfIdrEYIqKZ7zQKWCYy8CxgZVjGKphYkFxQnpeca6RUn5haX5qXrJefnbmIE
	B/kz6R2MqxosDjEKcDAq8fB27LALFmJNLCuuzD3EKMHBrCTCWzcBKMSbklhZlVqUH19UmpNa
	fIhRmoNFSZz3YKt1oJBAemJJanZqakFqEUyWiYNTqoFxwzO1x4lycj3smnMfq0VGnRa3cA1k
	2uonfYYjznXTorAsee93ni85JcVL3xyqEvaYUy938MbEswIsOYezZXfbhZ85+2dZ86Ebjb/F
	FRe+Zmla+CT4Lic7N4P8o2aFa+3BLN/0FFMC++oy1c9/duPyrIi+qNc1WfTLxSmGF83e55wK
	PbTR6a0SS3FGoqEWc1FxIgB2/VUlbgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Export sclk_hdmiphy clock to be usable from DT.

Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
---
 drivers/clk/samsung/clk-exynos4.c   |    2 +-
 include/dt-bindings/clock/exynos4.h |    1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/clk/samsung/clk-exynos4.c b/drivers/clk/samsung/clk-exynos4.c
index b4f9672..528f8eb 100644
--- a/drivers/clk/samsung/clk-exynos4.c
+++ b/drivers/clk/samsung/clk-exynos4.c
@@ -428,7 +428,7 @@ static struct samsung_fixed_rate_clock exynos4_fixed_rate_ext_clks[] __initdata
 /* fixed rate clocks generated inside the soc */
 static struct samsung_fixed_rate_clock exynos4_fixed_rate_clks[] __initdata = {
 	FRATE(0, "sclk_hdmi24m", NULL, CLK_IS_ROOT, 24000000),
-	FRATE(0, "sclk_hdmiphy", NULL, CLK_IS_ROOT, 27000000),
+	FRATE(CLK_SCLK_HDMIPHY, "sclk_hdmiphy", NULL, CLK_IS_ROOT, 27000000),
 	FRATE(0, "sclk_usbphy0", NULL, CLK_IS_ROOT, 48000000),
 };
 
diff --git a/include/dt-bindings/clock/exynos4.h b/include/dt-bindings/clock/exynos4.h
index 75aff33..0e245eb 100644
--- a/include/dt-bindings/clock/exynos4.h
+++ b/include/dt-bindings/clock/exynos4.h
@@ -33,6 +33,7 @@
 #define CLK_MOUT_MPLL_USER_C	18 /* Exynos4x12 only */
 #define CLK_MOUT_CORE		19
 #define CLK_MOUT_APLL		20
+#define CLK_SCLK_HDMIPHY	22
 
 /* gate for special clocks (sclk) */
 #define CLK_SCLK_FIMC0		128
-- 
1.7.9.5

