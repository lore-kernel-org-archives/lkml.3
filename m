Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750877AbaKDHzQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 02:55:16 -0500
Received: from mail-pd0-f176.google.com ([209.85.192.176]:41716 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752473AbaKDHzK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 02:55:10 -0500
From: Kever Yang <kever.yang@rock-chips.com>
To: Mike Turquette <mturquette@linaro.org>, Heiko Stuebner <heiko@sntech.de>
Cc: dianders@chromium.org, sonnyrao@chromium.org, addy.ke@rock-chips.com,
        cf@rock-chips.com, fzf@rock-chips.com, ykk@rock-chips.com,
        yzq@rock-chips.com, dkl@rock-chips.com, huangtao@rock-chips.com,
        Kever Yang <kever.yang@rock-chips.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/5] clk: divider: make clk_divider_recalc/set_rate available
Date: Tue,  4 Nov 2014 15:52:36 +0800
Message-Id: <1415087559-19444-3-git-send-email-kever.yang@rock-chips.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415087559-19444-1-git-send-email-kever.yang@rock-chips.com>
References: <1415087559-19444-1-git-send-email-kever.yang@rock-chips.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes these two function available for other file,
which may help to make costom usage of clock divider type.

Signed-off-by: Kever Yang <kever.yang@rock-chips.com>
---

 drivers/clk/clk-divider.c    | 4 ++--
 include/linux/clk-provider.h | 4 ++++
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/clk-divider.c b/drivers/clk/clk-divider.c
index 18a9de2..f3f55a8 100644
--- a/drivers/clk/clk-divider.c
+++ b/drivers/clk/clk-divider.c
@@ -109,7 +109,7 @@ static unsigned int _get_val(struct clk_divider *divider, unsigned int div)
 	return div - 1;
 }
 
-static unsigned long clk_divider_recalc_rate(struct clk_hw *hw,
+unsigned long clk_divider_recalc_rate(struct clk_hw *hw,
 		unsigned long parent_rate)
 {
 	struct clk_divider *divider = to_clk_divider(hw);
@@ -318,7 +318,7 @@ static long clk_divider_round_rate(struct clk_hw *hw, unsigned long rate,
 	return DIV_ROUND_UP(*prate, div);
 }
 
-static int clk_divider_set_rate(struct clk_hw *hw, unsigned long rate,
+int clk_divider_set_rate(struct clk_hw *hw, unsigned long rate,
 				unsigned long parent_rate)
 {
 	struct clk_divider *divider = to_clk_divider(hw);
diff --git a/include/linux/clk-provider.h b/include/linux/clk-provider.h
index be21af1..7947fe9 100644
--- a/include/linux/clk-provider.h
+++ b/include/linux/clk-provider.h
@@ -555,6 +555,10 @@ struct clk *__clk_lookup(const char *name);
 long __clk_mux_determine_rate(struct clk_hw *hw, unsigned long rate,
 			      unsigned long *best_parent_rate,
 			      struct clk **best_parent_p);
+unsigned long clk_divider_recalc_rate(struct clk_hw *hw,
+					unsigned long parent_rate);
+int clk_divider_set_rate(struct clk_hw *hw, unsigned long rate,
+			 unsigned long parent_rate);
 
 /*
  * FIXME clock api without lock protection
-- 
1.9.1

