Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757321Ab3EAVAM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 17:00:12 -0400
Received: from mail-da0-f47.google.com ([209.85.210.47]:38694 "EHLO
	mail-da0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756938Ab3EAVAJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 17:00:09 -0400
Date: Wed, 1 May 2013 14:00:06 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Borislav Petkov <bp@alien8.de>
cc: Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org, Pekka Enberg <penberg@kernel.org>,
        levinsasha928@gmail.com, mtosatti@redhat.com, tglx@linutronix.de,
        Borislav Petkov <bp@suse.de>, fengguang.wu@intel.com,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/urgent] x86/kconfig:  Add a Kconfig shortcut for building
 working KVM guest kernels
In-Reply-To: <20130501203500.GC4466@pd.tnic>
Message-ID: <alpine.DEB.2.02.1305011358500.19189@chino.kir.corp.google.com>
References: <20130426095140.GA15361@pd.tnic> <tip-83aee67833071c7b73a83f7803388f7a9e481908@git.kernel.org> <alpine.DEB.2.02.1305011248220.8448@chino.kir.corp.google.com> <20130501203500.GC4466@pd.tnic>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 May 2013, Borislav Petkov wrote:

> ---
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index e8fff2f4ecb7..4f8ef85b0633 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -389,7 +389,8 @@ config X86_VSMP
>  	bool "ScaleMP vSMP"
>  	select HYPERVISOR_GUEST
>  	select PARAVIRT
> -	depends on X86_64 && PCI
> +	select PCI
> +	depends on X86_64
>  	depends on X86_EXTENDED_PLATFORM
>  	depends on SMP
>  	---help---
> @@ -664,6 +665,7 @@ config KVM_GUEST_COMMON_OPTIONS
>  	select IP_PNP
>  	select IP_PNP_DHCP
>  	select BINFMT_ELF
> +	select PCI
>  	select PCI_MSI
>  	select HAVE_ARCH_KGDB
>  	select DEBUG_KERNEL

With this applied, two other types of conflicting dependencies:

warning: (KVM_GUEST_COMMON_OPTIONS) selects VIRTIO_NET which has unmet direct dependencies (NETDEVICES && NET_CORE && VIRTIO)

and

warning: (KVM_GUEST_COMMON_OPTIONS && AMD_IOMMU) selects PCI_MSI which has unmet direct dependencies (PCI && ARCH_SUPPORTS_MSI)
