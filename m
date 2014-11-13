Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932085AbaKMIOK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 03:14:10 -0500
Received: from mail-pa0-f44.google.com ([209.85.220.44]:47103 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751013AbaKMIOH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 03:14:07 -0500
From: Kever Yang <kever.yang@rock-chips.com>
To: Heiko Stuebner <heiko@sntech.de>, Mike Turquette <mturquette@linaro.org>
Cc: dianders@chromium.org, sonnyrao@chromium.org, addy.ke@rock-chips.com,
        cf@rock-chips.com, dkl@rock-chips.com, huangtao@rock-chips.com,
        linux-rockchip@lists.infradead.org,
        Kever Yang <kever.yang@rock-chips.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] clk: rockchip: fix clock select order for usbphy480m_src
Date: Thu, 13 Nov 2014 16:11:49 +0800
Message-Id: <1415866309-3277-1-git-send-email-kever.yang@rock-chips.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to rk3288 trm, the mux selector locate at bit[12:11]
of CRU_CLKSEL13_CON shows:
2'b00: select HOST0 USB pll clock (clk_otgphy1)
2'b01: select HOST1 USB pll clock (clk_otgphy2)
2'b10: select OTG USB pll clock   (clk_otgphy0)

The clock map is in Fig. 3-4 CRU Clock Architecture Diagram 3
- clk_otgphy0 -> USB PHY OTG
- clk_otgphy1 -> USB PHY host0
- clk_otgphy2 -> USB PHY host1

Signed-off-by: Kever Yang <kever.yang@rock-chips.com>
---

 drivers/clk/rockchip/clk-rk3288.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/rockchip/clk-rk3288.c b/drivers/clk/rockchip/clk-rk3288.c
index 157b60b..4d70518 100644
--- a/drivers/clk/rockchip/clk-rk3288.c
+++ b/drivers/clk/rockchip/clk-rk3288.c
@@ -195,8 +195,8 @@ PNAME(mux_hsadcout_p)	= { "hsadc_src", "ext_hsadc" };
 PNAME(mux_edp_24m_p)	= { "ext_edp_24m", "xin24m" };
 PNAME(mux_tspout_p)	= { "cpll", "gpll", "npll", "xin27m" };
 
-PNAME(mux_usbphy480m_p)		= { "sclk_otgphy0", "sclk_otgphy1",
-				    "sclk_otgphy2" };
+PNAME(mux_usbphy480m_p)		= { "sclk_otgphy1", "sclk_otgphy2",
+				    "sclk_otgphy0" };
 PNAME(mux_hsicphy480m_p)	= { "cpll", "gpll", "usbphy480m_src" };
 PNAME(mux_hsicphy12m_p)		= { "hsicphy12m_xin12m", "hsicphy12m_usbphy" };
 
-- 
1.9.1

