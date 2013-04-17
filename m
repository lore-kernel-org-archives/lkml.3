Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754914Ab3DQAjZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 20:39:25 -0400
Received: from mail-ve0-f174.google.com ([209.85.128.174]:45606 "EHLO
	mail-ve0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753638Ab3DQAjY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 20:39:24 -0400
Message-ID: <516DEF20.9060303@gmail.com>
Date: Tue, 16 Apr 2013 20:38:56 -0400
From: Sasha Levin <levinsasha928@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130408 Thunderbird/17.0.5
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: Pekka Enberg <penberg@kernel.org>, Ingo Molnar <mingo@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Fengguang Wu <fengguang.wu@intel.com>,
        lkml <linux-kernel@vger.kernel.org>, x86-ml <x86@kernel.org>,
        kvm@vger.kernel.org
Subject: Re: [PATCH] x86: Add a Kconfig shortcut for a kvm-bootable kernel
References: <20130412181956.GA13099@pd.tnic> <516A7760.7030907@kernel.org> <20130414110320.GB20547@pd.tnic> <20130416161852.GH5332@pd.tnic>
In-Reply-To: <20130416161852.GH5332@pd.tnic>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/16/2013 12:18 PM, Borislav Petkov wrote:
> On Sun, Apr 14, 2013 at 01:03:20PM +0200, Borislav Petkov wrote:
>> On Sun, Apr 14, 2013 at 12:31:12PM +0300, Pekka Enberg wrote:
>>> I obviously support having something like this in mainline. I wonder
>>> though if we could just call this "default standalone KVM guest
>>> config" instead of emphasizing testing angle.
>>
>> /me nods agreeingly...
>>
>> And it should be unter HYPERVISOR_GUEST where the rest of this stuff
>> resides. Good point.
> 
> Sanity check question:
> 
> Why not add the select stuff, i.e. this:
> 
> 	select NET
> 	select NETDEVICES
> 	select PCI
> 	select BLOCK
> 	select BLK_DEV
> 	select NETWORK_FILESYSTEMS
> 	select INET
> 	select EXPERIMENTAL
> 	select TTY
> 	select SERIAL_8250
> 	select SERIAL_8250_CONSOLE
> 	select IP_PNP
> 	select IP_PNP_DHCP
> 	select BINFMT_ELF
> 	select PCI_MSI
> 	select HAVE_ARCH_KGDB
> 	select DEBUG_KERNEL
> 	select KGDB
> 	select KGDB_SERIAL_CONSOLE
> 	select VIRTUALIZATION
> 	select VIRTIO
> 	select VIRTIO_RING
> 	select VIRTIO_PCI
> 	select VIRTIO_BLK
> 	select VIRTIO_CONSOLE
> 	select VIRTIO_NET
> 	select 9P_FS
> 	select NET_9P
> 	select NET_9P_VIRTIO
> 
> to the option below which we already have. It is in the same sense a KVM
> guest support deal.
> 
> Hmm.
> 
> KVM people, any objections?
> 
> config KVM_GUEST
>         bool "KVM Guest support (including kvmclock)"
>         depends on PARAVIRT
>         select PARAVIRT_CLOCK
>         default y
>         ---help---
>           This option enables various optimizations for running under the KVM
>           hypervisor. It includes a paravirtualized clock, so that instead
>           of relying on a PIT (or probably other) emulation by the
>           underlying device model, the host provides the guest with
>           timing infrastructure such as time of day, and system time

KVM guests don't need a serial device, KGDB, DEBUG_KERNEL or 9p in particular.


Thanks,
Sasha
