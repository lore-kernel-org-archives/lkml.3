Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754934Ab3LJQJt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 11:09:49 -0500
Received: from am1ehsobe003.messaging.microsoft.com ([213.199.154.206]:43064
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751687Ab3LJQJp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 11:09:45 -0500
X-Forefront-Antispam-Report: CIP:66.35.236.232;KIP:(null);UIP:(null);IPV:NLI;H:SJ-ITEXEDGE02.altera.priv.altera.com;RD:none;EFVD:NLI
X-SpamScore: 11
X-BigFish: VS11(z37d5kzzz1f42h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah1fc6hzz1de098h8275bh1de097hz2fh2a8h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h14ddh1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah224fh1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1e23h1fe8h1ff5h2218h2216h226dh22d0h2327h2336h286p1155h)
From: <dinguyen@altera.com>
To: <dinh.linux@gmail.com>, <mingo@kernel.org>, <daniel.lezcano@linaro.org>,
        <tglx@linutronix.de>
CC: <jamie@jamieiles.com>, <linus.walleij@linaro.org>,
        <linux-kernel@vger.kernel.org>, <heiko@sntech.de>,
        Dinh Nguyen <dinguyen@altera.com>
Subject: [PATCHv5 2/2] clocksource: dw_apb_timer_of: Fix support for dts binding "snps,dw-apb-timer"
Date: Tue, 10 Dec 2013 10:07:58 -0600
Message-ID: <1386691678-29618-2-git-send-email-dinguyen@altera.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1386691678-29618-1-git-send-email-dinguyen@altera.com>
References: <1386691678-29618-1-git-send-email-dinguyen@altera.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: altera.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dinh Nguyen <dinguyen@altera.com>

In commit 620f5e1cbf (dts: Rename DW APB timer compatible strings), both
"snps,dw-apb-timer-sp" and "snps,dw-apb-timer-osc" were deprecated in place
of "snps,dw-apb-timer". But the driver also needs to be udpated in order to
support this new binding "snps,dw-apb-timer".

Signed-off-by: Dinh Nguyen <dinguyen@altera.com>
---
v5: Separate patch to fix bindings
v4: none
v3: none
v2: none
---
 drivers/clocksource/dw_apb_timer_of.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/clocksource/dw_apb_timer_of.c b/drivers/clocksource/dw_apb_timer_of.c
index b29d7cd..8d6e5f6 100644
--- a/drivers/clocksource/dw_apb_timer_of.c
+++ b/drivers/clocksource/dw_apb_timer_of.c
@@ -113,7 +113,6 @@ static u64 read_sched_clock(void)
 
 static const struct of_device_id sptimer_ids[] __initconst = {
 	{ .compatible = "picochip,pc3x2-rtc" },
-	{ .compatible = "snps,dw-apb-timer-sp" },
 	{ /* Sentinel */ },
 };
 
@@ -151,4 +150,7 @@ static void __init dw_apb_timer_init(struct device_node *timer)
 	num_called++;
 }
 CLOCKSOURCE_OF_DECLARE(pc3x2_timer, "picochip,pc3x2-timer", dw_apb_timer_init);
-CLOCKSOURCE_OF_DECLARE(apb_timer, "snps,dw-apb-timer-osc", dw_apb_timer_init);
+CLOCKSOURCE_OF_DECLARE(apb_timer_osc, "snps,dw-apb-timer-osc", dw_apb_timer_init);
+CLOCKSOURCE_OF_DECLARE(apb_timer_sp, "snps,dw-apb-timer-sp", dw_apb_timer_init);
+CLOCKSOURCE_OF_DECLARE(apb_timer, "snps,dw-apb-timer", dw_apb_timer_init);
+
-- 
1.7.9.5


