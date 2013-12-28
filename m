Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751317Ab3L1VME (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Dec 2013 16:12:04 -0500
Received: from reverse.openmailbox.org ([62.210.189.180]:52479 "EHLO
	mail.openmailbox.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751210Ab3L1VMB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Dec 2013 16:12:01 -0500
X-Greylist: delayed 487 seconds by postgrey-1.27 at vger.kernel.org; Sat, 28 Dec 2013 16:12:01 EST
Message-ID: <52BF3CB2.5020703@openmailbox.org>
Date: Sat, 28 Dec 2013 22:03:46 +0100
From: Stefan Beller <stefanbeller@openmailbox.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: open list <linux-kernel@vger.kernel.org>
Subject: Watchdog detected hard LOCKUP on cpu 0 on FITPC2
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I noticed a machine to hang after a few days of uptime,
i.e. the USB, networking etc are all gone, but the machine is still up
and displaying the login screen.

I am running 
	$ uname -a
Linux sd 3.12.5-302.fc20.i686 #1 SMP Tue Dec 17 21:01:18 UTC 2013 i686 i686 i386 GNU/Linux

Today I got these messages:

[108655.024413] ------------[ cut here ]------------
[108655.024413] WARNING: CPU: 0 PID: 0 at kernel/watchdog.c:272 watchdog_overflow_callback+0xac/0xd0()
[108655.024413] Watchdog detected hard LOCKUP on cpu 0
[108655.024413] Modules linked in:
[108655.024413]  fuse nf_conntrack_netbios_ns nf_conntrack_broadcast ipt_MASQUERADE bnep ip6t_REJECT bluetooth xt_conntrack ebtable_nat ebtable_broute bridge stp llc ebtable_filter ebtables ip6table_nat nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6 ip6table_mangle ip6table_security ip6table_raw ip6table_filter ip6_tables iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack iptable_mangle iptable_security iptable_raw arc4 snd_hda_codec_realtek rt2800pci rt2800lib rt2x00pci rt2x00mmio snd_hda_intel rt2x00lib snd_hda_codec eeprom_93cx6 mac80211 coretemp snd_hwdep kvm_intel snd_seq cfg80211 snd_seq_device kvm i2c_isch snd_pcm crc_ccitt rfkill lirc_igorplugusb(C) r8169 snd_page_alloc lirc_dev gpio_sch microcode rc_core snd_timer mii snd sdhci_pci soundcore serio_raw sdhci lpc_sch mmc_core
[108655.024413]  acpi_cpufreq nfsd auth_rpcgss nfs_acl lockd sunrpc ata_generic pata_acpi gma500_gfx i2c_algo_bit drm_kms_helper pata_sch drm i2c_core video
[108655.024413] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G         C   3.12.5-302.fc20.i686 #1
[108655.024413] Hardware name: CompuLab SBC-FITPC2/SBC-FITPC2, BIOS NAPA0001.86C.0000.D.0912241315 12/24/2009
[108655.024413]  00000000 00000000 f580bc68 c0993d22 f580bca8 f580bc98 c04484be c0b340d4
[108655.024413]  f580bcc4 00000000 c0b3d684 00000110 c04ccc6c c04ccc6c c04ccbc0 0000000d
[108655.024413]  f580e800 f580bcb0 c0448513 00000009 f580bca8 c0b340d4 f580bcc4 f580bcc8
[108655.024413] Call Trace:
[108655.024413]  [<c0993d22>] dump_stack+0x41/0x52
[108655.024413]  [<c04484be>] warn_slowpath_common+0x7e/0xa0
[108655.024413]  [<c04ccc6c>] ? watchdog_overflow_callback+0xac/0xd0
[108655.024413]  [<c04ccc6c>] ? watchdog_overflow_callback+0xac/0xd0
[108655.024413]  [<c04ccbc0>] ? restart_watchdog_hrtimer+0x50/0x50
[108655.024413]  [<c0448513>] warn_slowpath_fmt+0x33/0x40
[108655.024413]  [<c04ccc6c>] watchdog_overflow_callback+0xac/0xd0
[108655.024413]  [<c04fca3d>] __perf_event_overflow+0xad/0x340
[108655.024413]  [<c0414b76>] ? x86_perf_event_set_period+0x136/0x230
[108655.024413]  [<c04fd2a5>] perf_event_overflow+0x15/0x20
[108655.024413]  [<c041a5e5>] intel_pmu_handle_irq+0x1d5/0x3d0
[108655.024413]  [<c045d20e>] ? insert_work+0x4e/0x80
[108655.024413]  [<c099b9bc>] perf_event_nmi_handler+0x2c/0x50
[108655.024413]  [<c099b197>] nmi_handle.isra.2+0x57/0x1a0
[108655.024413]  [<c099b4bf>] do_nmi+0x1df/0x3e0
[108655.024413]  [<c099a8cb>] nmi_stack_correct+0x2f/0x34
[108655.024413]  [<c0498bc1>] ? __getnstimeofday+0xd1/0x110
[108655.024413]  [<c0498c0d>] getnstimeofday+0xd/0x30
[108655.024413]  [<c0498c86>] ktime_get_real+0x16/0x30
[108655.024413]  [<c08a258c>] ? build_skb+0x2c/0x1c0
[108655.024413]  [<c08b0a3e>] netif_receive_skb+0x4e/0x90
[108655.024413]  [<c08b1287>] napi_gro_receive+0x67/0x90
[108655.024413]  [<c04083c0>] ? text_poke_bp+0xb0/0xb0
[108655.024413]  [<f86c7665>] rtl8169_poll+0x115/0x4c4 [r8169]
[108655.024413]  [<c044d42a>] ? irq_exit+0x6a/0xa0
[108655.024413]  [<c08b0cf8>] net_rx_action+0x118/0x1f0
[108655.024413]  [<c044d1d9>] __do_softirq+0xc9/0x1e0
[108655.024413]  [<c044d110>] ? cpu_callback+0x170/0x170
[108655.024413]  <IRQ>  [<c044d455>] ? irq_exit+0x95/0xa0
[108655.024413]  [<c0404605>] ? do_IRQ+0x45/0xb0
[108655.024413]  [<c04a0505>] ? tick_broadcast_oneshot_control+0x75/0x190
[108655.024413]  [<c09a1473>] ? common_interrupt+0x33/0x38
[108655.024413]  [<c049007b>] ? vprintk_emit+0x34b/0x520
[108655.024413]  [<c086b25e>] ? cpuidle_enter_state+0x3e/0xd0
[108655.024413]  [<c086b38e>] ? cpuidle_idle_call+0x9e/0x1d0
[108655.024413]  [<c040a8ed>] ? arch_cpu_idle+0xd/0x30
[108655.024413]  [<c0491801>] ? cpu_startup_entry+0x1c1/0x210
[108655.024413]  [<c098cb72>] ? rest_init+0x62/0x70
[108655.024413]  [<c0c87a9b>] ? start_kernel+0x397/0x39d
[108655.024413]  [<c0c8753b>] ? repair_env_string+0x51/0x51
[108655.024413]  [<c0c87378>] ? i386_start_kernel+0x12e/0x131
[108655.024413] ---[ end trace 0acea8149765c74f ]---
[111408.293304] INFO: rcu_sched detected stalls on CPUs/tasks: { 1} (detected by 0, t=106514 jiffies, g=357439, c=357438, q=1)
[111408.293347] sending NMI to all CPUs:
[111408.293374] NMI backtrace for cpu 0
[111408.293394] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G        WC   3.12.5-302.fc20.i686 #1
[111408.293406] Hardware name: CompuLab SBC-FITPC2/SBC-FITPC2, BIOS NAPA0001.86C.0000.D.0912241315 12/24/2009
[111408.293422] task: c0c03980 ti: f5808000 task.ti: c0bf8000
[111408.293436] EIP: 0060:[<c0430184>] EFLAGS: 00200082 CPU: 0
[111408.293464] EIP is at arch_trigger_all_cpu_backtrace+0x64/0x80
[111408.293477] EAX: 00000003 EBX: 00002710 ECX: fffff000 EDX: fffff000
[111408.293490] ESI: c0c1f040 EDI: f6bee200 EBP: f5809e44 ESP: f5809e3c
[111408.293503]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[111408.293517] CR0: 8005003b CR2: b777e000 CR3: 00d44000 CR4: 000007d0
[111408.293527] Stack:
[111408.293537]  c0b23d86 00000001 f5809e88 c04cfe0f c0b34258 00000000 0001a012 0005743f
[111408.293572]  0005743e 00000001 f6bee200 00200083 00000001 f5808000 00000000 c0c1f040
[111408.293604]  c0c03980 00000000 00000000 f5809e9c c04542ac f580bf7c f6bee038 f6beda40
[111408.293636] Call Trace:
[111408.293665]  [<c04cfe0f>] rcu_check_callbacks+0x4cf/0x510
[111408.293693]  [<c04542ac>] update_process_times+0x3c/0x70
[111408.293719]  [<c04a1156>] tick_sched_handle.isra.12+0x26/0x60
[111408.293739]  [<c04a11c7>] tick_sched_timer+0x37/0x70
[111408.293759]  [<c0467db8>] ? __remove_hrtimer+0x38/0x90
[111408.293778]  [<c0467ffd>] __run_hrtimer+0x6d/0x190
[111408.293799]  [<c04a1190>] ? tick_sched_handle.isra.12+0x60/0x60
[111408.293818]  [<c0468bf8>] hrtimer_interrupt+0x1e8/0x2a0
[111408.293842]  [<c049ff2b>] tick_do_broadcast.constprop.6+0x6b/0x70
[111408.293863]  [<c04a00d5>] tick_handle_oneshot_broadcast+0x105/0x180
[111408.293887]  [<c0405142>] timer_interrupt+0x12/0x20
[111408.293908]  [<c0492015>] handle_irq_event_percpu+0x35/0x1a0
[111408.293929]  [<c04949e0>] ? unmask_irq+0x30/0x30
[111408.293949]  [<c04921aa>] handle_irq_event+0x2a/0x50
[111408.293968]  [<c04943c0>] ? handle_simple_irq+0x70/0x70
[111408.293987]  [<c0494426>] handle_edge_irq+0x66/0x100
[111408.293998]  <IRQ> 

[111408.294024]  [<c04045fc>] ? do_IRQ+0x3c/0xb0
[111408.294041]  [<c04cd6e3>] ? rcu_report_qs_rnp+0x63/0x110
[111408.294066]  [<c09a1473>] ? common_interrupt+0x33/0x38
[111408.294089]  [<c045007b>] ? file_ns_capable+0x3b/0x50
[111408.294108]  [<c044d18d>] ? __do_softirq+0x7d/0x1e0
[111408.294128]  [<c044d110>] ? cpu_callback+0x170/0x170
[111408.294138]  <IRQ> 

[111408.294161]  [<c044d455>] ? irq_exit+0x95/0xa0
[111408.294178]  [<c0404605>] ? do_IRQ+0x45/0xb0
[111408.294189]  [<c04a0505>] ? tick_broadcast_oneshot_control+0x75/0x190
[111408.294189]  [<c09a1473>] ? common_interrupt+0x33/0x38
[111408.294189]  [<c049007b>] ? vprintk_emit+0x34b/0x520
[111408.294189]  [<c086b25e>] ? cpuidle_enter_state+0x3e/0xd0
[111408.294189]  [<c086b38e>] ? cpuidle_idle_call+0x9e/0x1d0
[111408.294189]  [<c040a8ed>] ? arch_cpu_idle+0xd/0x30
[111408.294189]  [<c0491801>] ? cpu_startup_entry+0x1c1/0x210
[111408.294189]  [<c098cb72>] ? rest_init+0x62/0x70
[111408.294189]  [<c0c87a9b>] ? start_kernel+0x397/0x39d
[111408.294189]  [<c0c8753b>] ? repair_env_string+0x51/0x51
[111408.294189]  [<c0c87378>] ? i386_start_kernel+0x12e/0x131
[111408.294189] Code: e8 95 10 56 00 8b 15 20 db c0 c0 b8 02 00 00 00 ff 52 7c eb 11 66 90 b8 58 89 41 00 e8 f6 a2 25 00 83 eb 01 74 09 a1 e0 1a c8 c0 <85> c0 75 e8 f0 80 25 d4 e9 d4 c0 fe eb a9 66 90 66 90 66 90 66
[111301.780024] NMI backtrace for cpu 1
[111408.294189] INFO: NMI handler (arch_trigger_all_cpu_backtrace_handler) took too long to run: 1.256 msecs
[111301.780024] CPU: 1 PID: 0 Comm: swapper/1 Tainted: G        WC   3.12.5-302.fc20.i686 #1
[111301.780024] Hardware name: CompuLab SBC-FITPC2/SBC-FITPC2, BIOS NAPA0001.86C.0000.D.0912241315 12/24/2009
[111301.780024] task: f5856d00 ti: f58c8000 task.ti: f58c8000
[111301.780024] EIP: 0060:[<c049171d>] EFLAGS: 00200246 CPU: 1
[111301.780024] EIP is at cpu_startup_entry+0xdd/0x210
[111301.780024] EAX: 00000000 EBX: 8cb62ac4 ECX: 01000000 EDX: 00000000
[111301.780024] ESI: 00000000 EDI: f58c8000 EBP: f58c9f90 ESP: f58c9f74
[111301.780024]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[111301.780024] CR0: 8005003b CR2: b777e000 CR3: 00d44000 CR4: 000007d0
[111301.780024] Stack:
[111301.780024]  f58c9f88 00000001 1f40a1f8 8cb62ac4 77436bab 00000000 00000000 f58c9fb4
[111301.780024]  c042c538 00000000 00000000 00000000 00000000 d5b399e3 77436bab 01020800
[111301.780024]  00000000 00000000 00000000 00000000 00000000 00000000 00000000 0000007b
[111301.780024] Call Trace:
[111301.780024]  [<c042c538>] start_secondary+0x208/0x2d0
[111301.780024] Code: ce 03 00 64 a1 10 30 d3 c0 89 45 e8 66 90 3e 8d 74 26 00 fb 90 8d 74 26 00 8b 47 08 a8 08 75 0f 8d b6 00 00 00 00 f3 90 8b 47 08 <a8> 08 74 f7 64 a1 10 30 d3 c0 89 45 e8 3e 8d 74 26 00 e8 9c cd
[111301.780024] INFO: NMI handler (arch_trigger_all_cpu_backtrace_handler) took too long to run: 1.772 msecs
[114527.956742] INFO: rcu_sched self-detected stall on CPU { 0}  (t=157236 jiffies g=359221 c=359220 q=1)
[114527.956783] sending NMI to all CPUs:
[114527.956811] NMI backtrace for cpu 0
[114527.956831] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G        WC   3.12.5-302.fc20.i686 #1
[114527.956843] Hardware name: CompuLab SBC-FITPC2/SBC-FITPC2, BIOS NAPA0001.86C.0000.D.0912241315 12/24/2009
[114527.956859] task: c0c03980 ti: f5808000 task.ti: c0bf8000
[114527.956873] EIP: 0060:[<c0430184>] EFLAGS: 00200082 CPU: 0
[114527.956900] EIP is at arch_trigger_all_cpu_backtrace+0x64/0x80
[114527.956914] EAX: 00000003 EBX: 00002710 ECX: fffff000 EDX: fffff000
[114527.956927] ESI: c0c1f040 EDI: f6bee200 EBP: f5809e44 ESP: f5809e3c
[114527.956940]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[114527.956954] CR0: 8005003b CR2: b777e000 CR3: 00d44000 CR4: 000007d0
[114527.956964] Stack:
[114527.956974]  c0b23d86 00000001 f5809e88 c04cfbcb c0b34208 00026634 00057b35 00057b34
[114527.957009]  00000001 00000000 00000000 9bea44ac 00000024 f5808000 00000000 c0c1f040
[114527.957041]  c0c03980 00000000 00000000 f5809e9c c04542ac f580bf7c f6bee038 f6beda40
[114527.957073] Call Trace:
[114527.957102]  [<c04cfbcb>] rcu_check_callbacks+0x28b/0x510
[114527.957129]  [<c04542ac>] update_process_times+0x3c/0x70
[114527.957155]  [<c04a1156>] tick_sched_handle.isra.12+0x26/0x60
[114527.957175]  [<c04a11c7>] tick_sched_timer+0x37/0x70
[114527.957194]  [<c0467db8>] ? __remove_hrtimer+0x38/0x90
[114527.957213]  [<c0467ffd>] __run_hrtimer+0x6d/0x190
[114527.957234]  [<c04a1190>] ? tick_sched_handle.isra.12+0x60/0x60
[114527.957254]  [<c0468bf8>] hrtimer_interrupt+0x1e8/0x2a0
[114527.957277]  [<c049ff2b>] tick_do_broadcast.constprop.6+0x6b/0x70
[114527.957297]  [<c04a00d5>] tick_handle_oneshot_broadcast+0x105/0x180
[114527.957321]  [<c0405142>] timer_interrupt+0x12/0x20
[114527.957342]  [<c0492015>] handle_irq_event_percpu+0x35/0x1a0
[114527.957363]  [<c04949e0>] ? unmask_irq+0x30/0x30
[114527.957383]  [<c04921aa>] handle_irq_event+0x2a/0x50
[114527.957402]  [<c04943c0>] ? handle_simple_irq+0x70/0x70
[114527.957421]  [<c0494426>] handle_edge_irq+0x66/0x100
[114527.957430]  <IRQ> 

[114527.957456]  [<c04045fc>] ? do_IRQ+0x3c/0xb0
[114527.957473]  [<c04ce155>] ? __note_gp_changes+0x45/0x50
[114527.957499]  [<c09a1473>] ? common_interrupt+0x33/0x38
[114527.957520]  [<c044d18d>] ? __do_softirq+0x7d/0x1e0
[114527.957540]  [<c044d110>] ? cpu_callback+0x170/0x170
[114527.957550]  <IRQ> 

[114527.957574]  [<c044d455>] ? irq_exit+0x95/0xa0
[114527.957591]  [<c0404605>] ? do_IRQ+0x45/0xb0
[114527.957607]  [<c04a0505>] ? tick_broadcast_oneshot_control+0x75/0x190
[114527.957607]  [<c09a1473>] ? common_interrupt+0x33/0x38
[114527.957607]  [<c049007b>] ? vprintk_emit+0x34b/0x520
[114527.957607]  [<c086b25e>] ? cpuidle_enter_state+0x3e/0xd0
[114527.957607]  [<c086b38e>] ? cpuidle_idle_call+0x9e/0x1d0
[114527.957607]  [<c040a8ed>] ? arch_cpu_idle+0xd/0x30
[114527.957607]  [<c0491801>] ? cpu_startup_entry+0x1c1/0x210
[114527.957607]  [<c098cb72>] ? rest_init+0x62/0x70
[114527.957607]  [<c0c87a9b>] ? start_kernel+0x397/0x39d
[114527.957607]  [<c0c8753b>] ? repair_env_string+0x51/0x51
[114527.957607]  [<c0c87378>] ? i386_start_kernel+0x12e/0x131
[114527.957607] Code: e8 95 10 56 00 8b 15 20 db c0 c0 b8 02 00 00 00 ff 52 7c eb 11 66 90 b8 58 89 41 00 e8 f6 a2 25 00 83 eb 01 74 09 a1 e0 1a c8 c0 <85> c0 75 e8 f0 80 25 d4 e9 d4 c0 fe eb a9 66 90 66 90 66 90 66
[114370.721167] NMI backtrace for cpu 1
[114370.721167] CPU: 1 PID: 0 Comm: swapper/1 Tainted: G        WC   3.12.5-302.fc20.i686 #1
[114370.721167] Hardware name: CompuLab SBC-FITPC2/SBC-FITPC2, BIOS NAPA0001.86C.0000.D.0912241315 12/24/2009
[114370.721167] task: f5856d00 ti: f58c8000 task.ti: f58c8000
[114370.721167] EIP: 0060:[<c049171a>] EFLAGS: 00200246 CPU: 1
[114370.721167] EIP is at cpu_startup_entry+0xda/0x210
[114370.721167] EAX: 00000000 EBX: 8cb62ac4 ECX: 01000000 EDX: 00000000
[114370.721167] ESI: 00000000 EDI: f58c8000 EBP: f58c9f90 ESP: f58c9f74
[114370.721167]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[114370.721167] CR0: 8005003b CR2: b777e000 CR3: 00d44000 CR4: 000007d0
[114370.721167] Stack:
[114370.721167]  f58c9f88 00000001 1f40a1f8 8cb62ac4 77436bab 00000000 00000000 f58c9fb4
[114370.721167]  c042c538 00000000 00000000 00000000 00000000 d5b399e3 77436bab 01020800
[114370.721167]  00000000 00000000 00000000 00000000 00000000 00000000 00000000 0000007b
[114370.721167] Call Trace:
[114370.721167]  [<c042c538>] start_secondary+0x208/0x2d0
[114370.721167] Code: 90 e8 7b ce 03 00 64 a1 10 30 d3 c0 89 45 e8 66 90 3e 8d 74 26 00 fb 90 8d 74 26 00 8b 47 08 a8 08 75 0f 8d b6 00 00 00 00 f3 90 <8b> 47 08 a8 08 74 f7 64 a1 10 30 d3 c0 89 45 e8 3e 8d 74 26 00
[114527.959014] INFO: rcu_sched self-detected stall on CPU { 1}  (t=157238 jiffies g=359221 c=359220 q=1)
[159207.204700] INFO: rcu_sched self-detected stall on CPU { 0}  (t=264131 jiffies g=405988 c=405987 q=2)
[159207.204741] sending NMI to all CPUs:
[159207.204769] NMI backtrace for cpu 0
[159207.204788] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G        WC   3.12.5-302.fc20.i686 #1
[159207.204801] Hardware name: CompuLab SBC-FITPC2/SBC-FITPC2, BIOS NAPA0001.86C.0000.D.0912241315 12/24/2009
[159207.204816] task: c0c03980 ti: f5808000 task.ti: c0bf8000
[159207.204831] EIP: 0060:[<c0430184>] EFLAGS: 00200082 CPU: 0
[159207.204858] EIP is at arch_trigger_all_cpu_backtrace+0x64/0x80
[159207.204872] EAX: 00000003 EBX: 00002710 ECX: fffff000 EDX: fffff000
[159207.204885] ESI: c0c1f040 EDI: f6bee200 EBP: f5809e44 ESP: f5809e3c
[159207.204898]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[159207.204911] CR0: 8005003b CR2: b777e000 CR3: 00d44000 CR4: 000007d0
[159207.204922] Stack:
[159207.204931]  c0b23d86 00000002 f5809e88 c04cfbcb c0b34208 000407c3 000631e4 000631e3
[159207.204967]  00000002 00000000 00000000 7f68e489 0000003d f5808000 00000000 c0c1f040
[159207.204999]  c0c03980 00000000 00000000 f5809e9c c04542ac f580bf7c f6bee038 f6beda40
[159207.205031] Call Trace:
[159207.205060]  [<c04cfbcb>] rcu_check_callbacks+0x28b/0x510
[159207.205088]  [<c04542ac>] update_process_times+0x3c/0x70
[159207.205113]  [<c04a1156>] tick_sched_handle.isra.12+0x26/0x60
[159207.205133]  [<c04a11c7>] tick_sched_timer+0x37/0x70
[159207.205153]  [<c0467db8>] ? __remove_hrtimer+0x38/0x90
[159207.205172]  [<c0467ffd>] __run_hrtimer+0x6d/0x190
[159207.205192]  [<c04a1190>] ? tick_sched_handle.isra.12+0x60/0x60
[159207.205212]  [<c0468bf8>] hrtimer_interrupt+0x1e8/0x2a0
[159207.205236]  [<c049ff2b>] tick_do_broadcast.constprop.6+0x6b/0x70
[159207.205256]  [<c04a00d5>] tick_handle_oneshot_broadcast+0x105/0x180
[159207.205280]  [<c0405142>] timer_interrupt+0x12/0x20
[159207.205301]  [<c0492015>] handle_irq_event_percpu+0x35/0x1a0
[159207.205322]  [<c04943c0>] ? handle_simple_irq+0x70/0x70
[159207.205341]  [<c04921aa>] handle_irq_event+0x2a/0x50
[159207.205361]  [<c04943c0>] ? handle_simple_irq+0x70/0x70
[159207.205379]  [<c0494426>] handle_edge_irq+0x66/0x100
[159207.205389]  <IRQ> 

[159207.205416]  [<c04045fc>] ? do_IRQ+0x3c/0xb0
[159207.205434]  [<c04ceed3>] ? rcu_process_callbacks+0x1c3/0x480
[159207.205459]  [<c09a1473>] ? common_interrupt+0x33/0x38
[159207.205481]  [<c044d18d>] ? __do_softirq+0x7d/0x1e0
[159207.205501]  [<c044d110>] ? cpu_callback+0x170/0x170
[159207.205511]  <IRQ> 

[159207.205535]  [<c044d455>] ? irq_exit+0x95/0xa0
[159207.205551]  [<c0404605>] ? do_IRQ+0x45/0xb0
[159207.205552]  [<c04a0505>] ? tick_broadcast_oneshot_control+0x75/0x190
[159207.205552]  [<c09a1473>] ? common_interrupt+0x33/0x38
[159207.205552]  [<c049007b>] ? vprintk_emit+0x34b/0x520
[159207.205552]  [<c086b25e>] ? cpuidle_enter_state+0x3e/0xd0
[159207.205552]  [<c086b38e>] ? cpuidle_idle_call+0x9e/0x1d0
[159207.205552]  [<c040a8ed>] ? arch_cpu_idle+0xd/0x30
[159207.205552]  [<c0491801>] ? cpu_startup_entry+0x1c1/0x210
[159207.205552]  [<c098cb72>] ? rest_init+0x62/0x70
[159207.205552]  [<c0c87a9b>] ? start_kernel+0x397/0x39d
[159207.205552]  [<c0c8753b>] ? repair_env_string+0x51/0x51
[159207.205552]  [<c0c87378>] ? i386_start_kernel+0x12e/0x131
[159207.205552] Code: e8 95 10 56 00 8b 15 20 db c0 c0 b8 02 00 00 00 ff 52 7c eb 11 66 90 b8 58 89 41 00 e8 f6 a2 25 00 83 eb 01 74 09 a1 e0 1a c8 c0 <85> c0 75 e8 f0 80 25 d4 e9 d4 c0 fe eb a9 66 90 66 90 66 90 66
[158943.074137] NMI backtrace for cpu 1
[158943.074137] CPU: 1 PID: 0 Comm: swapper/1 Tainted: G        WC   3.12.5-302.fc20.i686 #1
[158943.074137] Hardware name: CompuLab SBC-FITPC2/SBC-FITPC2, BIOS NAPA0001.86C.0000.D.0912241315 12/24/2009
[158943.074137] task: f5856d00 ti: f58c8000 task.ti: f58c8000
[158943.074137] EIP: 0060:[<c049171a>] EFLAGS: 00200246 CPU: 1
[158943.074137] EIP is at cpu_startup_entry+0xda/0x210
[158943.074137] EAX: 00000000 EBX: 8cb62ac4 ECX: 01000000 EDX: 00000000
[158943.074137] ESI: 00000000 EDI: f58c8000 EBP: f58c9f90 ESP: f58c9f74
[158943.074137]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[158943.074137] CR0: 8005003b CR2: b77c6000 CR3: 00d44000 CR4: 000007d0
[158943.074137] Stack:
[158943.074137]  f58c9f88 00000001 1f40a1f8 8cb62ac4 77436bab 00000000 00000000 f58c9fb4
[158943.074137]  c042c538 00000000 00000000 00000000 00000000 d5b399e3 77436bab 01020800
[158943.074137]  00000000 00000000 00000000 00000000 00000000 00000000 00000000 0000007b
[158943.074137] Call Trace:
[158943.074137]  [<c042c538>] start_secondary+0x208/0x2d0
[158943.074137] Code: 90 e8 7b ce 03 00 64 a1 10 30 d3 c0 89 45 e8 66 90 3e 8d 74 26 00 fb 90 8d 74 26 00 8b 47 08 a8 08 75 0f 8d b6 00 00 00 00 f3 90 <8b> 47 08 a8 08 74 f7 64 a1 10 30 d3 c0 89 45 e8 3e 8d 74 26 00
