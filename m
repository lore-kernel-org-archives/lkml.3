Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965506Ab3DRNhD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 09:37:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33599 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934912Ab3DRNhB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 09:37:01 -0400
Date: Thu, 18 Apr 2013 10:36:31 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Pekka Enberg <penberg@kernel.org>, Ingo Molnar <mingo@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Sasha Levin <levinsasha928@gmail.com>,
        Fengguang Wu <fengguang.wu@intel.com>,
        lkml <linux-kernel@vger.kernel.org>, x86-ml <x86@kernel.org>,
        kvm@vger.kernel.org
Subject: Re: [PATCH] x86: Add a Kconfig shortcut for a kvm-bootable kernel
Message-ID: <20130418133631.GA30965@amt.cnet>
References: <20130412181956.GA13099@pd.tnic>
 <516A7760.7030907@kernel.org>
 <20130414110320.GB20547@pd.tnic>
 <20130416161852.GH5332@pd.tnic>
 <20130417232507.GC31059@amt.cnet>
 <20130418094629.GC21719@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130418094629.GC21719@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 18, 2013 at 11:46:29AM +0200, Borislav Petkov wrote:
> On Wed, Apr 17, 2013 at 08:25:07PM -0300, Marcelo Tosatti wrote:
> > On Tue, Apr 16, 2013 at 06:18:52PM +0200, Borislav Petkov wrote:
> > > On Sun, Apr 14, 2013 at 01:03:20PM +0200, Borislav Petkov wrote:
> > > > On Sun, Apr 14, 2013 at 12:31:12PM +0300, Pekka Enberg wrote:
> > > > > I obviously support having something like this in mainline. I wonder
> > > > > though if we could just call this "default standalone KVM guest
> > > > > config" instead of emphasizing testing angle.
> > > > 
> > > > /me nods agreeingly...
> > > > 
> > > > And it should be unter HYPERVISOR_GUEST where the rest of this stuff
> > > > resides. Good point.
> > > 
> > > Sanity check question:
> > > 
> > > Why not add the select stuff, i.e. this:
> > > 
> > > 	select NET
> > > 	select NETDEVICES
> > > 	select PCI
> > > 	select BLOCK
> > > 	select BLK_DEV
> > > 	select NETWORK_FILESYSTEMS
> > > 	select INET
> > > 	select EXPERIMENTAL
> > > 	select TTY
> > > 	select SERIAL_8250
> > > 	select SERIAL_8250_CONSOLE
> > > 	select IP_PNP
> > > 	select IP_PNP_DHCP
> > > 	select BINFMT_ELF
> > > 	select PCI_MSI
> > > 	select HAVE_ARCH_KGDB
> > > 	select DEBUG_KERNEL
> > > 	select KGDB
> > > 	select KGDB_SERIAL_CONSOLE
> > > 	select VIRTUALIZATION
> > > 	select VIRTIO
> > > 	select VIRTIO_RING
> > > 	select VIRTIO_PCI
> > > 	select VIRTIO_BLK
> > > 	select VIRTIO_CONSOLE
> > > 	select VIRTIO_NET
> > > 	select 9P_FS
> > > 	select NET_9P
> > > 	select NET_9P_VIRTIO
> > > 
> > > to the option below which we already have. It is in the same sense a KVM
> > > guest support deal.
> > > 
> > > Hmm.
> > > 
> > > KVM people, any objections?
> > 
> > None, but please don't mix it with 'KVM_GUEST' flag below. 
> > 
> > Actually, what about adding kvm variants of the two files at
> > arch/x86/configs/ ?
> 
> two files?

x86_64, x86_32.

> > 
> > > config KVM_GUEST
> > >         bool "KVM Guest support (including kvmclock)"
> > >         depends on PARAVIRT
> > >         select PARAVIRT_CLOCK
> > >         default y
> > >         ---help---
> > >           This option enables various optimizations for running under the KVM
> > >           hypervisor. It includes a paravirtualized clock, so that instead
> > >           of relying on a PIT (or probably other) emulation by the
> > >           underlying device model, the host provides the guest with
> > >           timing infrastructure such as time of day, and system time
> 
> Hmm,
> 
> ok, maybe I wasn't clear enough. My proposal was to actually add all (or
> maybe not *all* of them, but most) those selects above to the KVM_GUEST
> config option. Because, you very probably want to select all that stuff
> above anyway if you want to build a kvm guest kernel, no?

Very probably but not certainly.

> IOW, something which says "Enable KVM guest support" should enable all
> the stuff needed for that.

I get your point, but thats up to the person selecting the options.

> Or do you want to keep the current CONFIG_KVM_GUEST separate for special
> stuff?

Yes.

> And yes, Sasha's suggestion to have an additional
> CONFIG_KVM_GUEST_KERNEL_TESTING or so option which enables debug
> stuff for people who write patches for the kernel and want to quickly
> smoke-test it in kvm.

Thats fine.

> Basically, I'm looking from the perspective of a kernel dev who would
> like to make an optimal use of kvm for testing kernels.
> 
> Does that make more sense?

Understood (just don't mix it with the current CONFIG_KVM_GUEST option).

Even though can't see why those options can live in defconfig files as
suggested.

