Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752821AbaFGBXr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 21:23:47 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:35925 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752424AbaFGBXg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 21:23:36 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "J. Bruce Fields" <bfields@redhat.com>
Date: Sat, 07 Jun 2014 02:26:29 +0100
Message-ID: <lsq.1402104389.688083361@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 83/92] nfsd4: warn on finding lockowner without stateid's
In-Reply-To: <lsq.1402104388.385007124@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.60-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: "J. Bruce Fields" <bfields@redhat.com>

commit 27b11428b7de097c42f205beabb1764f4365443b upstream.

The current code assumes a one-to-one lockowner<->lock stateid
correspondance.

Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/nfsd/nfs4state.c | 4 ++++
 1 file changed, 4 insertions(+)

--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -3820,6 +3820,10 @@ static bool same_lockowner_ino(struct nf
 
 	if (!same_owner_str(&lo->lo_owner, owner, clid))
 		return false;
+	if (list_empty(&lo->lo_owner.so_stateids)) {
+		WARN_ON_ONCE(1);
+		return false;
+	}
 	lst = list_first_entry(&lo->lo_owner.so_stateids,
 			       struct nfs4_ol_stateid, st_perstateowner);
 	return lst->st_file->fi_inode == inode;

