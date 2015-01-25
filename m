Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757331AbbAYS0r (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 13:26:47 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57868 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756075AbbAYSKc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 13:10:32 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Gary Bisson <bisson.gary@gmail.com>, Shawn Guo <shawn.guo@linaro.org>
Subject: [PATCH 3.18 166/183] ARM: clk-imx6q: fix video divider for rev T0 1.0
Date: Sun, 25 Jan 2015 10:08:08 -0800
Message-Id: <20150125180817.387057789@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150125180810.160428929@linuxfoundation.org>
References: <20150125180810.160428929@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gary Bisson <bisson.gary@gmail.com>

commit 81ef447950bf0955aca46f4a7617d8ce435cf0ce upstream.

The post dividers do not work on i.MX6Q rev T0 1.0 so they must be fixed
to 1. As the table index was wrong, a divider a of 4 could still be
requested which implied the clock not to be set properly. This is the
root cause of the HDMI not working at high resolution on rev T0 1.0 of
the SoC.

Signed-off-by: Gary Bisson <bisson.gary@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/mach-imx/clk-imx6q.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm/mach-imx/clk-imx6q.c
+++ b/arch/arm/mach-imx/clk-imx6q.c
@@ -144,7 +144,7 @@ static void __init imx6q_clocks_init(str
 		post_div_table[1].div = 1;
 		post_div_table[2].div = 1;
 		video_div_table[1].div = 1;
-		video_div_table[2].div = 1;
+		video_div_table[3].div = 1;
 	}
 
 	clk[IMX6QDL_PLL1_BYPASS_SRC] = imx_clk_mux("pll1_bypass_src", base + 0x00, 14, 2, pll_bypass_src_sels, ARRAY_SIZE(pll_bypass_src_sels));


