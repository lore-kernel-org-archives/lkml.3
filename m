Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760277Ab3D2TOT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 15:14:19 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60932 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759283Ab3D2TDR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 15:03:17 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Daniel Borkmann <dborkman@redhat.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Vlad Yasevich <vyasevich@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 30/34] net: sctp: sctp_auth_key_put: use kzfree instead of kfree
Date: Mon, 29 Apr 2013 12:02:37 -0700
Message-Id: <20130429184704.295077191@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130429184700.845644077@linuxfoundation.org>
References: <20130429184700.845644077@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Daniel Borkmann <dborkman@redhat.com>

[ Upstream commit 586c31f3bf04c290dc0a0de7fc91d20aa9a5ee53 ]

For sensitive data like keying material, it is common practice to zero
out keys before returning the memory back to the allocator. Thus, use
kzfree instead of kfree.

Signed-off-by: Daniel Borkmann <dborkman@redhat.com>
Acked-by: Neil Horman <nhorman@tuxdriver.com>
Acked-by: Vlad Yasevich <vyasevich@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sctp/auth.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/sctp/auth.c
+++ b/net/sctp/auth.c
@@ -71,7 +71,7 @@ void sctp_auth_key_put(struct sctp_auth_
 		return;
 
 	if (atomic_dec_and_test(&key->refcnt)) {
-		kfree(key);
+		kzfree(key);
 		SCTP_DBG_OBJCNT_DEC(keys);
 	}
 }


