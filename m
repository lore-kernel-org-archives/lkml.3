Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755116Ab3BDSZz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 13:25:55 -0500
Received: from mail-ie0-f182.google.com ([209.85.223.182]:56424 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751908Ab3BDSZw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 13:25:52 -0500
Message-ID: <510FFD2C.90902@gmail.com>
Date: Mon, 04 Feb 2013 10:25:48 -0800
From: Dirk Brandewie <dirk.brandewie@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: dirk.brandewie@gmail.com, linux-kernel@vger.kernel.org,
        cpufreq@vger.kernel.org
Subject: Re: [PATCH 5/6] cpufreq: balance out cpufreq_cpu_{get,put} for scaling
 drivers using setpolicy
References: <1359744343-18690-1-git-send-email-dirk.brandewie@gmail.com> <1359744343-18690-9-git-send-email-dirk.brandewie@gmail.com> <CAOh2x=mU8+mJmr=BXjSLaz7Yxg--t2mPpsc_=Xry2ArNroB8Aw@mail.gmail.com>
In-Reply-To: <CAOh2x=mU8+mJmr=BXjSLaz7Yxg--t2mPpsc_=Xry2ArNroB8Aw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Viresh,

I have rebased onto bleeding-edge when I reboot the system I get a kernel panic.
Any idea what I could have done that would have broken the restructured
cpufreq_{add/remove}_dev.

--Dirk

[  134.714071] kvm: exiting hardware virtualization
[  134.920302] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[  135.132967] Disabling non-boot CPUs ...
[  135.137189] __cpufreq_remove_dev: cpufreq: __cpufreq_remove_dev: 
unregistering CPU 1
[  135.145577] __cpufreq_remove_dev: cpufreq: __cpufreq_remove_dev: removing 
link, cpu: 1
[  135.154152] ------------[ cut here ]------------
[  135.159212] kernel BUG at fs/sysfs/dir.c:562!
[  135.163900] invalid opcode: 0000 [#1] SMP
[  135.168367] Modules linked in:
[  135.171720] CPU 0
[  135.173730] Pid: 1, comm: systemd-shutdow Not tainted 3.8.0-rc5+ #33 Acer 
Veriton X4618G/Veriton X4618G
[  135.184133] RIP: 0010:[<ffffffff81252723>]  [<ffffffff81252723>] 
sysfs_remove_one+0x73/0x80
[  135.193155] RSP: 0018:ffff880427c95b88  EFLAGS: 00010202
[  135.198925] RAX: ffff880427d10000 RBX: ffff880425efe460 RCX: 0000000180240017
[  135.206641] RDX: 0000000000000000 RSI: ffff880425efe460 RDI: ffff880427c95bb8
[  135.214314] RBP: ffff880427c95ba8 R08: 0000000000000000 R09: 0000000000000001
[  135.222060] R10: 000000000000000e R11: ffffffff81251f38 R12: 0000000000000000
[  135.229854] R13: ffff880425efe460 R14: 0000000000000246 R15: 0000000000000001
[  135.237537] FS:  00007fd987f6a800(0000) GS:ffff88043e200000(0000) 
knlGS:0000000000000000
[  135.246343] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  135.252525] CR2: 00000032e70104f0 CR3: 0000000416bf8000 CR4: 00000000000407f0
[  135.260203] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  135.267959] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  135.275668] Process systemd-shutdow (pid: 1, threadinfo ffff880427c94000, 
task ffff880427d10000)
[  135.285104] Stack:
[  135.287299]  ffff880425efe460 ffff880425efe460 0000000000000000 ffff880425efe460
[  135.295355]  ffff880427c95bd8 ffffffff8125281a ffff88042789fd20 0000000000000000
[  135.303461]  0000000000000246 0000000000000000 ffff880427c95c18 ffffffff81252cf7
[  135.311571] Call Trace:
[  135.314213]  [<ffffffff8125281a>] remove_dir+0x2a/0x40
[  135.319786]  [<ffffffff81252cf7>] sysfs_remove_dir+0x97/0xc0
[  135.325886]  [<ffffffff8137ebc6>] kobject_del+0x16/0x40
[  135.331529]  [<ffffffff8137ec52>] kobject_cleanup+0x62/0x1b0
[  135.337598]  [<ffffffff8137eafb>] kobject_put+0x2b/0x60
[  135.343253]  [<ffffffff816311a3>] __cpufreq_remove_dev.isra.13+0x183/0x450
[  135.350682]  [<ffffffff81829a76>] ? down_write+0x16/0x40
[  135.356422]  [<ffffffff8181e030>] cpufreq_cpu_callback+0x5d/0x77
[  135.362966]  [<ffffffff8182fa1d>] notifier_call_chain+0x4d/0x70
[  135.369346]  [<ffffffff810cf2ce>] __raw_notifier_call_chain+0xe/0x10
[  135.376256]  [<ffffffff810a8f70>] __cpu_notify+0x20/0x40
[  135.382026]  [<ffffffff8180f5af>] _cpu_down+0x7f/0x270
[  135.387602]  [<ffffffff810a926e>] disable_nonboot_cpus+0x8e/0x120
[  135.394170]  [<ffffffff810bcd7b>] kernel_restart+0x1b/0x60
[  135.400075]  [<ffffffff810bcfa1>] sys_reboot+0x1c1/0x280
[  135.405832]  [<ffffffff811827ae>] ? do_writepages+0x1e/0x40
[  135.411879]  [<ffffffff81177d41>] ? __filemap_fdatawrite_range+0x51/0x60
[  135.419129]  [<ffffffff811f6f78>] ? iput+0x48/0x190
[  135.424457]  [<ffffffff8120b600>] ? sync_inodes_one_sb+0x20/0x20
[  135.430969]  [<ffffffff81215d3f>] ? iterate_bdevs+0xef/0x100
[  135.437057]  [<ffffffff81833fd9>] system_call_fastpath+0x16/0x1b
[  135.443563] Code: 30 49 89 44 24 38 49 89 54 24 40 66 81 4b 60 00 20 49 8b 45 
08 48 89 43 30 49 89 5d 08 48 8b 5d e8 4c 8b 65 f0 4c
[  135.465457] RIP  [<ffffffff81252723>] sysfs_remove_one+0x73/0x80
[  135.471964]  RSP <ffff880427c95b88>
[  135.475777] ---[ end trace 88437c0ab4adf760 ]---
[  135.488452] Kernel panic - not syncing: Attempted to kill init! 
exitcode=0x0000000b
[  135.488452]
[  135.504187] drm_kms_helper: panic occurred, switching back to text console
[  135.511074] ------------[ cut here ]------------
[  135.515711] WARNING: at arch/x86/kernel/smp.c:123 
native_smp_send_reschedule+0x5b/0x60()
[  135.523805] Hardware name: Veriton X4618G
[  135.527819] Modules linked in:
[  135.530921] Pid: 1, comm: systemd-shutdow Tainted: G      D      3.8.0-rc5+ #33
[  135.538233] Call Trace:
[  135.540694]  <IRQ>  [<ffffffff810a552f>] warn_slowpath_common+0x7f/0xc0
[  135.547363]  [<ffffffff810a558a>] warn_slowpath_null+0x1a/0x20
[  135.553202]  [<ffffffff8107baeb>] native_smp_send_reschedule+0x5b/0x60
[  135.559733]  [<ffffffff810e5774>] trigger_load_balance+0x184/0x220
[  135.565920]  [<ffffffff810d9989>] scheduler_tick+0x109/0x140
[  135.571593]  [<ffffffff810b67bc>] update_process_times+0x6c/0x90
[  135.577615]  [<ffffffff810fef6e>] tick_sched_handle.isra.8+0x2e/0x70
[  135.583975]  [<ffffffff810ff0fc>] tick_sched_timer+0x4c/0x80
[  135.589639]  [<ffffffff810cd243>] __run_hrtimer+0x73/0x1d0
[  135.595135]  [<ffffffff810ff0b0>] ? tick_sched_do_timer+0x40/0x40
[  135.601242]  [<ffffffff810adc16>] ? __do_softirq+0x136/0x210
[  135.606912]  [<ffffffff810cdb67>] hrtimer_interrupt+0xf7/0x230
[  135.612755]  [<ffffffff81835c39>] smp_apic_timer_interrupt+0x69/0x99
[  135.619118]  [<ffffffff81834b9d>] apic_timer_interrupt+0x6d/0x80
[  135.625125]  <EOI>  [<ffffffff8182110e>] ? panic+0x18c/0x1d0
[  135.630843]  [<ffffffff81821078>] ? panic+0xf6/0x1d0
[  135.635814]  [<ffffffff810ab688>] do_exit+0x918/0x9e0
[  135.640872]  [<ffffffff8182cbdd>] oops_end+0x9d/0xe0
[  135.645849]  [<ffffffff8105b848>] die+0x58/0x90
[  135.650395]  [<ffffffff8182c47b>] do_trap+0x6b/0x170
[  135.655367]  [<ffffffff8182fa52>] ? __atomic_notifier_call_chain+0x12/0x20
[  135.662242]  [<ffffffff81058eec>] do_invalid_op+0x9c/0xb0
[  135.667650]  [<ffffffff81252723>] ? sysfs_remove_one+0x73/0x80
[  135.673482]  [<ffffffff818350de>] invalid_op+0x1e/0x30
[  135.678631]  [<ffffffff81251f38>] ? release_sysfs_dirent+0xa8/0xf0
[  135.684816]  [<ffffffff81252723>] ? sysfs_remove_one+0x73/0x80
[  135.690656]  [<ffffffff818291fd>] ? mutex_lock+0x1d/0x50
[  135.695982]  [<ffffffff8125281a>] remove_dir+0x2a/0x40
[  135.701136]  [<ffffffff81252cf7>] sysfs_remove_dir+0x97/0xc0
[  135.706798]  [<ffffffff8137ebc6>] kobject_del+0x16/0x40
[  135.712027]  [<ffffffff8137ec52>] kobject_cleanup+0x62/0x1b0
[  135.717693]  [<ffffffff8137eafb>] kobject_put+0x2b/0x60
[  135.722928]  [<ffffffff816311a3>] __cpufreq_remove_dev.isra.13+0x183/0x450
[  135.729812]  [<ffffffff81829a76>] ? down_write+0x16/0x40
[  135.735128]  [<ffffffff8181e030>] cpufreq_cpu_callback+0x5d/0x77
[  135.741140]  [<ffffffff8182fa1d>] notifier_call_chain+0x4d/0x70
[  135.747066]  [<ffffffff810cf2ce>] __raw_notifier_call_chain+0xe/0x10
[  135.753422]  [<ffffffff810a8f70>] __cpu_notify+0x20/0x40
[  135.758739]  [<ffffffff8180f5af>] _cpu_down+0x7f/0x270
[  135.763885]  [<ffffffff810a926e>] disable_nonboot_cpus+0x8e/0x120
[  135.769983]  [<ffffffff810bcd7b>] kernel_restart+0x1b/0x60
[  135.775479]  [<ffffffff810bcfa1>] sys_reboot+0x1c1/0x280
[  135.780803]  [<ffffffff811827ae>] ? do_writepages+0x1e/0x40
[  135.786381]  [<ffffffff81177d41>] ? __filemap_fdatawrite_range+0x51/0x60
[  135.793088]  [<ffffffff811f6f78>] ? iput+0x48/0x190
[  135.797982]  [<ffffffff8120b600>] ? sync_inodes_one_sb+0x20/0x20
[  135.803997]  [<ffffffff81215d3f>] ? iterate_bdevs+0xef/0x100
[  135.809665]  [<ffffffff81833fd9>] system_call_fastpath+0x16/0x1b
[  135.815676] ---[ end trace 88437c0ab4adf761 ]---


On 02/01/2013 09:41 PM, Viresh Kumar wrote:
> On Sat, Feb 2, 2013 at 12:15 AM,  <dirk.brandewie@gmail.com> wrote:
>> From: Dirk Brandewie <dirk.brandewie@gmail.com>
>>
>> There is an additional reference added to the driver in
>> cpufreq_add_dev_policy() that is removed in__cpufreq_governor() if the
>> driver implements target().  Remove the last reference when the driver
>> implements setpolicy()
>>
>> Signed-off-by: Dirk Brandewie <dirk.brandewie@gmail.com>
>
> Rebase it on latest work as cpufreq_add_dev_policy() doesn't exist anymore.
>
>> ---
>>   drivers/cpufreq/cpufreq.c |    3 +++
>>   1 files changed, 3 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
>> index a4fd51e..ec103bf 100644
>> --- a/drivers/cpufreq/cpufreq.c
>> +++ b/drivers/cpufreq/cpufreq.c
>> @@ -1119,6 +1119,9 @@ static int __cpufreq_remove_dev(struct device *dev, struct subsys_interface *sif
>>          if (cpufreq_driver->target)
>>                  __cpufreq_governor(data, CPUFREQ_GOV_STOP);
>>
>> +       if (cpufreq_driver->setpolicy)
>> +               cpufreq_cpu_put(data);
>> +
>>          kobj = &data->kobj;
>>          cmp = &data->kobj_unregister;
>>          unlock_policy_rwsem_write(cpu);
>> --
>> 1.7.7.6
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/

