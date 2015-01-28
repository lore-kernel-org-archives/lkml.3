Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759522AbbA2Ku2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 05:50:28 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:44737 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751763AbbA2I7Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 03:59:25 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
        Tony Lindgren <tony@atomide.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 124/176] ARM: omap5/dra7xx: Fix frequency typos
Date: Wed, 28 Jan 2015 15:29:14 +0100
Message-Id: <6f3911eb9a68af5b0cc541e6449a73265d30ccb9.1422455352.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
References: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
In-Reply-To: <cover.1422455352.git.jslaby@suse.cz>
References: <cover.1422455352.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 572b24e6d85d98cdc552f07e9fb9870d9460d81b upstream.

The switch statement of the possible list of SYSCLK1 frequencies is
missing a 0 in 4 out of the 7 frequencies.

Fixes: fa6d79d27614 ("ARM: OMAP: Add initialisation for the real-time counter")
Signed-off-by: Len Sorensen <lsorense@csclub.uwaterloo.ca>
Reviewed-by: Lokesh Vutla <lokeshvutla@ti.com>
Acked-by: Nishanth Menon <nm@ti.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 arch/arm/mach-omap2/timer.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm/mach-omap2/timer.c b/arch/arm/mach-omap2/timer.c
index ead48fa5715e..bf83df1a2db4 100644
--- a/arch/arm/mach-omap2/timer.c
+++ b/arch/arm/mach-omap2/timer.c
@@ -503,11 +503,11 @@ static void __init realtime_counter_init(void)
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
@@ -515,11 +515,11 @@ static void __init realtime_counter_init(void)
 		num = 8;
 		den = 25;
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
2.2.2

