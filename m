Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753292AbaAMQBT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 11:01:19 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:52807 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753233AbaAMQBF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 11:01:05 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alan Cox <alan@linux.intel.com>, Wim Van Sebroeck <wim@iguana.be>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 007/208] sc1200_wdt: Fix oops
Date: Mon, 13 Jan 2014 15:57:28 +0000
Message-Id: <1389628849-1614-8-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
References: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alan <gnomes@lxorguk.ukuu.org.uk>

commit dace8bbfccfd9e4fcccfffcfbd82881fda3e756f upstream.

If loaded with isapnp = 0 the driver explodes. This is catching
people out now and then. What should happen in the working case is
a complete mystery and the code appears terminally confused, but we
can at least make the error path work properly.

Signed-off-by: Alan Cox <alan@linux.intel.com>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Wim Van Sebroeck <wim@iguana.be>
Partially-Resolves-bug: https://bugzilla.kernel.org/show_bug.cgi?id=53991
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/watchdog/sc1200wdt.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/watchdog/sc1200wdt.c b/drivers/watchdog/sc1200wdt.c
index 3fb83b0..ab6d3f5 100644
--- a/drivers/watchdog/sc1200wdt.c
+++ b/drivers/watchdog/sc1200wdt.c
@@ -409,8 +409,9 @@ static int __init sc1200wdt_init(void)
 #if defined CONFIG_PNP
 	/* now that the user has specified an IO port and we haven't detected
 	 * any devices, disable pnp support */
+	if (isapnp)
+		pnp_unregister_driver(&scl200wdt_pnp_driver);
 	isapnp = 0;
-	pnp_unregister_driver(&scl200wdt_pnp_driver);
 #endif
 
 	if (!request_region(io, io_len, SC1200_MODULE_NAME)) {
-- 
1.8.3.2

