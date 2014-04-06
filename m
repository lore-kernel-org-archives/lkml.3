Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753693AbaDFN4V (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2014 09:56:21 -0400
Received: from baptiste.telenet-ops.be ([195.130.132.51]:45813 "EHLO
	baptiste.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752817AbaDFN4Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2014 09:56:16 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Jon Maloy <jon.maloy@ericsson.com>,
        Allan Stephens <allan.stephens@windriver.com>,
        "David S. Miller" <davem@davemloft.net>
Cc: netdev@vger.kernel.org, tipc-discussion@lists.sourceforge.net,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] tipc: Let tipc_release() return 0
Date: Sun,  6 Apr 2014 15:56:14 +0200
Message-Id: <1396792574-32169-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

net/tipc/socket.c: In function ‘tipc_release’:
net/tipc/socket.c:352: warning: ‘res’ is used uninitialized in this function

Introduced by commit 24be34b5a0c9114541891d29dff1152bb1a8df34 ("tipc:
eliminate upcall function pointers between port and socket"), which
removed the sole initializer of "res".

Just return 0 to fix it.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 net/tipc/socket.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/tipc/socket.c b/net/tipc/socket.c
index 29b7f26a12cf..adc12e227303 100644
--- a/net/tipc/socket.c
+++ b/net/tipc/socket.c
@@ -301,7 +301,6 @@ static int tipc_release(struct socket *sock)
 	struct tipc_sock *tsk;
 	struct tipc_port *port;
 	struct sk_buff *buf;
-	int res;
 
 	/*
 	 * Exit if socket isn't fully initialized (occurs when a failed accept()
@@ -349,7 +348,7 @@ static int tipc_release(struct socket *sock)
 	sock_put(sk);
 	sock->sk = NULL;
 
-	return res;
+	return 0;
 }
 
 /**
-- 
1.7.9.5

