Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752988AbaCaHJA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 03:09:00 -0400
Received: from natasha.panasas.com ([209.166.131.148]:44526 "EHLO
	natasha.panasas.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752243AbaCaHI6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 03:08:58 -0400
Message-ID: <53391483.9010800@panasas.com>
Date: Mon, 31 Mar 2014 10:08:51 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Fengguang Wu <fengguang.wu@intel.com>
CC: <linux-kernel@vger.kernel.org>
Subject: Re: [do_xor_speed] WARNING: CPU: 0 PID: 1 at init/main.c:708 do_one_initcall()
References: <20140331003825.GA11782@localhost>
In-Reply-To: <20140331003825.GA11782@localhost>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry about that I forgot about the experimental rule, fixed now.

Is there a way for a white list. With -experimental I need to say
every branch I do not want included is there a way to say only
the branches I do want included?

Thanks
Boaz

On 03/31/2014 03:38 AM, Fengguang Wu wrote:
> Greetings,
> 
> I got the below dmesg and the first bad commit is
> 
> git://git.open-osd.org/linux-open-osd.git bidi-mq
> 
> commit 992e60a78e1c2c6996fd55c5fb11344ad1a4c189
> Author:     Boaz Harrosh <bharrosh@panasas.com>
> AuthorDate: Thu Jul 19 15:22:37 2012 +0300
> Commit:     Boaz Harrosh <boaz@plexistor.com>
> CommitDate: Sun Mar 30 16:03:29 2014 +0300
> 
>     RFC: do_xor_speed Broken on UML do to jiffies
>     
> [    0.413369]    generic_sse:    70.500 MB/sec
> [    0.415084] xor: using function: generic_sse (70.500 MB/sec)
> [    0.416734] ------------[ cut here ]------------
> [    0.418634] WARNING: CPU: 0 PID: 1 at init/main.c:708 do_one_initcall+0x174/0x18b()
> [    0.420050] initcall calibrate_xor_blocks+0x0/0x1cc returned with preemption imbalance 
> [    0.423371] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.14.0-rc8-00108-g992e60a #38
> [    0.426451] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
> [    0.426700]  0000000000000000 ffff880000155d80 ffffffff823bd1f9 ffff880000155dc8
> [    0.432082]  ffff880000155db8 ffffffff81084d37 ffffffff84684565 ffffffff846b9bc6
> [    0.435342]  0000000000000000 0000000000000000 0000000000000000 ffff880000155e18
> [    0.438786] Call Trace:
> [    0.439766]  [<ffffffff823bd1f9>] dump_stack+0xa1/0x102
> [    0.440059]  [<ffffffff81084d37>] warn_slowpath_common+0x93/0xc1
> [    0.443380]  [<ffffffff84684565>] ? do_one_initcall+0x174/0x18b
> [    0.446707]  [<ffffffff846b9bc6>] ? do_xor_speed+0x12d/0x12d
> [    0.448950]  [<ffffffff81084df0>] warn_slowpath_fmt+0x55/0x5e
> [    0.450041]  [<ffffffff846b9bc6>] ? do_xor_speed+0x12d/0x12d
> [    0.453372]  [<ffffffff84684565>] do_one_initcall+0x174/0x18b
> [    0.455645]  [<ffffffff846848d7>] kernel_init_freeable+0x35b/0x46d
> [    0.456706]  [<ffffffff84683992>] ? do_early_param+0xd7/0xd7
> [    0.460044]  [<ffffffff8239ea58>] ? rest_init+0x15c/0x15c
> [    0.463372]  [<ffffffff8239ea68>] kernel_init+0x10/0x181
> [    0.465550]  [<ffffffff823d890c>] ret_from_fork+0x7c/0xb0
> [    0.466712]  [<ffffffff8239ea58>] ? rest_init+0x15c/0x15c
> [    0.470089] ---[ end trace 5d56b560c4cace50 ]---
> [    0.471938] prandom: seed boundary self test passed
> 
> git bisect start 80b612bf90a8ebdd09dff5695d0357aeb78f963e 66e810ec9fff9cf5622a8326805ef310fd5b98e7 --
> git bisect good ad95c966acc03bc906dff6b875a545379680f264  # 03:08     20+      0  Merge remote-tracking branch 'linus/master' into bidi-mq
> git bisect  bad 992e60a78e1c2c6996fd55c5fb11344ad1a4c189  # 03:09      0-      1  RFC: do_xor_speed Broken on UML do to jiffies
> # first bad commit: [992e60a78e1c2c6996fd55c5fb11344ad1a4c189] RFC: do_xor_speed Broken on UML do to jiffies
> git bisect good ad95c966acc03bc906dff6b875a545379680f264  # 03:20     60+      0  Merge remote-tracking branch 'linus/master' into bidi-mq
> git bisect  bad 80b612bf90a8ebdd09dff5695d0357aeb78f963e  # 03:20      0-     19  {TODO} bsg: remove bogus (and fatal) check in bsg_register_queue
> git bisect good 981e893ed537cbaa08f8089d480db4165e6d71c0  # 03:31     60+      0  Merge branch 'timers-urgent-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
> git bisect good 201544be8c37dffbf069bb5fc9edb5674f8c1754  # 03:36     60+      0  Add linux-next specific files for 20140328
> 
> 
> This script may reproduce the error.
> 
> -----------------------------------------------------------------------------
> #!/bin/bash
> 
> kernel=$1
> 
> kvm=(
> 	qemu-system-x86_64 -cpu kvm64 -enable-kvm
> 	-kernel $kernel
> 	-smp 2
> 	-m 256M
> 	-net nic,vlan=0,macaddr=00:00:00:00:00:00,model=virtio
> 	-net user,vlan=0
> 	-net nic,vlan=1,model=e1000
> 	-net user,vlan=1
> 	-boot order=nc
> 	-no-reboot
> 	-watchdog i6300esb
> 	-serial stdio
> 	-display none
> 	-monitor null
> )
> 
> append=(
> 	debug
> 	sched_debug
> 	apic=debug
> 	ignore_loglevel
> 	sysrq_always_enabled
> 	panic=10
> 	prompt_ramdisk=0
> 	earlyprintk=ttyS0,115200
> 	console=ttyS0,115200
> 	console=tty0
> 	vga=normal
> 	root=/dev/ram0
> 	rw
> )
> 
> "${kvm[@]}" --append "${append[*]}"
> -----------------------------------------------------------------------------
> 
> Thanks,
> Fengguang
> 

