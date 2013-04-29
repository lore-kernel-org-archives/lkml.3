Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933685Ab3D2Tb2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 15:31:28 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60805 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759650Ab3D2TDA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 15:03:00 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mathias Krause <minipli@googlemail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 05/34] atm: update msg_namelen in vcc_recvmsg()
Date: Mon, 29 Apr 2013 12:02:12 -0700
Message-Id: <20130429184701.509555702@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130429184700.845644077@linuxfoundation.org>
References: <20130429184700.845644077@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Mathias Krause <minipli@googlemail.com>

[ Upstream commit 9b3e617f3df53822345a8573b6d358f6b9e5ed87 ]

The current code does not fill the msg_name member in case it is set.
It also does not set the msg_namelen member to 0 and therefore makes
net/socket.c leak the local, uninitialized sockaddr_storage variable
to userland -- 128 bytes of kernel stack memory.

Fix that by simply setting msg_namelen to 0 as obviously nobody cared
about vcc_recvmsg() not filling the msg_name in case it was set.

Signed-off-by: Mathias Krause <minipli@googlemail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/atm/common.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/atm/common.c
+++ b/net/atm/common.c
@@ -520,6 +520,8 @@ int vcc_recvmsg(struct kiocb *iocb, stru
 	struct sk_buff *skb;
 	int copied, error = -EINVAL;
 
+	msg->msg_namelen = 0;
+
 	if (sock->state != SS_CONNECTED)
 		return -ENOTCONN;
 


