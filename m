Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758258Ab3EBPaT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 11:30:19 -0400
Received: from eva.fit.vutbr.cz ([147.229.176.14]:34262 "EHLO eva.fit.vutbr.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754674Ab3EBPaS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 11:30:18 -0400
X-Greylist: delayed 340 seconds by postgrey-1.27 at vger.kernel.org; Thu, 02 May 2013 11:30:17 EDT
Message-ID: <51828687.7040605@stud.fit.vutbr.cz>
Date: Thu, 02 May 2013 17:30:15 +0200
From: =?ISO-8859-1?Q?Radmila_Kompov=E1?= <xkompo00@stud.fit.vutbr.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: linux-nfs@vger.kernel.org
CC: linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] net/sunrpc/auth.c: move NULL check in rpcauth_invalcred()
 before first dereference
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Detected by cppcheck.

Signed-off-by: Kamil Dudka <kdudka@redhat.com>
---
 net/sunrpc/auth.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/sunrpc/auth.c b/net/sunrpc/auth.c
index ed2fdd2..cba5529 100644
--- a/net/sunrpc/auth.c
+++ b/net/sunrpc/auth.c
@@ -767,11 +767,12 @@ void
 rpcauth_invalcred(struct rpc_task *task)
 {
 	struct rpc_cred *cred = task->tk_rqstp->rq_cred;
+	if (!cred)
+		return;

 	dprintk("RPC: %5u invalidating %s cred %p\n",
 		task->tk_pid, cred->cr_auth->au_ops->au_name, cred);
-	if (cred)
-		clear_bit(RPCAUTH_CRED_UPTODATE, &cred->cr_flags);
+	clear_bit(RPCAUTH_CRED_UPTODATE, &cred->cr_flags);
 }

 int
-- 
1.8.1.5
