Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758423AbaDVVBd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 17:01:33 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:36408 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755954AbaDVUVc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 16:21:32 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "J. Bruce Fields" <bfields@redhat.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 096/133] nfsd4: fix test_stateid error reply encoding
Date: Tue, 22 Apr 2014 13:13:54 -0700
Message-Id: <1398197671-12786-97-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1398197671-12786-1-git-send-email-kamal@canonical.com>
References: <1398197671-12786-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.22 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "J. Bruce Fields" <bfields@redhat.com>

commit a11fcce1544df08c723d950ff0edef3adac40405 upstream.

If the entire operation fails then there's nothing to encode.

Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 fs/nfsd/nfs4xdr.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index b2d4e3d..dc12d02 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -3414,6 +3414,9 @@ nfsd4_encode_test_stateid(struct nfsd4_compoundres *resp, __be32 nfserr,
 	struct nfsd4_test_stateid_id *stateid, *next;
 	__be32 *p;
 
+	if (nfserr)
+		return nfserr;
+
 	RESERVE_SPACE(4 + (4 * test_stateid->ts_num_ids));
 	*p++ = htonl(test_stateid->ts_num_ids);
 
-- 
1.9.1

