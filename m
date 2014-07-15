Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758189AbaGOROo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 13:14:44 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:41884 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754919AbaGORCM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 13:02:12 -0400
From: Sam Asadi <asadi.samuel@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Tero Kristo <t-kristo@ti.com>, Paul Walmsley <paul@pwsan.com>,
        sam-the-6 <asadi.samuel@gmail.com>
Subject: [PATCH 38/94] ARM: OMAP2+: clock/dpll: fix _dpll_test_fint arithmetics overflow
Date: Tue, 15 Jul 2014 20:00:53 +0300
Message-Id: <1405443709-15288-38-git-send-email-asadi.samuel@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1405443709-15288-1-git-send-email-asadi.samuel@gmail.com>
References: <1405443709-15288-1-git-send-email-asadi.samuel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tero Kristo <t-kristo@ti.com>

The divider value provided to the _dpll_test_fint can reach value of
256 with J type DPLLs (USB etc.), which causes an overflow with the u8
datatype. Fix this by changing the parameter to be an int instead.

Signed-off-by: Tero Kristo <t-kristo@ti.com>
[paul@pwsan.com: changed type of 'n' to unsigned int]
Signed-off-by: Paul Walmsley <paul@pwsan.com>
Signed-off-by: sam-the-6 <asadi.samuel@gmail.com>
---
 arch/arm/mach-omap2/clkt_dpll.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-omap2/clkt_dpll.c b/arch/arm/mach-omap2/clkt_dpll.c
index 332af92..67fd26a 100644
--- a/arch/arm/mach-omap2/clkt_dpll.c
+++ b/arch/arm/mach-omap2/clkt_dpll.c
@@ -76,7 +76,7 @@
  * (assuming that it is counting N upwards), or -2 if the enclosing loop
  * should skip to the next iteration (again assuming N is increasing).
  */
-static int _dpll_test_fint(struct clk_hw_omap *clk, u8 n)
+static int _dpll_test_fint(struct clk_hw_omap *clk, unsigned int n)
 {
 	struct dpll_data *dd;
 	long fint, fint_min, fint_max;
-- 
1.7.10.4

