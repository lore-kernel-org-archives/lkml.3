Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752683AbaI3HKr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 03:10:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57311 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752016AbaI3HKe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 03:10:34 -0400
From: Baoquan He <bhe@redhat.com>
To: hpa@zytor.com
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        x86@kernel.org, vgoyal@redhat.com, keescook@chromium.org,
        ak@linux.intel.com, ebiederm@xmission.com, kexec@lists.infradead.org,
        whissi@whissi.de, kumagai-atsushi@mxc.nes.nec.co.jp,
        Baoquan He <bhe@redhat.com>
Subject: [resend Patch v3 2/2] export the kernel image size KERNEL_IMAGE_SIZE
Date: Tue, 30 Sep 2014 15:08:16 +0800
Message-Id: <1412060896-1902-2-git-send-email-bhe@redhat.com>
In-Reply-To: <1412060896-1902-1-git-send-email-bhe@redhat.com>
References: <1412060896-1902-1-git-send-email-bhe@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now kaslr makes kernel image size changable, not the fixed size 512M.
So KERNEL_IMAGE_SIZE need be exported to VMCOREINFO, otherwise makedumfile
will crash.

Signed-off-by: Baoquan He <bhe@redhat.com>
Acked-by: Kees Cook <keescook@chromium.org>
Acked-by: Vivek Goyal <vgoyal@redhat.com>
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

