Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753456AbaIXBxu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 21:53:50 -0400
Received: from cnbjrel01.sonyericsson.com ([219.141.167.165]:16000 "EHLO
	cnbjrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751012AbaIXBxs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 21:53:48 -0400
From: "Wang, Yalin" <Yalin.Wang@sonymobile.com>
To: "'Sasha Levin'" <sasha.levin@oracle.com>, Minchan Kim <minchan@kernel.org>
CC: Michal Hocko <mhocko@suse.cz>, Hugh Dickins <hughd@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "'Russell King - ARM Linux'" <linux@arm.linux.org.uk>
Date: Wed, 24 Sep 2014 09:53:44 +0800
Subject: RE: Boot failure caused by "mm/cma.c: free the reserved memblock
 when free cma pages"
Thread-Topic: Boot failure caused by "mm/cma.c: free the reserved memblock
 when free cma pages"
Thread-Index: Ac/XgoRVqSoseRHqSmqzYzVNRf0S2wAFzDcQ
Message-ID: <35FD53F367049845BC99AC72306C23D103D6DB49162B@CNBJMBX05.corpusers.net>
References: <5421FC12.2020706@oracle.com>
In-Reply-To: <5421FC12.2020706@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s8O1rskR009563

Hi

Very„ÄÄstrange,
I test it on ARM„ÄÄarch,
It works well.

I think revert it is ok ,
I have a discussion with Russell,
His concern make sense,
Remove this patch is ok.
https://lkml.org/lkml/2014/9/18/171


the crash is interesting,
I will have a look.
Sorry for that ..

-----Original Message-----
From: Sasha Levin [mailto:sasha.levin@oracle.com] 
Sent: Wednesday, September 24, 2014 7:03 AM
To: Wang, Yalin; Minchan Kim
Cc: Michal Hocko; Hugh Dickins; Joonsoo Kim; Andrew Morton; LKML; linux-mm@kvack.org
Subject: Boot failure caused by "mm/cma.c: free the reserved memblock when free cma pages"

Hi Yalin,

I'm seeing the following BUG when booting the latest -next kernel. I've bisected it down to "mm/cma.c: free the reserved memblock when free cma pages".

[    2.438701] BUG: unable to handle kernel paging request at ffff880972493000
[    2.438701] IP: memblock_isolate_range (mm/memblock.c:624)
[    2.438701] PGD 34b51067 PUD 34b54067 PMD 976c56067 PTE 8000000972493060
[    2.438701] Oops: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
[    2.438701] Dumping ftrace buffer:
[    2.438701]    (ftrace buffer empty)
[    2.438701] Modules linked in:
[    2.438701] CPU: 17 PID: 1 Comm: swapper/0 Not tainted 3.17.0-rc6-next-20140923-sasha-00037-gc40eca4 #1213
[    2.438701] task: ffff88076d7d0000 ti: ffff880048d40000 task.ti: ffff880048d40000
[    2.438701] RIP: memblock_isolate_range (mm/memblock.c:624)
[    2.438701] RSP: 0000:ffff880048d43cf8  EFLAGS: 00010286
[    2.438828] RAX: ffff880972493000 RBX: 0000000962600000 RCX: ffff880048d43d50
[    2.439590] RDX: 0000000000200000 RSI: 0000000962400000 RDI: ffffffffb2fcaa30
[    2.440000] RBP: ffff880048d43d38 R08: ffff880048d43d54 R09: 0000000000000001
[    2.440000] R10: 0000000000000000 R11: 0000000000000001 R12: ffff880048d43d54
[    2.440000] R13: 0000000962400000 R14: 0000000000000000 R15: ffffffffb2fcaa30
[    2.440000] FS:  0000000000000000(0000) GS:ffff880567c00000(0000) knlGS:0000000000000000
[    2.440000] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[    2.440000] CR2: ffff880972493000 CR3: 0000000031e2f000 CR4: 00000000000006a0
[    2.440000] Stack:
[    2.440000]  ffffffffad29cda2 ffff880048d43d50 ffffea002eeb4000 0000000962400000
[    2.440000]  ffffffffb2fcaa30 0000000000000000 000000000000a000 ffffea002eeb4008
[    2.440000]  ffff880048d43d68 ffffffffb049e64a 0000000962400000 0000000000000000
[    2.440000] Call Trace:
[    2.440000] ? adjust_managed_page_count (mm/page_alloc.c:5430)
[    2.440000] memblock_remove_range (mm/memblock.c:672)
[    2.440000] memblock_free (mm/memblock.c:695)
[    2.440000] init_cma_reserved_pageblock (mm/page_alloc.c:840)
[    2.440000] cma_init_reserved_areas (mm/cma.c:118 mm/cma.c:133)
[    2.440000] ? kfree (mm/slub.c:2674 mm/slub.c:3339)
[    2.440000] ? early_memunmap (mm/cma.c:129)
[    2.440000] do_one_initcall (init/main.c:792)
[    2.440000] kernel_init_freeable (init/main.c:857 init/main.c:865 init/main.c:884 init/main.c:1005)
[    2.440000] ? rest_init (init/main.c:932)
[    2.440000] kernel_init (init/main.c:937)
[    2.440000] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[    2.440000] ? rest_init (init/main.c:932)
[ 2.440000] Code: 89 ff e8 ec fa ff ff 85 c0 79 e1 b8 f4 ff ff ff e9 c0 00 00 00 4c 01 eb 45 31 f6 49 63 c6 49 3b 07 73 b9 48 c1 e0 05 49 03 47 18 <48> 8b 10 48 8b 48 08 48 8d 34 11 48 39 d3 76 a1 49 39 f5 0f 83 All code ========
   0:	89 ff                	mov    %edi,%edi
   2:	e8 ec fa ff ff       	callq  0xfffffffffffffaf3
   7:	85 c0                	test   %eax,%eax
   9:	79 e1                	jns    0xffffffffffffffec
   b:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
  10:	e9 c0 00 00 00       	jmpq   0xd5
  15:	4c 01 eb             	add    %r13,%rbx
  18:	45 31 f6             	xor    %r14d,%r14d
  1b:	49 63 c6             	movslq %r14d,%rax
  1e:	49 3b 07             	cmp    (%r15),%rax
  21:	73 b9                	jae    0xffffffffffffffdc
  23:	48 c1 e0 05          	shl    $0x5,%rax
  27:	49 03 47 18          	add    0x18(%r15),%rax
  2b:*	48 8b 10             	mov    (%rax),%rdx		<-- trapping instruction
  2e:	48 8b 48 08          	mov    0x8(%rax),%rcx
  32:	48 8d 34 11          	lea    (%rcx,%rdx,1),%rsi
  36:	48 39 d3             	cmp    %rdx,%rbx
  39:	76 a1                	jbe    0xffffffffffffffdc
  3b:	49 39 f5             	cmp    %rsi,%r13
  3e:	0f                   	.byte 0xf
  3f:	83                   	.byte 0x83
	...

Code starting with the faulting instruction ===========================================
   0:	48 8b 10             	mov    (%rax),%rdx
   3:	48 8b 48 08          	mov    0x8(%rax),%rcx
   7:	48 8d 34 11          	lea    (%rcx,%rdx,1),%rsi
   b:	48 39 d3             	cmp    %rdx,%rbx
   e:	76 a1                	jbe    0xffffffffffffffb1
  10:	49 39 f5             	cmp    %rsi,%r13
  13:	0f                   	.byte 0xf
  14:	83                   	.byte 0x83
	...
[    2.440000] RIP memblock_isolate_range (mm/memblock.c:624)
[    2.440000]  RSP <ffff880048d43cf8>
[    2.440000] CR2: ffff880972493000


Thanks,
Sasha
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
