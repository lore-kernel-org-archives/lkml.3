Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754084AbbALSKX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 13:10:23 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57793 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753884AbbALSGs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 13:06:48 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Benjamin Coddington <bcodding@redhat.com>,
        "J. Bruce Fields" <bfields@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 106/216] nfsd4: fix xdr4 count of server in fs_location4
Date: Mon, 12 Jan 2015 18:03:43 +0000
Message-Id: <1421085933-32536-107-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
References: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Coddington <bcodding@redhat.com>

commit bf7491f1be5e125eece2ec67e0f79d513caa6c7e upstream.

Fix a bug where nfsd4_encode_components_esc() incorrectly calculates the
length of server array in fs_location4--note that it is a count of the
number of array elements, not a length in bytes.

Signed-off-by: Benjamin Coddington <bcodding@redhat.com>
Fixes: 082d4bd72a45 (nfsd4: "backfill" using write_bytes_to_xdr_buf)
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/nfsd/nfs4xdr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index 69f15dc9e16b..dda2e4d91a25 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -1782,7 +1782,7 @@ static __be32 nfsd4_encode_components_esc(struct xdr_stream *xdr, char sep,
 
 		str = end;
 	}
-	pathlen = htonl(xdr->buf->len - pathlen_offset);
+	pathlen = htonl(count);
 	write_bytes_to_xdr_buf(xdr->buf, pathlen_offset, &pathlen, 4);
 	return 0;
 }
-- 
2.1.4

