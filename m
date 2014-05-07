Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933184AbaEGPh7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 11:37:59 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:21814 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932410AbaEGPhY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 11:37:24 -0400
Message-ID: <536A532C.4050001@oracle.com>
Date: Wed, 07 May 2014 11:37:16 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: axboe@fb.com
CC: LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>
Subject: blk-mq: WARN at block/blk-mq.c:585 __blk_mq_run_hw_queue
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

While fuzzing with trinity inside a KVM tools guest running the latest -next
kernel I've stumbled on the following spew:

[  986.962569] WARNING: CPU: 41 PID: 41607 at block/blk-mq.c:585 __blk_mq_run_hw_queue+0x90/0x500()
[  986.964364] Modules linked in:
[  986.964996] CPU: 41 PID: 41607 Comm: kworker/u147:1 Not tainted 3.15.0-rc4-next-20140506-sasha-00021-gc164334-dirty #447
[  986.967025] Workqueue: kblockd blk_mq_run_work_fn
[  986.967939]  0000000000000009 ffff8802410e1c68 ffffffff94536f8a 0000000000000001
[  986.970333]  0000000000000000 ffff8802410e1ca8 ffffffff9115febc ffffffff91183ef7
[  986.973173]  ffff8801b478ef60 0000000000000000 ffff8802410e1ce8 ffff8801b3f07978
[  986.975749] Call Trace:
[  986.976700] dump_stack (lib/dump_stack.c:52)
[  986.978875] warn_slowpath_common (kernel/panic.c:430)
[  986.981924] ? process_one_work (kernel/workqueue.c:2224)
[  986.984245] warn_slowpath_null (kernel/panic.c:465)
[  986.986670] __blk_mq_run_hw_queue (arch/x86/include/asm/bitops.h:311 (discriminator 65) block/blk-mq.c:587 (discriminator 65))
[  986.989000] ? process_one_work (include/linux/workqueue.h:186 kernel/workqueue.c:611 kernel/workqueue.c:638 kernel/workqueue.c:2220)
[  986.991584] ? get_parent_ip (kernel/sched/core.c:2485)
[  986.994168] blk_mq_run_work_fn (block/blk-mq.c:777)
[  986.996379] process_one_work (kernel/workqueue.c:2227 include/linux/jump_label.h:105 include/trace/events/workqueue.h:111 kernel/workqueue.c:2232)
[  986.998641] ? process_one_work (include/linux/workqueue.h:186 kernel/workqueue.c:611 kernel/workqueue.c:638 kernel/workqueue.c:2220)
[  987.001352] worker_thread (kernel/workqueue.c:2354)
[  987.003676] ? rescuer_thread (kernel/workqueue.c:2303)
[  987.006703] kthread (kernel/kthread.c:210)
[  987.009161] ? kthread_create_on_node (kernel/kthread.c:176)
[  987.012536] ret_from_fork (arch/x86/kernel/entry_64.S:553)
[  987.015272] ? kthread_create_on_node (kernel/kthread.c:176)


Thanks,
Sasha
