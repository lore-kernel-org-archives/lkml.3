Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755565AbaGENFq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2014 09:05:46 -0400
Received: from mout.gmx.net ([212.227.15.19]:63522 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754928AbaGENFp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2014 09:05:45 -0400
Message-ID: <53B7F823.4060004@gmx.de>
Date: Sat, 05 Jul 2014 15:05:39 +0200
From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>, linux-kernel@vger.kernel.org
Subject: Re: commit message 8a5b20aebaa3 refers to non-existing commit ?
References: <53B5CDDD.8000009@gmx.de> <alpine.DEB.2.02.1407031445390.10658@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.02.1407031445390.10658@chino.kir.corp.google.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K0:c3MIirKwKv2zxat9H+/O+7Kj1QRTpQCjfLMyWTQ8ZQ0cvpuTDXl
 j2hSrqdrNI1yrBu+wDS1ejxY722THSRYji26VRIxqIHO7xURU9pgFx6QlJtLLOU6x292C1m
 ZAJct4SXQ0xS3l4JYDzqdMVeut0mkuJihVsPZYkGbByUsF4Aj0OEJ6BhsxFqizCQTqDoptT
 INkZG7XmHzNVuaIKa6WXg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/03/2014 11:48 PM, David Rientjes wrote:
> On Thu, 3 Jul 2014, Toralf Förster wrote:
> 
>> in 
>> commit 8a5b20aebaa3d0ade5b8381e64d35fb777b7b355
>> Author: Joonsoo Kim <iamjoonsoo.kim@lge.com>
>> Date:   Wed Jul 2 15:22:35 2014 -0700
>>
>>     slub: fix off by one in number of slab tests
>>
>>
>> you stated:
>>
>>     Fixes 91cb69620284 ("slub: make dead memcg caches discard free slabs
>>     immediately").
>>
>>
>> which I cannot find in main line currently. Pls could you point me to that commit ?
>>
> 
> It hasn't been pushed to Linus yet, it's still sitting in the -mm tree:
> http://ozlabs.org/~akpm/mmotm/broken-out/slub-make-dead-memcg-caches-discard-free-slabs-immediately.patch
> 
> Not sure where the SHA1 came from, probably linux-next.  So the fix made 
> it to Linus before the offending commit, but the code is still correct.
> 
ah thx,

the reason I asked was that I (for a short time) I hoped that this commit would solve an issue at a 32 bit user mode linux (x86), which cored dumps since few weeks/months when fuzz-tested with trinity.
Unfortunately this is not the case. Although with this commit it needs much longer than before till the UML core dump happens (2-3 hours instead of about 30 minutes).

Just for completeness here is the back trace of the UML guest:

$> gdb /home/tfoerste/devel/linux/linux --core=/mnt/ramdisk/core -batch -ex 'thread apply all bt' 

Thread 1 (LWP 18431):
#0  0xb776eaec in __kernel_vsyscall ()
#1  0x08484ca5 in kill () at ../sysdeps/unix/syscall-template.S:81
#2  0x0807253d in uml_abort () at arch/um/os-Linux/util.c:93
#3  0x08072885 in os_dump_core () at arch/um/os-Linux/util.c:148
#4  0x0806241d in panic_exit (self=0x86c95c0 <panic_exit_notifier>, unused1=0, unused2=0x8700980 <buf.19750>) at arch/um/kernel/um_arch.c:240
#5  0x08099706 in notifier_call_chain (nl=0x0, val=1214151512, v=0x6, nr_to_call=-2, nr_calls=0x0) at kernel/notifier.c:93
#6  0x08099863 in __atomic_notifier_call_chain (nr_calls=<optimized out>, nr_to_call=<optimized out>, v=<optimized out>, val=<optimized out>, nh=<optimized out>) at kernel/notifier.c:183
#7  atomic_notifier_call_chain (nh=0x8700944 <panic_notifier_list>, val=0, v=0x8700980 <buf.19750>) at kernel/notifier.c:193
#8  0x084e02b4 in panic (fmt=0x0) at kernel/panic.c:133
#9  0x080cb905 in __delete_from_page_cache (page=0xa786fc0, shadow=0x0) at mm/filemap.c:202
#10 0x080cb9c3 in delete_from_page_cache (page=0xa786fc0) at mm/filemap.c:234
#11 0x080d6d67 in truncate_complete_page (page=<optimized out>, mapping=<optimized out>) at mm/truncate.c:145
#12 truncate_inode_page (mapping=0x487ab3b4, page=0xa786fc0) at mm/truncate.c:180
#13 0x080de257 in shmem_undo_range (inode=0x0, lstart=26983955288, lend=-1, unfalloc=false) at mm/shmem.c:430
#14 0x080de7dd in shmem_truncate_range (inode=0x487ab2fc, lstart=0, lend=5214741036428951552) at mm/shmem.c:527
#15 0x080de892 in shmem_evict_inode (inode=0x487ab2fc) at mm/shmem.c:571
#16 0x0811cebf in evict (inode=0x487ab2fc) at fs/inode.c:550
#17 0x0811d92d in iput_final (inode=<optimized out>) at fs/inode.c:1418
#18 iput (inode=0x487ab2fc) at fs/inode.c:1436
#19 0x08119898 in dentry_iput (dentry=<optimized out>) at fs/dcache.c:292
#20 __dentry_kill (dentry=0x4898d4d0) at fs/dcache.c:477
#21 0x0811a54c in dentry_kill (dentry=<optimized out>) at fs/dcache.c:521
#22 dput (dentry=0x4898d4d0) at fs/dcache.c:617
#23 0x08107265 in __fput (file=0x48664300) at fs/file_table.c:234
#24 0x081072bb in ____fput (work=0x48664300) at fs/file_table.c:252
#25 0x080930e6 in task_work_run () at kernel/task_work.c:123
#26 0x0805f8da in tracehook_notify_resume (regs=<optimized out>) at include/linux/tracehook.h:196
#27 interrupt_end () at arch/um/kernel/process.c:98
#28 0x08074409 in userspace (regs=0x4881c9e4) at arch/um/os-Linux/skas/process.c:459
#29 0x0805f6d0 in fork_handler () at arch/um/kernel/process.c:149
#30 0x00000000 in ?? ()

-- 
Toralf

