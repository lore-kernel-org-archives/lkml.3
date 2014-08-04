Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753284AbaHDXGi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 19:06:38 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56229 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752730AbaHDXGh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 19:06:37 -0400
Message-ID: <53E011D9.5040908@zytor.com>
Date: Mon, 04 Aug 2014 16:06:01 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Matt Fleming <matt@console-pimps.org>
CC: Ingo Molnar <mingo@kernel.org>, linux-efi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Matt Fleming <matt.fleming@intel.com>,
        Borislav Petkov <bp@suse.de>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86/efi: Fix 3DNow optimization build failure in EFI
 stub
References: <1407192735-26368-1-git-send-email-matt@console-pimps.org>
In-Reply-To: <1407192735-26368-1-git-send-email-matt@console-pimps.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/04/2014 03:52 PM, Matt Fleming wrote:
> 
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index 801ed36c2e49..fcad2e15e92a 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -1520,7 +1520,7 @@ config X86_SMAP
>  
>  config EFI
>  	bool "EFI runtime service support"
> -	depends on ACPI
> +	depends on ACPI && !X86_USE_3DNOW
>  	select UCS2_STRING
>  	select EFI_RUNTIME_WRAPPERS
>  	---help---
> 

As we discussed over IRC, should be EFI_STUB not EFI.  Once that is fixed:

Acked-by: H. Peter Anvin <hpa@linux.intel.com>

... in case Ingo or Thomas grabs it before I do.

	-hpa

