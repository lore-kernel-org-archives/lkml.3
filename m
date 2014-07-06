Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751298AbaGFPMu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2014 11:12:50 -0400
Received: from mail-wi0-f179.google.com ([209.85.212.179]:45394 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750889AbaGFPMs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2014 11:12:48 -0400
Date: Sun, 6 Jul 2014 18:12:42 +0300
From: Gleb Natapov <gleb@kernel.org>
To: Jan Kiszka <jan.kiszka@web.de>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86 <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        kvm <kvm@vger.kernel.org>
Subject: Re: [PATCH] x86: Make x2APIC support depend on interrupt remapping
 or guest support
Message-ID: <20140706151242.GN18167@minantech.com>
References: <53B7ADAA.9030101@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53B7ADAA.9030101@web.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 05, 2014 at 09:47:54AM +0200, Jan Kiszka wrote:
> From: Jan Kiszka <jan.kiszka@siemens.com>
> 
> We are able to use x2APIC mode in the absence of interrupt remapping on
> certain hypervisors. So it if fine to disable IRQ_REMAP without having
> to give up x2APIC support.
FWIW I did similar thing back when I added x2apic to KVM:
http://linux.derkeiler.com/Mailing-Lists/Kernel/2009-06/msg14579.html
But was advised against it.

> 
> Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
> ---
>  arch/x86/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index a8f749e..30a9987 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -310,7 +310,7 @@ config SMP
>  
>  config X86_X2APIC
>  	bool "Support x2apic"
> -	depends on X86_LOCAL_APIC && X86_64 && IRQ_REMAP
> +	depends on X86_LOCAL_APIC && X86_64 && (IRQ_REMAP || HYPERVISOR_GUEST)
>  	---help---
>  	  This enables x2apic support on CPUs that have this feature.
>  
> 
> 



--
			Gleb.
