Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751854AbaGBJsp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 05:48:45 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:37251 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751563AbaGBJsm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 05:48:42 -0400
From: "Gonglei (Arei)" <arei.gonglei@huawei.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "Huangweidong (C)" <weidong.huang@huawei.com>
Subject: [Question] suse11sp3 32bit guest os panic on kvm 
Thread-Topic: [Question] suse11sp3 32bit guest os panic on kvm 
Thread-Index: Ac+V2rxcYpYx4sdGSey5aKYcEgxq2A==
Date: Wed, 2 Jul 2014 09:48:20 +0000
Message-ID: <33183CC9F5247A488A2544077AF1902086C180A4@SZXEMA503-MBS.china.huawei.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-cr-hashedpuzzle: D9o= Ay73 BMfs B+WZ Crsu D7pF FfQF G/Is HOCY Hqu4 Iuhs
 JJ3g JX2v JlGn Jrfa
 KO5+;1;bABpAG4AdQB4AC0AawBlAHIAbgBlAGwAQAB2AGcAZQByAC4AawBlAHIAbgBlAGwALgBvAHIAZwA=;Sosha1_v1;7;{DAABFB9F-B14D-408E-9750-DD3894A397A3};YQByAGUAaQAuAGcAbwBuAGcAbABlAGkAQABoAHUAYQB3AGUAaQAuAGMAbwBtAA==;Wed,
 02 Jul 2014 09:48:11
 GMT;WwBRAHUAZQBzAHQAaQBvAG4AXQAgAHMAdQBzAGUAMQAxAHMAcAAzACAAMwAyAGIAaQB0ACAAZwB1AGUAcwB0ACAAbwBzACAAcABhAG4AaQBjACAAbwBuACAAawB2AG0A
x-cr-puzzleid: {DAABFB9F-B14D-408E-9750-DD3894A397A3}
x-originating-ip: [10.177.19.102]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
X-Mirapoint-Virus-RAPID-Raw: score=unknown(0),
	refid=str=0001.0A020204.53B3D56E.00C0,ss=1,re=0.000,fgs=0,
	ip=169.254.6.155,
	so=2013-05-26 15:14:31,
	dmn=2011-05-27 18:58:46
X-Mirapoint-Loop-Id: 9fb9fa246aafbe067b3a238e5b33e005
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, all

Recently I encounter a confused issue that described by the title.
I get the dump core according "virsh dump", and this below is the core
Information. It seem as that the vcpu deadlock between irqbalance
process(_raw_spin_lock_irqsave) and an interrupt handle
(_raw_spin_lock), I'm so confused. 

Any suggestions will be appreciated!

crash> log
[...]
[71434.017632] sd 0:0:0:0: [sda] abort
[71428.004077] Kernel panic - not syncing: Watchdog detected hard LOCKUP on cpu 2
[71428.004077] Pid: 9846, comm: irqbalance Tainted: G           N  3.0.76-0.11-default #1
[71428.004077] Call Trace:
[71428.004077]  [<c0205741>] try_stack_unwind+0x1a1/0x1b0
[71428.004077]  [<c0204727>] dump_trace+0x47/0x110
[71428.004077]  [<c02052cb>] show_trace_log_lvl+0x4b/0x60
[71428.004077]  [<c02052f8>] show_trace+0x18/0x20
[71428.004077]  [<c05ca598>] dump_stack+0x6d/0x72
[71428.004077]  [<c05ca5f4>] panic+0x57/0x196
[71428.004077]  [<c02a3d8e>] watchdog_overflow_callback+0xae/0xb0
[71428.004077]  [<c02cba77>] __perf_event_overflow+0xc7/0x290
[71428.004077]  [<c02cc302>] perf_event_overflow+0x12/0x20
[71428.004077]  [<c0214c29>] intel_pmu_handle_irq+0x199/0x320
[71428.004077]  [<c05cef56>] perf_event_nmi_handler+0x26/0x80
[71428.004077]  [<c05d0a96>] notifier_call_chain+0x36/0x60
[71428.004077]  [<c05d0adb>] __atomic_notifier_call_chain+0x1b/0x20
[71428.004077]  [<c05d0af7>] atomic_notifier_call_chain+0x17/0x20
[71428.004077]  [<c05d0b30>] notify_die+0x30/0x40
[71428.004077]  [<c05ce4a0>] default_do_nmi+0x30/0x280
[71428.004077]  [<c05ce74f>] do_nmi+0x5f/0x70
[71428.004077]  [<c05cdeb9>] nmi_stack_correct+0x28/0x2d
[71428.004077]  [<c05ccebe>] _raw_spin_lock_irqsave+0x2e/0x50
[71428.004077]  [<c02a76df>] show_interrupts+0xff/0x2f0
[71428.004077]  [<c0337cd0>] seq_read+0x150/0x360
[71428.004077]  [<c0366c50>] proc_reg_read+0x60/0x90
[71428.004077]  [<c031b9fb>] vfs_read+0x9b/0x110
[71428.004077]  [<c031bb41>] sys_read+0x41/0x80
[71428.004077]  [<c05d401c>] sysenter_do_call+0x12/0x28
[71428.004077]  [<ffffe430>] 0xffffe42f
[71428.004077] ------------[ cut here ]------------
[71428.004077] kernel BUG at /usr/src/packages/BUILD/kernel-default-3.0.76/linux-3.0/mm/vmalloc.c:1314!
[71428.004077] invalid opcode: 0000 [#1] SMP 
[71428.004077] Modules linked in: edd mperf af_packet fuse loop dm_mod joydev usbhid hid sr_mod acpiphp ipv6 ipv6_lib floppy i2c_pii
x4 cdrom pci_hotplug rtc_cmos pcspkr sg button ext3 jbd mbcache ttm drm_kms_helper drm i2c_core sysimgblt sysfillrect syscopyarea uh
ci_hcd ehci_hcd processor sd_mod crc_t10dif usbcore intel_agp thermal_sys hwmon usb_common intel_gtt scsi_dh_alua scsi_dh_emc scsi_d
h_hp_sw scsi_dh_rdac scsi_dh ata_generic ata_piix libata pv_channel(N) virtio_net virtio_blk virtio_pci virtio_scsi scsi_mod virtio_
console virtio virtio_ring kvm_ivshmem(N)
[71428.004077] Supported: No, Unsupported modules are loaded
[71428.004077] 
[71428.004077] Pid: 9846, comm: irqbalance Tainted: G           N  3.0.76-0.11-default #1 Bochs Bochs
[71428.004077] EIP: 0060:[<c02fceec>] EFLAGS: 00010006 CPU: 2
[71428.004077] EIP is at __get_vm_area_node+0x18c/0x190
[71428.004077] EAX: f2680000 EBX: 00001000 ECX: 00000022 EDX: 00000001
[71428.004077] ESI: ff7fe000 EDI: 00000001 EBP: 00000022 ESP: f2681a54
[71428.004077]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
[71428.004077] Process irqbalance (pid: 9846, ti=f2680000 task=f2406670 task.ti=f2680000)
[71428.004077] Stack:
[71428.004077]  c03fcd44 00000001 ffffffff 00001000 ff7fe000 000000d2 00000000 c02fd15c
[71428.004077]  f7ffe000 ff7fe000 ffffffff 000000d2 c044ee36 00000163 ff7fe000 c02fd239
[71428.004077]  ff7fe000 000000d2 00000163 ffffffff c044ee36 f38fa920 f4010000 f38f3000
[71428.004077] Call Trace:
[71428.004077]  [<c02fd15c>] __vmalloc_node_range+0x6c/0xf0
[71428.004077]  [<c02fd239>] __vmalloc_node+0x59/0x70
[71428.004077]  [<c02fd579>] vmalloc+0x29/0x30
[71428.004077]  [<c044ee36>] splash_prepare+0x136/0x560
[71428.004077]  [<c044441a>] fbcon_switch+0x4a/0x530
[71428.004077]  [<c04a945b>] redraw_screen+0x11b/0x280
[71428.004077]  [<c04442c9>] fbcon_blank+0x1c9/0x2d0
[71428.004077]  [<c04aa7ab>] do_unblank_screen+0x9b/0x1a0
[71428.004077]  [<c0401a25>] bust_spinlocks+0x15/0x40
[71428.004077]  [<c05ca654>] panic+0xb7/0x196
[71428.004077]  [<c02a3d8e>] watchdog_overflow_callback+0xae/0xb0
[71428.004077]  [<c02cba77>] __perf_event_overflow+0xc7/0x290
[71428.004077]  [<c02cc302>] perf_event_overflow+0x12/0x20
[71428.004077]  [<c0214c29>] intel_pmu_handle_irq+0x199/0x320
[71428.004077]  [<c05cef56>] perf_event_nmi_handler+0x26/0x80
[71428.004077]  [<c05d0a96>] notifier_call_chain+0x36/0x60
[71428.004077]  [<c05d0adb>] __atomic_notifier_call_chain+0x1b/0x20
[71428.004077]  [<c05d0af7>] atomic_notifier_call_chain+0x17/0x20
[71428.004077]  [<c05d0b30>] notify_die+0x30/0x40
[71428.004077]  [<c05ce4a0>] default_do_nmi+0x30/0x280
[71428.004077]  [<c05ce74f>] do_nmi+0x5f/0x70
[71428.004077]  [<c05cdeb9>] nmi_stack_correct+0x28/0x2d
[71428.004077]  [<c05ccebe>] _raw_spin_lock_irqsave+0x2e/0x50
[71428.004077]  [<c02a76df>] show_interrupts+0xff/0x2f0
[71428.004077]  [<c0337cd0>] seq_read+0x150/0x360
[71428.004077]  [<c0366c50>] proc_reg_read+0x60/0x90
[71428.004077]  [<c031b9fb>] vfs_read+0x9b/0x110
[71428.004077]  [<c031bb41>] sys_read+0x41/0x80
[71428.004077]  [<c05d401c>] sysenter_do_call+0x12/0x28
[71428.004077]  [<ffffe430>] 0xffffe42f
[71428.004077] Code: 85 c0 75 f3 89 03 89 1a f0 81 05 54 6f 85 c0 00 00 00 01 83 c4 0c 89 d8 5b 5e 5f 5d c3 89 d8 31 db e8 e9 e7 00 
00 e9 4e ff ff ff <0f> 0b eb fe 53 89 d3 83 ec 14 8b 15 88 df 84 c0 89 4c 24 10 89 
[71428.004077] EIP: [<c02fceec>] __get_vm_area_node+0x18c/0x190 SS:ESP 0068:f2681a54
[71428.004077] ---[ end trace a538072f67b7bdaa ]---
[71428.004077] Kernel panic - not syncing: Fatal exception in interrupt
[71428.004077] Pid: 9846, comm: irqbalance Tainted: G      D    N  3.0.76-0.11-default #1
[71428.004077] Call Trace:
[71428.004077]  [<c0205741>] try_stack_unwind+0x1a1/0x1b0
[71428.004077]  [<c0204727>] dump_trace+0x47/0x110
[71428.004077]  [<c02052cb>] show_trace_log_lvl+0x4b/0x60
[71428.004077]  [<c02052f8>] show_trace+0x18/0x20
[71428.004077]  [<c05ca598>] dump_stack+0x6d/0x72
[71428.004077]  [<c05ca5f4>] panic+0x57/0x196
[71428.004077]  [<c05ceacc>] oops_end+0xbc/0xd0
[71428.004077]  [<c020322f>] do_invalid_op+0x7f/0x90
[71428.004077]  [<c05cde0a>] error_code+0x5a/0x60
[71428.004077]  [<c02fceec>] __get_vm_area_node+0x18c/0x190
[71428.004077]  [<c02fd15c>] __vmalloc_node_range+0x6c/0xf0
[71428.004077]  [<c02fd239>] __vmalloc_node+0x59/0x70
[71428.004077]  [<c02fd579>] vmalloc+0x29/0x30
[71428.004077]  [<c044ee36>] splash_prepare+0x136/0x560
[71428.004077]  [<c044441a>] fbcon_switch+0x4a/0x530
[71428.004077]  [<c04a945b>] redraw_screen+0x11b/0x280
[71428.004077]  [<c04442c9>] fbcon_blank+0x1c9/0x2d0
[71428.004077]  [<c04aa7ab>] do_unblank_screen+0x9b/0x1a0
[71428.004077]  [<c0401a25>] bust_spinlocks+0x15/0x40
[71428.004077]  [<c05ca654>] panic+0xb7/0x196
[71428.004077]  [<c02a3d8e>] watchdog_overflow_callback+0xae/0xb0
[71428.004077]  [<c02cba77>] __perf_event_overflow+0xc7/0x290
[71428.004077]  [<c02cc302>] perf_event_overflow+0x12/0x20
[71428.004077]  [<c0214c29>] intel_pmu_handle_irq+0x199/0x320
[71428.004077]  [<c05cef56>] perf_event_nmi_handler+0x26/0x80
[71428.004077]  [<c05d0a96>] notifier_call_chain+0x36/0x60
[71428.004077]  [<c05d0adb>] __atomic_notifier_call_chain+0x1b/0x20
[71428.004077]  [<c05d0af7>] atomic_notifier_call_chain+0x17/0x20
[71428.004077]  [<c05d0b30>] notify_die+0x30/0x40
[71428.004077]  [<c05ce4a0>] default_do_nmi+0x30/0x280
[71428.004077]  [<c05ce74f>] do_nmi+0x5f/0x70
[71428.004077]  [<c05cdeb9>] nmi_stack_correct+0x28/0x2d
[71428.004077]  [<c05ccebe>] _raw_spin_lock_irqsave+0x2e/0x50
[71428.004077]  [<c02a76df>] show_interrupts+0xff/0x2f0
[71428.004077]  [<c0337cd0>] seq_read+0x150/0x360
[71428.004077]  [<c0366c50>] proc_reg_read+0x60/0x90
[71428.004077]  [<c031b9fb>] vfs_read+0x9b/0x110
[71428.004077]  [<c031bb41>] sys_read+0x41/0x80
[71428.004077]  [<c05d401c>] sysenter_do_call+0x12/0x28
[71428.004077]  [<ffffe430>] 0xffffe42f
[71418.009628] Kernel panic - not syncing: Watchdog detected hard LOCKUP on cpu 5
[71418.009628] Pid: 0, comm: kworker/0:1 Tainted: G      D    N  3.0.76-0.11-default #1
[71418.009628] Call Trace:
[71418.009628]  [<c0205741>] try_stack_unwind+0x1a1/0x1b0
[71418.009628]  [<c0204727>] dump_trace+0x47/0x110
[71418.009628]  [<c02052cb>] show_trace_log_lvl+0x4b/0x60
[71418.009628]  [<c02052f8>] show_trace+0x18/0x20
[71418.009628]  [<c05ca598>] dump_stack+0x6d/0x72
[71418.009628]  [<c05ca5f4>] panic+0x57/0x196
[71418.009628]  [<c02a3d8e>] watchdog_overflow_callback+0xae/0xb0
[71418.009628]  [<c02cba77>] __perf_event_overflow+0xc7/0x290
[71418.009628]  [<c02cc302>] perf_event_overflow+0x12/0x20
[71418.009628]  [<c0214c29>] intel_pmu_handle_irq+0x199/0x320
[71418.009628]  [<c05cef56>] perf_event_nmi_handler+0x26/0x80
[71418.009628]  [<c05d0a96>] notifier_call_chain+0x36/0x60
[71418.009628]  [<c05d0adb>] __atomic_notifier_call_chain+0x1b/0x20
[71418.009628]  [<c05d0af7>] atomic_notifier_call_chain+0x17/0x20
[71418.009628]  [<c05d0b30>] notify_die+0x30/0x40
[71418.009628]  [<c05ce4a0>] default_do_nmi+0x30/0x280
[71418.009628]  [<c05ce74f>] do_nmi+0x5f/0x70
[71418.009628]  [<c05cdeb9>] nmi_stack_correct+0x28/0x2d
[71418.009628]  [<c05cce80>] _raw_spin_lock+0x10/0x20
[71418.009628]  [<c02a4925>] handle_irq_event+0x35/0x50
[71418.009628]  [<c02a6ec4>] handle_edge_irq+0x54/0xf0
[71418.009628]  [<c02042e1>] handle_irq+0x61/0x90
[71418.009628]  [<00000005>] 0x4

crash> bt -a
PID: 0      TASK: c08464a0  CPU: 0   COMMAND: "swapper"
 #0 [c083bf30] __schedule at c05caf78
 #1 [c083bfd8] cpu_idle at c0201e54

PID: 25972  TASK: f2f94ed0  CPU: 1   COMMAND: "kworker/1:0"
 #0 [f7235d30] stop_this_cpu at c02095d9
 #1 [f7235d40] reboot_interrupt at c05cd475
    EAX: 00000296  EBX: 00000000  ECX: f539aa84  EDX: 00000296  EBP: 00000296 
    DS:  007b      ESI: f25c53c0  ES:  007b      EDI: f3080000  GS:  0000
    CS:  0060      EIP: c05ccf06  ERR: ffffff07  EFLAGS: 00000296 
 #2 [f7235d74] _raw_spin_unlock_irqrestore at c05ccf06
 #3 [f7235d80] ata_scsi_queuecmd at f82d7627 [libata]
 #4 [f7235d94] scsi_dispatch_cmd at f829bcf6 [scsi_mod]
 #5 [f7235db4] scsi_request_fn at f82a2ab4 [scsi_mod]
 #6 [f7235de8] __blk_run_queue at c03cc7c3
 #7 [f7235df0] blk_execute_rq_nowait at c03d2591
 #8 [f7235e04] blk_execute_rq at c03d2658
 #9 [f7235e90] scsi_execute at f82a3e63 [scsi_mod]
#10 [f7235eb0] scsi_execute_req at f82a4026 [scsi_mod]
#11 [f7235ee8] sr_check_events at f94f8315 [sr_mod]
#12 [f7235f38] cdrom_check_events at f951a043 [cdrom]
#13 [f7235f44] disk_events_workfn at c03d5865
#14 [f7235f68] process_one_work at c0262a95
#15 [f7235f9c] worker_thread at c026521d
#16 [f7235fc0] kthread at c0268b12
#17 [f7235fe8] kernel_thread_helper at c05d46a4

PID: 9846   TASK: f2406670  CPU: 2   COMMAND: "irqbalance"
 #0 [f26818f8] crash_kexec at c028f7d6
 #1 [f268194c] panic at c05ca696
 #2 [f2681968] oops_end at c05ceac7
 #3 [f268197c] do_invalid_op at c020322a
 #4 [f2681a14] error_code (via invalid_op) at c05cde08
    EAX: f2680000  EBX: 00001000  ECX: 00000022  EDX: 00000001  EBP: 00000022 
    DS:  007b      ESI: ff7fe000  ES:  007b      EDI: 00000001  GS:  31b0
    CS:  0060      EIP: c02fceec  ERR: ffffffff  EFLAGS: 00010006 
 #5 [f2681a48] __get_vm_area_node at c02fceec
 #6 [f2681a70] __vmalloc_node_range at c02fd157
 #7 [f2681a90] __vmalloc_node at c02fd234
 #8 [f2681ab4] vmalloc at c02fd574
 #9 [f2681ac4] splash_prepare at c044ee31
#10 [f2681b14] fbcon_switch at c0444415
#11 [f2681be4] redraw_screen at c04a9458
#12 [f2681c00] fbcon_blank at c04442c4
#13 [f2681cd4] do_unblank_screen at c04aa7a8
#14 [f2681cec] bust_spinlocks at c0401a20
#15 [f2681cf0] panic at c05ca64f
#16 [f2681d0c] watchdog_overflow_callback at c02a3d89
#17 [f2681d20] __perf_event_overflow at c02cba75
#18 [f2681d6c] perf_event_overflow at c02cc2fd
#19 [f2681d74] intel_pmu_handle_irq at c0214c24
#20 [f2681e20] perf_event_nmi_handler at c05cef50
#21 [f2681e24] notifier_call_chain at c05d0a94
#22 [f2681e40] __atomic_notifier_call_chain at c05d0ad6
#23 [f2681e50] atomic_notifier_call_chain at c05d0af2
#24 [f2681e5c] notify_die at c05d0b2b
#25 [f2681e74] default_do_nmi at c05ce49b
#26 [f2681e9c] do_nmi at c05ce74a
#27 [f2681ea4] nmi at c05cdeb4
    EAX: 00000296  EBX: ffffffff  ECX: 00005150  EDX: 0000003e  EBP: f345da40 
    DS:  007b      ESI: 00000296  ES:  007b      EDI: f364b80c  GS:  0000
    CS:  0060      EIP: c05ccebe  ERR: 00000296  EFLAGS: 00000097 
#28 [f2681ed8] _raw_spin_lock_irqsave at c05ccebe
#29 [f2681ef0] show_interrupts at c02a76da
#30 [f2681f24] seq_read at c0337ccd
#31 [f2681f5c] proc_reg_read at c0366c4e
#32 [f2681f7c] vfs_read at c031b9f9
#33 [f2681f94] sys_read at c031bb3c
#34 [f2681fb0] ia32_sysenter_target at c05d4015
    EAX: 00000003  EBX: 00000003  ECX: b76f3000  EDX: 00000400 
    DS:  007b      ESI: b7722490  ES:  007b      EDI: b76f3000
    SS:  007b      ESP: bfa64bbc  EBP: bfa64bf4  GS:  0000
    CS:  0073      EIP: ffffe430  ERR: 00000003  EFLAGS: 00000246 

PID: 0      TASK: f40bc2b0  CPU: 3   COMMAND: "kworker/0:1"
 #0 [f40e1f40] stop_this_cpu at c02095d9
 #1 [f40e1f50] reboot_interrupt at c05cd475
    EAX: 00000000  EBX: 00000003  ECX: f53b2700  EDX: 00000000  EBP: 00000000 
    DS:  007b      ESI: c0885888  ES:  007b      EDI: 00000003  GS:  0000
    CS:  0060      EIP: c022a6c2  ERR: ffffff07  EFLAGS: 00000246 
 #2 [f40e1f84] native_safe_halt at c022a6c2
 #3 [f40e1f90] default_idle at c0209dd0
 #4 [f40e1fa4] cpu_idle at c0201e54

PID: 0      TASK: f40f5010  CPU: 4   COMMAND: "kworker/0:1"
 #0 [f40f7f40] stop_this_cpu at c02095d9
 #1 [f40f7f50] reboot_interrupt at c05cd475
    EAX: 00000000  EBX: 00000004  ECX: f53be700  EDX: 00000000  EBP: 00000000 
    DS:  007b      ESI: c0885888  ES:  007b      EDI: 00000004  GS:  0000
    CS:  0060      EIP: c022a6c2  ERR: ffffff07  EFLAGS: 00000246 
 #2 [f40f7f84] native_safe_halt at c022a6c2
 #3 [f40f7f90] default_idle at c0209dd0
 #4 [f40f7fa4] cpu_idle at c0201e54

PID: 0      TASK: f41063f0  CPU: 5   COMMAND: "kworker/0:1"
 #0 [f410befc] __schedule at c05caf78
 #1 [f410bfa4] cpu_idle at c0201e54
crash>

Best regards,
-Gonglei


