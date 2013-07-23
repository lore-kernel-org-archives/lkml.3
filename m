Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933349Ab3GWPsc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 11:48:32 -0400
Received: from e06smtp18.uk.ibm.com ([195.75.94.114]:41695 "EHLO
	e06smtp18.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933252Ab3GWPsH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 11:48:07 -0400
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>, Vivek Goyal <vgoyal@redhat.com>
Cc: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>,
        Jan Willeke <willeke@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        linux-kernel@vger.kernel.org, kexec@lists.infradead.org
Subject: [PATCH v8 5/6] vmcore: Enable /proc/vmcore mmap for s390
Date: Tue, 23 Jul 2013 17:47:58 +0200
Message-Id: <1374594479-64671-6-git-send-email-holzheu@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.2.3
In-Reply-To: <1374594479-64671-1-git-send-email-holzheu@linux.vnet.ibm.com>
References: <1374594479-64671-1-git-send-email-holzheu@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13072315-6892-0000-0000-000005C365FA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch "s390/vmcore: Implement remap_oldmem_pfn_range for s390" allows
now to use mmap also on s390.

So enable mmap for s390 again.

Signed-off-by: Michael Holzheu <holzheu@linux.vnet.ibm.com>
---
 fs/proc/vmcore.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/proc/vmcore.c b/fs/proc/vmcore.c
index 3f6cf0e..532808e 100644
--- a/fs/proc/vmcore.c
+++ b/fs/proc/vmcore.c
@@ -327,7 +327,7 @@ static inline char *alloc_elfnotes_buf(size_t notes_sz)
  * regions in the 1st kernel pointed to by PT_LOAD entries) into
  * virtually contiguous user-space in ELF layout.
  */
-#if defined(CONFIG_MMU) && !defined(CONFIG_S390)
+#ifdef CONFIG_MMU
 static int mmap_vmcore(struct file *file, struct vm_area_struct *vma)
 {
 	size_t size = vma->vm_end - vma->vm_start;
-- 
1.8.2.3

