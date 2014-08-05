Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755829AbaHEQaB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 12:30:01 -0400
Received: from mail-qg0-f45.google.com ([209.85.192.45]:40079 "EHLO
	mail-qg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751919AbaHEQaA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 12:30:00 -0400
Date: Tue, 5 Aug 2014 12:29:56 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
cc: Russell King <rmk+kernel@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: remove unused/deprecated read_cpuid_part_number()
In-Reply-To: <2694769.svrdKA2rqt@amdc1032>
Message-ID: <alpine.LFD.2.11.1408051228480.6061@knanqh.ubzr>
References: <2694769.svrdKA2rqt@amdc1032>
User-Agent: Alpine 2.11 (LFD 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Aug 2014, Bartlomiej Zolnierkiewicz wrote:

> Commit af040ffc9ba1 ("ARM: make it easier to check the CPU part
> number correctly") has left (now unused in the upstream tree and
> marked as deprecated) read_cpuid_part_number() while changing
> the way it works (using the old function with the definitions will
> now always evaluate as false).  This causes problems with porting
> older code to new kernels as the code compiles (with warnings but
> they are very easy to miss) but it can fail silently or work just
> fine depending on the used hardware.
> 
> Remove unused/deprecated read_cpuid_part_number() so developers
> have to update their code during build time instead of running into
> tricky runtime problems later.
> 
> Please see the commit af040ffc9ba1 for details on how to convert
> your old out-of-tree code to use read_cpuid_part() instead of
> read_cpuid_part_number().
> 
> Cc: Nicolas Pitre <nico@linaro.org>
> Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>

If there are no more in-tree users then it should go indeed.

Acked-by: Nicolas Pitre <nico@linaro.org>

> ---
>  arch/arm/include/asm/cputype.h |    5 -----
>  1 file changed, 5 deletions(-)
> 
> Index: b/arch/arm/include/asm/cputype.h
> ===================================================================
> --- a/arch/arm/include/asm/cputype.h	2014-08-04 15:09:30.166988335 +0200
> +++ b/arch/arm/include/asm/cputype.h	2014-08-05 15:40:03.793317783 +0200
> @@ -182,11 +182,6 @@ static inline unsigned int __attribute_c
>  	return read_cpuid_id() & 0xff00fff0;
>  }
>  
> -static inline unsigned int __attribute_const__ __deprecated read_cpuid_part_number(void)
> -{
> -	return read_cpuid_id() & 0xFFF0;
> -}
> -
>  static inline unsigned int __attribute_const__ xscale_cpu_arch_version(void)
>  {
>  	return read_cpuid_id() & ARM_CPU_XSCALE_ARCH_MASK;
> 
> 
