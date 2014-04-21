Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754589AbaDUU3I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 16:29:08 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:51054 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754531AbaDUU2k convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 16:28:40 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Semen Protsenko <semen.protsenko@linaro.org>
Cc: Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] acpi: respect const qualifier
Date: Mon, 21 Apr 2014 22:44:59 +0200
Message-ID: <3334700.hi79274ifW@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.14.0-rc7+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1397750006-17463-1-git-send-email-semen.protsenko@linaro.org>
References: <1397750006-17463-1-git-send-email-semen.protsenko@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, April 17, 2014 06:53:26 PM Semen Protsenko wrote:
> This patch fixes next warning:
> 
> <------------------------------- cut here --------------------------------->
> drivers/acpi/property.c: In function ‘acpi_free_properties’:
> drivers/acpi/property.c:35:2: warning: passing argument 1 of ‘acpi_os_free’
>                               discards ‘const’ qualifier from pointer
>                               target type [enabled by default]
> 
>   ACPI_FREE(adev->properties);
> <------------------------------- cut here --------------------------------->

This is not a mainline kernel problem, surely?

> 
> The problem is next:
> 
>  - acpi_free_properties() calls ACPI_FREE(), passing "const *"
>    parameter to it
>  - ACPI_FREE() is macro for acpi_os_free()
>  - acpi_os_free() takes "void *" parameter
>  - acpi_os_free() calls kfree()
>  - but kfree() requires "const void *" parameter
> 
> So acpi_os_free() should require "const void *" parameter as well.
> 
> Signed-off-by: Semen Protsenko <semen.protsenko@linaro.org>
> ---
>  include/acpi/platform/aclinux.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/acpi/platform/aclinux.h b/include/acpi/platform/aclinux.h
> index 93c55ed..c6fa763 100644
> --- a/include/acpi/platform/aclinux.h
> +++ b/include/acpi/platform/aclinux.h
> @@ -174,7 +174,7 @@ static inline void *acpi_os_allocate_zeroed(acpi_size size)
>  #define ACPI_USE_ALTERNATE_PROTOTYPE_acpi_os_allocate_zeroed
>  #define USE_NATIVE_ALLOCATE_ZEROED
>  
> -static inline void acpi_os_free(void *memory)
> +static inline void acpi_os_free(const void *memory)
>  {
>  	kfree(memory);
>  }
> 

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
