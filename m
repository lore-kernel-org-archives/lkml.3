Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753738Ab3CAUML (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 15:12:11 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:51572 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753186Ab3CATps (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 14:45:48 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jianpeng Ma <majianpeng@gmail.com>,
        "J. Bruce Fields" <bfields@redhat.com>
Subject: [ 54/77] nfsd: Fix memleak
Date: Fri,  1 Mar 2013 11:44:39 -0800
Message-Id: <20130301194357.688809653@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130301194351.913471337@linuxfoundation.org>
References: <20130301194351.913471337@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: majianpeng <majianpeng@gmail.com>

commit 2d32b29a1c2830f7c42caa8258c714acd983961f upstream.

When free nfs-client, it must free the ->cl_stateids.

Signed-off-by: Jianpeng Ma <majianpeng@gmail.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfsd/nfs4state.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -1060,6 +1060,8 @@ free_client(struct nfs4_client *clp)
 	}
 	free_svc_cred(&clp->cl_cred);
 	kfree(clp->cl_name.data);
+	idr_remove_all(&clp->cl_stateids);
+	idr_destroy(&clp->cl_stateids);
 	kfree(clp);
 }
 


