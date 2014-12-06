Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752771AbaLFPKd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2014 10:10:33 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:47794 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752355AbaLFPIM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2014 10:08:12 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Cong Wang <cwang@twopensource.com>,
        "David S. Miller" <davem@davemloft.net>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Antonio Quartulli <antonio@open-mesh.com>,
        Marek Lindner <mareklindner@neomailbox.ch>,
        Cong Wang <xiyou.wangcong@gmail.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 66/66] batman: fix a bogus warning from batadv_is_on_batman_iface()
Date: Sat,  6 Dec 2014 16:07:58 +0100
Message-Id: <0ac8b68cefb09d4fe332b76f3171dfece2582104.1417878427.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <d278ba6471641f99eda3b3c76f8414339c9dbed0.1417878427.git.jslaby@suse.cz>
References: <d278ba6471641f99eda3b3c76f8414339c9dbed0.1417878427.git.jslaby@suse.cz>
In-Reply-To: <cover.1417878427.git.jslaby@suse.cz>
References: <cover.1417878427.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cong Wang <cwang@twopensource.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit b6ed5498601df40489606dbc14a9c7011c16630b upstream.

batman tries to search dev->iflink to check if it's a batman interface,
but ->iflink could be 0, which is not a valid ifindex. It should just
avoid iflink == 0 case.

Reported-by: Jet Chen <jet.chen@intel.com>
Tested-by: Jet Chen <jet.chen@intel.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Steffen Klassert <steffen.klassert@secunet.com>
Cc: Antonio Quartulli <antonio@open-mesh.com>
Cc: Marek Lindner <mareklindner@neomailbox.ch>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
Signed-off-by: Cong Wang <cwang@twopensource.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 net/batman-adv/hard-interface.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/batman-adv/hard-interface.c b/net/batman-adv/hard-interface.c
index c478e6bcf89b..75f8c72a1f8f 100644
--- a/net/batman-adv/hard-interface.c
+++ b/net/batman-adv/hard-interface.c
@@ -83,7 +83,7 @@ static bool batadv_is_on_batman_iface(const struct net_device *net_dev)
 		return true;
 
 	/* no more parents..stop recursion */
-	if (net_dev->iflink == net_dev->ifindex)
+	if (net_dev->iflink == 0 || net_dev->iflink == net_dev->ifindex)
 		return false;
 
 	/* recurse over the parent device */
-- 
2.1.3

