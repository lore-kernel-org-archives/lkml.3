Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934551Ab3DGX1y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Apr 2013 19:27:54 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46629 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757645Ab3DGX1v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Apr 2013 19:27:51 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Chuck Lever" <chuck.lever@oracle.com>,
        "Trond Myklebust" <Trond.Myklebust@netapp.com>
Date: Sun, 07 Apr 2013 23:45:42 +0100
Message-ID: <lsq.1365374742.174077105@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [50/74] NFS: nfs_getaclargs.acl_len is a size_t
In-Reply-To: <lsq.1365374742.214522651@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:b4b3:7e2a:e2d0:3478
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.43-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

commit 56d08fef2369d5ca9ad2e1fc697f5379fd8af751 upstream.

Squelch compiler warnings:

fs/nfs/nfs4proc.c: In function ‘__nfs4_get_acl_uncached’:
fs/nfs/nfs4proc.c:3811:14: warning: comparison between signed and
	unsigned integer expressions [-Wsign-compare]
fs/nfs/nfs4proc.c:3818:15: warning: comparison between signed and
	unsigned integer expressions [-Wsign-compare]

Introduced by commit bf118a34 "NFSv4: include bitmap in nfsv4 get
acl data", Dec 7, 2011.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/nfs/nfs4proc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -3578,7 +3578,8 @@ static ssize_t __nfs4_get_acl_uncached(s
 		.rpc_argp = &args,
 		.rpc_resp = &res,
 	};
-	int ret = -ENOMEM, npages, i, acl_len = 0;
+	int ret = -ENOMEM, npages, i;
+	size_t acl_len = 0;
 
 	npages = (buflen + PAGE_SIZE - 1) >> PAGE_SHIFT;
 	/* As long as we're doing a round trip to the server anyway,

