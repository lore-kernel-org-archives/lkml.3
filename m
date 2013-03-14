Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757329Ab3CNLGS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 07:06:18 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51689 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756666Ab3CNKgq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 06:36:46 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jianpeng Ma <majianpeng@gmail.com>, "J. Bruce Fields" <bfields@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 02/88] nfsd: Fix memleak
Date: Thu, 14 Mar 2013 10:34:55 +0000
Message-Id: <1363257381-15900-3-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1363257381-15900-1-git-send-email-luis.henriques@canonical.com>
References: <1363257381-15900-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.8 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: majianpeng <majianpeng@gmail.com>

commit 2d32b29a1c2830f7c42caa8258c714acd983961f upstream.

When free nfs-client, it must free the ->cl_stateids.

Signed-off-by: Jianpeng Ma <majianpeng@gmail.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/nfsd/nfs4state.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index 6ca92b1..c4daf96 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -1090,6 +1090,8 @@ free_client(struct nfs4_client *clp)
 	}
 	free_svc_cred(&clp->cl_cred);
 	kfree(clp->cl_name.data);
+	idr_remove_all(&clp->cl_stateids);
+	idr_destroy(&clp->cl_stateids);
 	kfree(clp);
 }
 
-- 
1.8.1.2

