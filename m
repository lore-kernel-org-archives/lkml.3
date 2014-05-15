Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755867AbaEOVz5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 17:55:57 -0400
Received: from mail-ee0-f53.google.com ([74.125.83.53]:62044 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752629AbaEOVzz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 17:55:55 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: "J. Bruce Fields" <bfields@fieldses.org>,
        Trond Myklebust <trond.myklebust@primarydata.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        "David S. Miller" <davem@davemloft.net>, linux-nfs@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: =?UTF-8?q?=5BPATCH=5D=20Fix=20for=20possible=20null=20pointer=20dereference=20in=20auth=2Ec?=
Date: Thu, 15 May 2014 23:56:38 +0200
Message-Id: <1400190998-28153-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is otherwise a risk of a possible null pointer dereference.

Was largely found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 net/sunrpc/auth.c |   10 +++++++---
 1 fil ändrad, 7 tillägg(+), 3 borttagningar(-)

diff --git a/net/sunrpc/auth.c b/net/sunrpc/auth.c
index 5285ead..3a55698 100644
--- a/net/sunrpc/auth.c
+++ b/net/sunrpc/auth.c
@@ -801,10 +801,14 @@ rpcauth_invalcred(struct rpc_task *task)
 {
 	struct rpc_cred *cred = task->tk_rqstp->rq_cred;
 
-	dprintk("RPC: %5u invalidating %s cred %p\n",
-		task->tk_pid, cred->cr_auth->au_ops->au_name, cred);
-	if (cred)
+	if (cred) {
+		dprintk("RPC: %5u invalidating %s cred %p\n",
+			task->tk_pid, cred->cr_auth->au_ops->au_name, cred);
+
 		clear_bit(RPCAUTH_CRED_UPTODATE, &cred->cr_flags);
+	}
+	else
+		dprintk("RPC: %5u invalidating is NULL\n", task->tk_pid);
 }
 
 int
-- 
1.7.10.4

