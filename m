Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751706AbaJAEwR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 00:52:17 -0400
Received: from mailrelay007.isp.belgacom.be ([195.238.6.173]:12157 "EHLO
	mailrelay007.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751289AbaJAEwP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 00:52:15 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqISAP+HK1RbtAoV/2dsb2JhbABggw62dQUBBQUBcgGaUwQCgQ4XAXuEYCOBGjeIQgGuXJAOhhKJKGQdhDUFnS+MSYkng2U7L4EGgUQBAQE
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, Gerrit Renker <gerrit@erg.abdn.ac.uk>,
        "David S. Miller" <davem@davemloft.net>, dccp@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH 1/1 linux-next] net/dccp/ccid.c: add __init to ccid_activate
Date: Wed,  1 Oct 2014 06:52:06 +0200
Message-Id: <1412139126-3794-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ccid_activate is only called by __init ccid_initialize_builtins in same module.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 net/dccp/ccid.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/dccp/ccid.c b/net/dccp/ccid.c
index 5975572..8349897 100644
--- a/net/dccp/ccid.c
+++ b/net/dccp/ccid.c
@@ -99,7 +99,7 @@ static void ccid_kmem_cache_destroy(struct kmem_cache *slab)
 		kmem_cache_destroy(slab);
 }
 
-static int ccid_activate(struct ccid_operations *ccid_ops)
+static int __init ccid_activate(struct ccid_operations *ccid_ops)
 {
 	int err = -ENOBUFS;
 
-- 
1.9.3

