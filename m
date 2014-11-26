Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753244AbaKZOef (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 09:34:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57234 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751110AbaKZOed (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 09:34:33 -0500
Date: Wed, 26 Nov 2014 09:34:13 -0500
From: Dave Jones <davej@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Juergen Gross <jgross@suse.com>, the arch/x86 maintainers <x86@kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: frequent lockups in 3.18rc4
Message-ID: <20141126143413.GA5876@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Juergen Gross <jgross@suse.com>,
	the arch/x86 maintainers <x86@kernel.org>,
	Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <20141115213405.GA31971@redhat.com>
 <20141116014006.GA5016@redhat.com>
 <CA+55aFwLH6zGf7O=o2+H0Z8=8nW4zwUbw3Q4bJGttHACv9g+FQ@mail.gmail.com>
 <20141126002501.GA11752@redhat.com>
 <CA+55aFy9c2FY2gDw14VU537QJoLHAbf+q_75VUwU33_HLz+F0w@mail.gmail.com>
 <5475596A.9010301@suse.com>
 <CA+55aFx1SiFBzmA=k9jHxi3cZE3Ei_+2NHepujgf86KEvkz8eQ@mail.gmail.com>
 <54756424.6020409@suse.com>
 <CA+55aFzVyTi_pR4y3=Z3y1bWkXbvgoJaykoyn0pUE7eTYgr+ZQ@mail.gmail.com>
 <CA+55aFzOSfdvgrkfiN=zZg4mSoot-tJQiVRh5ENW2-rzmLMy1w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+55aFzOSfdvgrkfiN=zZg4mSoot-tJQiVRh5ENW2-rzmLMy1w@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 25, 2014 at 10:21:46PM -0800, Linus Torvalds wrote:
 
 > So DaveJ, even though this does appear Xen-centric (Xentric?) and
 > you're running on bare hardware, maybe you could do the same thing in
 > that x86-64 vmalloc_fault(). The timing with Jürgen is kind of
 > intriguing - if 3.18-rc made it happen much more often for him, maybe
 > it really is very timing-sensitive, and you actually are seeing a
 > non-Xen version of the same thing...

I did try your WARN variant (after fixing the typo)

Woke up to the below trace. Looks like a different issue.

Nnngh.

	Dave

NMI watchdog: BUG: soft lockup - CPU#2 stuck for 22s! [trinity-c149:24766]
CPU: 2 PID: 24766 Comm: trinity-c149 Not tainted 3.18.0-rc6+ #98 [loadavg: 156.09 150.24 148.56 21/402 26750]
task: ffff8802285b96f0 ti: ffff8802260e0000 task.ti: ffff8802260e0000
RIP: 0010:[<ffffffff8104658c>]  [<ffffffff8104658c>] kernel_map_pages+0xbc/0x120
RSP: 0018:ffff8802260e3768  EFLAGS: 00000202
RAX: 00000000001407e0 RBX: ffffffff817e0c24 RCX: 0000000000140760
RDX: 0000000000000202 RSI: ffff8800000006b0 RDI: 0000000000000001
RBP: ffff8802260e37c8 R08: 8000000000000063 R09: ffff880000000000
R10: 0000000000000001 R11: 0000000000000000 R12: ffff880200000001
R13: 0000000000010000 R14: 0000000001b60000 R15: 0000000000000000
FS:  00007fb8ef71d740(0000) GS:ffff880244400000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000018b87f0 CR3: 00000002277fe000 CR4: 00000000001407e0
DR0: 0000000000000000 DR1: 00007f60b71b4000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
Stack:
 ffff880123cd7000 ffff8802260e3768 0000000000000000 0000000000000003
 0000000000000000 0000000100000001 0000000000123cd6 0000000000000000
 0000000000000000 00000000ade00558 ffff8802445d7638 0000000000000001
Call Trace:
 [<ffffffff81185ebf>] get_page_from_freelist+0x49f/0xaa0
 [<ffffffff810a7431>] ? get_parent_ip+0x11/0x50
 [<ffffffff811866ee>] __alloc_pages_nodemask+0x22e/0xb60
 [<ffffffff810ad5c5>] ? local_clock+0x25/0x30
 [<ffffffff810c6e7c>] ? __lock_acquire.isra.31+0x22c/0x9f0
 [<ffffffff813775e0>] ? __radix_tree_preload+0x60/0xf0
 [<ffffffff810a7431>] ? get_parent_ip+0x11/0x50
 [<ffffffff810c546d>] ? lock_release_holdtime.part.24+0x9d/0x160
 [<ffffffff811d093e>] alloc_pages_vma+0xee/0x1b0
 [<ffffffff81194f0e>] ? shmem_alloc_page+0x6e/0xc0
 [<ffffffff810c6e7c>] ? __lock_acquire.isra.31+0x22c/0x9f0
 [<ffffffff81194f0e>] shmem_alloc_page+0x6e/0xc0
 [<ffffffff810a7431>] ? get_parent_ip+0x11/0x50
 [<ffffffff810a75ab>] ? preempt_count_sub+0x7b/0x100
 [<ffffffff8139ac66>] ? __percpu_counter_add+0x86/0xb0
 [<ffffffff811b2396>] ? __vm_enough_memory+0x66/0x1c0
 [<ffffffff8117cac5>] ? find_get_entry+0x5/0x120
 [<ffffffff81300937>] ? cap_vm_enough_memory+0x47/0x50
 [<ffffffff81197880>] shmem_getpage_gfp+0x4d0/0x7e0
 [<ffffffff81197bd2>] shmem_write_begin+0x42/0x70
 [<ffffffff8117c2d4>] generic_perform_write+0xd4/0x1f0
 [<ffffffff8117eac2>] __generic_file_write_iter+0x162/0x350
 [<ffffffff811f0070>] ? new_sync_read+0xd0/0xd0
 [<ffffffff8117ecef>] generic_file_write_iter+0x3f/0xb0
 [<ffffffff8117ecb0>] ? __generic_file_write_iter+0x350/0x350
 [<ffffffff811f01b8>] do_iter_readv_writev+0x78/0xc0
 [<ffffffff811f19e8>] do_readv_writev+0xd8/0x2a0
 [<ffffffff8117ecb0>] ? __generic_file_write_iter+0x350/0x350
 [<ffffffff8117ecb0>] ? __generic_file_write_iter+0x350/0x350
 [<ffffffff810c54b6>] ? lock_release_holdtime.part.24+0xe6/0x160
 [<ffffffff810a7431>] ? get_parent_ip+0x11/0x50
 [<ffffffff810a75ab>] ? preempt_count_sub+0x7b/0x100
 [<ffffffff817df36b>] ? _raw_spin_unlock_irq+0x3b/0x60
 [<ffffffff811f1c3c>] vfs_writev+0x3c/0x50
 [<ffffffff811f1dac>] SyS_writev+0x5c/0x100
 [<ffffffff817e0249>] tracesys_phase2+0xd4/0xd9
Code: 65 48 33 04 25 28 00 00 00 75 75 48 83 c4 50 5b 41 5c 5d c3 0f 1f 00 9c 5a fa 0f 20 e0 48 89 c1 80 e1 7f 0f 22 e1 0f 22 e0 52 9d <eb> cf 66 90 49 bc 00 00 00 00 00 88 ff ff 48 63 f6 49 01 fc 48 
sending NMI to other CPUs:


<nothing further on console, accidentally had panic=1 set>
