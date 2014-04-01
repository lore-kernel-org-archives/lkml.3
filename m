Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751584AbaDANIW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 09:08:22 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:37788 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751291AbaDANIS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 09:08:18 -0400
Message-ID: <533ABA32.9080602@oracle.com>
Date: Tue, 01 Apr 2014 09:08:02 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>, Tejun Heo <tj@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: kernfs: trying to register non-static key in kernfs_iop_listxattr
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

While fuzzing with trinity inside a KVM tools guest running latest -next
kernel I've stumbled on the following:

[ 1316.776480] INFO: trying to register non-static key.
[ 1316.778981] the code is fine but needs lockdep annotation.
[ 1316.780364] turning off the locking correctness validator.
[ 1316.780364] CPU: 25 PID: 29352 Comm: trinity-c162 Not tainted 3.14.0-rc8-next-20140331-sasha-00013-g7a8780f #351
[ 1316.780364]  0000000000000000 ffff8805898cbc98 ffffffffbb4bc9a3 0000000000000000
[ 1316.780364]  ffffffffbf375390 ffff8805898cbd98 ffffffffb81c3942 ffff8806ac800a70
[ 1316.780364]  0000000000000000 0000000100000001[child40:30166] Chose rand_syscalls. ffff880600000000 ffffffffb8330371
[ 1316.780364] Call Trace:
[ 1316.780364] dump_stack (lib/dump_stack.c:52)
[ 1316.780364] __lock_acquire (kernel/locking/lockdep.c:743 kernel/locking/lockdep.c:3078)
[ 1316.780364] ? listxattr (fs/xattr.c:550)
[ 1316.792691] ? listxattr (fs/xattr.c:550)
[ 1316.792691] ? debug_smp_processor_id (lib/smp_processor_id.c:57)
[ 1316.792691] ? __slab_alloc (mm/slub.c:2385 (discriminator 2))
[ 1316.792691] ? __this_cpu_preempt_check (lib/smp_processor_id.c:63)
[ 1316.792691] ? trace_hardirqs_on_caller (kernel/locking/lockdep.c:2557 kernel/locking/lockdep.c:2599)
[ 1316.792691] lock_acquire (arch/x86/include/asm/current.h:14 kernel/locking/lockdep.c:3602)
[ 1316.792691] ? simple_xattr_list (fs/xattr.c:982)
[ 1316.797929] ? sched_clock (arch/x86/include/asm/paravirt.h:192 arch/x86/kernel/tsc.c:305)
[ 1316.797929] _raw_spin_lock (include/linux/spinlock_api_smp.h:143 kernel/locking/spinlock.c:151)
[ 1316.797929] ? simple_xattr_list (fs/xattr.c:982)
[ 1316.797929] simple_xattr_list (fs/xattr.c:982)
[ 1316.797929] kernfs_iop_listxattr (fs/kernfs/inode.c:239)
[ 1316.797929] vfs_listxattr (fs/xattr.c:276)
[ 1316.797929] listxattr (fs/xattr.c:559)
[ 1316.797929] SyS_flistxattr (include/linux/file.h:38 fs/xattr.c:621 fs/xattr.c:612)
[ 1316.797929] ? tracesys (arch/x86/kernel/entry_64.S:738)
[ 1316.797929] tracesys (arch/x86/kernel/entry_64.S:749)


Thanks,
Sasha
