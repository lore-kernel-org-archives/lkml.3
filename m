Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965964Ab3DQHuo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 03:50:44 -0400
Received: from mail.skyhub.de ([78.46.96.112]:43724 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965738Ab3DQHum (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 03:50:42 -0400
Date: Wed, 17 Apr 2013 09:50:37 +0200
From: Borislav Petkov <bp@alien8.de>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: Pekka Enberg <penberg@kernel.org>, Ingo Molnar <mingo@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Fengguang Wu <fengguang.wu@intel.com>,
        lkml <linux-kernel@vger.kernel.org>, x86-ml <x86@kernel.org>,
        kvm@vger.kernel.org
Subject: Re: [PATCH] x86: Add a Kconfig shortcut for a kvm-bootable kernel
Message-ID: <20130417075037.GB11807@pd.tnic>
References: <20130412181956.GA13099@pd.tnic>
 <516A7760.7030907@kernel.org>
 <20130414110320.GB20547@pd.tnic>
 <20130416161852.GH5332@pd.tnic>
 <516DEF20.9060303@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <516DEF20.9060303@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 16, 2013 at 08:38:56PM -0400, Sasha Levin wrote:
> > 	select NET
> > 	select NETDEVICES
> > 	select PCI
> > 	select BLOCK
> > 	select BLK_DEV
> > 	select NETWORK_FILESYSTEMS
> > 	select INET
> > 	select EXPERIMENTAL
> > 	select TTY
> > 	select SERIAL_8250
> > 	select SERIAL_8250_CONSOLE
> > 	select IP_PNP
> > 	select IP_PNP_DHCP
> > 	select BINFMT_ELF
> > 	select PCI_MSI
> > 	select HAVE_ARCH_KGDB
> > 	select DEBUG_KERNEL
> > 	select KGDB
> > 	select KGDB_SERIAL_CONSOLE
> > 	select VIRTUALIZATION
> > 	select VIRTIO
> > 	select VIRTIO_RING
> > 	select VIRTIO_PCI
> > 	select VIRTIO_BLK
> > 	select VIRTIO_CONSOLE
> > 	select VIRTIO_NET
> > 	select 9P_FS
> > 	select NET_9P
> > 	select NET_9P_VIRTIO
> > 
> > to the option below which we already have. It is in the same sense a KVM
> > guest support deal.
> > 
> > Hmm.
> > 
> > KVM people, any objections?
> > 
> > config KVM_GUEST
> >         bool "KVM Guest support (including kvmclock)"
> >         depends on PARAVIRT
> >         select PARAVIRT_CLOCK
> >         default y
> >         ---help---
> >           This option enables various optimizations for running under the KVM
> >           hypervisor. It includes a paravirtualized clock, so that instead
> >           of relying on a PIT (or probably other) emulation by the
> >           underlying device model, the host provides the guest with
> >           timing infrastructure such as time of day, and system time
> 
> KVM guests don't need a serial device, KGDB, DEBUG_KERNEL or 9p in particular.

Let's see:

* we need serial device for catching serial output on the host from the guest
  kernel

* KGDB - I guess this was meant to jump into the debugger when the guest crashes
  or so, we could drop it.

* DEBUG_KERNEL is also good for testing kernels
* 9p is needed for -virtfs folder sharing, AFAICT: http://wiki.qemu.org/Documentation/9psetup

So, I guess we can have another KVM_GUEST_KERNEL_TESTING option which
enables those additional, good for debugging options (except 9p - it
should be in the main thing) and which depends on KVM_GUEST. It would also
contain other DEBUG_* stuff.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
