Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756502AbaKROwr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 09:52:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46299 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755297AbaKROwo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 09:52:44 -0500
Date: Tue, 18 Nov 2014 09:52:34 -0500
From: Dave Jones <davej@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>
Subject: Re: frequent lockups in 3.18rc4
Message-ID: <20141118145234.GA7487@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	the arch/x86 maintainers <x86@kernel.org>
References: <CA+55aFx16ks_azU0eAcx+qZ5-o8Xo0zzP6aNjrskai8rqp+eMg@mail.gmail.com>
 <20141115213405.GA31971@redhat.com>
 <20141116014006.GA5016@redhat.com>
 <CA+55aFwLH6zGf7O=o2+H0Z8=8nW4zwUbw3Q4bJGttHACv9g+FQ@mail.gmail.com>
 <20141117170359.GA1382@redhat.com>
 <CA+55aFy9dWtS5qh=-HT9M7hQPeWDMvdxEynr0p4aRkiGkV6gyQ@mail.gmail.com>
 <20141118020959.GA2091@redhat.com>
 <CA+55aFy65SmGXFeosNqvrgx+P6JQLrzpEYuwXdyeWtZwZsKxZg@mail.gmail.com>
 <20141118023930.GA2871@redhat.com>
 <CA+55aFyOTpVQiku0xn=UHnXdYweKHZ5AsEUN9wUvOqH9XX4ENg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFyOTpVQiku0xn=UHnXdYweKHZ5AsEUN9wUvOqH9XX4ENg@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 17, 2014 at 06:51:25PM -0800, Linus Torvalds wrote:
 > On Mon, Nov 17, 2014 at 6:39 PM, Dave Jones <davej@redhat.com> wrote:
 > >
 > > So it could be that I'm just generating a lot more load now.
 > > I could drop that back down and see if it 'goes away' or at least
 > > happens less, but it strikes me that there's something here that needs
 > > fixing regardless.
 > 
 > Oh, absolutely. It's more a question of "maybe what changed can give us a clue".
 > 
 > But if it' something like "more load", that's not going to help
 > pinpoint, and you might be better off just doing the all-cpu-backtrace
 > thing and hope that gives some pattern to appreciate..

Here's the first hit. Curiously, one cpu is missing.


NMI watchdog: BUG: soft lockup - CPU#1 stuck for 23s! [trinity-c180:17837]
Modules linked in: dlci snd_seq_dummy fuse tun rfcomm bnep hidp scsi_transport_iscsi af_key llc2 can_raw nfnetlink can_bcm sctp libcrc32c nfc caif_socket caif af_802154 ieee802154 phonet af_rxrpc bluetooth can pppoe pppox ppp_generic slhc irda crc_ccitt rds rose x25 atm netrom appletalk ipx p8023 psnap p8022 llc ax25 cfg80211 rfkill coretemp hwmon x86_pkg_temp_thermal kvm_intel kvm snd_hda_codec_realtek snd_hda_codec_hdmi snd_hda_codec_generic crct10dif_pclmul crc32c_intel ghash_clmulni_intel microcode serio_raw pcspkr usb_debug snd_hda_intel snd_hda_controller snd_hda_codec snd_hwdep snd_seq snd_seq_device snd_pcm e1000e snd_timer ptp shpchp snd pps_core soundcore nfsd auth_rpcgss oid_registry nfs_acl lockd grace sunrpc
irq event stamp: 2258092
hardirqs last  enabled at (2258091): [<ffffffffa91a58b5>] get_page_from_freelist+0x555/0xaa0
hardirqs last disabled at (2258092): [<ffffffffa985396a>] apic_timer_interrupt+0x6a/0x80
softirqs last  enabled at (2244380): [<ffffffffa907b87f>] __do_softirq+0x24f/0x6f0
softirqs last disabled at (2244377): [<ffffffffa907c0dd>] irq_exit+0x13d/0x160
CPU: 1 PID: 17837 Comm: trinity-c180 Not tainted 3.18.0-rc5+ #90 [loadavg: 199.00 178.81 173.92 35/402 20526]
task: ffff8801575e4680 ti: ffff880202434000 task.ti: ffff880202434000
RIP: 0010:[<ffffffffa91a0db0>]  [<ffffffffa91a0db0>] bad_range+0x0/0x90
RSP: 0018:ffff8802024377a0  EFLAGS: 00000246
RAX: ffff8801575e4680 RBX: 0000000000000007 RCX: 0000000000000006
RDX: 0000000000002a20 RSI: ffffea0000887fc0 RDI: ffff88024d64c740
RBP: ffff880202437898 R08: 0000000000000000 R09: 0000000000000001
R10: 0000000000000002 R11: 0000000000000000 R12: 0000000000000001
R13: 0000000000000020 R14: 00000000001d8608 R15: 00000000001d8668
FS:  00007fd3b8960740(0000) GS:ffff880244200000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fd3b5ea0777 CR3: 00000001027cd000 CR4: 00000000001407e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
Stack:
 ffffffffa91a58c4 00000000000009e4 ffff8801575e4680 0000000000000001
 ffff88024d64dd08 0000010000000000 0000000000000000 ffff8802024377f8
 0000000000000000 ffff88024d64dd00 ffffffffa90ac411 ffffffff00000003
Call Trace:
 [<ffffffffa91a58c4>] ? get_page_from_freelist+0x564/0xaa0
 [<ffffffffa90ac411>] ? get_parent_ip+0x11/0x50
 [<ffffffffa91a6030>] __alloc_pages_nodemask+0x230/0xd20
 [<ffffffffa90ac411>] ? get_parent_ip+0x11/0x50
 [<ffffffffa90d1e45>] ? mark_held_locks+0x75/0xa0
 [<ffffffffa91f400e>] alloc_pages_vma+0xee/0x1b0
 [<ffffffffa91b643e>] ? shmem_alloc_page+0x6e/0xc0
 [<ffffffffa91b643e>] shmem_alloc_page+0x6e/0xc0
 [<ffffffffa90ac411>] ? get_parent_ip+0x11/0x50
 [<ffffffffa90ac58b>] ? preempt_count_sub+0x7b/0x100
 [<ffffffffa93dcc46>] ? __percpu_counter_add+0x86/0xb0
 [<ffffffffa91d50d6>] ? __vm_enough_memory+0x66/0x1c0
 [<ffffffffa919ad65>] ? find_get_entry+0x5/0x230
 [<ffffffffa933b10c>] ? cap_vm_enough_memory+0x4c/0x60
 [<ffffffffa91b8ff0>] shmem_getpage_gfp+0x630/0xa40
 [<ffffffffa90cee01>] ? match_held_lock+0x111/0x160
 [<ffffffffa91b9442>] shmem_write_begin+0x42/0x70
 [<ffffffffa919a684>] generic_perform_write+0xd4/0x1f0
 [<ffffffffa919d5d2>] __generic_file_write_iter+0x162/0x350
 [<ffffffffa92154a0>] ? new_sync_read+0xd0/0xd0
 [<ffffffffa919d7ff>] generic_file_write_iter+0x3f/0xb0
 [<ffffffffa919d7c0>] ? __generic_file_write_iter+0x350/0x350
 [<ffffffffa92155e8>] do_iter_readv_writev+0x78/0xc0
 [<ffffffffa9216e18>] do_readv_writev+0xd8/0x2a0
 [<ffffffffa919d7c0>] ? __generic_file_write_iter+0x350/0x350
 [<ffffffffa90cf426>] ? lock_release_holdtime.part.28+0xe6/0x160
 [<ffffffffa919d7c0>] ? __generic_file_write_iter+0x350/0x350
 [<ffffffffa90ac411>] ? get_parent_ip+0x11/0x50
 [<ffffffffa90ac58b>] ? preempt_count_sub+0x7b/0x100
 [<ffffffffa90e782e>] ? rcu_read_lock_held+0x6e/0x80
 [<ffffffffa921706c>] vfs_writev+0x3c/0x50
 [<ffffffffa92171dc>] SyS_writev+0x5c/0x100
 [<ffffffffa9852c49>] tracesys_phase2+0xd4/0xd9
Code: 09 48 83 f2 01 83 e2 01 eb a3 90 48 c7 c7 a0 8c e4 a9 e8 44 e1 f2 ff 85 c0 75 d2 eb c1 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 <0f> 1f 44 00 00 48 b8 00 00 00 00 00 16 00 00 55 4c 8b 47 68 48 
sending NMI to other CPUs:
NMI backtrace for cpu 2
CPU: 2 PID: 15913 Comm: trinity-c141 Not tainted 3.18.0-rc5+ #90 [loadavg: 199.00 178.81 173.92 35/402 20526]
task: ffff880223229780 ti: ffff8801afca0000 task.ti: ffff8801afca0000
RIP: 0010:[<ffffffffa9116dbe>]  [<ffffffffa9116dbe>] generic_exec_single+0xee/0x1a0
RSP: 0018:ffff8801afca3928  EFLAGS: 00000202
RAX: ffff8802443d9d00 RBX: ffff8801afca3930 RCX: ffff8802443d9dc0
RDX: ffff8802443d4d80 RSI: ffff8801afca3930 RDI: ffff8801afca3930
RBP: ffff8801afca3988 R08: 0000000000000001 R09: 0000000000000000
R10: 0000000000000001 R11: 0000000000000000 R12: 0000000000000001
R13: 0000000000000001 R14: ffff8801afca3a48 R15: ffffffffa9045bb0
FS:  00007fd3b8960740(0000) GS:ffff880244400000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000008 CR3: 000000022f8bd000 CR4: 00000000001407e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
Stack:
 ffff8801afca3a08 ffff8802443d9dc0 ffffffffa9045bb0 ffff8801afca3a48
 0000000000000003 000000007b19adc3 0000000000000001 00000000ffffffff
 0000000000000001 ffffffffa9045bb0 ffff8801afca3a48 0000000000000001
Call Trace:
 [<ffffffffa9045bb0>] ? do_flush_tlb_all+0x60/0x60
 [<ffffffffa9045bb0>] ? do_flush_tlb_all+0x60/0x60
 [<ffffffffa9116f3a>] smp_call_function_single+0x6a/0xe0
 [<ffffffffa93b2e1f>] ? cpumask_next_and+0x4f/0xb0
 [<ffffffffa9045bb0>] ? do_flush_tlb_all+0x60/0x60
 [<ffffffffa9117679>] smp_call_function_many+0x2b9/0x320
 [<ffffffffa9046370>] flush_tlb_mm_range+0xe0/0x370
 [<ffffffffa91cc762>] tlb_flush_mmu_tlbonly+0x42/0x50
 [<ffffffffa91cdd28>] unmap_single_vma+0x6b8/0x900
 [<ffffffffa91ce06c>] zap_page_range_single+0xfc/0x160
 [<ffffffffa91ce254>] unmap_mapping_range+0x134/0x190
 [<ffffffffa91bb9dd>] shmem_fallocate+0x4fd/0x520
 [<ffffffffa90c7c77>] ? prepare_to_wait+0x27/0x90
 [<ffffffffa9213bc2>] do_fallocate+0x132/0x1d0
 [<ffffffffa91e3228>] SyS_madvise+0x398/0x870
 [<ffffffffa983f6c0>] ? rcu_read_lock_sched_held+0x4e/0x6a
 [<ffffffffa9013877>] ? syscall_trace_enter_phase2+0xa7/0x2b0
 [<ffffffffa9852c49>] tracesys_phase2+0xd4/0xd9
Code: 48 89 de 48 03 14 c5 60 74 f1 a9 48 89 df e8 0a fa 2a 00 84 c0 75 46 45 85 ed 74 11 f6 43 18 01 74 0b 0f 1f 00 f3 90 f6 43 18 01 <75> f8 31 c0 48 8b 4d c8 65 48 33 0c 25 28 00 00 00 0f 85 8e 00 
NMI backtrace for cpu 0
INFO: NMI handler (arch_trigger_all_cpu_backtrace_handler) took too long to run: 37.091 msecs
CPU: 0 PID: 15851 Comm: trinity-c80 Not tainted 3.18.0-rc5+ #90 [loadavg: 199.00 178.81 173.92 36/402 20526]
task: ffff8801874e8000 ti: ffff88022baec000 task.ti: ffff88022baec000
RIP: 0010:[<ffffffffa90ac450>]  [<ffffffffa90ac450>] preempt_count_add+0x0/0xc0
RSP: 0000:ffff880244003c30  EFLAGS: 00000092
RAX: 0000000000000001 RBX: ffffffffa9edb560 RCX: 0000000000000001
RDX: 0000000000000001 RSI: 0000000000000001 RDI: 0000000000000001
RBP: ffff880244003c48 R08: 0000000000000000 R09: 0000000000000001
R10: 0000000000000000 R11: ffff8801874e88c8 [23543.271956] NMI backtrace for cpu 3
INFO: NMI handler (arch_trigger_all_cpu_backtrace_handler) took too long to run: 100.612 msecs
CPU: 3 PID: 0 Comm: swapper/3 Not tainted 3.18.0-rc5+ #90 [loadavg: 199.00 178.81 173.92 37/402 20526]
task: ffff880242b5c680 ti: ffff880242b78000 task.ti: ffff880242b78000
RIP: 0010:[<ffffffffa94251b5>]  [<ffffffffa94251b5>] intel_idle+0xd5/0x180
RSP: 0018:ffff880242b7bdf8  EFLAGS: 00000046
RAX: 0000000000000032 RBX: 0000000000000010 RCX: 0000000000000001
RDX: 0000000000000000 RSI: ffff880242b7bfd8 RDI: 0000000000000003
RBP: ffff880242b7be28 R08: 000000008baf8f3d R09: 0000000000000000
R10: 0000000000000000 R11: ffff880242b5cea0 R12: 0000000000000005
R13: 0000000000000032 R14: 0000000000000004 R15: ffff880242b78000
FS:  0000000000000000(0000) GS:ffff880244600000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000b1c9ac CR3: 0000000029e11000 CR4: 00000000001407e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
Stack:
 0000000342b7be28 afc453cb003f4590 ffffe8ffff402200 0000000000000005
 ffffffffa9eaa0c0 0000000000000003 ffff880242b7be78 ffffffffa96bbb45
 0000156cc07cf6e3 ffffffffa9eaa290 0000000000000096 ffffffffa9f197b0
Call Trace:
 [<ffffffffa96bbb45>] cpuidle_enter_state+0x55/0x300
 [<ffffffffa96bbea7>] cpuidle_enter+0x17/0x20
 [<ffffffffa90c88f5>] cpu_startup_entry+0x4e5/0x630
 [<ffffffffa902d523>] start_secondary+0x1a3/0x220
Code: 31 d2 65 48 8b 34 25 08 ba 00 00 48 8d 86 38 c0 ff ff 48 89 d1 0f 01 c8 48 8b 86 38 c0 ff ff a8 08 75 08 b1 01 4c 89 e8 0f 01 c9 <65> 48 8b 0c 25 08 ba 00 00 f0 80 a1 3a c0 ff ff df 0f ae f0 48 
INFO: NMI handler (arch_trigger_all_cpu_backtrace_handler) took too long to run: 125.739 msecs

