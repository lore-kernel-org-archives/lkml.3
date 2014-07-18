Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935104AbaGRNQB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 09:16:01 -0400
Received: from bband-dyn38.178-41-141.t-com.sk ([178.41.141.38]:17842 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1161155AbaGRNPu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 09:15:50 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>,
        Wim Van Sebroeck <wim@iguana.be>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 023/170] watchdog: sp805: Set watchdog_device->timeout from ->set_timeout()
Date: Fri, 18 Jul 2014 14:10:28 +0200
Message-Id: <3ffceee7c5ae8ccaf1ede159d8e3878be9c5c625.1405685481.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
References: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
In-Reply-To: <cover.1405685481.git.jslaby@suse.cz>
References: <cover.1405685481.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Viresh Kumar <viresh.kumar@linaro.org>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 938626d96a3ffb9eb54552bb0d3a4f2b30ffdeb0 upstream.

Implementation of ->set_timeout() is supposed to set 'timeout' field of 'struct
watchdog_device' passed to it. sp805 was rather setting this in a local
variable. Fix it.

Reported-by: Arun Ramamurthy <arun.ramamurthy@broadcom.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Wim Van Sebroeck <wim@iguana.be>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/watchdog/sp805_wdt.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/watchdog/sp805_wdt.c b/drivers/watchdog/sp805_wdt.c
index 58df98aec122..2cf02ffbf9d8 100644
--- a/drivers/watchdog/sp805_wdt.c
+++ b/drivers/watchdog/sp805_wdt.c
@@ -60,7 +60,6 @@
  * @adev: amba device structure of wdt
  * @status: current status of wdt
  * @load_val: load value to be set for current timeout
- * @timeout: current programmed timeout
  */
 struct sp805_wdt {
 	struct watchdog_device		wdd;
@@ -69,7 +68,6 @@ struct sp805_wdt {
 	struct clk			*clk;
 	struct amba_device		*adev;
 	unsigned int			load_val;
-	unsigned int			timeout;
 };
 
 static bool nowayout = WATCHDOG_NOWAYOUT;
@@ -99,7 +97,7 @@ static int wdt_setload(struct watchdog_device *wdd, unsigned int timeout)
 	spin_lock(&wdt->lock);
 	wdt->load_val = load;
 	/* roundup timeout to closest positive integer value */
-	wdt->timeout = div_u64((load + 1) * 2 + (rate / 2), rate);
+	wdd->timeout = div_u64((load + 1) * 2 + (rate / 2), rate);
 	spin_unlock(&wdt->lock);
 
 	return 0;
-- 
2.0.0

