Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757341Ab3GQWCx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 18:02:53 -0400
Received: from sentry-two.sandia.gov ([132.175.109.14]:60468 "EHLO
	sentry-two.sandia.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755329Ab3GQWCw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 18:02:52 -0400
X-Greylist: delayed 1061 seconds by postgrey-1.27 at vger.kernel.org; Wed, 17 Jul 2013 18:02:52 EDT
X-WSS-ID: 0MQ3OF8-0B-0WT-02
X-M-MSG: 
X-Server-Uuid: AF72F651-81B1-4134-BA8C-A8E1A4E620FF
Message-ID: <51E7104D.6040405@sandia.gov>
Date: Wed, 17 Jul 2013 15:44:45 -0600
From: "Jim Schutt" <jaschut@sandia.gov>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514
 Thunderbird/17.0.6
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
cc: ceph-devel@vger.kernel.org, "Tejun Heo" <tj@kernel.org>
Subject: 3.10.0 failed paging request from kthread_data
X-TMWD-Spam-Summary: TS=20130717214447; ID=1; SEV=2.3.1;
 DFV=B2013022509; IFV=NA; AIF=B2013022509; RPD=5.03.0010; ENG=NA;
 RPDID=7374723D303030312E30413031303230382E35314537313034462E303039323A534346535441543838363133332C73733D312C6667733D30;
 CAT=NONE; CON=NONE; SIG=AAAAAAAAAAAAAAAAAAAAAAAAfQ==
X-MMS-Spam-Filter-ID: B2013022509_5.03.0010
X-WSS-ID: 7DF9CFC42F01303468-01-01
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
X-RSA-Inspected: yes
X-RSA-Classifications: public
X-RSA-Action: allow
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm trying to test the btrfs and ceph contributions to 3.11, without
testing all of 3.11-rc1 (just yet), so I'm testing with the "next"
branch of Chris Mason's tree  (commit cbacd76bb3 from
git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git)
merged into the for-linus branch of the ceph tree (commit 8b8cf8917f
from git://git.kernel.org/pub/scm/linux/kernel/git/sage/ceph-client.git)

One of my ceph clients hit this:

[94633.463166] BUG: unable to handle kernel paging request at ffffffffffffffa8
[94633.464003] IP: [<ffffffff8106a070>] kthread_data+0x10/0x20
[94633.464003] PGD 1a0c067 PUD 1a0e067 PMD 0 
[94633.464003] Oops: 0000 [#2] SMP 
[94633.464003] Modules linked in: cbc ceph libceph ib_ipoib rdma_ucm ib_ucm ib_uverbs ib_umad rdma_cm ib_cm iw_cm ib_addr ipv6 ib_sa dm_mirror dm_region_hash dm_log dm_multipath scsi_dh scsi_mod vhost_net macvtap macvlan tun uinput iTCO_wdt iTCO_vendor_support dcdbas coretemp kvm microcode button serio_raw pcspkr ehci_pci ehci_hcd ib_mthca ib_mad ib_core lpc_ich mfd_core uhci_hcd i5k_amb i5000_edac edac_core dm_mod nfsv4 nfsv3 nfs_acl nfsv2 nfs lockd sunrpc fscache broadcom tg3 bnx2 igb ptp pps_core i2c_algo_bit i2c_core dca hwmon e1000
[94633.464003] CPU: 0 PID: 78416 Comm: kworker/0:1 Tainted: G      D W    3.10.0-00119-g2925339 #601
[94633.464003] Hardware name: Dell Inc. PowerEdge 1950/0NK937, BIOS 1.1.0 06/21/2006
[94633.464003] task: ffff880415b60000 ti: ffff88040e39a000 task.ti: ffff88040e39a000
[94633.464003] RIP: 0010:[<ffffffff8106a070>]  [<ffffffff8106a070>] kthread_data+0x10/0x20
[94633.464003] RSP: 0018:ffff88040e39b7f8  EFLAGS: 00010092
[94633.464003] RAX: 0000000000000000 RBX: 0000000000000000 RCX: ffffffff81d30320
[94633.464003] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff880415b60000
[94633.464003] RBP: ffff88040e39b7f8 R08: ffff880415b60070 R09: 0000000000000001
[94633.464003] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
[94633.464003] R13: ffff880415b603e8 R14: 0000000000000001 R15: 0000000000000002
[94633.464003] FS:  0000000000000000(0000) GS:ffff88042fc00000(0000) knlGS:0000000000000000
[94633.464003] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[94633.464003] CR2: 0000000000000028 CR3: 0000000415f77000 CR4: 00000000000007f0
[94633.464003] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[94633.464003] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[94633.464003] Stack:
[94633.464003]  ffff88040e39b818 ffffffff810602a5 ffff88040e39b818 ffff88042fc139c0
[94633.464003]  ffff88040e39b8a8 ffffffff814ef79e ffff880400000000 ffff88040e39bfd8
[94633.464003]  ffff88040e39a000 ffff88040e39a000 ffff88040e39a010 ffff88040e39a000
[94633.464003] Call Trace:
[94633.464003]  [<ffffffff810602a5>] wq_worker_sleeping+0x15/0xa0
[94633.464003]  [<ffffffff814ef79e>] __schedule+0x17e/0x6b0
[94633.464003]  [<ffffffff814efefd>] schedule+0x5d/0x60
[94633.464003]  [<ffffffff8104717b>] do_exit+0x3eb/0x440
[94633.464003]  [<ffffffff814f33f8>] oops_end+0xd8/0xf0
[94633.464003]  [<ffffffff810362df>] no_context+0x1bf/0x1e0
[94633.464003]  [<ffffffff810364f5>] __bad_area_nosemaphore+0x1f5/0x230
[94633.464003]  [<ffffffff81036543>] bad_area_nosemaphore+0x13/0x20
[94633.464003]  [<ffffffff814f6406>] __do_page_fault+0x416/0x4b0
[94633.464003]  [<ffffffff810869ae>] ? idle_balance+0x14e/0x180
[94633.464003]  [<ffffffff81077a1f>] ? finish_task_switch+0x3f/0x110
[94633.464003]  [<ffffffff814f29e3>] ? error_sti+0x5/0x6
[94633.464003]  [<ffffffff8109e859>] ? trace_hardirqs_off_caller+0x29/0xd0
[94633.464003]  [<ffffffff8128c6dd>] ? trace_hardirqs_off_thunk+0x3a/0x3c
[94633.464003]  [<ffffffff814f64ae>] do_page_fault+0xe/0x10
[94633.464003]  [<ffffffff814f27e2>] page_fault+0x22/0x30
[94633.464003]  [<ffffffff81285a47>] ? rb_erase+0x297/0x3a0
[94633.464003]  [<ffffffffa02b45d8>] __remove_osd+0x98/0xd0 [libceph]
[94633.464003]  [<ffffffffa02b49c3>] __reset_osd+0xa3/0x1c0 [libceph]
[94633.464003]  [<ffffffffa02b6c5b>] ? osd_reset+0x9b/0xd0 [libceph]
[94633.464003]  [<ffffffffa02b695b>] __kick_osd_requests+0x7b/0x2e0 [libceph]
[94633.464003]  [<ffffffffa02b6c66>] osd_reset+0xa6/0xd0 [libceph]
[94633.464003]  [<ffffffffa02aeb65>] con_work+0x445/0x4a0 [libceph]
[94633.464003]  [<ffffffff810635b5>] process_one_work+0x2e5/0x510
[94633.464003]  [<ffffffff81063510>] ? process_one_work+0x240/0x510
[94633.464003]  [<ffffffff81064975>] worker_thread+0x215/0x340
[94633.464003]  [<ffffffff81064760>] ? manage_workers+0x170/0x170
[94633.464003]  [<ffffffff8106aa61>] kthread+0xe1/0xf0
[94633.464003]  [<ffffffff8106a980>] ? __init_kthread_worker+0x70/0x70
[94633.464003]  [<ffffffff814faf5c>] ret_from_fork+0x7c/0xb0
[94633.464003]  [<ffffffff8106a980>] ? __init_kthread_worker+0x70/0x70
[94633.464003] Code: 90 03 00 00 48 8b 40 98 c9 48 c1 e8 02 83 e0 01 c3 66 2e 0f 1f 84 00 00 00 00 00 55 48 89 e5 66 66 66 66 90 48 8b 87 90 03 00 00 <48> 8b 40 a8 c9 c3 66 2e 0f 1f 84 00 00 00 00 00 55 48 89 e5 66 
[94633.464003] RIP  [<ffffffff8106a070>] kthread_data+0x10/0x20
[94633.464003]  RSP <ffff88040e39b7f8>
[94633.464003] CR2: ffffffffffffffa8
[94633.464003] ---[ end trace 89622896705a7fac ]---
[94633.464003] Fixing recursive fault but reboot is needed!
[94633.464003] ------------[ cut here ]------------

kthread_data disassembles to this:

(gdb) disassemble kthread_data
Dump of assembler code for function kthread_data:
   0xffffffff8106a060 <+0>:	push   %rbp
   0xffffffff8106a061 <+1>:	mov    %rsp,%rbp
   0xffffffff8106a064 <+4>:	callq  0xffffffff814fabc0
   0xffffffff8106a069 <+9>:	mov    0x390(%rdi),%rax
   0xffffffff8106a070 <+16>:	mov    -0x58(%rax),%rax
   0xffffffff8106a074 <+20>:	leaveq 
   0xffffffff8106a075 <+21>:	retq   
End of assembler dump.

and scripts/decodecode had this to say:

All code
========
   0:	90                   	nop
   1:	03 00                	add    (%rax),%eax
   3:	00 48 8b             	add    %cl,-0x75(%rax)
   6:	40 98                	rex cwtl 
   8:	c9                   	leaveq 
   9:	48 c1 e8 02          	shr    $0x2,%rax
   d:	83 e0 01             	and    $0x1,%eax
  10:	c3                   	retq   
  11:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  18:	00 00 00 
  1b:	55                   	push   %rbp
  1c:	48 89 e5             	mov    %rsp,%rbp
  1f:	66 66 66 66 90       	data32 data32 data32 xchg %ax,%ax
  24:	48 8b 87 90 03 00 00 	mov    0x390(%rdi),%rax
  2b:*	48 8b 40 a8          	mov    -0x58(%rax),%rax		<-- trapping instruction
  2f:	c9                   	leaveq 
  30:	c3                   	retq   
  31:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  38:	00 00 00 
  3b:	55                   	push   %rbp
  3c:	48 89 e5             	mov    %rsp,%rbp
  3f:	66                   	data16

So, I think that all means that __schedule() called wq_worker_sleeping() for a task
whose vfork_done completion pointer was NULL, and to_kthread() tried to use it.

Assuming I got that right, that's where I get stuck - I don't have a clue where
to go next to figure out what caused it.

So far I've only triggered this one instance, so I don't know how repeatable this is.

Any ideas where I should look for what might be going wrong?

Thanks in advance for any help anyone can give me.

-- Jim

