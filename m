Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754952Ab3JJHQG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 03:16:06 -0400
Received: from mail.renton.name ([90.155.165.44]:60344 "EHLO
	beaver.old-horrors.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752192Ab3JJHQB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 03:16:01 -0400
Date: Thu, 10 Oct 2013 11:13:20 +0400
From: Alexey Vlasov <renton@renton.name>
To: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <bitbucket@online.de>, linux-kernel@vger.kernel.org
Subject: Re: Kernel migration eat CPUs
Message-ID: <20131010071320.GA13359@beaver>
References: <20130823151711.f4c1f596b4c7aa1eecccc9a6@linux-foundation.org>
 <20130825142837.GD31370@twins.programming.kicks-ass.net>
 <20130904185315.GB13294@beaver>
 <20130905111252.GA23362@gmail.com>
 <20130911151813.GH13294@beaver>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="Nq2Wo0NMKNjxTN9z"
Content-Disposition: inline
In-Reply-To: <20130911151813.GH13294@beaver>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Nq2Wo0NMKNjxTN9z
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi Ingo,

On Wed, Sep 11, 2013 at 07:18:14PM +0400, Alexey Vlasov wrote:
> On Thu, Sep 05, 2013 at 01:12:52PM +0200, Ingo Molnar wrote:
> > 
> > Could you try the latest -tip tree at:
> > 
> >    git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git
> > 
> > In particular this fix:
> > 
> >    5a8e01f8fa51 sched/cputime: Do not scale when utime == 0
> > 
> > Could perhaps fix the phantom CPU overhead you are seeing?
> 
> This kernel solved problems.
> Thank you.

One problem is solved, but there appeared another one. Now this kernel
began to crash.

Crashdump is in attachment.

-- 
BRGDS. Alexey Vlasov.

--Nq2Wo0NMKNjxTN9z
Content-Type: text/plain; charset=utf-8
Content-Disposition: attachment; filename="bug_kernel-git-tip.txt"

Oct  4 20:42:55 l25 [255033.586773] BUG: unable to handle kernel
Oct  4 20:42:55 l25 paging request
Oct  4 20:42:55 l25 at 0000000100000000
Oct  4 20:42:55 l25 [255033.594760] IP:
Oct  4 20:42:55 l25 [<ffffffff811235b1>] kmem_cache_alloc+0x51/0x120
Oct  4 20:42:55 l25 [255033.601622] PGD 199b953067
Oct  4 20:42:55 l25 PUD 0
Oct  4 20:42:55 l25
Oct  4 20:42:55 l25 [255033.605481] Oops: 0000 [#1]
Oct  4 20:42:55 l25 SMP
Oct  4 20:42:55 l25
Oct  4 20:42:55 l25 [255033.609249] Modules linked in:
Oct  4 20:42:55 l25 netconsole
Oct  4 20:42:55 l25 flashcache(O)
Oct  4 20:42:55 l25 x86_pkg_temp_thermal
Oct  4 20:42:55 l25
Oct  4 20:42:55 l25 [255033.617333] CPU: 13 PID: 21874 Comm: httpd Tainted: G          IO 3.11.0-1gb-cm-tr+ #1
Oct  4 20:42:55 l25 [255033.626297] Hardware name: Intel Corporation S2600WP/S2600WP, BIOS SE5C600.86B.01.06.0002.110120121539 11/01/2012
Oct  4 20:42:55 l25 [255033.637900] task: ffff880018108000 ti: ffff88003aafa000 task.ti: ffff88003aafa000
Oct  4 20:42:55 l25 [255033.646386] RIP: 0010:[<ffffffff811235b1>]
Oct  4 20:42:55 l25 [<ffffffff811235b1>] kmem_cache_alloc+0x51/0x120
Oct  4 20:42:55 l25 [255033.656009] RSP: 0018:ffff88003aafbe18  EFLAGS: 00010206
Oct  4 20:42:55 l25 [255033.662077] RAX: 0000000000000000 RBX: ffff880e6fac6d80 RCX: 0000000000000000
Oct  4 20:42:55 l25 [255033.670165] RDX: 000000000a4f5d48 RSI: 00000000000080d0 RDI: 0000000000015380
Oct  4 20:42:55 l25 [255033.678256] RBP: ffff88003aafbe58 R08: ffff881c3fcb5380 R09: ffffffff81179fdf
Oct  4 20:42:55 l25 [255033.686442] R10: 0000000001d26b20 R11: 0000000000000246 R12: ffff8813ef803800
Oct  4 20:42:55 l25 [255033.694705] R13: 0000000100000000 R14: ffff880018108000 R15: ffff88161f1eac00
Oct  4 20:42:55 l25 [255033.702968] FS:  00007f3d46edc740(0000) GS:ffff881c3fca0000(0000) knlGS:0000000000000000
Oct  4 20:42:55 l25 [255033.733352] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Oct  4 20:42:55 l25 [255033.739996] CR2: 0000000100000000 CR3: 0000001688961000 CR4: 00000000000407e0
Oct  4 20:42:55 l25 [255033.748263] Stack:
Oct  4 20:42:55 l25 [255033.750716]  0000000000000000
Oct  4 20:42:55 l25 000080d000000000
Oct  4 20:42:55 l25 0000000000000000
Oct  4 20:42:55 l25 ffff880e6fac6d80
Oct  4 20:42:55 l25
Oct  4 20:42:55 l25 [255033.759374]  ffff88003aafbec8
Oct  4 20:42:55 l25 ffff880e6fac6dc8
Oct  4 20:42:55 l25 ffff880018108000
Oct  4 20:42:55 l25 ffff88161f1eac00
Oct  4 20:42:55 l25
Oct  4 20:42:55 l25 [255033.768028]  ffff88003aafbe78
Oct  4 20:42:55 l25 ffffffff81179fdf
Oct  4 20:42:55 l25 0000000000000001
Oct  4 20:42:55 l25 ffff880e6fac6d80
Oct  4 20:42:55 l25
Oct  4 20:42:55 l25 [255033.776672] Call Trace:
Oct  4 20:42:55 l25 [255033.779612]  [<ffffffff81179fdf>] locks_alloc_lock+0x1f/0x70
Oct  4 20:42:55 l25 [255033.786139]  [<ffffffff8117a284>] flock_lock_file_wait+0x254/0x380
Oct  4 20:42:55 l25 [255033.793262]  [<ffffffff81123658>] ? kmem_cache_alloc+0xf8/0x120
Oct  4 20:42:55 l25 [255033.800085]  [<ffffffff8117b56b>] SyS_flock+0x1bb/0x1d0
Oct  4 20:42:55 l25 [255033.806145]  [<ffffffff81502482>] system_call_fastpath+0x16/0x1b
Oct  4 20:42:55 l25 [255033.813062] Code:
Oct  4 20:42:55 l25 03
Oct  4 20:42:55 l25 04
Oct  4 20:42:55 l25 25
Oct  4 20:42:55 l25 08
Oct  4 20:42:55 l25 cc
Oct  4 20:42:55 l25 00
Oct  4 20:42:55 l25 00
Oct  4 20:42:55 l25 49
Oct  4 20:42:55 l25 8b
Oct  4 20:42:55 l25 50
Oct  4 20:42:55 l25 08
Oct  4 20:42:55 l25 4d
Oct  4 20:42:55 l25 8b
Oct  4 20:42:55 l25 28
Oct  4 20:42:55 l25 49
Oct  4 20:42:55 l25 83
Oct  4 20:42:55 l25 78
Oct  4 20:42:55 l25 10
Oct  4 20:42:55 l25 00
Oct  4 20:42:55 l25 0f
Oct  4 20:42:55 l25 84
Oct  4 20:42:55 l25 be
Oct  4 20:42:55 l25 00
Oct  4 20:42:55 l25 00
Oct  4 20:42:55 l25 00
Oct  4 20:42:55 l25 4d
Oct  4 20:42:55 l25 85
Oct  4 20:42:55 l25 ed
Oct  4 20:42:55 l25 0f
Oct  4 20:42:55 l25 84
Oct  4 20:42:55 l25 b5
Oct  4 20:42:55 l25 00
Oct  4 20:42:55 l25 00
Oct  4 20:42:55 l25 00
Oct  4 20:42:55 l25 49
Oct  4 20:42:55 l25 63
Oct  4 20:42:55 l25 44
Oct  4 20:42:55 l25 24
Oct  4 20:42:55 l25 20
Oct  4 20:42:55 l25 49
Oct  4 20:42:55 l25 8b
Oct  4 20:42:55 l25 3c
Oct  4 20:42:55 l25 24
Oct  4 20:42:55 l25
Oct  4 20:42:55 l25 8b
Oct  4 20:42:55 l25 5c
Oct  4 20:42:55 l25 05
Oct  4 20:42:55 l25 00
Oct  4 20:42:55 l25 48
Oct  4 20:42:55 l25 8d
Oct  4 20:42:55 l25 4a
Oct  4 20:42:55 l25 01
Oct  4 20:42:55 l25 4c
Oct  4 20:42:55 l25 89
Oct  4 20:42:55 l25 e8
Oct  4 20:42:55 l25 65
Oct  4 20:42:55 l25 48
Oct  4 20:42:55 l25 0f
Oct  4 20:42:55 l25 c7
Oct  4 20:42:55 l25 0f
Oct  4 20:42:55 l25 0f
Oct  4 20:42:55 l25 94
Oct  4 20:42:55 l25 c0
Oct  4 20:42:55 l25 84
Oct  4 20:42:55 l25
Oct  4 20:42:55 l25 [255033.835977] RIP
Oct  4 20:42:55 l25 [<ffffffff811235b1>] kmem_cache_alloc+0x51/0x120
Oct  4 20:42:55 l25 [255033.843039]  RSP <ffff88003aafbe18>
Oct  4 20:42:55 l25 [255033.847166] CR2: 0000000100000000
Oct  4 20:42:55 l25 [255033.851756] ---[ end trace 74c79b3b05e82a8a ]---
Oct  4 20:42:55 l25 [255033.870833] BUG: unable to handle kernel paging request at 0000000100000000
Oct  4 20:42:55 l25 [255033.870842] IP: [<ffffffff8112247f>] __kmalloc+0x6f/0x170
Oct  4 20:42:55 l25 [255033.870844] PGD 199b953067 PUD 0
Oct  4 20:42:55 l25 [255033.870846] Oops: 0000 [#2] SMP
Oct  4 20:42:55 l25 [255033.870850] Modules linked in: netconsole flashcache(O) x86_pkg_temp_thermal
Oct  4 20:42:55 l25 [255033.870853] CPU: 13 PID: 16854 Comm: kworker/13:2 Tainted: G      D   IO 3.11.0-1gb-cm-tr+ #1
Oct  4 20:42:55 l25 [255033.870854] Hardware name: Intel Corporation S2600WP/S2600WP, BIOS SE5C600.86B.01.06.0002.110120121539 11/01/2012
Oct  4 20:42:55 l25 [255033.870860] Workqueue: xfs-log/dm-0 xfs_log_worker
Oct  4 20:42:55 l25 [255033.870861] task: ffff881c0df188f0 ti: ffff881206806000 task.ti: ffff881206806000
Oct  4 20:42:55 l25 [255033.870864] RIP: 0010:[<ffffffff8112247f>]  [<ffffffff8112247f>] __kmalloc+0x6f/0x170
Oct  4 20:42:55 l25 [255033.870865] RSP: 0018:ffff881206807c48  EFLAGS: 00010206
Oct  4 20:42:55 l25 [255033.870866] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000020
Oct  4 20:42:55 l25 [255033.870867] RDX: 000000000a4f5d48 RSI: 0000000000000000 RDI: 0000000000015380
Oct  4 20:42:55 l25 [255033.870868] RBP: ffff881206807c88 R08: ffff881c3fcb5380 R09: ffffffff811e1fbf
Oct  4 20:42:55 l25 [255033.870869] R10: 0000000000000000 R11: 0000000000005572 R12: ffff8813ef803800
Oct  4 20:42:55 l25 [255033.870870] R13: 0000000100000000 R14: 0000000000000098 R15: 0000000051eb851f
Oct  4 20:42:55 l25 [255033.870871] FS:  0000000000000000(0000) GS:ffff881c3fca0000(0000) knlGS:0000000000000000
Oct  4 20:42:55 l25 [255033.870873] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Oct  4 20:42:55 l25 [255033.870877] CR2: 0000000100000000 CR3: 0000001688961000 CR4: 00000000000407e0
Oct  4 20:42:55 l25 [255033.870886] Stack:
Oct  4 20:42:55 l25 [255033.870895]  0000000000000250 0000025000000050 ffff881c0e415980 0000000000000000
Oct  4 20:42:55 l25 [255033.870901]  0000000000000250 0000000000000098 0000000000000000 0000000051eb851f
Oct  4 20:42:55 l25 [255033.870907]  ffff881206807cc8 ffffffff811e1fbf 0000000000000009 ffff8808dfb7ee10
Oct  4 20:42:55 l25 [255033.870909] Call Trace:
Oct  4 20:42:55 l25 [255033.870917]  [<ffffffff811e1fbf>] kmem_alloc+0x6f/0xe0
Oct  4 20:42:55 l25 [255033.870921]  [<ffffffff8122ba6f>] xfs_log_commit_cil+0x10f/0x500
Oct  4 20:42:56 l25 [255033.870924]  [<ffffffff81226c21>] xfs_trans_commit+0x71/0x250
Oct  4 20:42:56 l25 [255033.870929]  [<ffffffff811d3051>] xfs_fs_log_dummy+0x61/0x90
Oct  4 20:42:56 l25 [255033.870931]  [<ffffffff81228d7b>] ? xfs_log_need_covered+0x9b/0xd0
Oct  4 20:42:56 l25 [255033.870933]  [<ffffffff8122a4a8>] xfs_log_worker+0x48/0x50
Oct  4 20:42:56 l25 [255033.870939]  [<ffffffff8105e291>] process_one_work+0x171/0x420
Oct  4 20:42:56 l25 [255033.870942]  [<ffffffff8105f396>] worker_thread+0x126/0x360
Oct  4 20:42:56 l25 [255033.870945]  [<ffffffff8105f270>] ? manage_workers.clone.19+0x270/0x270
Oct  4 20:42:56 l25 [255033.870949]  [<ffffffff810658ee>] kthread+0xce/0xe0
Oct  4 20:42:56 l25 [255033.870952]  [<ffffffff81065820>] ? __kthread_parkme+0x90/0x90
Oct  4 20:42:56 l25 [255033.870957]  [<ffffffff815023dc>] ret_from_fork+0x7c/0xb0
Oct  4 20:42:56 l25 [255033.870959]  [<ffffffff81065820>] ? __kthread_parkme+0x90/0x90
Oct  4 20:42:56 l25 [255033.870976] Code: 03 04 25 08 cc 00 00 49 8b 50 08 4d 8b 28 49 83 78 10 00 0f 84 d4 00 00 00 4d 85 ed 0f 84 cb 00 00 00 49 63 44 24 20 49 8b 3c 24 <49> 8b 5c 05 00 48 8d 4a 01 4c 89 e8 65 48 0f c7 0f 0f 94 c0 84
Oct  4 20:42:56 l25 [255033.870978] RIP  [<ffffffff8112247f>] __kmalloc+0x6f/0x170
Oct  4 20:42:56 l25 [255033.870979]  RSP <ffff881206807c48>
Oct  4 20:42:56 l25 [255033.870979] CR2: 0000000100000000
Oct  4 20:42:56 l25 [255033.870981] ---[ end trace 74c79b3b05e82a8b ]---
Oct  4 20:42:56 l25 [255033.879442] BUG: unable to handle kernel paging request at ffffffffffffffd8
Oct  4 20:42:56 l25 [255033.879448] IP: [<ffffffff81065c50>] kthread_data+0x10/0x20
Oct  4 20:42:56 l25 [255033.879451] PGD 1a0c067 PUD 1a0e067 PMD 0
Oct  4 20:42:56 l25 [255033.879454] Oops: 0000 [#3] SMP
Oct  4 20:42:56 l25 [255033.879458] Modules linked in: netconsole flashcache(O) x86_pkg_temp_thermal
Oct  4 20:42:56 l25 [255033.879461] CPU: 13 PID: 16854 Comm: kworker/13:2 Tainted: G      D   IO 3.11.0-1gb-cm-tr+ #1
Oct  4 20:42:56 l25 [255033.879463] Hardware name: Intel Corporation S2600WP/S2600WP, BIOS SE5C600.86B.01.06.0002.110120121539 11/01/2012
Oct  4 20:42:56 l25 [255033.879477] task: ffff881c0df188f0 ti: ffff881206806000 task.ti: ffff881206806000
Oct  4 20:42:56 l25 [255033.879482] RIP: 0010:[<ffffffff81065c50>]  [<ffffffff81065c50>] kthread_data+0x10/0x20
Oct  4 20:42:56 l25 [255033.879484] RSP: 0018:ffff881206807778  EFLAGS: 00010096
Oct  4 20:42:56 l25 [255033.879485] RAX: 0000000000000000 RBX: 000000000000000d RCX: ffffffffff48e500
Oct  4 20:42:56 l25 [255033.879487] RDX: ffff881c3fcb2700 RSI: 000000000000000d RDI: ffff881c0df188f0
Oct  4 20:42:56 l25 [255033.879488] RBP: ffff881206807778 R08: 00000000000000bd R09: ffffea004caae480
Oct  4 20:42:56 l25 [255033.879489] R10: ffffffff8127804b R11: 0000000000000000 R12: 000000000000000d
Oct  4 20:42:56 l25 [255033.879491] R13: ffff881c0df18dd0 R14: ffff8813d5590000 R15: 0000000000000000
Oct  4 20:42:56 l25 [255033.879493] FS:  0000000000000000(0000) GS:ffff881c3fca0000(0000) knlGS:0000000000000000
Oct  4 20:42:56 l25 [255033.879494] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Oct  4 20:42:56 l25 [255033.879496] CR2: 0000000000000028 CR3: 0000001688961000 CR4: 00000000000407e0
Oct  4 20:42:56 l25 [255033.879497] Stack:
Oct  4 20:42:56 l25 [255033.879503]  ffff8812068077a8 ffffffff8105f655 000000000000000d ffff881c0df18dd0
Oct  4 20:42:56 l25 [255033.879508]  ffff8812068077a8 ffff881c3fcb2700 ffff8812068078e8 ffffffff814fff88
Oct  4 20:42:56 l25 [255033.879514]  ffff881c0df188f0 0000000000012700 ffff881206807fd8 ffff881206806000
Oct  4 20:42:56 l25 [255033.879514] Call Trace:
Oct  4 20:42:56 l25 [255033.879521]  [<ffffffff8105f655>] wq_worker_sleeping+0x15/0xa0
Oct  4 20:42:56 l25 [255033.879529]  [<ffffffff814fff88>] __schedule+0x4f8/0x920
Oct  4 20:42:56 l25 [255033.879535]  [<ffffffff81265ce6>] ? put_io_context+0x86/0xc0
Oct  4 20:42:56 l25 [255033.879539]  [<ffffffff81265de2>] ? put_io_context_active+0xc2/0xf0
Oct  4 20:42:56 l25 [255033.879543]  [<ffffffff81500469>] schedule+0x29/0x70
Oct  4 20:42:56 l25 [255033.879550]  [<ffffffff81047b8d>] do_exit+0x6bd/0x9c0
Oct  4 20:42:56 l25 [255033.879556]  [<ffffffff81005e81>] oops_end+0x81/0xb0
Oct  4 20:42:56 l25 [255033.879574]  [<ffffffff81037daa>] no_context+0x12a/0x2e0
Oct  4 20:42:56 l25 [255033.879579]  [<ffffffff8103807d>] __bad_area_nosemaphore+0x11d/0x220
Oct  4 20:42:56 l25 [255033.879584]  [<ffffffff81038193>] bad_area_nosemaphore+0x13/0x20
Oct  4 20:42:56 l25 [255033.879588]  [<ffffffff8103874a>] __do_page_fault+0x2ea/0x490
Oct  4 20:42:56 l25 [255033.879593]  [<ffffffff8103892e>] do_page_fault+0xe/0x10
Oct  4 20:42:56 l25 [255033.879598]  [<ffffffff81501cb2>] page_fault+0x22/0x30
Oct  4 20:42:56 l25 [255033.879602]  [<ffffffff811e1fbf>] ? kmem_alloc+0x6f/0xe0
Oct  4 20:42:56 l25 [255033.879607]  [<ffffffff8112247f>] ? __kmalloc+0x6f/0x170
Oct  4 20:42:56 l25 [255033.879611]  [<ffffffff81122441>] ? __kmalloc+0x31/0x170
Oct  4 20:42:56 l25 [255033.879614]  [<ffffffff811e1fbf>] kmem_alloc+0x6f/0xe0
Oct  4 20:42:56 l25 [255033.879619]  [<ffffffff8122ba6f>] xfs_log_commit_cil+0x10f/0x500
Oct  4 20:42:56 l25 [255033.879623]  [<ffffffff81226c21>] xfs_trans_commit+0x71/0x250
Oct  4 20:42:56 l25 [255033.879627]  [<ffffffff811d3051>] xfs_fs_log_dummy+0x61/0x90
Oct  4 20:42:56 l25 [255033.879631]  [<ffffffff81228d7b>] ? xfs_log_need_covered+0x9b/0xd0
Oct  4 20:42:56 l25 [255033.879634]  [<ffffffff8122a4a8>] xfs_log_worker+0x48/0x50
Oct  4 20:42:56 l25 [255033.879639]  [<ffffffff8105e291>] process_one_work+0x171/0x420
Oct  4 20:42:56 l25 [255033.879643]  [<ffffffff8105f396>] worker_thread+0x126/0x360
Oct  4 20:42:56 l25 [255033.879648]  [<ffffffff8105f270>] ? manage_workers.clone.19+0x270/0x270
Oct  4 20:42:56 l25 [255033.879652]  [<ffffffff810658ee>] kthread+0xce/0xe0
Oct  4 20:42:56 l25 [255033.879656]  [<ffffffff81065820>] ? __kthread_parkme+0x90/0x90
Oct  4 20:42:56 l25 [255033.879659]  [<ffffffff815023dc>] ret_from_fork+0x7c/0xb0
Oct  4 20:42:56 l25 [255033.879663]  [<ffffffff81065820>] ? __kthread_parkme+0x90/0x90
Oct  4 20:42:56 l25 [255033.879690] Code: 88 04 00 00 48 8b 40 c8 c9 48 c1 e8 02 83 e0 01 c3 66 2e 0f 1f 84 00 00 00 00 00 55 48 89 e5 66 66 66 66 90 48 8b 87 88 04 00 00 <48> 8b 40 d8 c9 c3 66 2e 0f 1f 84 00 00 00 00 00 55 48 89 e5 48
Oct  4 20:42:56 l25 [255033.879693] RIP  [<ffffffff81065c50>] kthread_data+0x10/0x20
Oct  4 20:42:56 l25 [255033.879694]  RSP <ffff881206807778>
Oct  4 20:42:56 l25 [255033.879695] CR2: ffffffffffffffd8
Oct  4 20:42:56 l25 [255033.879697] ---[ end trace 74c79b3b05e82a8c ]---
Oct  4 20:42:56 l25 [255033.890764] Fixing recursive fault but reboot is needed!
Oct  4 20:43:15 l25 [255053.594096] Kernel panic - not syncing: Watchdog detected hard LOCKUP on cpu 13
Oct  4 20:43:16 l25 [255054.636585] Shutting down cpus with NMI

--Nq2Wo0NMKNjxTN9z--
