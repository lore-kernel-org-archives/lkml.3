Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758668Ab3BFVFJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 16:05:09 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:53957 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757301Ab3BFVFG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 16:05:06 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Artem Savkov <artem.savkov@gmail.com>
Cc: cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>
Subject: Re: [BUG] cpufreq: sleeping function called from invalid context at kernel/workqueue.c:2811
Date: Wed, 06 Feb 2013 22:11:25 +0100
Message-ID: <1543919.ZBNJa64WB5@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc6; KDE/4.9.5; x86_64; ; )
In-Reply-To: <20130206202513.GA5626@thinkpad.lan>
References: <20130206202513.GA5626@thinkpad.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, February 07, 2013 12:25:13 AM Artem Savkov wrote:
> I get the following BUG on suspend using systemd-sleep(this doesn't
> happen with pm-suspend). This seems to be introduced by some of the
> Viresh's patches.

Which branch from which day?

Rafael


> [   94.908046] Disabling non-boot CPUs ...
> [   94.908416] BUG: sleeping function called from invalid context at kernel/workqueue.c:2811
> [   94.908419] in_atomic(): 1, irqs_disabled(): 1, pid: 4038, name: systemd-sleep
> [   94.908421] 7 locks held by systemd-sleep/4038:
> [   94.908439]  #0:  (&buffer->mutex){......}, at: [<c11908e9>] sysfs_write_file+0x29/0x100
> [   94.908448]  #1:  (s_active#179){......}, at: [<c119094d>] sysfs_write_file+0x8d/0x100
> [   94.908459]  #2:  (pm_mutex){......}, at: [<c107f990>] pm_suspend+0x40/0x1e0
> [   94.908469]  #3:  (cpu_add_remove_lock){......}, at: [<c103ab04>] cpu_maps_update_begin+0x14/0x20
> [   94.908476]  #4:  (cpu_hotplug.lock){......}, at: [<c103a9e2>] cpu_hotplug_begin+0x22/0x50
> [   94.908487]  #5:  (&per_cpu(cpu_policy_rwsem, cpu)){......}, at: [<c14bfbfd>] lock_policy_rwsem_write+0x3d/0x70
> [   94.908495]  #6:  (cpufreq_driver_lock){......}, at: [<c14bfe06>] __cpufreq_remove_dev.isra.10+0x26/0x270
> [   94.908500] Pid: 4038, comm: systemd-sleep Not tainted 3.8.0-rc6-next-20130205+ #200
> [   94.908501] Call Trace:
> [   94.908511]  [<c1067ce0>] __might_sleep+0xe0/0x100
> [   94.908518]  [<c1050f3f>] flush_work+0x5f/0x230
> [   94.908523]  [<c1050ee0>] ? insert_work+0x50/0x50
> [   94.908528]  [<c1046277>] ? del_timer+0x47/0x70
> [   94.908533]  [<c1046277>] ? del_timer+0x47/0x70
> [   94.908538]  [<c1052b08>] ? try_to_grab_pending+0xa8/0x120
> [   94.908543]  [<c1053b49>] __cancel_work_timer+0x59/0x80
> [   94.908548]  [<c1053b82>] cancel_delayed_work_sync+0x12/0x20
> [   94.908555]  [<c14c32ed>] cpufreq_governor_dbs+0x2cd/0x490
> [   94.908561]  [<c14c26c6>] od_cpufreq_governor_dbs+0x16/0x20
> [   94.908565]  [<c14bfd21>] __cpufreq_governor+0x41/0x100
> [   94.908570]  [<c14bfe06>] ? __cpufreq_remove_dev.isra.10+0x26/0x270
> [   94.908575]  [<c14bfe36>] __cpufreq_remove_dev.isra.10+0x56/0x270
> [   94.908580]  [<c14bfbfd>] ? lock_policy_rwsem_write+0x3d/0x70
> [   94.908589]  [<c1686c20>] cpufreq_cpu_callback+0x50/0x65
> [   94.908596]  [<c16966c7>] notifier_call_chain+0x47/0x90
> [   94.908606]  [<c1060fee>] __raw_notifier_call_chain+0x1e/0x30
> [   94.908610]  [<c103a974>] __cpu_notify+0x24/0x50
> [   94.908615]  [<c167bf7d>] _cpu_down+0x6d/0x250
> [   94.908621]  [<c103ac7c>] disable_nonboot_cpus+0x6c/0xf0
> [   94.908625]  [<c107f815>] suspend_devices_and_enter+0x175/0x2b0
> [   94.908629]  [<c107fb27>] pm_suspend+0x1d7/0x1e0
> [   94.908633]  [<c107ebed>] state_store+0x5d/0xb0
> [   94.908638]  [<c107eb90>] ? pm_trace_dev_match_show+0x20/0x20
> [   94.908644]  [<c12c074b>] kobj_attr_store+0x1b/0x30
> [   94.908650]  [<c1190963>] sysfs_write_file+0xa3/0x100
> [   94.908655]  [<c11908c0>] ? sysfs_open_file+0x1f0/0x1f0
> [   94.908662]  [<c112dc28>] vfs_write+0x88/0x140
> [   94.908667]  [<c11908c0>] ? sysfs_open_file+0x1f0/0x1f0
> [   94.908672]  [<c112def7>] sys_write+0x47/0x90
> [   94.908679]  [<c169a0fa>] sysenter_do_call+0x12/0x2d
> [   94.911067] smpboot: CPU 1 is now offline
> [   94.915585] smpboot: CPU 2 is now offline
> [   94.917500] smpboot: CPU 3 is now offline
> 
> 
> 
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
