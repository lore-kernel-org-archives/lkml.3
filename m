Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965877AbaKNSgu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 13:36:50 -0500
Received: from mailrelay010.isp.belgacom.be ([195.238.6.177]:7330 "EHLO
	mailrelay010.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965580AbaKNSgt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 13:36:49 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aq4SAF5LZlRXQzQ2/2dsb2JhbABbgw6BLrlDBQF1mg8EAoEdFwEBAQEBfYQwLyOBGjeIRQHBcJBRhj6KAGQdhDUFnkyNEologUcBgjU8MIEGgUUBAQE
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, "David S. Miller" <davem@davemloft.net>,
        netdev@vger.kernel.org
Subject: [PATCH 1/1 net-next] net: dsa: replace count*size kmalloc by kmalloc_array
Date: Fri, 14 Nov 2014 19:36:42 +0100
Message-Id: <1415990202-28673-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kmalloc_array manages count*sizeof overflow.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 net/dsa/dsa.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/dsa/dsa.c b/net/dsa/dsa.c
index 4648f12..c00cca3 100644
--- a/net/dsa/dsa.c
+++ b/net/dsa/dsa.c
@@ -526,7 +526,8 @@ static int dsa_of_setup_routing_table(struct dsa_platform_data *pd,
 
 	/* First time routing table allocation */
 	if (!cd->rtable) {
-		cd->rtable = kmalloc(pd->nr_chips * sizeof(s8), GFP_KERNEL);
+		cd->rtable = kmalloc_array(pd->nr_chips, sizeof(s8),
+					   GFP_KERNEL);
 		if (!cd->rtable)
 			return -ENOMEM;
 
-- 
1.9.3

