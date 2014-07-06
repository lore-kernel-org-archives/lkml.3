Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751443AbaGFOcN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2014 10:32:13 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:58690 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750903AbaGFOcL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2014 10:32:11 -0400
Message-ID: <53B95DE5.5040101@redhat.com>
Date: Sun, 06 Jul 2014 16:32:05 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Jan Kiszka <jan.kiszka@web.de>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86 <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: kvm <kvm@vger.kernel.org>
Subject: Re: [PATCH] x86: Make x2APIC support depend on interrupt remapping
 or guest support
References: <53B7ADAA.9030101@web.de>
In-Reply-To: <53B7ADAA.9030101@web.de>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 05/07/2014 09:47, Jan Kiszka ha scritto:
> From: Jan Kiszka <jan.kiszka@siemens.com>
>
> We are able to use x2APIC mode in the absence of interrupt remapping on
> certain hypervisors. So it if fine to disable IRQ_REMAP without having
> to give up x2APIC support.
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

Makes sense.

Acked-by: Paolo Bonzini <pbonzini@redhat.com>
