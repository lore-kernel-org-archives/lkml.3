Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757466Ab3DWWRX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 18:17:23 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34022 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757425Ab3DWVwt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 17:52:49 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Rik van Riel <riel@redhat.com>, Michal Hocko <mhocko@suse.cz>,
        HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 10/42] fs/binfmt_elf.c: fix hugetlb memory check in vma_dump_size()
Date: Tue, 23 Apr 2013 14:52:08 -0700
Message-Id: <20130423215206.604858158@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130423215205.523980967@linuxfoundation.org>
References: <20130423215205.523980967@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>

commit 23d9e482136e31c9d287633a6e473daa172767c4 upstream.

Documentation/filesystems/proc.txt says about coredump_filter bitmask,

  Note bit 0-4 doesn't effect any hugetlb memory. hugetlb memory are only
  effected by bit 5-6.

However current code can go into the subsequent flag checks of bit 0-4
for vma(VM_HUGETLB). So this patch inserts 'return' and makes it work
as written in the document.

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Reviewed-by: Rik van Riel <riel@redhat.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Reviewed-by: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

---
 fs/binfmt_elf.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -1132,6 +1132,7 @@ static unsigned long vma_dump_size(struc
 			goto whole;
 		if (!(vma->vm_flags & VM_SHARED) && FILTER(HUGETLB_PRIVATE))
 			goto whole;
+		return 0;
 	}
 
 	/* Do not dump I/O mapped devices or special mappings */


