Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932490Ab3KHCSx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 21:18:53 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:34673 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932441Ab3KHCSo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 21:18:44 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mathias Krause <minipli@googlemail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 28/91] unix_diag: fix info leak
Date: Thu,  7 Nov 2013 18:14:43 -0800
Message-Id: <1383876946-2396-29-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1383876946-2396-1-git-send-email-kamal@canonical.com>
References: <1383876946-2396-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mathias Krause <minipli@googlemail.com>

[ Upstream commit 6865d1e834be84ddd5808d93d5035b492346c64a ]

When filling the netlink message we miss to wipe the pad field,
therefore leak one byte of heap memory to userland. Fix this by
setting pad to 0.

Signed-off-by: Mathias Krause <minipli@googlemail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/unix/diag.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/unix/diag.c b/net/unix/diag.c
index 5ac19dc..ff4f29b 100644
--- a/net/unix/diag.c
+++ b/net/unix/diag.c
@@ -124,6 +124,7 @@ static int sk_diag_fill(struct sock *sk, struct sk_buff *skb, struct unix_diag_r
 	rep->udiag_family = AF_UNIX;
 	rep->udiag_type = sk->sk_type;
 	rep->udiag_state = sk->sk_state;
+	rep->pad = 0;
 	rep->udiag_ino = sk_ino;
 	sock_diag_save_cookie(sk, rep->udiag_cookie);
 
-- 
1.8.1.2

