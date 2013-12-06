Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758236Ab3LFOCF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 09:02:05 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:43901 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161456Ab3LFNBQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 08:01:16 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jiada Wang <jiada_wang@mentor.com>, Shawn Guo <shawn.guo@linaro.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 076/272] ARM: i.MX6q: fix the wrong parent of can_root clock
Date: Fri,  6 Dec 2013 12:56:05 +0000
Message-Id: <1386334761-25517-77-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
References: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiada Wang <jiada_wang@mentor.com>

commit 9b3d423707c3b1f6633be1be7e959623e10c596b upstream.

instead of pll3_usb_otg the parent of can_root clock
should be pll3_60m.

Signed-off-by: Jiada Wang <jiada_wang@mentor.com>
Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
Cc: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/arm/mach-imx/clk-imx6q.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-imx/clk-imx6q.c b/arch/arm/mach-imx/clk-imx6q.c
index 86567d9..dc17783 100644
--- a/arch/arm/mach-imx/clk-imx6q.c
+++ b/arch/arm/mach-imx/clk-imx6q.c
@@ -413,7 +413,7 @@ static void __init imx6q_clocks_init(struct device_node *ccm_node)
 	clk[asrc_podf]        = imx_clk_divider("asrc_podf",        "asrc_pred",         base + 0x30, 9,  3);
 	clk[spdif_pred]       = imx_clk_divider("spdif_pred",       "spdif_sel",         base + 0x30, 25, 3);
 	clk[spdif_podf]       = imx_clk_divider("spdif_podf",       "spdif_pred",        base + 0x30, 22, 3);
-	clk[can_root]         = imx_clk_divider("can_root",         "pll3_usb_otg",      base + 0x20, 2,  6);
+	clk[can_root]         = imx_clk_divider("can_root",         "pll3_60m",          base + 0x20, 2,  6);
 	clk[ecspi_root]       = imx_clk_divider("ecspi_root",       "pll3_60m",          base + 0x38, 19, 6);
 	clk[gpu2d_core_podf]  = imx_clk_divider("gpu2d_core_podf",  "gpu2d_core_sel",    base + 0x18, 23, 3);
 	clk[gpu3d_core_podf]  = imx_clk_divider("gpu3d_core_podf",  "gpu3d_core_sel",    base + 0x18, 26, 3);
-- 
1.8.3.2

