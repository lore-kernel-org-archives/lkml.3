Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756227AbaGaH5O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 03:57:14 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:52508 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756189AbaGaH5L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 03:57:11 -0400
X-IronPort-AV: E=Sophos;i="5.00,1001,1396972800"; 
   d="scan'208";a="34006822"
Message-ID: <53D9F3ED.50504@cn.fujitsu.com>
Date: Thu, 31 Jul 2014 15:44:45 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: <rafael.j.wysocki@intel.com>, Tejun Heo <tj@kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: ACPI/cpu hotplug: possible lockdep
References: <53D88C5B.4060302@cn.fujitsu.com> <1956231.f1vFNp0Nyx@vostro.rjw.lan>
In-Reply-To: <1956231.f1vFNp0Nyx@vostro.rjw.lan>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.226.100]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rafael,
The warning is still there, though the detail info is a bit different.

[  389.589955] ======================================================
[  389.590064] [ INFO: possible circular locking dependency detected ]
[  389.590064] 3.16.0-rc7+ #119 Not tainted
[  389.590064] -------------------------------------------------------
[  389.590064] kworker/u8:3/62 is trying to acquire lock:
[  389.590064]  (s_active#53){++++.+}, at: [<ffffffff811d4ad8>] kernfs_remove_by_name_ns+0x70/0x8c
[  389.590064] 
[  389.590064] but task is already holding lock:
[  389.590064]  (cpu_hotplug.lock#2){+.+.+.}, at: [<ffffffff810628f9>] cpu_hotplug_begin+0x4f/0x79
[  389.606161] 
[  389.606161] which lock already depends on the new lock.
[  389.606161] 
[  389.606161] 
[  389.606161] the existing dependency chain (in reverse order) is:
[  389.606161] 
-> #3 (cpu_hotplug.lock#2){+.+.+.}:
[  389.606161]        [<ffffffff810a1081>] lock_acquire+0xdb/0x101
[  389.606161]        [<ffffffff81596187>] mutex_lock_nested+0x6d/0x37a
[  389.606161]        [<ffffffff810628f9>] cpu_hotplug_begin+0x4f/0x79
[  389.606161]        [<ffffffff81062992>] _cpu_up+0x35/0x126
[  389.606161]        [<ffffffff81062af2>] cpu_up+0x6f/0x81
[  389.606161]        [<ffffffff81d11809>] smp_init+0x53/0x93
[  389.606161]        [<ffffffff81cf5fe2>] kernel_init_freeable+0x13d/0x24b
[  389.606161]        [<ffffffff8158557a>] kernel_init+0xe/0xdf
[  389.606161]        [<ffffffff8159952c>] ret_from_fork+0x7c/0xb0
[  389.606161] 
-> #2 (cpu_hotplug.lock){++++++}:
[  389.606161]        [<ffffffff810a1081>] lock_acquire+0xdb/0x101
[  389.606161]        [<ffffffff810628eb>] cpu_hotplug_begin+0x41/0x79
[  389.606161]        [<ffffffff81062992>] _cpu_up+0x35/0x126
[  389.606161]        [<ffffffff81062af2>] cpu_up+0x6f/0x81
[  389.606161]        [<ffffffff81d11809>] smp_init+0x53/0x93
[  389.606161]        [<ffffffff81cf5fe2>] kernel_init_freeable+0x13d/0x24b
[  389.606161]        [<ffffffff8158557a>] kernel_init+0xe/0xdf
[  389.638245]        [<ffffffff8159952c>] ret_from_fork+0x7c/0xb0
[  389.638245] 
[  389.638245] -> #1 (cpu_add_remove_lock){+.+.+.}:
[  389.638245]        [<ffffffff810a1081>] lock_acquire+0xdb/0x101
[  389.638245]        [<ffffffff81598726>] _raw_spin_lock+0x3e/0x73
[  389.638245]        [<ffffffff81590182>] get_partial_node+0x4b/0x1e7
[  389.638245]        [<ffffffff815904d8>] __slab_alloc+0x1ba/0x466
[  389.638245]        [<ffffffff81167239>] kmem_cache_alloc+0x86/0x157
[  389.638245]        [<ffffffff8117237d>] create_object+0x36/0x2a0
[  389.638245]        [<ffffffff815880df>] kmemleak_alloc+0x72/0x96
[  389.638245]        [<ffffffff81164c29>] slab_post_alloc_hook+0x28/0x2a
[  389.638245]        [<ffffffff81166f76>] kmem_cache_alloc_trace+0xf0/0x11a
[  389.638245]        [<ffffffff811923d9>] seq_open+0x37/0xac
[  389.638245]        [<ffffffff811d5511>] kernfs_fop_open+0x169/0x2ca
[  389.638245]        [<ffffffff81173822>] do_dentry_open+0x1ac/0x2ca
[  389.638245]        [<ffffffff81173c39>] finish_open+0x35/0x40
[  389.638245]        [<ffffffff81181f4c>] do_last+0x833/0x9d2
[  389.638245]        [<ffffffff81182320>] path_openat+0x235/0x4c3
[  389.638245]        [<ffffffff811828f9>] do_filp_open+0x3a/0x8a
[  389.638245]        [<ffffffff811749f3>] do_sys_open+0x70/0x102
[  389.638245]        [<ffffffff81174aa3>] SyS_open+0x1e/0x20
[  389.638245]        [<ffffffff815995d2>] system_call_fastpath+0x16/0x1b
[  389.638245] 
[  389.638245] -> #0 (s_active#53){++++.+}:
[  389.638245]        [<ffffffff810a088a>] __lock_acquire+0xb3b/0xe41
[  389.638245]        [<ffffffff810a1081>] lock_acquire+0xdb/0x101
[  389.638245]        [<ffffffff811d3f97>] __kernfs_remove+0x169/0x2be
[  389.638245]        [<ffffffff811d4ad8>] kernfs_remove_by_name_ns+0x70/0x8c
[  389.638245]        [<ffffffff811d604c>] sysfs_remove_file_ns+0x15/0x17
[  389.638245]        [<ffffffff8138143e>] device_remove_file+0x19/0x1b
[  389.638245]        [<ffffffff813814f6>] device_remove_attrs+0x2e/0x68
[  389.638245]        [<ffffffff81381658>] device_del+0x128/0x187
[  389.638245]        [<ffffffff813816ff>] device_unregister+0x48/0x54
[  389.638245]        [<ffffffff81387366>] unregister_cpu+0x39/0x55
[  389.638245]        [<ffffffff81008c03>] arch_unregister_cpu+0x23/0x28
[  389.638245]        [<ffffffff812f7a75>] acpi_processor_remove+0x91/0xca
[  389.638245]        [<ffffffff812f51d1>] acpi_bus_trim+0x5a/0x8d
[  389.638245]        [<ffffffff812f71c6>] acpi_device_hotplug+0x301/0x3ff
[  389.638245]        [<ffffffff812f0760>] acpi_hotplug_work_fn+0x20/0x2d
[  389.638245]        [<ffffffff81078ff5>] process_one_work+0x207/0x375
[  389.638245]        [<ffffffff8107944f>] worker_thread+0x2bd/0x329
[  389.638245]        [<ffffffff8107ef6e>] kthread+0xba/0xc2
[  389.638245]        [<ffffffff8159952c>] ret_from_fork+0x7c/0xb0
[  389.638245] 
[  389.638245] other info that might help us debug this:
[  389.638245] 
[  389.638245] Chain exists of:
[  389.638245]   s_active#53 --> cpu_hotplug.lock --> cpu_hotplug.lock#2
[  389.638245] 
[  389.638245]  Possible unsafe locking scenario:
[  389.638245] 
[  389.638245]        CPU0                    CPU1
[  389.638245]        ----                    ----
[  389.638245]   lock(cpu_hotplug.lock#2);
[  389.638245]                                lock(cpu_hotplug.lock);
[  389.638245]                                lock(cpu_hotplug.lock#2);
[  389.638245]   lock(s_active#53);
[  389.638245] 
[  389.638245]  *** DEADLOCK ***
[  389.638245] 
[  389.638245] 7 locks held by kworker/u8:3/62:
[  389.638245]  #0:  ("kacpi_hotplug"){.+.+.+}, at: [<ffffffff81078f4d>] process_one_work+0x15f/0x375
[  389.638245]  #1:  ((&hpw->work)){+.+.+.}, at: [<ffffffff81078f4d>] process_one_work+0x15f/0x375
[  389.638245]  #2:  (device_hotplug_lock){+.+.+.}, at: [<ffffffff81381f7a>] lock_device_hotplug+0x17/0x19
[  389.638245]  #3:  (acpi_scan_lock){+.+.+.}, at: [<ffffffff812f6ef2>] acpi_device_hotplug+0x2d/0x3ff
[  389.638245]  #4:  (cpu_add_remove_lock){+.+.+.}, at: [<ffffffff81062722>] cpu_maps_update_begin+0x17/0x19
[  389.638245]  #5:  (cpu_hotplug.lock){++++++}, at: [<ffffffff810628af>] cpu_hotplug_begin+0x5/0x79
[  389.638245]  #6:  (cpu_hotplug.lock#2){+.+.+.}, at: [<ffffffff810628f9>] cpu_hotplug_begin+0x4f/0x79
[  389.638245] 
[  389.638245] stack backtrace:
[  389.638245] CPU: 1 PID: 62 Comm: kworker/u8:3 Not tainted 3.16.0-rc7+ #119
[  389.638245] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.7.5-0-ge51488c-20140602_164612-nilsson.home.kraxel.org 04/01/2014
[  389.638245] Workqueue: kacpi_hotplug acpi_hotplug_work_fn
[  389.638245]  ffffffff8209cc80 ffff8800372df968 ffffffff8159266c 0000000000000b3c
[  389.638245]  ffffffff820f2840 ffff8800372df9b8 ffffffff8158e0ce ffff8800372df9a8
[  389.638245]  ffffffff82486070 ffff8800372e0000 ffff8800372e09d8 ffff8800372e0000
[  389.638245] Call Trace:
[  389.638245]  [<ffffffff8159266c>] dump_stack+0x4e/0x68
[  389.638245]  [<ffffffff8158e0ce>] print_circular_bug+0x1f8/0x209
[  389.638245]  [<ffffffff810a088a>] __lock_acquire+0xb3b/0xe41
[  389.638245]  [<ffffffff811d4ad8>] ? kernfs_remove_by_name_ns+0x70/0x8c
[  389.638245]  [<ffffffff810a1081>] lock_acquire+0xdb/0x101
[  389.638245]  [<ffffffff811d4ad8>] ? kernfs_remove_by_name_ns+0x70/0x8c
[  389.638245]  [<ffffffff811d3f97>] __kernfs_remove+0x169/0x2be
[  389.638245]  [<ffffffff811d4ad8>] ? kernfs_remove_by_name_ns+0x70/0x8c
[  389.638245]  [<ffffffff811d3412>] ? kernfs_find_ns+0xdc/0x104
[  389.638245]  [<ffffffff811d4ad8>] kernfs_remove_by_name_ns+0x70/0x8c
[  389.638245]  [<ffffffff811d604c>] sysfs_remove_file_ns+0x15/0x17
[  389.638245]  [<ffffffff8138143e>] device_remove_file+0x19/0x1b
[  389.638245]  [<ffffffff813814f6>] device_remove_attrs+0x2e/0x68
[  389.638245]  [<ffffffff81381658>] device_del+0x128/0x187
[  389.638245]  [<ffffffff813816ff>] device_unregister+0x48/0x54
[  389.638245]  [<ffffffff81387366>] unregister_cpu+0x39/0x55
[  389.638245]  [<ffffffff81008c03>] arch_unregister_cpu+0x23/0x28
[  389.638245]  [<ffffffff812f7a75>] acpi_processor_remove+0x91/0xca
[  389.638245]  [<ffffffff812f51d1>] acpi_bus_trim+0x5a/0x8d
[  389.638245]  [<ffffffff812f71c6>] acpi_device_hotplug+0x301/0x3ff
[  389.638245]  [<ffffffff812f0760>] acpi_hotplug_work_fn+0x20/0x2d
[  389.638245]  [<ffffffff81078ff5>] process_one_work+0x207/0x375
[  389.638245]  [<ffffffff81078f4d>] ? process_one_work+0x15f/0x375
[  389.638245]  [<ffffffff8107944f>] worker_thread+0x2bd/0x329
[  389.638245]  [<ffffffff81079192>] ? process_scheduled_works+0x2f/0x2f
[  389.638245]  [<ffffffff8107ef6e>] kthread+0xba/0xc2
[  389.638245]  [<ffffffff810a1511>] ? trace_hardirqs_on+0xd/0xf
[  389.638245]  [<ffffffff8107eeb4>] ? __init_kthread_worker+0x59/0x59
[  389.638245]  [<ffffffff8159952c>] ret_from_fork+0x7c/0xb0
[  389.638245]  [<ffffffff8107eeb4>] ? __init_kthread_worker+0x59/0x59

On 07/30/2014 09:12 PM, Rafael J. Wysocki wrote:

> On Wednesday, July 30, 2014 02:10:35 PM Gu Zheng wrote:
>> Hi Rafael,
> 
> Hi,
> 
>> A lockdep warning occurs when hot removing a cpu via sysfs:
>> echo 1 > /sys/bus/acpi/devices/LNXCPU\:02/eject
>> The kernel is latest upstream, and the test box is a kvm vm,
>> detail info as following.
> 
> Well, I have a theory.
> 
> Is the splat still reproducible with the patch below applied?
> 
> Rafael
> 
> ---
>  kernel/smp.c |    2 ++
>  1 file changed, 2 insertions(+)
> 
> Index: linux-pm/kernel/smp.c
> ===================================================================
> --- linux-pm.orig/kernel/smp.c
> +++ linux-pm/kernel/smp.c
> @@ -542,6 +542,7 @@ void __init smp_init(void)
>  
>  	idle_threads_init();
>  
> +	lock_device_hotplug();
>  	/* FIXME: This should be done in userspace --RR */
>  	for_each_present_cpu(cpu) {
>  		if (num_online_cpus() >= setup_max_cpus)
> @@ -549,6 +550,7 @@ void __init smp_init(void)
>  		if (!cpu_online(cpu))
>  			cpu_up(cpu);
>  	}
> +	unlock_device_hotplug();
>  
>  	/* Any cleanup work */
>  	smp_announce();
> 
> .
> 


