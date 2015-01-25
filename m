Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756769AbbAYSqj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 13:46:39 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57780 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755788AbbAYSKG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 13:10:06 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sonny Rao <sonnyrao@chromium.org>, Heiko Stuebner <heiko@sntech.de>,
        Doug Anderson <dianders@chromium.org>
Subject: [PATCH 3.18 090/183] clk: rockchip: fix rk3288 cpuclk core dividers
Date: Sun, 25 Jan 2015 10:06:52 -0800
Message-Id: <20150125180814.089350198@linuxfoundation.org>
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

From: Heiko Stuebner <heiko@sntech.de>

commit 9880d4277f6aab6b21404c824f9d9c652ba518ac upstream.

Commit 0e5bdb3f9fa5 (clk: rockchip: switch to using the new cpuclk type
for armclk) didn't take into account that the divider used on rk3288
are of the (n+1) type.

The rk3066 and rk3188 socs use more complex divider types making it
necessary for the list-elements to be the real register-values to write.

Therefore reduce divider values in the table accordingly so that they
really are the values that should be written to the registers and match
the dividers actually specified for the rk3288.

Reported-by: Sonny Rao <sonnyrao@chromium.org>
Fixes: 0e5bdb3f9fa5 ("clk: rockchip: switch to using the new cpuclk type for armclk")
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Reviewed-by: Doug Anderson <dianders@chromium.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/clk/rockchip/clk-rk3288.c |   28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

--- a/drivers/clk/rockchip/clk-rk3288.c
+++ b/drivers/clk/rockchip/clk-rk3288.c
@@ -142,20 +142,20 @@ struct rockchip_pll_rate_table rk3288_pl
 	}
 
 static struct rockchip_cpuclk_rate_table rk3288_cpuclk_rates[] __initdata = {
-	RK3288_CPUCLK_RATE(1800000000, 2, 4, 2, 4, 4),
-	RK3288_CPUCLK_RATE(1704000000, 2, 4, 2, 4, 4),
-	RK3288_CPUCLK_RATE(1608000000, 2, 4, 2, 4, 4),
-	RK3288_CPUCLK_RATE(1512000000, 2, 4, 2, 4, 4),
-	RK3288_CPUCLK_RATE(1416000000, 2, 4, 2, 4, 4),
-	RK3288_CPUCLK_RATE(1200000000, 2, 4, 2, 4, 4),
-	RK3288_CPUCLK_RATE(1008000000, 2, 4, 2, 4, 4),
-	RK3288_CPUCLK_RATE( 816000000, 2, 4, 2, 4, 4),
-	RK3288_CPUCLK_RATE( 696000000, 2, 4, 2, 4, 4),
-	RK3288_CPUCLK_RATE( 600000000, 2, 4, 2, 4, 4),
-	RK3288_CPUCLK_RATE( 408000000, 2, 4, 2, 4, 4),
-	RK3288_CPUCLK_RATE( 312000000, 2, 4, 2, 4, 4),
-	RK3288_CPUCLK_RATE( 216000000, 2, 4, 2, 4, 4),
-	RK3288_CPUCLK_RATE( 126000000, 2, 4, 2, 4, 4),
+	RK3288_CPUCLK_RATE(1800000000, 1, 3, 1, 3, 3),
+	RK3288_CPUCLK_RATE(1704000000, 1, 3, 1, 3, 3),
+	RK3288_CPUCLK_RATE(1608000000, 1, 3, 1, 3, 3),
+	RK3288_CPUCLK_RATE(1512000000, 1, 3, 1, 3, 3),
+	RK3288_CPUCLK_RATE(1416000000, 1, 3, 1, 3, 3),
+	RK3288_CPUCLK_RATE(1200000000, 1, 3, 1, 3, 3),
+	RK3288_CPUCLK_RATE(1008000000, 1, 3, 1, 3, 3),
+	RK3288_CPUCLK_RATE( 816000000, 1, 3, 1, 3, 3),
+	RK3288_CPUCLK_RATE( 696000000, 1, 3, 1, 3, 3),
+	RK3288_CPUCLK_RATE( 600000000, 1, 3, 1, 3, 3),
+	RK3288_CPUCLK_RATE( 408000000, 1, 3, 1, 3, 3),
+	RK3288_CPUCLK_RATE( 312000000, 1, 3, 1, 3, 3),
+	RK3288_CPUCLK_RATE( 216000000, 1, 3, 1, 3, 3),
+	RK3288_CPUCLK_RATE( 126000000, 1, 3, 1, 3, 3),
 };
 
 static const struct rockchip_cpuclk_reg_data rk3288_cpuclk_data = {


