Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751696AbaKGKGW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 05:06:22 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:41184 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751251AbaKGKGQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 05:06:16 -0500
Date: Fri, 7 Nov 2014 11:06:11 +0100
From: Pavel Machek <pavel@ucw.cz>
To: kernel list <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@osdl.org>
Subject: 3.18-rc3: soft lockup in compact_zone, dead machine
Message-ID: <20141107100611.GA4175@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

My main machine died completely, it seems that original failure was
soft lockup in compact_zone().

See log below.

								Pavel

Nov  7 10:11:12 amd NetworkManager[2402]: <warn> Could not send ARP for local address 10.10.0.14: Failed to execute child process "/sbin/arping" (No such file or directory)
Nov  7 10:11:12 amd NetworkManager[2402]: <info> (tun0): device state change: ip-config -> ip-check (reason 'none') [70 80 0]
Nov  7 10:11:12 amd NetworkManager[2402]: <info> Activation (tun0) Stage 5 of 5 (IPv4 Commit) complete.
Nov  7 10:11:12 amd NetworkManager[2402]: <info> (tun0): device state change: ip-check -> secondaries (reason 'none') [80 90 0]
Nov  7 10:11:12 amd NetworkManager[2402]: <info> (tun0): device state change: secondaries -> activated (reason 'none') [90 100 0]
Nov  7 10:11:12 amd NetworkManager[2402]: <info> Activation (tun0) successful, device activated.
Nov  7 10:11:12 amd nm-dispatcher: Dispatching action 'up' for tun0
Nov  7 10:11:12 amd systemd[1]: Reloading OpenBSD Secure Shell server.
Nov  7 10:11:12 amd systemd[1]: Reloaded OpenBSD Secure Shell server.
Nov  7 10:11:14 amd NetworkManager[2402]: <warn> Could not send ARP for local address 10.10.0.14: Failed to execute child process "/sbin/arping" (No such file or directory)
Nov  7 10:11:21 amd ntpdate[16917]: adjust time server 46.243.48.222 offset 0.001669 sec
Nov  7 10:14:52 amd ovpn-castor[2845]: [castor.denx.org] Inactivity timeout (--ping-restart), restarting
Nov  7 10:14:52 amd ovpn-castor[2845]: /sbin/ip addr del dev tun0 local 10.10.0.14 peer 10.10.0.13
Nov  7 10:14:52 amd avahi-daemon[2404]: Withdrawing workstation service for tun0.
Nov  7 10:14:52 amd systemd-udevd[1963]: Network interface NamePolicy= disabled on kernel commandline, ignoring.
Nov  7 10:15:17 amd kernel: NMI watchdog: BUG: soft lockup - CPU#1 stuck for 23s! [kworker/u8:2:31788]
Nov  7 10:15:17 amd kernel: Modules linked in:
Nov  7 10:15:17 amd kernel: CPU: 1 PID: 31788 Comm: kworker/u8:2 Not tainted 3.18.0-rc3 #7
Nov  7 10:15:17 amd kernel: Hardware name:                  /DG41MJ, BIOS MJG4110H.86A.0006.2009.1223.1155 12/23/2009
Nov  7 10:15:17 amd kernel: Workqueue: khelper __call_usermodehelper
Nov  7 10:15:17 amd kernel: task: e0f35580 ti: c0f12000 task.ti: c0f12000
Nov  7 10:15:17 amd kernel: EIP: 0060:[<c40b82bd>] EFLAGS: 00000206 CPU: 1
Nov  7 10:15:17 amd kernel: EIP is at __zone_watermark_ok+0xd/0xa0
Nov  7 10:15:17 amd kernel: EAX: c4bcb1c0 EBX: 00001aca ECX: 00000472 EDX: 00000001
Nov  7 10:15:17 amd kernel: ESI: 00000001 EDI: c4bcb1c0 EBP: c0f13c4c ESP: c0f13c40
Nov  7 10:15:17 amd kernel: DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
Nov  7 10:15:17 amd kernel: CR0: 8005003b CR2: 0834af00 CR3: 04c6f000 CR4: 00040790
Nov  7 10:15:17 amd kernel: Stack:
Nov  7 10:15:17 amd kernel: 00001aca 00000000 c0f13ccc c0f13c68 c40b9511 00000000 00000000 00001aca
Nov  7 10:15:17 amd kernel: 00037400 c4bcb1c0 c0f13ca8 c40ce958 00000000 00000000 00000000 c4bcb3ec
Nov  7 10:15:17 amd kernel: 00000000 00000004 00000000 e0f35580 c0f13fec c4bcb1c0 00037400 c4bcb1c0
Nov  7 10:15:17 amd kernel: Call Trace:
Nov  7 10:15:17 amd kernel: [<c40b9511>] zone_watermark_ok+0x21/0x30
Nov  7 10:15:17 amd kernel: [<c40ce958>] compact_zone+0x268/0x4d0
Nov  7 10:15:17 amd kernel: [<c40cef64>] try_to_compact_pages+0xd4/0x260
Nov  7 10:15:17 amd kernel: [<c40bb211>] __alloc_pages_direct_compact+0x41/0x170
Nov  7 10:15:17 amd kernel: [<c40bb686>] __alloc_pages_nodemask+0x346/0x790
Nov  7 10:15:17 amd kernel: [<c40bbb83>] alloc_kmem_pages_node+0x13/0x20
Nov  7 10:15:17 amd kernel: [<c4030982>] copy_process.part.53+0xb2/0x1410
Nov  7 10:15:17 amd kernel: [<c4042740>] ? ____call_usermodehelper+0x140/0x140
Nov  7 10:15:17 amd kernel: [<c4042740>] ? ____call_usermodehelper+0x140/0x140
Nov  7 10:15:17 amd kernel: [<c4031e65>] do_fork+0xb5/0x390
Nov  7 10:15:17 amd kernel: [<c406a42a>] ? __lock_acquire.isra.24+0x2ea/0xc10
Nov  7 10:15:17 amd kernel: [<c4042740>] ? ____call_usermodehelper+0x140/0x140
Nov  7 10:15:17 amd kernel: [<c403215a>] kernel_thread+0x1a/0x20
Nov  7 10:15:17 amd kernel: [<c40425c2>] __call_usermodehelper+0x22/0x60
Nov  7 10:15:17 amd kernel: [<c404546f>] process_one_work+0x15f/0x390
Nov  7 10:15:17 amd kernel: [<c4045419>] ? process_one_work+0x109/0x390
Nov  7 10:15:17 amd kernel: [<c4045ae9>] worker_thread+0x39/0x440
Nov  7 10:15:17 amd kernel: [<c4045ab0>] ? cancel_delayed_work+0x70/0x70
Nov  7 10:15:17 amd kernel: [<c4049f4e>] kthread+0xae/0xd0
Nov  7 10:15:17 amd kernel: [<c4040000>] ? SyS_getpriority+0xe0/0x270
Nov  7 10:15:17 amd kernel: [<c48303c1>] ret_from_kernel_thread+0x21/0x30
Nov  7 10:15:17 amd kernel: [<c4049ea0>] ? kthread_create_on_node+0x170/0x170
Nov  7 10:15:17 amd kernel: Code: 8d 0c db 8d 50 34 8d 44 88 10 8d 74 26 00 c7 02 01 00 00 00 83 c2 24 39 c2 75 f3 5b 5d c3 55 89 e5 57 56 be 01 00 00 00 53 89 c7 <89> cb 89 f0 89 d1 d3 e0 29 c6 03 75 10 f6 45 0c 20 74 0b 89 d9
Nov  7 10:15:45 amd kernel: NMI watchdog: BUG: soft lockup - CPU#1 stuck for 22s! [kworker/u8:2:31788]
Nov  7 10:15:45 amd kernel: Modules linked in:
Nov  7 10:15:45 amd kernel: CPU: 1 PID: 31788 Comm: kworker/u8:2 Tainted: G             L 3.18.0-rc3 #7
Nov  7 10:15:45 amd kernel: Hardware name:                  /DG41MJ, BIOS MJG4110H.86A.0006.2009.1223.1155 12/23/2009
Nov  7 10:15:45 amd kernel: Workqueue: khelper __call_usermodehelper
Nov  7 10:15:45 amd kernel: task: e0f35580 ti: c0f12000 task.ti: c0f12000
Nov  7 10:15:45 amd kernel: EIP: 0060:[<c40b82ee>] EFLAGS: 00000246 CPU: 1
Nov  7 10:15:45 amd kernel: EIP is at __zone_watermark_ok+0x3e/0xa0
Nov  7 10:15:45 amd kernel: EAX: 00000002 EBX: 00000472 ECX: 00000001 EDX: 00000001
Nov  7 10:15:45 amd kernel: ESI: 00001307 EDI: c4bcb1c0 EBP: c0f13c4c ESP: c0f13c40
Nov  7 10:15:45 amd kernel: DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
Nov  7 10:15:45 amd kernel: CR0: 8005003b CR2: 0834af00 CR3: 04c6f000 CR4: 00040790
Nov  7 10:15:45 amd kernel: Stack:
Nov  7 10:15:45 amd kernel: 00001308 00000000 c0f13ccc c0f13c68 c40b9511 00000000 00000000 00001308
Nov  7 10:15:45 amd kernel: 00037400 c4bcb1c0 c0f13ca8 c40ce958 00000000 00000000 00000000 c4bcb3ec
Nov  7 10:15:45 amd kernel: 00000000 00000004 00000000 e0f35580 c0f13fec c4bcb1c0 00037400 c4bcb1c0
Nov  7 10:15:45 amd kernel: Call Trace:
Nov  7 10:15:45 amd kernel: [<c40b9511>] zone_watermark_ok+0x21/0x30
Nov  7 10:15:45 amd kernel: [<c40ce958>] compact_zone+0x268/0x4d0
Nov  7 10:15:45 amd kernel: [<c40cef64>] try_to_compact_pages+0xd4/0x260
Nov  7 10:15:45 amd kernel: [<c40bb211>] __alloc_pages_direct_compact+0x41/0x170
Nov  7 10:15:45 amd kernel: [<c40bb686>] __alloc_pages_nodemask+0x346/0x790
Nov  7 10:15:45 amd kernel: [<c40bbb83>] alloc_kmem_pages_node+0x13/0x20
Nov  7 10:15:45 amd kernel: [<c4030982>] copy_process.part.53+0xb2/0x1410
Nov  7 10:15:45 amd kernel: [<c4042740>] ? ____call_usermodehelper+0x140/0x140
Nov  7 10:15:45 amd kernel: [<c4042740>] ? ____call_usermodehelper+0x140/0x140
Nov  7 10:15:45 amd kernel: [<c4031e65>] do_fork+0xb5/0x390
Nov  7 10:15:45 amd kernel: [<c406a42a>] ? __lock_acquire.isra.24+0x2ea/0xc10
Nov  7 10:15:45 amd kernel: [<c4042740>] ? ____call_usermodehelper+0x140/0x140
Nov  7 10:15:45 amd kernel: [<c403215a>] kernel_thread+0x1a/0x20
Nov  7 10:15:45 amd kernel: [<c40425c2>] __call_usermodehelper+0x22/0x60
Nov  7 10:15:45 amd kernel: [<c404546f>] process_one_work+0x15f/0x390
Nov  7 10:15:45 amd kernel: [<c4045419>] ? process_one_work+0x109/0x390
Nov  7 10:15:45 amd kernel: [<c4045ae9>] worker_thread+0x39/0x440
Nov  7 10:15:45 amd kernel: [<c4045ab0>] ? cancel_delayed_work+0x70/0x70
Nov  7 10:15:45 amd kernel: [<c4049f4e>] kthread+0xae/0xd0
Nov  7 10:15:45 amd kernel: [<c4040000>] ? SyS_getpriority+0xe0/0x270
Nov  7 10:15:45 amd kernel: [<c48303c1>] ret_from_kernel_thread+0x21/0x30
Nov  7 10:15:45 amd kernel: [<c4049ea0>] ? kthread_create_on_node+0x170/0x170
Nov  7 10:15:45 amd kernel: Code: d3 e0 29 c6 03 75 10 f6 45 0c 20 74 0b 89 d9 c1 e9 1f 01 d9 d1 f9 29 cb f6 45 0c 10 74 0d 8d 43 03 85 db 0f 49 c3 c1 f8 02 29 c3 <8b> 45 08 8b 4c 87 0c 31 c0 01 d9 39 ce 7e 3e 85 d2 74 35 2b b7
Nov  7 10:15:52 amd kernel: INFO: rcu_sched self-detected stall on CPU { 1}  (t=15000 jiffies g=2299748 c=2299747 q=54293)
Nov  7 10:15:52 amd kernel: Task dump for CPU 1:
Nov  7 10:15:52 amd kernel: kworker/u8:2    R running      0 31788      2 0x00000008
Nov  7 10:15:52 amd kernel: Workqueue: khelper __call_usermodehelper
Nov  7 10:15:52 amd kernel: e0f35580 e0f35580 c0f13b7c c40521a7 c4a4bc15 00000000 00007c2c 00000002
Nov  7 10:15:52 amd kernel: 00000008 00000001 c4b747c0 c0f13b90 c4054af9 c4a4bc5a 00000001 00000002
Nov  7 10:15:52 amd kernel: c0f13ba8 c4080b1d c4b747c0 c4b747c0 c4b747c0 f779d940 c0f13bec c408356a
Nov  7 10:15:52 amd kernel: Call Trace:
Nov  7 10:15:52 amd kernel: [<c40521a7>] sched_show_task+0xb7/0x110
Nov  7 10:15:52 amd kernel: [<c4054af9>] dump_cpu_task+0x29/0x30
Nov  7 10:15:52 amd kernel: [<c4080b1d>] rcu_dump_cpu_stacks+0x6d/0xb0
Nov  7 10:15:52 amd kernel: [<c408356a>] rcu_check_callbacks+0x30a/0x510
Nov  7 10:15:52 amd kernel: [<c4085be7>] update_process_times+0x37/0x60
Nov  7 10:15:52 amd kernel: [<c40944af>] tick_nohz_handler+0x6f/0x100
Nov  7 10:15:52 amd kernel: [<c4021d08>] local_apic_timer_interrupt+0x28/0x50
Nov  7 10:15:52 amd kernel: [<c402209e>] smp_apic_timer_interrupt+0x2e/0x40
Nov  7 10:15:52 amd kernel: [<c4830c6d>] apic_timer_interrupt+0x31/0x38
Nov  7 10:15:52 amd kernel: [<c40ce9c3>] ? compact_zone+0x2d3/0x4d0
Nov  7 10:15:52 amd kernel: [<c40cef64>] try_to_compact_pages+0xd4/0x260
Nov  7 10:15:52 amd kernel: [<c40bb211>] __alloc_pages_direct_compact+0x41/0x170
Nov  7 10:15:52 amd kernel: [<c40bb686>] __alloc_pages_nodemask+0x346/0x790
Nov  7 10:15:52 amd kernel: [<c40bbb83>] alloc_kmem_pages_node+0x13/0x20
Nov  7 10:15:52 amd kernel: [<c4030982>] copy_process.part.53+0xb2/0x1410
Nov  7 10:15:52 amd kernel: [<c4042740>] ? ____call_usermodehelper+0x140/0x140
Nov  7 10:15:52 amd kernel: [<c4042740>] ? ____call_usermodehelper+0x140/0x140
Nov  7 10:15:52 amd kernel: [<c4031e65>] do_fork+0xb5/0x390
Nov  7 10:15:52 amd kernel: [<c406a42a>] ? __lock_acquire.isra.24+0x2ea/0xc10
Nov  7 10:15:52 amd kernel: [<c4042740>] ? ____call_usermodehelper+0x140/0x140
Nov  7 10:15:52 amd kernel: [<c403215a>] kernel_thread+0x1a/0x20
Nov  7 10:15:52 amd kernel: [<c40425c2>] __call_usermodehelper+0x22/0x60
Nov  7 10:15:52 amd kernel: [<c404546f>] process_one_work+0x15f/0x390
Nov  7 10:15:52 amd kernel: [<c4045419>] ? process_one_work+0x109/0x390
Nov  7 10:15:52 amd kernel: [<c4045ae9>] worker_thread+0x39/0x440
Nov  7 10:15:52 amd kernel: [<c4045ab0>] ? cancel_delayed_work+0x70/0x70
Nov  7 10:15:52 amd kernel: [<c4049f4e>] kthread+0xae/0xd0
Nov  7 10:15:52 amd kernel: [<c4040000>] ? SyS_getpriority+0xe0/0x270
Nov  7 10:15:52 amd kernel: [<c48303c1>] ret_from_kernel_thread+0x21/0x30
Nov  7 10:15:52 amd kernel: [<c4049ea0>] ? kthread_create_on_node+0x170/0x170
Nov  7 10:16:17 amd kernel: NMI watchdog: BUG: soft lockup - CPU#1 stuck for 23s! [kworker/u8:2:31788]
Nov  7 10:16:17 amd kernel: Modules linked in:
Nov  7 10:16:17 amd kernel: CPU: 1 PID: 31788 Comm: kworker/u8:2 Tainted: G             L 3.18.0-rc3 #7
Nov  7 10:16:17 amd kernel: Hardware name:                  /DG41MJ, BIOS MJG4110H.86A.0006.2009.1223.1155 12/23/2009
Nov  7 10:16:17 amd kernel: Workqueue: khelper __call_usermodehelper
Nov  7 10:16:17 amd kernel: task: e0f35580 ti: c0f12000 task.ti: c0f12000
Nov  7 10:16:17 amd kernel: EIP: 0060:[<c40b82c5>] EFLAGS: 00000202 CPU: 1
Nov  7 10:16:17 amd kernel: EIP is at __zone_watermark_ok+0x15/0xa0
Nov  7 10:16:17 amd kernel: EAX: 00000002 EBX: 00000472 ECX: 00000001 EDX: 00000001
Nov  7 10:16:17 amd kernel: ESI: 00000001 EDI: c4bcb1c0 EBP: c0f13c4c ESP: c0f13c40
Nov  7 10:16:17 amd kernel: DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
Nov  7 10:16:17 amd kernel: CR0: 8005003b CR2: 0834af00 CR3: 04c6f000 CR4: 00040790
Nov  7 10:16:17 amd kernel: Stack:
Nov  7 10:16:17 amd kernel: 00000f7c 00000000 c0f13ccc c0f13c68 c40b9511 00000000 00000000 00000f7c
Nov  7 10:16:17 amd kernel: 00037400 c4bcb1c0 c0f13ca8 c40ce958 00000000 00000000 00000000 c4bcb3ec
Nov  7 10:16:17 amd kernel: 00000000 00000004 00000000 e0f35580 c0f13fec c4bcb1c0 00037400 c4bcb1c0
Nov  7 10:16:17 amd kernel: Call Trace:
Nov  7 10:16:17 amd kernel: [<c40b9511>] zone_watermark_ok+0x21/0x30
Nov  7 10:16:17 amd kernel: [<c40ce958>] compact_zone+0x268/0x4d0
Nov  7 10:16:17 amd kernel: [<c40cef64>] try_to_compact_pages+0xd4/0x260
Nov  7 10:16:17 amd kernel: [<c40bb211>] __alloc_pages_direct_compact+0x41/0x170
Nov  7 10:16:17 amd kernel: [<c40bb686>] __alloc_pages_nodemask+0x346/0x790
Nov  7 10:16:17 amd kernel: [<c40bbb83>] alloc_kmem_pages_node+0x13/0x20
Nov  7 10:16:17 amd kernel: [<c4030982>] copy_process.part.53+0xb2/0x1410
Nov  7 10:16:17 amd kernel: [<c4042740>] ? ____call_usermodehelper+0x140/0x140
Nov  7 10:16:17 amd kernel: [<c4042740>] ? ____call_usermodehelper+0x140/0x140
Nov  7 10:16:17 amd kernel: [<c4031e65>] do_fork+0xb5/0x390
Nov  7 10:16:17 amd kernel: [<c406a42a>] ? __lock_acquire.isra.24+0x2ea/0xc10
Nov  7 10:16:17 amd kernel: [<c4042740>] ? ____call_usermodehelper+0x140/0x140
Nov  7 10:16:17 amd kernel: [<c403215a>] kernel_thread+0x1a/0x20
Nov  7 10:16:17 amd kernel: [<c40425c2>] __call_usermodehelper+0x22/0x60
Nov  7 10:16:17 amd kernel: [<c404546f>] process_one_work+0x15f/0x390
Nov  7 10:16:17 amd kernel: [<c4045419>] ? process_one_work+0x109/0x390
Nov  7 10:16:17 amd kernel: [<c4045ae9>] worker_thread+0x39/0x440
Nov  7 10:16:17 amd kernel: [<c4045ab0>] ? cancel_delayed_work+0x70/0x70
Nov  7 10:16:17 amd kernel: [<c4049f4e>] kthread+0xae/0xd0
Nov  7 10:16:17 amd kernel: [<c4040000>] ? SyS_getpriority+0xe0/0x270
Nov  7 10:16:17 amd kernel: [<c48303c1>] ret_from_kernel_thread+0x21/0x30
Nov  7 10:16:17 amd kernel: [<c4049ea0>] ? kthread_create_on_node+0x170/0x170
Nov  7 10:16:17 amd kernel: Code: 88 10 8d 74 26 00 c7 02 01 00 00 00 83 c2 24 39 c2 75 f3 5b 5d c3 55 89 e5 57 56 be 01 00 00 00 53 89 c7 89 cb 89 f0 89 d1 d3 e0 <29> c6 03 75 10 f6 45 0c 20 74 0b 89 d9 c1 e9 1f 01 d9 d1 f9 29
Nov  7 10:16:45 amd kernel: NMI watchdog: BUG: soft lockup - CPU#1 stuck for 23s! [kworker/u8:2:31788]
Nov  7 10:16:45 amd kernel: Modules linked in:
Nov  7 10:16:45 amd kernel: CPU: 1 PID: 31788 Comm: kworker/u8:2 Tainted: G             L 3.18.0-rc3 #7
Nov  7 10:16:45 amd kernel: Hardware name:                  /DG41MJ, BIOS MJG4110H.86A.0006.2009.1223.1155 12/23/2009
Nov  7 10:16:45 amd kernel: Workqueue: khelper __call_usermodehelper
Nov  7 10:16:45 amd kernel: task: e0f35580 ti: c0f12000 task.ti: c0f12000
Nov  7 10:16:45 amd kernel: EIP: 0060:[<c40ce9e9>] EFLAGS: 00000212 CPU: 1
Nov  7 10:16:45 amd kernel: EIP is at compact_zone+0x2f9/0x4d0
Nov  7 10:16:45 amd kernel: EAX: 000377fe EBX: 00037800 ECX: 00037400 EDX: 00000001
Nov  7 10:16:45 amd kernel: ESI: 00000004 EDI: c0f13ccc EBP: c0f13ca8 ESP: c0f13c78
Nov  7 10:16:45 amd kernel: DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
Nov  7 10:16:45 amd kernel: CR0: 8005003b CR2: 0834af00 CR3: 04c6f000 CR4: 00040790
Nov  7 10:16:45 amd kernel: Stack:
Nov  7 10:16:45 amd kernel: 00000000 c4bcb3ec 00000000 00000004 00000000 e0f35580 c0f13fec c4bcb1c0
Nov  7 10:16:45 amd kernel: 00037400 c4bcb1c0 00000001 c0f13d04 c0f13d10 c40cef64 002000d0 e0f35580
Nov  7 10:16:45 amd kernel: 00000002 00000000 00000001 c4bcbc4c c4bcb1c0 c0f13ccc c0f13ccc c0f13cd4
Nov  7 10:16:45 amd kernel: Call Trace:
Nov  7 10:16:45 amd kernel: [<c40cef64>] try_to_compact_pages+0xd4/0x260
Nov  7 10:16:45 amd kernel: [<c40bb211>] __alloc_pages_direct_compact+0x41/0x170
Nov  7 10:16:45 amd kernel: [<c40bb686>] __alloc_pages_nodemask+0x346/0x790
Nov  7 10:16:45 amd kernel: [<c40bbb83>] alloc_kmem_pages_node+0x13/0x20
Nov  7 10:16:45 amd kernel: [<c4030982>] copy_process.part.53+0xb2/0x1410
Nov  7 10:16:45 amd kernel: [<c4042740>] ? ____call_usermodehelper+0x140/0x140
Nov  7 10:16:45 amd kernel: [<c4042740>] ? ____call_usermodehelper+0x140/0x140
Nov  7 10:16:45 amd kernel: [<c4031e65>] do_fork+0xb5/0x390
Nov  7 10:16:45 amd kernel: [<c406a42a>] ? __lock_acquire.isra.24+0x2ea/0xc10
Nov  7 10:16:45 amd kernel: [<c4042740>] ? ____call_usermodehelper+0x140/0x140
Nov  7 10:16:45 amd kernel: [<c403215a>] kernel_thread+0x1a/0x20
Nov  7 10:16:45 amd kernel: [<c40425c2>] __call_usermodehelper+0x22/0x60
Nov  7 10:16:45 amd kernel: [<c404546f>] process_one_work+0x15f/0x390
Nov  7 10:16:45 amd kernel: [<c4045419>] ? process_one_work+0x109/0x390
Nov  7 10:16:45 amd kernel: [<c4045ae9>] worker_thread+0x39/0x440
Nov  7 10:16:45 amd kernel: [<c4045ab0>] ? cancel_delayed_work+0x70/0x70
Nov  7 10:16:45 amd kernel: [<c4049f4e>] kthread+0xae/0xd0
Nov  7 10:16:45 amd kernel: [<c4040000>] ? SyS_getpriority+0xe0/0x270
Nov  7 10:16:45 amd kernel: [<c48303c1>] ret_from_kernel_thread+0x21/0x30
Nov  7 10:16:45 amd kernel: [<c4049ea0>] ? kthread_create_on_node+0x170/0x170
Nov  7 10:16:45 amd kernel: Code: ff 39 da 75 dd 8b 4f 1c 8b 47 18 89 4d f0 8b 4d f0 83 7f 20 01 8d 99 00 04 00 00 19 f6 81 e3 00 fc ff ff 83 e6 04 39 c3 89 75 dc <0f> 87 c6 01 00 00 f7 45 f0 ff 7f 00 00 75 18 8b 45 e8 2d ec 1f
Nov  7 10:17:02 amd pulseaudio[3253]: snd_pcm_avail() returned a value that is exceptionally large: 135776 bytes (769 ms).
Nov  7 10:17:02 amd pulseaudio[3253]: Most likely this is a bug in the ALSA driver 'snd_hda_intel'. Please report this issue to the ALSA developers.
Nov  7 10:17:02 amd pulseaudio[3253]: snd_pcm_dump():
Nov  7 10:17:02 amd pulseaudio[3253]: Soft volume PCM
Nov  7 10:17:02 amd pulseaudio[3253]: Control: PCM Playback Volume
Nov  7 10:17:02 amd pulseaudio[3253]: min_dB: -51
Nov  7 10:17:02 amd pulseaudio[3253]: max_dB: 0
Nov  7 10:17:02 amd pulseaudio[3253]: resolution: 256
Nov  7 10:17:02 amd pulseaudio[3253]: Its setup is:
Nov  7 10:17:02 amd pulseaudio[3253]:   stream       : PLAYBACK
Nov  7 10:17:02 amd pulseaudio[3253]:   access       : MMAP_INTERLEAVED
Nov  7 10:17:02 amd pulseaudio[3253]:   format       : S16_LE
Nov  7 10:17:02 amd pulseaudio[3253]:   subformat    : STD
Nov  7 10:17:02 amd pulseaudio[3253]:   rate         : 44100
Nov  7 10:17:02 amd pulseaudio[3253]:   exact rate   : 44100 (44100/1)
Nov  7 10:17:02 amd pulseaudio[3253]:   msbits       : 16
Nov  7 10:17:02 amd pulseaudio[3253]:   buffer_size  : 4408
Nov  7 10:17:02 amd pulseaudio[3253]:   period_size  : 1102
Nov  7 10:17:02 amd pulseaudio[3253]:   period_time  : 24988
Nov  7 10:17:02 amd pulseaudio[3253]:   tstamp_mode  : ENABLE
Nov  7 10:17:02 amd pulseaudio[3253]:   period_step  : 1
Nov  7 10:17:02 amd pulseaudio[3253]:   avail_min    : 1102
Nov  7 10:17:02 amd pulseaudio[3253]:   period_event : 1
Nov  7 10:17:02 amd pulseaudio[3253]:   start_threshold  : -1
Nov  7 10:17:02 amd pulseaudio[3253]:   stop_threshold   : 1155530752
Nov  7 10:17:02 amd pulseaudio[3253]:   silence_threshold: 0
Nov  7 10:17:02 amd pulseaudio[3253]:   silence_size : 0
Nov  7 10:17:02 amd pulseaudio[3253]:   boundary     : 1155530752
Nov  7 10:17:02 amd pulseaudio[3253]: Slave: Hardware PCM card 0 'HDA Intel' device 0 subdevice 0
Nov  7 10:17:02 amd pulseaudio[3253]: Its setup is:
Nov  7 10:17:02 amd pulseaudio[3253]:   stream       : PLAYBACK
Nov  7 10:17:02 amd pulseaudio[3253]:   access       : MMAP_INTERLEAVED
Nov  7 10:17:02 amd pulseaudio[3253]:   format       : S16_LE
Nov  7 10:17:02 amd pulseaudio[3253]:   subformat    : STD
Nov  7 10:17:02 amd pulseaudio[3253]:   channels     : 2
Nov  7 10:17:02 amd pulseaudio[3253]:   rate         : 44100
Nov  7 10:17:02 amd pulseaudio[3253]:   exact rate   : 44100 (44100/1)
Nov  7 10:17:02 amd pulseaudio[3253]:   msbits       : 16
Nov  7 10:17:02 amd pulseaudio[3253]:   buffer_size  : 4408
Nov  7 10:17:02 amd pulseaudio[3253]:   period_size  : 1102
Nov  7 10:17:02 amd pulseaudio[3253]:   period_time  : 24988
Nov  7 10:17:02 amd pulseaudio[3253]:   period_step  : 1
Nov  7 10:17:02 amd pulseaudio[3253]:   avail_min    : 1102
Nov  7 10:17:02 amd pulseaudio[3253]:   period_event : 1
Nov  7 10:17:02 amd pulseaudio[3253]:   start_threshold  : -1
Nov  7 10:17:02 amd pulseaudio[3253]:   stop_threshold   : 1155530752
Nov  7 10:17:02 amd pulseaudio[3253]:   silence_threshold: 0
Nov  7 10:17:02 amd pulseaudio[3253]:   silence_size : 0
Nov  7 10:17:02 amd pulseaudio[3253]:   boundary     : 1155530752
Nov  7 10:17:02 amd pulseaudio[3253]:   appl_ptr     : 327239648
Nov  7 10:17:02 amd pulseaudio[3253]:   hw_ptr       : 327278760
Nov  7 10:17:05 amd kernel: Purging GPU memory, 0 bytes freed, 14688256 bytes still pinned.
Nov  7 10:17:05 amd kernel: Xorg invoked oom-killer: gfp_mask=0xd0, order=0, oom_score_adj=0
Nov  7 10:17:05 amd kernel: CPU: 0 PID: 2515 Comm: Xorg Tainted: G             L 3.18.0-rc3 #7
Nov  7 10:17:05 amd kernel: Hardware name:                  /DG41MJ, BIOS MJG4110H.86A.0006.2009.1223.1155 12/23/2009
Nov  7 10:17:05 amd kernel: 00000000 00000000 f4ca39b8 c48285e8 f0ec7580 f4ca3a00 c40b7656 c4a561e4
Nov  7 10:17:05 amd kernel: f0ec7940 000000d0 00000000 00000000 c4b76e80 00203206 f4ca39ec 00203206
Nov  7 10:17:05 amd kernel: c4b76e80 00000001 00000000 c429c7c4 d383f580 000000d0 00000000 f4ca3a24
Nov  7 10:17:05 amd kernel: Call Trace:
Nov  7 10:17:05 amd kernel: [<c48285e8>] dump_stack+0x41/0x52
Nov  7 10:17:05 amd kernel: [<c40b7656>] dump_header.isra.10+0x66/0x200
Nov  7 10:17:05 amd kernel: [<c429c7c4>] ? ___ratelimit+0x64/0xc0
Nov  7 10:17:05 amd kernel: [<c40b7b9f>] oom_kill_process+0x19f/0x320
Nov  7 10:17:05 amd kernel: [<c40b8143>] out_of_memory+0x2d3/0x300
Nov  7 10:17:05 amd kernel: [<c40bbab4>] __alloc_pages_nodemask+0x774/0x790
Nov  7 10:17:05 amd kernel: [<c40bbadf>] __get_free_pages+0xf/0x30
Nov  7 10:17:05 amd kernel: [<c40fc8bf>] __pollwait+0x7f/0xc0
Nov  7 10:17:05 amd kernel: [<c40fc840>] ? poll_initwait+0x40/0x40
Nov  7 10:17:05 amd kernel: [<c474f71f>] unix_poll+0x1f/0xb0
Nov  7 10:17:05 amd kernel: [<c469e90a>] sock_poll+0x11a/0x130
Nov  7 10:17:05 amd kernel: [<c40fd05a>] do_select+0x37a/0x790
Nov  7 10:17:05 amd kernel: [<c402bd8d>] ? _lookup_address_cpa.isra.24+0x2d/0x30
Nov  7 10:17:05 amd kernel: [<c40fc840>] ? poll_initwait+0x40/0x40
Nov  7 10:17:05 amd kernel: [<c40fca60>] ? poll_select_copy_remaining+0x100/0x100
Nov  7 10:17:05 amd kernel: [<c40fca60>] ? poll_select_copy_remaining+0x100/0x100
Nov  7 10:17:05 amd kernel: [<c40fca60>] ? poll_select_copy_remaining+0x100/0x100
Nov  7 10:17:05 amd kernel: [<c40fca60>] ? poll_select_copy_remaining+0x100/0x100
Nov  7 10:17:05 amd kernel: [<c40fca60>] ? poll_select_copy_remaining+0x100/0x100
Nov  7 10:17:05 amd kernel: [<c40fca60>] ? poll_select_copy_remaining+0x100/0x100
Nov  7 10:17:05 amd kernel: [<c40fca60>] ? poll_select_copy_remaining+0x100/0x100
Nov  7 10:17:05 amd kernel: [<c40fca60>] ? poll_select_copy_remaining+0x100/0x100
Nov  7 10:17:05 amd kernel: [<c40fca60>] ? poll_select_copy_remaining+0x100/0x100
Nov  7 10:17:05 amd kernel: [<c40fca60>] ? poll_select_copy_remaining+0x100/0x100
Nov  7 10:17:05 amd kernel: [<c40fca60>] ? poll_select_copy_remaining+0x100/0x100
Nov  7 10:17:05 amd kernel: [<c40fca60>] ? poll_select_copy_remaining+0x100/0x100
Nov  7 10:17:05 amd kernel: [<c40fca60>] ? poll_select_copy_remaining+0x100/0x100
Nov  7 10:17:05 amd kernel: [<c40fca60>] ? poll_select_copy_remaining+0x100/0x100
Nov  7 10:17:05 amd kernel: [<c40fca60>] ? poll_select_copy_remaining+0x100/0x100
Nov  7 10:17:05 amd kernel: [<c40fca60>] ? poll_select_copy_remaining+0x100/0x100
Nov  7 10:17:05 amd kernel: [<c40fca60>] ? poll_select_copy_remaining+0x100/0x100
Nov  7 10:17:05 amd kernel: [<c40fca60>] ? poll_select_copy_remaining+0x100/0x100
Nov  7 10:17:05 amd kernel: [<c40fd626>] core_sys_select+0x1b6/0x2a0
Nov  7 10:17:05 amd kernel: [<c40fccbd>] ? poll_select_set_timeout+0x6d/0x90
Nov  7 10:17:05 amd kernel: [<c40fd7ad>] SyS_select+0x9d/0xd0
Nov  7 10:17:05 amd kernel: [<c483051e>] syscall_call+0x7/0x7
Nov  7 10:17:05 amd kernel: [<c4830000>] ? _raw_spin_trylock_bh+0x30/0x70
Nov  7 10:17:05 amd kernel: Mem-Info:
Nov  7 10:17:05 amd kernel: DMA per-cpu:
Nov  7 10:17:05 amd kernel: CPU    0: hi:    0, btch:   1 usd:   0
Nov  7 10:17:05 amd kernel: CPU    1: hi:    0, btch:   1 usd:   0
Nov  7 10:17:05 amd kernel: Normal per-cpu:
Nov  7 10:17:05 amd kernel: CPU    0: hi:  186, btch:  31 usd:  14
Nov  7 10:17:05 amd kernel: CPU    1: hi:  186, btch:  31 usd:   0
Nov  7 10:17:05 amd kernel: HighMem per-cpu:
Nov  7 10:17:05 amd kernel: CPU    0: hi:  186, btch:  31 usd:  52
Nov  7 10:17:05 amd kernel: CPU    1: hi:  186, btch:  31 usd:   0
Nov  7 10:17:05 amd kernel: active_anon:275236 inactive_anon:73786 isolated_anon:0
Nov  7 10:17:05 amd kernel: active_file:16776 inactive_file:10004 isolated_file:0
Nov  7 10:17:05 amd kernel: unevictable:15 dirty:0 writeback:32 unstable:0
Nov  7 10:17:05 amd kernel: free:176651 slab_reclaimable:167554 slab_unreclaimable:37133
Nov  7 10:17:05 amd kernel: mapped:41298 shmem:60802 pagetables:4223 bounce:0
Nov  7 10:17:05 amd kernel: free_cma:0
Nov  7 10:17:05 amd kernel: DMA free:3364kB min:68kB low:84kB high:100kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15988kB managed:15912kB mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:8708kB slab_unreclaimable:1692kB kernel_stack:1880kB pagetables:92kB unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:4 all_unreclaimable? yes
Nov  7 10:17:05 amd kernel: lowmem_reserve[]: 0 824 2970 2970
Nov  7 10:17:05 amd kernel: Normal free:3696kB min:3636kB low:4544kB high:5452kB active_anon:3132kB inactive_anon:3752kB active_file:80kB inactive_file:308kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:892920kB managed:843860kB mlocked:0kB dirty:0kB writeback:128kB mapped:44kB shmem:3604kB slab_reclaimable:661508kB slab_unreclaimable:146840kB kernel_stack:4080kB pagetables:16800kB unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:46184 all_unreclaimable? yes
Nov  7 10:17:05 amd kernel: lowmem_reserve[]: 0 0 17167 17167
Nov  7 10:17:05 amd kernel: HighMem free:699544kB min:512kB low:2880kB high:5248kB active_anon:1097812kB inactive_anon:291392kB active_file:67024kB inactive_file:39708kB unevictable:60kB isolated(anon):0kB isolated(file):0kB present:2197444kB managed:2197444kB mlocked:60kB dirty:0kB writeback:0kB mapped:165148kB shmem:239604kB slab_reclaimable:0kB slab_unreclaimable:0kB kernel_stack:0kB pagetables:0kB unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
Nov  7 10:17:05 amd kernel: lowmem_reserve[]: 0 0 0 0
Nov  7 10:17:05 amd kernel: DMA: 131*4kB (EMR) 1*8kB (R) 1*16kB (R) 0*32kB 2*64kB (R) 1*128kB (R) 0*256kB 1*512kB (R) 2*1024kB (R) 0*2048kB 0*4096kB = 3364kB
Nov  7 10:17:05 amd kernel: Normal: 660*4kB (UEM) 8*8kB (R) 1*16kB (R) 1*32kB (R) 0*64kB 1*128kB (R) 1*256kB (R) 1*512kB (R) 0*1024kB 0*2048kB 0*4096kB = 3648kB
Nov  7 10:17:05 amd kernel: HighMem: 82840*4kB (EMR) 34740*8kB (EMR) 5325*16kB (EMR) 123*32kB (MR) 6*64kB (R) 4*128kB (R) 1*256kB (R) 0*512kB 0*1024kB 0*2048kB 0*4096kB = 699568kB
Nov  7 10:17:05 amd kernel: 93531 total pagecache pages
Nov  7 10:17:05 amd kernel: 5913 pages in swap cache
Nov  7 10:17:05 amd kernel: Swap cache stats: add 598229, delete 592316, find 190604/256368
Nov  7 10:17:05 amd kernel: Free swap  = 1770352kB
Nov  7 10:17:05 amd kernel: Total swap = 2097148kB
Nov  7 10:17:05 amd kernel: 776588 pages RAM
Nov  7 10:17:05 amd kernel: 549361 pages HighMem/MovableOnly
Nov  7 10:17:05 amd kernel: 0 pages reserved
Nov  7 10:17:05 amd kernel: [ pid ]   uid  tgid total_vm      rss nr_ptes swapents oom_score_adj name
Nov  7 10:17:05 amd kernel: [ 1206]     0  1206     3117      689       7       45             0 systemd-journal
Nov  7 10:17:05 amd kernel: [ 1963]     0  1963     1132      516       4       30         -1000 systemd-udevd
Nov  7 10:17:05 amd kernel: [ 2288]     0  2288     1087      162       4       58             0 rpcbind
Nov  7 10:17:05 amd kernel: [ 2299]   104  2299     1136       95       4      126             0 rpc.statd
Nov  7 10:17:05 amd kernel: [ 2315]     0  2315      725        0       3       52             0 rpc.idmapd
Nov  7 10:17:05 amd kernel: [ 2386]     0  2386      657        3       2       29             0 atd
Nov  7 10:17:05 amd kernel: [ 2389]     0  2389    10254      413       9      143             0 ModemManager
Nov  7 10:17:05 amd kernel: [ 2390]     0  2390     1034      166       3       84             0 smartd
Nov  7 10:17:05 amd kernel: [ 2392]     0  2392     2009     1146       3        0         -1000 sshd
Nov  7 10:17:05 amd kernel: [ 2393]     0  2393      608       91       2       30             0 inetd
Nov  7 10:17:05 amd kernel: [ 2395]     0  2395     1273      140       4       42             0 cron
Nov  7 10:17:05 amd kernel: [ 2398]     0  2398      934      343       3       29             0 systemd-logind
Nov  7 10:17:05 amd kernel: [ 2399]   121  2399    40469       12      11      195          -900 postgres
Nov  7 10:17:05 amd kernel: [ 2402]     0  2402    16656     1718      12      158             0 NetworkManager
Nov  7 10:17:05 amd kernel: [ 2404]   102  2404      904      145       3       19             0 avahi-daemon
Nov  7 10:17:05 amd kernel: [ 2405]   101  2405     1552      369       4       61          -900 dbus-daemon
Nov  7 10:17:05 amd kernel: [ 2423]   102  2423      873        6       3       47             0 avahi-daemon
Nov  7 10:17:05 amd kernel: [ 2461]     0  2461     1260      375       4      102             0 rpc.mountd
Nov  7 10:17:05 amd kernel: [ 2465]     0  2465     7998       54       5      148             0 rsyslogd
Nov  7 10:17:05 amd kernel: [ 2471]     0  2471     2491      184       5      130             0 cups-browsed
Nov  7 10:17:05 amd kernel: [ 2475]     0  2475     9286      668       8      120             0 polkitd
Nov  7 10:17:05 amd kernel: [ 2486]     0  2486     1070       87       4       32             0 agetty
Nov  7 10:17:05 amd kernel: [ 2497]     0  2497     9007      162       8      113             0 lightdm
Nov  7 10:17:05 amd kernel: [ 2515]     0  2515    36791     3657      41     2774             0 Xorg
Nov  7 10:17:05 amd kernel: [ 2573]   111  2573    10803      665       9      858             0 colord
Nov  7 10:17:05 amd kernel: [ 2827]   121  2827    40469       13       9      205             0 postgres
Nov  7 10:17:05 amd kernel: [ 2828]   121  2828    40469        2      10      205             0 postgres
Nov  7 10:17:05 amd kernel: [ 2829]   121  2829    40469        8       8      207             0 postgres
Nov  7 10:17:05 amd kernel: [ 2830]   121  2830    40535      371      11      211             0 postgres
Nov  7 10:17:05 amd kernel: [ 2831]   121  2831     4813      211       7      183             0 postgres
Nov  7 10:17:05 amd kernel: [ 2845]     0  2845     1508      874       3       37             0 openvpn
Nov  7 10:17:05 amd kernel: [ 2864]   107  2864     1240       70       4       65             0 systemd
Nov  7 10:17:05 amd kernel: [ 2869]   107  2869     1794       11       4      372             0 (sd-pam)
Nov  7 10:17:05 amd kernel: [ 2906]   107  2906      985       65       3       63             0 dbus-launch
Nov  7 10:17:05 amd kernel: [ 2914]   107  2914     1299      134       4       74             0 dbus-daemon
Nov  7 10:17:05 amd kernel: [ 2934]   107  2934    11020      192       8      126             0 at-spi-bus-laun
Nov  7 10:17:05 amd kernel: [ 2946]   107  2946     1299       16       4       58             0 dbus-daemon
Nov  7 10:17:05 amd kernel: [ 2959]   107  2959     4547       28       5       90             0 at-spi2-registr
Nov  7 10:17:05 amd kernel: [ 3113]     0  3113     6998      236       6      152             0 lightdm
Nov  7 10:17:05 amd kernel: [ 3134]  1000  3134     1241       49       3       60             0 systemd
Nov  7 10:17:05 amd kernel: [ 3139]  1000  3139     1794       11       4      373             0 (sd-pam)
Nov  7 10:17:05 amd kernel: [ 3143]  1000  3143    16327      809      11      118             0 gnome-keyring-d
Nov  7 10:17:05 amd kernel: [ 3147]  1000  3147    12891      425      12      214             0 mate-session
Nov  7 10:17:05 amd kernel: [ 3172]  1000  3172     1083        5       3       46             0 ssh-agent
Nov  7 10:17:05 amd kernel: [ 3175]  1000  3175      985       60       4       62             0 dbus-launch
Nov  7 10:17:05 amd kernel: [ 3176]  1000  3176     1398      303       4       46             0 dbus-daemon
Nov  7 10:17:05 amd kernel: [ 3180]  1000  3180     6340      284       7       44             0 dconf-service
Nov  7 10:17:05 amd kernel: [ 3187]  1000  3187    41594     1212      22      304             0 mate-settings-d
Nov  7 10:17:05 amd kernel: [ 3189]  1000  3189    30867     1213      17      219             0 marco
Nov  7 10:17:05 amd kernel: [ 3194]  1000  3194    39266      634      27      299             0 mate-panel
Nov  7 10:17:05 amd kernel: [ 3197]  1000  3197     7866       84       8       64             0 gvfsd
Nov  7 10:17:05 amd kernel: [ 3217]  1000  3217    40321      407      34      385             0 caja
Nov  7 10:17:05 amd kernel: [ 3233]  1000  3233    32690      981      23      202             0 wnck-applet
Nov  7 10:17:05 amd kernel: [ 3234]  1000  3234     7912      440       9      151             0 polkit-mate-aut
Nov  7 10:17:05 amd kernel: [ 3240]  1000  3240     8806      496      11     1188             0 smart-notifier
Nov  7 10:17:05 amd kernel: [ 3245]  1000  3245    45490      832      19      360             0 mate-volume-con
Nov  7 10:17:05 amd kernel: [ 3246]  1000  3246     8012      551       8      173             0 xfce4-power-man
Nov  7 10:17:05 amd kernel: [ 3247]  1000  3247    13873      899      13      162             0 mate-screensave
Nov  7 10:17:05 amd kernel: [ 3249]  1000  3249    10541      717       9      129             0 gvfs-udisks2-vo
Nov  7 10:17:05 amd kernel: [ 3253]  1000  3253    60129      938      15      165             0 pulseaudio
Nov  7 10:17:05 amd kernel: [ 3258]  1000  3258    62710     8019      48      538             0 nm-applet
Nov  7 10:17:05 amd kernel: [ 3262]  1000  3262    10770      536      11      177             0 mate-power-mana
Nov  7 10:17:05 amd kernel: [ 3264]  1000  3264    10013      569      11     1269             0 applet.py
Nov  7 10:17:05 amd kernel: [ 3266]     0  3266    15506      254      11      210             0 udisksd
Nov  7 10:17:05 amd kernel: [ 3273]  1000  3273     1783      148       3       41             0 xfconfd
Nov  7 10:17:05 amd kernel: [ 3277]  1000  3277    10766       34      10      149             0 gvfs-afc-volume
Nov  7 10:17:05 amd kernel: [ 3286]  1000  3286     7566       39       7       99             0 gvfs-mtp-volume
Nov  7 10:17:05 amd kernel: [ 3291]  1000  3291     7635       14       7      109             0 gvfs-goa-volume
Nov  7 10:17:05 amd kernel: [ 3300]  1000  3300     7814      348       8       79             0 gvfs-gphoto2-vo
Nov  7 10:17:05 amd kernel: [ 3303]     0  3303    10699      446       8      118             0 upowerd
Nov  7 10:17:05 amd kernel: [ 3304]     0  3304     8127      487       8      442             0 console-kit-dae
Nov  7 10:17:05 amd kernel: [ 3307]  1000  3307    28674      620      15      169             0 notification-ar
Nov  7 10:17:05 amd kernel: [ 3308]  1000  3308    34892     1320      19      285             0 clock-applet
Nov  7 10:17:05 amd kernel: [ 3312]  1000  3312    12315      251      10      158             0 gvfsd-trash
Nov  7 10:17:05 amd kernel: [ 3387]  1000  3387     2363      491       5       39             0 gconfd-2
Nov  7 10:17:05 amd kernel: [ 3426]  1000  3426    39682     2893      28      643             0 mate-terminal
Nov  7 10:17:05 amd kernel: [ 3431]  1000  3431      599      113       3       33             0 gnome-pty-helpe
Nov  7 10:17:05 amd kernel: [ 3432]  1000  3432     1694      151       4      389             0 bash
Nov  7 10:17:05 amd kernel: [ 3443]  1000  3443     3951      596       7     1703             0 herdd.py
Nov  7 10:17:05 amd kernel: [ 3444]  1000  3444     1291       58       4       40             0 bash
Nov  7 10:17:05 amd kernel: [ 3445]  1000  3445     9281     1948      10      251             0 gkrellm
Nov  7 10:17:05 amd kernel: [ 3446]  1000  3446     1942      923       4      174             0 bash
Nov  7 10:17:05 amd kernel: [ 3447]  1000  3447     1370      341       4       56             0 bash
Nov  7 10:17:05 amd kernel: [ 3448]  1000  3448     1567      104       3       93             0 su
Nov  7 10:17:05 amd kernel: [ 3453]  1000  3453    12746      442      13     1805             0 emacs
Nov  7 10:17:05 amd kernel: [ 3454]  1000  3454     1693      345       4      333             0 bash
Nov  7 10:17:05 amd kernel: [ 3455]  1000  3455     1693      285       4      395             0 bash
Nov  7 10:17:05 amd kernel: [ 3558]  1000  3558     1903      658       4      354             0 bash
Nov  7 10:17:05 amd kernel: [ 3573]  1000  3573     1698       95       4      401             0 bash
Nov  7 10:17:05 amd kernel: [ 7612]  1000  7612     1696      532       4      264             0 bash
Nov  7 10:17:05 amd kernel: [ 7622]  1000  7622     1696      346       4      400             0 bash
Nov  7 10:17:05 amd kernel: [ 7631]  1000  7631     1694      698       4      182             0 bash
Nov  7 10:17:05 amd kernel: [15014]  1000 15014      560        0       2       17             0 start-pulseaudi
Nov  7 10:17:05 amd kernel: [15015]  1000 15015     4465      970       7     1989             0 xprop
Nov  7 10:17:05 amd kernel: [15640]  1000 15640     1880      434       4      497             0 bash
Nov  7 10:17:05 amd kernel: [28508]  1000 28508     1991      706       4      391             0 bash
Nov  7 10:17:05 amd kernel: [ 6878]  1000  6878    89843     8313      79     3379             0 liferea
Nov  7 10:17:05 amd kernel: [19396]  1000 19396     1291       58       4       40             0 e
Nov  7 10:17:05 amd kernel: [19397]  1000 19397    12428      259      13     1523             0 emacs
Nov  7 10:17:05 amd kernel: [19521]  1000 19521     8264      179       9      106             0 gvfsd-http
Nov  7 10:17:05 amd kernel: [ 3219]  1000  3219     1696      300       4      360             0 bash
Nov  7 10:17:05 amd kernel: [ 3255]  1000  3255     1874       95       4      575             0 bash
Nov  7 10:17:05 amd kernel: [ 4870]  1000  4870     1696      550       4      246             0 bash
Nov  7 10:17:05 amd kernel: [ 4608]  1000  4608     1695      593       4      322             0 bash
Nov  7 10:17:05 amd kernel: [ 6355]  1000  6355     1696      762       4      191             0 bash
Nov  7 10:17:05 amd kernel: [ 7312]  1000  7312     1291      397       4       40             0 e
Nov  7 10:17:05 amd kernel: [ 7313]  1000  7313    12827      598      13     1905             0 emacs
Nov  7 10:17:05 amd kernel: [ 7774]  1000  7774     4250     2487       6      428             0 periodic.py
Nov  7 10:17:05 amd kernel: [ 7788]  1000  7788     3811      692       6     1205             0 periodic_robot.
Nov  7 10:17:05 amd kernel: [11340]  1000 11340    36376     3758      23     1317             0 pidgin
Nov  7 10:17:05 amd kernel: [11749]  1000 11749   204118    31331     133     3145             0 chromium
Nov  7 10:17:05 amd kernel: [11752]  1000 11752    45753     1413      32      657             0 chromium
Nov  7 10:17:05 amd kernel: [11775]  1000 11775   265416    44752     181     9231           200 chromium
Nov  7 10:17:05 amd kernel: [11839]  1000 11839    74971     9570      84     1050           300 chromium
Nov  7 10:17:05 amd kernel: [11849]  1000 11849    67950     4866      76     2264           300 chromium
Nov  7 10:17:05 amd kernel: [11917]  1000 11917    65997     3482      69     1378           300 chromium
Nov  7 10:17:05 amd kernel: [11952]  1000 11952    63672     3053      66     1316           300 chromium
Nov  7 10:17:05 amd kernel: [11986]  1000 11986    81079    10357      91     1008           300 chromium
Nov  7 10:17:05 amd kernel: [12040]  1000 12040    70125     5836      79      855           300 chromium
Nov  7 10:17:05 amd kernel: [12078]  1000 12078    67520     5211      74     1131           300 chromium
Nov  7 10:17:05 amd kernel: [12111]  1000 12111    74646    13393      95      876           300 chromium
Nov  7 10:17:05 amd kernel: [12248]  1000 12248    64209     3739      68     1141           300 chromium
Nov  7 10:17:05 amd kernel: [12291]  1000 12291    65118     4524      72      638           300 chromium
Nov  7 10:17:05 amd kernel: [12421]  1000 12421    61028     3316      61      602           300 chromium
Nov  7 10:17:05 amd kernel: [12551]  1000 12551    66628     5912      75      598           300 chromium
Nov  7 10:17:05 amd kernel: [12597]  1000 12597    71292     6895      81      648           300 chromium
Nov  7 10:17:05 amd kernel: [12624]  1000 12624    66581     5500      73      599           300 chromium
Nov  7 10:17:05 amd kernel: [12635]  1000 12635    74269    11662      84      628           300 chromium
Nov  7 10:17:05 amd kernel: [12850]  1000 12850    67683     7367      69      600           300 chromium
Nov  7 10:17:05 amd kernel: [13227]  1000 13227    68372     6794      78      599           300 chromium
Nov  7 10:17:05 amd kernel: [13605]  1000 13605    64260     4154      68      599           300 chromium
Nov  7 10:17:05 amd kernel: [13637]  1000 13637    83078    13777      99      617           300 chromium
Nov  7 10:17:05 amd kernel: [14827]  1000 14827   113835    38725     156      755           300 chromium
Nov  7 10:17:05 amd kernel: [17380]  1000 17380    87049    19042     113      820           300 chromium
Nov  7 10:17:05 amd kernel: [18757]  1000 18757    90289    16989     111     1666           300 chromium
Nov  7 10:17:05 amd kernel: [17039]  1000 17039    76948     5478      54        0             0 ekiga
Nov  7 10:17:05 amd kernel: [23982]     0 23982     1070      406       4        0             0 agetty
Nov  7 10:17:05 amd kernel: [30773]  1000 30773    21590      779       7        0             0 mpg123
Nov  7 10:17:05 amd kernel: [31191]  1000 31191     1291      529       4        0             0 e
Nov  7 10:17:05 amd kernel: [31192]  1000 31192    12339     1831      13        0             0 emacs
Nov  7 10:17:05 amd kernel: [ 3543]  1000  3543    73485     8508      86      602           300 chromium
Nov  7 10:17:05 amd kernel: [ 3680]  1000  3680    70942     8282      81      600           300 chromium
Nov  7 10:17:05 amd kernel: [ 4444]  1000  4444    81482    17368     111      612           300 chromium
Nov  7 10:17:05 amd kernel: [ 4886]  1000  4886    88943    15184      97      762           300 chromium
Nov  7 10:17:05 amd kernel: [ 7966]  1000  7966    72013     7527      83     1116           300 chromium
Nov  7 10:17:05 amd kernel: [10779]  1000 10779    75176    13200      86      930           300 chromium
Nov  7 10:17:05 amd kernel: [14049]  1000 14049    70750     7494      82     1877           300 chromium
Nov  7 10:17:05 amd kernel: [17170]  1000 17170     1291      532       4        0             0 e
Nov  7 10:17:05 amd kernel: [17171]  1000 17171    12340     1558      14      354             0 emacs
Nov  7 10:17:05 amd kernel: [21332]  1000 21332    65154     4998      75      598           300 chromium
Nov  7 10:17:05 amd kernel: [22100]  1000 22100    67852     6860      79      598           300 chromium
Nov  7 10:17:05 amd kernel: [26883]     0 26883     2951     1279       4        0             0 sshd
Nov  7 10:17:05 amd kernel: [26896]  1000 26896     2951      805       4        0             0 sshd
Nov  7 10:17:05 amd kernel: [26903]  1000 26903     1691     1012       4        0             0 bash
Nov  7 10:17:05 amd kernel: [26913]     0 26913     2951     1293       5        0             0 sshd
Nov  7 10:17:05 amd kernel: [26926]  1000 26926     2951      797       4        0             0 sshd
Nov  7 10:17:05 amd kernel: [26935]  1000 26935     1693     1075       4        0             0 bash
Nov  7 10:17:05 amd kernel: [26942]     0 26942     2951     1281       4        0             0 sshd
Nov  7 10:17:05 amd kernel: [26955]  1000 26955     2951      811       4        0             0 sshd
Nov  7 10:17:05 amd kernel: [26966]  1000 26966     1693     1049       4        0             0 bash
Nov  7 10:17:05 amd kernel: [26973]     0 26973     2951     1286       5        0             0 sshd
Nov  7 10:17:05 amd kernel: [26986]  1000 26986     2951      803       5        0             0 sshd
Nov  7 10:17:05 amd kernel: [26999]  1000 26999     1693     1066       4        0             0 bash
Nov  7 10:17:05 amd kernel: [ 1292]  1000  1292     1691      891       4        0             0 bash
Nov  7 10:17:05 amd kernel: [ 1293]  1000  1293     5162     2395       7        0             0 mutt
Nov  7 10:17:05 amd kernel: [15777]  1000 15777     1290      624       4        0             0 e
Nov  7 10:17:05 amd kernel: [15778]  1000 15778    12339     4387      13        0             0 emacs
Nov  7 10:17:05 amd kernel: [16525]     0 16525     2951     1459       5        0             0 sshd
Nov  7 10:17:05 amd kernel: [16538]  1000 16538     2951      877       5        0             0 sshd
Nov  7 10:17:05 amd kernel: [16553]  1000 16553     1691     1108       4        0             0 bash
Nov  7 10:17:05 amd kernel: [16758]  1000 16758     1852     1164       3        0             0 ssh
Nov  7 10:17:05 amd kernel: [17590]     0 17590     2626     1368       4        0             0 sshd
Nov  7 10:17:05 amd kernel: [17593]   108 17593     2345      745       3        0             0 sshd
Nov  7 10:17:05 amd kernel: [17605]     0 17605     1975     1041       4        0             0 sshd
Nov  7 10:17:05 amd kernel: [17606]     0 17606     1975     1042       3        0             0 sshd
Nov  7 10:17:05 amd kernel: [17616]  1000 17616      560      106       2        0             0 sh
Nov  7 10:17:05 amd kernel: [17617]  1000 17617     1291      618       4        0             0 ff
Nov  7 10:17:05 amd kernel: [17618]  1000 17618    22948     6635      21        0             0 offlineimap
Nov  7 10:17:05 amd kernel: [17620]     0 17620     1975     1021       4        0             0 sshd
Nov  7 10:17:05 amd kernel: [17624]     0 17624     1975     1023       3        0             0 sshd
Nov  7 10:17:05 amd kernel: [17636]  1000 17636      560      111       2        0             0 sh
Nov  7 10:17:05 amd kernel: [17637]  1000 17637     2247     1519       4        0             0 ssh
Nov  7 10:17:05 amd kernel: [17648]     0 17648     1975      966       3        0             0 sshd
Nov  7 10:17:05 amd kernel: Out of memory: Kill process 14827 (chromium) score 330 or sacrifice child
Nov  7 10:17:05 amd kernel: Killed process 14827 (chromium) total-vm:455340kB, anon-rss:127900kB, file-rss:27000kB
Nov  7 10:55:30 amd rsyslogd: [origin software="rsyslogd" swVersion="8.4.2" x-pid="2487" x-info="http://www.rsyslog.com"] start


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
