Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753673AbbAJQ7j (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2015 11:59:39 -0500
Received: from mail-wi0-f170.google.com ([209.85.212.170]:52551 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752686AbbAJQ7i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2015 11:59:38 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: "J. Bruce Fields" <bfields@fieldses.org>,
        Trond Myklebust <trond.myklebust@primarydata.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] lockd: xdr: Remove unused function
Date: Sat, 10 Jan 2015 18:02:42 +0100
Message-Id: <1420909362-31705-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the function nlm_encode_fh() that is not used anywhere.

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 fs/lockd/xdr.c |    8 --------
 1 file changed, 8 deletions(-)

diff --git a/fs/lockd/xdr.c b/fs/lockd/xdr.c
index 9340e7e..5b651da 100644
--- a/fs/lockd/xdr.c
+++ b/fs/lockd/xdr.c
@@ -95,14 +95,6 @@ nlm_decode_fh(__be32 *p, struct nfs_fh *f)
 	return p + XDR_QUADLEN(NFS2_FHSIZE);
 }
 
-static inline __be32 *
-nlm_encode_fh(__be32 *p, struct nfs_fh *f)
-{
-	*p++ = htonl(NFS2_FHSIZE);
-	memcpy(p, f->data, NFS2_FHSIZE);
-	return p + XDR_QUADLEN(NFS2_FHSIZE);
-}
-
 /*
  * Encode and decode owner handle
  */
-- 
1.7.10.4

