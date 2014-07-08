Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755993AbaGHTVj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 15:21:39 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54236 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755732AbaGHTIm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 15:08:42 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Jeff Layton" <jeff.layton@primarydata.com>,
        "J. Bruce Fields" <bfields@redhat.com>
Date: Tue, 08 Jul 2014 20:01:50 +0100
Message-ID: <lsq.1404846110.613422491@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 070/125] nfsd4: fix FREE_STATEID lockowner leak
In-Reply-To: <lsq.1404846109.699842714@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.61-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: "J. Bruce Fields" <bfields@redhat.com>

commit 48385408b45523d9a432c66292d47ef43efcbb94 upstream.

27b11428b7de ("nfsd4: remove lockowner when removing lock stateid")
introduced a memory leak.

Reported-by: Jeff Layton <jeff.layton@primarydata.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/nfsd/nfs4state.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -3393,7 +3393,7 @@ nfsd4_free_lock_stateid(struct nfs4_ol_s
 	 * correspondance, and we have to delete the lockowner when we
 	 * delete the lock stateid:
 	 */
-	unhash_lockowner(lo);
+	release_lockowner(lo);
 	return nfs_ok;
 }
 

