Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756838AbaIIOUO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 10:20:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1509 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751798AbaIIOUM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 10:20:12 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH] RxRPC: Fix missing __user annotation
From: David Howells <dhowells@redhat.com>
To: netdev@vger.kernel.org
Cc: linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Tue, 09 Sep 2014 15:19:44 +0100
Message-ID: <20140909141944.18112.74852.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a missing __user annotation in a cast of a user space pointer (found by
checker).

Signed-off-by: David Howells <dhowells@redhat.com>
---

 net/rxrpc/ar-key.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/rxrpc/ar-key.c b/net/rxrpc/ar-key.c
index b45d080e64a7..1b24191167f1 100644
--- a/net/rxrpc/ar-key.c
+++ b/net/rxrpc/ar-key.c
@@ -1143,7 +1143,7 @@ static long rxrpc_read(const struct key *key,
 		if (copy_to_user(xdr, (s), _l) != 0)			\
 			goto fault;					\
 		if (_l & 3 &&						\
-		    copy_to_user((u8 *)xdr + _l, &zero, 4 - (_l & 3)) != 0) \
+		    copy_to_user((u8 __user *)xdr + _l, &zero, 4 - (_l & 3)) != 0) \
 			goto fault;					\
 		xdr += (_l + 3) >> 2;					\
 	} while(0)

