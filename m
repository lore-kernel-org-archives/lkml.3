Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757195AbaDKMuY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 08:50:24 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:50656 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754438AbaDKMuU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 08:50:20 -0400
Message-ID: <5347E4FB.2090705@oracle.com>
Date: Fri, 11 Apr 2014 08:50:03 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: "linux-mm@kvack.org" <linux-mm@kvack.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Konstantin Khlebnikov <koct9i@gmail.com>, suresh.b.siddha@intel.com,
        Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>
Subject: mm,x86: warning at arch/x86/mm/pat.c:781 untrack_pfn+0x65/0xb0()
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

While fuzzing with trinity inside a KVM tools guest running the latest -next
kernel I've stumbled on the following:


[ 3431.738346] WARNING: CPU: 12 PID: 17371 at arch/x86/mm/pat.c:781 untrack_pfn+0x65/0xb0()
[ 3431.741153] Modules linked in:
[ 3431.742138] CPU: 12 PID: 17371 Comm: trinity-c361 Not tainted 3.14.0-next-20140410-sasha-00022-gb3d9015-dirty #390
[ 3431.745365]  0000000000000009 ffff8801b5635be8 ffffffffae51f40b 0000000000005b10
[ 3431.747699]  0000000000000000 ffff8801b5635c28 ffffffffab15a37c ffff8801b5635c38
[ 3431.750401]  ffff8802e8fd2e00 0000000000000000 ffff8801b5635d68 ffff8801b5635d68
[ 3431.752853] Call Trace:
[ 3431.753625] dump_stack (lib/dump_stack.c:52)
[ 3431.755244] warn_slowpath_common (kernel/panic.c:418)
[ 3431.757062] warn_slowpath_null (kernel/panic.c:453)
[ 3431.758828] untrack_pfn (arch/x86/mm/pat.c:781 (discriminator 3))
[ 3431.760785] unmap_single_vma (mm/memory.c:1316)
[ 3431.762703] ? sched_clock (arch/x86/include/asm/paravirt.h:192 arch/x86/kernel/tsc.c:305)
[ 3431.764366] ? sched_clock_local (kernel/sched/clock.c:214)
[ 3431.766253] ? move_page_tables (mm/mremap.c:156 mm/mremap.c:217)
[ 3431.768071] unmap_vmas (mm/memory.c:1366 (discriminator 1))
[ 3431.769686] unmap_region (mm/mmap.c:2361 (discriminator 3))
[ 3431.771776] ? validate_mm_rb (mm/mmap.c:401)
[ 3431.773606] ? vma_rb_erase (mm/mmap.c:446 include/linux/rbtree_augmented.h:219 include/linux/rbtree_augmented.h:227 mm/mmap.c:485)
[ 3431.775268] do_munmap (mm/mmap.c:3259 mm/mmap.c:2559)
[ 3431.777012] move_vma (mm/mremap.c:306)
[ 3431.778621] SyS_mremap (mm/mremap.c:439 mm/mremap.c:501 mm/mremap.c:470)
[ 3431.780576] tracesys (arch/x86/kernel/entry_64.S:749)


Thanks,
Sasha
