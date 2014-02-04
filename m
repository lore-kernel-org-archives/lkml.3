Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934926AbaBDVRV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 16:17:21 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57475 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934780AbaBDVMv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 16:12:51 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.13 115/140] fib_frontend: fix possible NULL pointer dereference
Date: Tue,  4 Feb 2014 13:11:42 -0800
Message-Id: <20140204211040.258731051@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140204211036.967663852@linuxfoundation.org>
References: <20140204211036.967663852@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oliver Hartkopp <socketcan@hartkopp.net>

[ Upstream commit a0065f266a9b5d51575535a25c15ccbeed9a9966 ]

The two commits 0115e8e30d (net: remove delay at device dismantle) and
748e2d9396a (net: reinstate rtnl in call_netdevice_notifiers()) silently
removed a NULL pointer check for in_dev since Linux 3.7.

This patch re-introduces this check as it causes crashing the kernel when
setting small mtu values on non-ip capable netdevices.

Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
Acked-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/fib_frontend.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/ipv4/fib_frontend.c
+++ b/net/ipv4/fib_frontend.c
@@ -1047,6 +1047,8 @@ static int fib_netdev_event(struct notif
 	}
 
 	in_dev = __in_dev_get_rtnl(dev);
+	if (!in_dev)
+		return NOTIFY_DONE;
 
 	switch (event) {
 	case NETDEV_UP:


