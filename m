Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756987AbaFXUzp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 16:55:45 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:47534 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750925AbaFXUaf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 16:30:35 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Trond Myklebust <trond.myklebust@primarydata.com>,
        "J. Bruce Fields" <bfields@redhat.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 06/65] NFSd: call rpc_destroy_wait_queue() from free_client()
Date: Tue, 24 Jun 2014 13:29:26 -0700
Message-Id: <1403641825-12825-7-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403641825-12825-1-git-send-email-kamal@canonical.com>
References: <1403641825-12825-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.25 -stable review patch.  If anyone has any objections, please let me know.

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
index 1e7527a..b2142f9 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -1052,6 +1052,7 @@ free_client(struct nfs4_client *clp)
 		list_del(&ses->se_perclnt);
 		nfsd4_put_session_locked(ses);
 	}
+	rpc_destroy_wait_queue(&clp->cl_cb_waitq);
 	free_svc_cred(&clp->cl_cred);
 	kfree(clp->cl_name.data);
 	idr_remove_all(&clp->cl_stateids);
-- 
1.9.1

