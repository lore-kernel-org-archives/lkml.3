Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965137AbaGCJXh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 05:23:37 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52150 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965107AbaGCJXe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 05:23:34 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Viresh Kumar <viresh.kumar@linaro.org>, Wim Van Sebroeck <wim@iguana.be>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 116/198] watchdog: sp805: Set watchdog_device->timeout from ->set_timeout()
Date: Thu,  3 Jul 2014 10:19:19 +0100
Message-Id: <1404379241-8590-117-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
References: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Viresh Kumar <viresh.kumar@linaro.org>

commit 938626d96a3ffb9eb54552bb0d3a4f2b30ffdeb0 upstream.

Implementation of ->set_timeout() is supposed to set 'timeout' field of 'struct
watchdog_device' passed to it. sp805 was rather setting this in a local
variable. Fix it.

Reported-by: Arun Ramamurthy <arun.ramamurthy@broadcom.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Wim Van Sebroeck <wim@iguana.be>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
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
1.9.1

