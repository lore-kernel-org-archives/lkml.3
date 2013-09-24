Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754622Ab3IXQyF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 12:54:05 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:48885 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753659Ab3IXQyA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 12:54:00 -0400
X-AuditID: cbfee61a-b7f7a6d00000235f-18-5241c3923eeb
From: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
To: kyungmin.park@samsung.com
Cc: mturquette@linaro.org, t.figa@samsung.com, s.nawrocki@samsung.com,
        yadi.brar@samsung.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, rob.herring@calxeda.com,
        pawel.moll@arm.com, mark.rutland@arm.com, swarren@wwwdotorg.org,
        ijc+devicetree@hellion.org.uk, rob@landley.net,
        devicetree@vger.kernel.org, ben-linux@fluff.org,
        linux-samsung-soc@vger.kernel.org,
        Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
Subject: [PATCH 1/3] clk: samsung: pll: Add support for PLL6545a and PLL6522x
Date: Tue, 24 Sep 2013 18:53:23 +0200
Message-id: <1380041605-15736-1-git-send-email-m.krawczuk@partner.samsung.com>
X-Mailer: git-send-email 1.8.1.2
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJLMWRmVeSWpSXmKPExsVy+t9jAd3Jhx2DDKb2s1tMWneAyWL+kXOs
	FuderWS0ONv0ht1i0+NrrBaXd81hs5hxfh+Txek1p5gtll6/yGTxdMJFNosJ09eyWBxeAdS2
	7uV0IOtNO6vFq4NtLBbrZ7xmsZgz/R2Tg6DHmnlrGD0WfL7C7vF31Qtmj5XLv7B5vFo9k9Xj
	zrU9bB6bl9R7HHy3h8mjb8sqRo/Pm+Q8Ns4NDeCO4rJJSc3JLEst0rdL4MpoXX+StWANR8Wt
	twvYGhjb2LsYOTgkBEwktkww7WLkBDLFJC7cW8/WxcjFISSwiFHi44G/zBBOO5PEzzdrWEGq
	2ATMJSY+28QCYosIyEpMnPwFrIhZYC+zxJSzq1lBpgoL+Erc/5YFUsMioCqx4sF3NhCbV8BP
	4vTN20wQ2xQkfl4+wTaBkXsBI8MqRtHUguSC4qT0XEO94sTc4tK8dL3k/NxNjOAAfia1g3Fl
	g8UhRgEORiUe3h3eDkFCrIllxZW5hxglOJiVRHjNNzgGCfGmJFZWpRblxxeV5qQWH2KU5mBR
	Euc90GodKCSQnliSmp2aWpBaBJNl4uCUamCs7ZsSddE2rETrnoX+Y299b2Nuh7/T732vCDz3
	6N6k/2d+zTl+v+2L51z9LOWXAe/OvtMxy5tR6X9OVUpzSoRSpVvBU7f5/hryys5BM66HuVlX
	XVifouD7Zl5xY8Z3f7Fopp9SERNXXFmf9OvTyQ1fu6KOX7vmxMW+7rJtN0Pdm+fWzL/71LyV
	WIozEg21mIuKEwFEOFh3XAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/clk/samsung/clk-pll.c | 2 ++
 drivers/clk/samsung/clk-pll.h | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/drivers/clk/samsung/clk-pll.c b/drivers/clk/samsung/clk-pll.c
index 529e11d..dea8715 100644
--- a/drivers/clk/samsung/clk-pll.c
+++ b/drivers/clk/samsung/clk-pll.c
@@ -773,6 +773,8 @@ static void __init _samsung_clk_register_pll(struct samsung_pll_clock *pll_clk,
 			init.ops = &samsung_pll36xx_clk_ops;
 		break;
 	case pll_6552:
+	case pll_6545a:
+	case pll_6522x:
 		init.ops = &samsung_pll6552_clk_ops;
 		break;
 	case pll_6553:
diff --git a/drivers/clk/samsung/clk-pll.h b/drivers/clk/samsung/clk-pll.h
index 6c39030..e786875 100644
--- a/drivers/clk/samsung/clk-pll.h
+++ b/drivers/clk/samsung/clk-pll.h
@@ -25,6 +25,8 @@ enum samsung_pll_type {
 	pll_4650c,
 	pll_6552,
 	pll_6553,
+	pll_6545a,
+	pll_6522x,
 };
 
 #define PLL_35XX_RATE(_rate, _m, _p, _s)			\
-- 
1.8.1.2

