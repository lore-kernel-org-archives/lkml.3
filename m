Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759330Ab3CZR6S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 13:58:18 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:9615 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753982Ab3CZRgJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 13:36:09 -0400
X-Authority-Analysis: v=2.0 cv=UN5f7Vjy c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=si9fn7eAXHgA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=goAKRR9QTb8A:10 a=20KFwNOVAAAA:8 a=J1Y8HTJGAAAA:8 a=GZK3lcuhIWR5GrNAc6YA:9 a=jEp0ucaQiEUA:10 a=4N9Db7Z2_RYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130326173603.867853069@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 26 Mar 2013 13:21:24 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Daniel Borkmann <dborkman@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 25/86] net: sctp: sctp_setsockopt_auth_key: use kzfree instead of kfree
References: <20130326172059.136127374@goodmis.org>
Content-Disposition: inline; filename=0025-net-sctp-sctp_setsockopt_auth_key-use-kzfree-instead.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.1 stable review patch.
If anyone has any objections, please let me know.

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
---
 net/sctp/socket.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index cb54123..d32d86d 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -3375,7 +3375,7 @@ static int sctp_setsockopt_auth_key(struct sock *sk,
 
 	ret = sctp_auth_set_key(sctp_sk(sk)->ep, asoc, authkey);
 out:
-	kfree(authkey);
+	kzfree(authkey);
 	return ret;
 }
 
-- 
1.7.10.4


