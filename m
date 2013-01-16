Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756816Ab3APRbz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 12:31:55 -0500
Received: from mail-bk0-f52.google.com ([209.85.214.52]:63590 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755426Ab3APRbx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 12:31:53 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1301161048120.4978@kaball.uk.xensource.com>
References: <1357260531-11115-1-git-send-email-yinghai@kernel.org>
	<alpine.DEB.2.02.1301151214480.4978@kaball.uk.xensource.com>
	<CAE9FiQV1uxeHDVMcgNij7qAta+r2A52Jqwzb32Y1qgM13jUOeQ@mail.gmail.com>
	<CAE9FiQVhk4jc5WaOC5b+dn6Jo1w7s01MUBL16P43tNxav4kJzA@mail.gmail.com>
	<alpine.DEB.2.02.1301161048120.4978@kaball.uk.xensource.com>
Date: Wed, 16 Jan 2013 09:31:51 -0800
X-Google-Sender-Auth: drt38vCb7DlmNjvt_xAcKtBt8M8
Message-ID: <CAE9FiQUYi_Bp2DW-G3Ht=Xz1rk+xks+NZe+-nAmvh4xR4dxVwA@mail.gmail.com>
Subject: Re: [PATCH v7u1 00/31] x86, boot, 64bit: Add support for loading
 ramdisk and bzImage above 4G
From: Yinghai Lu <yinghai@kernel.org>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, Jan Kiszka <jan.kiszka@web.de>,
        Jason Wessel <jason.wessel@windriver.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 16, 2013 at 3:32 AM, Stefano Stabellini
<stefano.stabellini@eu.citrix.com> wrote:
> On Tue, 15 Jan 2013, Yinghai Lu wrote:
>> On Tue, Jan 15, 2013 at 8:43 AM, Yinghai Lu <yinghai@kernel.org> wrote:
>> > On Tue, Jan 15, 2013 at 4:19 AM, Stefano Stabellini
>> > <stefano.stabellini@eu.citrix.com> wrote:
>> >>> could be found at:
>> >>>
>> >>>         git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-yinghai.git for-x86-boot
>> >>
>> >> I tried to boot this kernel as PV guest with 2GB of RAM, but
>> >> unfortunately it crashes early on at boot (earlyprintk=xen log
>> >> appended).
>> >>
>> >>
>> >>
>> >> mapping kernel into physical memory
>> >> about to get started...
>> >> [    0.000000] Initializing cgroup subsys cpuset
>> >> [    0.000000] Linux version 3.8.0-rc3+ (sstabellini@st22) (gcc version 4.4.5 (Debian 4.4.5-8) ) #4 SMP Tue Jan 15 12:11:59 UTC 2013
>> >> [    0.000000] Command line: root=/dev/xvda1 rw loglevel=9 debug console=hvc0 earlyprintk=xen
>> >> [    0.000000] ACPI in unprivileged domain disabled
>> >> [    0.000000] e820: BIOS-provided physical RAM map:
>> >> [    0.000000] Xen: [mem 0x0000000000000000-0x000000000009ffff] usable
>> >> [    0.000000] Xen: [mem 0x00000000000a0000-0x00000000000fffff] reserved
>> >> [    0.000000] Xen: [mem 0x0000000000100000-0x000000007fffffff] usable
>> >> [    0.000000] bootconsole [xenboot0] enabled
>> >> [    0.000000] NX (Execute Disable) protection: active
>> >> [    0.000000] DMI not present or invalid.
>> >> [    0.000000] e820: update [mem 0x00000000-0x0000ffff] usable ==> reserved
>> >> [    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
>> >> [    0.000000] No AGP bridge found
>> >> [    0.000000] e820: last_pfn = 0x80000 max_arch_pfn = 0x400000000
>> >> [    0.000000] Base memory trampoline at [ffff88000009a000] 9a000 size 24576
>> >> [    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
>> >> [    0.000000]  [mem 0x00000000-0x000fffff] page 4k
>> >> [    0.000000] init_memory_mapping: [mem 0x7fe00000-0x7fffffff]
>> >> [    0.000000]  [mem 0x7fe00000-0x7fffffff] page 4k
>> >> [    0.000000] BRK [0x023b8000, 0x023b8fff] PGTABLE
>> >> [    0.000000] BRK [0x023b9000, 0x023b9fff] PGTABLE
>> >> [    0.000000] init_memory_mapping: [mem 0x7c000000-0x7fdfffff]
>> >> [    0.000000]  [mem 0x7c000000-0x7fdfffff] page 4k
>> >> [    0.000000] BRK [0x023ba000, 0x023bafff] PGTABLE
>> >> [    0.000000] BRK [0x023bb000, 0x023bbfff] PGTABLE
>> >> [    0.000000] BRK [0x023bc000, 0x023bcfff] PGTABLE
>> >> [    0.000000] init_memory_mapping: [mem 0x00100000-0x7bffffff]
>> >> [    0.000000]  [mem 0x00100000-0x7bffffff] page 4k
>> >> (XEN) d15:v0: unhandled page fault (ec=0000)
>> >> (XEN) Pagetable walk from ffffea0000080330:
>> >> (XEN)  L4[0x1d4] = 0000000000000000 ffffffffffffffff
>> >> (XEN) domain_crash_sync called from entry.S
>> >> (XEN) Domain 15 (vcpu#0) crashed on cpu#3:
>> >> (XEN) ----[ Xen-4.3-unstable  x86_64  debug=y  Not tainted ]----
>> >
>> > ok, i think i know the cause for now,  will check if there is good way
>> > to fix it.
>>
>> Can you please test attached patch?
>
> Yes, this patch seems to fix the problem.
> I have also run the kernel with this patch as dom0 and PV domU with
> various memory configurations up to 8GB, and I have no errors to report.

Thanks a lot for testing all those conf out.

Hi, Peter,
this bug is in tip:x86/mm2 already, but looks like it is only triggered on with
one patch in for-x86-boot.
http://git.kernel.org/?p=linux/kernel/git/yinghai/linux-yinghai.git;a=commitdiff;h=af4f3bc044d1556f89bd488c7ea75e2a162bb273

rom af4f3bc044d1556f89bd488c7ea75e2a162bb273 Mon Sep 17 00:00:00 2001
From: Yinghai Lu <yinghai@kernel.org>
Date: Mon, 14 Jan 2013 21:11:05 -0800
Subject: [PATCH] x86, mm: Fix page table early allocation offset checking

During debugging loading kernel above 4G, found that one page is not used
in pre-allocated BRK area for early page allocation.

pgt_buf_top is address that can not be used, so should check if that new
end is above that top, otherwise last page will not be used.

Fix that checking and also add print out for allocation from pre-allocated
BRK area to catch possible bugs later.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/mm/init.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index 6f85de8..c4293cf 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -47,7 +47,7 @@ __ref void *alloc_low_pages(unsigned int num)
 						__GFP_ZERO, order);
 	}

-	if ((pgt_buf_end + num) >= pgt_buf_top) {
+	if ((pgt_buf_end + num) > pgt_buf_top) {
 		unsigned long ret;
 		if (min_pfn_mapped >= max_pfn_mapped)
 			panic("alloc_low_page: ran out of memory");
@@ -61,6 +61,8 @@ __ref void *alloc_low_pages(unsigned int num)
 	} else {
 		pfn = pgt_buf_end;
 		pgt_buf_end += num;
+		printk(KERN_DEBUG "BRK [%#010lx, %#010lx] PGTABLE\n",
+			pfn << PAGE_SHIFT, (pgt_buf_end << PAGE_SHIFT) - 1);
 	}

 	for (i = 0; i < num; i++) {
-- 
1.7.7.6


So we could
1. just put the fix as first one in for-x86-boot.
2. or fold uncovering patch and fix into x86/mm2, and I will send
patches again, and you rebase the whole tip:x86/mm2.

Please let me know which one you like.

Thanks

Yinghai
