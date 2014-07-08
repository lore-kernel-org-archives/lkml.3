Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754572AbaGHWUb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 18:20:31 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:48875 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750947AbaGHWU3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 18:20:29 -0400
Date: Wed, 9 Jul 2014 03:50:23 +0530
From: Himangi Saraogi <himangi774@gmail.com>
To: "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: julia.lawall@lip6.fr
Subject: [PATCH] iaf_packet: use BUG_ON
Message-ID: <20140708222023.GA11829@himangi-Dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use BUG_ON(x) rather than if(x) BUG();

The semantic patch that fixes this problem is as follows:

// <smpl>
@@ identifier x; @@
-if (x) BUG();
+BUG_ON(x);
// </smpl>

Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
Acked-by: Julia Lawall <julia.lawall@lip6.fr>
---
To send to: "David S. Miller" <davem@davemloft.net>,netdev@vger.kernel.org,linux-kernel@vger.kernel.org
 net/packet/af_packet.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index b85c67c..cda8552 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -551,8 +551,7 @@ static void prb_setup_retire_blk_timer(struct packet_sock *po, int tx_ring)
 {
 	struct tpacket_kbdq_core *pkc;
 
-	if (tx_ring)
-		BUG();
+	BUG_ON(tx_ring);
 
 	pkc = tx_ring ? GET_PBDQC_FROM_RB(&po->tx_ring) :
 			GET_PBDQC_FROM_RB(&po->rx_ring);
-- 
1.9.1

