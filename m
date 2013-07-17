Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757014Ab3GQT3D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 15:29:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37416 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755944Ab3GQT3A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 15:29:00 -0400
Date: Wed, 17 Jul 2013 22:28:48 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: Xiao Guangrong <xiaoguangrong.eric@gmail.com>, kvm@vger.kernel.org,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: commit f8f559422b (KVM: MMU: fast invalidate all mmio sptes)
 causes hang
Message-ID: <20130717192848.GL13732@redhat.com>
References: <20130717163215.GA359@x4>
 <20130717164232.GI13732@redhat.com>
 <20130717165743.GA357@x4>
 <A242AFC1-86E6-4716-8DF7-6FD169DB6EC8@gmail.com>
 <20130717184226.GA358@x4>
 <20130717185539.GK13732@redhat.com>
 <20130717190029.GA362@x4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130717190029.GA362@x4>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 17, 2013 at 09:00:29PM +0200, Markus Trippelsdorf wrote:
> > > 10346403  qemu-system-x86-1403  [001]  1451.422260: check_mmio_spte:      spte ffff0000fee00e3f kvm_gen 7ffc8 spte-gen 7ffc7 valid 0  
> > > ...
Can you trace only this event and record stack information:
trace-cmd record -T -e kvmmmu:check_mmio_spte


> > > 
> [  236.322519] qemu-system-x86 R  running task        0   603    367 0x00000000
Is this the task that now prints check_mmio_spte ad nauseam?

> [  236.322523]  0000000000000000 0000000100000000 00007fff27e6b950 00000000000fee00
> [  236.322528]  ffff8801df8b3b90 00000000fee000b0 ffff8801dff0b0d1 0000000000000000
> [  236.322533]  ffff8801df8b3b90 ffff8801f7614040 0000000000000000 0000000000000000
> [  236.322537] Call Trace:
> [  236.322544]  [<ffffffff8102aea0>] ? nested_svm_get_tdp_cr3+0x20/0x20
I am assuming you are not running nested guest and this is just a glitch
in the matrix, correct?

> [  236.322551]  [<ffffffff810100b5>] ? kvm_arch_vcpu_ioctl_run+0x415/0x10c0
> [  236.322556]  [<ffffffff810e24cb>] ? page_add_new_anon_rmap+0x2b/0x100
> [  236.322561]  [<ffffffff810d8fbb>] ? handle_pte_fault+0x69b/0x7c0
> [  236.322567]  [<ffffffff8100d10a>] ? kvm_arch_vcpu_load+0x4a/0x1e0
> [  236.322573]  [<ffffffff810022b1>] ? kvm_vcpu_ioctl+0x271/0x500
> [  236.322578]  [<ffffffff811067ec>] ? do_vfs_ioctl+0x2cc/0x4a0
> [  236.322583]  [<ffffffff811069fc>] ? SyS_ioctl+0x3c/0x80
> [  236.322588]  [<ffffffff81583592>] ? system_call_fastpath+0x16/0x1b

--
			Gleb.
