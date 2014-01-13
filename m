Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754813AbaAMQG7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 11:06:59 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:53868 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754699AbaAMQFp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 11:05:45 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Magnus Damm <damm@opensource.se>,
        Simon Horman <horms+renesas@verge.net.au>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 208/208] clocksource: em_sti: Set cpu_possible_mask to fix SMP broadcast
Date: Mon, 13 Jan 2014 16:00:49 +0000
Message-Id: <1389628849-1614-209-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
References: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Magnus Damm <damm@opensource.se>

commit 2199a5574b6d94b9ca26c6345356f45ec60fef8b upstream.

Update the STI driver by setting cpu_possible_mask to make EMEV2
SMP work as expected together with the ARM broadcast timer.

This breakage was introduced by:

f7db706 ARM: 7674/1: smp: Avoid dummy clockevent being preferred over real hardware clock-event

Without this fix SMP operation is broken on EMEV2 since no
broadcast timer interrupts trigger on the secondary CPU cores.

Signed-off-by: Magnus Damm <damm@opensource.se>
Tested-by: Simon Horman <horms+renesas@verge.net.au>
Reviewed-by: Stephen Boyd <sboyd@codeaurora.org>
Signed-off-by: Simon Horman <horms+renesas@verge.net.au>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/clocksource/em_sti.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clocksource/em_sti.c b/drivers/clocksource/em_sti.c
index 4329a29..3141849 100644
--- a/drivers/clocksource/em_sti.c
+++ b/drivers/clocksource/em_sti.c
@@ -301,7 +301,7 @@ static void em_sti_register_clockevent(struct em_sti_priv *p)
 	ced->name = dev_name(&p->pdev->dev);
 	ced->features = CLOCK_EVT_FEAT_ONESHOT;
 	ced->rating = 200;
-	ced->cpumask = cpumask_of(0);
+	ced->cpumask = cpu_possible_mask;
 	ced->set_next_event = em_sti_clock_event_next;
 	ced->set_mode = em_sti_clock_event_mode;
 
-- 
1.8.3.2

