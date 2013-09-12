Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754193Ab3ILNJp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 09:09:45 -0400
Received: from georges.telenet-ops.be ([195.130.137.68]:59726 "EHLO
	georges.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754084Ab3ILNJn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 09:09:43 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: linux-nfs@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] sunrpc: Add missing kuids conversion for printing
Date: Thu, 12 Sep 2013 15:09:39 +0200
Message-Id: <1378991379-9106-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

m68k/allmodconfig:

net/sunrpc/auth_generic.c: In function ‘generic_key_timeout’:
net/sunrpc/auth_generic.c:241: warning: format ‘%d’ expects type ‘int’, but
argument 2 has type ‘kuid_t’

commit cdba321e291f0fbf5abda4d88340292b858e3d4d ("sunrpc: Convert kuids and
kgids to uids and gids for printing") forgot to convert one instance.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 net/sunrpc/auth_generic.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sunrpc/auth_generic.c b/net/sunrpc/auth_generic.c
index f6d84be..ed04869 100644
--- a/net/sunrpc/auth_generic.c
+++ b/net/sunrpc/auth_generic.c
@@ -239,7 +239,7 @@ generic_key_timeout(struct rpc_auth *auth, struct rpc_cred *cred)
 		if (test_and_clear_bit(RPC_CRED_KEY_EXPIRE_SOON,
 					&acred->ac_flags))
 			dprintk("RPC:        UID %d Credential key reset\n",
-				tcred->cr_uid);
+				from_kuid(&init_user_ns, tcred->cr_uid));
 		/* set up fasttrack for the normal case */
 		set_bit(RPC_CRED_NOTIFY_TIMEOUT, &acred->ac_flags);
 	}
-- 
1.7.9.5

