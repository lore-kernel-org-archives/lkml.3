Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752866Ab3I0NNK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 09:13:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27644 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751210Ab3I0NNI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 09:13:08 -0400
Message-ID: <5245845F.5090100@redhat.com>
Date: Fri, 27 Sep 2013 15:13:03 +0200
From: Zdenek Kabelac <zkabelac@redhat.com>
Organization: Red Hat
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130805 Thunderbird/17.0.8
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Crash of 3.12-rc2 BUG: unable to handle kernel NULL pointer dereference
References: <524572BF.5060407@redhat.com>
In-Reply-To: <524572BF.5060407@redhat.com>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dne 27.9.2013 13:57, Zdenek Kabelac napsal(a):
> Hi
>
>
> I'm trying to use -rc2 kernel however I'm getting quite often regular kernel
> panic:
>
> Here is a BUG trace from kvm running this kernel:
> (I'm building kernel with some kernel debug checks)
> (Kernel is used in 64bit qemu and running 32bit Debian environment)
> linux-vanilla git: 4b97280675f45c1650ee4e388bd711ecbb18c4b4
> (on top of that there are few minor unrelated patches)
>
>
> [  235.631952] loop: module loaded
> [  235.971853] bio: create slab <bio-1> at 1
> [  237.355014] bio: create slab <bio-2> at 2
> [  237.671371] BUG: unable to handle kernel NULL pointer dereference at
> 0000000000000018
> [  237.674537] IP: [<ffffffff8105a008>] get_next_timer_interrupt+0x168/0x250
> [  237.674537] PGD 16939067 PUD 14257067 PMD 0
> [  237.674537] Oops: 0000 [#1] PREEMPT SMP
> [  237.674537] Modules linked in: loop dm_thin_pool dm_persistent_data


Here is the same trace from my native  HW   Lenovo T61:

I'm suspecting new debug option:
  CONFIG_DEBUG_KOBJECT_RELEASE which I've recently enabled)

I've also noticed there are much older reports for this problem:
i.e. https://lkml.org/lkml/2013/3/9/3

I can trigger this bug very easily (makes 3.12-rc2 unusable for my desktop)


[  120.327263] bio: create slab <bio-1> at 1
[  120.633731] bio: create slab <bio-2> at 2
[  120.662856] BUG: unable to handle kernel NULL pointer dereference at 
0000000000000018
[  120.666137] IP: [<ffffffff8105a008>] get_next_timer_interrupt+0x168/0x250
[  120.666137] PGD 0
[  120.666137] Oops: 0000 [#1] PREEMPT SMP
[  120.666137] Modules linked in: dm_thin_pool dm_persistent_data dm_bufio 
dm_bio_prison dm_mod libcrc32c ipt_MASQUERADE iptable_nat nf_nat_ipv4 nf_nat 
nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack ipt_REJECT 
xt_CHECKSUM iptable_mangle xt_tcpudp tun bridge stp llc ipv6 ip6_tables 
iptable_filter ip_tables ebtable_nat ebtables x_tables bnep btusb bluetooth 
hid_generic usbhid hid snd_hda_codec_analog arc4 iTCO_wdt iTCO_vendor_support 
coretemp iwl3945 kvm_intel iwlegacy kvm mac80211 snd_hda_intel snd_hda_codec 
snd_seq microcode snd_seq_device sdhci_pci r852 cfg80211 sm_common psmouse 
nand sdhci i2c_i801 e1000e nand_ecc snd_pcm nand_ids i2c_core serio_raw r592 
mmc_core mtd lpc_ich memstick mfd_core ptp snd_page_alloc snd_timer 
thinkpad_acpi pps_core wmi nvram snd soundcore evdev binfmt_misc nfsd 
auth_rpcgss oid_registry exportfs nfs_acl lockd loop sunrpc pcmcia sr_mod 
cdrom yenta_socket ehci_pci uhci_hcd ehci_hcd usbcore usb_common video 
backlight autofs4
[  120.666137] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G        W 
3.12.0-rc2-00088-gfcbfc0d #163
[  120.666137] Hardware name: LENOVO 6464CTO/6464CTO, BIOS 7LETC9WW (2.29 ) 
03/18/2011
[  120.666137] task: ffffffff81a114c0 ti: ffffffff81a00000 task.ti: 
ffffffff81a00000
[  120.666137] RIP: 0010:[<ffffffff8105a008>]  [<ffffffff8105a008>] 
get_next_timer_interrupt+0x168/0x250
[  120.666137] RSP: 0018:ffffffff81a01e50  EFLAGS: 00010013
[  120.666137] RAX: 0000000000000000 RBX: 00000000ffff2dd6 RCX: 0000000000000000
[  120.666137] RDX: 0000000000000000 RSI: ffffffff81dfc508 RDI: 0000000000ffff2e
[  120.666137] RBP: ffffffff81a01e98 R08: 0000000000000001 R09: 000000000000002e
[  120.666137] R10: 000000000000002e R11: ffffffff81dfc228 R12: 000000013fff2dd5
[  120.666137] R13: ffffffff81dfb1c0 R14: ffffffff81a01e58 R15: ffffffff81a01e70
[  120.666137] FS:  0000000000000000(0000) GS:ffff880137200000(0000) 
knlGS:0000000000000000
[  120.666137] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  120.666137] CR2: 0000000000000018 CR3: 00000001341c3000 CR4: 00000000000007f0
[  120.666137] Stack:
[  120.666137]  ffffffff81dfc228 ffffffff81dfc628 ffffffff81dfca28 
ffffffff81dfce28
[  120.666137]  0000000000000000 0000001c18108669 00000000ffff2dd6 
ffff88013720d080
[  120.666137]  ffff88013720de40 ffffffff81a01f00 ffffffff810bdce5 
0000001b31c77648
[  120.666137] Call Trace:
[  120.666137]  [<ffffffff810bdce5>] __tick_nohz_idle_enter+0x2e5/0x550
[  120.666137]  [<ffffffff810bdf91>] tick_nohz_idle_enter+0x41/0x70
[  120.666137]  [<ffffffff810ac89c>] cpu_startup_entry+0x3c/0x400
[  120.666137]  [<ffffffff8158bce2>] rest_init+0x132/0x140
[  120.666137]  [<ffffffff8158bbb5>] ? rest_init+0x5/0x140
[  120.666137]  [<ffffffff81cb1e49>] start_kernel+0x3c2/0x3cf
[  120.666137]  [<ffffffff81cb188f>] ? repair_env_string+0x5c/0x5c
[  120.666137]  [<ffffffff81cb15a3>] x86_64_start_reservations+0x2a/0x2c
[  120.666137]  [<ffffffff81cb1696>] x86_64_start_kernel+0xf1/0xf4
[  120.666137] Code: 89 fa 41 83 e2 3f 45 89 d1 66 2e 0f 1f 84 00 00 00 00 00 
49 63 f1 48 c1 e6 04 4c 01 de 48 8b 06 48 39 f0 74 25 66 0f 1f 44 00 00 <f6> 
40 18 01 75 11 48 8b 48 10 41 b8 01 00 00 00 48 39 d1 48 0f
[  120.666137] RIP  [<ffffffff8105a008>] get_next_timer_interrupt+0x168/0x250
[  120.666137]  RSP <ffffffff81a01e50>
[  120.666137] CR2: 0000000000000018
[  120.666137] ---[ end trace c4429f55908a7532 ]---
[  120.666137] Kernel panic - not syncing: Attempted to kill the idle task!
[  121.005821] BUG: spinlock lockup suspected on CPU#0, swapper/0/0
[  121.005821]  lock: boot_tvec_bases+0x0/0x2080, .magic: dead4ead, .owner: 
swapper/0/0, .owner_cpu: 0
[  121.005821] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G      D W 
3.12.0-rc2-00088-gfcbfc0d #163
[  121.005821] Hardware name: LENOVO 6464CTO/6464CTO, BIOS 7LETC9WW (2.29 ) 
03/18/2011
[  121.005821]  ffffffff81dfb1c0 ffff880137203e28 ffffffff81595d57 
ffffffff81a114c0
[  121.005821]  ffff880137203e48 ffffffff81595e17 ffffffff81dfb1c0 
0000000082cbe238
[  121.005821]  ffff880137203e70 ffffffff813432ea ffffffff81dfb1c0 
ffffffff81dfb1d8
[  121.005821] Call Trace:
[  121.005821]  <IRQ>  [<ffffffff81595d57>] dump_stack+0x4e/0x82
[  121.005821]  [<ffffffff81595e17>] spin_dump+0x8c/0x91
[  121.005821]  [<ffffffff813432ea>] do_raw_spin_lock+0x6a/0x140
[  121.005821]  [<ffffffff8159d666>] _raw_spin_lock_irq+0x66/0x80
[  121.005821]  [<ffffffff81058eed>] ? run_timer_softirq+0x3d/0x380
[  121.005821]  [<ffffffff81058eed>] run_timer_softirq+0x3d/0x380
[  121.005821]  [<ffffffff810c2e7d>] ? trace_hardirqs_on+0xd/0x10
[  121.005821]  [<ffffffff810500f7>] __do_softirq+0xf7/0x420
[  121.005821]  [<ffffffff810505c5>] irq_exit+0xb5/0xc0
[  121.005821]  [<ffffffff815a86a5>] smp_apic_timer_interrupt+0x45/0x60
[  121.005821]  [<ffffffff815a732f>] apic_timer_interrupt+0x6f/0x80
[  121.005821]  <EOI>  [<ffffffff8159e5a0>] ? retint_restore_args+0xe/0xe
[  121.005821]  [<ffffffff810c2e7d>] ? trace_hardirqs_on+0xd/0x10
[  121.005821]  [<ffffffff81590cac>] ? panic+0x197/0x1d5
[  121.005821]  [<ffffffff81590ca8>] ? panic+0x193/0x1d5
[  121.005821]  [<ffffffff8104c914>] do_exit+0xb24/0xc30
[  121.005821]  [<ffffffff810ac4cd>] ? kmsg_dump+0x1bd/0x230
[  121.005821]  [<ffffffff810ac335>] ? kmsg_dump+0x25/0x230
[  121.005821]  [<ffffffff8159f390>] oops_end+0x90/0xd0
[  121.005821]  [<ffffffff815906f9>] no_context+0x268/0x275
[  121.005821]  [<ffffffff8159077e>] __bad_area_nosemaphore+0x78/0x1d1
[  121.005821]  [<ffffffff815908ea>] bad_area_nosemaphore+0x13/0x15
[  121.005821]  [<ffffffff815a19fe>] __do_page_fault+0x37e/0x5e0
[  121.005821]  [<ffffffff810bf70f>] ? trace_hardirqs_off_caller+0x1f/0xc0
[  121.005821]  [<ffffffff8159e9e3>] ? error_sti+0x5/0x6
[  121.005821]  [<ffffffff8133bc1d>] ? trace_hardirqs_off_thunk+0x3a/0x3c
[  121.005821]  [<ffffffff815a1c6e>] do_page_fault+0xe/0x10
[  121.005821]  [<ffffffff8159e7e2>] page_fault+0x22/0x30
[  121.005821]  [<ffffffff8105a008>] ? get_next_timer_interrupt+0x168/0x250
[  121.005821]  [<ffffffff810bdce5>] __tick_nohz_idle_enter+0x2e5/0x550
[  121.005821]  [<ffffffff810bdf91>] tick_nohz_idle_enter+0x41/0x70
[  121.005821]  [<ffffffff810ac89c>] cpu_startup_entry+0x3c/0x400
[  121.005821]  [<ffffffff8158bce2>] rest_init+0x132/0x140
[  121.005821]  [<ffffffff8158bbb5>] ? rest_init+0x5/0x140
[  121.005821]  [<ffffffff81cb1e49>] start_kernel+0x3c2/0x3cf
[  121.005821]  [<ffffffff81cb188f>] ? repair_env_string+0x5c/0x5c
[  121.005821]  [<ffffffff81cb15a3>] x86_64_start_reservations+0x2a/0x2c
[  121.005821]  [<ffffffff81cb1696>] x86_64_start_kernel+0xf1/0xf4
[  121.005821] sending NMI to all CPUs:
[  121.005821] NMI backtrace for cpu 0
[  121.005821] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G      D W 
3.12.0-rc2-00088-gfcbfc0d #163
[  121.005821] Hardware name: LENOVO 6464CTO/6464CTO, BIOS 7LETC9WW (2.29 ) 
03/18/2011
[  121.005821] task: ffffffff81a114c0 ti: ffffffff81a00000 task.ti: 
ffffffff81a00000
[  121.005821] RIP: 0010:[<ffffffff8133a883>]  [<ffffffff8133a883>] 
delay_tsc+0x73/0xe0
[  121.005821] RSP: 0018:ffff880137203df8  EFLAGS: 00000006
[  121.005821] RAX: 00000000e9b57b4c RBX: 00000000e9b57aff RCX: 00000000022e1092
[  121.005821] RDX: 0000000000000080 RSI: ffffffff81035950 RDI: 0000000000000001
[  121.005821] RBP: ffff880137203e20 R08: 0000000000000002 R09: 0000000000000104
[  121.005821] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000217bf1
[  121.005821] R13: 0000000000000000 R14: ffffffff81a05108 R15: ffffffff81a01fd8
[  121.005821] FS:  0000000000000000(0000) GS:ffff880137200000(0000) 
knlGS:0000000000000000
[  121.005821] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  121.005821] CR2: 0000000000000018 CR3: 0000000001a0c000 CR4: 00000000000007f0
[  121.005821] Stack:
[  121.005821]  0000000000002710 0000000082cbe238 0000000082cbe238 
ffffffff81a05108
[  121.005821]  0000000000000041 ffff880137203e30 ffffffff8133a77f 
ffff880137203e48
[  121.005821]  ffffffff810325b2 ffffffff81dfb1c0 ffff880137203e70 
ffffffff813432ef
[  121.005821] Call Trace:
[  121.005821]  <IRQ>
[  121.005821]  [<ffffffff8133a77f>] __const_udelay+0x2f/0x40
[  121.005821]  [<ffffffff810325b2>] arch_trigger_all_cpu_backtrace+0x62/0x80
[  121.005821]  [<ffffffff813432ef>] do_raw_spin_lock+0x6f/0x140
[  121.005821]  [<ffffffff8159d666>] _raw_spin_lock_irq+0x66/0x80
[  121.005821]  [<ffffffff81058eed>] ? run_timer_softirq+0x3d/0x380
[  121.005821]  [<ffffffff81058eed>] run_timer_softirq+0x3d/0x380
[  121.005821]  [<ffffffff810c2e7d>] ? trace_hardirqs_on+0xd/0x10
[  121.005821]  [<ffffffff810500f7>] __do_softirq+0xf7/0x420
[  121.005821]  [<ffffffff810505c5>] irq_exit+0xb5/0xc0
[  121.005821]  [<ffffffff815a86a5>] smp_apic_timer_interrupt+0x45/0x60
[  121.005821]  [<ffffffff815a732f>] apic_timer_interrupt+0x6f/0x80
[  121.005821]  <EOI>
[  121.005821]  [<ffffffff8159e5a0>] ? retint_restore_args+0xe/0xe
[  121.005821]  [<ffffffff810c2e7d>] ? trace_hardirqs_on+0xd/0x10
[  121.005821]  [<ffffffff81590cac>] ? panic+0x197/0x1d5
[  121.005821]  [<ffffffff81590ca8>] ? panic+0x193/0x1d5
[  121.005821]  [<ffffffff8104c914>] do_exit+0xb24/0xc30
[  121.005821]  [<ffffffff810ac4cd>] ? kmsg_dump+0x1bd/0x230
[  121.005821]  [<ffffffff810ac335>] ? kmsg_dump+0x25/0x230
[  121.005821]  [<ffffffff8159f390>] oops_end+0x90/0xd0
[  121.005821]  [<ffffffff815906f9>] no_context+0x268/0x275
[  121.005821]  [<ffffffff8159077e>] __bad_area_nosemaphore+0x78/0x1d1
[  121.005821]  [<ffffffff815908ea>] bad_area_nosemaphore+0x13/0x15
[  121.005821]  [<ffffffff815a19fe>] __do_page_fault+0x37e/0x5e0
[  121.005821]  [<ffffffff810bf70f>] ? trace_hardirqs_off_caller+0x1f/0xc0
[  121.005821]  [<ffffffff8159e9e3>] ? error_sti+0x5/0x6
[  121.005821]  [<ffffffff8133bc1d>] ? trace_hardirqs_off_thunk+0x3a/0x3c
[  121.005821]  [<ffffffff815a1c6e>] do_page_fault+0xe/0x10
[  121.005821]  [<ffffffff8159e7e2>] page_fault+0x22/0x30
[  121.005821]  [<ffffffff8105a008>] ? get_next_timer_interrupt+0x168/0x250
[  121.005821]  [<ffffffff810bdce5>] __tick_nohz_idle_enter+0x2e5/0x550
[  121.005821]  [<ffffffff810bdf91>] tick_nohz_idle_enter+0x41/0x70
[  121.005821]  [<ffffffff810ac89c>] cpu_startup_entry+0x3c/0x400
[  121.005821]  [<ffffffff8158bce2>] rest_init+0x132/0x140
[  121.005821]  [<ffffffff8158bbb5>] ? rest_init+0x5/0x140
[  121.005821]  [<ffffffff81cb1e49>] start_kernel+0x3c2/0x3cf
[  121.005821]  [<ffffffff81cb188f>] ? repair_env_string+0x5c/0x5c
[  121.005821]  [<ffffffff81cb15a3>] x86_64_start_reservations+0x2a/0x2c
[  121.005821]  [<ffffffff81cb1696>] x86_64_start_kernel+0xf1/0xf4
[  121.005821] Code: 26 00 49 8b 87 38 e0 ff ff a8 08 75 5a f3 90 bf 01 00 00 
00 e8 6f 77 26 00 e8 2a 8f 00 00 41 39 c5 75 4b 0f 1f 00 0f ae e8 0f 31 <48> 
c1 e2 20 89 c0 48 09 c2 41 89 d6 29 da 44 39 e2 72 ba bf 01


Zdenek



