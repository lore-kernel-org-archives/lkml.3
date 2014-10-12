Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752486AbaJLDrB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2014 23:47:01 -0400
Received: from gproxy1-pub.mail.unifiedlayer.com ([69.89.25.95]:38940 "HELO
	gproxy1-pub.mail.unifiedlayer.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752288AbaJLDq6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2014 23:46:58 -0400
X-Authority-Analysis: v=2.1 cv=e5mVF8Z/ c=1 sm=1 tr=0
 a=yEjhGPV9XlbPNRGz7jjbow==:117 a=yEjhGPV9XlbPNRGz7jjbow==:17 a=DsvgjBjRAAAA:8
 a=f5113yIGAAAA:8 a=neHJxMmKCwgA:10 a=IkcTkHD0fZMA:10 a=wCmvBT1CAAAA:8
 a=djd9j7hWnewA:10 a=DpvdtwX123EA:10 a=FP58Ms26AAAA:8 a=Dahj-TVe2SCTPRODm9AA:9
 a=QEXdDO2ut3YA:10
Message-ID: <1413085598.2435.10.camel@slavad-ubuntu-14.04>
Subject: Re: hfsplus: invalid memory access in hfsplus_brec_lenoff
From: Vyacheslav Dubeyko <slava@dubeyko.com>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: akpm@linux-foundation.org, viro@zeniv.linux.org.uk, hch@infradead.org,
        fabf@skynet.be, sougata@tuxera.com, saproj@gmail.com,
        linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>
Date: Sat, 11 Oct 2014 20:46:38 -0700
In-Reply-To: <5439EFB9.60002@oracle.com>
References: <5439EFB9.60002@oracle.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Identified-User: {2172:host202.hostmonster.com:dubeykoc:dubeyko.com} {sentby:smtp auth 74.95.4.49 authed with slava@dubeyko.com}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2014-10-11 at 23:04 -0400, Sasha Levin wrote:
> Hi all,
> 
> While fuzzing with trinity inside a KVM tools guest running the latest -next
> kernel, I've stumbled on the following spew:
> 
> 
> [ 2435.025476] BUG: unable to handle kernel paging request at ffff88056730bfd4

Thank you. I guess that I know about such issue. Likewise issue was
reported by Luis G.F <luisgf@luisgf.es>. As far as I can judge, Hin-Tak
Leung <htl10@users.sourceforge.net> tried to discuss likewise issue many
times. Anyway, the reason of this issue is synchronization issue with
b-tree's nodes locking technique, from my point of view.

Unfortunately, I hadn't opportunity for this activity during last time.
I hope that I'll find time for this in the near future. But I can't
promise something definite.

Thanks,
Vyacheslav Dubeyko.

> [ 2435.033434] IP: memcpy (arch/x86/lib/memcpy_64.S:160)
> [ 2435.034378] PGD 145c3067 PUD a6e3e5067 PMD a6e2ab067 PTE 800000056730b060
> [ 2435.035052] Oops: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC KASAN
> [ 2435.035052] Dumping ftrace buffer:
> [ 2435.035052]    (ftrace buffer empty)
> [ 2435.035052] Modules linked in:
> [ 2435.035052] CPU: 24 PID: 26772 Comm: trinity-c611 Not tainted 3.17.0-next-20141010-sasha-00053-g16471e7-dirty #1379
> [ 2435.035052] task: ffff880226ec3000 ti: ffff88021a9c8000 task.ti: ffff88021a9c8000
> [ 2435.035052] RIP: memcpy (arch/x86/lib/memcpy_64.S:160)
> [ 2435.035052] RSP: 0018:ffff88021a9cb4d0  EFLAGS: 00010246
> [ 2435.035052] RAX: ffff88021a9cb544 RBX: 0000000000000004 RCX: ffff88056730bfd4
> [ 2435.035052] RDX: 0000000000000004 RSI: ffff88056730bfd4 RDI: ffff88021a9cb544
> [ 2435.035052] RBP: ffff88021a9cb528 R08: dfffe90000000001 R09: ffff88021a9cb547
> [ 2435.035052] R10: 1ffff100435396a8 R11: 1ffff100435396a8 R12: 0000000000000004
> [ 2435.035052] R13: ffff880630e8b560 R14: ffff88021a9cb544 R15: 0000000000000004
> [ 2435.035052] FS:  00007ff4c9a4d700(0000) GS:ffff88006dc00000(0000) knlGS:0000000000000000
> [ 2435.035052] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [ 2435.035052] CR2: ffff88056730bfd4 CR3: 000000024a2e6000 CR4: 00000000000006a0
> [ 2435.035052] Stack:
> [ 2435.035052]  ffffffff8b6c6897 ffff880000000000 cccccccccccccccd 0000160000000000
> [ 2435.035052]  ffff88056730bfd4 ffff88021a9cb518 ffff880630e8b4d0 ffff88021a9cb58a
> [ 2435.035052]  ffff88024f075668 0000000000000014 0000000000000003 ffff88021a9cb568
> [ 2435.035052] Call Trace:
> [ 2435.035052] hfsplus_brec_lenoff (include/uapi/linux/swab.h:49 fs/hfsplus/brec.c:26)
> [ 2435.035052] __hfsplus_brec_find (fs/hfsplus/bfind.c:130)
> [ 2435.035052] hfsplus_brec_find (fs/hfsplus/bfind.c:196)
> [ 2435.035052] hfsplus_brec_read (fs/hfsplus/bfind.c:224)
> [ 2435.035052] hfsplus_find_cat (fs/hfsplus/catalog.c:202)
> [ 2435.035052] hfsplus_iget (fs/hfsplus/super.c:79)
> [ 2435.035052] hfsplus_lookup (fs/hfsplus/dir.c:118)
> [ 2435.035052] lookup_real (fs/namei.c:1345)
> [ 2435.035052] __lookup_hash (fs/namei.c:1364)
> [ 2435.093450] walk_component (fs/namei.c:1471 fs/namei.c:1550)
> [ 2435.094918] path_lookupat (fs/namei.c:1925 fs/namei.c:1959)
> [ 2435.094918] filename_lookup (fs/namei.c:1998)
> [ 2435.094918] user_path_at_empty (fs/namei.c:2150)
> [ 2435.094918] user_path_at (fs/namei.c:2161)
> [ 2435.094918] SyS_chown (fs/open.c:606 fs/open.c:591 fs/open.c:625 fs/open.c:623)
> [ 2435.094918] tracesys_phase2 (arch/x86/kernel/entry_64.S:529)
> [ 2435.094918] Code: 89 5c 17 f8 c3 90 83 fa 08 72 1b 4c 8b 06 4c 8b 4c 16 f8 4c 89 07 4c 89 4c 17 f8 c3 66 2e 0f 1f 84 00 00 00 00 00 83 fa 04 72 1b <8b> 0e 44 8b 44 16 fc 89 0f 44 89 44 17 fc c3 66 66 66 2e 0f 1f
> All code
> ========
>    0:	89 5c 17 f8          	mov    %ebx,-0x8(%rdi,%rdx,1)
>    4:	c3                   	retq
>    5:	90                   	nop
>    6:	83 fa 08             	cmp    $0x8,%edx
>    9:	72 1b                	jb     0x26
>    b:	4c 8b 06             	mov    (%rsi),%r8
>    e:	4c 8b 4c 16 f8       	mov    -0x8(%rsi,%rdx,1),%r9
>   13:	4c 89 07             	mov    %r8,(%rdi)
>   16:	4c 89 4c 17 f8       	mov    %r9,-0x8(%rdi,%rdx,1)
>   1b:	c3                   	retq
>   1c:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
>   23:	00 00 00
>   26:	83 fa 04             	cmp    $0x4,%edx
>   29:	72 1b                	jb     0x46
>   2b:*	8b 0e                	mov    (%rsi),%ecx		<-- trapping instruction
>   2d:	44 8b 44 16 fc       	mov    -0x4(%rsi,%rdx,1),%r8d
>   32:	89 0f                	mov    %ecx,(%rdi)
>   34:	44 89 44 17 fc       	mov    %r8d,-0x4(%rdi,%rdx,1)
>   39:	c3                   	retq
>   3a:	66 66 66 2e 0f 1f 00 	data32 data32 nopw %cs:(%rax)
> 
> Code starting with the faulting instruction
> ===========================================
>    0:	8b 0e                	mov    (%rsi),%ecx
>    2:	44 8b 44 16 fc       	mov    -0x4(%rsi,%rdx,1),%r8d
>    7:	89 0f                	mov    %ecx,(%rdi)
>    9:	44 89 44 17 fc       	mov    %r8d,-0x4(%rdi,%rdx,1)
>    e:	c3                   	retq
>    f:	66 66 66 2e 0f 1f 00 	data32 data32 nopw %cs:(%rax)
> [ 2435.094918] RIP memcpy (arch/x86/lib/memcpy_64.S:160)
> [ 2435.094918]  RSP <ffff88021a9cb4d0>
> [ 2435.094918] CR2: ffff88056730bfd4
> 
> 
> Thanks,
> Sasha


