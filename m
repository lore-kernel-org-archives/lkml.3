Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751998Ab3LKOlI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 09:41:08 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:49857 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751763Ab3LKOlH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 09:41:07 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: Matt Wilson <msw@amazon.com>
Cc: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Anthony Liguori <aliguori@amazon.com>, xen-devel@lists.xenproject.org,
        linux-kernel@vger.kernel.org,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Luis Henriques <luis.henriques@canonical.com>,
        kernel-team@lists.ubuntu.com
Subject: [3.11.y.z extended stable] Patch "xen/gnttab: leave lazy MMU mode in the case of a m2p override failure" has been added to staging queue
Date: Wed, 11 Dec 2013 14:40:59 +0000
Message-Id: <1386772859-9619-1-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a note to let you know that I have just added a patch titled

    xen/gnttab: leave lazy MMU mode in the case of a m2p override failure

to the linux-3.11.y-queue branch of the 3.11.y.z extended stable tree 
which can be found at:

 http://kernel.ubuntu.com/git?p=ubuntu/linux.git;a=shortlog;h=refs/heads/linux-3.11.y-queue

If you, or anyone else, feels it should not be added to this tree, please 
reply to this email.

For more information about the 3.11.y.z tree, see
https://wiki.ubuntu.com/Kernel/Dev/ExtendedStable

Thanks.
-Luis

------

>From 2dd09d40574a72d3dc150e56e5c4592857b4c070 Mon Sep 17 00:00:00 2001
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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/xen/grant-table.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/xen/grant-table.c b/drivers/xen/grant-table.c
index c4d2298..255e828 100644
--- a/drivers/xen/grant-table.c
+++ b/drivers/xen/grant-table.c
@@ -921,9 +921,10 @@ int gnttab_map_refs(struct gnttab_map_grant_ref *map_ops,
 		ret = m2p_add_override(mfn, pages[i], kmap_ops ?
 				       &kmap_ops[i] : NULL);
 		if (ret)
-			return ret;
+			goto out;
 	}

+ out:
 	if (lazy)
 		arch_leave_lazy_mmu_mode();

@@ -954,9 +955,10 @@ int gnttab_unmap_refs(struct gnttab_unmap_grant_ref *unmap_ops,
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

