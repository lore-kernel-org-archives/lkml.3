Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965401AbaE3Prd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 11:47:33 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:43579 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932189AbaE3Pra (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 11:47:30 -0400
Date: Fri, 30 May 2014 21:17:13 +0530
From: Himangi Saraogi <himangi774@gmail.com>
To: Chien Yen <chien.yen@oracle.com>, "David S. Miller" <davem@davemloft.net>,
        rds-devel@oss.oracle.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: julia.lawall@lip6.fr
Subject: [PATCH] rds/tcp_listen: Replace comma with semicolon
Message-ID: <20140530154713.GA4079@himangi-Dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch replaces a comma between expression statements by a semicolon.

A simplified version of the semantic patch that performs this
transformation is as follows:

// <smpl>
@r@
expression e1,e2,e;
type T;
identifier i;
@@

 e1
-,
+;
 e2;
// </smpl>

Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
Acked-by: Julia Lawall <julia.lawall@lip6.fr>
---
 net/rds/tcp_listen.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/rds/tcp_listen.c b/net/rds/tcp_listen.c
index 4e638f8..23ab4dcd 100644
--- a/net/rds/tcp_listen.c
+++ b/net/rds/tcp_listen.c
@@ -153,7 +153,7 @@ int rds_tcp_listen_init(void)
 	sock->sk->sk_data_ready = rds_tcp_listen_data_ready;
 	write_unlock_bh(&sock->sk->sk_callback_lock);
 
-	sin.sin_family = PF_INET,
+	sin.sin_family = PF_INET;
 	sin.sin_addr.s_addr = (__force u32)htonl(INADDR_ANY);
 	sin.sin_port = (__force u16)htons(RDS_TCP_PORT);
 
-- 
1.9.1

