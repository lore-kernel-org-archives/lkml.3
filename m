Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754159AbaCZO5K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 10:57:10 -0400
Received: from mga11.intel.com ([192.55.52.93]:62837 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750956AbaCZO5I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 10:57:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,735,1389772800"; 
   d="scan'208";a="499956732"
Date: Wed, 26 Mar 2014 22:57:01 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, lkp@01.org
Subject: Re: [KVM] BUG: unable to handle kernel NULL pointer dereference at
 00000000000002b0
Message-ID: <20140326145701.GA27938@localhost>
References: <20140326144053.GC26721@localhost>
 <5332E94B.3050407@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5332E94B.3050407@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 26, 2014 at 03:50:51PM +0100, Paolo Bonzini wrote:
> Il 26/03/2014 15:40, Fengguang Wu ha scritto:
> >Hi Paolo,
> >
> >We noticed the below kernel BUG on
> >
> >git://git.kernel.org/pub/scm/virt/kvm/kvm.git queue
> >commit 93c4adc7afedf9b0ec190066d45b6d67db5270da ("KVM: x86: handle missing MPX in nested virtualization")
> 
> Ouch.  Out of curiosity is this on Skylake prototypes, or is it also
> visible on some released silicon?

Paolo, the problem shows up in a Sandybridge-EX and an Ivybridge-EX.

Thanks,
Fengguang

> >[   17.665744] Freeing initrd memory: 213444K (ffff880072f82000 - ffff88007fff3000)
> >[   17.674933] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
> >[   17.682659] software IO TLB [mem 0xb73c7000-0xbb3c7000] (64MB) mapped at [ffff8800b73c7000-ffff8800bb3c6fff]
> >[   17.695661] BUG: unable to handle kernel NULL pointer dereference at 00000000000002b0
> >[   17.705465] IP: [<ffffffff81015a9f>] kvm_arch_init+0x12a/0x1ea
> >[   17.712577] PGD 0
> >[   17.715390] Oops: 0000 [#1] SMP
> >[   17.719654] Modules linked in:
> >[   17.723641] CPU: 10 PID: 1 Comm: swapper/0 Not tainted 3.14.0-rc7-03020-ga929a7d #1
> >[   17.733067] Hardware name: Intel Corporation LH Pass/S4600LH...., BIOS SE5C600.86B.99.02.1047.032320122259 03/23/2012
> >[   17.745821] task: ffff880429cb0000 ti: ffff880429ca4000 task.ti: ffff880429ca4000
> >[   17.755039] RIP: 0010:[<ffffffff81015a9f>]  [<ffffffff81015a9f>] kvm_arch_init+0x12a/0x1ea
> >[   17.765228] RSP: 0000:ffff880429ca5e00  EFLAGS: 00010246
> >[   17.771644] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
> >[   17.780096] RDX: 0000000000000000 RSI: ffff880429ca5e04 RDI: 0000000000000d90
> >[   17.788549] RBP: ffff880429ca5e30 R08: ffff88082fc55d00 R09: ffff88042f803e00
> >[   17.796993] R10: 0000000000000004 R11: 0000000000000003 R12: 000000000000000c
> >[   17.805449] R13: 0000000000000017 R14: ffffffff82018b10 R15: 0000000000000018
> >[   17.813907] FS:  0000000000000000(0000) GS:ffff88082fc40000(0000) knlGS:0000000000000000
> >[   17.823808] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> >[   17.830693] CR2: 00000000000002b0 CR3: 000000000200f000 CR4: 00000000000407e0
> >[   17.839159] Stack:
> >[   17.841873]  0000000000000000 0000000000000040 0000000000000000 0000000000003f40
> >[   17.851328]  0000000000000000 0000000000000000 ffff880429ca5e68 ffffffff810039dc
> >[   17.860790]  00000000000164d8 0000000000000006 0000000000000000 000000000000023c
> >[   17.870256] Call Trace:
> >[   17.873468]  [<ffffffff810039dc>] kvm_init+0x1f/0x24a
> >[   17.879599]  [<ffffffff82154fa4>] vmx_init+0x1df/0x3f6
> >[   17.885825]  [<ffffffff82154dc5>] ? vmx_check_processor_compat+0x61/0x61
> >[   17.893782]  [<ffffffff810002d2>] do_one_initcall+0xa4/0x13a
> >[   17.900604]  [<ffffffff810f9aa9>] ? parse_args+0x25f/0x33d
> >[   17.907225]  [<ffffffff8214ff94>] kernel_init_freeable+0x1a9/0x22e
> >[   17.914615]  [<ffffffff8214f78f>] ? do_early_param+0x88/0x88
> >[   17.921433]  [<ffffffff819af0d5>] ? rest_init+0x89/0x89
> >[   17.927731]  [<ffffffff819af0e3>] kernel_init+0xe/0xdf
> >
> >Full dmesg is attached, and more details can be provided on your request.
> >
> >Thanks,
> >Fengguang
> >
