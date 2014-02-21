Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755819AbaBUWqm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 17:46:42 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:25754 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755674AbaBUWql (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 17:46:41 -0500
Message-ID: <5307D74C.5070002@oracle.com>
Date: Fri, 21 Feb 2014 17:46:36 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: "linux-mm@kvack.org" <linux-mm@kvack.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: mm:  kernel BUG at mm/huge_memory.c:1371!
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

While fuzzing with trinity inside a KVM tools guest running latest -next kernel I've stumbled on the 
following (now with pretty line numbers!) spew:

[  746.125099] kernel BUG at mm/huge_memory.c:1371!
[  746.125775] invalid opcode: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
[  746.126774] Dumping ftrace buffer:
[  746.127484]    (ftrace buffer empty)
[  746.127781] Modules linked in:
[  746.128358] CPU: 2 PID: 19816 Comm: trinity-c127 Tainted: G        W 
3.14.0-rc3-next-20140221-sasha-00008-g0e660cf-dirty #114
[  746.130196] task: ffff8803a7cc3000 ti: ffff8803a7f1c000 task.ti: ffff8803a7f1c000
[  746.130317] RIP: 0010:[<mm/huge_memory.c:1371>]  [<mm/huge_memory.c:1371>] zap_huge_pmd+0x17a/0x200
[  746.130317] RSP: 0018:ffff8803a7f1dca8  EFLAGS: 00010246
[  746.130317] RAX: ffff8801ab4ac000 RBX: ffff8803a7f1ddd8 RCX: 000000000000002e
[  746.130317] RDX: 0000000000000000 RSI: ffff8803a7cc3d00 RDI: 000000000172c000
[  746.130317] RBP: ffff8803a7f1dce8 R08: 0000000000000000 R09: 0000000000000000
[  746.130317] R10: 0000000000000001 R11: 0000000000000001 R12: ffffea0006a8fa00
[  746.130317] R13: ffffea0005cb0000 R14: 00007f784f800000 R15: 00007f785750bfff
[  746.130317] FS:  00007f785afbc700(0000) GS:ffff8801abc00000(0000) knlGS:0000000000000000
[  746.130317] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  746.130317] CR2: 0000000000000010 CR3: 00000003a9739000 CR4: 00000000000006e0
[  746.130317] DR0: 0000000000693000 DR1: 0000000000000000 DR2: 0000000000000000
[  746.130317] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000600
[  746.130317] Stack:
[  746.130317]  00000000000004de ffff8803a9777390 ffff8803a7f1dce8 ffff8803a2afd3e0
[  746.130317]  00007f784f800000 00007f785750c000 ffff8803a7f1ddd8 00007f785750bfff
[  746.130317]  ffff8803a7f1dd78 ffffffff81285536 00000000001d8500 00007f784fa00000
[  746.130317] Call Trace:
[  746.130317]  [<mm/memory.c:1231 mm/memory.c:1265 mm/memory.c:1290>] unmap_page_range+0x2c6/0x410
[  746.130317]  [<mm/memory.c:1338>] unmap_single_vma+0xf1/0x110
[  746.130317]  [<mm/memory.c:1390>] zap_page_range+0x121/0x170
[  746.130317]  [<mm/madvise.c:271 mm/madvise.c:371>] madvise_vma+0x180/0x1c0
[  746.130317]  [<mm/madvise.c:518 mm/madvise.c:448>] SyS_madvise+0x17e/0x250
[  746.130317]  [<arch/x86/kernel/entry_64.S:749>] tracesys+0xdd/0xe2
[  746.152464] Code: 00 eb fe 66 0f 1f 44 00 00 48 8b 03 f0 48 81 80 60 03 00 00 00 fe ff ff 49 8b 
45 00 f6 c4 40 75 18 31 f6 4c 89 ef e8 26 29 f9 ff <0f> 0b 0f 1f 40 00 eb fe 66 0f 1f 44 00 00 48 8b 
03 f0 48 ff 48
[  746.152464] RIP  [<mm/huge_memory.c:1371>] zap_huge_pmd+0x17a/0x200
[  746.152464]  RSP <ffff8803a7f1dca8>


Thanks,
Sasha
