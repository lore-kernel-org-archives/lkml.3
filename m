Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751392Ab3DNF2e (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Apr 2013 01:28:34 -0400
Received: from server.prisktech.co.nz ([115.188.14.127]:49660 "EHLO
	server.prisktech.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750822Ab3DNF2d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Apr 2013 01:28:33 -0400
From: Tony Prisk <linux@prisktech.co.nz>
To: Mike Turquette <mturquette@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org,
        vt8500-wm8505-linux-kernel@googlegroups.com,
        linux-kernel@vger.kernel.org, Tony Prisk <linux@prisktech.co.nz>
Subject: [PATCH] clk: vt8500: Missing breaks in vtwm_pll_round_rate/_set_rate.
Date: Sun, 14 Apr 2013 17:28:35 +1200
Message-Id: <1365917315-3615-1-git-send-email-linux@prisktech.co.nz>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The case of PLL_TYPE_WM8750 in both these functions is missing a break
statement causing a fall-through to the default: case.

Insert the missing break statements.

Signed-off-by: Tony Prisk <linux@prisktech.co.nz>
---
Mike,

Any chance this can still go in as a fix for 3.9
The fault makes it impossible to set the PLL clocks on WM8750 and later SoCs.

Regards
Tony P
 drivers/clk/clk-vt8500.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/clk/clk-vt8500.c b/drivers/clk/clk-vt8500.c
index 09c6331..debf688 100644
--- a/drivers/clk/clk-vt8500.c
+++ b/drivers/clk/clk-vt8500.c
@@ -488,6 +488,7 @@ static int vtwm_pll_set_rate(struct clk_hw *hw, unsigned long rate,
 	case PLL_TYPE_WM8750:
 		wm8750_find_pll_bits(rate, parent_rate, &filter, &mul, &div1, &div2);
 		pll_val = WM8750_BITS_TO_VAL(filter, mul, div1, div2);
+		break;
 	default:
 		pr_err("%s: invalid pll type\n", __func__);
 		return 0;
@@ -523,6 +524,7 @@ static long vtwm_pll_round_rate(struct clk_hw *hw, unsigned long rate,
 	case PLL_TYPE_WM8750:
 		wm8750_find_pll_bits(rate, *prate, &filter, &mul, &div1, &div2);
 		round_rate = WM8750_BITS_TO_FREQ(*prate, mul, div1, div2);
+		break;
 	default:
 		round_rate = 0;
 	}
-- 
1.7.9.5

