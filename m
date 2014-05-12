Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758326AbaELCUH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 22:20:07 -0400
Received: from 1wt.eu ([62.212.114.60]:34372 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751825AbaELBlg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 21:41:36 -0400
Message-Id: <20140512003202.295138602@1wt.eu>
User-Agent: quilt/0.48-1
Date: Mon, 12 May 2014 02:32:40 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Chris Healy <cphealy@gmail.com>, "David S. Miller" <davem@davemloft.net>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 040/143] resubmit bridge: fix message_age_timer calculation
In-Reply-To: <f07e5fe6d87f172fc73580b9c86ba9a2@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Healy <cphealy@gmail.com>

[ Upstream commit 9a0620133ccce9dd35c00a96405c8d80938c2cc0 ]

This changes the message_age_timer calculation to use the BPDU's max age as
opposed to the local bridge's max age.  This is in accordance with section
8.6.2.3.2 Step 2 of the 802.1D-1998 sprecification.

With the current implementation, when running with very large bridge
diameters, convergance will not always occur even if a root bridge is
configured to have a longer max age.

Tested successfully on bridge diameters of ~200.

Signed-off-by: Chris Healy <cphealy@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 net/bridge/br_stp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/bridge/br_stp.c b/net/bridge/br_stp.c
index c7d6bfc..a67e6ce 100644
--- a/net/bridge/br_stp.c
+++ b/net/bridge/br_stp.c
@@ -192,7 +192,7 @@ static inline void br_record_config_information(struct net_bridge_port *p,
 	p->designated_age = jiffies + bpdu->message_age;
 
 	mod_timer(&p->message_age_timer, jiffies
-		  + (p->br->max_age - bpdu->message_age));
+		  + (bpdu->max_age - bpdu->message_age));
 }
 
 /* called under bridge lock */
-- 
1.7.12.2.21.g234cd45.dirty



