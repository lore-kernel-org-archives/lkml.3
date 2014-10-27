Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752019AbaJ0UMP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 16:12:15 -0400
Received: from mailrelay003.isp.belgacom.be ([195.238.6.53]:6438 "EHLO
	mailrelay003.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751504AbaJ0UMO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 16:12:14 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AmEPAGemTlRXQ3zJ/2dsb2JhbABcgw6BLLlECwUBdJpDgR8XAX2EMC8jgRo3iEUBvGWPEoY0iXBkHYQ1BZ1hjGqJRIFHAYIxPC+BBoFFAQEB
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH V2 net-next] ipx: remove __inline__ in c file on static
Date: Mon, 27 Oct 2014 21:12:08 +0100
Message-Id: <1414440728-6144-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Let compiler decide what to do with static void __ipxitf_put()

Suggested-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
V2: remove __inline__ instead of replacing it by standard inline
(suggested by David S. Miller)

 net/ipx/af_ipx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipx/af_ipx.c b/net/ipx/af_ipx.c
index 91729b8..313ef46 100644
--- a/net/ipx/af_ipx.c
+++ b/net/ipx/af_ipx.c
@@ -306,7 +306,7 @@ void ipxitf_down(struct ipx_interface *intrfc)
 	spin_unlock_bh(&ipx_interfaces_lock);
 }
 
-static __inline__ void __ipxitf_put(struct ipx_interface *intrfc)
+static void __ipxitf_put(struct ipx_interface *intrfc)
 {
 	if (atomic_dec_and_test(&intrfc->refcnt))
 		__ipxitf_down(intrfc);
-- 
1.9.1

