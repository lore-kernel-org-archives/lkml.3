Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932606AbbA0MbZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 07:31:25 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:35296 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932459AbbA0MTR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 07:19:17 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Len Sorensen <lsorense@csclub.uwaterloo.ca>,
        Tony Lindgren <tony@atomide.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 086/126] ARM: omap5/dra7xx: Fix frequency typos
Date: Tue, 27 Jan 2015 12:16:31 +0000
Message-Id: <1422361031-19364-87-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1422361031-19364-1-git-send-email-luis.henriques@canonical.com>
References: <1422361031-19364-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>

commit 572b24e6d85d98cdc552f07e9fb9870d9460d81b upstream.

The switch statement of the possible list of SYSCLK1 frequencies is
missing a 0 in 4 out of the 7 frequencies.

Fixes: fa6d79d27614 ("ARM: OMAP: Add initialisation for the real-time counter")
Signed-off-by: Len Sorensen <lsorense@csclub.uwaterloo.ca>
Reviewed-by: Lokesh Vutla <lokeshvutla@ti.com>
Acked-by: Nishanth Menon <nm@ti.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/arm/mach-omap2/timer.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm/mach-omap2/timer.c b/arch/arm/mach-omap2/timer.c
index 43d03fbf4c0b..b1418a2c06e5 100644
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
2.1.4

