Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754675AbaBJTwH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 14:52:07 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:35128 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754353AbaBJTrU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 14:47:20 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Andy Adamson <andros@netapp.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 029/124] SUNRPC: don't map EKEYEXPIRED to EACCES in call_refreshresult
Date: Mon, 10 Feb 2014 11:39:29 -0800
Message-Id: <1392061264-28124-30-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1392061264-28124-1-git-send-email-kamal@canonical.com>
References: <1392061264-28124-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.18 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Adamson <andros@netapp.com>

commit f1ff0c27fd9987c59d707cd1a6b6c1fc3ae0a250 upstream.

The NFS layer needs to know when a key has expired.
This change also returns -EKEYEXPIRED to the application, and the informative
"Key has expired" error message is displayed. The user then knows that
credential renewal is required.

Signed-off-by: Andy Adamson <andros@netapp.com>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/sunrpc/clnt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sunrpc/clnt.c b/net/sunrpc/clnt.c
index d8b6ad9..e1d98c8 100644
--- a/net/sunrpc/clnt.c
+++ b/net/sunrpc/clnt.c
@@ -1376,9 +1376,9 @@ call_refreshresult(struct rpc_task *task)
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

