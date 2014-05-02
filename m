Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754227AbaEBP6G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 11:58:06 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44198 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752536AbaEBPpU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 11:45:20 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Benny Halevy <bhalevy@primarydata.com>,
        "J. Bruce Fields" <bfields@redhat.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 093/151] nfsd4: buffer-length check for SUPPATTR_EXCLCREAT
Date: Fri,  2 May 2014 08:38:01 -0700
Message-Id: <1399045139-4531-94-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1399045139-4531-1-git-send-email-kamal@canonical.com>
References: <1399045139-4531-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "J. Bruce Fields" <bfields@redhat.com>

commit de3997a7eeb9ea286b15879fdf8a95aae065b4f7 upstream.

This was an omission from 8c18f2052e756e7d5dea712fc6e7ed70c00e8a39
"nfsd41: SUPPATTR_EXCLCREAT attribute".

Cc: Benny Halevy <bhalevy@primarydata.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 fs/nfsd/nfs4xdr.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index ee7237f..86d8011 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -2517,6 +2517,8 @@ out_acl:
 			goto out;
 	}
 	if (bmval2 & FATTR4_WORD2_SUPPATTR_EXCLCREAT) {
+		if ((buflen -= 16) < 0)
+			goto out_resource;
 		WRITE32(3);
 		WRITE32(NFSD_SUPPATTR_EXCLCREAT_WORD0);
 		WRITE32(NFSD_SUPPATTR_EXCLCREAT_WORD1);
-- 
1.9.1

