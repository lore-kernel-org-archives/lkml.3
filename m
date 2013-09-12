Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756541Ab3ILUJW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 16:09:22 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39584 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754161Ab3ILUJU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 16:09:20 -0400
Message-ID: <52321F0B.4070609@zytor.com>
Date: Thu, 12 Sep 2013 13:07:39 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Mark Salter <msalter@redhat.com>
CC: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org, rth@twiddle.net,
        vgupta@synopsys.com, linux@arm.linux.org.uk, tony.luck@intel.com,
        geert@linux-m68k.org, monstr@monstr.eu, ralf@linux-mips.org,
        jejb@parisc-linux.org, benh@kernel.crashing.org, lethal@linux-sh.org,
        davem@davemloft.net, cmetcalf@tilera.com, gxt@mprc.pku.edu.cn,
        tglx@linutronix.de, mingo@redhat.com
Subject: Re: [PATCH] Kconfig cleanup (PARPORT_PC dependencies)
References: <1379012038-31764-1-git-send-email-msalter@redhat.com>
In-Reply-To: <1379012038-31764-1-git-send-email-msalter@redhat.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/12/2013 11:53 AM, Mark Salter wrote:
>  
> diff --git a/drivers/parport/Kconfig b/drivers/parport/Kconfig
> index 70694ce..fa005a9 100644
> --- a/drivers/parport/Kconfig
> +++ b/drivers/parport/Kconfig
> @@ -35,9 +35,7 @@ if PARPORT
>  
>  config PARPORT_PC
>  	tristate "PC-style hardware"
> -	depends on (!SPARC64 || PCI) && !SPARC32 && !M32R && !FRV && !S390 && \
> -		(!M68K || ISA) && !MN10300 && !AVR32 && !BLACKFIN && \
> -		!XTENSA && !CRIS && !H8300
> +	depends on ARCH_MAY_HAVE_PC_PARPORT
>  
>  	---help---
>  	  You should say Y here if you have a PC-style parallel port. All
> 

I'm somewhat astonished that this driver is that problematic.  It is
really just a very basic PIO interface, at least in the absence of EPP/ECP.

It is, of course, also largely a dead interface at this point so it
probably doesn't matter.

	-hpa

