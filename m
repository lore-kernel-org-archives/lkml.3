Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966198AbaFQVsf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 17:48:35 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53997 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966159AbaFQVsa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 17:48:30 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Trond Myklebust <trond.myklebust@primarydata.com>,
        "J. Bruce Fields" <bfields@redhat.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 093/212] NFSd: call rpc_destroy_wait_queue() from free_client()
Date: Tue, 17 Jun 2014 14:43:07 -0700
Message-Id: <1403041506-13646-94-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403041506-13646-1-git-send-email-kamal@canonical.com>
References: <1403041506-13646-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <trond.myklebust@primarydata.com>

commit 4cb57e3032d4e4bf5e97780e9907da7282b02b0c upstream.

Mainly to ensure that we don't leave any hanging timers.

Signed-off-by: Trond Myklebust <trond.myklebust@primarydata.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 fs/nfsd/nfs4state.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index 3fcd3ba..c3f6fdc 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -1103,6 +1103,7 @@ free_client(struct nfs4_client *clp)
 		WARN_ON_ONCE(atomic_read(&ses->se_ref));
 		free_session(ses);
 	}
+	rpc_destroy_wait_queue(&clp->cl_cb_waitq);
 	free_svc_cred(&clp->cl_cred);
 	kfree(clp->cl_name.data);
 	idr_destroy(&clp->cl_stateids);
-- 
1.9.1

