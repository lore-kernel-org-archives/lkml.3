Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757337AbaD2JuV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 05:50:21 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:60070 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751942AbaD2JuT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 05:50:19 -0400
Date: Tue, 29 Apr 2014 18:49:47 +0900
From: Daeseok Youn <daeseok.youn@gmail.com>
To: stefanr@s5r6.in-berlin.de
Cc: daeseok.youn@gmail.com, linux1394-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
Subject: [PATCH] firewire: fix NULL derefencing in fwnet_probe()
Message-ID: <20140429094947.GA11409@devel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"dev" and "net" are NULL when alloc_netdev() is failed.
So just unlock and return an error.

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
---
 drivers/firewire/net.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/firewire/net.c b/drivers/firewire/net.c
index 4af0a7b..c398645 100644
--- a/drivers/firewire/net.c
+++ b/drivers/firewire/net.c
@@ -1462,8 +1462,8 @@ static int fwnet_probe(struct fw_unit *unit,
 
 	net = alloc_netdev(sizeof(*dev), "firewire%d", fwnet_init_dev);
 	if (net == NULL) {
-		ret = -ENOMEM;
-		goto out;
+		mutex_unlock(&fwnet_device_mutex);
+		return -ENOMEM;
 	}
 
 	allocated_netdev = true;
-- 
1.7.4.4

