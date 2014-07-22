Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932703AbaGVWXr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 18:23:47 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44515 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932634AbaGVWXn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 18:23:43 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Bin Wang <binw@marvell.com>,
        Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>,
        Norbert Ciosek <norbertciosek@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 085/116] Revert "uio: fix vma io range check in mmap"
Date: Tue, 22 Jul 2014 15:21:36 -0700
Message-Id: <1406067727-19683-86-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1406067727-19683-1-git-send-email-kamal@canonical.com>
References: <1406067727-19683-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.27 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit b29f680c4fe305902d02c1d5aa4968fe13a45fe6 upstream.

This reverts commit ddb09754e6c7239e302c7b675df9bbd415f8de5d.

Linus objected to this originally, I can see why it might be needed, but
given that no one spoke up defending this patch, I'm going to revert it.

If you have hardware that requires this change, please speak up in the
future and defend the patch.

Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Bin Wang <binw@marvell.com>
Cc: Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>
Cc: Norbert Ciosek <norbertciosek@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/uio/uio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/uio/uio.c b/drivers/uio/uio.c
index 354c095..9981b9b 100644
--- a/drivers/uio/uio.c
+++ b/drivers/uio/uio.c
@@ -657,7 +657,7 @@ static int uio_mmap_physical(struct vm_area_struct *vma)
 
 	if (mem->addr & ~PAGE_MASK)
 		return -ENODEV;
-	if (vma->vm_end - vma->vm_start > PAGE_ALIGN(mem->size))
+	if (vma->vm_end - vma->vm_start > mem->size)
 		return -EINVAL;
 
 	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
-- 
1.9.1

