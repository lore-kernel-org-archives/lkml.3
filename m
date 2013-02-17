Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755712Ab3BQWza (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2013 17:55:30 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:45678 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755172Ab3BQWzW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2013 17:55:22 -0500
Message-Id: <20130217225007.906916186@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 17 Feb 2013 22:50:55 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Daniel Borkmann <dborkman@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 54/66] net: sctp: sctp_setsockopt_auth_key: use kzfree  instead of kfree
In-Reply-To: <20130217225001.621306883@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:a11:96ff:fec6:70c4
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Borkmann <dborkman@redhat.com>

[ Upstream commit 6ba542a291a5e558603ac51cda9bded347ce7627 ]

In sctp_setsockopt_auth_key, we create a temporary copy of the user
passed shared auth key for the endpoint or association and after
internal setup, we free it right away. Since it's sensitive data, we
should zero out the key before returning the memory back to the
allocator. Thus, use kzfree instead of kfree, just as we do in
sctp_auth_key_put().

Signed-off-by: Daniel Borkmann <dborkman@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/sctp/socket.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index fa8333b..5e0d86e 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -3375,7 +3375,7 @@ static int sctp_setsockopt_auth_key(struct sock *sk,
 
 	ret = sctp_auth_set_key(sctp_sk(sk)->ep, asoc, authkey);
 out:
-	kfree(authkey);
+	kzfree(authkey);
 	return ret;
 }
 


