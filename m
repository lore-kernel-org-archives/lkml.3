Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751319AbaJAEsN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 00:48:13 -0400
Received: from mailrelay002.isp.belgacom.be ([195.238.6.175]:10520 "EHLO
	mailrelay002.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750750AbaJAEsK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 00:48:10 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqISAMqGK1RbtAoV/2dsb2JhbABggw62dQUBBQUBcgGaUwQCgQ4XAXuEYCOBGjeIQgGuXJANhhKJKGQdhDUFnS+MSYkng2U7L4EGgUQBAQE
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, Gerrit Renker <gerrit@erg.abdn.ac.uk>,
        "David S. Miller" <davem@davemloft.net>, dccp@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH 1/1 linux-next] net/dccp/proto.c: add __init to dccp_mib_init
Date: Wed,  1 Oct 2014 06:48:03 +0200
Message-Id: <1412138883-2476-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dccp_mib_init is only called by __init dccp_init in same module.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 net/dccp/proto.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/dccp/proto.c b/net/dccp/proto.c
index e421edd..6d090c4 100644
--- a/net/dccp/proto.c
+++ b/net/dccp/proto.c
@@ -1082,7 +1082,7 @@ void dccp_shutdown(struct sock *sk, int how)
 
 EXPORT_SYMBOL_GPL(dccp_shutdown);
 
-static inline int dccp_mib_init(void)
+static inline int __init dccp_mib_init(void)
 {
 	dccp_statistics = alloc_percpu(struct dccp_mib);
 	if (!dccp_statistics)
-- 
1.9.3

