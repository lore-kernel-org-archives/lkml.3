Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752495AbbAMOWS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 09:22:18 -0500
Received: from mout.kundenserver.de ([212.227.17.13]:56297 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751788AbbAMOWR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 09:22:17 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Yanchang Li <yl22@csr.com>, Barry Song <Baohua.Song@csr.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH] clocksource: sirf: remove unused variable
Date: Tue, 13 Jan 2015 15:22:06 +0100
Message-ID: <1599190.ZYSE4SrQSK@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:4VrRT42fYeoJ3q6GJOyi4vuShi6rAlmOe2UTPO5hwehqQAmNayP
 tzjidv1jZ6S5PjHKVXt9aL7CDXGsGeyH0TNadylzvQh+lCk0va3+MWmlg1zquHa4XucFNUP
 ULUNDEIaVHtK8Ismcx47UlY8lVsLnp3s1kzU684thQSP1+cIvIZnNmz2RihMmvZWaauneJD
 Is2fQe2En+iPIg36zdp7w==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A recent rework of the driver left an obviously unused variable
around, and now the compiler complains:

clocksource/timer-marco.c: In function 'sirfsoc_marco_timer_init':
clocksource/timer-marco.c:260:6: warning: unused variable 'timer_div' [-Wunused-variable]

Remove it.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Fixes: ef89af1f4380b92 ("clocksource: sirf: Remove hard-coded clock rate")

diff --git a/drivers/clocksource/timer-marco.c b/drivers/clocksource/timer-marco.c
index 361a789d4bee..3ddb81f7ee66 100644
--- a/drivers/clocksource/timer-marco.c
+++ b/drivers/clocksource/timer-marco.c
@@ -257,7 +257,6 @@ static void __init sirfsoc_clockevent_init(void)
 /* initialize the kernel jiffy timer source */
 static void __init sirfsoc_marco_timer_init(struct device_node *np)
 {
-	u32 timer_div;
 	struct clk *clk;
 
 	clk = of_clk_get(np, 0);

