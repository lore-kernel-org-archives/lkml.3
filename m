Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755033Ab3EVCXZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 22:23:25 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:55948 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754998Ab3EVCXW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 22:23:22 -0400
Message-ID: <1369189396.19416.0.camel@phoenix>
Subject: [RESEND][PATCH 1/2] clk: wm831x: Fix update wrong register for
 enable/disable FLL
From: Axel Lin <axel.lin@ingics.com>
To: Mike Turquette <mturquette@linaro.org>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Wed, 22 May 2013 10:23:16 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to the datasheet, FLL Enable is controlled by
R16530 (4092h) FLL Control1
        BIT 0: FLL Enable
                0 = Disable
                1 = Enable

Thus the code should update WM831X_FLL_CONTROL_1 register rather than
WM831X_FLL_CONTROL_2 register.

Also fixes a trivial typo in dev_crit message.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
Hi Mike,
This patch serial was sent on http://lkml.org/lkml/2013/5/1/152
With Mark's Ack.

Regards,
Axel
 drivers/clk/clk-wm831x.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/clk/clk-wm831x.c b/drivers/clk/clk-wm831x.c
index 16ed068..4bdf0b0 100644
--- a/drivers/clk/clk-wm831x.c
+++ b/drivers/clk/clk-wm831x.c
@@ -97,7 +97,7 @@ static int wm831x_fll_prepare(struct clk_hw *hw)
 	struct wm831x *wm831x = clkdata->wm831x;
 	int ret;
 
-	ret = wm831x_set_bits(wm831x, WM831X_FLL_CONTROL_2,
+	ret = wm831x_set_bits(wm831x, WM831X_FLL_CONTROL_1,
 			      WM831X_FLL_ENA, WM831X_FLL_ENA);
 	if (ret != 0)
 		dev_crit(wm831x->dev, "Failed to enable FLL: %d\n", ret);
@@ -114,9 +114,9 @@ static void wm831x_fll_unprepare(struct clk_hw *hw)
 	struct wm831x *wm831x = clkdata->wm831x;
 	int ret;
 
-	ret = wm831x_set_bits(wm831x, WM831X_FLL_CONTROL_2, WM831X_FLL_ENA, 0);
+	ret = wm831x_set_bits(wm831x, WM831X_FLL_CONTROL_1, WM831X_FLL_ENA, 0);
 	if (ret != 0)
-		dev_crit(wm831x->dev, "Failed to disaable FLL: %d\n", ret);
+		dev_crit(wm831x->dev, "Failed to disable FLL: %d\n", ret);
 }
 
 static unsigned long wm831x_fll_recalc_rate(struct clk_hw *hw,
-- 
1.8.1.2



