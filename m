Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759586Ab3CZH07 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 03:26:59 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:47934 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757146Ab3CZH05 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 03:26:57 -0400
From: "Kim, Milo" <Milo.Kim@ti.com>
To: "wim@iguana.be" <wim@iguana.be>
CC: "linux-watchdog@vger.kernel.org" <linux-watchdog@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] watchdog: softdog: remove replaceable ping operation
Thread-Topic: [PATCH] watchdog: softdog: remove replaceable ping operation
Thread-Index: Ac4p80czuCjz+VxRTj23Yih3TsfvDg==
Date: Tue, 26 Mar 2013 07:26:49 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F82E49607@DQHE02.ent.ti.com>
Accept-Language: ko-KR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.87.185.62]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In watchdog_ping(), 'start' is called automatically when 'ping' function call
is not configured.
Softdog driver has same handling in both cases - start and ping, so 'ping' OPS
can be removed.

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 drivers/watchdog/softdog.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/watchdog/softdog.c b/drivers/watchdog/softdog.c
index fe83beb..b68b1e5 100644
--- a/drivers/watchdog/softdog.c
+++ b/drivers/watchdog/softdog.c
@@ -152,7 +152,6 @@ static struct watchdog_ops softdog_ops = {
 	.owner = THIS_MODULE,
 	.start = softdog_ping,
 	.stop = softdog_stop,
-	.ping = softdog_ping,
 	.set_timeout = softdog_set_timeout,
 };
 
-- 
1.7.9.5


Best Regards,
Milo


