Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932316Ab3APQmw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 11:42:52 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:36225 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932208Ab3APQEz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 11:04:55 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Yanchuan Nian <ycnian@gmail.com>, "J. Bruce Fields" <bfields@redhat.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 117/222] nfs: fix wrong object type in lockowner_slab
Date: Wed, 16 Jan 2013 13:55:17 -0200
Message-Id: <1358351822-7675-118-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yanchuan Nian <ycnian@gmail.com>

commit 3c40794b2dd0f355ef4e6bf8d85af5dcd7da7ece upstream.

The object type in the cache of lockowner_slab is wrong, and it is
better to fix it.

Signed-off-by: Yanchuan Nian <ycnian@gmail.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 fs/nfsd/nfs4state.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index 02ac082..6ca92b1 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -2331,7 +2331,7 @@ nfsd4_init_slabs(void)
 	if (openowner_slab == NULL)
 		goto out_nomem;
 	lockowner_slab = kmem_cache_create("nfsd4_lockowners",
-			sizeof(struct nfs4_openowner), 0, 0, NULL);
+			sizeof(struct nfs4_lockowner), 0, 0, NULL);
 	if (lockowner_slab == NULL)
 		goto out_nomem;
 	file_slab = kmem_cache_create("nfsd4_files",
-- 
1.7.9.5

