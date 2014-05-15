Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755196AbaEOOvz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 10:51:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41828 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752312AbaEOOvy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 10:51:54 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH] af_rxrpc: Fix XDR length check in rxrpc key demarshalling.
From: David Howells <dhowells@redhat.com>
To: netdev@vger.kernel.org
Cc: Nathaniel Wesley Filardo <nwf@cs.jhu.edu>, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date: Thu, 15 May 2014 15:51:22 +0100
Message-ID: <20140515145122.29177.65285.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nathaniel W Filardo <nwf@cs.jhu.edu>

There may be padding on the ticket contained in the key payload, so just ensure
that the claimed token length is large enough, rather than exactly the right
size.

Signed-off-by: Nathaniel Wesley Filardo <nwf@cs.jhu.edu>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 net/rxrpc/ar-key.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/rxrpc/ar-key.c b/net/rxrpc/ar-key.c
index 7633a752c65e..0ad080790a32 100644
--- a/net/rxrpc/ar-key.c
+++ b/net/rxrpc/ar-key.c
@@ -99,7 +99,7 @@ static int rxrpc_instantiate_xdr_rxkad(struct key *key, const __be32 *xdr,
 	_debug("tktlen: %x", tktlen);
 	if (tktlen > AFSTOKEN_RK_TIX_MAX)
 		return -EKEYREJECTED;
-	if (8 * 4 + tktlen != toklen)
+	if (toklen < 8 * 4 + tktlen)
 		return -EKEYREJECTED;
 
 	plen = sizeof(*token) + sizeof(*token->kad) + tktlen;

