Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757500Ab3LERjt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 12:39:49 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:38477 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933459Ab3LERiU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 12:38:20 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Andy Adamson <andros@netapp.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 87/90] SUNRPC: don't map EKEYEXPIRED to EACCES in call_refreshresult
Date: Thu,  5 Dec 2013 17:36:09 +0000
Message-Id: <1386264972-5399-88-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386264972-5399-1-git-send-email-luis.henriques@canonical.com>
References: <1386264972-5399-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.27 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Adamson <andros@netapp.com>

commit f1ff0c27fd9987c59d707cd1a6b6c1fc3ae0a250 upstream.

The NFS layer needs to know when a key has expired.
This change also returns -EKEYEXPIRED to the application, and the informative
"Key has expired" error message is displayed. The user then knows that
credential renewal is required.

Signed-off-by: Andy Adamson <andros@netapp.com>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/sunrpc/clnt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sunrpc/clnt.c b/net/sunrpc/clnt.c
index 3321e09..46b5fb6 100644
--- a/net/sunrpc/clnt.c
+++ b/net/sunrpc/clnt.c
@@ -1339,9 +1339,9 @@ call_refreshresult(struct rpc_task *task)
 		return;
 	case -ETIMEDOUT:
 		rpc_delay(task, 3*HZ);
-	case -EKEYEXPIRED:
 	case -EAGAIN:
 		status = -EACCES;
+	case -EKEYEXPIRED:
 		if (!task->tk_cred_retry)
 			break;
 		task->tk_cred_retry--;
-- 
1.8.3.2

