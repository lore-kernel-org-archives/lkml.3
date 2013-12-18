Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752737Ab3LRVKo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 16:10:44 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:35831 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752545Ab3LRVJL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 16:09:11 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alan Cox <alan@linux.intel.com>, Guenter Roeck <linux@roeck-us.net>,
        Wim Van Sebroeck <wim@iguana.be>
Subject: [PATCH 3.4 29/31] sc1200_wdt: Fix oops
Date: Wed, 18 Dec 2013 13:08:37 -0800
Message-Id: <20131218210523.611486738@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20131218210522.790152625@linuxfoundation.org>
References: <20131218210522.790152625@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/watchdog/sc1200wdt.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

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


