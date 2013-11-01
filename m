Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754623Ab3KAVoB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 17:44:01 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54540 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754485Ab3KAVn5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 17:43:57 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mathias Krause <minipli@googlemail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 15/32] unix_diag: fix info leak
Date: Fri,  1 Nov 2013 14:43:26 -0700
Message-Id: <20131101214317.318936912@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131101214313.735463599@linuxfoundation.org>
References: <20131101214313.735463599@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mathias Krause <minipli@googlemail.com>

[ Upstream commit 6865d1e834be84ddd5808d93d5035b492346c64a ]

When filling the netlink message we miss to wipe the pad field,
therefore leak one byte of heap memory to userland. Fix this by
setting pad to 0.

Signed-off-by: Mathias Krause <minipli@googlemail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/unix/diag.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/unix/diag.c
+++ b/net/unix/diag.c
@@ -134,6 +134,7 @@ static int sk_diag_fill(struct sock *sk,
 	rep->udiag_family = AF_UNIX;
 	rep->udiag_type = sk->sk_type;
 	rep->udiag_state = sk->sk_state;
+	rep->pad = 0;
 	rep->udiag_ino = sk_ino;
 	sock_diag_save_cookie(sk, rep->udiag_cookie);
 


