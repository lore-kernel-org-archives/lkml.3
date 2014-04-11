Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754712AbaDKSDa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 14:03:30 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45877 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753288AbaDKSD3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 14:03:29 -0400
Message-ID: <53482E61.8050606@zytor.com>
Date: Fri, 11 Apr 2014 11:03:13 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Thomas_B=E4chler?= <thomas@archlinux.org>,
        Matt Fleming <matt.fleming@intel.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] efi: Clarify Kconfig help for EFI_MIXED
References: <1397239154-30121-1-git-send-email-thomas@archlinux.org>
In-Reply-To: <1397239154-30121-1-git-send-email-thomas@archlinux.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/11/2014 10:59 AM, Thomas Bächler wrote:
> EFI stub support is only missing for a 64 bit kernel on 32-bit firmware,
> on 64-bit kernels, EFI stub works as usual.
> ---
> 
> Matt, I don't know if this help was intentionally discouraging,
> however, out of curiosity, I tested this with ovmf, and the
> kernel boots fine on 64-bit firmware bit with EFI stub, and on
> 32-bit firmware using efilinux.
> 
> Documenting this properly is important for distribution kernels.
> We would want to support this on Arch, but not if it means
> introducing a regression for EFI stub users.
> 
>  arch/x86/Kconfig | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index 5b8ec0f..2bbbbb9 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -1529,8 +1529,8 @@ config EFI_MIXED
>  	   mode.
>  
>  	   Note that it is not possible to boot a mixed-mode enabled
> -	   kernel via the EFI boot stub - a bootloader that supports
> -	   the EFI handover protocol must be used.
> +	   kernel via the EFI boot stub on 32-bit firmware - a bootloader
> +	   that supports the EFI handover protocol must be used.
>  
>  	   If unsure, say N.
>  

Right, it is really that it is not possible to boot a mixed-mode kernel
on its non-native firmware using the stub, since the stub itself can
only be one way or the other.

	-hpa


