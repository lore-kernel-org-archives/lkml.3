Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754855Ab3LJPuX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 10:50:23 -0500
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:25738 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754086Ab3LJPuS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 10:50:18 -0500
X-Forefront-Antispam-Report: CIP:66.35.236.232;KIP:(null);UIP:(null);IPV:NLI;H:SJ-ITEXEDGE02.altera.priv.altera.com;RD:none;EFVD:NLI
X-SpamScore: 8
X-BigFish: VS8(zzzz1f42h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah1fc6hzz1de098h8275bh1de097hz2fh2a8h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h14ddh1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah224fh1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e1dh1e23h1fe8h1ff5h2218h2216h226dh22d0h2327h2336h286p1155h)
From: <dinguyen@altera.com>
To: <dinh.linux@gmail.com>, <mingo@kernel.org>, <daniel.lezcano@linaro.org>,
        <tglx@linutronix.de>
CC: <jamie@jamieiles.com>, <linus.walleij@linaro.org>,
        <linux-kernel@vger.kernel.org>, <heiko@sntech.de>,
        Dinh Nguyen <dinguyen@altera.com>
Subject: [PATCHv4] clocksource: dw_apb_timer_of: Fix read_sched_clock
Date: Tue, 10 Dec 2013 09:46:35 -0600
Message-ID: <1386690395-27182-1-git-send-email-dinguyen@altera.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: altera.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dinh Nguyen <dinguyen@altera.com>

The read_sched_clock should return the ~value because the clock is a
countdown implementation. read_sched_clock() should be the same as
__apbt_read_clocksource().

Maintain backwards compatibility for "dw-apb-timer-sp" and
"dw-apb-timer-osc".

Signed-off-by: Dinh Nguyen <dinguyen@altera.com>
---
v4: Simplify the fix by simply returning ~__raw_readl(sched_io_base)
v3: Use APBTMR_N_CURRENT_VALUE define in read_sched_clock()
v2: Maintain backwards compatibility for "dw-apb-timer-sp" and
      "dw-apb-timer-osc".
---
 drivers/clocksource/dw_apb_timer_of.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/clocksource/dw_apb_timer_of.c b/drivers/clocksource/dw_apb_timer_of.c
index 45ba8ae..8d6e5f6 100644
--- a/drivers/clocksource/dw_apb_timer_of.c
+++ b/drivers/clocksource/dw_apb_timer_of.c
@@ -108,12 +108,11 @@ static void __init add_clocksource(struct device_node *source_timer)
 
 static u64 read_sched_clock(void)
 {
-	return __raw_readl(sched_io_base);
+	return ~__raw_readl(sched_io_base);
 }
 
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


