Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754090AbaBJTqT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 14:46:19 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:34925 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754064AbaBJTqN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 14:46:13 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Oliver Hartkopp <socketcan@hartkopp.net>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 119/124] fib_frontend: fix possible NULL pointer dereference
Date: Mon, 10 Feb 2014 11:40:59 -0800
Message-Id: <1392061264-28124-120-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1392061264-28124-1-git-send-email-kamal@canonical.com>
References: <1392061264-28124-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.18 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/ipv4/fib_frontend.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/ipv4/fib_frontend.c b/net/ipv4/fib_frontend.c
index 5cd75e2..93ea4a1 100644
--- a/net/ipv4/fib_frontend.c
+++ b/net/ipv4/fib_frontend.c
@@ -1052,6 +1052,8 @@ static int fib_netdev_event(struct notifier_block *this, unsigned long event, vo
 	}
 
 	in_dev = __in_dev_get_rtnl(dev);
+	if (!in_dev)
+		return NOTIFY_DONE;
 
 	switch (event) {
 	case NETDEV_UP:
-- 
1.8.3.2

