Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753748AbaJ0TEe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 15:04:34 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52871 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751982AbaJ0TEb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 15:04:31 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Olga Kornievskaia <kolga@netapp.com>,
        Trond Myklebust <trond.myklebust@primarydata.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 046/105] Fixing lease renewal
Date: Mon, 27 Oct 2014 11:56:21 -0700
Message-Id: <1414436240-13879-47-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1414436240-13879-1-git-send-email-kamal@canonical.com>
References: <1414436240-13879-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.10 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Olga Kornievskaia <kolga@netapp.com>

commit 8faaa6d5d48b201527e0451296d9e71d23afb362 upstream.

Commit c9fdeb28 removed a 'continue' after checking if the lease needs
to be renewed. However, if client hasn't moved, the code falls down to
starting reboot recovery erroneously (ie., sends open reclaim and gets
back stale_clientid error) before recovering from getting stale_clientid
on the renew operation.

Signed-off-by: Olga Kornievskaia <kolga@netapp.com>
Fixes: c9fdeb280b8c (NFS: Add basic migration support to state manager thread)
Signed-off-by: Trond Myklebust <trond.myklebust@primarydata.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 fs/nfs/nfs4state.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/nfs/nfs4state.c b/fs/nfs/nfs4state.c
index b3b8aea..5d02d74 100644
--- a/fs/nfs/nfs4state.c
+++ b/fs/nfs/nfs4state.c
@@ -2378,6 +2378,7 @@ static void nfs4_state_manager(struct nfs_client *clp)
 			status = nfs4_check_lease(clp);
 			if (status < 0)
 				goto out_error;
+			continue;
 		}
 
 		if (test_and_clear_bit(NFS4CLNT_MOVED, &clp->cl_state)) {
-- 
1.9.1

