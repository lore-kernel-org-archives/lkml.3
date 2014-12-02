Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934009AbaLBTs4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 14:48:56 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:46654 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933262AbaLBTXK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 14:23:10 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Trond Myklebust <trond.myklebust@primarydata.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13.y-ckt 080/121] NFS: Don't try to reclaim delegation open state if recovery failed
Date: Tue,  2 Dec 2014 11:19:19 -0800
Message-Id: <1417548000-1794-81-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417548000-1794-1-git-send-email-kamal@canonical.com>
References: <1417548000-1794-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11-ckt12 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <trond.myklebust@primarydata.com>

commit f8ebf7a8ca35dde321f0cd385fee6f1950609367 upstream.

If state recovery failed, then we should not attempt to reclaim delegated
state.

http://lkml.kernel.org/r/CAN-5tyHwG=Cn2Q9KsHWadewjpTTy_K26ee+UnSvHvG4192p-Xw@mail.gmail.com
Signed-off-by: Trond Myklebust <trond.myklebust@primarydata.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 fs/nfs/delegation.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/nfs/delegation.c b/fs/nfs/delegation.c
index 2897534..3ed1be9 100644
--- a/fs/nfs/delegation.c
+++ b/fs/nfs/delegation.c
@@ -109,6 +109,8 @@ again:
 			continue;
 		if (!test_bit(NFS_DELEGATED_STATE, &state->flags))
 			continue;
+		if (!nfs4_valid_open_stateid(state))
+			continue;
 		if (!nfs4_stateid_match(&state->stateid, stateid))
 			continue;
 		get_nfs_open_context(ctx);
-- 
1.9.1

