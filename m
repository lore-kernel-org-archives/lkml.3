Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751890AbaJOPrX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 11:47:23 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57194 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751789AbaJOPrT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 11:47:19 -0400
Message-ID: <543E96FF.6000201@zytor.com>
Date: Wed, 15 Oct 2014 08:47:11 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>
CC: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arch/x86/realmode: make trampoline code conditional for
 x86-32
References: <1413387506-5269-1-git-send-email-jarkko.sakkinen@linux.intel.com>
In-Reply-To: <1413387506-5269-1-git-send-email-jarkko.sakkinen@linux.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/15/2014 08:38 AM, Jarkko Sakkinen wrote:
> Trampoline code is only needed for SMP and in x86-64 for wakeup
> code. Make it conditional in order to minimize the kernel size.
> 
> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> ---
>  arch/x86/realmode/rm/Makefile | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/arch/x86/realmode/rm/Makefile b/arch/x86/realmode/rm/Makefile
> index 7c0d7be..82b7312 100644
> --- a/arch/x86/realmode/rm/Makefile
> +++ b/arch/x86/realmode/rm/Makefile
> @@ -20,7 +20,11 @@ wakeup-objs	+= video-vesa.o
>  wakeup-objs	+= video-bios.o
>  
>  realmode-y			+= header.o
> +ifdef CONFIG_X86_64
>  realmode-y			+= trampoline_$(BITS).o
> +else
> +realmode-$(CONFIG_SMP)		+= trampoline_$(BITS).o
> +endif
>  realmode-y			+= stack.o
>  realmode-y			+= reboot.o
>  realmode-$(CONFIG_ACPI_SLEEP)	+= $(wakeup-objs)
> 

It is usually preferred to make this a hidden config option (e.g.
CONFIG_X86_TRAMPOLINE) rather than use ifdef, especially since your
ifdef has another conditional inside it.

	-hpa

