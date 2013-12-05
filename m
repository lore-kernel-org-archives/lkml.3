Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757466Ab3LERiM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 12:38:12 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:38403 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757427Ab3LERiE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 12:38:04 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jiada Wang <jiada_wang@mentor.com>, Shawn Guo <shawn.guo@linaro.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 73/90] ARM: i.MX6q: fix the wrong parent of can_root clock
Date: Thu,  5 Dec 2013 17:35:55 +0000
Message-Id: <1386264972-5399-74-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386264972-5399-1-git-send-email-luis.henriques@canonical.com>
References: <1386264972-5399-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.27 -stable review patch.  If anyone has any objections, please let me know.

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
index e1a17ac..cca5799 100644
--- a/arch/arm/mach-imx/clk-imx6q.c
+++ b/arch/arm/mach-imx/clk-imx6q.c
@@ -278,7 +278,7 @@ int __init mx6q_clocks_init(void)
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

