Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755383AbaAWVhE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 16:37:04 -0500
Received: from mail-bk0-f44.google.com ([209.85.214.44]:36980 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751537AbaAWVhD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 16:37:03 -0500
Date: Thu, 23 Jan 2014 13:36:55 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Mike Waychison <mikew@google.com>
cc: gregkh@linuxfoundation.org, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] firmware/google: drop 'select EFI' to avoid recursive
 dependency
In-Reply-To: <1390473588-23367-1-git-send-email-ard.biesheuvel@linaro.org>
Message-ID: <alpine.DEB.2.02.1401231334540.7313@chino.kir.corp.google.com>
References: <1390473588-23367-1-git-send-email-ard.biesheuvel@linaro.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Jan 2014, Ard Biesheuvel wrote:

> The GOOGLE_SMI Kconfig symbol depends on DMI and selects EFI. This
> causes problems on other archs when introducing DMI support that
> depends on EFI, as it results in a recursive dependency:
> 
> arch/arm/Kconfig:1845:error: recursive dependency detected!
> arch/arm/Kconfig:1845:	symbol DMI depends on EFI
> 
> Fix by changing the 'select EFI' to a 'depends on EFI'.
> 
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> ---
>  drivers/firmware/google/Kconfig | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/firmware/google/Kconfig b/drivers/firmware/google/Kconfig
> index 2f21b0bfe653..29c8cdda82a1 100644
> --- a/drivers/firmware/google/Kconfig
> +++ b/drivers/firmware/google/Kconfig
> @@ -12,8 +12,7 @@ menu "Google Firmware Drivers"
>  
>  config GOOGLE_SMI
>  	tristate "SMI interface for Google platforms"
> -	depends on ACPI && DMI
> -	select EFI
> +	depends on ACPI && DMI && EFI
>  	select EFI_VARS
>  	help
>  	  Say Y here if you want to enable SMI callbacks for Google

Adding Mike Waychison <mikew@google.com> to the cc since this is his code, 
but it looks good to me.

$ ./scripts/get_maintainer.pl -f drivers/firmware/google/Kconfig
linux-kernel@vger.kernel.org (open list)

I wonder why he's not listed as a recipient for patches from 
get_maintainer.pl since it's clearly obvious he wrote the entire file.
