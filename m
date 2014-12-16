Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752074AbaLPVII (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 16:08:08 -0500
Received: from mail.csclub.uwaterloo.ca ([129.97.134.52]:44156 "EHLO
	mail.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750791AbaLPVIG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 16:08:06 -0500
From: "Lennart Sorensen" <lsorense@csclub.uwaterloo.ca>
Date: Tue, 16 Dec 2014 16:08:04 -0500
To: Len Sorensen <lsorense@csclub.uwaterloo.ca>
Cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH V2 1/2] ARM: omap5/dra7xx: Fix frequency typos.
Message-ID: <3fa6cd089057e67830f7c3f4f5985d5d62fc0cc6.1418762900.git.lsorense@csclub.uwaterloo.ca>
References: <cover.1418762900.git.lsorense@csclub.uwaterloo.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1418762900.git.lsorense@csclub.uwaterloo.ca>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The switch statement of the possible list of SYSCLK1 frequencies is
missing a 0 in 4 out of the 7 frequencies.

Fixes: fa6d79d27614 ("ARM: OMAP: Add initialisation for the real-time
counter")

Signed-off-by: Len Sorensen <lsorense@csclub.uwaterloo.ca>
Reviewed-by: Lokesh Vutla <lokeshvutla@ti.com>
Acked-by: Nishanth Menon <nm@ti.com>
---
 arch/arm/mach-omap2/timer.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm/mach-omap2/timer.c b/arch/arm/mach-omap2/timer.c
index 4f61148..fb0cb2b 100644
--- a/arch/arm/mach-omap2/timer.c
+++ b/arch/arm/mach-omap2/timer.c
@@ -513,11 +513,11 @@ static void __init realtime_counter_init(void)
 	rate = clk_get_rate(sys_clk);
 	/* Numerator/denumerator values refer TRM Realtime Counter section */
 	switch (rate) {
-	case 1200000:
+	case 12000000:
 		num = 64;
 		den = 125;
 		break;
-	case 1300000:
+	case 13000000:
 		num = 768;
 		den = 1625;
 		break;
@@ -529,11 +529,11 @@ static void __init realtime_counter_init(void)
 		num = 192;
 		den = 625;
 		break;
-	case 2600000:
+	case 26000000:
 		num = 384;
 		den = 1625;
 		break;
-	case 2700000:
+	case 27000000:
 		num = 256;
 		den = 1125;
 		break;
-- 
1.7.10.4
