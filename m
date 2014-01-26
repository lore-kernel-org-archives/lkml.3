Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753032AbaAZKkR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jan 2014 05:40:17 -0500
Received: from mout.gmx.net ([212.227.15.18]:51784 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752480AbaAZKkO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jan 2014 05:40:14 -0500
Message-ID: <52E4E606.1020409@gmx.de>
Date: Sun, 26 Jan 2014 11:40:06 +0100
From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Paolo Bonzini <pbonzini@redhat.com>, Dave Hansen <dave.hansen@intel.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
CC: kernel@gentoo.org, kvm@vger.kernel.org, Gleb Natapov <gleb@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: 3.13 hangs when I tried to start a KVM at a 32 bit stable Gentoo
References: <52DEA270.60803@gmx.de> <52E165B7.6020506@intel.com> <52E16E83.6060301@intel.com> <52E17273.2030200@gmx.de> <52E25E5D.1020806@redhat.com>
In-Reply-To: <52E25E5D.1020806@redhat.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K0:yi06otLgrDVowjVBg3czensReFCKiedycS5UqR8MMJCd38L1vk2
 p23XieQncx9KyX3z2YSNrWqt+P16h3p8CPfeDvS64XdM1kozlrD088rg5zF4KPHo7KKAnAa
 1Vep/zSZgunPAfBlLOlHZdVtz6KaUENVLqaRe7a3QfsoQVrOkhmaGbp/Y7YZn6O8AU1LSev
 /y4Bi6rzFm+qaa9iyU5OA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA256

On 01/24/2014 01:36 PM, Paolo Bonzini wrote:
> Il 23/01/2014 20:50, Toralf Förster ha scritto:
> | What makes the situation really annyoing - sometimes I just can
> | restart my wlan device it the system works normal, but sometimes
> | the whole system hangs and for those cases then sometimes not even
> | sysrq buttons do work.
> 
> Can you reproduce it with the wlan driver disabled completely?

yes - with CONFIG_WLAN=n I do get a similar thing :


Jan 26 11:23:17 n22 kernel: NET: Registered protocol family 17
Jan 26 11:23:17 n22 kernel: device vnet0 entered promiscuous mode
Jan 26 11:23:17 n22 kernel: br0: port 4(vnet0) entered forwarding state
Jan 26 11:23:17 n22 kernel: br0: port 4(vnet0) entered forwarding state
Jan 26 11:23:17 n22 kernel: IPv6: ADDRCONF(NETDEV_CHANGE): br0: link becomes ready
Jan 26 11:23:17 n22 kernel: cgroup: libvirtd (6113) created nested cgroup for controller "memory" which has incomplete hierarchy support. Nested cgroups may change behavior in the future.
Jan 26 11:23:17 n22 kernel: cgroup: "memory" requires setting use_hierarchy to 1 on the root.
Jan 26 11:23:19 n22 ntpd[6015]: Listen normally on 5 br0 fe80::837:18ff:feae:caf0 UDP 123
Jan 26 11:23:19 n22 ntpd[6015]: Listen normally on 6 vnet0 fe80::fc54:ff:fed0:f1eb UDP 123
Jan 26 11:23:19 n22 ntpd[6015]: peers refreshed
Jan 26 11:23:35 n22 kernel: br0: port 4(vnet0) entered disabled state
Jan 26 11:23:35 n22 kernel: device vnet0 left promiscuous mode
Jan 26 11:23:35 n22 kernel: br0: port 4(vnet0) entered disabled state
Jan 26 11:23:38 n22 ntpd[6015]: Deleting interface #6 vnet0, fe80::fc54:ff:fed0:f1eb#123, interface stats: received=0, sent=0, dropped=0, active_time=19 secs
Jan 26 11:23:38 n22 ntpd[6015]: peers refreshed
Jan 26 11:23:45 n22 kernel: device vnet0 entered promiscuous mode
Jan 26 11:23:45 n22 kernel: br0: port 4(vnet0) entered forwarding state
Jan 26 11:23:45 n22 kernel: br0: port 4(vnet0) entered forwarding state
Jan 26 11:23:48 n22 ntpd[6015]: Listen normally on 7 vnet0 fe80::fc54:ff:fed0:f1eb UDP 123
Jan 26 11:23:48 n22 ntpd[6015]: peers refreshed
Jan 26 11:24:09 n22 kernel: br0: port 4(vnet0) entered disabled state
Jan 26 11:24:09 n22 kernel: device vnet0 left promiscuous mode
Jan 26 11:24:09 n22 kernel: br0: port 4(vnet0) entered disabled state
Jan 26 11:24:11 n22 ntpd[6015]: Deleting interface #7 vnet0, fe80::fc54:ff:fed0:f1eb#123, interface stats: received=0, sent=0, dropped=0, active_time=23 secs
Jan 26 11:24:11 n22 ntpd[6015]: peers refreshed
Jan 26 11:24:28 n22 kernel: device vnet0 entered promiscuous mode
Jan 26 11:24:28 n22 kernel: br0: port 4(vnet0) entered forwarding state
Jan 26 11:24:28 n22 kernel: br0: port 4(vnet0) entered forwarding state
Jan 26 11:24:31 n22 ntpd[6015]: Listen normally on 8 vnet0 fe80::fc54:ff:fed0:f1eb UDP 123
Jan 26 11:24:31 n22 ntpd[6015]: peers refreshed
Jan 26 11:24:57 n22 kernel: hda-intel: IRQ timing workaround is activated for card #0. Suggest a bigger bdl_pos_adj.
Jan 26 11:25:34 n22 kernel: INFO: rcu_sched self-detected stall on CPU { 3}  (t=60000 jiffies g=23149 c=23148 q=7132)
Jan 26 11:25:34 n22 kernel: sending NMI to all CPUs:
Jan 26 11:25:34 n22 kernel: NMI backtrace for cpu 3
Jan 26 11:25:34 n22 kernel: CPU: 3 PID: 6523 Comm: qemu-system-x86 Not tainted 3.13.0 #5
Jan 26 11:25:34 n22 kernel: Hardware name: LENOVO 4180F65/4180F65, BIOS 83ET75WW (1.45 ) 05/10/2013
Jan 26 11:25:34 n22 kernel: task: e410c8a0 ti: eec60000 task.ti: eec60000
Jan 26 11:25:34 n22 kernel: EIP: 0060:[<c1255bed>] EFLAGS: 00000006 CPU: 3
Jan 26 11:25:34 n22 kernel: EIP is at __const_udelay+0xd/0x20
Jan 26 11:25:34 n22 kernel: EAX: 01062560 EBX: 00002710 ECX: c1557e60 EDX: 00278af4
Jan 26 11:25:34 n22 kernel: ESI: c155c500 EDI: f3627c80 EBP: eec61c64 ESP: eec61c64
Jan 26 11:25:34 n22 kernel: DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
Jan 26 11:25:34 n22 kernel: CR0: 80050033 CR2: 00000000 CR3: 23c2e000 CR4: 000427f0
Jan 26 11:25:34 n22 kernel: Stack:
Jan 26 11:25:34 n22 kernel: eec61c74 c102dc75 c14b9db5 c155c500 eec61cb8 c108ba1c c14c3ac0 0000ea60
Jan 26 11:25:34 n22 kernel: 00005a6d 00005a6c 00001bdc c106aadd 00000001 c155c500 c1595544 f3627c80
Jan 26 11:25:34 n22 kernel: 00001bdc 00000003 e410c8a0 00000000 00000003 eec61ccc c104a2fb f3627ec0
Jan 26 11:25:34 n22 kernel: Call Trace:
Jan 26 11:25:34 n22 kernel: [<c102dc75>] arch_trigger_all_cpu_backtrace+0x55/0x70
Jan 26 11:25:34 n22 kernel: [<c108ba1c>] rcu_check_callbacks+0x38c/0x590
Jan 26 11:25:34 n22 kernel: [<c106aadd>] ? account_system_time+0xbd/0x170
Jan 26 11:25:34 n22 kernel: [<c104a2fb>] update_process_times+0x3b/0x70
Jan 26 11:25:34 n22 kernel: [<c1095983>] tick_sched_handle.isra.12+0x33/0x40
Jan 26 11:25:34 n22 kernel: [<c1095b40>] tick_sched_timer+0x40/0x70
Jan 26 11:25:34 n22 kernel: [<c105dad0>] ? __remove_hrtimer+0x40/0xa0
Jan 26 11:25:34 n22 kernel: [<c105dd89>] __run_hrtimer+0x69/0x190
Jan 26 11:25:34 n22 kernel: [<c1095b00>] ? tick_sched_do_timer+0x40/0x40
Jan 26 11:25:34 n22 kernel: [<c105e917>] hrtimer_interrupt+0xf7/0x290
Jan 26 11:25:34 n22 kernel: [<c10957c9>] ? tick_program_event+0x29/0x30
Jan 26 11:25:34 n22 kernel: [<c102b9cf>] local_apic_timer_interrupt+0x2f/0x60
Jan 26 11:25:34 n22 kernel: [<c1042855>] ? irq_enter+0x15/0x60
Jan 26 11:25:34 n22 kernel: [<c14037c3>] smp_apic_timer_interrupt+0x33/0x50
Jan 26 11:25:34 n22 kernel: [<c1402acc>] apic_timer_interrupt+0x34/0x3c
Jan 26 11:25:34 n22 kernel: [<f89a3059>] ? vmx_save_host_state+0x9/0x160 [kvm_intel]
Jan 26 11:25:34 n22 kernel: [<f98340cd>] kvm_arch_vcpu_ioctl_run+0x89d/0xff0 [kvm]
Jan 26 11:25:34 n22 kernel: [<f981f171>] kvm_vcpu_ioctl+0x421/0x500 [kvm]
Jan 26 11:25:34 n22 kernel: [<c1097c7b>] ? futex_wake+0xeb/0x110
Jan 26 11:25:34 n22 kernel: [<c1099613>] ? do_futex+0xf3/0x970
Jan 26 11:25:34 n22 kernel: [<f981ed50>] ? vcpu_put+0x30/0x30 [kvm]
Jan 26 11:25:34 n22 kernel: [<c114141f>] do_vfs_ioctl+0x6f/0x550
Jan 26 11:25:34 n22 kernel: [<c1099f2b>] ? SyS_futex+0x9b/0x150
Jan 26 11:25:34 n22 kernel: [<c1141945>] SyS_ioctl+0x45/0x70
Jan 26 11:25:34 n22 kernel: [<c1403141>] sysenter_do_call+0x12/0x22
Jan 26 11:25:34 n22 kernel: Code: fd 48 5d c3 8d 76 00 8d bc 27 00 00 00 00 55 89 e5 66 66 66 66 90 ff 15 8c 61 57 c1 5d c3 55 c1 e0 02 89 e5 64 8b 15 dc ee 61 c1 <69> d2 fa 00 00 00 f7 e2 8d 42 01 ff 15 8c 61 57 c1 5d c3 55 89
Jan 26 11:25:34 n22 kernel: NMI backtrace for cpu 0
Jan 26 11:25:34 n22 kernel: CPU: 0 PID: 6385 Comm: einstein_S6CasA Not tainted 3.13.0 #5
Jan 26 11:25:34 n22 kernel: Hardware name: LENOVO 4180F65/4180F65, BIOS 83ET75WW (1.45 ) 05/10/2013
Jan 26 11:25:34 n22 kernel: task: e8f80a60 ti: edb32000 task.ti: edb32000
Jan 26 11:25:34 n22 kernel: EIP: 0073:[<0805b146>] EFLAGS: 00000202 CPU: 0
Jan 26 11:25:34 n22 kernel: EIP is at 0x805b146
Jan 26 11:25:34 n22 kernel: EAX: 12c38f18 EBX: bf825e04 ECX: 00146be5 EDX: 12c3dc50
Jan 26 11:25:34 n22 kernel: ESI: 0000009d EDI: 0014759b EBP: bf825d18 ESP: bf825a40
Jan 26 11:25:34 n22 kernel: DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 007b
Jan 26 11:25:34 n22 kernel:
Jan 26 11:25:34 n22 kernel: NMI backtrace for cpu 2
Jan 26 11:25:34 n22 kernel: CPU: 2 PID: 0 Comm: swapper/2 Not tainted 3.13.0 #5
Jan 26 11:25:34 n22 kernel: Hardware name: LENOVO 4180F65/4180F65, BIOS 83ET75WW (1.45 ) 05/10/2013
Jan 26 11:25:34 n22 kernel: task: f21619f0 ti: f2194000 task.ti: f2194000
Jan 26 11:25:34 n22 kernel: EIP: 0060:[<c1289af8>] EFLAGS: 00200046 CPU: 2
Jan 26 11:25:34 n22 kernel: EIP is at intel_idle+0xa8/0x100
Jan 26 11:25:34 n22 kernel: EAX: 00000030 EBX: 00000010 ECX: 00000001 EDX: 00000000
Jan 26 11:25:34 n22 kernel: ESI: 00000005 EDI: 00000030 EBP: f2195f28 ESP: f2195f14
Jan 26 11:25:34 n22 kernel: DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
Jan 26 11:25:34 n22 kernel: CR0: 80050033 CR2: b1e66000 CR3: 01628000 CR4: 000427f0
Jan 26 11:25:34 n22 kernel: Stack:
Jan 26 11:25:34 n22 kernel: 00000004 00000002 c1577000 f3621d00 c157718c f2195f48 c13574a7 00000005
Jan 26 11:25:34 n22 kernel: c20f8743 00000074 15f05edb f3621d00 00000000 f2195f6c c13575d4 00000074
Jan 26 11:25:34 n22 kernel: 00000002 c1577000 00000005 15f05edb 00000000 00000000 f2195f74 c100ac7d
Jan 26 11:25:34 n22 kernel: Call Trace:
Jan 26 11:25:34 n22 kernel: [<c13574a7>] cpuidle_enter_state+0x37/0xd0
Jan 26 11:25:34 n22 kernel: [<c13575d4>] cpuidle_idle_call+0x94/0x1d0
Jan 26 11:25:34 n22 kernel: [<c100ac7d>] arch_cpu_idle+0xd/0x30
Jan 26 11:25:34 n22 kernel: [<c1083a9a>] cpu_startup_entry+0x1ea/0x230
Jan 26 11:25:34 n22 kernel: [<c102a461>] start_secondary+0x1c1/0x240
Jan 26 11:25:34 n22 kernel: Code: 89 e0 25 00 e0 ff ff 31 d2 83 c0 08 89 d1 0f 01 c8 0f ae f0 66 90 89 e0 25 00 e0 ff ff 8b 40 08 a8 08 75 07 b1 01 89 f8 0f 01 c9 <85> 1d 14 73 57 c1 75 0d 8d 55 f0 b8 05 00 00 00 e8 e3 a1 e0 ff
Jan 26 11:25:34 n22 kernel: NMI backtrace for cpu 1
Jan 26 11:25:34 n22 kernel: CPU: 1 PID: 6522 Comm: qemu-system-x86 Not tainted 3.13.0 #5
Jan 26 11:25:34 n22 kernel: Hardware name: LENOVO 4180F65/4180F65, BIOS 83ET75WW (1.45 ) 05/10/2013
Jan 26 11:25:34 n22 kernel: task: e41094c0 ti: ed8ae000 task.ti: ed8ae000
Jan 26 11:25:34 n22 kernel: EIP: 0060:[<c1088a5b>] EFLAGS: 00000286 CPU: 1
Jan 26 11:25:34 n22 kernel: EIP is at __srcu_read_unlock+0xb/0x20
Jan 26 11:25:34 n22 kernel: EAX: e8d6a0d4 EBX: e3e88000 ECX: 00000000 EDX: 00000001
Jan 26 11:25:34 n22 kernel: ESI: 00000000 EDI: 00000000 EBP: ed8afe00 ESP: ed8afe00
Jan 26 11:25:34 n22 kernel: DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
Jan 26 11:25:34 n22 kernel: CR0: 80050033 CR2: ffe16000 CR3: 23c2e000 CR4: 000427f0
Jan 26 11:25:34 n22 kernel: Stack:
Jan 26 11:25:34 n22 kernel: ed8afea4 f9834100 00000000 00000000 00000001 e8d6a0b0 00000002 00000002
Jan 26 11:25:34 n22 kernel: 00278b5d e41094c0 9189cb08 00000006 e41094c0 fb603320 00000067 00000202
Jan 26 11:25:34 n22 kernel: 00000000 28e95000 00000000 e8d6a0d4 7ffbfeff fffffffe 00000000 01010000
Jan 26 11:25:34 n22 kernel: Call Trace:
Jan 26 11:25:34 n22 kernel: [<f9834100>] kvm_arch_vcpu_ioctl_run+0x8d0/0xff0 [kvm]
Jan 26 11:25:34 n22 kernel: [<f981f171>] kvm_vcpu_ioctl+0x421/0x500 [kvm]
Jan 26 11:25:34 n22 kernel: [<c106b618>] ? __enqueue_entity+0x78/0x80
Jan 26 11:25:34 n22 kernel: [<c106f98c>] ? put_prev_task_fair+0x5c/0x3e0
Jan 26 11:25:34 n22 kernel: [<c106b575>] ? __dequeue_entity+0x25/0x40
Jan 26 11:25:34 n22 kernel: [<f981ed50>] ? vcpu_put+0x30/0x30 [kvm]
Jan 26 11:25:34 n22 kernel: [<c114141f>] do_vfs_ioctl+0x6f/0x550
Jan 26 11:25:34 n22 kernel: [<c13ff60e>] ? __schedule+0x22e/0x690
Jan 26 11:25:34 n22 kernel: [<c105e998>] ? hrtimer_interrupt+0x178/0x290
Jan 26 11:25:34 n22 kernel: [<c10517f9>] ? getrusage+0x319/0x350
Jan 26 11:25:34 n22 kernel: [<c1145780>] ? dget_parent+0x70/0x70
Jan 26 11:25:34 n22 kernel: [<c10517f9>] ? getrusage+0x319/0x350
Jan 26 11:25:34 n22 kernel: [<c10517f9>] ? getrusage+0x319/0x350
Jan 26 11:25:34 n22 kernel: [<c1141945>] SyS_ioctl+0x45/0x70
Jan 26 11:25:34 n22 kernel: [<c1403141>] sysenter_do_call+0x12/0x22
Jan 26 11:25:34 n22 kernel: Code: 91 0f ae f0 66 90 8b 40 04 64 03 05 24 a7 61 c1 8b 4c 90 08 83 c1 01 89 4c 90 08 5b 89 d0 5d c3 55 89 e5 66 66 66 66 90 0f ae f0 <66> 90 8b 40 04 64 ff 0c 90 5d c3 8d 76 00 8d bc 27 00 00 00 00
Jan 26 11:26:10 n22 su[6563]: Successful su for root by root
Jan 26 11:26:10 n22 su[6563]: + /dev/pts/4 root:root
Jan 26 11:26:10 n22 su[6563]: pam_unix(su:session): session opened for user root by tfoerste(uid=0)
Jan 26 11:26:50 n22 polkitd[4259]: Operator of unix-session:/org/freedesktop/ConsoleKit/Session1 successfully authenticated as unix-user:root to gain TEMPORARY authorization for action org.libvirt.unix.manage for unix-process:6597:57390 [/usr/bin/python2.7 /usr/share/virt-manager/virt-manager] (owned by unix-user:tfoerste)
Jan 26 11:27:18 n22 kernel: SysRq : Emergency Sync
Jan 26 11:27:18 n22 kernel: Emergency Sync complete


- -- 
MfG/Sincerely
Toralf Förster
pgp finger print:1A37 6F99 4A9D 026F 13E2 4DCF C4EA CDDE 0076 E94E
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF4EAREIAAYFAlLk5gYACgkQxOrN3gB26U5zMAD+OoV7eCtjYkLGolGEh454sWNr
/mImeXwgajkNnCbOGmwA+wXSG0t4fNbahKYSpYrTPYGhvwvyLzSo8XDBJKQnyG9l
=JXqd
-----END PGP SIGNATURE-----
