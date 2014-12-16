Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751332AbaLPJqP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 04:46:15 -0500
Received: from mail-pa0-f43.google.com ([209.85.220.43]:62515 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751064AbaLPJqN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 04:46:13 -0500
From: Magnus Damm <magnus.damm@gmail.com>
To: Magnus Damm <magnus.damm@gmail.com>, linux-kernel@vger.kernel.org
Cc: linux-sh@vger.kernel.org, daniel.lezcano@linaro.org, horms@verge.net.au,
        geert@linux-m68k.org, laurent.pinchart@ideasonboard.com,
        Magnus Damm <magnus.damm@gmail.com>, tglx@linutronix.de
Date: Tue, 16 Dec 2014 18:48:54 +0900
Message-Id: <20141216094854.22639.69181.sendpatchset@w520>
Subject: [PATCH] clocksource: sh_tmu: Set cpu_possible_mask to fix SMP broadcast
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Magnus Damm <damm+renesas@opensource.se>

Update the TMU driver to use cpu_possible_mask as cpumask to make
r8a7779 SMP work as expected with or without the ARM TWD timer.

Signed-off-by: Magnus Damm <damm+renesas@opensource.se>
---

 drivers/clocksource/sh_tmu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- 0001/drivers/clocksource/sh_tmu.c
+++ work/drivers/clocksource/sh_tmu.c	2014-12-16 17:49:49.000000000 +0900
@@ -428,7 +428,7 @@ static void sh_tmu_register_clockevent(s
 	ced->features = CLOCK_EVT_FEAT_PERIODIC;
 	ced->features |= CLOCK_EVT_FEAT_ONESHOT;
 	ced->rating = 200;
-	ced->cpumask = cpumask_of(0);
+	ced->cpumask = cpu_possible_mask;
 	ced->set_next_event = sh_tmu_clock_event_next;
 	ced->set_mode = sh_tmu_clock_event_mode;
 	ced->suspend = sh_tmu_clock_event_suspend;
