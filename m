Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967050AbaFTUkT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 16:40:19 -0400
Received: from mailrelay005.isp.belgacom.be ([195.238.6.171]:27670 "EHLO
	mailrelay005.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752863AbaFTUkP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 16:40:15 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsHADWbpFNXQzOZ/2dsb2JhbABZgw2rRwUBAQEBAQEFAZkqgQ4XdYQxLyOBGjeIRgHKLReFYokUHYQtBJpEizCIKoNEOw
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, Pablo Neira Ayuso <pablo@netfilter.org>,
        Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
Subject: [PATCH 1/1] net/netfilter/nf_conntrack_netlink.c: remove null test before kfree
Date: Fri, 20 Jun 2014 22:38:58 +0200
Message-Id: <1403296738-6213-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix checkpatch warning:
WARNING: kfree(NULL) is safe this check is probably not required

Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Patrick McHardy <kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 net/netfilter/nf_conntrack_netlink.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 5857963..aee017f 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -742,8 +742,7 @@ static int ctnetlink_done(struct netlink_callback *cb)
 {
 	if (cb->args[1])
 		nf_ct_put((struct nf_conn *)cb->args[1]);
-	if (cb->data)
-		kfree(cb->data);
+	kfree(cb->data);
 	return 0;
 }
 
-- 
1.8.4.5

