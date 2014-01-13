Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755387AbaAMQhA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 11:37:00 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:53354 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754043AbaAMQDd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 11:03:33 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dinh Nguyen <dinguyen@altera.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 113/208] clocksource: dw_apb_timer_of: Fix read_sched_clock
Date: Mon, 13 Jan 2014 15:59:14 +0000
Message-Id: <1389628849-1614-114-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
References: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dinh Nguyen <dinguyen@altera.com>

commit 85dc6ee1237c8a4a7742e6abab96a20389b7d682 upstream.

The read_sched_clock should return the ~value because the clock is a
countdown implementation. read_sched_clock() should be the same as
 __apbt_read_clocksource().

Signed-off-by: Dinh Nguyen <dinguyen@altera.com>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/clocksource/dw_apb_timer_of.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clocksource/dw_apb_timer_of.c b/drivers/clocksource/dw_apb_timer_of.c
index 4cbae4f..33fd4ff 100644
--- a/drivers/clocksource/dw_apb_timer_of.c
+++ b/drivers/clocksource/dw_apb_timer_of.c
@@ -108,7 +108,7 @@ static void add_clocksource(struct device_node *source_timer)
 
 static u32 read_sched_clock(void)
 {
-	return __raw_readl(sched_io_base);
+	return ~__raw_readl(sched_io_base);
 }
 
 static const struct of_device_id sptimer_ids[] __initconst = {
-- 
1.8.3.2

