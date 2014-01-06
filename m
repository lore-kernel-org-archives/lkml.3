Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757585AbaAFXjY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 18:39:24 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:47968 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932698AbaAFWkK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 17:40:10 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dinh Nguyen <dinguyen@altera.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: [PATCH 3.12 140/144] clocksource: dw_apb_timer_of: Fix support for dts binding "snps,dw-apb-timer"
Date: Mon,  6 Jan 2014 14:38:21 -0800
Message-Id: <20140106223749.361323467@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140106223745.326293132@linuxfoundation.org>
References: <20140106223745.326293132@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dinh Nguyen <dinguyen@altera.com>

commit 9ab4727c1d41e50b67aecde4bf11879560a3ca78 upstream.

In commit 620f5e1cbf (dts: Rename DW APB timer compatible strings), both
"snps,dw-apb-timer-sp" and "snps,dw-apb-timer-osc" were deprecated in place
of "snps,dw-apb-timer". But the driver also needs to be udpated in order to
support this new binding "snps,dw-apb-timer".

Signed-off-by: Dinh Nguyen <dinguyen@altera.com>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/clocksource/dw_apb_timer_of.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/clocksource/dw_apb_timer_of.c
+++ b/drivers/clocksource/dw_apb_timer_of.c
@@ -113,7 +113,6 @@ static u32 read_sched_clock(void)
 
 static const struct of_device_id sptimer_ids[] __initconst = {
 	{ .compatible = "picochip,pc3x2-rtc" },
-	{ .compatible = "snps,dw-apb-timer-sp" },
 	{ /* Sentinel */ },
 };
 
@@ -153,4 +152,6 @@ static void __init dw_apb_timer_init(str
 	num_called++;
 }
 CLOCKSOURCE_OF_DECLARE(pc3x2_timer, "picochip,pc3x2-timer", dw_apb_timer_init);
-CLOCKSOURCE_OF_DECLARE(apb_timer, "snps,dw-apb-timer-osc", dw_apb_timer_init);
+CLOCKSOURCE_OF_DECLARE(apb_timer_osc, "snps,dw-apb-timer-osc", dw_apb_timer_init);
+CLOCKSOURCE_OF_DECLARE(apb_timer_sp, "snps,dw-apb-timer-sp", dw_apb_timer_init);
+CLOCKSOURCE_OF_DECLARE(apb_timer, "snps,dw-apb-timer", dw_apb_timer_init);


