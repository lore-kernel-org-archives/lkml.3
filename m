Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755563AbaDNQ0J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 12:26:09 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:60056 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755214AbaDNQ0C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 12:26:02 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: tglx@linutronix.de
Cc: linaro-kernel@lists.linaro.org, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, Arvind.Chauhan@arm.com,
        linaro-networking@linaro.org, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 18/38] tick-common: don't set mode to CLOCK_EVT_MODE_UNUSED in tick_shutdown()
Date: Mon, 14 Apr 2014 21:53:40 +0530
Message-Id: <25b069afdaa6f28e561caefa74cd62c62974099a.1397492345.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1397492345.git.viresh.kumar@linaro.org>
References: <cover.1397492345.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1397492345.git.viresh.kumar@linaro.org>
References: <cover.1397492345.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tick_shutdown() calls clockevents_exchange_device() which already sets mode to
CLOCK_EVT_MODE_UNUSED and so tick_shutdown() doesn't need to do it.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 kernel/time/tick-common.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/kernel/time/tick-common.c b/kernel/time/tick-common.c
index bb9a218..3954f4d 100644
--- a/kernel/time/tick-common.c
+++ b/kernel/time/tick-common.c
@@ -334,7 +334,6 @@ void tick_shutdown(unsigned int *cpup)
 		 * Prevent that the clock events layer tries to call
 		 * the set mode function!
 		 */
-		dev->mode = CLOCK_EVT_MODE_UNUSED;
 		clockevents_exchange_device(dev, NULL);
 		dev->event_handler = clockevents_handle_noop;
 		td->evtdev = NULL;
-- 
1.7.12.rc2.18.g61b472e

