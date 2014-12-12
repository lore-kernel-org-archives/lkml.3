Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030992AbaLLRNv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 12:13:51 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:43529 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030303AbaLLRNt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 12:13:49 -0500
X-SecurityPolicyCheck: OK by SHieldMailChecker v2.0.1
X-SHieldMailCheckerPolicyVersion: FJ-ISEC-20120718-3
Message-ID: <548B221C.40909@jp.fujitsu.com>
Date: Sat, 13 Dec 2014 02:13:00 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Lai Jiangshan <laijs@cn.fujitsu.com>
CC: <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>,
        "Gu, Zheng" <guz.fnst@cn.fujitsu.com>,
        tangchen <tangchen@cn.fujitsu.com>,
        Hiroyuki KAMEZAWA <kamezawa.hiroyu@jp.fujitsu.com>,
        <isimatu.yasuaki@jp.fujitsu.com>
Subject: Re: [PATCH 0/5] workqueue: fix bug when numa mapping is changed
References: <1418379595-6281-1-git-send-email-laijs@cn.fujitsu.com>
In-Reply-To: <1418379595-6281-1-git-send-email-laijs@cn.fujitsu.com>
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
X-SecurityPolicyCheck-GC: OK by FENCE-Mail
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lai,

Thank you for posting the patches. I tried your patches.
But the following kernel panic occurred.

[  889.394087] BUG: unable to handle kernel paging request at 000000020000f3f1
[  889.395005] IP: [<ffffffff8108fe90>] workqueue_cpu_up_callback+0x510/0x740
[  889.395005] PGD 17a83067 PUD 0
[  889.395005] Oops: 0000 [#1] SMP
[  889.395005] Modules linked in: xt_CHECKSUM ip6t_rpfilter ip6t_REJECT nf_reject_ipv6 nf_conntrack_ipv6 nf_defrag_ipv6 ipt_REJECT nf_reject_ipv4 nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack cfg80211 rfkill ebtable_nat ebtable_broute bridge stp llc ebtable_filter ebtables
ip6table_mangle ip6table_security ip6table_raw ip6table_filter ip6_tables iptable_mangle iptable_security iptable_raw iptable_filter ip_tables sg vfat fat x86_pkg_temp_thermal coretemp kvm_intel kvm crct10dif_pclmul crc32_pclmul crc32c_intel ghash_clmulni_intel aesni_intel iTCO_wdt sb_edac
iTCO_vendor_support i2c_i801 lrw gf128mul lpc_ich edac_core glue_helper mfd_core ablk_helper cryptd pcspkr shpchp ipmi_devintf ipmi_si ipmi_msghandler tpm_infineon nfsd auth_rpcgss nfs_acl lockd grace sunrpc uinput xfs libcrc32c sd_mod mgag200 syscopyarea sysfillrect sysimgblt drm_kms_helper igb ttm
e1000e lpfc drm dca ptp i2c_algo_bit megaraid_sas scsi_transport_fc pps_core i2c_core dm_mirror dm_region_hash dm_log dm_mod
[  889.395005] CPU: 8 PID: 13595 Comm: udev_dp_bridge. Not tainted 3.18.0Lai+ #26
[  889.395005] Hardware name: FUJITSU PRIMEQUEST2800E/SB, BIOS PRIMEQUEST 2000 Series BIOS Version 01.81 12/03/2014
[  889.395005] task: ffff8a074a145160 ti: ffff8a077a6ec000 task.ti: ffff8a077a6ec000
[  889.395005] RIP: 0010:[<ffffffff8108fe90>]  [<ffffffff8108fe90>] workqueue_cpu_up_callback+0x510/0x740
[  889.395005] RSP: 0018:ffff8a077a6efca8  EFLAGS: 00010202
[  889.395005] RAX: 0000000000000001 RBX: 000000000000edf1 RCX: 000000000000edf1
[  889.395005] RDX: 0000000000000100 RSI: 000000020000f3f1 RDI: 0000000000000001
[  889.395005] RBP: ffff8a077a6efd08 R08: ffffffff81ac6de0 R09: ffff880874610000
[  889.395005] R10: 00000000ffffffff R11: 0000000000000001 R12: 000000000000f3f0
[  889.395005] R13: 000000000000001f R14: 00000000ffffffff R15: ffffffff81ac6de0
[  889.395005] FS:  00007f6b20c67740(0000) GS:ffff88087fd00000(0000) knlGS:0000000000000000
[  889.395005] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  889.395005] CR2: 000000020000f3f1 CR3: 000000004534c000 CR4: 00000000001407e0
[  889.395005] Stack:
[  889.395005]  ffffffffffffffff 0000000000000020 fffffffffffffff8 00000004810a192d
[  889.395005]  ffff8a0700000204 0000000052f5b32d ffffffff81994fc0 00000000fffffff6
[  889.395005]  ffffffff81a13840 0000000000000002 000000000000001f 0000000000000000
[  889.395005] Call Trace:
[  889.395005]  [<ffffffff81094f6c>] notifier_call_chain+0x4c/0x70
[  889.395005]  [<ffffffff8109507e>] __raw_notifier_call_chain+0xe/0x10
[  889.395005]  [<ffffffff810750b3>] cpu_notify+0x23/0x50
[  889.395005]  [<ffffffff81075408>] _cpu_up+0x188/0x1a0
[  889.395005]  [<ffffffff810754a9>] cpu_up+0x89/0xb0
[  889.395005]  [<ffffffff8164f960>] cpu_subsys_online+0x40/0x90
[  889.395005]  [<ffffffff8140f10d>] device_online+0x6d/0xa0
[  889.395005]  [<ffffffff8140f1d5>] online_store+0x95/0xa0
[  889.395005]  [<ffffffff8140c2e8>] dev_attr_store+0x18/0x30
[  889.395005]  [<ffffffff8126210d>] sysfs_kf_write+0x3d/0x50
[  889.395005]  [<ffffffff81261624>] kernfs_fop_write+0xe4/0x160
[  889.395005]  [<ffffffff811e90d7>] vfs_write+0xb7/0x1f0
[  889.395005]  [<ffffffff81021dcc>] ? do_audit_syscall_entry+0x6c/0x70
[  889.395005]  [<ffffffff811e9bc5>] SyS_write+0x55/0xd0
[  889.395005]  [<ffffffff816646a9>] system_call_fastpath+0x12/0x17
[  889.395005] Code: 44 00 00 83 c7 01 48 63 d7 4c 89 ff e8 3a 2a 28 00 8b 15 78 84 a3 00 89 c7 39 d0 7d 70 48 63 cb 4c 89 e6 48 03 34 cd e0 3a ab 81 <8b> 1e 39 5d bc 74 36 41 39 de 74 0c 48 63 f2 eb c7 0f 1f 80 00
[  889.395005] RIP  [<ffffffff8108fe90>] workqueue_cpu_up_callback+0x510/0x740
[  889.395005]  RSP <ffff8a077a6efca8>
[  889.395005] CR2: 000000020000f3f1
[  889.785760] ---[ end trace 39abbfc9f93402f2 ]---
[  889.790931] Kernel panic - not syncing: Fatal exception
[  889.791931] Kernel Offset: 0x0 from 0xffffffff81000000 (relocation range: 0xffffffff80000000-0xffffffff9fffffff)
[  889.791931] drm_kms_helper: panic occurred, switching back to text console
[  889.815947] ------------[ cut here ]------------
[  889.815947] WARNING: CPU: 8 PID: 64 at arch/x86/kernel/smp.c:124 native_smp_send_reschedule+0x5d/0x60()
[  889.815947] Modules linked in: xt_CHECKSUM ip6t_rpfilter ip6t_REJECT nf_reject_ipv6 nf_conntrack_ipv6 nf_defrag_ipv6 ipt_REJECT nf_reject_ipv4 nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack cfg80211 rfkill ebtable_nat ebtable_broute bridge stp llc ebtable_filter ebtables
ip6table_mangle ip6table_security ip6table_raw ip6table_filter ip6_tables iptable_mangle iptable_security iptable_raw iptable_filter ip_tables sg vfat fat x86_pkg_temp_thermal coretemp kvm_intel kvm crct10dif_pclmul crc32_pclmul crc32c_intel ghash_clmulni_intel aesni_intel iTCO_wdt sb_edac
iTCO_vendor_support i2c_i801 lrw gf128mul lpc_ich edac_core glue_helper mfd_core ablk_helper cryptd pcspkr shpchp ipmi_devintf ipmi_si ipmi_msghandler tpm_infineon nfsd auth_rpcgss nfs_acl lockd grace sunrpc uinput xfs libcrc32c sd_mod mgag200 syscopyarea sysfillrect sysimgblt drm_kms_helper igb ttm
e1000e lpfc drm dca ptp i2c_algo_bit megaraid_sas scsi_transport_fc pps_core i2c_core dm_mirror dm_region_hash dm_log dm_mod
[  889.815947] CPU: 8 PID: 64 Comm: migration/8 Tainted: G      D        3.18.0Lai+ #26
[  889.815947] Hardware name: FUJITSU PRIMEQUEST2800E/SB, BIOS PRIMEQUEST 2000 Series BIOS Version 01.81 12/03/2014
[  889.815947]  0000000000000000 00000000f7f40529 ffff88087fd03d38 ffffffff8165c8d4
[  889.815947]  0000000000000000 0000000000000000 ffff88087fd03d78 ffffffff81074eb1
[  889.815947]  ffff88087fd03d78 0000000000000000 ffff88087fc13840 0000000000000008
[  889.815947] Call Trace:
[  889.815947]  <IRQ>  [<ffffffff8165c8d4>] dump_stack+0x46/0x58
[  889.815947]  [<ffffffff81074eb1>] warn_slowpath_common+0x81/0xa0
[  889.815947]  [<ffffffff81074fca>] warn_slowpath_null+0x1a/0x20
[  889.815947]  [<ffffffff810489bd>] native_smp_send_reschedule+0x5d/0x60
[  889.815947]  [<ffffffff810b0ad4>] trigger_load_balance+0x144/0x1b0
[  889.815947]  [<ffffffff810a009f>] scheduler_tick+0x9f/0xe0
[  889.815947]  [<ffffffff810daef4>] update_process_times+0x64/0x80
[  889.815947]  [<ffffffff810eab05>] tick_sched_handle.isra.19+0x25/0x60
[  889.815947]  [<ffffffff810eab85>] tick_sched_timer+0x45/0x80
[  889.815947]  [<ffffffff810dbbe7>] __run_hrtimer+0x77/0x1d0
[  889.815947]  [<ffffffff810eab40>] ? tick_sched_handle.isra.19+0x60/0x60
[  889.815947]  [<ffffffff810dbfd7>] hrtimer_interrupt+0xf7/0x240
[  889.815947]  [<ffffffff8104b85b>] local_apic_timer_interrupt+0x3b/0x70
[  889.815947]  [<ffffffff81667465>] smp_apic_timer_interrupt+0x45/0x60
[  889.815947]  [<ffffffff8166553d>] apic_timer_interrupt+0x6d/0x80
[  889.815947]  <EOI>  [<ffffffff810a79c7>] ? set_next_entity+0x67/0x80
[  889.815947]  [<ffffffffa011d1d7>] ? __drm_modeset_lock_all+0x37/0x120 [drm]
[  889.815947]  [<ffffffff8109c727>] ? finish_task_switch+0x57/0x180
[  889.815947]  [<ffffffff8165fba8>] __schedule+0x2e8/0x7e0
[  889.815947]  [<ffffffff816600c9>] schedule+0x29/0x70
[  889.815947]  [<ffffffff81097d43>] smpboot_thread_fn+0xd3/0x1b0
[  889.815947]  [<ffffffff81097c70>] ? SyS_setgroups+0x1a0/0x1a0
[  889.815947]  [<ffffffff81093df1>] kthread+0xe1/0x100
[  889.815947]  [<ffffffff81093d10>] ? kthread_create_on_node+0x1b0/0x1b0
[  889.815947]  [<ffffffff816645fc>] ret_from_fork+0x7c/0xb0
[  889.815947]  [<ffffffff81093d10>] ? kthread_create_on_node+0x1b0/0x1b0
[  889.815947] ---[ end trace 39abbfc9f93402f3 ]---
[  890.156187] ------------[ cut here ]------------
[  890.156187] WARNING: CPU: 8 PID: 64 at arch/x86/kernel/smp.c:124 native_smp_send_reschedule+0x5d/0x60()
[  890.156187] Modules linked in: xt_CHECKSUM ip6t_rpfilter ip6t_REJECT nf_reject_ipv6 nf_conntrack_ipv6 nf_defrag_ipv6 ipt_REJECT nf_reject_ipv4 nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack cfg80211 rfkill ebtable_nat ebtable_broute bridge stp llc ebtable_filter ebtables
ip6table_mangle ip6table_security ip6table_raw ip6table_filter ip6_tables iptable_mangle iptable_security iptable_raw iptable_filter ip_tables sg vfat fat x86_pkg_temp_thermal coretemp kvm_intel kvm crct10dif_pclmul crc32_pclmul crc32c_intel ghash_clmulni_intel aesni_intel iTCO_wdt sb_edac
iTCO_vendor_support i2c_i801 lrw gf128mul lpc_ich edac_core glue_helper mfd_core ablk_helper cryptd pcspkr shpchp ipmi_devintf ipmi_si ipmi_msghandler tpm_infineon nfsd auth_rpcgss nfs_acl lockd grace sunrpc uinput xfs libcrc32c sd_mod mgag200 syscopyarea sysfillrect sysimgblt drm_kms_helper igb ttm
e1000e lpfc drm dca ptp i2c_algo_bit megaraid_sas scsi_transport_fc pps_core i2c_core dm_mirror dm_region_hash dm_log dm_mod
[  890.156187] CPU: 8 PID: 64 Comm: migration/8 Tainted: G      D W      3.18.0Lai+ #26
[  890.156187] Hardware name: FUJITSU PRIMEQUEST2800E/SB, BIOS PRIMEQUEST 2000 Series BIOS Version 01.81 12/03/2014
[  890.156187]  0000000000000000 00000000f7f40529 ffff88087366bc08 ffffffff8165c8d4
[  890.156187]  0000000000000000 0000000000000000 ffff88087366bc48 ffffffff81074eb1
[  890.156187]  ffff88087fd142c0 0000000000000044 ffff8a074a145160 ffff8a074a145160
[  890.156187] Call Trace:
[  890.156187]  [<ffffffff8165c8d4>] dump_stack+0x46/0x58
[  890.156187]  [<ffffffff81074eb1>] warn_slowpath_common+0x81/0xa0
[  890.156187]  [<ffffffff81074fca>] warn_slowpath_null+0x1a/0x20
[  890.156187]  [<ffffffff810489bd>] native_smp_send_reschedule+0x5d/0x60
[  890.156187]  [<ffffffff8109ddd8>] resched_curr+0xa8/0xd0
[  890.156187]  [<ffffffff8109eac0>] check_preempt_curr+0x80/0xa0
[  890.156187]  [<ffffffff810a78c8>] attach_task+0x48/0x50
[  890.156187]  [<ffffffff810a7ae5>] active_load_balance_cpu_stop+0x105/0x250
[  890.156187]  [<ffffffff810a79e0>] ? set_next_entity+0x80/0x80
[  890.156187]  [<ffffffff8110cab8>] cpu_stopper_thread+0x78/0x150
[  890.156187]  [<ffffffff8165fba8>] ? __schedule+0x2e8/0x7e0
[  890.156187]  [<ffffffff81097d6f>] smpboot_thread_fn+0xff/0x1b0
[  890.156187]  [<ffffffff81097c70>] ? SyS_setgroups+0x1a0/0x1a0
[  890.156187]  [<ffffffff81093df1>] kthread+0xe1/0x100
[  890.156187]  [<ffffffff81093d10>] ? kthread_create_on_node+0x1b0/0x1b0
[  890.156187]  [<ffffffff816645fc>] ret_from_fork+0x7c/0xb0
[  890.156187]  [<ffffffff81093d10>] ? kthread_create_on_node+0x1b0/0x1b0
[  890.156187] ---[ end trace 39abbfc9f93402f4 ]---

Thanks,
Yasuaki Ishimatsu

(2014/12/12 19:19), Lai Jiangshan wrote:
> Workqueue code has an assumption that the numa mapping is stable
> after system booted.  It is incorrectly currently.
> 
> Yasuaki Ishimatsu hit a allocation failure bug when the numa mapping
> between CPU and node is changed. This was the last scene:
>   SLUB: Unable to allocate memory on node 2 (gfp=0x80d0)
>    cache: kmalloc-192, object size: 192, buffer size: 192, default order: 1, min order: 0
>    node 0: slabs: 6172, objs: 259224, free: 245741
>    node 1: slabs: 3261, objs: 136962, free: 127656
> 
> Yasuaki Ishimatsu investigated that it happened in the following situation:
> 
> 1) System Node/CPU before offline/online:
> 	       | CPU
> 	------------------------
> 	node 0 |  0-14, 60-74
> 	node 1 | 15-29, 75-89
> 	node 2 | 30-44, 90-104
> 	node 3 | 45-59, 105-119
> 
> 2) A system-board (contains node2 and node3) is offline:
> 	       | CPU
> 	------------------------
> 	node 0 |  0-14, 60-74
> 	node 1 | 15-29, 75-89
> 
> 3) A new system-board is online, two new node IDs are allocated
>     for the two node of the SB, but the old CPU IDs are allocated for
>     the SB, here the NUMA mapping between node and CPU is changed.
>     (the node of CPU#30 is changed from node#2 to node#4, for example)
> 	       | CPU
> 	------------------------
> 	node 0 |  0-14, 60-74
> 	node 1 | 15-29, 75-89
> 	node 4 | 30-59
> 	node 5 | 90-119
> 
> 4) now, the NUMA mapping is changed, but wq_numa_possible_cpumask
>     which is the convenient NUMA mapping cache in workqueue.c is still outdated.
>     thus pool->node calculated by get_unbound_pool() is incorrect.
> 
> 5) when the create_worker() is called with the incorrect offlined
>      pool->node, it is failed and the pool can't make any progress.
> 
> To fix this bug, we need to fixup the wq_numa_possible_cpumask and the
> pool->node, it is done in patch2 and patch3.
> 
> patch1 fixes memory leak related wq_numa_possible_cpumask.
> patch4 kill another assumption about how the numa mapping changed.
> patch5 reduces the allocation fails when the node is offline or the node
> is lack of memory.
> 
> The patchset is untested. It is sent for earlier review.
> 
> Thanks,
> Lai.
> 
> Reported-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
> Cc: "Gu, Zheng" <guz.fnst@cn.fujitsu.com>
> Cc: tangchen <tangchen@cn.fujitsu.com>
> Cc: Hiroyuki KAMEZAWA <kamezawa.hiroyu@jp.fujitsu.com>
> Lai Jiangshan (5):
>    workqueue: fix memory leak in wq_numa_init()
>    workqueue: update wq_numa_possible_cpumask
>    workqueue: fixup existing pool->node
>    workqueue: update NUMA affinity for the node lost CPU
>    workqueue: retry on NUMA_NO_NODE when create_worker() fails
> 
>   kernel/workqueue.c |  129 ++++++++++++++++++++++++++++++++++++++++++++--------
>   1 files changed, 109 insertions(+), 20 deletions(-)
> 


