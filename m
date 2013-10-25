Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754944Ab3JYNfl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 09:35:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14991 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754140Ab3JYNfi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 09:35:38 -0400
Message-ID: <1382708133.1768.93.camel@deneb.redhat.com>
Subject: Re: linux-next: manual merge of the h8300-remove tree
From: Mark Salter <msalter@redhat.com>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Guenter Roeck <linux@roeck-us.net>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Fri, 25 Oct 2013 09:35:33 -0400
In-Reply-To: <1382706224-8859-2-git-send-email-treding@nvidia.com>
References: <1382632289-18523-1-git-send-email-treding@nvidia.com>
	 <1382706224-8859-1-git-send-email-treding@nvidia.com>
	 <1382706224-8859-2-git-send-email-treding@nvidia.com>
Organization: Red Hat, Inc
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-10-25 at 15:03 +0200, Thierry Reding wrote:
> Today's linux-next tree of the h8300-remove tree got a conflict in
> 
> 	drivers/parport/Kconfig
> 
> caused by commits e9783b0 (Revert "drivers: parport: Kconfig: exclude h8300
> for PARPORT_PC") and d90c3eb (Kconfig cleanup (PARPORT_PC dependencies)).
> 
> I fixed it up (see below). Please verify that the resolution looks good.
> 
> Thanks,
> Thierry
> ---
> diff --cc drivers/parport/Kconfig
> index f536685,dc82ef0..2225237
> --- a/drivers/parport/Kconfig
> +++ b/drivers/parport/Kconfig
> @@@ -41,8 -35,10 +41,7 @@@ if PARPOR
>   
>   config PARPORT_PC
>   	tristate "PC-style hardware"
>  -	depends on (!SPARC64 || PCI) && !SPARC32 && !M32R && !FRV && !S390 && \
>  -		(!M68K || ISA) && !MN10300 && !AVR32 && !BLACKFIN && \
>  -		!XTENSA && !CRIS
>  -
>  +	depends on ARCH_MIGHT_HAVE_PC_PARPORT
> - 
>   	---help---
>   	  You should say Y here if you have a PC-style parallel port. All
>   	  IBM PC compatible computers and some Alphas have PC-style

Yes, that looks right. With the PC_PARPORT cleanup, h8300 doesn't need
to exclude itself. It is now excluded by default.


