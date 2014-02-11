Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752805AbaBKWg1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 17:36:27 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41915 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751585AbaBKWg0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 17:36:26 -0500
Date: Tue, 11 Feb 2014 14:36:24 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Rashika Kheria <rashika.kheria@gmail.com>
Cc: linux-kernel@vger.kernel.org, Vivek Goyal <vgoyal@redhat.com>,
        Michael Holzheu <holzheu@linux.vnet.ibm.com>,
        James Hogan <james.hogan@imgtec.com>,
        Qais Yousef <qais.yousef@imgtec.com>, josh@joshtriplett.org
Subject: Re: [PATCH 21/21] fs: Move prototype declaration to appropriate
 header file
Message-Id: <20140211143624.277f72655ba9d0fe732fede9@linux-foundation.org>
In-Reply-To: <94bd5f839212612524d7b8dc2d6a6d4ed96b42da.1391952682.git.rashika.kheria@gmail.com>
References: <764a2eddc09cb8670d757cd4170d44d41b3971e0.1391949868.git.rashika.kheria@gmail.com>
	<94bd5f839212612524d7b8dc2d6a6d4ed96b42da.1391952682.git.rashika.kheria@gmail.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 9 Feb 2014 19:03:54 +0530 Rashika Kheria <rashika.kheria@gmail.com> wrote:

> Move prototype declaration to header file include/linux/crash_dump.h

It adds a prototype rather than moving it.

> because it is used by more than file.

True, but you didn't notice the second user ;)

> --- a/include/linux/crash_dump.h
> +++ b/include/linux/crash_dump.h
> @@ -25,6 +25,7 @@ extern int __weak remap_oldmem_pfn_range(struct vm_area_struct *vma,
>  
>  extern ssize_t copy_oldmem_page(unsigned long, char *, size_t,
>  						unsigned long, int);
> +void vmcore_cleanup(void);
>  
>  /* Architecture code defines this if there are other possible ELF
>   * machine types, e.g. on bi-arch capable hardware. */

Take a look over in powerpc...

From: Andrew Morton <akpm@linux-foundation.org>
Subject: include-linux-crash_dumph-add-vmcore_cleanup-prototype-fix

clean up powerpc, remove unneeded EXPORT_SYMBOL

Cc: Josh Triplett <josh@joshtriplett.org>
Cc: Rashika Kheria <rashika.kheria@gmail.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/include/asm/fadump.h |    1 -
 fs/proc/vmcore.c                  |    1 -
 2 files changed, 2 deletions(-)

--- a/arch/powerpc/include/asm/fadump.h~include-linux-crash_dumph-add-vmcore_cleanup-prototype-fix
+++ a/arch/powerpc/include/asm/fadump.h
@@ -210,7 +210,6 @@ extern int is_fadump_active(void);
 extern void crash_fadump(struct pt_regs *, const char *);
 extern void fadump_cleanup(void);
 
-extern void vmcore_cleanup(void);
 #else	/* CONFIG_FA_DUMP */
 static inline int is_fadump_active(void) { return 0; }
 static inline void crash_fadump(struct pt_regs *regs, const char *str) { }
--- a/fs/proc/vmcore.c~include-linux-crash_dumph-add-vmcore_cleanup-prototype-fix
+++ a/fs/proc/vmcore.c
@@ -1118,4 +1118,3 @@ void vmcore_cleanup(void)
 	}
 	free_elfcorebuf();
 }
-EXPORT_SYMBOL_GPL(vmcore_cleanup);
_

