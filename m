Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753900AbaBLWWs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 17:22:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57760 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752638AbaBLWWq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 17:22:46 -0500
Date: Wed, 12 Feb 2014 17:22:41 -0500
From: Mike Snitzer <snitzer@redhat.com>
To: Akhil Bhansali <abhansali@stec-inc.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Subject: Re: skd: disable discard support
Message-ID: <20140212222240.GC4265@redhat.com>
References: <20140212221835.GA4265@redhat.com>
 <20140212221940.GB4265@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20140212221940.GB4265@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 12 2014 at  5:19pm -0500,
Mike Snitzer <snitzer@redhat.com> wrote:

> On Wed, Feb 12 2014 at  5:18pm -0500,
> Mike Snitzer <snitzer@redhat.com> wrote:
> 
> > The skd driver has never handled discards reliably.
> > 
> > The kernel will BUG as a result of issuing discards to the skd device.
> > Disable the skd driver's discard support until it is proven reliable.
> 
> Here is the first BUG I recently saw:

And a 2nd:

Kernel panic - not syncing: Watchdog detected hard LOCKUP on cpu 10
CPU: 10 PID: 0 Comm: swapper/10 Tainted: G        W  O 3.14.0-rc1.snitm+ #4
Hardware name: FUJITSU                          PRIMERGY RX300 S6             /D2619, BIOS 6.00 Rev. 1.10.2619.N1           05/24/2011
 0000000000000000 ffff88033fd47bb8 ffffffff8153f180 000000000000fffa
 ffffffff817d8778 ffff88033fd47c38 ffffffff8153ef0d 0000000000000010
 ffff88033fd47c48 ffff88033fd47be8 0000000000000000 0000000000000000
Call Trace:
 <NMI>  [<ffffffff8153f180>] dump_stack+0x49/0x61
 [<ffffffff8153ef0d>] panic+0xbb/0x1d5
 [<ffffffff810e8761>] watchdog_overflow_callback+0xb1/0xc0
 [<ffffffff8111e9b8>] __perf_event_overflow+0x98/0x220
 [<ffffffff8111f2a4>] perf_event_overflow+0x14/0x20
 [<ffffffff8102012e>] intel_pmu_handle_irq+0x1de/0x3c0
 [<ffffffff8115f931>] ? unmap_kernel_range_noflush+0x11/0x20
 [<ffffffff8131a5c5>] ? ghes_copy_tofrom_phys+0xe5/0x200
 [<ffffffff81544e84>] perf_event_nmi_handler+0x34/0x60
 [<ffffffff8154464a>] nmi_handle+0x8a/0x170
 [<ffffffff81544848>] default_do_nmi+0x68/0x210
 [<ffffffff81544a80>] do_nmi+0x90/0xe0
 [<ffffffff81543ca7>] end_repeat_nmi+0x1e/0x2e
 [<ffffffffa06ef7a0>] ? skd_timer_tick_not_online+0x330/0x330 [skd]
 [<ffffffff815432a1>] ? _raw_spin_lock_irqsave+0x21/0x30
 [<ffffffff815432a1>] ? _raw_spin_lock_irqsave+0x21/0x30
 [<ffffffff815432a1>] ? _raw_spin_lock_irqsave+0x21/0x30
 <<EOE>>  <IRQ>  [<ffffffffa06ef7d9>] skd_timer_tick+0x39/0x1e0 [skd]
 [<ffffffff81069480>] ? __queue_work+0x360/0x360
 [<ffffffffa06ef7a0>] ? skd_timer_tick_not_online+0x330/0x330 [skd]
 [<ffffffff8105a318>] call_timer_fn+0x48/0x120
 [<ffffffff8105aef5>] run_timer_softirq+0x225/0x290
 [<ffffffffa06ef7a0>] ? skd_timer_tick_not_online+0x330/0x330 [skd]
 [<ffffffff8105365c>] __do_softirq+0xfc/0x2b0
 [<ffffffff810bc09f>] ? tick_do_update_jiffies64+0x9f/0xd0
 [<ffffffff8105390d>] irq_exit+0xbd/0xd0
 [<ffffffff8154dbea>] smp_apic_timer_interrupt+0x4a/0x5a
 [<ffffffff8154c8ca>] apic_timer_interrupt+0x6a/0x70
 <EOI>  [<ffffffff8144d710>] ? cpuidle_enter_state+0xa0/0xd0
 [<ffffffff8144d6cb>] ? cpuidle_enter_state+0x5b/0xd0
 [<ffffffff8144d887>] cpuidle_idle_call+0xc7/0x160
 [<ffffffff8100cf5e>] arch_cpu_idle+0xe/0x30
 [<ffffffff810a696a>] cpu_idle_loop+0x9a/0x240
 [<ffffffff810b9e64>] ? clockevents_register_device+0xc4/0x130
 [<ffffffff810a6b33>] cpu_startup_entry+0x23/0x30
 [<ffffffff81032d5a>] start_secondary+0x7a/0x80
Shutting down cpus with NMI
Kernel Offset: 0x0 from 0xffffffff81000000 (relocation range: 0xffffffff80000000-0xffffffff9fffffff)
------------[ cut here ]------------
WARNING: CPU: 10 PID: 0 at arch/x86/kernel/smp.c:124 native_smp_send_reschedule+0x5f/0x70()
Modules linked in: skd(O) dm_thin_pool(O) dm_bio_prison(O) dm_persistent_data(O) dm_bufio(O) libcrc32c ebtable_nat ebtables xt_CHECKSUM iptable_mangle bridge autofs4 target_core_iblock target_core_file target_core_pscsi target_core_mod configfs bnx2fc fcoe libfcoe 8021q libfc garp stp scsi_transport_fc llc scsi_tgt sunrpc cpufreq_ondemand ipt_REJECT nf_conntrack_ipv4 nf_defrag_ipv4 iptable_filter ip_tables ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables bnx2i cnic uio ipv6 cxgb4i cxgb4 cxgb3i libcxgbi cxgb3 iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi vhost_net macvtap macvlan vhost tun kvm_intel kvm iTCO_wdt iTCO_vendor_support microcode i2c_i801 lpc_ich mfd_core igb i2c_algo_bit i2c_core i7core_edac edac_core ixgbe dca ptp pps_core mdio ses enclosure sg acpi_cpufreq ext4 jbd2 mbcache sr_mod cdrom pata_acpi ata_generic ata_piix sd_mod crc_t10dif crct10dif_common dm_mirror dm_region_hash dm_log dm_mod megaraid_sas [last unloaded: skd]
CPU: 10 PID: 0 Comm: swapper/10 Tainted: G        W  O 3.14.0-rc1.snitm+ #4
Hardware name: FUJITSU                          PRIMERGY RX300 S6             /D2619, BIOS 6.00 Rev. 1.10.2619.N1           05/24/2011
 000000000000007c ffff88033fd478c0 ffffffff8153f180 000000000000007c
 0000000000000000 ffff88033fd47900 ffffffff8104e9bc ffff88033fd52c40
 ffff88033fc52c40 0000000000000002 ffff88033fd52c40 ffff8803329be250
Call Trace:
 <NMI>  [<ffffffff8153f180>] dump_stack+0x49/0x61
 [<ffffffff8104e9bc>] warn_slowpath_common+0x8c/0xc0
 [<ffffffff8104ea0a>] warn_slowpath_null+0x1a/0x20
 [<ffffffff8103141f>] native_smp_send_reschedule+0x5f/0x70
 [<ffffffff81087e3e>] trigger_load_balance+0x15e/0x200
 [<ffffffff8107ccf7>] scheduler_tick+0xa7/0xe0
 [<ffffffff8105a031>] update_process_times+0x61/0x80
 [<ffffffff8131863c>] ? apei_exec_write_register_value+0x1c/0x20
 [<ffffffff810bbfb9>] tick_sched_handle+0x39/0x80
 [<ffffffff810bc1e4>] tick_sched_timer+0x54/0x90
 [<ffffffff810743be>] __run_hrtimer+0x7e/0x1c0
 [<ffffffff810bc190>] ? tick_nohz_handler+0xc0/0xc0
 [<ffffffff810747ae>] hrtimer_interrupt+0x10e/0x260
 [<ffffffff8103489b>] local_apic_timer_interrupt+0x3b/0x60
 [<ffffffff8154dbe5>] smp_apic_timer_interrupt+0x45/0x5a
 [<ffffffff8154c8ca>] apic_timer_interrupt+0x6a/0x70
 [<ffffffff8153efe4>] ? panic+0x192/0x1d5
 [<ffffffff8153ef42>] ? panic+0xf0/0x1d5
 [<ffffffff810e8761>] watchdog_overflow_callback+0xb1/0xc0
 [<ffffffff8111e9b8>] __perf_event_overflow+0x98/0x220
 [<ffffffff8111f2a4>] perf_event_overflow+0x14/0x20
 [<ffffffff8102012e>] intel_pmu_handle_irq+0x1de/0x3c0
 [<ffffffff8115f931>] ? unmap_kernel_range_noflush+0x11/0x20
 [<ffffffff8131a5c5>] ? ghes_copy_tofrom_phys+0xe5/0x200
 [<ffffffff81544e84>] perf_event_nmi_handler+0x34/0x60
 [<ffffffff8154464a>] nmi_handle+0x8a/0x170
 [<ffffffff81544848>] default_do_nmi+0x68/0x210
 [<ffffffff81544a80>] do_nmi+0x90/0xe0
 [<ffffffff81543ca7>] end_repeat_nmi+0x1e/0x2e
 [<ffffffffa06ef7a0>] ? skd_timer_tick_not_online+0x330/0x330 [skd]
 [<ffffffff815432a1>] ? _raw_spin_lock_irqsave+0x21/0x30
 [<ffffffff815432a1>] ? _raw_spin_lock_irqsave+0x21/0x30
 [<ffffffff815432a1>] ? _raw_spin_lock_irqsave+0x21/0x30
 <<EOE>>  <IRQ>  [<ffffffffa06ef7d9>] skd_timer_tick+0x39/0x1e0 [skd]
 [<ffffffff81069480>] ? __queue_work+0x360/0x360
 [<ffffffffa06ef7a0>] ? skd_timer_tick_not_online+0x330/0x330 [skd]
 [<ffffffff8105a318>] call_timer_fn+0x48/0x120
 [<ffffffff8105aef5>] run_timer_softirq+0x225/0x290
 [<ffffffffa06ef7a0>] ? skd_timer_tick_not_online+0x330/0x330 [skd]
 [<ffffffff8105365c>] __do_softirq+0xfc/0x2b0
 [<ffffffff810bc09f>] ? tick_do_update_jiffies64+0x9f/0xd0
 [<ffffffff8105390d>] irq_exit+0xbd/0xd0
 [<ffffffff8154dbea>] smp_apic_timer_interrupt+0x4a/0x5a
 [<ffffffff8154c8ca>] apic_timer_interrupt+0x6a/0x70
 <EOI>  [<ffffffff8144d710>] ? cpuidle_enter_state+0xa0/0xd0
 [<ffffffff8144d6cb>] ? cpuidle_enter_state+0x5b/0xd0
 [<ffffffff8144d887>] cpuidle_idle_call+0xc7/0x160
 [<ffffffff8100cf5e>] arch_cpu_idle+0xe/0x30
 [<ffffffff810a696a>] cpu_idle_loop+0x9a/0x240
 [<ffffffff810b9e64>] ? clockevents_register_device+0xc4/0x130
 [<ffffffff810a6b33>] cpu_startup_entry+0x23/0x30
 [<ffffffff81032d5a>] start_secondary+0x7a/0x80
---[ end trace 72a22a0dddd989d3 ]---
