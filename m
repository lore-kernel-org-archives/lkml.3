Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966665AbaFQVun (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 17:50:43 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54412 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965250AbaFQVuf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 17:50:35 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "J. Bruce Fields" <bfields@redhat.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 158/212] nfsd4: warn on finding lockowner without stateid's
Date: Tue, 17 Jun 2014 14:44:12 -0700
Message-Id: <1403041506-13646-159-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403041506-13646-1-git-send-email-kamal@canonical.com>
References: <1403041506-13646-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "J. Bruce Fields" <bfields@redhat.com>

commit 27b11428b7de097c42f205beabb1764f4365443b upstream.

The current code assumes a one-to-one lockowner<->lock stateid
correspondance.

Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 fs/nfsd/nfs4state.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index f1fa0ec..63b6cdc 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -4153,6 +4153,10 @@ static bool same_lockowner_ino(struct nfs4_lockowner *lo, struct inode *inode, c
 
 	if (!same_owner_str(&lo->lo_owner, owner, clid))
 		return false;
+	if (list_empty(&lo->lo_owner.so_stateids)) {
+		WARN_ON_ONCE(1);
+		return false;
+	}
 	lst = list_first_entry(&lo->lo_owner.so_stateids,
 			       struct nfs4_ol_stateid, st_perstateowner);
 	return lst->st_file->fi_inode == inode;
-- 
1.9.1

