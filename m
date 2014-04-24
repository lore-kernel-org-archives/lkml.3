Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754276AbaDXIyM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 04:54:12 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:46680 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754212AbaDXIyG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 04:54:06 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Benny Halevy <bhalevy@primarydata.com>,
        "J. Bruce Fields" <bfields@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 091/182] nfsd4: buffer-length check for SUPPATTR_EXCLCREAT
Date: Thu, 24 Apr 2014 09:50:16 +0100
Message-Id: <1398329507-5911-92-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1398329507-5911-1-git-send-email-luis.henriques@canonical.com>
References: <1398329507-5911-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "J. Bruce Fields" <bfields@redhat.com>

commit de3997a7eeb9ea286b15879fdf8a95aae065b4f7 upstream.

This was an omission from 8c18f2052e756e7d5dea712fc6e7ed70c00e8a39
"nfsd41: SUPPATTR_EXCLCREAT attribute".

Cc: Benny Halevy <bhalevy@primarydata.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/nfsd/nfs4xdr.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index c6c727a13..7b87337 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -2500,6 +2500,8 @@ out_acl:
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

