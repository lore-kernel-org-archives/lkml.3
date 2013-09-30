Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756057Ab3I3KQw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 06:16:52 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43821 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755831Ab3I3KNi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 06:13:38 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Felix Fietkau <nbd@openwrt.org>, Gabor Juhos <juhosg@openwrt.org>,
        linux-mips@linux-mips.org, Ralf Baechle <ralf@linux-mips.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 095/104] MIPS: ath79: Fix ar933x watchdog clock
Date: Mon, 30 Sep 2013 11:11:12 +0100
Message-Id: <1380535881-9239-96-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1380535881-9239-1-git-send-email-luis.henriques@canonical.com>
References: <1380535881-9239-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.22 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@openwrt.org>

commit a1191927ace7e6f827132aa9e062779eb3f11fa5 upstream.

The watchdog device on the AR933x is connected to
the AHB clock, however the current code uses the
reference clock. Due to the wrong rate, the watchdog
driver can't calculate correct register values for
a given timeout value and the watchdog unexpectedly
restarts the system.

The code uses the wrong value since the initial
commit 04225e1d227c8e68d685936ecf42ac175fec0e54
(MIPS: ath79: add AR933X specific clock init)

The patch fixes the code to use the correct clock
rate to avoid the problem.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
Cc: linux-mips@linux-mips.org
Patchwork: https://patchwork.linux-mips.org/patch/5777/
Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/mips/ath79/clock.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/mips/ath79/clock.c b/arch/mips/ath79/clock.c
index 579f452..300d7d3 100644
--- a/arch/mips/ath79/clock.c
+++ b/arch/mips/ath79/clock.c
@@ -164,7 +164,7 @@ static void __init ar933x_clocks_init(void)
 		ath79_ahb_clk.rate = freq / t;
 	}
 
-	ath79_wdt_clk.rate = ath79_ref_clk.rate;
+	ath79_wdt_clk.rate = ath79_ahb_clk.rate;
 	ath79_uart_clk.rate = ath79_ref_clk.rate;
 }
 
-- 
1.8.3.2

