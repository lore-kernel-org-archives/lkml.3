Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757496Ab3CDDo4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 22:44:56 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33188 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757442Ab3CDDox (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 22:44:53 -0500
Message-Id: <20130304033710.320592652@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 04 Mar 2013 03:37:35 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, majianpeng <majianpeng@gmail.com>,
        "J. Bruce Fields" <bfields@redhat.com>
Subject: [ 028/153] nfsd: Fix memleak
In-Reply-To: <20130304033707.648729212@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:a11:96ff:fec6:70c4
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: majianpeng <majianpeng@gmail.com>

commit 2d32b29a1c2830f7c42caa8258c714acd983961f upstream.

When free nfs-client, it must free the ->cl_stateids.

Signed-off-by: Jianpeng Ma <majianpeng@gmail.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/nfsd/nfs4state.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -1009,6 +1009,8 @@ free_client(struct nfs4_client *clp)
 		put_group_info(clp->cl_cred.cr_group_info);
 	kfree(clp->cl_principal);
 	kfree(clp->cl_name.data);
+	idr_remove_all(&clp->cl_stateids);
+	idr_destroy(&clp->cl_stateids);
 	kfree(clp);
 }
 


