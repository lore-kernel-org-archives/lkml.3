Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753124AbaFGBhj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 21:37:39 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:36034 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752608AbaFGBXh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 21:23:37 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Trond Myklebust" <trond.myklebust@primarydata.com>,
        "J. Bruce Fields" <bfields@redhat.com>
Date: Sat, 07 Jun 2014 02:26:29 +0100
Message-ID: <lsq.1402104389.309111302@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 57/92] NFSd: call rpc_destroy_wait_queue() from
 free_client()
In-Reply-To: <lsq.1402104388.385007124@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.60-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <trond.myklebust@primarydata.com>

commit 4cb57e3032d4e4bf5e97780e9907da7282b02b0c upstream.

Mainly to ensure that we don't leave any hanging timers.

Signed-off-by: Trond Myklebust <trond.myklebust@primarydata.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/nfsd/nfs4state.c | 1 +
 1 file changed, 1 insertion(+)

--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -1011,6 +1011,7 @@ free_client(struct nfs4_client *clp)
 		list_del(&ses->se_perclnt);
 		nfsd4_put_session(ses);
 	}
+	rpc_destroy_wait_queue(&clp->cl_cb_waitq);
 	if (clp->cl_cred.cr_group_info)
 		put_group_info(clp->cl_cred.cr_group_info);
 	kfree(clp->cl_principal);

