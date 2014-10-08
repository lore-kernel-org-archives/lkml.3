Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754591AbaJHShG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 14:37:06 -0400
Received: from mailrelay009.isp.belgacom.be ([195.238.6.176]:46604 "EHLO
	mailrelay009.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751253AbaJHShD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 14:37:03 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApgSAGODNVRbsGtC/2dsb2JhbABfgw65BwUBc5oCBAKBCxcBe4RgI4EaN4hCAbcFjmqGIIokHYQ1BZ1FjFqJM4NlOy+CSgEBAQ
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, Paul Moore <paul@paul-moore.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH 1/1 net-next] netlabel: directly return netlbl_unlabel_genl_init()
Date: Wed,  8 Oct 2014 20:37:01 +0200
Message-Id: <1412793421-9914-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No need to store netlbl_unlabel_genl_init result and test it before returning.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 net/netlabel/netlabel_user.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/net/netlabel/netlabel_user.c b/net/netlabel/netlabel_user.c
index 1e779bb..adf8b79 100644
--- a/net/netlabel/netlabel_user.c
+++ b/net/netlabel/netlabel_user.c
@@ -71,11 +71,7 @@ int __init netlbl_netlink_init(void)
 	if (ret_val != 0)
 		return ret_val;
 
-	ret_val = netlbl_unlabel_genl_init();
-	if (ret_val != 0)
-		return ret_val;
-
-	return 0;
+	return netlbl_unlabel_genl_init();
 }
 
 /*
-- 
1.9.1

