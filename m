Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932807AbaIEOKN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 10:10:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48631 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932790AbaIEOKL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 10:10:11 -0400
From: Baoquan He <bhe@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: ak@linux.intel.com, mingo@redhat.com, whissi@whissi.de, dyoung@redhat.com,
        tglx@linutronix.de, vgoyal@redhat.com, keescook@chromium.org,
        chaowang@redhat.com, Baoquan He <bhe@redhat.com>
Subject: [PATCH 4/4] export the kernel image size KERNEL_IMAGE_SIZE
Date: Fri,  5 Sep 2014 22:08:17 +0800
Message-Id: <1409926097-2101-5-git-send-email-bhe@redhat.com>
In-Reply-To: <1409926097-2101-1-git-send-email-bhe@redhat.com>
References: <1409926097-2101-1-git-send-email-bhe@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now kaslr makes kernel image size changable, not the fixed size 512M.
So KERNEL_IMAGE_SIZE need be exported to VMCOREINFO, otherwise makedumfile
will crash.

Signed-off-by: Baoquan He <bhe@redhat.com>
---
 kernel/kexec.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/kexec.c b/kernel/kexec.c
index 2bee072..bd680d3 100644
--- a/kernel/kexec.c
+++ b/kernel/kexec.c
@@ -2003,6 +2003,9 @@ static int __init crash_save_vmcoreinfo_init(void)
 #endif
 	VMCOREINFO_NUMBER(PG_head_mask);
 	VMCOREINFO_NUMBER(PAGE_BUDDY_MAPCOUNT_VALUE);
+#ifdef CONFIG_X86
+       VMCOREINFO_NUMBER(KERNEL_IMAGE_SIZE);
+#endif
 #ifdef CONFIG_HUGETLBFS
 	VMCOREINFO_SYMBOL(free_huge_page);
 #endif
-- 
1.8.5.3

