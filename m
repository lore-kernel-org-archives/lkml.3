Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756348Ab3DLUIX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 16:08:23 -0400
Received: from casper.infradead.org ([85.118.1.10]:43663 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755109Ab3DLUIV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 16:08:21 -0400
Message-ID: <516869A7.7060500@infradead.org>
Date: Fri, 12 Apr 2013 13:08:07 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Pekka Enberg <penberg@kernel.org>,
        Sasha Levin <levinsasha928@gmail.com>,
        Fengguang Wu <fengguang.wu@intel.com>,
        lkml <linux-kernel@vger.kernel.org>, x86-ml <x86@kernel.org>
Subject: Re: [PATCH] x86: Add a Kconfig shortcut for a kvm-bootable kernel
References: <20130412181956.GA13099@pd.tnic>
In-Reply-To: <20130412181956.GA13099@pd.tnic>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/12/13 11:19, Borislav Petkov wrote:
> --
> From efa9a7f7a460bc46d1dd37b691afa88070a34059 Mon Sep 17 00:00:00 2001
> From: Borislav Petkov <bp@suse.de>
> Date: Fri, 12 Apr 2013 20:01:47 +0200
> Subject: [PATCH] x86: Add a Kconfig shortcut for a kvm-bootable kernel
> 
> This is pretty useful for the case where people want to boot the
> resulting kernel in qemu/kvm. Instead of going and searching for each
> required option through the Kconfig maze, this single option should
> simply enable all stuff which is required to boot the resulting kernel
> in the guest.
> 
> Originally-by: Pekka Enberg <penberg@kernel.org>
> Originally-by: Sasha Levin <levinsasha928@gmail.com>
> Signed-off-by: Borislav Petkov <bp@suse.de>
> Cc: Fengguang Wu <fengguang.wu@intel.com>
> ---
>  arch/x86/Kconfig | 37 +++++++++++++++++++++++++++++++++++++
>  1 file changed, 37 insertions(+)
> 
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index 70c0f3da0476..3ca241172812 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -596,6 +596,43 @@ config SCHED_OMIT_FRAME_POINTER
>  
>  	  If in doubt, say "Y".
>  
> +config KVM_TEST_ENABLE
> +	bool "Enable options for a kernel suitable for testing in kvm"
> +	select NET
> +	select NETDEVICES
> +	select PCI
> +	select BLOCK
> +	select BLK_DEV
> +	select NETWORK_FILESYSTEMS
> +	select INET
> +	select EXPERIMENTAL
> +	select TTY
> +	select SERIAL_8250
> +	select SERIAL_8250_CONSOLE
> +	select IP_PNP
> +	select IP_PNP_DHCP
> +	select BINFMT_ELF
> +	select PCI_MSI
> +	select HAVE_ARCH_KGDB
> +	select DEBUG_KERNEL
> +	select KGDB
> +	select KGDB_SERIAL_CONSOLE
> +	select VIRTUALIZATION
> +	select VIRTIO
> +	select VIRTIO_RING
> +	select VIRTIO_PCI
> +	select VIRTIO_BLK
> +	select VIRTIO_CONSOLE
> +	select VIRTIO_NET
> +	select 9P_FS
> +	select NET_9P
> +	select NET_9P_VIRTIO
> +	---help---
> +	  Select stuff which is required for booting the kernel as a guest
> +	  in qemu/kvm. This entails basic stuff like serial support, kgdb

Use commas, please:

	                                        like serial support, kgdb,
	  9p, virtio, and other basic ...

> +	  9p virtio and other basic functionality so that you can be able
> +	  to have serial output from the guest, networking, etc.
> +
>  menuconfig PARAVIRT_GUEST
>  	bool "Paravirtualized guest support"
>  	---help---
> 


-- 
~Randy
