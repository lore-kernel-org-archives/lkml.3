Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754186AbaF0VJG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 17:09:06 -0400
Received: from mailrelay011.isp.belgacom.be ([195.238.6.178]:55990 "EHLO
	mailrelay011.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752851AbaF0VJE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 17:09:04 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AkUHAIbcrVNXQCoO/2dsb2JhbABbgw2rbwUBAQEBAQEFAW0BmQKBDRd1hDEvI4EaN4hGAcRWF4VkiSEdhC0Fml2LP4g8ggCBRDs
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>,
        Dmitry Tarnyagin <dmitry.tarnyagin@lockless.no>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH 1/1] net/caif/caif_socket.c: remove unnecessary null test before debugfs_remove_recursive
Date: Fri, 27 Jun 2014 23:07:43 +0200
Message-Id: <1403903263-13355-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

based on checkpatch:
"debugfs_remove_recursive(NULL) is safe this check is probably not required"

Cc: Dmitry Tarnyagin <dmitry.tarnyagin@lockless.no>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: netdev@vger.kernel.org
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 net/caif/caif_socket.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/caif/caif_socket.c b/net/caif/caif_socket.c
index e843709..43f750e 100644
--- a/net/caif/caif_socket.c
+++ b/net/caif/caif_socket.c
@@ -908,8 +908,7 @@ static int caif_release(struct socket *sock)
 	sock->sk = NULL;
 
 	WARN_ON(IS_ERR(cf_sk->debugfs_socket_dir));
-	if (cf_sk->debugfs_socket_dir != NULL)
-		debugfs_remove_recursive(cf_sk->debugfs_socket_dir);
+	debugfs_remove_recursive(cf_sk->debugfs_socket_dir);
 
 	lock_sock(&(cf_sk->sk));
 	sk->sk_state = CAIF_DISCONNECTED;
-- 
1.8.4.5

