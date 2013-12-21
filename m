Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752343Ab3LUAdV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 19:33:21 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:35663 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750895Ab3LUAdT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 19:33:19 -0500
Message-ID: <52B4E1C6.6070808@oracle.com>
Date: Fri, 20 Dec 2013 19:33:10 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Al Viro <viro@ZenIV.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: module: BUG in copy_module_from_fd
References: <52B4D581.40103@oracle.com>
In-Reply-To: <52B4D581.40103@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/20/2013 06:40 PM, Sasha Levin wrote:
> Hi all,
>
> While fuzzing with trinity inside a KVM tools guest running latest -next kernel, I've stumbled on
> the following spew.
>
> This reproduced twice with the same call trace, so I suspect it's something specific with the way
> the module subsystem calls vfs_getattr rather than something odd in vfs.

Sorry, forget that. Just got one that has nothing to do with modules:

BUG: unable to handle kernel paging request at ffff880429d40010
[ 2935.385056] IP: [<ffffffff812d792d>] generic_fillattr+0xd/0xa0
[ 2935.386268] PGD 857a067 PUD 857d067 PMD 42fe93067 PTE 8000000429d40060
[ 2935.387998] Oops: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
[ 2935.389936] Dumping ftrace buffer:
[ 2935.390321]    (ftrace buffer empty)
[ 2935.390321] Modules linked in:
[ 2935.390321] CPU: 22 PID: 57475 Comm: trinity-c598 Tainted: G        W    3.13.0-rc4-
next-20131220-sasha-00014-gd62f590-dirty #2
[ 2935.390321] task: ffff88005d880000 ti: ffff88004e3be000 task.ti: ffff88004e3be000
[ 2935.390321] RIP: 0010:[<ffffffff812d792d>]  [<ffffffff812d792d>] generic_fillattr+0x
d/0xa0
[ 2935.390321] RSP: 0018:ffff88004e3bfe58  EFLAGS: 00010246
[ 2935.390321] RAX: ffff880429d40000 RBX: ffff88015bf9e5d0 RCX: ffff88015b700a20
[ 2935.390321] RDX: 0000000000000000 RSI: ffff88004e3bfee8 RDI: ffff88042a078550
[ 2935.390321] RBP: ffff88004e3bfe58 R08: ffff88042a078550 R09: 0000000000000000
[ 2935.390321] R10: 0000000000000001 R11: 0000000000000000 R12: ffff88004e3bfee8
[ 2935.390321] R13: ffff88004e3bfee8 R14: 0000000000000000 R15: 0000000000000010
[ 2935.390321] FS:  00007ff7f4855700(0000) GS:ffff880161a00000(0000) knlGS:000000000000
0000
[ 2935.390321] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 2935.390321] CR2: ffff880429d40010 CR3: 0000000035487000 CR4: 00000000000006e0
[ 2935.390321] Stack:
[ 2935.390321]  ffff88004e3bfe68 ffffffff812d79f8 ffff88004e3bfe88 ffffffff812d7fe7
[ 2935.390321]  ffff88015bf9e5c0 0000000000000000 ffff88004e3bfed8 ffffffff812d81f2
[ 2935.390321]  ffff88004e3bfeb8 ffff88005d880000 ffffffff81249435 0000000000000256
[ 2935.390321] Call Trace:
[ 2935.390321]  [<ffffffff812d79f8>] vfs_getattr_nosec+0x38/0x40
[ 2935.390321]  [<ffffffff812d7fe7>] vfs_getattr+0x37/0x50
[ 2935.390321]  [<ffffffff812d81f2>] vfs_fstat+0x42/0x70
[ 2935.390321]  [<ffffffff81249435>] ? context_tracking_user_exit+0x195/0x1d0
[ 2935.390321]  [<ffffffff812d852f>] SYSC_newfstat+0x1f/0x40
[ 2935.390321]  [<ffffffff8119302d>] ? trace_hardirqs_on+0xd/0x10
[ 2935.390321]  [<ffffffff8107a852>] ? syscall_trace_enter+0x32/0x290
[ 2935.390321]  [<ffffffff843b5ef1>] ? tracesys+0x7e/0xe2
[ 2935.390321]  [<ffffffff812d855e>] SyS_newfstat+0xe/0x10
[ 2935.390321]  [<ffffffff843b5f50>] tracesys+0xdd/0xe2

Thanks,
Sasha
