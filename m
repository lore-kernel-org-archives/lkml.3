Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760715Ab3K0B7h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 20:59:37 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:38869 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756648Ab3K0A5H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 19:57:07 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Andy Adamson <andros@netapp.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [PATCH 3.10 15/80] SUNRPC: dont map EKEYEXPIRED to EACCES in call_refreshresult
Date: Tue, 26 Nov 2013 16:56:44 -0800
Message-Id: <20131127005642.001356799@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc3
In-Reply-To: <20131127005640.934155527@linuxfoundation.org>
References: <20131127005640.934155527@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Adamson <andros@netapp.com>

commit f1ff0c27fd9987c59d707cd1a6b6c1fc3ae0a250 upstream.

The NFS layer needs to know when a key has expired.
This change also returns -EKEYEXPIRED to the application, and the informative
"Key has expired" error message is displayed. The user then knows that
credential renewal is required.

Signed-off-by: Andy Adamson <andros@netapp.com>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/sunrpc/clnt.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/sunrpc/clnt.c
+++ b/net/sunrpc/clnt.c
@@ -1407,9 +1407,9 @@ call_refreshresult(struct rpc_task *task
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


