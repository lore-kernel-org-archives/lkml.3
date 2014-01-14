Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753270AbaANA1Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 19:27:16 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53988 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753177AbaANA1D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 19:27:03 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Magnus Damm <damm@opensource.se>,
        Simon Horman <horms+renesas@verge.net.au>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: [PATCH 3.10 02/62] clocksource: em_sti: Set cpu_possible_mask to fix SMP broadcast
Date: Mon, 13 Jan 2014 16:26:27 -0800
Message-Id: <20140114002710.536195812@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140114002710.464561569@linuxfoundation.org>
References: <20140114002710.464561569@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/clocksource/em_sti.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/clocksource/em_sti.c
+++ b/drivers/clocksource/em_sti.c
@@ -301,7 +301,7 @@ static void em_sti_register_clockevent(s
 	ced->name = dev_name(&p->pdev->dev);
 	ced->features = CLOCK_EVT_FEAT_ONESHOT;
 	ced->rating = 200;
-	ced->cpumask = cpumask_of(0);
+	ced->cpumask = cpu_possible_mask;
 	ced->set_next_event = em_sti_clock_event_next;
 	ced->set_mode = em_sti_clock_event_mode;
 


