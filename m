Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932210AbaFWN3C (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 09:29:02 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:36747 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753994AbaFWNDq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 09:03:46 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "J. Bruce Fields" <bfields@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 18/93] nfsd4: warn on finding lockowner without stateid's
Date: Mon, 23 Jun 2014 14:01:57 +0100
Message-Id: <1403528592-2163-19-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403528592-2163-1-git-send-email-luis.henriques@canonical.com>
References: <1403528592-2163-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.12 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "J. Bruce Fields" <bfields@redhat.com>

commit 27b11428b7de097c42f205beabb1764f4365443b upstream.

The current code assumes a one-to-one lockowner<->lock stateid
correspondance.

Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/nfsd/nfs4state.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index 4858accc4c33..85e3686f16fc 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -4149,6 +4149,10 @@ static bool same_lockowner_ino(struct nfs4_lockowner *lo, struct inode *inode, c
 
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

