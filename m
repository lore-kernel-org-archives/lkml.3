Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759262AbaGOR2x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 13:28:53 -0400
Received: from mail-wg0-f52.google.com ([74.125.82.52]:43475 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754998AbaGORCG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 13:02:06 -0400
From: Sam Asadi <asadi.samuel@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Vasily Khoruzhick <anarsoul@gmail.com>,
        Tomasz Figa <t.figa@samsung.com>, sam-the-6 <asadi.samuel@gmail.com>
Subject: [PATCH 06/94] clk: samsung: fix several typos to fix boot on s3c2410
Date: Tue, 15 Jul 2014 20:00:21 +0300
Message-Id: <1405443709-15288-6-git-send-email-asadi.samuel@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1405443709-15288-1-git-send-email-asadi.samuel@gmail.com>
References: <1405443709-15288-1-git-send-email-asadi.samuel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vasily Khoruzhick <anarsoul@gmail.com>

There's a several typos in a driver: 2410 instead of S3C2410
and wrong argument to ARRAY_SIZE(). They prevent s3c2410
from properly booting.

Signed-off-by: Vasily Khoruzhick <anarsoul@gmail.com>
Reviewed-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Tomasz Figa <t.figa@samsung.com>
Signed-off-by: sam-the-6 <asadi.samuel@gmail.com>
---
 drivers/clk/samsung/clk-s3c2410.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/samsung/clk-s3c2410.c b/drivers/clk/samsung/clk-s3c2410.c
index ba07168..bd9a873 100644
--- a/drivers/clk/samsung/clk-s3c2410.c
+++ b/drivers/clk/samsung/clk-s3c2410.c
@@ -378,7 +378,7 @@ void __init s3c2410_common_clk_init(struct device_node *np, unsigned long xti_f,
 	if (!np)
 		s3c2410_common_clk_register_fixed_ext(ctx, xti_f);
 
-	if (current_soc == 2410) {
+	if (current_soc == S3C2410) {
 		if (_get_rate("xti") == 12 * MHZ) {
 			s3c2410_plls[mpll].rate_table = pll_s3c2410_12mhz_tbl;
 			s3c2410_plls[upll].rate_table = pll_s3c2410_12mhz_tbl;
@@ -432,7 +432,7 @@ void __init s3c2410_common_clk_init(struct device_node *np, unsigned long xti_f,
 		samsung_clk_register_fixed_factor(ctx, s3c2410_ffactor,
 				ARRAY_SIZE(s3c2410_ffactor));
 		samsung_clk_register_alias(ctx, s3c2410_aliases,
-			ARRAY_SIZE(s3c2410_common_aliases));
+			ARRAY_SIZE(s3c2410_aliases));
 		break;
 	case S3C2440:
 		samsung_clk_register_mux(ctx, s3c2440_muxes,
-- 
1.7.10.4

