Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751483Ab3LLIit (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 03:38:49 -0500
Received: from mail-pd0-f176.google.com ([209.85.192.176]:52488 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751013Ab3LLIir (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 03:38:47 -0500
From: Olof Johansson <olof@lixom.net>
To: davem@davemloft.net
Cc: linux@arm.linux.org.uk, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        tedheadster@gmail.com, Olof Johansson <olof@lixom.net>
Subject: [PATCH] net: eth: 8390: remove section warning in etherh.c
Date: Thu, 12 Dec 2013 00:39:37 -0800
Message-Id: <1386837577-15130-1-git-send-email-olof@lixom.net>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit c45f812f0280 ('8390 : Replace ei_debug with msg_enable/NETIF_MSG_*
feature') ended up moving the printout of version[] from something that
will be compiled out due to defines, to something that is now evaluated
at runtime.

That means that what always used to be an access to an __initdata string
from non-__init code started showing up as a section mismatch when it
didn't before.

All other 8390 versions skip __initdata on the version string, and
starting to annotate the whole chain of callers with __init seems like
more churn than it's worth on this driver, so remove it from etherh.c as well.

Fixes: c45f812f0280 ('8390 : Replace ei_debug with msg_enable/NETIF_MSG_* feature')
Signed-off-by: Olof Johansson <olof@lixom.net>
---
 drivers/net/ethernet/8390/etherh.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/8390/etherh.c b/drivers/net/ethernet/8390/etherh.c
index b15e482a..b36ee9e 100644
--- a/drivers/net/ethernet/8390/etherh.c
+++ b/drivers/net/ethernet/8390/etherh.c
@@ -59,7 +59,7 @@
 #define DRV_NAME	"etherh"
 #define DRV_VERSION	"1.11"
 
-static char version[] __initdata =
+static char version[] =
 	"EtherH/EtherM Driver (c) 2002-2004 Russell King " DRV_VERSION "\n";
 
 #include "lib8390.c"
-- 
1.7.10.4

