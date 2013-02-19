Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934285Ab3BSSxG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 13:53:06 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:54383 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932886Ab3BSSxB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 13:53:01 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Eric Dumazet <edumazet@google.com>,
        John Fastabend <john.r.fastabend@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 47/81] macvlan: fix macvlan_get_size()
Date: Tue, 19 Feb 2013 15:49:10 -0300
Message-Id: <1361299784-8830-48-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1361299784-8830-1-git-send-email-herton.krzesinski@canonical.com>
References: <1361299784-8830-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

commit 01fe944f1024bd4e5c327ddbe8d657656b66af2f upstream.

commit df8ef8f3aaa (macvlan: add FDB bridge ops and macvlan flags)
forgot to update macvlan_get_size() after the addition of
IFLA_MACVLAN_FLAGS

Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: John Fastabend <john.r.fastabend@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/net/macvlan.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/macvlan.c b/drivers/net/macvlan.c
index 66a9bfe..62ce7b8 100644
--- a/drivers/net/macvlan.c
+++ b/drivers/net/macvlan.c
@@ -822,7 +822,10 @@ static int macvlan_changelink(struct net_device *dev,
 
 static size_t macvlan_get_size(const struct net_device *dev)
 {
-	return nla_total_size(4);
+	return (0
+		+ nla_total_size(4) /* IFLA_MACVLAN_MODE */
+		+ nla_total_size(2) /* IFLA_MACVLAN_FLAGS */
+		);
 }
 
 static int macvlan_fill_info(struct sk_buff *skb,
-- 
1.7.9.5

