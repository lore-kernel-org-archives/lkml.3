Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759240AbaGOVcm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 17:32:42 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54028 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759198AbaGOVci (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 17:32:38 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "J. Bruce Fields" <bfields@redhat.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 111/198] nfsd4: fix FREE_STATEID lockowner leak
Date: Tue, 15 Jul 2014 14:29:41 -0700
Message-Id: <1405459868-15089-112-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405459868-15089-1-git-send-email-kamal@canonical.com>
References: <1405459868-15089-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "J. Bruce Fields" <bfields@redhat.com>

commit 48385408b45523d9a432c66292d47ef43efcbb94 upstream.

27b11428b7de ("nfsd4: remove lockowner when removing lock stateid")
introduced a memory leak.

Reported-by: Jeff Layton <jeff.layton@primarydata.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 fs/nfsd/nfs4state.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index 63b6cdc..025cd8e8d 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -3713,7 +3713,7 @@ nfsd4_free_lock_stateid(struct nfs4_ol_stateid *stp)
 	 * correspondance, and we have to delete the lockowner when we
 	 * delete the lock stateid:
 	 */
-	unhash_lockowner(lo);
+	release_lockowner(lo);
 	return nfs_ok;
 }
 
-- 
1.9.1

