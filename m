Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752766AbaBCLZp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 06:25:45 -0500
Received: from 9.mo3.mail-out.ovh.net ([87.98.184.141]:54067 "EHLO
	mo3.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751872AbaBCLZl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 06:25:41 -0500
From: Boris BREZILLON <b.brezillon@overkiz.com>
To: Mike Turquette <mturquette@linaro.org>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Boris BREZILLON <b.brezillon@overkiz.com>
Subject: [PATCH 3/3] clk: at91: propagate rate change on system clks
Date: Mon,  3 Feb 2014 12:25:30 +0100
Message-Id: <1391426731-9392-4-git-send-email-b.brezillon@overkiz.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1391426731-9392-1-git-send-email-b.brezillon@overkiz.com>
References: <1391426731-9392-1-git-send-email-b.brezillon@overkiz.com>
X-Ovh-Tracer-Id: 8986370107941287967
X-Ovh-Remote: 80.245.18.66 ()
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejtddrieelucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejtddrieelucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

System clks are just gates, and thus do not provide any rate operations.
Authorize clk rate change to be propagated to system clk parents.

Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
---
 drivers/clk/at91/clk-system.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/clk/at91/clk-system.c b/drivers/clk/at91/clk-system.c
index 8f7c043..a98557b 100644
--- a/drivers/clk/at91/clk-system.c
+++ b/drivers/clk/at91/clk-system.c
@@ -84,7 +84,8 @@ at91_clk_register_system(struct at91_pmc *pmc, const char *name,
 	 * (see drivers/memory) which would request and enable the ddrck clock.
 	 * When this is done we will be able to remove CLK_IGNORE_UNUSED flag.
 	 */
-	init.flags = CLK_IGNORE_UNUSED;
+	init.flags = CLK_SET_RATE_GATE | CLK_SET_RATE_PARENT |
+		     CLK_IGNORE_UNUSED;
 
 	sys->id = id;
 	sys->hw.init = &init;
-- 
1.7.9.5

