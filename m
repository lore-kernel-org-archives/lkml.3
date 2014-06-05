Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754570AbaFEFBu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 01:01:50 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43866 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752331AbaFEEUd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 00:20:33 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "J. Bruce Fields" <bfields@redhat.com>
Subject: [PATCH 3.4 066/214] nfsd4: warn on finding lockowner without stateids
Date: Wed,  4 Jun 2014 21:17:09 -0700
Message-Id: <20140605041648.385175038@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <20140605041639.638675216@linuxfoundation.org>
References: <20140605041639.638675216@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "J. Bruce Fields" <bfields@redhat.com>

commit 27b11428b7de097c42f205beabb1764f4365443b upstream.

The current code assumes a one-to-one lockowner<->lock stateid
correspondance.

Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfsd/nfs4state.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -3918,6 +3918,10 @@ static bool same_lockowner_ino(struct nf
 
 	if (!same_owner_str(&lo->lo_owner, owner, clid))
 		return false;
+	if (list_empty(&lo->lo_owner.so_stateids)) {
+		WARN_ON_ONCE(1);
+		return false;
+	}
 	lst = list_first_entry(&lo->lo_owner.so_stateids,
 			       struct nfs4_ol_stateid, st_perstateowner);
 	return lst->st_file->fi_inode == inode;


