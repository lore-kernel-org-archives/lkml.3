Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031727AbaGDWvo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 18:51:44 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57254 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030653AbaGDWRw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 18:17:52 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Arun Ramamurthy <arun.ramamurthy@broadcom.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Guenter Roeck <linux@roeck-us.net>, Wim Van Sebroeck <wim@iguana.be>
Subject: [PATCH 3.4 07/19] watchdog: sp805: Set watchdog_device->timeout from ->set_timeout()
Date: Fri,  4 Jul 2014 15:15:17 -0700
Message-Id: <20140704221436.776963233@linuxfoundation.org>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <20140704221436.423715636@linuxfoundation.org>
References: <20140704221436.423715636@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/watchdog/sp805_wdt.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/drivers/watchdog/sp805_wdt.c
+++ b/drivers/watchdog/sp805_wdt.c
@@ -62,7 +62,6 @@
  * @adev: amba device structure of wdt
  * @status: current status of wdt
  * @load_val: load value to be set for current timeout
- * @timeout: current programmed timeout
  */
 struct sp805_wdt {
 	spinlock_t			lock;
@@ -73,7 +72,6 @@ struct sp805_wdt {
 	#define WDT_BUSY		0
 	#define WDT_CAN_BE_CLOSED	1
 	unsigned int			load_val;
-	unsigned int			timeout;
 };
 
 /* local variables */
@@ -101,7 +99,7 @@ static void wdt_setload(unsigned int tim
 	spin_lock(&wdt->lock);
 	wdt->load_val = load;
 	/* roundup timeout to closest positive integer value */
-	wdt->timeout = div_u64((load + 1) * 2 + (rate / 2), rate);
+	wdd->timeout = div_u64((load + 1) * 2 + (rate / 2), rate);
 	spin_unlock(&wdt->lock);
 }
 


