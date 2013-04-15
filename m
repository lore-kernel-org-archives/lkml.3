Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934262Ab3DOMvv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 08:51:51 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:31290 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933036Ab3DOMvs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 08:51:48 -0400
From: Libin <huawei.libin@huawei.com>
To: Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        David Airlie <airlied@linux.ie>, Bjorn Helgaas <bhelgaas@google.com>,
        "Hans J. Koch" <hjk@hansjkoch.de>,
        Petr Vandrovec <petr@vandrovec.name>,
        Andrew Morton <akpm@linux-foundation.org>
CC: Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Dave Airlie <airlied@redhat.com>,
        Nadia Yvette Chambers <nyc@holomorphy.com>,
        Jiri Kosina <jkosina@suse.cz>, Al Viro <viro@zeniv.linux.org.uk>,
        Mel Gorman <mgorman@suse.de>, Hugh Dickins <hughd@google.com>,
        Rik van Riel <riel@redhat.com>, David Rientjes <rientjes@google.com>,
        Michel Lespinasse <walken@google.com>, <linux-kernel@vger.kernel.org>,
        <dri-devel@lists.freedesktop.org>, <linux-pci@vger.kernel.org>,
        <linux-mm@kvack.org>, <guohanjun@huawei.com>, <wangyijing@huawei.com>
Subject: [PATCH 3/6] ncpfs: use vma_pages() to replace (vm_end - vm_start) >> PAGE_SHIFT
Date: Mon, 15 Apr 2013 20:48:55 +0800
Message-ID: <1366030138-71292-3-git-send-email-huawei.libin@huawei.com>
X-Mailer: git-send-email 1.8.1.msysgit.1
In-Reply-To: <1366030138-71292-1-git-send-email-huawei.libin@huawei.com>
References: <1366030138-71292-1-git-send-email-huawei.libin@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.135.74.57]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(*->vm_end - *->vm_start) >> PAGE_SHIFT operation is implemented
as a inline funcion vma_pages() in linux/mm.h, so using it.

Signed-off-by: Libin <huawei.libin@huawei.com>
---
 fs/ncpfs/mmap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ncpfs/mmap.c b/fs/ncpfs/mmap.c
index ee24df5..3c5dd55 100644
--- a/fs/ncpfs/mmap.c
+++ b/fs/ncpfs/mmap.c
@@ -117,7 +117,7 @@ int ncp_mmap(struct file *file, struct vm_area_struct *vma)
 		return -EINVAL;
 	/* we do not support files bigger than 4GB... We eventually 
 	   supports just 4GB... */
-	if (((vma->vm_end - vma->vm_start) >> PAGE_SHIFT) + vma->vm_pgoff 
+	if (vma_pages(vma) + vma->vm_pgoff
 	   > (1U << (32 - PAGE_SHIFT)))
 		return -EFBIG;
 
-- 
1.8.2.1


