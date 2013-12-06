Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162313Ab3LFNRH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 08:17:07 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44644 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161981Ab3LFNEi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 08:04:38 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Weston Andros Adamson <dros@netapp.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 228/272] NFSv4: don't fail on missing fattr in open recover
Date: Fri,  6 Dec 2013 12:58:37 +0000
Message-Id: <1386334761-25517-229-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
References: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Weston Andros Adamson <dros@netapp.com>

commit a43ec98b72aae3e330f0673438f58316c3769b84 upstream.

This is an unneeded check that could cause the client to fail to recover
opens.

Signed-off-by: Weston Andros Adamson <dros@netapp.com>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/nfs/nfs4proc.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index c6dce26..84c6225 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -1236,12 +1236,6 @@ _nfs4_opendata_reclaim_to_nfs4_state(struct nfs4_opendata *data)
 		goto err;
 	}
 
-	ret = -ESTALE;
-	if (!(data->f_attr.valid & NFS_ATTR_FATTR_TYPE) ||
-	    !(data->f_attr.valid & NFS_ATTR_FATTR_FILEID) ||
-	    !(data->f_attr.valid & NFS_ATTR_FATTR_CHANGE))
-		goto err;
-
 	ret = -ENOMEM;
 	state = nfs4_get_open_state(inode, data->owner);
 	if (state == NULL)
-- 
1.8.3.2

