Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752212AbaKQLPL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 06:15:11 -0500
Received: from pepin.polanet.pl ([193.34.52.2]:54564 "EHLO pepin.polanet.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751899AbaKQLPH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 06:15:07 -0500
Date: Mon, 17 Nov 2014 12:15:04 +0100
From: Tomasz Pala <gotar@polanet.pl>
To: Borislav Petkov <bp@alien8.de>
Cc: linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] amd64_edac: Build module on x86-32
Message-ID: <20141117111504.GA16737@polanet.pl>
References: <20141102102212.GA7034@polanet.pl>
 <20141102103300.GB5229@pd.tnic>
 <20141102121139.GA7000@polanet.pl>
 <20141102123538.GE5229@pd.tnic>
 <20141102140839.GA27342@polanet.pl>
 <20141103105508.GB27384@pd.tnic>
 <20141105120324.GB3467@polanet.pl>
 <20141105145603.GE5245@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
In-Reply-To: <20141105145603.GE5245@pd.tnic>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 05, 2014 at 15:56:03 +0100, Borislav Petkov wrote:

>> There's not much of if related (system is running 3.14.4):
> 
> CONFIG_EDAC_DEBUG gives additional debugging output and this is without
> it but it doesn't matter - I see you have a K8 box.

Oh, I've misread the 'DEBUG' part. Unfortunately I've got only K8s to
test.

> Just FYI though, one serious advantage of 64-bit is that gets orders of
> magnitude more testing than 32-bit so if you still are contemplating a
> 64-bit switch someday, remember that fact. :)

Yes, I'm aware of this and won't put 32-bit on new pieces of hardware.
Well, it has always been a pain to support Old, Running, Important Systems;)

>> -         the AMD64 families of memory controllers (K8 and F10h)
>> +         the AMD64 families of memory controllers, everything >= K8.
>> 
>> "everything >= K8" mislead me.
> 
> Ok, it is supposed to say, on everything K8 and later. K8 is what you
> have. What would make it more understandable?

"K8, K10 and everything >= 15h"? To emphase there is a gap? Dunno...

> So here's an updated version of your patch:

That looks fine, thank you for your assistance and patience!

regards,

> ---
> From: Tomasz Pala <gotar@polanet.pl>
> Subject: [PATCH] amd64_edac: Build module on x86-32
> 
> By popular demand, enable amd64_edac on 32-bit too.
> 
> Boris:
>  - update Kconfig text.
>  - add a warning on load which states that 32-bit configurations are unsupported.
> 
> Signed-off-by: Tomasz Pala <gotar@polanet.pl>
> Link: http://lkml.kernel.org/r/20141102102212.GA7034@polanet.pl
> Signed-off-by: Borislav Petkov <bp@suse.de>
> ---
>  drivers/edac/Kconfig      | 6 +++---
>  drivers/edac/amd64_edac.c | 5 +++++
>  2 files changed, 8 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/edac/Kconfig b/drivers/edac/Kconfig
> index 7072c2892d63..4316c9e955b3 100644
> --- a/drivers/edac/Kconfig
> +++ b/drivers/edac/Kconfig
> @@ -105,11 +105,11 @@ config EDAC_GHES
>  	  In doubt, say 'Y'.
>  
>  config EDAC_AMD64
> -	tristate "AMD64 (Opteron, Athlon64) K8, F10h"
> -	depends on EDAC_MM_EDAC && AMD_NB && X86_64 && EDAC_DECODE_MCE
> +	tristate "AMD64 (Opteron, Athlon64)"
> +	depends on EDAC_MM_EDAC && AMD_NB && EDAC_DECODE_MCE
>  	help
>  	  Support for error detection and correction of DRAM ECC errors on
> -	  the AMD64 families of memory controllers (K8 and F10h)
> +	  the AMD64 families (>= K8) of memory controllers.
>  
>  config EDAC_AMD64_ERROR_INJECTION
>  	bool "Sysfs HW Error injection facilities"
> diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
> index 1a1d7c43a20f..17638d7cf5c2 100644
> --- a/drivers/edac/amd64_edac.c
> +++ b/drivers/edac/amd64_edac.c
> @@ -3035,6 +3035,11 @@ static int __init amd64_edac_init(void)
>  		goto err_no_instances;
>  
>  	setup_pci_device();
> +
> +#ifdef CONFIG_X86_32
> +	amd64_err("%s on 32-bit is unsupported. USE AT YOUR OWN RISK!\n", EDAC_MOD_STR);
> +#endif
> +
>  	return 0;
>  
>  err_no_instances:

-- 
Tomasz Pala <gotar@pld-linux.org>
