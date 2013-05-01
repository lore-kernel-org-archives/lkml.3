Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756886Ab3EATxK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 15:53:10 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:42912 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756593Ab3EATxH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 15:53:07 -0400
Date: Wed, 1 May 2013 12:53:03 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org, Pekka Enberg <penberg@kernel.org>,
        Borislav Petkov <bp@alien8.de>, levinsasha928@gmail.com,
        mtosatti@redhat.com, tglx@linutronix.de, Borislav Petkov <bp@suse.de>,
        fengguang.wu@intel.com
cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/urgent] x86/kconfig:  Add a Kconfig shortcut for building
 working KVM guest kernels
In-Reply-To: <tip-83aee67833071c7b73a83f7803388f7a9e481908@git.kernel.org>
Message-ID: <alpine.DEB.2.02.1305011248220.8448@chino.kir.corp.google.com>
References: <20130426095140.GA15361@pd.tnic> <tip-83aee67833071c7b73a83f7803388f7a9e481908@git.kernel.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="531381512-1184140420-1367437984=:8448"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--531381512-1184140420-1367437984=:8448
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Tue, 30 Apr 2013, tip-bot for Borislav Petkov wrote:

> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index 15b5cef..1d053dc 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -633,6 +633,45 @@ config KVM_GUEST
>  	  underlying device model, the host provides the guest with
>  	  timing infrastructure such as time of day, and system time
>  
> +config KVM_GUEST_COMMON_OPTIONS
> +	bool "Enable commodity options for a standalone KVM guest"
> +	depends on KVM_GUEST
> +	select NET
> +	select NETDEVICES
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
> +	  Select guest kernel functionality which facilitates booting the
> +	  kernel as a guest in qemu or lkvm. This entails basic stuff like
> +	  serial support, kgdb, virtio and other so that you can be able to
> +	  have commodity functionality like serial output from the guest,
> +	  networking, seamless host file system integration into guest context
> +	  and other useful things.
> +
>  source "arch/x86/lguest/Kconfig"
>  
>  config PARAVIRT

This causes

warning: (KVM_GUEST_COMMON_OPTIONS && AMD_IOMMU) selects PCI_MSI which has unmet direct dependencies (PCI && ARCH_SUPPORTS_MSI)
warning: (KVM_GUEST_COMMON_OPTIONS) selects VIRTIO_PCI which has unmet direct dependencies (PCI)

in linux-next which results in

drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c: In function ‘ixgbevf_request_msix_irqs’:
drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c:911:10: error: invalid use of undefined type ‘struct msix_entry’
drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c:911:52: error: dereferencing pointer to incomplete type
drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c:927:26: error: dereferencing pointer to incomplete type
drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c:937:2: error: invalid use of undefined type ‘struct msix_entry’
drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c:937:41: error: dereferencing pointer to incomplete type
drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c:950:3: error: invalid use of undefined type ‘struct msix_entry’
drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c:950:33: error: dereferencing pointer to incomplete type
drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c: In function ‘ixgbevf_free_irq’:
drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c:1007:2: error: invalid use of undefined type ‘struct msix_entry’
drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c:1007:32: error: dereferencing pointer to incomplete type
drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c:1016:3: error: invalid use of undefined type ‘struct msix_entry’
drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c:1016:33: error: dereferencing pointer to incomplete type
drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c: In function ‘ixgbevf_irq_disable’
drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c:1039:3: error: invalid use of undefined type ‘struct msix_entry’
drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c:1039:40: error: dereferencing pointer to incomplete type
drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c: In function ‘ixgbevf_acquire_msix_vectors’:
drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c:1767:3: error: implicit declaration of function ‘pci_enable_msix’ [-Werror=implicit-function-declaration]
drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c: In function ‘ixgbevf_set_interrupt_capability’:
drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c:1887:13: error: invalid application of ‘sizeof’ to incomplete type ‘struct msix_entry’ 
drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c:1894:3: error: invalid use of undefined type ‘struct msix_entry’
drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c:1894:24: error: dereferencing pointer to incomplete type
drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c: In function ‘ixgbevf_reset_interrupt_capability’:
drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c:1976:2: error: implicit declaration of function ‘pci_disable_msix’ [-Werror=implicit-function-declaration]
drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c: In function ‘ixgbevf_resume’:
drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c:3212:2: error: implicit declaration of function ‘pci_enable_device_mem’ [-Werror=implicit-function-declaration]

since KVM_GUEST_COMMON_OPTIONS selects PCI_MSI without selecting PCI.

If we select PCI in KVM_GUEST_COMMON_OPTIONS, we get:

arch/x86/Kconfig:651:error: recursive dependency detected!
arch/x86/Kconfig:651:	symbol KVM_GUEST_COMMON_OPTIONS depends on HYPERVISOR_GUEST
arch/x86/Kconfig:597:	symbol HYPERVISOR_GUEST is selected by X86_VSMP
arch/x86/Kconfig:388:	symbol X86_VSMP depends on PCI
arch/x86/Kconfig:2042:	symbol PCI is selected by KVM_GUEST_COMMON_OPTIONS
--531381512-1184140420-1367437984=:8448--
