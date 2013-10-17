Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756731Ab3JQOQ7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 10:16:59 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:54125 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756160Ab3JQOQ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 10:16:58 -0400
Date: Thu, 17 Oct 2013 15:16:53 +0100
From: Matt Fleming <matt@console-pimps.org>
To: linux-efi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Matt Fleming <matt.fleming@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Tony Luck <tony.luck@intel.com>,
        Leif Lindholm <leif.lindholm@linaro.org>
Subject: Re: [PATCH 1/2] efi: Add asm-generic/efi.h for non-x86
Message-ID: <20131017141653.GJ10834@console-pimps.org>
References: <1382012355-8846-1-git-send-email-matt@console-pimps.org>
 <1382012355-8846-2-git-send-email-matt@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1382012355-8846-2-git-send-email-matt@console-pimps.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Oct, at 01:19:14PM, Matt Fleming wrote:
> From: Matt Fleming <matt.fleming@intel.com>
> 
> From the #ifdef CONFIG_X86 in linux/efi.h it's clear we need a place to
> declare functions that are implemented differently for each
> architecture.
> 
> Since it's only x86 that needs to do special things, add a generic EFI
> header file that can be used by everyone else and move the x86-specific
> stuff to arch/x86/include/asm/efi.h.
> 
> Because the asm files are now included from linux/efi.h directly, this
> change means we no longer have to include the asm file explicitly from C
> files, allowing us to delete quite a few #include lines.
> 
> Cc: H. Peter Anvin <hpa@zytor.com>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Tony Luck <tony.luck@intel.com>
> Cc: Leif Lindholm <leif.lindholm@linaro.org>
> Signed-off-by: Matt Fleming <matt.fleming@intel.com>
> ---

[...]

> diff --git a/include/asm-generic/efi.h b/include/asm-generic/efi.h
> new file mode 100644
> index 0000000..8a31713
> --- /dev/null
> +++ b/include/asm-generic/efi.h
> @@ -0,0 +1,17 @@
> +#ifndef _ASM_GENERIC_EFI_H
> +#define _ASM_GENERIC_EFI_H
> +
> +static inline void efi_late_init(void) {}
> +static inline void efi_free_boot_services(void) {}
> +
> +static inline efi_status_t efi_query_variable_store(u32 attributes, unsigned long size)
> +{
> +	return EFI_SUCCESS;
> +}
> +
> +static inline int efi_enabled(int facility)
> +{
> +	return IS_ENABLED(CONFIG_EFI);
> +}
> +
> +#endif /* _ASM_GENERIC_EFI_H */

After reading Leif's arm runtime patches this patch obviously doesn't
make much sense. I'll work on something better.

-- 
Matt Fleming, Intel Open Source Technology Center
