Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932089Ab3IYARA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 20:17:00 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39233 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932074Ab3IYAQ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 20:16:57 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Felix Fietkau <nbd@openwrt.org>, Gabor Juhos <juhosg@openwrt.org>,
        Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org
Subject: [ 086/110] MIPS: ath79: Fix ar933x watchdog clock
Date: Tue, 24 Sep 2013 17:15:24 -0700
Message-Id: <20130925001332.749799302@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20130925001323.387158698@linuxfoundation.org>
References: <20130925001323.387158698@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/mips/ath79/clock.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/mips/ath79/clock.c
+++ b/arch/mips/ath79/clock.c
@@ -164,7 +164,7 @@ static void __init ar933x_clocks_init(vo
 		ath79_ahb_clk.rate = freq / t;
 	}
 
-	ath79_wdt_clk.rate = ath79_ref_clk.rate;
+	ath79_wdt_clk.rate = ath79_ahb_clk.rate;
 	ath79_uart_clk.rate = ath79_ref_clk.rate;
 }
 


