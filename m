Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934781AbaGRNMJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 09:12:09 -0400
Received: from bband-dyn38.178-41-141.t-com.sk ([178.41.141.38]:17604 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932307AbaGRNMF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 09:12:05 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Trond Myklebust <trond.myklebust@primarydata.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 034/170] pNFS: Handle allocation errors correctly in filelayout_alloc_layout_hdr()
Date: Fri, 18 Jul 2014 14:10:39 +0200
Message-Id: <803e56e270ff2d90a2bf144e9c5b237e83f9f341.1405685481.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
References: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
In-Reply-To: <cover.1405685481.git.jslaby@suse.cz>
References: <cover.1405685481.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Trond Myklebust <trond.myklebust@primarydata.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 6df200f5d5191bdde4d2e408215383890f956781 upstream.

Return the NULL pointer when the allocation fails.

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Trond Myklebust <trond.myklebust@primarydata.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 fs/nfs/nfs4filelayout.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nfs/nfs4filelayout.c b/fs/nfs/nfs4filelayout.c
index 394b0a0c54bf..3c27659aba7b 100644
--- a/fs/nfs/nfs4filelayout.c
+++ b/fs/nfs/nfs4filelayout.c
@@ -1330,7 +1330,7 @@ filelayout_alloc_layout_hdr(struct inode *inode, gfp_t gfp_flags)
 	struct nfs4_filelayout *flo;
 
 	flo = kzalloc(sizeof(*flo), gfp_flags);
-	return &flo->generic_hdr;
+	return flo != NULL ? &flo->generic_hdr : NULL;
 }
 
 static void
-- 
2.0.0

