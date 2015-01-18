Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751822AbbARLZG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2015 06:25:06 -0500
Received: from mail-ig0-f169.google.com ([209.85.213.169]:53044 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751235AbbARLZE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2015 06:25:04 -0500
MIME-Version: 1.0
Date: Sun, 18 Jan 2015 06:25:02 -0500
X-Google-Sender-Auth: 17X1u_i-m8H6_X1MsgDquSvCib4
Message-ID: <CAJyeiY4dF6CJmf3iNAoCm7QTw-yCNby2S1fGfCvLi4ss+xON_g@mail.gmail.com>
Subject: divide by zero oops in kernel 3.17.7
From: william <william@waisse.org>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi all

I just had the following kernel oops, its a 32 bits kernel, the
problem was triggered by both mysql ( user 60 )  on cpu 2 and cpu 6
and apache ( user 81 ) on cpu  4, at the same time, here is the log :

Jan 15 22:16:17 gemelos kernel: divide error: 0000 [#1] SMP
Jan 15 22:16:17 gemelos kernel: CPU: 2 PID: 18340 Comm: mysqld Not
tainted 3.17.7-hardened-r1ww7_r10b #1
Jan 15 22:16:17 gemelos kernel: Hardware name: Dell Inc. PowerEdge
R210 II/03X6X0, BIOS 2.7.0 11/15/2013
Jan 15 22:16:17 gemelos kernel: task: ee0c0930 ti: ee0c0c94 task.ti: ee0c0c94
Jan 15 22:16:17 gemelos kernel: EIP: 0060:[<00249241>] EFLAGS: 00210246 CPU: 2
Jan 15 22:16:17 gemelos kernel: EAX: 0000003a EBX: ffff66bd ECX:
00000000 EDX: 00000000
Jan 15 22:16:17 gemelos kernel: ESI: 0000003a EDI: 0000003a EBP:
c230fc6c ESP: c230fc48
Jan 15 22:16:17 gemelos kernel: DS: 0068 ES: 0068 FS: 00d8 GS: 007b SS: 0068
Jan 15 22:16:17 gemelos kernel: CR0: 80050033 CR2: 204bc454 CR3:
01a04080 CR4: 001407f0
Jan 15 22:16:17 gemelos kernel: Stack:
Jan 15 22:16:17 gemelos kernel: 00000542 00000000 c230fc74 00000000
00000000 00000000 00000000 00000000
Jan 15 22:16:17 gemelos kernel: 00000000 c230fca8 000c1e69 00000000
00000000 02a70000 00000000 00000000
Jan 15 22:16:17 gemelos kernel: 00000000 000002a7 0000003b 00000000
00000001 00000065 00000000 ee3d49c4
Jan 15 22:16:17 gemelos kernel: Call Trace:
Jan 15 22:16:17 gemelos kernel: [<000c1e69>] bdi_position_ratio+0x181/0x1dd
Jan 15 22:16:17 gemelos kernel: [<000c2fc5>]
balance_dirty_pages_ratelimited+0x43f/0x739
Jan 15 22:16:17 gemelos kernel: [<00498fe8>] ? nft_target_init+0x6b/0x17b
Jan 15 22:16:17 gemelos kernel: [<00498fe8>] ? nft_target_init+0x6b/0x17b
Jan 15 22:16:17 gemelos kernel: [<001a784d>] ? __ext4_journal_stop+0x53/0x6c
Jan 15 22:16:17 gemelos kernel: [<00017ffe>] ? intel_pmu_hw_config+0xa7/0xca
Jan 15 22:16:17 gemelos kernel: [<000bb9ff>] generic_perform_write+0x172/0x1af
Jan 15 22:16:17 gemelos kernel: [<003c0000>] ? bnx2x_queue_comp_cmd+0xcf/0x12d
Jan 15 22:16:17 gemelos kernel: [<000bcbc0>]
__generic_file_write_iter+0x444/0x4c5
Jan 15 22:16:17 gemelos kernel: [<003c1000>] ? bnx2x_func_send_cmd+0xc7/0x459
Jan 15 22:16:17 gemelos kernel: [<00200246>] ? sha256_transform+0x19e0/0x24a2
Jan 15 22:16:17 gemelos kernel: [<00010000>] ? print_cpu_msr+0x3b/0x55
Jan 15 22:16:17 gemelos kernel: [<00010000>] ? print_cpu_msr+0x3b/0x55
Jan 15 22:16:17 gemelos kernel: [<00010000>] ? print_cpu_msr+0x3b/0x55
Jan 15 22:16:17 gemelos kernel: [<003c0000>] ? bnx2x_queue_comp_cmd+0xcf/0x12d
Jan 15 22:16:17 gemelos kernel: [<00180245>] ext4_file_write_iter+0x3b2/0x473
Jan 15 22:16:17 gemelos kernel: [<00010000>] ? print_cpu_msr+0x3b/0x55
Jan 15 22:16:17 gemelos kernel: [<00010000>] ? print_cpu_msr+0x3b/0x55
Jan 15 22:16:17 gemelos kernel: [<00010000>] ? print_cpu_msr+0x3b/0x55
Jan 15 22:16:17 gemelos kernel: [<000ee35d>] new_sync_write+0x5c/0x83
Jan 15 22:16:17 gemelos kernel: [<00010000>] ? print_cpu_msr+0x3b/0x55
Jan 15 22:16:17 gemelos kernel: [<00010000>] ? print_cpu_msr+0x3b/0x55
Jan 15 22:16:17 gemelos kernel: [<0000f000>] ? init_intel_cacheinfo+0x291/0x3bd
Jan 15 22:16:17 gemelos kernel: [<003c0000>] ? bnx2x_queue_comp_cmd+0xcf/0x12d
Jan 15 22:16:17 gemelos kernel: [<00010000>] ? print_cpu_msr+0x3b/0x55
Jan 15 22:16:17 gemelos kernel: [<00010000>] ? print_cpu_msr+0x3b/0x55
Jan 15 22:16:17 gemelos kernel: [<000ee301>] ? do_sync_readv_writev+0x70/0x70
Jan 15 22:16:17 gemelos kernel: [<000eee57>] vfs_write+0xe8/0x1c8
Jan 15 22:16:17 gemelos kernel: [<000ef286>] SyS_write+0x3f/0x7f
Jan 15 22:16:17 gemelos kernel: [<00010000>] ? print_cpu_msr+0x3b/0x55
Jan 15 22:16:17 gemelos kernel: [<003c0000>] ? bnx2x_queue_comp_cmd+0xcf/0x12d
Jan 15 22:16:17 gemelos kernel: [<00510b09>] syscall_call+0x7/0x7
Jan 15 22:16:17 gemelos kernel: [<00010000>] ? print_cpu_msr+0x3b/0x55
Jan 15 22:16:17 gemelos kernel: [<00010033>] ? print_cpu_info+0x19/0xb0
Jan 15 22:16:17 gemelos kernel: [<00200293>] ? sha256_transform+0x1a2d/0x24a2
Jan 15 22:16:17 gemelos kernel: [<00200293>] ? sha256_transform+0x1a2d/0x24a2
Jan 15 22:16:17 gemelos kernel: [<00020033>] ?
smp_trace_threshold_interrupt+0x13/0x85
Jan 15 22:16:17 gemelos kernel: [<00200293>] ? sha256_transform+0x1a2d/0x24a2
Jan 15 22:16:17 gemelos kernel: [<00200033>] ? sha256_transform+0x17cd/0x24a2
Jan 15 22:16:17 gemelos kernel: [<00200293>] ? sha256_transform+0x1a2d/0x24a2
Jan 15 22:16:17 gemelos kernel: [<00200033>] ? sha256_transform+0x17cd/0x24a2
Jan 15 22:16:17 gemelos kernel: [<00200293>] ? sha256_transform+0x1a2d/0x24a2
Jan 15 22:16:17 gemelos kernel: Code: 89 f9 83 ec 18 89 d7 8b 51 04 8b
01 85 d2 89 45 e8 89 d0 89 55 ec 75 2e 8b 4d e8 89 f3 89 fe 39 ce 73
04 31 f6 eb 10 89 f0 31 d2 <f7> f1 31 d2 89 c6 89 f8 f7 f1 89 d7 89 d8
89 fa 89 f3 f7 f1 89
Jan 15 22:16:17 gemelos kernel: EIP: [<00249241>] div64_u64+0x36/0x106
SS:ESP 0068:c230fc48
Jan 15 22:16:17 gemelos kernel: divide error: 0000 [#2]
Jan 15 22:16:17 gemelos kernel: ---[ end trace 16e28ee794763227 ]---
Jan 15 22:16:17 gemelos kernel: grsec: banning user with uid 60 until
system restart for suspicious kernel crash
Jan 15 22:16:17 gemelos kernel: SMP
Jan 15 22:16:17 gemelos kernel: CPU: 4 PID: 18516 Comm: apache2
Tainted: G      D        3.17.7-hardened-r1ww7_r10b #1
Jan 15 22:16:17 gemelos kernel: Hardware name: Dell Inc. PowerEdge
R210 II/03X6X0, BIOS 2.7.0 11/15/2013
Jan 15 22:16:17 gemelos kernel: task: ee0eced0 ti: ee0ed234 task.ti: ee0ed234
Jan 15 22:16:17 gemelos kernel: EIP: 0060:[<00249241>] EFLAGS: 00210246 CPU: 4
Jan 15 22:16:17 gemelos kernel: EAX: 0000003a EBX: ffff6647 ECX:
00000000 EDX: 00000000
Jan 15 22:16:17 gemelos kernel: ESI: 0000003a EDI: 0000003a EBP:
c23ebc58 ESP: c23ebc34
Jan 15 22:16:17 gemelos kernel: DS: 0068 ES: 0068 FS: 00d8 GS: 007b SS: 0068
Jan 15 22:16:17 gemelos kernel: CR0: 80050033 CR2: a18c2000 CR3:
01a04100 CR4: 001407f0
Jan 15 22:16:17 gemelos kernel: Stack:
Jan 15 22:16:17 gemelos kernel: 00000542 00000000 c23ebc60 00000000
00000000 00000000 00000000 00000000
Jan 15 22:16:17 gemelos kernel: 00000000 c23ebc94 000c1e69 00000000
00000000 02a70000 00000000 00000000
Jan 15 22:16:17 gemelos kernel: 00000000 000002a7 0000003b 00000000
00000001 00000065 00000000 ee3d49c4
Jan 15 22:16:17 gemelos kernel: Call Trace:
Jan 15 22:16:17 gemelos kernel: [<000c1e69>] bdi_position_ratio+0x181/0x1dd
Jan 15 22:16:17 gemelos kernel: [<000c2fc5>]
balance_dirty_pages_ratelimited+0x43f/0x739
Jan 15 22:16:17 gemelos kernel: [<00498fe8>] ? nft_target_init+0x6b/0x17b
Jan 15 22:16:17 gemelos kernel: [<00498fe8>] ? nft_target_init+0x6b/0x17b
Jan 15 22:16:17 gemelos kernel: [<001a784d>] ? __ext4_journal_stop+0x53/0x6c
Jan 15 22:16:17 gemelos kernel: [<00017ffe>] ? intel_pmu_hw_config+0xa7/0xca
Jan 15 22:16:17 gemelos kernel: [<000bb9ff>] generic_perform_write+0x172/0x1af
Jan 15 22:16:17 gemelos kernel: [<000bcbc0>]
__generic_file_write_iter+0x444/0x4c5
Jan 15 22:16:17 gemelos kernel: [<00200246>] ? sha256_transform+0x19e0/0x24a2
Jan 15 22:16:17 gemelos kernel: [<00180245>] ext4_file_write_iter+0x3b2/0x473
Jan 15 22:16:17 gemelos kernel: [<000ee35d>] new_sync_write+0x5c/0x83
Jan 15 22:16:17 gemelos kernel: [<000ee301>] ? do_sync_readv_writev+0x70/0x70
Jan 15 22:16:17 gemelos kernel: [<000eee57>] vfs_write+0xe8/0x1c8
Jan 15 22:16:17 gemelos kernel: [<000ef391>] SyS_pwrite64+0x52/0x79
Jan 15 22:16:17 gemelos kernel: [<00510b09>] syscall_call+0x7/0x7
Jan 15 22:16:17 gemelos kernel: [<00200246>] ? sha256_transform+0x19e0/0x24a2
Jan 15 22:16:17 gemelos kernel: [<00510b29>] ? restore_all_pax+0xc/0xc
Jan 15 22:16:17 gemelos kernel: [<0051007b>] ? ldsem_down_read+0x3b/0x163
Jan 15 22:16:17 gemelos kernel: [<00010000>] ? print_cpu_msr+0x3b/0x55
Jan 15 22:16:17 gemelos kernel: [<00200202>] ? sha256_transform+0x199c/0x24a2
Jan 15 22:16:17 gemelos kernel: [<00200033>] ? sha256_transform+0x17cd/0x24a2
Jan 15 22:16:17 gemelos kernel: [<00200286>] ? sha256_transform+0x1a20/0x24a2
Jan 15 22:16:17 gemelos kernel: Code: 89 f9 83 ec 18 89 d7 8b 51 04 8b
01 85 d2 89 45 e8 89 d0 89 55 ec 75 2e 8b 4d e8 89 f3 89 fe 39 ce 73
04 31 f6 eb 10 89 f0 31 d2 <f7> f1 31 d2 89 c6 89 f8 f7 f1 89 d7 89 d8
89 fa 89 f3 f7 f1 89
Jan 15 22:16:17 gemelos kernel: EIP: [<00249241>] div64_u64+0x36/0x106
SS:ESP 0068:c23ebc34
Jan 15 22:16:17 gemelos kernel: divide error: 0000 [#3]
Jan 15 22:16:17 gemelos kernel: ---[ end trace 16e28ee794763228 ]---
Jan 15 22:16:17 gemelos kernel: grsec: banning user with uid 81 until
system restart for suspicious kernel crash
Jan 15 22:16:17 gemelos kernel: SMP
Jan 15 22:16:17 gemelos kernel: CPU: 6 PID: 18483 Comm: mysqld
Tainted: G      D        3.17.7-hardened-r1ww7_r10b #1
Jan 15 22:16:17 gemelos kernel: Hardware name: Dell Inc. PowerEdge
R210 II/03X6X0, BIOS 2.7.0 11/15/2013
Jan 15 22:16:17 gemelos kernel: task: ee0a4e10 ti: ee0a5174 task.ti: ee0a5174
Jan 15 22:16:17 gemelos kernel: EIP: 0060:[<00249241>] EFLAGS: 00210246 CPU: 6
Jan 15 22:16:17 gemelos kernel: EAX: 0000003a EBX: ffff64e5 ECX:
00000000 EDX: 00000000
Jan 15 22:16:17 gemelos kernel: ESI: 0000003a EDI: 0000003a EBP:
ebe7bbfc ESP: ebe7bbd8
Jan 15 22:16:17 gemelos kernel: DS: 0068 ES: 0068 FS: 00d8 GS: 007b SS: 0068
Jan 15 22:16:17 gemelos kernel: CR0: 80050033 CR2: a3400000 CR3:
01a04180 CR4: 001407f0
Jan 15 22:16:17 gemelos kernel: Stack:
Jan 15 22:16:17 gemelos kernel: 00000542 00000000 ebe7bc04 00000000
00000000 00000000 00000000 00000000
Jan 15 22:16:17 gemelos kernel: 00000000 ebe7bc38 000c1e69 00000000
00000000 02a70000 00000000 00000000
Jan 15 22:16:17 gemelos kernel: 00000000 000002a7 0000003b 00000000
00000001 00000065 00000000 ee3d49c4
Jan 15 22:16:17 gemelos kernel: Call Trace:
Jan 15 22:16:17 gemelos kernel: [<000c1e69>] bdi_position_ratio+0x181/0x1dd
Jan 15 22:16:17 gemelos kernel: [<000c2fc5>]
balance_dirty_pages_ratelimited+0x43f/0x739
Jan 15 22:16:17 gemelos kernel: [<00498fe8>] ? nft_target_init+0x6b/0x17b
Jan 15 22:16:17 gemelos kernel: [<00498fe8>] ? nft_target_init+0x6b/0x17b
Jan 15 22:16:17 gemelos kernel: [<001a784d>] ? __ext4_journal_stop+0x53/0x6c
Jan 15 22:16:17 gemelos kernel: [<00017ffe>] ? intel_pmu_hw_config+0xa7/0xca
Jan 15 22:16:17 gemelos kernel: [<00010000>] ? print_cpu_msr+0x3b/0x55
Jan 15 22:16:17 gemelos kernel: [<000bb9ff>] generic_perform_write+0x172/0x1af
Jan 15 22:16:17 gemelos kernel: [<000bcbc0>]
__generic_file_write_iter+0x444/0x4c5
Jan 15 22:16:17 gemelos kernel: [<00200246>] ? sha256_transform+0x19e0/0x24a2
Jan 15 22:16:17 gemelos kernel: [<00010000>] ? print_cpu_msr+0x3b/0x55
Jan 15 22:16:17 gemelos kernel: [<00010000>] ? print_cpu_msr+0x3b/0x55
Jan 15 22:16:17 gemelos kernel: [<00010000>] ? print_cpu_msr+0x3b/0x55
Jan 15 22:16:17 gemelos kernel: [<00180245>] ext4_file_write_iter+0x3b2/0x473
Jan 15 22:16:17 gemelos kernel: [<00010000>] ? print_cpu_msr+0x3b/0x55
Jan 15 22:16:17 gemelos kernel: [<00010000>] ? print_cpu_msr+0x3b/0x55
Jan 15 22:16:17 gemelos kernel: [<00010000>] ? print_cpu_msr+0x3b/0x55
Jan 15 22:16:17 gemelos kernel: [<000ee35d>] new_sync_write+0x5c/0x83
Jan 15 22:16:17 gemelos kernel: [<00010000>] ? print_cpu_msr+0x3b/0x55
Jan 15 22:16:17 gemelos kernel: [<00010000>] ? print_cpu_msr+0x3b/0x55
Jan 15 22:16:17 gemelos kernel: [<00010000>] ? print_cpu_msr+0x3b/0x55
Jan 15 22:16:17 gemelos kernel: [<00010000>] ? print_cpu_msr+0x3b/0x55
Jan 15 22:16:17 gemelos kernel: [<00010000>] ? print_cpu_msr+0x3b/0x55
Jan 15 22:16:17 gemelos kernel: [<000ee301>] ? do_sync_readv_writev+0x70/0x70
Jan 15 22:16:17 gemelos kernel: [<000eee57>] vfs_write+0xe8/0x1c8
Jan 15 22:16:17 gemelos kernel: [<000ef286>] SyS_write+0x3f/0x7f
Jan 15 22:16:17 gemelos kernel: [<00010000>] ? print_cpu_msr+0x3b/0x55
Jan 15 22:16:17 gemelos kernel: [<00510b09>] syscall_call+0x7/0x7
Jan 15 22:16:17 gemelos kernel: [<00010000>] ? print_cpu_msr+0x3b/0x55
Jan 15 22:16:17 gemelos kernel: [<00200293>] ? sha256_transform+0x1a2d/0x24a2
Jan 15 22:16:17 gemelos kernel: [<00510b29>] ? restore_all_pax+0xc/0xc
Jan 15 22:16:17 gemelos kernel: [<00010000>] ? print_cpu_msr+0x3b/0x55
Jan 15 22:16:17 gemelos kernel: [<00010000>] ? print_cpu_msr+0x3b/0x55
Jan 15 22:16:17 gemelos kernel: [<00200293>] ? sha256_transform+0x1a2d/0x24a2
Jan 15 22:16:17 gemelos kernel: [<00010000>] ? print_cpu_msr+0x3b/0x55
Jan 15 22:16:17 gemelos kernel: [<00010000>] ? print_cpu_msr+0x3b/0x55
Jan 15 22:16:17 gemelos kernel: [<00200033>] ? sha256_transform+0x17cd/0x24a2
Jan 15 22:16:17 gemelos kernel: [<00200293>] ? sha256_transform+0x1a2d/0x24a2
Jan 15 22:16:17 gemelos kernel: Code: 89 f9 83 ec 18 89 d7 8b 51 04 8b
01 85 d2 89 45 e8 89 d0 89 55 ec 75 2e 8b 4d e8 89 f3 89 fe 39 ce 73
04 31 f6 eb 10 89 f0 31 d2 <f7> f1 31 d2 89 c6 89 f8 f7 f1 89 d7 89 d8
89 fa 89 f3 f7 f1 89
Jan 15 22:16:17 gemelos kernel: EIP: [<00249241>] div64_u64+0x36/0x106
SS:ESP 0068:ebe7bbd8
Jan 15 22:16:17 gemelos kernel: ---[ end trace 16e28ee794763229 ]---
Jan 15 22:16:17 gemelos kernel: grsec: banning user with uid 60 until
system restart for suspicious kernel crash

this could be related to this thread :
https://lkml.org/lkml/2014/11/1/52

I just rebuilt my kernel with CONFIG_DEBUG_INFO_REDUCED and
CONFIG_DEBUG_INFO to get more infos if the oops happen again, please
tell me whatever i could do to help you trace the bug.

answering to the other thread ( https://lkml.org/lkml/2014/11/11/870 )
I have :

 cat /proc/sys/vm/dirty_ratio
20

cat /proc/sys/vm/dirty_background_ratio
10





-- 
Cordialement

       -----------------------------------

 William Waisse
  http://waisse.org | http://neoskills.com
   http://cahierspip.ww7.be | http://feeder.ww7.be
Computers are like air conditionners. They work better when you close windows.
