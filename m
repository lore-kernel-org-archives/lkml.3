Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755479AbaEDPsn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 11:48:43 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36840 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755042AbaEDPm4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 11:42:56 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "J. Bruce Fields" <bfields@redhat.com>
Subject: [PATCH 3.4 20/43] nfsd4: fix setclientid encode size
Date: Sun,  4 May 2014 11:42:14 -0400
Message-Id: <20140504154226.983719763@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140504154224.211508175@linuxfoundation.org>
References: <20140504154224.211508175@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "J. Bruce Fields" <bfields@redhat.com>

commit 480efaee085235bb848f1063f959bf144103c342 upstream.

Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfsd/nfs4proc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -1418,7 +1418,8 @@ static inline u32 nfsd4_setattr_rsize(st
 
 static inline u32 nfsd4_setclientid_rsize(struct svc_rqst *rqstp, struct nfsd4_op *op)
 {
-	return (op_encode_hdr_size + 2 + 1024) * sizeof(__be32);
+	return (op_encode_hdr_size + 2 + XDR_QUADLEN(NFS4_VERIFIER_SIZE)) *
+								sizeof(__be32);
 }
 
 static inline u32 nfsd4_write_rsize(struct svc_rqst *rqstp, struct nfsd4_op *op)


