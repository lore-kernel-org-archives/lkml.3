Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759341Ab3BLU6m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 15:58:42 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53631 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755617Ab3BLUgM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 15:36:12 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Daniel Borkmann <dborkman@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 50/61] net: sctp: sctp_setsockopt_auth_key: use kzfree instead of kfree
Date: Tue, 12 Feb 2013 12:35:10 -0800
Message-Id: <20130212203424.676542580@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130212203417.890993903@linuxfoundation.org>
References: <20130212203417.890993903@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sctp/socket.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -3388,7 +3388,7 @@ static int sctp_setsockopt_auth_key(stru
 
 	ret = sctp_auth_set_key(sctp_sk(sk)->ep, asoc, authkey);
 out:
-	kfree(authkey);
+	kzfree(authkey);
 	return ret;
 }
 


