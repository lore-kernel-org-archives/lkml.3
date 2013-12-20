Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753993Ab3LTUVQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 15:21:16 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:54840 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751832Ab3LTUVO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 15:21:14 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: Matt Wilson <msw@amazon.com>
Cc: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Anthony Liguori <aliguori@amazon.com>, xen-devel@lists.xenproject.org,
        linux-kernel@vger.kernel.org,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Kamal Mostafa <kamal@canonical.com>, kernel-team@lists.ubuntu.com
Subject: [3.8.y.z extended stable] Patch "xen/gnttab: leave lazy MMU mode in the case of a m2p override failure" has been added to staging queue
Date: Fri, 20 Dec 2013 12:21:07 -0800
Message-Id: <1387570867-19406-1-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a note to let you know that I have just added a patch titled

    xen/gnttab: leave lazy MMU mode in the case of a m2p override failure

to the linux-3.8.y-queue branch of the 3.8.y.z extended stable tree 
which can be found at:

 http://kernel.ubuntu.com/git?p=ubuntu/linux.git;a=shortlog;h=refs/heads/linux-3.8.y-queue

This patch is scheduled to be released in version 3.8.13.15.

If you, or anyone else, feels it should not be added to this tree, please 
reply to this email.

For more information about the 3.8.y.z tree, see
https://wiki.ubuntu.com/Kernel/Dev/ExtendedStable

Thanks.
-Kamal

------

>From f8fab7bbd1aa39a684fb212cd8721e8896e779f4 Mon Sep 17 00:00:00 2001
From: Matt Wilson <msw@amazon.com>
Date: Wed, 20 Nov 2013 12:11:35 -0800
Subject: xen/gnttab: leave lazy MMU mode in the case of a m2p override failure

commit 14883a75ec76b44759385fb12629f4a0f1aef4e3 upstream.

Commit f62805f1 introduced a bug where lazy MMU mode isn't exited if a
m2p_add/remove_override call fails.

Acked-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Reviewed-by: David Vrabel <david.vrabel@citrix.com>
Reviewed-by: Anthony Liguori <aliguori@amazon.com>
Cc: xen-devel@lists.xenproject.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Matt Wilson <msw@amazon.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/xen/grant-table.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/xen/grant-table.c b/drivers/xen/grant-table.c
index 51be226..b146bfd 100644
--- a/drivers/xen/grant-table.c
+++ b/drivers/xen/grant-table.c
@@ -920,9 +920,10 @@ int gnttab_map_refs(struct gnttab_map_grant_ref *map_ops,
 		ret = m2p_add_override(mfn, pages[i], kmap_ops ?
 				       &kmap_ops[i] : NULL);
 		if (ret)
-			return ret;
+			goto out;
 	}

+ out:
 	if (lazy)
 		arch_leave_lazy_mmu_mode();

@@ -953,9 +954,10 @@ int gnttab_unmap_refs(struct gnttab_unmap_grant_ref *unmap_ops,
 		ret = m2p_remove_override(pages[i], kmap_ops ?
 				       &kmap_ops[i] : NULL);
 		if (ret)
-			return ret;
+			goto out;
 	}

+ out:
 	if (lazy)
 		arch_leave_lazy_mmu_mode();

--
1.8.3.2

