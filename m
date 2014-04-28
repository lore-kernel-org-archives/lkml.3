Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755600AbaD1BdQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 21:33:16 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:42851 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752464AbaD1B3U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 21:29:20 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "J. Bruce Fields" <bfields@redhat.com>
Date: Mon, 28 Apr 2014 02:11:22 +0100
Message-ID: <lsq.1398647482.134469391@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 67/94] nfsd4: fix setclientid encode size
In-Reply-To: <lsq.1398647481.453080089@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.58-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: "J. Bruce Fields" <bfields@redhat.com>

commit 480efaee085235bb848f1063f959bf144103c342 upstream.

Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/nfsd/nfs4proc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -1387,7 +1387,8 @@ static inline u32 nfsd4_setattr_rsize(st
 
 static inline u32 nfsd4_setclientid_rsize(struct svc_rqst *rqstp, struct nfsd4_op *op)
 {
-	return (op_encode_hdr_size + 2 + 1024) * sizeof(__be32);
+	return (op_encode_hdr_size + 2 + XDR_QUADLEN(NFS4_VERIFIER_SIZE)) *
+								sizeof(__be32);
 }
 
 static inline u32 nfsd4_write_rsize(struct svc_rqst *rqstp, struct nfsd4_op *op)

