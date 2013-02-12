Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759113Ab3BLVGA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 16:06:00 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53489 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752968Ab3BLUfw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 15:35:52 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>,
        John Fastabend <john.r.fastabend@intel.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 23/61] macvlan: fix macvlan_get_size()
Date: Tue, 12 Feb 2013 12:34:43 -0800
Message-Id: <20130212203421.527870315@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130212203417.890993903@linuxfoundation.org>
References: <20130212203417.890993903@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 01fe944f1024bd4e5c327ddbe8d657656b66af2f ]

commit df8ef8f3aaa (macvlan: add FDB bridge ops and macvlan flags)
forgot to update macvlan_get_size() after the addition of
IFLA_MACVLAN_FLAGS

Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: John Fastabend <john.r.fastabend@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/macvlan.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/net/macvlan.c
+++ b/drivers/net/macvlan.c
@@ -822,7 +822,10 @@ static int macvlan_changelink(struct net
 
 static size_t macvlan_get_size(const struct net_device *dev)
 {
-	return nla_total_size(4);
+	return (0
+		+ nla_total_size(4) /* IFLA_MACVLAN_MODE */
+		+ nla_total_size(2) /* IFLA_MACVLAN_FLAGS */
+		);
 }
 
 static int macvlan_fill_info(struct sk_buff *skb,


