Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754128AbaELCIx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 22:08:53 -0400
Received: from 1wt.eu ([62.212.114.60]:34525 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752491AbaELBmU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 21:42:20 -0400
Message-Id: <20140512003202.003301323@1wt.eu>
User-Agent: quilt/0.48-1
Date: Mon, 12 May 2014 02:32:33 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        "David S. Miller" <davem@davemloft.net>, Willy Tarreau <w@1wt.eu>
Subject: [ 033/143] farsync: fix info leak in ioctl
In-Reply-To: <f07e5fe6d87f172fc73580b9c86ba9a2@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: =?latin1?q?Salva=20Peir=F3?= <speiro@ai2.upv.es>

[ Upstream commit 96b340406724d87e4621284ebac5e059d67b2194 ]

The fst_get_iface() code fails to initialize the two padding bytes of
struct sync_serial_settings after the ->loopback member. Add an explicit
memset(0) before filling the structure to avoid the info leak.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 drivers/net/wan/farsync.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wan/farsync.c b/drivers/net/wan/farsync.c
index beda387..433bf99 100644
--- a/drivers/net/wan/farsync.c
+++ b/drivers/net/wan/farsync.c
@@ -1971,6 +1971,7 @@ fst_get_iface(struct fst_card_info *card, struct fst_port_info *port,
 	}
 
 	i = port->index;
+	memset(&sync, 0, sizeof(sync));
 	sync.clock_rate = FST_RDL(card, portConfig[i].lineSpeed);
 	/* Lucky card and linux use same encoding here */
 	sync.clock_type = FST_RDB(card, portConfig[i].internalClock) ==
-- 
1.7.12.2.21.g234cd45.dirty



