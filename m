Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757042Ab3J1Otu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 10:49:50 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51267 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757017Ab3J1Otp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 10:49:45 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mathias Krause <minipli@googlemail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 51/64] unix_diag: fix info leak
Date: Mon, 28 Oct 2013 14:48:10 +0000
Message-Id: <1382971703-17393-52-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1382971703-17393-1-git-send-email-luis.henriques@canonical.com>
References: <1382971703-17393-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.24 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mathias Krause <minipli@googlemail.com>

commit 6865d1e834be84ddd5808d93d5035b492346c64a upstream.

When filling the netlink message we miss to wipe the pad field,
therefore leak one byte of heap memory to userland. Fix this by
setting pad to 0.

Signed-off-by: Mathias Krause <minipli@googlemail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/unix/diag.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/unix/diag.c b/net/unix/diag.c
index 47d3002..1b4d8fc 100644
--- a/net/unix/diag.c
+++ b/net/unix/diag.c
@@ -134,6 +134,7 @@ static int sk_diag_fill(struct sock *sk, struct sk_buff *skb, struct unix_diag_r
 	rep->udiag_family = AF_UNIX;
 	rep->udiag_type = sk->sk_type;
 	rep->udiag_state = sk->sk_state;
+	rep->pad = 0;
 	rep->udiag_ino = sk_ino;
 	sock_diag_save_cookie(sk, rep->udiag_cookie);
 
-- 
1.8.3.2

