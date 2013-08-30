Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756946Ab3H3Ql1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 12:41:27 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:56949 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756353Ab3H3QlB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 12:41:01 -0400
From: Guenter Roeck <linux@roeck-us.net>
To: linux-kernel@vger.kernel.org
Cc: linux-ide@vger.kernel.org, netdev@vger.kernel.org,
        linux-watchdog@vger.kernel.org, Wim Van Sebroeck <wim@iguana.be>,
        "David S. Miller" <davem@davemloft.net>,
        Al Viro <viro@zeniv.linux.org.uk>, Eric Paris <eparis@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiang Liu <jiang.liu@huawei.com>, David Howells <dhowells@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 3/7] net/ethernet: smsc: Drop conditional code for H8/300
Date: Fri, 30 Aug 2013 09:40:38 -0700
Message-Id: <1377880842-6835-4-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.7.9.7
In-Reply-To: <1377880842-6835-1-git-send-email-linux@roeck-us.net>
References: <1377880842-6835-1-git-send-email-linux@roeck-us.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the H8/300 architecture gone, this code is no longer necessary.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 drivers/net/ethernet/smsc/smc9194.c |   12 ------------
 1 file changed, 12 deletions(-)

diff --git a/drivers/net/ethernet/smsc/smc9194.c b/drivers/net/ethernet/smsc/smc9194.c
index e85c2e7..814f59b 100644
--- a/drivers/net/ethernet/smsc/smc9194.c
+++ b/drivers/net/ethernet/smsc/smc9194.c
@@ -95,14 +95,6 @@ static const char version[] =
 #define USE_32_BIT 1
 #endif
 
-#if defined(__H8300H__) || defined(__H8300S__)
-#define NO_AUTOPROBE
-#undef insl
-#undef outsl
-#define insl(a,b,l)  io_insl_noswap(a,b,l)
-#define outsl(a,b,l) io_outsl_noswap(a,b,l)
-#endif
-
 /*
  .the SMC9194 can be at any of the following port addresses.  To change,
  .for a slightly different card, you can add it to the array.  Keep in
@@ -651,11 +643,7 @@ static void smc_hardware_send_packet( struct net_device * dev )
 #ifdef USE_32_BIT
 	if ( length & 0x2  ) {
 		outsl(ioaddr + DATA_1, buf,  length >> 2 );
-#if !defined(__H8300H__) && !defined(__H8300S__)
 		outw( *((word *)(buf + (length & 0xFFFFFFFC))),ioaddr +DATA_1);
-#else
-		ctrl_outw( *((word *)(buf + (length & 0xFFFFFFFC))),ioaddr +DATA_1);
-#endif
 	}
 	else
 		outsl(ioaddr + DATA_1, buf,  length >> 2 );
-- 
1.7.9.7

