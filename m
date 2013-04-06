Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932768Ab3DFHPU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Apr 2013 03:15:20 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:38767 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932752Ab3DFHPS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Apr 2013 03:15:18 -0400
Message-ID: <515FCAC6.8090806@linux.vnet.ibm.com>
Date: Sat, 06 Apr 2013 12:42:06 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Dave Hansen <dave@sr71.net>
CC: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Dave Jones <davej@redhat.com>, dhillf@gmail.com
Subject: Re: kernel BUG at kernel/smpboot.c:134!
References: <515F457E.5050505@sr71.net>
In-Reply-To: <515F457E.5050505@sr71.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 13040607-7014-0000-0000-000002D0C6B6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

On 04/06/2013 03:13 AM, Dave Hansen wrote:
> Hey Thomas,
> 
> I seem to be running in to smpboot_thread_fn()'s
> 
> 	BUG_ON(td->cpu != smp_processor_id());
> 
> pretty regularly, both at boot and if I boot with maxcpus=x and then
> online the CPUs from sysfs after boot.  It's a 160-logical-cpu system,
> so it's quite a beast.  I _seem_ to be hitting it more often at higher
> cpu counts, but it doesn't trigger on bringing up a particular CPU as
> far as I can tell.
> 
> This is on a pull of mainline from today, e0a77f263.  Any ideas?
>

Dave Jones had reported a similar problem some time back and Hillf had
proposed a fix. I guess it slipped through the cracks and never went
upstream.

Here is the link: https://lkml.org/lkml/2013/1/19/1

Can you please try it and see if it improves anything?

Regards,
Srivatsa S. Bhat
 
>> [  790.223270] ------------[ cut here ]------------
>> [  790.223966] kernel BUG at kernel/smpboot.c:134!
>> [  790.224739] invalid opcode: 0000 [#1] SMP 
>> [  790.225671] Modules linked in:
>> [  790.226428] CPU 81 
>> [  790.226909] Pid: 3909, comm: migration/135 Tainted: G        W    3.9.0-rc5-00184-gb6a9b7f-dirty #118 FUJITSU-SV PRIMEQUEST 1800E2/SB
>> [  790.228775] RIP: 0010:[<ffffffff8110bee8>]  [<ffffffff8110bee8>] smpboot_thread_fn+0x258/0x280
>> [  790.230205] RSP: 0018:ffff88bfef9c1e08  EFLAGS: 00010202
>> [  790.231090] RAX: 0000000000000051 RBX: ffff88bfefb82000 RCX: 000000000000b888
>> [  790.231653] RDX: ffff88bfef9c1fd8 RSI: ffff881fff000000 RDI: 0000000000000087
>> [  790.232085] RBP: ffff88bfef9c1e38 R08: 0000000000000001 R09: 0000000000000000
>> [  790.232850] R10: 0000000000000018 R11: 0000000000000000 R12: ffff88bfec9e22e0
>> [  790.233561] R13: ffffffff81e587a0 R14: ffff88bfec9e22e0 R15: 0000000000000000
>> [  790.234004] FS:  0000000000000000(0000) GS:ffff881fff000000(0000) knlGS:0000000000000000
>> [  790.234918] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
>> [  790.235602] CR2: 00007fa89a333c62 CR3: 0000000001e0b000 CR4: 00000000000007e0
>> [  790.236110] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>> [  790.236584] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
>> [  790.237329] Process migration/135 (pid: 3909, threadinfo ffff88bfef9c0000, task ffff88bfec9e22e0)
>> [  790.238321] Stack:
>> [  790.238882]  ffff88bfef9c1e38 0000000000000000 ffff88ffef421cc0 ffff88bfef9c1ec0
>> [  790.245415]  ffff88bfefb82000 ffffffff8110bc90 ffff88bfef9c1f48 ffffffff810ff1df
>> [  790.250755]  0000000000000001 0000000000000087 ffff88bfefb82000 0000000000000000
>> [  790.253365] Call Trace:
>> [  790.254121]  [<ffffffff8110bc90>] ? __smpboot_create_thread+0x180/0x180
>> [  790.255428]  [<ffffffff810ff1df>] kthread+0xef/0x100
>> [  790.256071]  [<ffffffff819cb1a4>] ? wait_for_completion+0x124/0x180
>> [  790.256697]  [<ffffffff810ff0f0>] ? __init_kthread_worker+0x80/0x80
>> [  790.257325]  [<ffffffff819dba9c>] ret_from_fork+0x7c/0xb0
>> [  790.258233]  [<ffffffff810ff0f0>] ? __init_kthread_worker+0x80/0x80
>> [  790.258942] Code: ef 3d 01 01 48 89 df e8 87 b0 16 00 48 83 05 67 ef 3d 01 01 48 83 c4 10 31 c0 5b 41 5c 41 5d 41 5e 5d c3 48 83 05 90 ef 3d 01 01 <0f> 0b 48 83 05 96 ef 3d 01 01 48 83 05 56 ef 3d 01 01 0f 0b 48 
>> [  790.276178] RIP  [<ffffffff8110bee8>] smpboot_thread_fn+0x258/0x280
>> [  790.276735]  RSP <ffff88bfef9c1e08>
>> [  790.278348] ---[ end trace 84baa2bee1434240 ]---
> 
> 

