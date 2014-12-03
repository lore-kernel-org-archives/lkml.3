Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753359AbaLCLvF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 06:51:05 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54701 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752404AbaLCL1T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 06:27:19 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Trond Myklebust <trond.myklebust@primarydata.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 053/101] NFS: Don't try to reclaim delegation open state if recovery failed
Date: Wed,  3 Dec 2014 12:26:15 +0100
Message-Id: <a78d2dde1a6297c60901b287ccdb843d260f4483.1417605922.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <f9a3dbb8fd1853c16930b2c95eefa34a324eca19.1417605922.git.jslaby@suse.cz>
References: <f9a3dbb8fd1853c16930b2c95eefa34a324eca19.1417605922.git.jslaby@suse.cz>
In-Reply-To: <cover.1417605922.git.jslaby@suse.cz>
References: <cover.1417605922.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Trond Myklebust <trond.myklebust@primarydata.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit f8ebf7a8ca35dde321f0cd385fee6f1950609367 upstream.

If state recovery failed, then we should not attempt to reclaim delegated
state.

http://lkml.kernel.org/r/CAN-5tyHwG=Cn2Q9KsHWadewjpTTy_K26ee+UnSvHvG4192p-Xw@mail.gmail.com
Signed-off-by: Trond Myklebust <trond.myklebust@primarydata.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 fs/nfs/delegation.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/nfs/delegation.c b/fs/nfs/delegation.c
index 5d8ccecf5f5c..6acc11e6ebad 100644
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
2.1.3

