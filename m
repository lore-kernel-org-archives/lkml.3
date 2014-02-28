Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753143AbaB1SJi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 13:09:38 -0500
Received: from mout.gmx.net ([212.227.17.22]:64986 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751900AbaB1SJg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 13:09:36 -0500
Message-ID: <5310D0DD.3030507@gmx.de>
Date: Fri, 28 Feb 2014 19:09:33 +0100
From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: How to find a good parent to bisect this bug ?
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K0:wGLK99MGn2CfEGPIFXwOo+4jVpPZhGJn2hKf+7KDGRlzshXb5Yo
 PzJrdks2Y2beMCOlzGYY2Wh5AwuY+PcDX2Yz99ka0RACiQ7AdxSjXlFQTdTj2G/Xg2nAsMz
 A70KuSBO0CZdtgrCxoxeLRI/04ywpNckHY9B7LMTuOo//aBA3yNvDbiE+7ZnaIcAwxLjAOP
 4/o6Q9PtpigvSQPLFxQQA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA256

After 4 attempts to bisect an issue with recent kernels I'm unsure how to continue.
The issue happens here at  a 32 bit stable Gentoo Linux if I try to start a KVM image. Kernels 3.12.X works fine, kernel >=v3.13 will hang shortly after I started the image with the virtual-manager. The last syslog messages are something like :



Feb 28 16:22:00 n22 kernel: INFO: rcu_sched detected stalls on CPUs/tasks: {} (detected by 2, t=60002 jiffies, g=14689, c=14688, q=21051)
Feb 28 16:22:00 n22 kernel: INFO: Stall ended before state dump start
^@^@^@^@^@^@^@^@^@




Feb 28 16:45:10 n22 polkitd[4237]: Operator of unix-session:/org/freedesktop/ConsoleKit/Session1 successfully authenticated as unix-user:root to gain TEMPORARY authorization for action org.libvirt.unix.manage for unix-process:6983:33937 [/usr/bin/python2.7 /usr/share/virt-manager/virt-manager] (owned by unix-user:tfoerste)
Feb 28 16:45:39 n22 kernel: device vnet0 entered promiscuous mode
Feb 28 16:45:39 n22 kernel: br0: port 4(vnet0) entered forwarding state
Feb 28 16:45:39 n22 kernel: br0: port 4(vnet0) entered forwarding state
Feb 28 16:45:39 n22 kernel: IPv6: ADDRCONF(NETDEV_CHANGE): br0: link becomes ready
Feb 28 16:45:39 n22 kernel: cgroup: libvirtd (6060) created nested cgroup for controller "memory" which has incomplete hierarchy support. Nested cgroups may change behavior in the future.
Feb 28 16:45:39 n22 kernel: cgroup: "memory" requires setting use_hierarchy to 1 on the root.
Feb 28 16:45:41 n22 ntpd[5961]: Listen normally on 7 br0 fe80::71:daff:fea9:3e2 UDP 123
Feb 28 16:45:41 n22 ntpd[5961]: Listen normally on 8 vnet0 fe80::fc54:ff:fe46:1fc4 UDP 123
Feb 28 16:45:41 n22 ntpd[5961]: peers refreshed
Feb 28 16:45:52 n22 kernel: hda-intel: IRQ timing workaround is activated for card #0. Suggest a bigger bdl_pos_adj.
Feb 28 16:46:50 n22 kernel: INFO: rcu_sched self-detected stall on CPU { 0}  (t=60000 jiffies g=20876 c=20875 q=25976)
Feb 28 16:46:50 n22 kernel: sending NMI to all CPUs:
Feb 28 16:46:50 n22 kernel: NMI backtrace for cpu 2
Feb 28 16:46:50 n22 kernel: CPU: 2 PID: 6052 Comm: hsgamma_FGRP3_1 Not tainted 3.12.0-rc4+ #51
Feb 28 16:46:50 n22 kernel: Hardware name: LENOVO 4180F65/4180F65, BIOS 83ET75WW (1.45 ) 05/10/2013
Feb 28 16:46:50 n22 kernel: task: eedfbe40 ti: ee266000 task.ti: ee266000
Feb 28 16:46:50 n22 kernel: EIP: 0073:[<080921be>] EFLAGS: 00000212 CPU: 2
Feb 28 16:46:50 n22 kernel: EIP is at 0x80921be
Feb 28 16:46:50 n22 kernel: EAX: 004f98e4 EBX: 00000d2c ECX: 3d1426d5 EDX: 09e3fdb0
Feb 28 16:46:50 n22 kernel: ESI: ad422984 EDI: ad422980 EBP: 09e88448 ESP: bf9aafd0
Feb 28 16:46:50 n22 kernel: DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 007b
Feb 28 16:46:50 n22 kernel:
Feb 28 16:46:50 n22 kernel: NMI backtrace for cpu 0
Feb 28 16:46:50 n22 kernel: CPU: 0 PID: 7143 Comm: qemu-system-x86 Not tainted 3.12.0-rc4+ #51
Feb 28 16:46:50 n22 kernel: Hardware name: LENOVO 4180F65/4180F65, BIOS 83ET75WW (1.45 ) 05/10/2013
Feb 28 16:46:50 n22 kernel: task: e1040a60 ti: e10ae000 task.ti: e10ae000
Feb 28 16:46:50 n22 kernel: EIP: 0060:[<c12f3c71>] EFLAGS: 00000006 CPU: 0
Feb 28 16:46:50 n22 kernel: EIP is at __const_udelay+0x1/0x20
Feb 28 16:46:50 n22 kernel: EAX: 00418958 EBX: 00002710 ECX: c1617ae0 EDX: fffff000
Feb 28 16:46:50 n22 kernel: ESI: 00006578 EDI: c161de40 EBP: e10afc98 ESP: e10afc88
Feb 28 16:46:50 n22 kernel: DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
Feb 28 16:46:50 n22 kernel: CR0: 80050033 CR2: 00000000 CR3: 00148000 CR4: 000427f0
Feb 28 16:46:50 n22 kernel: Stack:
Feb 28 16:46:50 n22 kernel: e10afc98 c102d665 c1574fe0 f3643f80 e10afcdc c10b47eb c157ff7c 0000ea60
Feb 28 16:46:50 n22 kernel: 0000518c 0000518b 00006578 c106b2dd 00000001 00000092 c1656244 f3643f80
Feb 28 16:46:50 n22 kernel: 00000000 c161de40 e1040a60 00000000 00000000 e10afcf0 c1049a1b f3643de0
Feb 28 16:46:50 n22 kernel: Call Trace:
Feb 28 16:46:50 n22 kernel: [<c102d665>] ? arch_trigger_all_cpu_backtrace+0x55/0x70
Feb 28 16:46:50 n22 kernel: [<c10b47eb>] rcu_check_callbacks+0x29b/0x510
Feb 28 16:46:50 n22 kernel: [<c106b2dd>] ? account_system_time+0xbd/0x170
Feb 28 16:46:50 n22 kernel: [<c1049a1b>] update_process_times+0x3b/0x70
Feb 28 16:46:50 n22 kernel: [<c1091173>] tick_sched_handle.isra.11+0x33/0x40
Feb 28 16:46:50 n22 kernel: [<c1091330>] tick_sched_timer+0x40/0x70
Feb 28 16:46:50 n22 kernel: [<c105da40>] ? __remove_hrtimer+0x40/0xa0
Feb 28 16:46:50 n22 kernel: [<c105dcf9>] __run_hrtimer+0x69/0x190
Feb 28 16:46:50 n22 kernel: [<c10912f0>] ? tick_sched_do_timer+0x40/0x40
Feb 28 16:46:50 n22 kernel: [<c105e877>] hrtimer_interrupt+0xf7/0x290
Feb 28 16:46:50 n22 kernel: [<c102b3df>] local_apic_timer_interrupt+0x2f/0x60
Feb 28 16:46:50 n22 kernel: [<c1041df5>] ? irq_enter+0x15/0x60
Feb 28 16:46:50 n22 kernel: [<c14a2203>] smp_apic_timer_interrupt+0x33/0x50
Feb 28 16:46:50 n22 kernel: [<c14a14fc>] apic_timer_interrupt+0x34/0x3c
Feb 28 16:46:50 n22 kernel: [<f8932c2d>] ? kvm_arch_vcpu_ioctl_run+0x8ad/0x10a0 [kvm]
Feb 28 16:46:50 n22 kernel: [<f8921760>] ? kvm_vm_ioctl_unregister_coalesced_mmio+0x110/0x110 [kvm]
Feb 28 16:46:50 n22 kernel: [<f8921790>] ? kvm_set_ioapic_irq+0x30/0x30 [kvm]
Feb 28 16:46:50 n22 kernel: [<c1066938>] ? ttwu_do_activate.constprop.92+0x58/0x70
Feb 28 16:46:50 n22 kernel: [<f892e1e8>] ? kvm_arch_vcpu_load+0x58/0x200 [kvm]
Feb 28 16:46:50 n22 kernel: [<f891e003>] kvm_vcpu_ioctl+0x453/0x4f0 [kvm]
Feb 28 16:46:50 n22 kernel: [<c106bdf8>] ? __enqueue_entity+0x78/0x80
Feb 28 16:46:50 n22 kernel: [<c106f72c>] ? put_prev_task_fair+0x5c/0x3e0
Feb 28 16:46:50 n22 kernel: [<c106bd55>] ? __dequeue_entity+0x25/0x40
Feb 28 16:46:50 n22 kernel: [<f891dbb0>] ? vcpu_put+0x30/0x30 [kvm]
Feb 28 16:46:50 n22 kernel: [<c113e937>] do_vfs_ioctl+0x77/0x560
Feb 28 16:46:50 n22 kernel: [<c149f13e>] ? __schedule+0x22e/0x690
Feb 28 16:46:50 n22 kernel: [<c10956cb>] ? SyS_futex+0x9b/0x150
Feb 28 16:46:50 n22 kernel: [<c113ee65>] SyS_ioctl+0x45/0x70
Feb 28 16:46:50 n22 kernel: [<c14a1b81>] sysenter_do_call+0x12/0x22
Feb 28 16:46:50 n22 kernel: [<c14a0000>] ? yield+0x30/0x30
Feb 28 16:46:50 n22 kernel: Code: 00 00 00 8d bc 27 00 00 00 00 48 75 fd 48 5d c3 8d 76 00 8d bc 27 00 00 00 00 55 89 e5 66 66 66 66 90 ff 15 8c 6d 63 c1 5d c3 55 <c1> e0 02 89 e5 64 8b 15 5c 1f 6e c1 69 d2 fa 00 00 00 f7 e2 8d
Feb 28 16:46:50 n22 kernel: NMI backtrace for cpu 3
Feb 28 16:46:50 n22 kernel: CPU: 3 PID: 6053 Comm: hsgamma_FGRP3_1 Not tainted 3.12.0-rc4+ #51
Feb 28 16:46:50 n22 kernel: Hardware name: LENOVO 4180F65/4180F65, BIOS 83ET75WW (1.45 ) 05/10/2013
Feb 28 16:46:50 n22 kernel: task: eedfb910 ti: eecf8000 task.ti: eecf8000
Feb 28 16:46:50 n22 kernel: EIP: 0073:[<080921be>] EFLAGS: 00000202 CPU: 3
Feb 28 16:46:50 n22 kernel: EIP is at 0x80921be
Feb 28 16:46:50 n22 kernel: EAX: 008bfef8 EBX: 00001318 ECX: 3c0f125e EDX: 09f63700
Feb 28 16:46:50 n22 kernel: ESI: ae9588e4 EDI: ae9588e0 EBP: 09fa9e98 ESP: bfa2cf60
Feb 28 16:46:50 n22 kernel: DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 007b
Feb 28 16:46:50 n22 kernel:
Feb 28 16:46:50 n22 kernel: NMI backtrace for cpu 1
Feb 28 16:46:50 n22 kernel: CPU: 1 PID: 0 Comm: swapper/1 Not tainted 3.12.0-rc4+ #51
Feb 28 16:46:50 n22 kernel: Hardware name: LENOVO 4180F65/4180F65, BIOS 83ET75WW (1.45 ) 05/10/2013
Feb 28 16:46:50 n22 kernel: task: f216e290 ti: f2194000 task.ti: f2194000
...





Feb 23 23:16:13 n22 ntpd[5994]: peers refreshed
Feb 23 23:17:04 n22 kernel: iwlwifi 0000:03:00.0: fail to flush all tx fifo queues Q 0
Feb 23 23:17:04 n22 kernel: iwlwifi 0000:03:00.0: Current SW read_ptr 33 write_ptr 34
Feb 23 23:17:04 n22 kernel: iwl data: 00000000: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
Feb 23 23:17:04 n22 kernel: iwlwifi 0000:03:00.0: FH TRBs(0) = 0x00000000
...
Feb 23 23:17:13 n22 kernel: ieee80211 phy0: Hardware restart was requested
Feb 23 23:17:13 n22 kernel: ------------[ cut here ]------------
Feb 23 23:17:13 n22 kernel: WARNING: CPU: 3 PID: 49 at drivers/net/wireless/iwlwifi/dvm/../iwl-trans.h:689 iwlagn_mac_flush+0xcf/0xe0 [iwldvm]()
Feb 23 23:17:13 n22 kernel: iwl_trans_wait_tx_queue_empty bad state = 0
...


I tried bisecting between v3.12..v3.13, v3.11..37bf06375 and v3.10..v3.13. It yields always to commit ids which can't really be blamed. The history of the last bisect is :

$ cat ~/tmp/BISECT_LOG
# bad: [d8ec26d7f8287f5788a494f56e8814210f0e64be] Linux 3.13
# good: [8bb495e3f02401ee6f76d1b1d77f3ac9f079e376] Linux 3.10
git bisect start 'v3.13' 'v3.10'
# good: [2bb9936beac2eed0c1ed907f83694bc752e159d9] doc: usb: Fix typo in Documentation/usb/gadget_configs.txt
git bisect good 2bb9936beac2eed0c1ed907f83694bc752e159d9
# bad: [c6d65bf246fbba6e9042a35aba050d2a92f39505] Merge tag 'regulator-v3.13' of git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regulator
git bisect bad c6d65bf246fbba6e9042a35aba050d2a92f39505
# good: [d6570b33a1c0620774fe693030ef9e0317dafd84] staging:iio:ad7280a: Report scale as fractional value
git bisect good d6570b33a1c0620774fe693030ef9e0317dafd84
# good: [0b1e73ed225d8f7aeef96b74147215ca8b990dce] Merge tag 'staging-3.13-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging
git bisect good 0b1e73ed225d8f7aeef96b74147215ca8b990dce
# good: [78d4a42069b4815040a857a4e9bb0e4fb0aa1dc8] Merge branch 'parisc-3.13' of git://git.kernel.org/pub/scm/linux/kernel/git/deller/parisc-linux
git bisect good 78d4a42069b4815040a857a4e9bb0e4fb0aa1dc8
# bad: [39cf275a1a18ba3c7eb9b986c5c9b35b57332798] Merge branch 'sched-core-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
git bisect bad 39cf275a1a18ba3c7eb9b986c5c9b35b57332798
# good: [ac6976255076d4bf761abfbecb19d46af5b88046] perf tools: Show single option when failed to parse
git bisect good ac6976255076d4bf761abfbecb19d46af5b88046
# bad: [7053ea1a34fa8567cb5e3c39e04ace4c5d0fbeaa] stop_machine: Fix race between stop_two_cpus() and stop_cpus()
git bisect bad 7053ea1a34fa8567cb5e3c39e04ace4c5d0fbeaa
# bad: [7a0f308337d11fd5caa9f845c6d08cc5d6067988] sched/numa: Resist moving tasks towards nodes with fewer hinting faults
git bisect bad 7a0f308337d11fd5caa9f845c6d08cc5d6067988
# good: [48c2521717b39cb6904941ec2847d9775669207a] sched/wait: Collapse __wait_event_interruptible_exclusive()
git bisect good 48c2521717b39cb6904941ec2847d9775669207a
# bad: [b8916634b77bffb233d8f2f45703c80343457cc1] mm: Prevent parallel splits during THP migration
git bisect bad b8916634b77bffb233d8f2f45703c80343457cc1
# skip: [c2eb505b9b24d5e912798c033814ff429b1a8823] MAINTAINERS, sched: Update file pattern
git bisect skip c2eb505b9b24d5e912798c033814ff429b1a8823
# good: [a1dc6852ac5eecdcd3122ae01703183a3e88e979] sched/wait: Collapse __wait_event_interruptible_lock_irq_timeout()
git bisect good a1dc6852ac5eecdcd3122ae01703183a3e88e979
# good: [6bfa687c19b7ab8adee03f0d43c197c2945dd869] sched/rt: Remove redundant nr_cpus_allowed test
git bisect good 6bfa687c19b7ab8adee03f0d43c197c2945dd869
# bad: [c69307d533d7aa7cc8894dbbb8a274599f8630d7] sched/numa: Fix comments
git bisect bad c69307d533d7aa7cc8894dbbb8a274599f8630d7
# skip: [10fc05d0e551146ad6feb0ab8902d28a2d3c5624] mm: numa: Document automatic NUMA balancing sysctls
git bisect skip 10fc05d0e551146ad6feb0ab8902d28a2d3c5624
# skip: [37bf06375c90a42fe07b9bebdb07bc316ae5a0ce] Merge tag 'v3.12-rc4' into sched/core
git bisect skip 37bf06375c90a42fe07b9bebdb07bc316ae5a0ce
# only skipped commits left to test
# possible first bad commit: [c69307d533d7aa7cc8894dbbb8a274599f8630d7] sched/numa: Fix comments
# possible first bad commit: [10fc05d0e551146ad6feb0ab8902d28a2d3c5624] mm: numa: Document automatic NUMA balancing sysctls
# possible first bad commit: [37bf06375c90a42fe07b9bebdb07bc316ae5a0ce] Merge tag 'v3.12-rc4' into sched/core


B/c all v3.13.X and v3.14-rc* kernels can't be used here and v3.12.13 seems to be the last of its series I'm wondering how to continue.

(And there's no a fun in bisecting this kind bugs).


- -- 
MfG/Sincerely
Toralf Förster
pgp finger print:1A37 6F99 4A9D 026F 13E2 4DCF C4EA CDDE 0076 E94E
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF4EAREIAAYFAlMQ0N0ACgkQxOrN3gB26U7gXQD+Nh3beqHGxi8nDtnnVgHa+48O
GchTnjx3f0It6Y78rr4A/2RJ8HX9QZrEpSuHYfdEh1QP86GVrvuXnD3pcNZc7F26
=DLQ0
-----END PGP SIGNATURE-----
